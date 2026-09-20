# BATCH GW — THREE RUNES, AND A GATE THAT WROTE WHAT IT TESTED.
#
#   §0  THE PLAYER'S FILES, AS FOUND
#   §1  THE SHARED HIDE CROSSES, AND NOTHING HERE SETS A RUNE FIELD BY HAND.
#       The rune is equipped on a party member, the GAME writes its field onto
#       the hunter at the spawn, the summon carries it onto the companion, and
#       the multiplier pays — driven with the engine equipped and with it merely
#       owned, because the rune reads no engine and is offered either way
#   §1b THE CENSUS THAT SAYS IT IS THE ONLY ONE, asked of a live board with a
#       beast standing: over all `rune_` fields the companion carries exactly
#       one, and the four structural facts every other field's exemption rests
#       on — a companion is not in `heroes`, is in neither of `_next_unit`'s two
#       arrays, IS in `_hero_side`, and holds no engine
#   §2  THE SHAPE, SWEPT OVER THE BATTERY'S OWN POPULATION — a gate that SETS a
#       rune, engine or talent field on a unit rather than equipping the rune,
#       taking the engine or buying the node. A REPORT with a ceiling, not a
#       repair: §2 of the brief ruled on nothing
#   §3  THE TWO PRICES, GATED WITH THEIR PAYOUTS. Engine equipped: the price
#       lands and the payout pays. Engine merely owned: neither
#   §4  THE PLAYER'S FILES, AS THEY WERE
#
# ── EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM ───────────────────────────────
# The companion's field carried, beside the same board with no rune worn where
# it is not; the multiplier paying, beside the same board paying exactly 1.0;
# the blow bigger, beside the same seeded blow without it. A companion absent
# from `heroes`, beside the same body PRESENT in `_hero_side`. A price refused
# with the engine merely owned, beside the same price landing with it equipped
# AND the payout paying there; and beside a hero wearing no rune at all, whose
# heal lands and whose poison bites in both arms.
#
# ── WHY §1 DOES NOT WRITE `rune_shared_hide` ANYWHERE ───────────────────────
# **THAT IS THE WHOLE SUBJECT.** `check_ez` set the field on the BEAST by hand
# and then read the multiplier — the one path a real run never takes — so it
# asserted 1.25 for batches while the rune paid nobody anything, and `check_gv`
# drove the same rune through the real door, read 15 damage in all four arms and
# recorded that as the expected state. Two gates, opposite readings, and nothing
# reconciled them. This gate only ever equips.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gw.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SEED := 20260920

# §2 — THE CEILING, AND WHY IT IS A CEILING RATHER THAN A PIN.
# The sweep is a REPORT (the brief ruled on nothing), so this number may only
# ever come DOWN by itself. A batch that adds a legitimate hand-set — a fixture
# seating a hero, a probe dressing a board — raises it here and says why in its
# report; a batch that adds another gate arranging its own subject is the one
# this is for. Measured at GW over the battery's own target list, on the
# landed tree: 90, after the two `check_ez` sites this batch repaired came out
# of it (the recon read 92).
const SHAPE_CEILING := 90
# ...and the two that were on a body the game never writes the field to, both
# repaired at GW. Zero is the assertion; the rest of the ceiling is the report.
const WRONG_BODY := 0

# §1 — the buff the multiplier reads, and its literal, off `_shared_hide_mult`'s
# own list. Surge is a flat 1.2 there and is the cheapest thing to lay.
const SURGE_MULT := 1.2

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH GW — THREE RUNES, AND A GATE THAT WROTE WHAT IT TESTED")
	# UNCAPPED, or every board's ninety settling frames arrive at sixty a second
	# (`battle._ready` uncaps only a sim). GV's own reason, and its measurement.
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a beast is called")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	await _s1_the_hide_crosses()
	await _s1c_the_loadouts()
	await _s1b_the_census()
	_s2_the_shape()
	await _s3_the_prices()
	_s4_the_players_files()
	Engine.time_scale = 1.0
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

