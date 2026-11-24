# BATCH KE — THE WITHERED WARDEN IS BUILT TO ITS STRATEGY: KILL THE GROVE FIRST (the designer's ruling at KE, JW §0's value).
#
# What this gate asserts, section by section (`docs/reports/KE.md` has the working):
#
#   §1  THE DATA: the Withered Warden carries `rootbound` at the designer's figure, and no other kind carries it.
#   §2  THE DOORS, DRIVEN: while any other body of its warband stands, a blow (`take_hit`) and a tick (`take_tick_damage`)
#       land the figure less the cut, the battle's `_landed` says so before the door, the floor holds at 1 and nothing stays
#       nothing; Break damage is not cut; a body whose data carries no field takes the blow whole; alone, the Warden takes it
#       whole; a body Raised roots it again.
#   §2b THE STRIKE, DRIVEN: a hero's own strike, an Aegis Reversal riding it, on the rooted Warden is cut once — in its computation, never again at the door —
#       landing the uncut strike's figure less the cut (the same dice, the escort cut down in a second fight), and the figure the
#       strike books to the hero is the health that left (IA §0.6: a figure paid off a blow is the blow that landed).
#   §3  THE CHIP: a display chip from the spawn — never a status, so nothing dispels it — whose tag reads the figure off the
#       body; it falls with the last other body and returns on a Raise.
#   §4  THE BOT (a POLICY, DV38): the bot's mark passes over the Warden while another body stands, and takes it alone.
#   §5  THE RECORD: `CLAUDE.md`'s boss-strategy block names the Warden in a bullet built to the value, and in no owed bullet.
#   §6  THE DOOR CALLS: every damage door call of the battle (`take_hit`, `take_tick_damage`, Break-only calls aside) is in KE's
#       census of record (`docs/reports/KE-doors.tsv`), keyed by function and line as `check_jw` §4 keys its own, and each holds
#       its class at source — the strike marks its door, a PRECUT call cuts its receiver within ten lines above, a LANDED call
#       asks `_landed` of its receiver within forty — so a door call written later reds until it is classed (IA §0.6's rule kept).
#   §7  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether the fight is the right difficulty — the figure is
# the designer's — or whether a player reads the chip and answers the question; the sim's figures test the code only. Nor the
# chip's return on a Raise in play: the chip falls only when no other body stands, so none is left to Raise one, and the Warden
# holds no Raise — §2 and §3 drive the return by `revive`. Of the 36 door calls KE cut before they print, §2b drives the strike
# and the doors; the rest are held by the census of record (`report/door_census.tsv` in KE's work folder), not driven here.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const BOSS := "withered_warden"
const FOE := {"type": "boss", "theme": "Boss Escort", "enemies": ["withered_warden", "raider", "totemist"]}
const SCRATCH_PROFILE := "user://ke_profile.json"
const SCRATCH_RELICS := "user://ke_relics.json"
# The designer's figure (*Kill the grove first*), held here as the ruling.
const RULED := 0.5
const BLOCK_HEAD := "## STANDING DESIGN RULE — EVERY BOSS FIGHT HAS A STRATEGY SPECIFIC TO IT"
const BUILT_WORDS := "BUILT TO IT"
const DOORS := "res://docs/reports/KE-doors.tsv"
const DOOR_CLASSES := ["STRIKE", "PRECUT", "LANDED", "DORMANT", "HERO"]
const OWED_WORDS := "RULED, NOT BUILT"

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KE — THE WITHERED WARDEN: KILL THE GROVE FIRST")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before anything is written")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s1_data()
	await _s2_doors()
	await _s2b_strike()
	await _s3_chip()
	await _s4_bot()
	_s5_record()
	_s6_doors()
	Engine.time_scale = 1.0
	_s7_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ──────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(ENG4[i])))
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.pending_item_offers = []
	_run.items = {}


func _battle() -> Node:
	_new_run()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	Engine.time_scale = 1.0
	return current_scene


func _warden(s: Node) -> BattleUnit:
	for e in s.get("enemies"):
		if (e as BattleUnit).rootbound > 0.0:
			return e
	return null


func _escort(s: Node, w: BattleUnit) -> Array:
	var out: Array = []
	for e in s.get("enemies"):
		if e != w:
			out.append(e)
	return out


# What one door call takes off a body's health, the body's health and Break meter put back after.
func _hit_loss(u: BattleUnit, amount: int, tick := false) -> int:
	var before := u.hp
	if tick:
		u.take_tick_damage(amount, "-%d gate" % amount, Color.WHITE)
	else:
		u.take_hit(amount, 0)
	var lost := before - u.hp
	u.hp = before
	return lost


