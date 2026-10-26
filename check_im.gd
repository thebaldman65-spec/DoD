# BATCH IM — THE RUIN RUNG, AND THE PICKER's REMAINDER.
#
#   §1   THE RUIN RUNG: TWO BANDS A RUNG, AND NO FALLBACK. Every rung names the severity band its safe slot is dealt
#        from and the band its gambles are; every band is non-empty over the table and the gambles can always be
#        three distinct with the safe pick; `roll_offer` reads both bands and falls back to nothing. Measured at EP's
#        sample through the real roll: Wanderer and Warden dealt offer for offer as the floor dealt them (the
#        control), Ruin's mean above Warden's, Ruin's safe slot never below Warden's safe slot's top, the merchant at
#        the rung's mildest dealt severity and paid nowhere else (re-pointed at IN §2: severity 1 until IN); the
#        glossary's three entries read against the bands. (Re-pointed at IN §1: the table Wanderer and Warden deal from
#        is the twenty below Ruin's severity-5 gambles, and IM's reference model deals over those twenty.)
#   §2   THE FOUR TEXTS SAY STRIKE DAMAGE: the tree's More Damage Dealt and Less Damage Taken, the Dragonbone Idol and
#        the Horn of the First War — each figure read off its own field, both fields read in the strike loop alone,
#        and each text measured at the surfaces that draw it.
#   §3a  THE UPGRADED EXECUTE TESTS EACH BODY's OWN PRICE: under Warded, with his Rage between the list and the ward's
#        price, the pick offers the Broken body alone; the list price is read nowhere in the pool.
#   §3b  THE PICKER's REMAINDER: the seven cards whose pick can produce nothing refuse those bodies with a reason, and
#        every one of the seven is cast on a refused body (nothing moves) and on an offered one (something does), so
#        the predicate is shown to be its handler's; the door refuses a card whose pick offers nobody, and says why;
#        the bot's aims ask the pool; the reach walk names Execute and the seven, and Hunt is offered.
#   §0   The pouch's rule in the items entry; the charmed Daze's comment; the `st/b` column named for what it counts and
#        its printed header unmoved; the three instrument rules this batch records.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 measures the offer, not a run — how often a Ruin party takes a harsh
# bargain is play's. §3b drives each card on boards this gate lays out with the status door; a card whose handler grows
# a branch the board does not exercise is caught only if that branch reads what `_pick_dud` reads. The bot's three
# re-pointed aims are read off the source and driven where the hook can see the card.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_im.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}

# §3b — THE SEVEN, by special, with the class seat that holds each (the board's lineage for its engine).
const SEVEN := {"firedraw": "Firedraw", "transference": "Transference", "cryoclasm": "Cryoclasm",
	"cull": "Cull", "requiem": "Requiem", "funeral_pyre": "Funeral Pyre", "pyre_wake": "Pyre Wake"}
const SEAT_OF := {"firedraw": "mage", "funeral_pyre": "mage", "pyre_wake": "mage", "cryoclasm": "mage",
	"transference": "cleric", "requiem": "cleric", "cull": "hunter"}
# §2 — the four texts: [kind, id, the field the figure is read off].
const STRIKE_TEXTS := [["talent", "tn_damage", "dmg_bonus"], ["talent", "tn_guard", "dmg_taken_bonus"],
	["relic", "dragonbone", "hero_attack_mult"], ["relic", "warhorn", "hero_attack_mult"]]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IM — THE RUIN RUNG, AND THE PICKER's REMAINDER")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s1_the_bands()
	_s1_the_sample()
	_s1_the_words()
	_s2_strike_texts()
	await _s3a_warded_price()
	await _s3b_the_seven()
	await _s3b_the_door()
	await _s3b_the_bot()
	await _s3b_the_reach()
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


func _board(specs: Array, over: Dictionary) -> Node:
	var s: Node = await Gate.spawn(self, specs, {"deterministic": true, "party": over})
	Engine.time_scale = 50.0
	return s


func _clear(scene: Node) -> void:
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


func _slot(scene: Node, e: BattleUnit) -> String:
	if e == null:
		return "nobody"
	return "slot %d (%s)" % [(scene.get("enemies") as Array).find(e), e.unit_name]


func _slots(scene: Node, bodies: Array) -> String:
	return str(bodies.map(func(e): return (scene.get("enemies") as Array).find(e)))