# ONE BOARD BUILDER, AND IT ONLY EVER EQUIPS. The lineage hero sits at his
# class's seat with no other lineage seated; his engine rune is his, EQUIPPED or
# merely OWNED (the state the pouch's own door leaves him in); the ordinary runes
# named are worn through `party[seat]["runes"]`, which is the dict
# `battle.gd`'s spawn reads as it builds each hero — so every `rune_` field on
# the board below was written by the game.
func _board(spec: String, runes: Array, equip: bool) -> Node:
	var seat := SEATS.find(Classes.class_of_spec(spec))
	var specs := ["", "", "", ""]
	specs[seat] = spec
	var over := {}
	for i in 4:
		over[i] = {"engines": []}
	var eng: Array = Runes.engine_pouch_for_spec(spec)
	for r in eng:
		(r as Dictionary)["equipped"] = equip
	over[seat]["engines"] = eng
	var worn: Array = []
	for rid in runes:
		var r2: Dictionary = Runes.build(String(rid))
		r2["equipped"] = true
		worn.append(r2)
	over[seat]["runes"] = worn
	var s: Node = await Gate.spawn(self, specs, {"party": over, "deterministic": true})
	Engine.time_scale = 50.0
	return s


# THE BEAR, AND THE REASON IT IS THE BEAR. A blow is measured as the body's
# health before and after, so anything else that reaches that body inside the
# call is inside the reading — and the FIRST DRAFT OF THIS ARM MEASURED EXACTLY
# THAT. A Canis lays Bleed on every strike (`_add_bleed_with_burst`), whose
# burst lands in the same window and is NOT multiplied by this rune, and an
# Aguila lays Exposed, which raises everything that follows: over twelve wolf
# blows the with/without ratio read x1.19 against a multiplier of x1.2500, and
# the gap was the bleed. **The bear's only rider strikes the bodies BESIDE the
# target**, so the blow on the target is the companion's blow and nothing else.
#
# The body is topped up between blows rather than inflated: a foe given a
# million health reads every percentage-of-health term in the file at a
# million's scale, which the first draft also did (400,198 over twelve blows).
func _blows(s: Node, comp: BattleUnit, foe: BattleUnit) -> int:
	var total := 0
	seed(SEED)
	for _i in BLOWS:
		foe.hp = foe.max_hp
		var was := foe.hp
		await s._companion_strike(comp, foe, 1.0, false)
		total += was - foe.hp
	return total


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return s.get("enemies").filter(func(e): return not e.dead)


# EVERY `rune_` FIELD ON `BattleUnit`, DERIVED OFF THE DECLARATION RATHER THAN
# LISTED. A second list is a second thing to keep in step; this one grows by
# itself the day a rune field is declared.
func _rune_fields() -> Array:
	var out: Array = []
	for raw in FileAccess.get_file_as_string("res://scripts/unit.gd").split("\n"):
		var line := String(raw)
		if not line.begins_with("var rune_"):
			continue
		out.append(line.substr(4).split(" ")[0].split(":")[0])
	return out


# A blow from a foe, so the struck hero's own clauses fire at the site a landed
# attack fires them at.
func _struck(s: Node, foe: BattleUnit, victim: BattleUnit) -> void:
	foe.resource = 99999
	foe.cooldowns.clear()
	await s._resolve(foe, foe.abilities[0], victim, "good")