# The Break damage one 100-damage blow carrying 20 lays, the body's health, meter and Broken state put back after.
func _blow_bd(u: BattleUnit) -> int:
	var before := u.hp
	u.pressure = 0
	u.broken = false
	var bd := int(u.take_hit(100, 20)["bd"])
	u.hp = before
	u.pressure = 0
	u.broken = false
	return bd


func _kill(u: BattleUnit) -> void:
	u.take_hit(u.hp + 9999, 0)


# ── §1 — THE DATA ────────────────────────────────────────────────────────────

func _s1_data() -> void:
	print("\n§1 — the Warden carries the field at the designer's figure; no other kind carries it")
	var data: Dictionary = Enemies._load()
	ok(data.has(BOSS) and is_equal_approx(float((data[BOSS] as Dictionary).get("rootbound", 0.0)), RULED),
		"§1: the Withered Warden's rootbound is %s — the ruling is %s" % [str((data.get(BOSS, {}) as Dictionary).get("rootbound", "absent")), str(RULED)])
	var others: Array = []
	for k in data:
		if String(k) != BOSS and (data[k] as Dictionary).has("rootbound"):
			others.append(k)
	ok(others.is_empty(), "§1: kinds other than the Warden carry rootbound: %s" % str(others))
	print("    CHECKED %d kinds: the Warden's figure, no other carrier" % data.size())


# ── §2 — THE DOORS ───────────────────────────────────────────────────────────

func _s2_doors() -> void:
	print("\n§2 — the two doors cut what reaches the Warden while its warband stands")
	var s: Node = await _battle()
	var w := _warden(s)
	ok(w != null and w.is_boss and w.unit_name == Enemies.unit_name(BOSS), "§2: the fight fielded no Rootbound Warden")
	if w == null:
		return
	var esc := _escort(s, w)
	ok(esc.size() == 2, "§2: the escort is %d bodies — want 2" % esc.size())
	ok(is_equal_approx(w.rootbound, RULED), "§2: the spawned Warden's rootbound is %.3f — want %.3f" % [w.rootbound, RULED])
	ok(bool(s.call("_rootbound_holds", w)), "§2: the battle says the Warden's grove does not stand with two of its warband up")
	var want := maxi(int(round(100 * (1.0 - w.rootbound))), 1)
	var blow := _hit_loss(w, 100)
	var tick := _hit_loss(w, 100, true)
	ok(blow == want, "§2: a 100 blow took %d off the rooted Warden — want %d" % [blow, want])
	ok(tick == want, "§2: a 100 tick took %d off the rooted Warden — want %d" % [tick, want])
	ok(int(s.call("_landed", w, 100)) == want, "§2: `_landed` says %d before the door — want %d" % [int(s.call("_landed", w, 100)), want])
	ok(_hit_loss(w, 1) == 1, "§2: a 1 blow on the rooted Warden landed %d — the floor is 1" % _hit_loss(w, 1))
	ok(w.rootbound_landed(0) == 0, "§2: a blow of nothing became %d" % w.rootbound_landed(0))
	# THE FLOOR, where it acts: at a share that rounds a small blow to nothing (the ruled share never does), put back after.
	var ruled := w.rootbound
	w.rootbound = 0.9
	ok(_hit_loss(w, 3) == 1 and _hit_loss(w, 1) == 1, "§2: at a 0.9 share a 3 blow landed %d and a 1 blow %d — the floor is 1" % [_hit_loss(w, 3), _hit_loss(w, 1)])
	w.rootbound = ruled
	var raider: BattleUnit = esc[0]
	ok(raider.rootbound == 0.0 and _hit_loss(raider, 100) == 100,
		"§2: a body with no field took %d of a 100 blow — want 100" % _hit_loss(raider, 100))
	# BREAK DAMAGE IS NOT CUT: the same blow, rooted and alone, fills the meter alike while its damage is cut only rooted.
	var bd_rooted := _blow_bd(w)
	for e in esc:
		_kill(e)
	ok(not bool(s.call("_rootbound_holds", w)), "§2: the battle says the grove stands with the escort dead")
	var bd_alone := _blow_bd(w)
	ok(bd_rooted > 0 and bd_rooted == bd_alone, "§2: Break damage rooted %d, alone %d — Break is never cut" % [bd_rooted, bd_alone])
	ok(_hit_loss(w, 100) == 100, "§2: the Warden alone took %d of a 100 blow — want 100" % _hit_loss(w, 100))
	ok(_hit_loss(w, 100, true) == 100, "§2: the Warden alone took %d of a 100 tick — want 100" % _hit_loss(w, 100, true))
	(esc[1] as BattleUnit).revive(0.5)
	ok(bool(s.call("_rootbound_holds", w)) and _hit_loss(w, 100) == want,
		"§2: a body Raised did not root the Warden again (took %d of 100)" % _hit_loss(w, 100))
	print("    CHECKED a blow, a tick, the landed figure, the floor, Break, a plain body, alone and Raised")