func _card(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if a.display_name == name:
			return a
	return null


# Every enemy at one size, whole, unbroken and clean, and no prison standing, so a shape laid after it is the only
# thing on the board.
func _calm(scene: Node, max_hp: int) -> void:
	(scene.get("_holds") as Array).clear()
	for e in scene.get("enemies"):
		var eu: BattleUnit = e
		if eu.dead:
			continue
		eu.max_hp = max_hp
		eu.hp = max_hp
		eu.pressure = 0
		eu.broken = false
		for st in eu.statuses.duplicate():
			eu.remove_status(String(st.id))


# The button the abilities list draws for a card, built by the list's own builder, and its hover read.
func _button_tip(scene: Node, u: BattleUnit, ab: Ability) -> Dictionary:
	var pop := PopupPanel.new()
	scene.add_child(pop)
	var b: Button = scene.call("_ability_popup_button", u, ab, pop, -1)
	var out := {"tip": String(b.tooltip_text), "disabled": b.disabled}
	b.free()
	pop.free()
	return out


# Everything a cast could move on the board: every body's health and its statuses, and the prisons standing. The
# caster's own resource, cooldowns and ledgers are not in it — every cast pays those, whatever it does to the pick.
func _snap(scene: Node) -> String:
	var parts: Array = []
	for u in (scene.get("heroes") as Array) + (scene.get("enemies") as Array):
		var bu: BattleUnit = u
		var sts: Array = []
		for st in bu.statuses:
			sts.append("%s:%s:%s:%s" % [st.id, st.get("turns", 0), st.get("power", 0), st.get("stacks", 0)])
		sts.sort()
		parts.append("%s hp%d %s [%s]" % [bu.unit_name, bu.hp, "dead" if bu.dead else "up", ",".join(sts)])
	parts.append("holds %s" % _slots(scene, scene.get("_holds") as Array))
	return "\n".join(parts)


# ── §1 — THE RUIN RUNG: TWO BANDS A RUNG, AND NO FALLBACK ───────────────────

func _table_sevs() -> Array:
	var out: Array = []
	for id in _run.MODIFIERS:
		# RE-POINTED AT IX §3: the table a rung deals from is the graded deck — a modifier with no severity stands in no band.
		if int(_run.modifier_severity(String(id))) >= 1:
			out.append(int(_run.modifier_severity(String(id))))
	return out


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


func _s1_the_bands() -> void:
	print("\n§1 — the Ruin rung: two bands a rung, and no fallback")
	var sevs := _table_sevs()
	var top := 0
	var bottom := 99
	for sv in sevs:
		top = maxi(top, int(sv))
		bottom = mini(bottom, int(sv))
	var rungs: Array = _run.DIFFICULTY_ORDER
	for d in rungs:
		var def: Dictionary = _run.DIFFICULTIES[d]
		ok(def.has("safe_band") and def.has("gamble_band") and not def.has("severity_floor"),
			"§1: %s carries %s — want `safe_band` and `gamble_band`, and no `severity_floor` (the one field that did two jobs)" % [
				d, str(def.keys())])
		if not (def.has("safe_band") and def.has("gamble_band")):
			continue
		var sb: Array = def["safe_band"]
		var gb: Array = def["gamble_band"]
		var safe := _band_members(sb)
		var gam := _band_members(gb)
		ok(sb.size() == 2 and gb.size() == 2 and int(sb[0]) <= int(sb[1]) and int(gb[0]) <= int(gb[1]),
			"§1: %s's bands are not [lowest, highest] pairs: safe %s, gambles %s" % [d, str(sb), str(gb)])
		# AN EMPTY BAND IS THE SATURATION DEFECT WEARING A NEW FIELD NAME: the safe slot needs one modifier, and the two
		# gambles need two that are not the safe one, whatever the safe slot took.
		var overlap := safe.filter(func(i): return gam.has(i)).size()
		ok(not safe.is_empty(), "§1: %s's safe band %s holds no modifier of the table" % [d, str(sb)])
		ok(gam.size() - (1 if overlap > 0 else 0) >= 2,
			"§1: %s's gamble band %s holds %d modifiers, %d shared with the safe band — two gambles cannot always be dealt" % [
				d, str(gb), gam.size(), overlap])
		print("    %-8s safe %s (%d modifiers, mean %.3f)   gambles %s (%d, mean %.3f)   arithmetic %.2f" % [
			d, str(sb), safe.size(), _mean_sev(safe), str(gb), gam.size(), _mean_sev(gam),
			(_mean_sev(safe) + 2.0 * _mean_sev(gam)) / 3.0])
	# CONDITION 2: RUIN's SAFE SLOT NEVER DRAWS BELOW WARDEN's SAFE SLOT's TOP — read in the data, as a relation.
	var ruin_sb: Array = (_run.DIFFICULTIES["ruin"] as Dictionary).get("safe_band", [0, 0])
	var ward_sb: Array = (_run.DIFFICULTIES["warden"] as Dictionary).get("safe_band", [0, 0])
	ok(int(ruin_sb[0]) >= int(ward_sb[1]),
		"§1: Ruin's safe band opens at severity %d, below the top of Warden's safe band (%d) — a mild option is back" % [
			int(ruin_sb[0]), int(ward_sb[1])])
	# THE FIRST TWO RUNGS ARE THE FLOOR's OWN SPLIT: the safe band runs from the table's bottom to the old floor and the
	# gambles from the next severity to the top, so their offers are dealt exactly as before (the sample below proves it).
	# BATCH IN §1 — THE TABLE THEY DEAL FROM IS THE TWENTY: Ruin's gambles stand above it at severity 5, which no
	# Wanderer or Warden band reaches, so the split is of the severities below Ruin's gamble band.
	var top20 := int(((_run.DIFFICULTIES["ruin"] as Dictionary).get("gamble_band", [top + 1, top + 1]) as Array)[0]) - 1
	for d2 in ["wanderer", "warden"]:
		var sb2: Array = (_run.DIFFICULTIES[d2] as Dictionary).get("safe_band", [0, 0])
		var gb2: Array = (_run.DIFFICULTIES[d2] as Dictionary).get("gamble_band", [0, 0])
		ok(int(sb2[0]) == bottom and int(gb2[0]) == int(sb2[1]) + 1 and int(gb2[1]) == top20,
			"§1: %s's bands %s / %s are not a floor's split of the table they deal from (%d..%d) — its offers would move" % [
				d2, str(sb2), str(gb2), bottom, top20])
	# CONDITION 4: NO FALLBACK REMAINS — the roll reads both bands, draws the safe slot once and never draws from the
	# safe band again.
	var body := _body("scripts/run_state.gd", "roll_offer")
	ok(body.contains("difficulty_def()[\"safe_band\"]") and body.contains("difficulty_def()[\"gamble_band\"]"),
		"§1: `roll_offer` does not read both of the rung's bands")
	ok(body.count("safe.pop_front()") == 1 and body.count(".pop_front()") == 1,
		"§1: `roll_offer` draws %d times off a band's front, want the safe slot's one draw — a second is the fallback back" % body.count(".pop_front()"))
	var floor_reads := 0
	for f in ["scripts/run_state.gd", "scripts/battle.gd", "scripts/map_screen.gd", "scripts/draft_screen.gd",
			"scripts/run_sim.gd", "scripts/offer_screen.gd"]:
		if FileAccess.file_exists("res://" + f):
			floor_reads += _src(f).count("severity_floor")
	ok(floor_reads == 0, "§1: the game's scripts read `severity_floor` %d times — the field is gone" % floor_reads)


# The roll as the floor dealt it until IM — a REFERENCE MODEL, kept here on purpose: it is the control the bands are read
# against, so a rung whose bands are the floor's own split must be dealt the same offer from the same dice.
func _floor_offer(floor_sev: int) -> Array:
	var low: Array = []
	var rest: Array = []
	# BATCH IN §1 — IM's table was the twenty: Ruin's severity-5 four stand above every band this model deals.
	var top20 := int(((_run.DIFFICULTIES["ruin"] as Dictionary)["gamble_band"] as Array)[0]) - 1
	for id in _run.MODIFIERS:
		# RE-POINTED AT IX §3: and a modifier with no severity is in no band, so the floor never split it either.
		if int(_run.modifier_severity(String(id))) > top20 or int(_run.modifier_severity(String(id))) < 1:
			continue
		if int(_run.modifier_severity(String(id))) <= floor_sev:
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
	while picked.size() < 3 and not low.is_empty():
		picked.append(low.pop_front())
	var offer: Array = []
	for id in picked:
		var sev := int(_run.modifier_severity(String(id)))
		# BATCH IN §2 — the merchant stood behind severity 1's gold in IM's table; the model keeps it there.
		var choices: Array = (_run.REWARDS.get(sev, _run.REWARDS[1]) as Array).duplicate()
		if sev == 1:
			choices.append({"kind": "shop"})
		if _run.shop_gated(int(_run.slot_idx) + 1):
			choices = choices.filter(func(r): return String(r.get("kind", "")) != "shop")
		offer.append({"modifier": String(id), "reward": (choices.pick_random() as Dictionary).duplicate()})
	offer.shuffle()
	return offer


func _s1_the_sample() -> void:
	print("\n§1 — EP's sample: 400 offers a rung through the real `roll_offer`, seeded, past the shop gate")
	var was := String(_run.difficulty)
	var was_slot := int(_run.slot_idx)
	_run.slot_idx = int(_run.SHOP_GATE_NODES) + 4
	var means := {}
	var mins := {}
	var shops := {}
	for d in ["wanderer", "warden", "ruin"]:
		_run.difficulty = d
		seed(4004)
		var dealt: Array = []
		for _i in 400:
			dealt.append(_run.roll_offer())
		var dist := {1: 0, 2: 0, 3: 0, 4: 0}
		var sum := 0
		var n := 0
		var lo := 99
		var sh := 0
		var at_shop: Array = []
		for offer in dealt:
			for opt in offer:
				var sev := int(_run.modifier_severity(String(opt["modifier"])))
				dist[sev] = int(dist.get(sev, 0)) + 1
				sum += sev
				n += 1
				lo = mini(lo, sev)
				if String((opt["reward"] as Dictionary).get("kind", "")) == "shop":
					sh += 1
					at_shop.append(sev)
		ok(n == 1200, "§1: %s dealt %d options over 400 offers, want 1,200 — an offer came short" % [d, n])
		means[d] = float(sum) / maxf(float(n), 1.0)
		mins[d] = lo
		shops[d] = sh
		ok(at_shop.all(func(v): return int(v) == int(_run.mildest_dealt_severity())),
			"§1: %s paid the merchant at severities %s, want its mildest dealt, %d, alone (IN §2)" % [
				d, str(at_shop), _run.mildest_dealt_severity()])
		print("    %-8s mean severity %.2f over %d options — by severity %d / %d / %d / %d — the merchant on %d" % [
			d, means[d], n, dist[1], dist[2], dist[3], dist[4], sh])
		# THE CONTROL: a rung whose bands are the floor's split is dealt the floor's own offer, offer for offer.
		if d != "ruin":
			var fl := int(((_run.DIFFICULTIES[d] as Dictionary).get("safe_band", [0, 0]) as Array)[1])
			seed(4004)
			var same := 0
			var first_diff := -1
			for i in 400:
				var o2 := _floor_offer(fl)
				if str(o2) == str(dealt[i]):
					same += 1
				elif first_diff < 0:
					first_diff = i
			ok(same == 400, "§1: %s's offers moved — %d of 400 dealt as the floor dealt them (first to differ: #%d)" % [d, same, first_diff])
			print("             dealt as the floor dealt it: %d of 400 offers" % same)
	_run.difficulty = was
	_run.slot_idx = was_slot
	# CONDITION 1 AND THE STEP IT BUYS: Ruin's mean above Warden's, and the gap read off the bands, not typed.
	ok(float(means["ruin"]) > float(means["warden"]) and float(means["warden"]) > float(means["wanderer"]),
		"§1: the rungs' means read %.2f / %.2f / %.2f — Ruin's bargains are not the harshest" % [
			means["wanderer"], means["warden"], means["ruin"]])
	var ruin_def: Dictionary = _run.DIFFICULTIES["ruin"]
	var want := (_mean_sev(_band_members(ruin_def.get("safe_band", [0, 0]))) \
		+ 2.0 * _mean_sev(_band_members(ruin_def.get("gamble_band", [0, 0])))) / 3.0
	ok(absf(float(means["ruin"]) - want) < 0.10,
		"§1: Ruin's sample reads %.2f against its bands' arithmetic %.2f" % [means["ruin"], want])
	# CONDITION 2, IN THE SAMPLE: no Ruin option below the top of Warden's safe band.
	var ward_top := int(((_run.DIFFICULTIES["warden"] as Dictionary).get("safe_band", [0, 0]) as Array)[1])
	ok(int(mins["ruin"]) >= ward_top,
		"§1: Ruin dealt a severity-%d option, below the top of Warden's safe band (%d)" % [mins["ruin"], ward_top])
	# THE MERCHANT IS NO SEVERITY's ROW (IN §2, re-pointed from HW §2's severity 1): `rewards_for` puts it behind the
	# gold of the rung's mildest dealt severity, and the table itself holds it nowhere.
	var shop_at: Array = []
	for sv2 in _run.REWARDS:
		for r in _run.REWARDS[sv2]:
			if String(r.get("kind", "")) == "shop":
				shop_at.append(int(sv2))
	ok(shop_at.is_empty() and _body("scripts/run_state.gd", "rewards_for").contains("mildest_dealt_severity()"),
		"§1: the table holds the merchant at severity %s, or `rewards_for` does not read the mildest dealt (IN §2)" % str(shop_at))
	print("    Ruin above Warden by %.2f — %.2f of a full step; the merchant on a Ruin bargain: %d" % [
		float(means["ruin"]) - float(means["warden"]), float(means["ruin"]) - float(means["warden"]), shops["ruin"]])


# THE GLOSSARY READ AGAINST THE BANDS (IL §2d's discipline): what each entry says the bargain does.
func _s1_the_words() -> void:
	print("\n§1 — the glossary and the rungs' own words, read against the bands")
	var sev_e: String = String(Glossary.entry("severity").get("long", ""))
	var raw_sev := ""
	for e in JSON.parse_string(FileAccess.get_file_as_string("res://data/glossary.json")):
		if String((e as Dictionary).get("id", "")) == "severity":
			raw_sev = String((e as Dictionary).get("long", ""))
	ok(not raw_sev.contains("severity_floor") and not raw_sev.to_upper().contains("SEVERITY FLOOR"),
		"§1: the severity entry still speaks of the floor")
	var missing: Array = []
	for d in ["wanderer", "warden", "ruin"]:
		for k in ["safe_band.0", "safe_band.1", "gamble_band.0"]:
			var tok := "{=Run.DIFFICULTIES.%s.%s}" % [d, k]
			if not raw_sev.contains(tok):
				missing.append(tok)
	ok(missing.is_empty(), "§1: the severity entry does not read the bands it states: %s" % str(missing))
	# A band the entry calls ONE severity ("at N alone") is one.
	for d2 in ["warden", "ruin"]:
		var gb: Array = (_run.DIFFICULTIES[d2] as Dictionary).get("gamble_band", [0, 0])
		ok(int(gb[0]) == int(gb[1]),
			"§1: the severity entry says %s's gambles are dealt at one severity, and its band is %s" % [d2, str(gb)])
	ok(sev_e.contains("there is no mild option"), "§1: the severity entry does not say Ruin has no mild option")
	# G080L — *weighted toward the mild end* still describes the table; its reason names the rungs it is true of.
	# BATCH IN §1 — THE TWENTY ARE WHAT THE SENTENCE IS ABOUT: the entry says *the twenty are weighted toward the mild
	# end*, and Ruin's four at severity 5 are counted apart.
	var low := 0
	var high := 0
	var top_20 := int(((_run.DIFFICULTIES["ruin"] as Dictionary)["gamble_band"] as Array)[0]) - 1
	for sv in _table_sevs():
		if int(sv) > top_20:
			continue
		if int(sv) <= 2:
			low += 1
		else:
			high += 1
	var mod_e := String(Glossary.entry("modifier").get("long", ""))
	# RE-POINTED AT IX §3: the scale moves how many stand beneath Ruin's gambles, so the entry names them without a count.
	ok(low > high and mod_e.contains("They are weighted toward the mild end"),
		"§1: G080L — the modifiers beneath Ruin's gambles hold %d at severity 1-2 and %d at 3-%d; the entry says they are weighted toward the mild end: %s" % [
			low, high, top_20, mod_e.contains("They are weighted toward the mild end")])
	ok(mod_e.contains("the safe slot on Wanderer's and Warden's bargains draws from that end")
			and not mod_e.contains("the safe slot on every bargain"),
		"§1: the modifier entry still says every bargain's safe slot draws from the mild end — Ruin's does not")
	var lad_e := String(Glossary.entry("difficulty_ladder").get("long", ""))
	ok(lad_e.contains("its safe option is never mild") and not lad_e.contains("SEVERITY FLOOR"),
		"§1: the ladder entry does not say Ruin's safe option is never mild, or still names the floor")
	# R091 — *harsher bargains* — and every other rung's own words, read against the sample's order.
	var blurb_ruin := String((_run.DIFFICULTIES["ruin"] as Dictionary)["blurb"])
	ok(blurb_ruin.begins_with("Harsher bargains"), "§1: Ruin's own words no longer promise harsher bargains")
	print("    R091 *harsher bargains*: true at IM (Ruin's mean above Warden's, §1's sample); Warden's *the guaranteed mild bargain gets less mild*: its safe band %s against Wanderer's %s" % [
		str((_run.DIFFICULTIES["warden"] as Dictionary).get("safe_band", [])), str((_run.DIFFICULTIES["wanderer"] as Dictionary).get("safe_band", []))])


# ── §2 — THE FOUR TEXTS SAY STRIKE DAMAGE ───────────────────────────────────

func _s2_strike_texts() -> void:
	print("\n§2 — the tree's two and the two relics say strike damage, their figures read off their fields")
	var font: Font = ThemeDB.fallback_font
	for row in STRIKE_TEXTS:
		var kind := String(row[0])
		var id := String(row[1])
		var field := String(row[2])
		var text := ""
		var figure := 0.0
		if kind == "talent":
			var node: Dictionary = Talents.node_in_tree(Talents.TREE, id)
			text = Talents.desc_for(node, 1)
			figure = absf(float(((node.get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).get(field, 0.0))) * 100.0
		else:
			text = Relics.desc_of(id)
			figure = absf(float(((Relics.POOL[id] as Dictionary).get("hooks", {}) as Dictionary).get(field, 0.0))) * 100.0
		ok(text.contains("strike damage") and text.contains("%d%%" % int(round(figure))),
			"§2: %s reads %s — want *strike damage* and its own %d%%" % [id, JSON.stringify(text), int(round(figure))])
		ok(not text.contains("{"), "§2: %s carries an unresolved token: %s" % [id, text])
		# THE WIDTH, AT EVERY SURFACE THAT DRAWS IT: a node's tooltip (talents screen, 320 px at 12; the hero sheet's
		# tree tip, 300 px at 12), a relic's shelf panel (320 px at 14) and its draft tooltip (one line, unwrapped).
		var w12 := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
		var w14 := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		if kind == "talent":
			ok(w12 <= 300.0, "§2: %s is %.0f px at font 12 — past the hero sheet's 300-px tree tip, one line more" % [id, w12])
			print("    %-11s %-44s %3.0f px at 12 (tips 320 and 300)" % [id, text, w12])
		else:
			ok(w14 <= 320.0, "§2: %s is %.0f px at font 14 — past the shelf's 320-px panel, one line more" % [id, w14])
			print("    %-11s %-44s %3.0f px at 14 (the shelf's 320); its draft tooltip is one line" % [id, text, w14])
	# BOTH FIELDS ARE READ IN THE STRIKE LOOP ALONE — the reach the word now names — and the relic hook lands in
	# `dmg_bonus` at the spawn, which is the field the strike loop reads.
	var res_body := _body("scripts/battle.gd", "_resolve")
	var b_src := _src("scripts/battle.gd")
	var reads := {"attacker.dmg_bonus": 0, "strike_target.dmg_taken_bonus": 0}
	for k in reads:
		reads[k] = res_body.count(String(k))
	var elsewhere := 0
	for k2 in [".dmg_bonus", ".dmg_taken_bonus"]:
		elsewhere += b_src.count(String(k2)) - res_body.count(String(k2))
	ok(int(reads["attacker.dmg_bonus"]) == 1 and int(reads["strike_target.dmg_taken_bonus"]) == 1 and elsewhere == 0,
		"§2: `_resolve` reads `dmg_bonus` %d and `dmg_taken_bonus` %d times, and battle.gd %d more elsewhere — want once each, in the strike loop alone" % [
			reads["attacker.dmg_bonus"], reads["strike_target.dmg_taken_bonus"], elsewhere])
	ok(b_src.contains("cfg[\"dmg_bonus\"] = cfg.get(\"dmg_bonus\", 0.0) \\\n\t\t\t\t+ Run.relic_add(\"hero_attack_mult\")"),
		"§2: the relic hook `hero_attack_mult` no longer lands in `dmg_bonus` at the spawn")


# ── §3a — THE UPGRADED EXECUTE TESTS EACH BODY's OWN PRICE ──────────────────

func _s3a_warded_price() -> void:
	print("\n§3a — under Warded the upgraded Execute's pick is the bodies he can pay for")
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"],
		{0: {"engines": [], "bm_abilities": ["Execute"], "bm_equipped": ["Execute"]}})
	var u := _hero(s, "warrior") if s != null else null
	var ex := _card(u, "Execute") if u != null else null
	var foes := _foes(s) if s != null else []
	ok(u != null and ex != null and foes.size() >= 3, "§3a: the board seats a Warrior holding a drafted Execute against three")
	if u == null or ex == null or foes.size() < 3:
		await _clear(s)
		return
	_calm(s, 10000)
	u.execute_upgraded = 1
	(foes[0] as BattleUnit).hp = int(round(10000.0 * maxf(float(s.call("_execute_line", u)) - 0.05, 0.01)))
	(foes[1] as BattleUnit).hp = 9700
	(foes[1] as BattleUnit).broken = true
	u.cooldowns.clear()
	# THE WARD: every cost 1.25 times the list, and his Rage between the two.
	var was_mult := float(u.mod_cost_mult)
	u.mod_cost_mult = 1.25
	u.resource = ex.cost
	var warded_price := int(s.call("_eff_cost", u, ex, foes[0]))
	var pool: Array = s.call("_enemy_pick_pool", u, ex, foes)
	var refusals: Dictionary = s.call("_target_refusals", u, ex, pool)
	ok(warded_price > u.resource, "§3a: the ward prices slot 0 at %d against his %d Rage — the board does not hold the defect's state" % [
		warded_price, u.resource])
	ok(pool == [foes[1]], "§3a: under Warded with %d Rage (the list %d, the ward's %d) the pick offers %s — want slot 1, the Broken one, alone" % [
		u.resource, ex.cost, warded_price, _slots(s, pool)])
	ok(String(refusals.get(foes[0], "")).contains("cannot pay its Rage"),
		"§3a: slot 0's hover does not say he cannot pay — %s" % JSON.stringify(String(refusals.get(foes[0], ""))))
	ok(bool(s.call("_ability_usable", u, ex)) and pool.all(func(e): return int(s.call("_eff_cost", u, ex, e)) <= u.resource),
		"§3a: the door and the pool disagree — usable %s, every offered body payable %s" % [
			s.call("_ability_usable", u, ex), pool.all(func(e): return int(s.call("_eff_cost", u, ex, e)) <= u.resource)])
	# THE CONTROL: no ward, the same Rage — both bodies.
	u.mod_cost_mult = 1.0
	var pool2: Array = s.call("_enemy_pick_pool", u, ex, foes)
	ok(pool2.has(foes[0]) and pool2.has(foes[1]) and pool2.size() == 2,
		"§3a: with no ward and %d Rage the pick offers %s — want slots 0 and 1" % [u.resource, _slots(s, pool2)])
	u.mod_cost_mult = was_mult
	u.execute_upgraded = 0
	var body := _body("scripts/battle.gd", "_enemy_pick_pool")
	ok(body.contains("_eff_cost(u, ab, e) <= u.resource") and not body.contains("ab.cost"),
		"§3a: `_enemy_pick_pool` reads the list price (`ab.cost`) or not each body's own (`_eff_cost(u, ab, e)`)")
	print("    warded: list %d, ward's price %d, Rage %d — offered %s; unwarded — offered %s" % [
		ex.cost, warded_price, ex.cost, _slots(s, pool), _slots(s, pool2)])
	# THE SWEEP: every other reader of a list price where an effective one is meant, printed (IM's report counts them).
	var by_fn := {}
	var rx := RegEx.new()
	rx.compile("\\w+\\.cost\\s*[<>]=?\\s*\\w+\\.resource|\\w+\\.resource\\s*[<>]=?\\s*\\w+\\.cost\\b|\\w+\\.resource\\s*>=\\s*\\w+\\.cost\\s*\\+")
	var fn := ""
	for line in _src("scripts/battle.gd").split("\n"):
		if String(line).begins_with("func "):
			fn = String(line).substr(5, String(line).find("(") - 5)
		if rx.search(String(line)) != null:
			by_fn[fn] = int(by_fn.get(fn, 0)) + 1
	var total := 0
	for k in by_fn:
		total += int(by_fn[k])
	ok(not by_fn.has("_enemy_pick_pool"), "§3a: the pick pool still compares a list price with his resource")
	print("    list-price reads left in battle.gd: %d — %s" % [total, str(by_fn)])
	await _clear(s)


# ── §3b — THE SEVEN, DRIVEN BOTH WAYS ───────────────────────────────────────

# The shape each card's thing takes on a body: Burn, Ruin, a prison, or an affliction.
func _lay(s: Node, sp: String, e: BattleUnit, src: BattleUnit) -> void:
	match sp:
		"firedraw", "funeral_pyre", "pyre_wake":
			s.call("_apply_status", e, "burn", 4, 0, s.call("_dot_tick", "burn", src), src)
		"transference", "requiem":
			s.call("_apply_status", e, "ruin", -1, 0, 0, src)
			e.set_ruin_stacks(3)
		"cull":
			s.call("_apply_status", e, "cripple", 3, 0, 0, src)
		"cryoclasm":
			e.add_status("chilled", "Chilled", "C", Color(0.5, 0.8, 1.0), 3, "", 0)
			e.set_chilled_stacks(4)
			s.call("_hold_freeze", e, src, true)


func _s3b_the_seven() -> void:
	print("\n§3b — the seven: a refused body moves nothing, an offered one moves something")
	var boards := [["swordmaster", "pyromancer", "occultist", "mystic"], ["swordmaster", "cryomancer", "holy", "beastmaster"]]
	var driven := 0
	for specs in boards:
		var s: Node = await _board(specs, {})
		if s == null:
			ok(false, "§3b: the board %s did not spawn" % str(specs))
			continue
		var foes := _foes(s)
		ok(foes.size() == 3, "§3b: the board fields %d enemies, want three" % foes.size())
		for sp in SEVEN:
			var seat := String(SEAT_OF[sp])
			var u := _hero(s, seat)
			var ab: Ability = Classes.pool_ability(String(SEVEN[sp]))
			if u == null or ab == null:
				ok(false, "§3b: %s has no seat or no definition" % SEVEN[sp])
				continue
			if sp == "cryoclasm" and not u.has_engine("permafrost"):
				continue
			if sp != "cryoclasm" and specs[1] == "cryomancer":
				continue
			driven += 1
			# THE BOARD: the thing on slot 0 alone — so slot 0 is the dud of a MOVE card and the one offered body of a
			# CONSUME card. (A second holder is laid below, so a move card's holder is offered once another holds it.)
			_calm(s, 100000)
			_lay(s, sp, foes[0], u)
			var pool: Array = s.call("_enemy_pick_pool", u, ab, foes)
			var refused: Dictionary = s.call("_target_refusals", u, ab, pool)
			var moves: bool = sp in ["firedraw", "transference", "cryoclasm"]
			var want_pool: Array = [foes[1], foes[2]] if moves else [foes[0]]
			ok(pool == want_pool,
				"§3b: %s with the thing on slot 0 alone offers %s — want %s" % [SEVEN[sp], _slots(s, pool), _slots(s, want_pool)])
			var refused_ok := true
			for e in foes:
				if pool.has(e):
					refused_ok = refused_ok and not refused.has(e)
				else:
					refused_ok = refused_ok and String(refused.get(e, "")).begins_with(String(SEVEN[sp]) + ":")
			ok(refused_ok, "§3b: %s's hover reasons are %s — every body it does not offer says why, in the card's name, and no offered body does" % [
				SEVEN[sp], JSON.stringify(refused.values())])
			# DRIVEN: a body the PICK refuses moves nothing at all, and one it offers moves something — each taken from
			# the pool the predicate built, never named here, so a predicate that is not its handler's reds both arms.
			var refused_bodies: Array = foes.filter(func(e): return not pool.has(e))
			if refused_bodies.is_empty() or pool.is_empty():
				ok(false, "§3b: %s's pool %s leaves no refused or no offered body to cast on" % [SEVEN[sp], _slots(s, pool)])
				continue
			var dud: BattleUnit = refused_bodies[0]
			u.resource = u.max_resource
			var before := _snap(s)
			await s.call("_resolve", u, ab, dud, "good")
			var after := _snap(s)
			ok(before == after, "§3b: %s cast on a body the pick refuses (%s) moved the board:\n%s\n  ->\n%s" % [
				SEVEN[sp], _slot(s, dud), before, after])
			# AND AN OFFERED BODY MOVES SOMETHING.
			_calm(s, 100000)
			_lay(s, sp, foes[0], u)
			var live: BattleUnit = pool[0]
			u.resource = u.max_resource
			var before2 := _snap(s)
			await s.call("_resolve", u, ab, live, "good")
			ok(_snap(s) != before2, "§3b: %s cast on a body the pick offers (%s) moved nothing" % [SEVEN[sp], _slot(s, live)])
			# A MOVE CARD's HOLDER IS OFFERED ONCE ANOTHER BODY HOLDS THE THING TOO — the refusal is the lone holder's.
			if moves and sp != "cryoclasm":
				_calm(s, 100000)
				_lay(s, sp, foes[0], u)
				_lay(s, sp, foes[1], u)
				var pool3: Array = s.call("_enemy_pick_pool", u, ab, foes)
				ok(pool3.size() == 3, "§3b: %s with two holders offers %s — want all three" % [SEVEN[sp], _slots(s, pool3)])
			print("    %-13s refuses %s, offers %s" % [SEVEN[sp], _slots(s, foes.filter(func(e): return not pool.has(e))), _slots(s, pool)])
		await _clear(s)
	ok(driven == SEVEN.size(), "§3b: %d of the seven were driven, want %d" % [driven, SEVEN.size()])
	# THE ONE ANSWER: `_pick_dud` is asked by the pool and the hover, and nobody else.
	var b_src := _src("scripts/battle.gd")
	var askers := b_src.count("_pick_dud(") - 1
	var known := _body("scripts/battle.gd", "_enemy_pick_pool").count("_pick_dud(") \
		+ _body("scripts/battle.gd", "_target_refusals").count("_pick_dud(")
	ok(askers == known and known == 2,
		"§3b: `_pick_dud` is asked %d times, %d of them by the pool and the hover — want those two and no other" % [askers, known])
	var seven_in_code: Array = s_list(b_src)
	ok(seven_in_code == SEVEN.keys(),
		"§3b: `PICK_DUD_SPECIALS` reads %s — want the seven %s" % [str(seven_in_code), str(SEVEN.keys())])


# `PICK_DUD_SPECIALS` as the source writes it, in order.
func s_list(b_src: String) -> Array:
	var at := b_src.find("const PICK_DUD_SPECIALS := [")
	if at < 0:
		return []
	var close := b_src.find("]", at)
	var inner := b_src.substr(at + "const PICK_DUD_SPECIALS := [".length(), close - at - "const PICK_DUD_SPECIALS := [".length())
	var out: Array = []
	for part in inner.split(","):
		var p := String(part).strip_edges().trim_prefix("\"").trim_suffix("\"")
		if p != "":
			out.append(p)
	return out


# THE DOOR AND THE BUTTON: a card that moves a thing from ANOTHER enemy offers nobody when the last enemy standing holds
# it, so the door refuses it and the button says so; a card that consumes what its pick carries is refused by its board
# gate, and Cull's and Cryoclasm's say why now too.
func _s3b_the_door() -> void:
	print("\n§3b — the door refuses a card whose pick offers nobody, and the button says why")
	var boards := [["swordmaster", "pyromancer", "occultist", "mystic"], ["swordmaster", "cryomancer", "holy", "beastmaster"]]
	var lines := {"firedraw": "(The last enemy standing carries the only fire)",
		"transference": "(The last enemy standing carries the only Ruin)",
		"cryoclasm": "(The last enemy standing is the only prison)"}
	for specs in boards:
		var s: Node = await _board(specs, {})
		if s == null:
			continue
		var foes := _foes(s)
		for sp in ["firedraw", "transference", "cryoclasm"]:
			var u := _hero(s, String(SEAT_OF[sp]))
			var ab: Ability = Classes.pool_ability(String(SEVEN[sp]))
			if u == null or ab == null:
				continue
			if (sp == "cryoclasm") != (specs[1] == "cryomancer"):
				continue
			_calm(s, 100000)
			_lay(s, sp, foes[0], u)
			u.resource = u.max_resource
			u.cooldowns.clear()
			var lit_three := bool(s.call("_ability_usable", u, ab))
			# The other two fall: the last enemy standing is the holder.
			(foes[1] as BattleUnit).dead = true
			(foes[2] as BattleUnit).dead = true
			var lit_one := bool(s.call("_ability_usable", u, ab))
			var tip := _button_tip(s, u, ab)
			(foes[1] as BattleUnit).dead = false
			(foes[2] as BattleUnit).dead = false
			ok(lit_three and not lit_one and bool(tip["disabled"]) and String(tip["tip"]).contains(String(lines[sp])),
				"§3b: %s — lit with three standing %s, with the holder alone %s; its button says %s" % [
					SEVEN[sp], lit_three, lit_one, JSON.stringify(String(tip["tip"]).get_slice("\n", String(tip["tip"]).get_slice_count("\n") - 1))])
		if specs[1] == "cryomancer":
			var cm := _hero(s, "mage")
			var cc: Ability = Classes.pool_ability("Cryoclasm")
			_calm(s, 100000)
			var tip2 := _button_tip(s, cm, cc)
			ok(bool(tip2["disabled"]) and String(tip2["tip"]).contains("(No enemy is held in a prison)"),
				"§3b: Cryoclasm with no prison standing is not darkened with its reason")
		else:
			var hu := _hero(s, "hunter")
			var cu: Ability = Classes.pool_ability("Cull")
			_calm(s, 100000)
			var tip3 := _button_tip(s, hu, cu)
			ok(bool(tip3["disabled"]) and String(tip3["tip"]).contains("(Nothing on the field can be reaped)"),
				"§3b: Cull with nothing to reap is not darkened with its reason")
		await _clear(s)


# THE BOT AIMS WHERE THE PICKER WOULD: the drafted hook's Firedraw aim and its Transference aim, and the Cryomancer's
# rotation, ask the pool — driven where the hook can see the card, read off the source where it cannot.
func _s3b_the_bot() -> void:
	print("\n§3b — the bot's aims at the seven ask the pool")
	var hook := _body("scripts/battle.gd", "_bot_drafted_pick")
	var rota := _body("scripts/battle.gd", "_autoplay_pick_kit")
	ok(hook.contains("if cb_ripest != null and _enemy_pick_pool(u, ab, foes).has(cb_ripest):"),
		"§3b: the hook's Firedraw aim does not ask the pool")
	ok(hook.contains("if ab.special == \"transference\" and not _enemy_pick_pool(u, ab, foes).has(bu_pick):")
			and not hook.contains("bu_others"),
		"§3b: the hook's Transference aim keeps a qualifier of its own")
	ok(rota.contains("and _enemy_pick_pool(u, clasp, foes).has(cryo_mark)"),
		"§3b: the Cryomancer's rotation aims Cryoclasm without the pool")
	var seen: Array = []
	for sp in SEVEN:
		if Classes.draft_ability(String(SEVEN[sp])) != null:
			seen.append(SEVEN[sp])
	print("    the drafted hook can see %s of the seven (`Classes.draft_ability`)" % str(seen))
	if not seen.has("Firedraw"):
		return
	var s: Node = await _board(["swordmaster", "pyromancer", "occultist", "mystic"],
		{1: {"bm_abilities": ["Firedraw"], "bm_equipped": ["Firedraw"]}})
	var u := _hero(s, "mage") if s != null else null
	var fd := _card(u, "Firedraw") if u != null else null
	if u == null or fd == null:
		ok(false, "§3b: the board does not seat a Pyromancer holding a drafted Firedraw")
		await _clear(s)
		return
	var foes := _foes(s)
	_calm(s, 100000)
	_lay(s, "firedraw", foes[0], u)
	u.resource = u.max_resource
	u.cooldowns.clear()
	var pick: Array = s.call("_bot_drafted_pick", u)
	ok(pick.is_empty() or pick[0] != fd or (pick[1] as BattleUnit) != foes[0],
		"§3b: with one enemy alight the hook aimed Firedraw at it — the one body the pick refuses")
	_lay(s, "firedraw", foes[1], u)
	var pick2: Array = s.call("_bot_drafted_pick", u)
	ok(not pick2.is_empty() and pick2[0] == fd and (s.call("_enemy_pick_pool", u, fd, foes) as Array).has(pick2[1]),
		"§3b: with two alight the hook did not aim Firedraw at an offered body (%s)" % [
			_slot(s, pick2[1] as BattleUnit) if not pick2.is_empty() else "nothing"])
	print("    one alight: the hook aims %s; two alight: Firedraw at %s" % [
		"nothing" if pick.is_empty() else "%s at %s" % [(pick[0] as Ability).display_name, _slot(s, pick[1] as BattleUnit)],
		_slot(s, pick2[1] as BattleUnit) if not pick2.is_empty() else "nobody"])
	await _clear(s)


# THE REACH: every single-target enemy pick in the corpus on a clean board — the seven and Execute narrow (each to
# nobody: nothing on the field is theirs), and no other card does; Hunt keeps the whole warband.
func _s3b_the_reach() -> void:
	print("\n§3b — the reach: which picks narrow on a clean board")
	var s: Node = await _board(["berserker", "pyromancer", "holy", "mystic"], {})
	var u := _hero(s, "warrior") if s != null else null
	if u == null:
		ok(false, "§3b: the reach board did not spawn")
		await _clear(s)
		return
	_calm(s, 10000)
	var narrowed: Array = []
	var read := 0
	var hunt_whole := false
	for ab in Classes.ability_corpus():
		if ab.target != Ability.Target.ENEMY or ab.aoe or ab.random_hits > 0:
			continue
		read += 1
		var pool: Array = s.call("_enemy_pick_pool", u, ab, _foes(s))
		if pool.size() != _foes(s).size():
			narrowed.append(ab.display_name)
		if ab.display_name == "Hunt":
			hunt_whole = pool.size() == _foes(s).size()
	var want: Array = ["Execute"]
	for sp in SEVEN:
		want.append(String(SEVEN[sp]))
	var got := narrowed.duplicate()
	got.sort()
	want.sort()
	ok(got == want and read >= 100,
		"§3b: on a clean board the pick narrows %s — want Execute and the seven (%d cards read)" % [str(got), read])
	ok(hunt_whole, "§3b: Hunt's pick does not offer the whole warband — a pick that pays its base is offered")
	print("    %d single-target enemy picks read; narrowed: %s" % [read, str(got)])
	await _clear(s)


# ── §0 — THE RULINGS ────────────────────────────────────────────────────────

func _s0_rulings() -> void:
	print("\n§0 — the pouch's rule, the Daze's comment, the `st/b` column and the three instrument rules")
	var items := String(Glossary.entry("consumables").get("long", ""))
	ok(items.count("No one deals a bomb's damage and no one lays a potion's status — the pouch belongs to all four heroes") == 1,
		"§0.5: the items entry does not state the pouch's one rule once")
	ok(items.count("No one deals a bomb's damage") == 1, "§0.5: the bomb's line stands twice in the items entry")
	# THE DAZE: the comment says nobody's, by DI §2's rule, and the call passes no source (IL §1a holds the call).
	var raw := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not raw.contains("Occultist-attributed") and not raw.contains("the Daze is\n\t# the Occultist's work"),
		"§0.5: `battle.gd` still calls the charmed Daze the Occultist's work")
	var bw := _body("scripts/battle.gd", "_bewitched_strike")
	ok(bw.contains("_apply_status(bw_target, \"dazed\", 2)\n"), "§0.5: the charmed Daze passes a source, or moved")
	var bw_at := raw.find("\nfunc _bewitched_strike(")
	# BATCH IT §3b — RE-POINTED: the 900 characters ABOVE the function started 129 inside `_cheapest_attack`, the function
	# before it. The read is the function's own comment now — the comment lines directly above its `func` — and says so.
	var bw_lead := Gate.comment_above(raw, bw_at + 1) if bw_at > 0 else ""
	ok(Gate.is_comment(bw_lead), "§0.5: the lead read above `_bewitched_strike` is its own comment and nothing else (%d chars)" % bw_lead.length())
	ok(bw_at > 0 and bw_lead.contains("DI §2"),
		"§0.5: the comment above `_bewitched_strike` does not name DI §2's ruling")
	# THE `st/b` COLUMN: named for what it counts, and not one printed character of the report moved.
	ok(not raw.contains("debuff counter") and not raw.contains("the debuffer's ledger"),
		"§0.6: `battle.gd` still calls the `st/b` column a debuff counter")
	ok(_src("scripts/battle.gd").contains("lines.append(\"  hero               n   dmg/b  dmg%  heal/b  prev/b   BD/b  BD%  BDprev/b  st/b  d+h+p%\")"),
		"§0.6: the report's header moved — the tally is renamed in its words, never in its output")
	ok(_body("scripts/battle.gd", "_apply_status").contains("_stat(\"st_hero_\" + st_name)"),
		"§0.6: the door's tally is not where it was")
	# THE THREE RULES, ONCE EACH, IN THE INSTRUMENT RULES.
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	for needle in ["A FACT ABOUT A FIELD's REACH IS READ AT THE FIELD's READ SITES, NEVER AT ITS WRITES",
			"RETIRING A TRUE CLAIM IS THE SAME DEFECT AS KEEPING A FALSE ONE",
			"A GATE THAT SELECTS ITS SUBJECT BY A SUPERLATIVE NAMES THE SUBJECT IT PICKED"]:
		ok(ir.count(needle) == 1, "§0: `docs/instrument-rules.md` states *%s* %d times, want once" % [needle, ir.count(needle)])


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