# ── §1 — THE SHARED HIDE CROSSES ────────────────────────────────────────────
#
# **DRIVEN IN BOTH ENGINE ARMS ON PURPOSE.** The rune reads no engine — a
# companion is fielded by an earned Call the Wilds with no Pack Bond at all
# (GV §1c) — so it is not a `Runes.ENGINE_READ` row and must pay with the engine
# merely owned exactly as it pays with it equipped. That is also the arm that
# says the repair is a COPY at the summon rather than anything the engine does.
func _s1_the_hide_crosses() -> void:
	print("\n§1 — the Shared Hide crosses, equipped through the real door")
	for equip in [true, false]:
		var arm := "engine equipped" if equip else "engine merely owned"
		# ── worn ──
		var s: Node = await _board("beastmaster", ["shared_hide"], equip)
		var bm: BattleUnit = _hero(s, "hunter")
		var f0: BattleUnit = _foes(s)[0]
		ok(bm != null and bm.rune_shared_hide > 0,
			"§1 [%s]: the GAME wrote the Shared Hide onto the hunter at the spawn (%d)"
				% [arm, bm.rune_shared_hide if bm != null else -1])
		await s._do_summon(bm, "ursus")
		var cn: BattleUnit = s._beasts(bm)[0]
		ok(cn != null and cn.rune_shared_hide == bm.rune_shared_hide,
			"§1 [%s]: ...and the summon carried it onto the companion (%d against the hunter's %d)"
				% [arm, cn.rune_shared_hide if cn != null else -1, bm.rune_shared_hide])
		s._apply_status(cn, "surge", 3)
		ok(cn.has_status("surge"), "§1 [%s]: Surge attaches to the beast" % arm)
		ok(abs(s._shared_hide_mult(cn) - SURGE_MULT) < 0.0001,
			"§1 [%s]: ...and the hide multiplier reads %.4f — the buff it was already wearing finally pays"
				% [arm, s._shared_hide_mult(cn)])
		var with_rune: int = await _blows(s, cn, f0)
		await _clear(s)
		# ── the same board, no rune ──
		var s2: Node = await _board("beastmaster", [], equip)
		var bm2: BattleUnit = _hero(s2, "hunter")
		var f1: BattleUnit = _foes(s2)[0]
		ok(bm2.rune_shared_hide == 0,
			"§1 [%s]: with no rune worn the hunter's field is 0" % arm)
		await s2._do_summon(bm2, "ursus")
		var cn2: BattleUnit = s2._beasts(bm2)[0]
		ok(cn2.rune_shared_hide == 0,
			"§1 [%s]: ...and so is the companion's — the copy carries a 0 as faithfully as a 1" % arm)
		s2._apply_status(cn2, "surge", 3)
		ok(abs(s2._shared_hide_mult(cn2) - 1.0) < 0.0001,
			"§1 [%s]: ...and the multiplier is exactly 1.0000 with the same Surge standing" % arm)
		var bare: int = await _blows(s2, cn2, f1)
		await _clear(s2)
		print("    [%s] %d Surged blows: %d with the rune, %d without (x%.3f)"
			% [arm, BLOWS, with_rune, bare, float(with_rune) / maxf(float(bare), 1.0)])
		ok(with_rune > bare,
			"§1 [%s]: the blow read %d with the Shared Hide and %d without — the rune pays SOMEBODY now"
				% [arm, with_rune, bare])


# ── §1c — THE THREE LOADOUTS, DRIVEN AS DAMAGE ──────────────────────────────
#
# **EZ REPORTED +25.0% / +56.2% / +133.6% AND MEASURED THEM BY CALLING
# `_shared_hide_mult` ON A BEAST WHOSE FIELD IT HAD SET BY HAND** (`docs/reports/EZ.md`
# §4b(ii)). Those are the multipliers the function returns; they were never a
# companion's damage, and the field they were read off is the one a real run
# never writes. This drives the same three states through the real door and
# reads the BLOW.
#
# **THE POWERS ARE THE ONES THAT REPRODUCE EZ'S OWN PRODUCTS**, so the two
# readings are comparable rather than merely both true: Warcry 25 (×1.2500 alone,
# EZ's thin row), Empower's flat 1.25 (×1.5625, EZ's mid row), and Battle Shout 15
# with the Pivot at 30 (1.25 × 1.25 × 1.15 × 1.30 = ×2.3359375, EZ's deep row).
# Battle Shout's power is Bleed-derived and the Pivot's is the stance's, so
# neither has a default to fall back on — they are stated here, not guessed.
const LOADOUTS := [
	["thin  — Warcry alone", {"warcry": 25}, 1.25],
	["mid   — Warcry + Empower", {"warcry": 25, "empower": 0}, 1.5625],
	["deep  — Warcry + Empower + Battle Shout + Pivot",
		{"warcry": 25, "empower": 0, "battle_shout": 15, "tempo": 30}, 2.3359375],
]
const BLOWS := 40
# THE FLOOR EVERY DAMAGE ARM IS HELD TO, AND WHY IT IS A FRACTION OF THE
# MULTIPLIER RATHER THAN THE MULTIPLIER. A blow is an integer — the bear's is
# about ten — so rounding moves a forty-blow ratio by a percent or two either
# way, and a band written to one run's extremes reads the next run as a
# regression (DD's rule). Half the multiplier's own swing is far above rounding
# and far below "the rune moved a little": at x1.25 it demands +12.5%, and the
# arm that failed before this gate existed paid exactly 0.0%.
const SWING_FLOOR := 0.5