# ── §6 — THE DOOR CALLS ──────────────────────────────────────────────────────

func _s6_doors() -> void:
	print("\n§6 — every damage door call is in KE's census, and each that can reach a Rootbound body cuts first or asks")
	var cen := {}
	var rows := FileAccess.get_file_as_string(DOORS).split("\n", false)
	ok(rows.size() > 1, "§6: the census of record %s is gone or empty" % DOORS)
	if rows.size() <= 1:
		return
	var head := String(rows[0]).split("\t")
	var cf := head.find("function")
	var cc := head.find("code")
	var ck := head.find("class")
	var bad_class: Array = []
	for r in rows.slice(1):
		var c := String(r).split("\t")
		if c.size() <= maxi(cf, maxi(cc, ck)):
			continue
		var key := "%s|%s" % [c[cf], c[cc]]
		if not cen.has(key):
			cen[key] = []
		cen[key].append(c[ck])
		if not DOOR_CLASSES.has(c[ck]):
			bad_class.append(key)
	var lines := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd")).split("\n")
	var fn_re := RegEx.new()
	fn_re.compile("^(static\\s+)?func\\s+(\\w+)\\s*\\(")
	var door_re := RegEx.new()
	door_re.compile("(\\w+)\\.(take_hit|take_tick_damage)\\(")
	var brk_re := RegEx.new()
	brk_re.compile("\\.take_hit\\(\\s*0\\s*,")
	var cur := ""
	var seen := {}
	var unlisted: Array = []
	var broken: Array = []
	var counts := {}
	for i in lines.size():
		var line := String(lines[i])
		var fm := fn_re.search(line)
		if fm != null:
			cur = fm.get_string(2)
		var dm := door_re.search(line)
		if dm == null or brk_re.search(line) != null:
			continue
		var key := "%s|%s" % [cur, line.strip_edges().replace("\t", " ")]
		seen[key] = int(seen.get(key, 0)) + 1
		if not cen.has(key):
			unlisted.append(key.substr(0, 90))
			continue
		var cls: Array = cen[key]
		var cl := String(cls[mini(int(seen[key]), cls.size()) - 1])
		counts[cl] = int(counts.get(cl, 0)) + 1
		var recv := dm.get_string(1)
		var held := true
		match cl:
			"STRIKE":
				held = i > 0 and String(lines[i - 1]).contains("rootbound_precut = rb_cut")
			"PRECUT":
				held = false
				for j in range(maxi(0, i - 10), i):
					if String(lines[j]).contains("_rootbound_precut(%s," % recv):
						held = true
			"LANDED":
				held = false
				for j in range(maxi(0, i - 40), i):
					if String(lines[j]).contains("_landed(%s," % recv):
						held = true
		if not held:
			broken.append("%s (%s)" % [key.substr(0, 80), cl])
	var gone: Array = []
	for k in cen:
		if int(seen.get(k, 0)) != (cen[k] as Array).size():
			gone.append("%s (x%d in the census, x%d in the source)" % [String(k).substr(0, 70), (cen[k] as Array).size(), int(seen.get(k, 0))])
	var total := 0
	for k2 in seen:
		total += int(seen[k2])
	print("    CHECKED %d door calls against %d census rows: %s" % [total, rows.size() - 1, str(counts)])
	ok(total >= 50 and int(counts.get("PRECUT", 0)) >= 30 and int(counts.get("STRIKE", 0)) == 1,
		"§6: the walk read %d door calls (%s) — it has stopped reading" % [total, str(counts)])
	ok(unlisted.is_empty(), "§6: %d door calls the census does not class: %s" % [unlisted.size(), str(unlisted.slice(0, 3))])
	ok(gone.is_empty(), "§6: %d census rows the source does not hold as listed: %s" % [gone.size(), str(gone.slice(0, 3))])
	ok(bad_class.is_empty(), "§6: a census row carries no class this gate names: %s" % str(bad_class.slice(0, 3)))
	ok(broken.is_empty(), "§6: %d door calls do not hold their class at source — a figure printed or paid is not the blow that landed: %s" % [broken.size(), str(broken.slice(0, 3))])