func _s1c_the_loadouts() -> void:
	print("\n§1c — the three loadouts EZ measured, driven as a companion's damage")
	for row in LOADOUTS:
		var label := String(row[0])
		var buffs: Dictionary = row[1]
		var ez := float(row[2])
		var dealt := {}
		var mult := {}
		for wear in [true, false]:
			var s: Node = await _board("beastmaster", ["shared_hide"] if wear else [], true)
			var bm: BattleUnit = _hero(s, "hunter")
			var f0: BattleUnit = _foes(s)[0]
			await s._do_summon(bm, "ursus")
			var cn: BattleUnit = s._beasts(bm)[0]
			for sid in buffs:
				s._apply_status(cn, String(sid), 99, int(buffs[sid]))
				# A BUFF THAT DID NOT LAND WOULD READ AS A RUNE THAT DID NOT
				# PAY, which is the exact failure this gate exists for.
				ok(cn.has_status(String(sid)),
					"§1c: [%s] %s attaches to the beast (rune %s)"
						% [label, sid, "worn" if wear else "not worn"])
			mult[wear] = s._shared_hide_mult(cn)
			dealt[wear] = await _blows(s, cn, f0)
			await _clear(s)
		var swing := 100.0 * (float(dealt[true]) / maxf(float(dealt[false]), 1.0) - 1.0)
		print("    %-48s  %d blows: %d with, %d without  (%+.1f%%)   mult %.4f / %.4f   EZ %.4f"
			% [label, BLOWS, dealt[true], dealt[false], swing, mult[true], mult[false], ez])
		ok(abs(float(mult[true]) - ez) < 0.0001,
			"§1c: [%s] the multiplier the GAME wrote reads %.4f against EZ's %.4f"
				% [label, mult[true], ez])
		ok(abs(float(mult[false]) - 1.0) < 0.0001,
			"§1c: [%s] ...and exactly 1.0000 with no rune worn, the same buffs standing (%.4f)"
				% [label, mult[false]])
		ok(swing >= 100.0 * (ez - 1.0) * SWING_FLOOR,
			"§1c: [%s] the BLOW moved %+.1f%% over %d seeded strikes (%d against %d) — under %.1f%%, half the multiplier's own swing"
				% [label, swing, BLOWS, dealt[true], dealt[false],
					100.0 * (ez - 1.0) * SWING_FLOOR])


# ── §1b — THE CENSUS, ASKED OF A LIVE BOARD ─────────────────────────────────
#
# **THE REPORT SAYS ONE FIELD CROSSES AND THIS IS WHY THE OTHER 119 DO NOT.**
# Each exemption in GW §1b rests on one of four structural facts about a
# companion, and each is asked here of a body actually standing on a board
# rather than read off the source: it is not in `heroes` (so every `for h in
# heroes` walk misses it), it is in neither array `_next_unit` picks from (so it
# never acts, and `_resolve`'s `attacker` is never one), it IS in `_hero_side`
# (so it can be STRUCK, which is what makes `strike_target` the one receiver
# worth checking at all), and it holds no engine (so every `has_engine` guard
# refuses it — `rune_thin_blood` and `rune_second_barb`'s read sites above all).
func _s1b_the_census() -> void:
	print("\n§1b — the census: one field crosses, and the four facts that exempt the rest")
	var s: Node = await _board("beastmaster", ["shared_hide", "long_leash"], true)
	var bm: BattleUnit = _hero(s, "hunter")
	await s._do_summon(bm, "ursus")
	var cn: BattleUnit = s._beasts(bm)[0]
	var fields := _rune_fields()
	ok(fields.size() >= 100,
		"§1b: the field list was read off `unit.gd` — %d declarations" % fields.size())
	# THE HUNTER CARRIES BOTH RUNES' FIELDS, which is the arm that makes the
	# companion's single field a finding rather than an empty board.
	ok(bm.rune_shared_hide > 0 and bm.rune_long_leash > 0,
		"§1b: the hunter carries BOTH runes' fields (hide %d, leash %d)"
			% [bm.rune_shared_hide, bm.rune_long_leash])
	var carried: Array = []
	for f in fields:
		if float(cn.get(String(f))) != 0.0:
			carried.append(String(f))
	print("    the companion carries: %s" % [carried])
	ok(carried == ["rune_shared_hide"],
		"§1b: the companion carries exactly one `rune_` field of %d, and it is the Shared Hide's (%s)"
			% [fields.size(), carried])
	# THE FOUR FACTS.
	var heroes: Array = s.get("heroes")
	var enemies: Array = s.get("enemies")
	ok(not heroes.has(cn),
		"§1b: a companion is NOT in `heroes` — every `for h in heroes` walk misses it")
	ok(not heroes.has(cn) and not enemies.has(cn),
		"§1b: ...and is in neither array `_next_unit` picks from, so it never takes a turn")
	ok(is_inf(cn.next_time),
		"§1b: ...which is also what its INF `next_time` says (%s)" % cn.next_time)
	ok(s._hero_side().has(cn),
		"§1b: but it IS in `_hero_side` — an enemy can strike it, which is why `strike_target` is the receiver worth checking")
	ok(cn.engines.is_empty(),
		"§1b: and it holds no engine (%s) — every `has_engine` guard refuses it" % [cn.engines])
	ok(not bm.engines.is_empty(),
		"§1b: ...beside its hunter, who holds one (%s)" % [bm.engines])
	await _clear(s)


# ── §2 — THE SHAPE, SWEPT ───────────────────────────────────────────────────
#
# **A GATE THAT WRITES ITS OWN PRECONDITION CANNOT FAIL WHEN THE PATH THAT
# SHOULD WRITE IT IS BROKEN.** The sweep's population is the battery's own
# target list, read out of `run_battery.sh` rather than listed here, and the
# fields are read off `unit.gd` and `talents.gd` — so a target added later is
# swept by doing nothing.
#
# **COMMENTS ARE STRIPPED FIRST** (`check_ds`'s ruling): prose describing a
# hand-set is not a hand-set, and this gate's own header names two of them.
func _s2_the_shape() -> void:
	print("\n§2 — the shape, swept over the battery's own population")
	var fields := {}
	for f in _rune_fields():
		fields[f] = "RUNE"
	fields["engines"] = "ENGINE"
	for f in _talent_fields():
		if not fields.has(f):
			fields[f] = "TALENT"
	var targets := _battery_targets()
	ok(targets.size() > 100,
		"§2: the battery's target list was read off `run_battery.sh` — %d targets" % targets.size())
	var sites := 0
	var per := {}
	var read := 0
	for t in targets:
		var path := "res://%s.gd" % t
		if not FileAccess.file_exists(path):
			continue
		read += 1
		var src := Gate.strip_comments(FileAccess.get_file_as_string(path))
		for raw in src.split("\n"):
			var line := String(raw)
			for f in fields:
				var at := line.find(".%s " % f)
				if at < 0:
					continue
				var rest := line.substr(at + String(f).length() + 2)
				if not (rest.begins_with("= ") or rest.begins_with("+= ")
						or rest.begins_with("-= ") or rest.begins_with("*= ")):
					continue
				sites += 1
				per[t] = int(per.get(t, 0)) + 1
	ok(read >= 100, "§2: %d of the %d targets are scripts this gate could read" % [read, targets.size()])
	var names: Array = per.keys()
	names.sort()
	for n in names:
		print("    %-26s %d" % [n, per[n]])
	print("    %d sites in %d targets (ceiling %d)" % [sites, names.size(), SHAPE_CEILING])
	ok(sites <= SHAPE_CEILING,
		"§2: the shape GREW to %d sites against a ceiling of %d — a batch adding a legitimate hand-set raises it here and says why; a batch adding a gate that arranges its own subject is what this is for"
			% [sites, SHAPE_CEILING])
	ok(sites > 0,
		"§2: the sweep found nothing at all — it is reading no source, not a clean tree")
	# AND THE TWO THAT WERE ON THE WRONG BODY. `check_ez` set `rune_shared_hide`
	# on the BEAST, which is the one body the game never writes it to, and that
	# is why it could not see a dead rune.
	#
	# **THIS IS A PIN ON THOSE TWO SITES AND NOT A GENERAL RULE, WHICH IS SAID
	# HERE RATHER THAN IMPLIED.** "Is this receiver a companion?" is not a
	# question a source sweep can answer — the receiver is a local whose binding
	# is three statements away — so the needle is the exact spelling the repair
	# removed, and what stands guard over a NEW wrong-body hand-set is the
	# ceiling above, which any additional site trips. The needle is assembled at
	# runtime so this gate does not carry the string it forbids (`check_ds`).
	#
	# **AND IT COUNTS A WRITE, NOT A MENTION.** The first draft counted the
	# needle as a substring and read 2 on a repaired tree: `check_ez`'s new arm
	# COMPARES `beast.rune_shared_hide` against what it expects, and a
	# comparison contains the assignment's own spelling. A needle that cannot
	# tell `==` from `=` accuses the repair for being written about.
	var needle := "beast.rune_shared" + "_hide"
	var wrong := 0
	for t in targets:
		var p2 := "res://%s.gd" % t
		if not FileAccess.file_exists(p2):
			continue
		for raw2 in Gate.strip_comments(
				FileAccess.get_file_as_string(p2)).split("\n"):
			var line2 := String(raw2)
			var at2 := line2.find(needle)
			if at2 < 0:
				continue
			var rest2 := line2.substr(at2 + needle.length())
			if rest2.begins_with(" = ") or rest2.begins_with(" += "):
				wrong += 1
	ok(wrong == WRONG_BODY,
		"§2: %d of the two sites GW repaired still set the Shared Hide's field on the BEAST — the body the game never writes it to" % wrong)