# ── §2b — THE STRIKE ─────────────────────────────────────────────────────────

# One strike of `atk`'s basic on `w` under the same dice: [health it took, the figure it booked to the hero].
func _strike(s: Node, atk: BattleUnit, w: BattleUnit) -> Array:
	var slice: Dictionary = s.get("_run_slice")
	var key := "dmg_hero_" + atk.unit_name
	var booked0 := float(slice.get(key, 0.0))
	var hp0 := w.hp
	# An unspent Aegis Reversal rides the strike, added to its figure below the computation's cut: it lands cut as the blow does.
	atk.aegis_bonus = 40
	seed(4242)
	await s._resolve(atk, atk.abilities[0], w, "good")
	var lost := hp0 - w.hp
	var booked := float((s.get("_run_slice") as Dictionary).get(key, 0.0)) - booked0
	return [lost, int(round(booked))]


func _s2b_strike() -> void:
	print("\n§2b — a hero's strike on the rooted Warden: cut once, in its computation, and booked as it lands")
	var s1: Node = await _battle()
	var w1 := _warden(s1)
	var atk1: BattleUnit = (s1.get("heroes") as Array)[0]
	if w1 == null or atk1 == null:
		ok(false, "§2b: the fight fielded no Rootbound Warden or no hero")
		return
	ok(bool(s1.call("_rootbound_holds", w1)), "§2b: the first fight's grove does not stand")
	var rooted: Array = await _strike(s1, atk1, w1)
	ok(not w1.rootbound_precut, "§2b: the strike's mark outlived its door")
	# Read off the first fight before the second frees it.
	var share := w1.rootbound
	var who := atk1.unit_name
	var s2: Node = await _battle()
	var w2 := _warden(s2)
	var atk2: BattleUnit = (s2.get("heroes") as Array)[0]
	for e in _escort(s2, w2):
		_kill(e)
	ok(not bool(s2.call("_rootbound_holds", w2)), "§2b: the second fight's Warden does not stand alone")
	var alone: Array = await _strike(s2, atk2, w2)
	var want := int(round(int(alone[0]) * (1.0 - share)))
	print("    %s's basic: %d off the rooted Warden (booked %d), %d off the Warden alone" % [who, int(rooted[0]), int(rooted[1]), int(alone[0])])
	ok(int(alone[0]) > 0, "§2b: the strike on the Warden alone took nothing — the arm reads no blow")
	ok(absi(int(rooted[0]) - want) <= 2, "§2b: the strike took %d off the rooted Warden and %d off it alone — want about %d, the cut once" % [int(rooted[0]), int(alone[0]), want])
	ok(int(rooted[1]) == int(rooted[0]), "§2b: the strike booked %d to the hero and took %d off the rooted Warden — a figure paid off a blow is the blow that landed" % [int(rooted[1]), int(rooted[0])])
	print("    CHECKED one strike rooted and one alone under the same dice, the booked figure, the mark spent")


# ── §3 — THE CHIP ────────────────────────────────────────────────────────────

func _s3_chip() -> void:
	print("\n§3 — the chip: a display chip from the spawn, its figure off the body; it falls and returns with the warband")
	var s: Node = await _battle()
	var w := _warden(s)
	if w == null:
		ok(false, "§3: the fight fielded no Rootbound Warden")
		return
	var chip: Dictionary = w.display_chip("rootbound")
	ok(not chip.is_empty(), "§3: the spawned Warden wears no Rootbound chip with its warband standing")
	ok(not w.has_status("rootbound"), "§3: Rootbound is a status on the Warden — a dispel could take it")
	var want_tag := "-%d%%" % int(round(w.rootbound * 100.0))
	ok(String(chip.get("short", "")) == want_tag, "§3: the chip's tag is %s — want %s, read off the body" % [String(chip.get("short", "")), want_tag])
	ok(String(chip.get("desc", "")).contains("%d%%" % int(round(w.rootbound * 100.0))) and String(chip.get("desc", "")).contains("Alone"),
		"§3: the chip's words do not state the body's figure and what alone does: %s" % String(chip.get("desc", "")))
	var esc := _escort(s, w)
	_kill(esc[0])
	ok(w.has_display_chip("rootbound"), "§3: the chip fell with one of the warband still standing")
	_kill(esc[1])
	ok(not w.has_display_chip("rootbound"), "§3: the chip stands with the Warden alone")
	# THE TAG IS READ OFF THE BODY: the share moved while the chip is off, and the Raise lays it again with the new share.
	var ruled := w.rootbound
	w.rootbound = 0.3
	(esc[0] as BattleUnit).revive(0.5)
	ok(w.has_display_chip("rootbound"), "§3: the chip did not return when a body was Raised")
	ok(String(w.display_chip("rootbound").get("short", "")) == "-30%", "§3: at a 0.3 share the chip's tag reads %s — it is not read off the body" % String(w.display_chip("rootbound").get("short", "")))
	w.rootbound = ruled
	print("    CHECKED the spawn's chip, its tag and words, the fall on the last death, the return on a Raise")