func _talent_fields() -> Array:
	var out: Array = []
	var src := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/talents.gd"))
	var base := ["attack", "armor", "speed", "crit_bonus", "max_hp_pct",
		"max_resource", "no_cover", "parry_bonus", "deflection", "dmg_bonus",
		"dmg_taken_bonus", "pierce_bonus"]
	var at := src.find("\"stat\": {")
	while at >= 0:
		var end := src.find("}", at)
		var body := src.substr(at + 9, end - at - 9)
		for piece in body.split(","):
			var k := String(piece).strip_edges()
			if not k.begins_with("\""):
				continue
			k = k.substr(1, k.find("\"", 1) - 1)
			if not base.has(k) and not out.has(k):
				out.append(k)
		at = src.find("\"stat\": {", end)
	return out


# THE BATTERY'S OWN LIST, READ OFF THE RUNNER. `SUITES` and `GATES` are arrays
# of names in one shell file; a target added there is swept here by doing
# nothing, which is the whole reason the list is not copied.
func _battery_targets() -> Array:
	var out: Array = []
	var src := FileAccess.get_file_as_string("res://run_battery.sh")
	for key in ["SUITES=(", "GATES=("]:
		var at := src.find(key)
		if at < 0:
			continue
		var end := src.find(")", at)
		for w in src.substr(at + key.length(), end - at - key.length()).split("\n"):
			for name in String(w).split(" "):
				var n := String(name).strip_edges()
				if n != "" and not n.begins_with("#"):
					out.append(n)
	return out


# ── §3 — THE TWO PRICES, GATED WITH THEIR PAYOUTS ───────────────────────────
#
# **EACH TOOK ITS PRICE WITH NO ENGINE EQUIPPED WHILE ITS PAYOUT WAS GATED
# BEHIND ONE** (GV §3b drove both: an ally's heal of 40 landed 0 with the Martyr
# worn and 46 without it; a poison ticked 0 with Thin Blood worn and 3 without),
# so an unequipped hero paid a cost and received nothing. Ruled at GW §3: no
# engine, no cost and no payout.
#
# **BOTH ARE ALREADY `Runes.ENGINE_READ` ROWS** — asserted below, because the
# brief's first question was whether they had slipped the census, and the answer
# decides whether the fix is the table or the cost. The table already has them;
# the offer door never offers either to a hero with his engine out. What the
# door cannot reach is a rune already BOUGHT, and that is the whole of §3.
func _s3_the_prices() -> void:
	print("\n§3 — the two prices, gated with their payouts")
	ok(Runes.engine_read("martyr_fk") == "mercy",
		"§3: the Martyr is a ROW already — it did not slip GV's census (%s)"
			% Runes.engine_read("martyr_fk"))
	ok(Runes.engine_read("thin_blood") == "trapper",
		"§3: Thin Blood is a ROW already — it did not slip GV's census (%s)"
			% Runes.engine_read("thin_blood"))
	# ── THE MARTYR: the price is the heal's return, the payout is its own log
	# line. The LOG rather than the bar, because a blow that crosses the half
	# line pays Mercy through the PASSIVE as well and the two would add.
	for equip in [true, false]:
		var arm := "engine equipped" if equip else "engine merely owned"
		var s: Node = await _board("holy", ["martyr_fk"], equip)
		var cl: BattleUnit = _hero(s, "cleric")
		var foe: BattleUnit = _foes(s)[0]
		cl.hp = int(cl.max_hp * 0.5)
		var got: int = cl.heal_amount(40, true)
		cl.hp = cl.max_hp
		await _struck(s, foe, cl)
		var paid: int = _log_count(s, "Rune: the Martyr")
		print("    [Martyr, %s] an ally's heal of 40 lands %d; a blow pays the rune %d time(s)"
			% [arm, got, paid])
		if equip:
			ok(got == 0, "§3: [%s] the Martyr's price refuses an ally's heal (%d)" % [arm, got])
			ok(paid > 0, "§3: ...and the payout it buys pays (%d Mercy line(s))" % paid)
		else:
			ok(got > 0, "§3: [%s] the price is OFF — an ally's heal lands %d" % [arm, got])
			ok(paid == 0, "§3: ...and the payout is off with it (%d Mercy line(s))" % paid)
		await _clear(s)
	# ...and a Cleric wearing no rune at all, in both arms: the heal must land
	# either way, or the arms above are reading something other than the rune.
	for equip2 in [true, false]:
		var s2: Node = await _board("holy", [], equip2)
		var cl2: BattleUnit = _hero(s2, "cleric")
		cl2.hp = int(cl2.max_hp * 0.5)
		ok(cl2.heal_amount(40, true) > 0,
			"§3: with no Martyr worn an ally's heal lands (%s)"
				% ["engine equipped" if equip2 else "engine merely owned"])
		await _clear(s2)
	# ── THIN BLOOD: the price is read on the poison HE lays, the payout on a
	# SECOND body — the barb goes onto whoever struck him, and measuring both on
	# one foe would read his own poison as the barb's.
	for equip3 in [true, false]:
		var arm3 := "engine equipped" if equip3 else "engine merely owned"
		var s3: Node = await _board("mystic", ["thin_blood"], equip3)
		var sv: BattleUnit = _hero(s3, "hunter")
		var f_price: BattleUnit = _foes(s3)[0]
		var f_barb: BattleUnit = _foes(s3)[1]
		s3._apply_poison(sv, f_price, 3)
		var tick := int(f_price.get_status("poison").get("tick", -1))
		ok(not f_barb.has_status("poison"),
			"§3: [%s] the second body carries no poison before the blows" % arm3)
		for _i in 12:
			if f_barb.dead or sv.dead:
				break
			sv.hp = sv.max_hp
			await _struck(s3, f_barb, sv)
		var barbed := f_barb.has_status("poison")
		print("    [Thin Blood, %s] a poison he lays ticks for %d; twelve blows leave the striker poisoned: %s"
			% [arm3, tick, barbed])
		if equip3:
			ok(tick == 0, "§3: [%s] Thin Blood's price stops his poison biting (%d)" % [arm3, tick])
			ok(barbed, "§3: ...and the barb it buys fires on the striker")
		else:
			ok(tick > 0, "§3: [%s] the price is OFF — his poison ticks for %d" % [arm3, tick])
			ok(not barbed, "§3: ...and the barb is off with it — the striker is unpoisoned")
		await _clear(s3)
	for equip4 in [true, false]:
		var s4: Node = await _board("mystic", [], equip4)
		var sv4: BattleUnit = _hero(s4, "hunter")
		var f4: BattleUnit = _foes(s4)[0]
		s4._apply_poison(sv4, f4, 3)
		ok(int(f4.get_status("poison").get("tick", -1)) > 0,
			"§3: with no Thin Blood worn his poison bites (%s)"
				% ["engine equipped" if equip4 else "engine merely owned"])
		await _clear(s4)


func _log_count(s: Node, needle: String) -> int:
	return String(s.get("history").get_parsed_text()).count(needle)


func _statuses(u: BattleUnit) -> Array:
	var out: Array = []
	for st in u.statuses:
		out.append(String(st.id))
	out.sort()
	return out


func _s4_the_players_files() -> void:
	print("\n§4 — the player's files")
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§4: %s exists as it did before the gate (%s)" % [p, has])
		var now := FileAccess.get_file_as_bytes(p) if has else PackedByteArray()
		ok(now == PackedByteArray(was[1]), "§4: %s is byte for byte as this gate found it" % p)