# ── §4 — THE BOT ─────────────────────────────────────────────────────────────

func _s4_bot() -> void:
	print("\n§4 — the bot's mark passes over the Warden while another body stands (DV38)")
	var s: Node = await _battle()
	var w := _warden(s)
	if w == null:
		ok(false, "§4: the fight fielded no Rootbound Warden")
		return
	var foes: Array = (s.get("enemies") as Array).filter(func(e): return bool(s.call("_pickable", e)))
	var pool: Array = s.call("_bot_mark_pool", foes)
	ok(not pool.has(w) and pool.size() == foes.size() - 1, "§4: the bot's mark pool kept the rooted Warden: %s" % str(pool.map(func(e): return e.unit_name)))
	# The Warden made the lowest-health body, so a mark by health alone would take it: every hero's bot pick aims past it.
	w.hp = int(w.max_hp * 0.3)
	var aimed := 0
	for h in s.get("heroes"):
		var hu := h as BattleUnit
		if hu.is_companion or hu.dead:
			continue
		var pick: Array = s.call("_autoplay_pick", hu)
		if pick.size() >= 2 and pick[1] is BattleUnit and not (pick[1] as BattleUnit).is_hero:
			aimed += 1
			ok(pick[1] != w, "§4: %s's bot aimed %s at the rooted Warden at 30%% health" % [hu.unit_name, (pick[0] as Ability).display_name])
	ok(aimed >= 1, "§4: no hero's bot pick aimed at the warband — the arm reads nothing")
	# THE CLERIC's RUIN FOCUS, which ranks an unbroken boss first: past the rooted Warden while another stands.
	var esc4 := _escort(s, w)
	var rf: BattleUnit = s.call("_ruin_focus", foes, esc4[0])
	ok(w.is_boss and not w.broken and rf != w, "§4: the Ruin focus aimed at the rooted, unbroken Warden")
	for e in _escort(s, w):
		_kill(e)
	var alone: Array = (s.get("enemies") as Array).filter(func(e): return bool(s.call("_pickable", e)))
	var pool2: Array = s.call("_bot_mark_pool", alone)
	ok(pool2.size() == 1 and pool2[0] == w, "§4: alone, the bot's mark pool is not the Warden: %s" % str(pool2.map(func(e): return e.unit_name)))
	ok(s.call("_ruin_focus", alone, null) == w, "§4: alone, the Ruin focus does not take the unbroken Warden")
	print("    CHECKED the pool rooted and alone, and %d hero picks aimed past the Warden" % aimed)


# ── §5 — THE RECORD ──────────────────────────────────────────────────────────

func _s5_record() -> void:
	print("\n§5 — CLAUDE.md names the Warden built to the boss-strategy value")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var at := cm.find(BLOCK_HEAD)
	var end := cm.find("\n## ", at + 4) if at >= 0 else -1
	var block := cm.substr(at, end - at).replace("\n", " ") if at >= 0 and end > at else ""
	ok(block.length() > 500, "§5: CLAUDE.md's boss-strategy block is gone")
	var name := Enemies.unit_name(BOSS).to_upper()
	var built := false
	var owed := false
	for bullet in block.split(" - **"):
		# The markers read as written (`check_jw` §0's way); the name read case aside.
		var up := String(bullet).to_upper()
		if String(bullet).contains(BUILT_WORDS) and not String(bullet).contains(OWED_WORDS) and up.contains(name):
			built = true
		if String(bullet).contains(OWED_WORDS) and up.contains(name):
			owed = true
	ok(built, "§5: no bullet of the block names the %s built to the value" % name)
	ok(not owed, "§5: the %s is still named in a bullet marked owed" % name)
	print("    CHECKED the block: built %s, owed %s" % [str(built), str(owed)])


# ── §6 — THE PLAYER's FILES ──────────────────────────────────────────────────

func _s7_the_players_files() -> void:
	print("\n§7 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§7: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§7: %s was created" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
