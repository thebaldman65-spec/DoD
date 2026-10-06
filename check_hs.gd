# BATCH HS — CONJUNCTIONS: THE MECHANISM, AND ONE OF THEM.
#
# What this gate asserts, section by section (`docs/reports/HS.md` has the working):
#
#   §0  HR's rulings 2 and 3, built: no event stands in the run's first
#       `SHOP_GATE_NODES` nodes either — the first three teach combat — and every
#       board still holds its full count, later zones ungated; and the bargain does
#       not pay "a merchant follows the fight" at an elite in those nodes, while it
#       still can from the fourth on.
#   §1  `CLAUDE.md`'s two status rules that the code does not keep are corrected,
#       and the code facts they now state are driven: Burn re-applied ADDS its
#       turns, Chilled adds a stack and RESETS its clock, the default branch keeps
#       the larger.
#   §2  The mechanism. Two afflictions in `CONJUNCTIONS` meeting on one body make
#       one entry and one chip, in either order, and a pair not in the table does
#       nothing. COMPONENTS ARE PRESENCE (the readers that ask for Burn or Chilled
#       find them inside it). TIER IS WEIGHT (every breadth reader counts the
#       ingredients — the Trapper's strike is driven, ruptured and unmerged). The
#       NEGATIVE, hardest: the composition does not run its ingredients twice — one
#       Burn tick, one slow. The CLOCK is the shorter ingredient's, and the longer
#       stands alone when it ends. A CLEANSE takes it whole; a CONSUMER eating one
#       ingredient leaves the other. A RE-APPLIED ingredient runs its own rule.
#   §3  Rupture: its one figure pinned HERE and nowhere else (PROPOSED, the
#       designer's to tune), its chip not `BD`, its Break riding the Burn tick, and
#       the glossary's two entries carrying no copy of the figure.
#   §5  The log is the instrument: one ruptured body's whole conjunction log, read
#       out of a fight as it ran — it forms, a re-application, every tick with its
#       Burn and its Break apart, and how it ended — every name off the data.
#   §6  The bot does not choke on it: a fight with a Rupture standing runs to its
#       end on autoplay.
#
# What it cannot assert, said so it is not mistaken for coverage: whether the
# figure is right (that is the designer's play), and how often the bot makes one by
# accident (that is the report's sim reading, a property of the dice). `Run` is
# fetched off the tree, never named.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
# A Swordmaster, a Pyromancer (Overburn), a Holy and a Survivalist (Trapper): the
# fire card gates and the breadth engine are both seated, and no hero chills on his
# own, so every Chilled below is one the gate laid.
const PARTY := ["swordmaster", "pyromancer", "holy", "mystic"]
const SCRATCH_PROFILE := "user://hs_profile.json"
const SCRATCH_RELICS := "user://hs_relics.json"
const BOARD_SEED := 20261007
const BOARDS := 80
const OFFER_ROLLS := 300
const STRIKE_SEED := 4401
const FRAME_CAP := 30000
# THE ONE PIN ON RUPTURE'S FIGURE (HS §3): PROPOSED, and the designer tunes it from
# play. Every other arm in this gate reads `battle.RUPTURE_BREAK_PER_TICK`, and no
# other gate pins it — a tuning pass moves the constant and this line.
const RUPTURE_BREAK_PROPOSED := 10

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HS — CONJUNCTIONS: THE MECHANISM, AND ONE OF THEM")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s0_the_rulings()
	_s1_the_rules_file()
	await _s2_the_mechanism()
	await _s2c_tier_is_weight()
	await _s2e_the_clock()
	await _s2f_cleanse_and_consumer()
	await _s2g_reapplied()
	await _s3_rupture()
	await _s5_the_log()
	await _s6_the_bot()
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

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
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true


func _board(specs: Array = PARTY, opts: Dictionary = {}) -> Node:
	var o := {"deterministic": true}
	o.merge(opts, true)
	var scene: Node = await Gate.spawn(self, specs, o)
	return scene


func _hero(scene: Node, spec_name: String) -> BattleUnit:
	for h in scene.get("heroes"):
		if String((h as BattleUnit).unit_name).to_lower() == spec_name.to_lower():
			return h
	return null


# The top-level ids standing on a body, in order — one per chip.
func _ids(u: BattleUnit) -> Array:
	var out: Array = []
	for s in u.statuses:
		out.append(String(s.id))
	return out


func _burn(scene: Node, target: BattleUnit, src: BattleUnit, turns: int) -> void:
	scene.call("_apply_status", target, "burn", turns, 0, scene.call("_dot_tick", "burn", src), src)


func _chill(scene: Node, target: BattleUnit, src: BattleUnit, turns: int) -> void:
	scene.call("_apply_status", target, "chilled", turns, 0, 0, src)


func _clear(u: BattleUnit) -> void:
	u.statuses = []
	u._refresh_chips()


# The fixture parks the first hero's turn awaiting a pick; it is answered by hand
# BEFORE the bot takes over (GN §4's order, `check_go` §12's shape) — setting
# `autoplay` cannot reach a turn that is already waiting on a press. His basic, at
# a foe that is not `spare`.
func _answer_parked(scene: Node, spare: BattleUnit) -> void:
	var parked: BattleUnit = scene.get("current_hero")
	if parked == null:
		return
	var answer: Ability = parked.abilities[0]
	parked.cooldowns.clear()
	parked.resource = parked.max_resource
	scene.emit_signal("_ability_picked", answer)
	await process_frame
	var aim: BattleUnit = null
	for f in scene.get("enemies"):
		if not (f as BattleUnit).dead and f != spare:
			aim = f
	scene.emit_signal("_target_picked", aim if aim != null else spare)
	await process_frame


func _log_text(scene: Node) -> String:
	return String((scene.get("history") as RichTextLabel).get_parsed_text())


# A body carrying a Burn and a Chilled UNMERGED — two chips — built from entries the
# real door laid on two other bodies, so the twin differs from a ruptured body in
# nothing but the composing.
func _unmerged_twin(scene: Node, twin: BattleUnit, donor: BattleUnit, src_b: BattleUnit,
		src_c: BattleUnit, burn_turns: int, chill_turns: int) -> void:
	_clear(twin)
	_clear(donor)
	_burn(scene, twin, src_b, burn_turns)
	_chill(scene, donor, src_c, chill_turns)
	twin.statuses.append((donor.get_status("chilled") as Dictionary).duplicate(true))
	_clear(donor)
	twin._refresh_chips()


# ── §0 — HR's RULINGS 2 AND 3 ────────────────────────────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — HR's rulings 2 and 3, built")
	var gate_n: int = int(_run.SHOP_GATE_NODES)
	var gated: Array = _run.GATED_NODE_TYPES
	ok(gate_n == 3 and gated.size() == 3 and gated.has("event") and gated.has("merchant")
			and gated.has("blacksmith"),
		"§0a: the first %d nodes keep out %s — ruled: the trade nodes AND the events" % [gate_n, gated])
	var z1 := {}
	var short := PackedStringArray()
	var later_events := 0
	_new_run()
	for z in 3:
		for i in BOARDS:
			seed(BOARD_SEED + i + 1000 * z)
			_run.zone_idx = z
			_run._generate_map()
			var cnt := {}
			for slot in _run.map:
				for node in slot:
					var ty := String(node["type"])
					cnt[ty] = int(cnt.get(ty, 0)) + 1
			for ty2 in ["elite", "blacksmith", "merchant", "event"]:
				if int(cnt.get(ty2, 0)) != int(_run.NODE_COPIES[ty2]):
					short.append("zone %d board %d: %s %d" % [z + 1, i, ty2, int(cnt.get(ty2, 0))])
			for c in range(1, gate_n + 1):
				for node in _run.map[_run.column_slot(c)]:
					var ty3 := String(node["type"])
					if z == 0:
						z1[ty3] = int(z1.get(ty3, 0)) + 1
					elif ty3 == "event":
						later_events += 1
	print("    CHECKED %d boards a zone: zone 1's first %d columns held %s" % [BOARDS, gate_n, z1])
	ok(int(z1.get("event", 0)) == 0 and int(z1.get("merchant", 0)) == 0
			and int(z1.get("blacksmith", 0)) == 0,
		"§0a: zone 1's first %d columns held %s — no event, no Peddler, no Smith" % [gate_n, z1])
	ok(int(z1.get("fight", 0)) > 0 and int(z1.get("elite", 0)) > 0,
		"§0a: ...and those columns held no fights or no elites — the absence read nothing (%s)" % [z1])
	ok(short.is_empty(), "§0a: a board was dealt short of a kind: %s" % [short.slice(0, 4)])
	ok(later_events > 0, "§0a: no later zone put an event in its first %d columns in %d boards — the gate is the run's, not every zone's" % [gate_n, 2 * BOARDS])
	# §0b — THE BARGAIN'S BOUGHT MERCHANT: not offered at the first nodes; still
	# offered from the fourth on, and in a later zone's first nodes.
	_new_run()
	var shops := {}
	var sev4 := {}
	for z_slot in [[0, 0], [0, 1], [0, 2], [0, 3], [1, 1]]:
		_run.zone_idx = int(z_slot[0])
		_run.slot_idx = int(z_slot[1])
		seed(BOARD_SEED + 7 * int(z_slot[1]) + 100 * int(z_slot[0]))
		var key := "z%d c%d" % [int(z_slot[0]) + 1, int(z_slot[1]) + 1]
		shops[key] = 0
		sev4[key] = {}
		for _k in OFFER_ROLLS:
			for opt in _run.roll_offer():
				var kind := String((opt["reward"] as Dictionary).get("kind", ""))
				if kind == "shop":
					shops[key] = int(shops[key]) + 1
				if int(_run.modifier_severity(String(opt["modifier"]))) == 4:
					sev4[key][kind] = int(sev4[key].get(kind, 0)) + 1
	_run.zone_idx = 0
	_run.slot_idx = -1
	print("    the merchant reward over %d offers: %s" % [OFFER_ROLLS, shops])
	print("    what a severity-4 option paid: %s" % [sev4])
	ok(int(shops["z1 c1"]) == 0 and int(shops["z1 c2"]) == 0 and int(shops["z1 c3"]) == 0,
		"§0b: the bargain offered a merchant at the run's first nodes: %s" % [shops])
	ok(int(shops["z1 c4"]) > 0 and int(shops["z2 c2"]) > 0,
		"§0b: the bargain never offered a merchant from node 4 on, or in zone 2 — the gate took the reward away: %s" % [shops])
	ok(int((sev4["z1 c2"] as Dictionary).get("gold", 0)) > 0 and int((sev4["z1 c2"] as Dictionary).get("rune", 0)) > 0,
		"§0b: at a gated elite a severity-4 option did not pay its gold and its rune instead: %s" % [sev4["z1 c2"]])


# ── §1 — THE RULES FILE STATES THE STATUS RULES THE CODE KEEPS ─────────────────

func _s1_the_rules_file() -> void:
	print("\n§1 — CLAUDE.md's two status rules, corrected")
	var cl := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not cl.contains("Faith, Mercy, Burn, Chilled, Frenzy, Block"),
		"§1a: the engine list still names Burn and Chilled as engines exclusive to a class")
	ok(cl.contains("Overburn and Glacial Hold are the engines; Burn and Chilled are statuses"),
		"§1a: the engine list does not say Burn and Chilled are statuses any class can lay")
	ok(not cl.contains("`add_status` resolves a re-application as `max()` on duration and power"),
		"§1b: the recast block still says every re-application resolves as max()")
	ok(cl.contains("Burn ADDS its turns, Chilled adds a stack and RESETS its clock"),
		"§1b: the recast block does not state the two rules the code keeps")


# ── §2 — THE MECHANISM ──────────────────────────────────────────────────────

func _s2_the_mechanism() -> void:
	print("\n§2 — two afflictions meeting on one body make a third")
	var scene: Node = await _board()
	var conj: Dictionary = scene.CONJUNCTIONS
	var info: Array = (scene.STATUS_INFO as Dictionary).get("rupture", [])
	print("    the table: %s; the chip: %s" % [conj, info.slice(0, 2)])
	ok(conj.size() == 1 and conj.has("rupture") and (conj["rupture"] as Array).size() == 2
			and (conj["rupture"] as Array).has("burn") and (conj["rupture"] as Array).has("chilled"),
		"§2a: the table is not the one ruled row, Rupture of Burn and Chilled: %s" % [conj])
	var shorts := 0
	for sid in scene.STATUS_INFO:
		if String(scene.STATUS_INFO[sid][1]) == String(info[1]):
			shorts += 1
	ok(info.size() >= 3 and String(info[1]) != "BD" and shorts == 1,
		"§2a: Rupture's chip reads %s — it must be its own, and never BD (%d rows share it)" % [info.slice(0, 2), shorts])
	ok(BattleUnit.DEBUFF_IDS.has("rupture") and not (scene.DOT_STATUSES as Dictionary).has("rupture")
			and not (scene.DISPEL_NEVER as Array).has("rupture"),
		"§2a: Rupture is not an affliction a cleanse takes and a Dispel leaves, with no tick of its own")
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var foes: Array = scene.get("enemies")
	ok(pyro != null and sv != null and foes.size() == 3, "§2: the party or the warband is not the one this gate seats")
	if pyro == null or sv == null or foes.size() < 3:
		scene.queue_free()
		await process_frame
		return
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	# §2b — COMPOSING, BOTH ORDERS, AND A PAIR NOT IN THE TABLE.
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	_chill(scene, b, sv, 3)
	_burn(scene, b, pyro, 3)
	scene.call("_apply_poison", sv, c, 3)
	_burn(scene, c, pyro, 3)
	var ra: Dictionary = a.get_status("rupture")
	print("    burn then chill: %s; chill then burn: %s; poison and burn: %s" % [_ids(a), _ids(b), _ids(c)])
	ok(_ids(a) == ["rupture"] and _ids(b) == ["rupture"],
		"§2b: Burn and Chilled met and did not become one entry: %s, %s" % [_ids(a), _ids(b)])
	ok(ra.has("parts") and (ra["parts"] as Array).size() == 2 and BattleUnit.tier_of(ra) == 2,
		"§2b: the Rupture does not carry its two ingredients whole (tier %d)" % BattleUnit.tier_of(ra))
	var c_ids := _ids(c)
	c_ids.sort()
	ok(c_ids == ["burn", "poison"], "§2b: a pair not in the table composed: %s" % [c_ids])
	await process_frame
	var chips := 0
	for ch in a.get("_chips_root").get_children():
		if ch is ColorRect and not ch.is_queued_for_deletion():
			chips += 1
	ok(chips == 1, "§2b: a ruptured body draws %d chips — one, not three" % chips)
	# §2d — COMPONENTS ARE PRESENCE.
	ok(a.has_status("burn") and a.has_status("chilled") and a.status_stacks("chilled") == 1
			and String(a.get_status("burn").get("id", "")) == "burn"
			and int(a.get_status("burn").get("turns", 0)) == 3,
		"§2d: the Burn and the Chilled inside a Rupture are not read as standing")
	ok(String(a.get_status("burn").get("src_name", "")) == pyro.unit_name
			and String(a.get_status("chilled").get("src_name", "")) == sv.unit_name,
		"§2d: an ingredient lost who laid it")
	var burn_turns := 0
	for f in foes:
		burn_turns += maxi(int((f as BattleUnit).get_status("burn").get("turns", 0)), 0)
	ok(int(scene.call("_total_burn_turns")) == burn_turns and burn_turns == 9
			and int(scene.call("_burning_foe_count")) == 3,
		"§2d: Overburn's field reads %d burn-turns over %d bodies, want %d over 3" % [
			int(scene.call("_total_burn_turns")), int(scene.call("_burning_foe_count")), burn_turns])
	ok(bool(scene.call("_other_spec_debuff", a)), "§2d: Firedraw's deep case does not see the Chilled inside a Rupture")
	# THE FIRE GATES ARE ASKED OF A FIELD BURNING ONLY INSIDE RUPTURES: the third body's
	# Burn stands alone, and left there it would open every gate by itself (the S03 control
	# found that this arm read green with presence cut).
	_clear(c)
	ok(_ids(a) == ["rupture"] and _ids(b) == ["rupture"] and c.statuses.is_empty(),
		"§2d: the field is not burning only inside Ruptures (%s, %s, %s)" % [_ids(a), _ids(b), _ids(c)])
	pyro.resource = 999
	var opened := []
	for card in ["Wildfire", "Backdraft", "Funeral Pyre", "Firedraw", "Pyre Wake"]:
		var ab: Ability = Classes.pool_ability(card)
		if ab != null and bool(scene.call("_ability_usable", pyro, ab)):
			opened.append(card)
	print("    the fire gates open on a field burning only inside Ruptures: %s" % [opened])
	ok(opened.size() == 5, "§2d: a fire card's gate stayed shut with Burn standing inside a Rupture: %s" % [opened])
	# PYROBLAST STILL READS A BURNING TARGET: the same seed into a Rupture, its unmerged
	# twin and the same body clean, each held far from dying.
	var pb: Ability = Classes.pool_ability("Pyroblast")
	var pb_hits := []
	var pb_lines := []
	if pb != null:
		_unmerged_twin(scene, b, c, pyro, sv, 3, 3)
		for k in 3:
			var pt: BattleUnit = b if k == 1 else a
			if k == 2:
				_clear(a)
			pt.max_hp = 9999
			pt.hp = 9999
			pt.pressure = 0
			pyro.resource = 999
			pyro.cooldowns.clear()
			seed(STRIKE_SEED + 7)
			var pb_was := _log_text(scene).length()
			Engine.time_scale = 50.0
			await scene.call("_resolve", pyro, pb, pt, "good")
			Engine.time_scale = 1.0
			pb_hits.append(9999 - pt.hp)
			pb_lines.append(_log_text(scene).substr(pb_was).contains("Pyroblast lands on burning flesh"))
	print("    Pyroblast: into a Rupture %s, its unmerged twin %s, the same body clean %s" % [
		pb_hits[0] if pb_hits.size() > 0 else "?", pb_hits[1] if pb_hits.size() > 1 else "?",
		pb_hits[2] if pb_hits.size() > 2 else "?"])
	ok(pb_hits.size() == 3 and int(pb_hits[0]) == int(pb_hits[1]) and int(pb_hits[2]) > 0
			and int(pb_hits[0]) > int(pb_hits[2]) and pb_lines == [true, true, false],
		"§2d: Pyroblast's burning-target term does not read the Burn inside a Rupture: %s %s" % [pb_hits, pb_lines])
	# THE PAIRED NEGATIVE OF THE GATES: with nothing alight they stay shut.
	_clear(a)
	_clear(b)
	_clear(c)
	var shut := 0
	for card2 in ["Wildfire", "Backdraft", "Funeral Pyre", "Firedraw", "Pyre Wake"]:
		var ab2: Ability = Classes.pool_ability(card2)
		if ab2 != null and not bool(scene.call("_ability_usable", pyro, ab2)):
			shut += 1
	ok(shut == 5, "§2d: with nothing alight %d of the five fire gates were shut — the arm above read nothing" % shut)
	# §2 — THE NEGATIVE, HARDEST: THE COMPOSITION DOES NOT RUN ITS INGREDIENTS TWICE.
	# One Burn tick, the same as the unmerged twin's, and the Break beside it; one slow.
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	_unmerged_twin(scene, b, c, pyro, sv, 3, 3)
	print("    ruptured: %s   unmerged twin: %s" % [_ids(a), _ids(b)])
	ok(_ids(a) == ["rupture"] and _ids(b).size() == 2, "§2: the ruptured body or its unmerged twin is not what this arm needs")
	ok(is_equal_approx(a.effective_speed(), b.effective_speed()) and a.effective_speed() < float(a.speed),
		"§2: the Chilled inside a Rupture slows %.2f, the unmerged twin %.2f — once each" % [
			a.effective_speed(), b.effective_speed()])
	var log_was := _log_text(scene).length()
	var hp_a := a.hp
	var pr_a := a.pressure
	var hp_b := b.hp
	var pr_b := b.pressure
	Engine.time_scale = 50.0
	await scene.call("_dot_pass", a)
	var said := _log_text(scene).substr(log_was)
	await scene.call("_dot_pass", b)
	Engine.time_scale = 1.0
	var tick_a := hp_a - a.hp
	var tick_b := hp_b - b.hp
	print("    one pass: ruptured -%d HP +%d Break; unmerged -%d HP +%d Break" % [
		tick_a, a.pressure - pr_a, tick_b, b.pressure - pr_b])
	ok(tick_a > 0 and tick_a == tick_b,
		"§2: a ruptured body took %d from its Burn's tick, the unmerged twin %d — the Burn ticks ONCE" % [tick_a, tick_b])
	ok(a.pressure - pr_a > 0 and b.pressure == pr_b,
		"§2: the Break rode the wrong tick (ruptured +%d, unmerged +%d)" % [a.pressure - pr_a, b.pressure - pr_b])
	var plain_lines := said.count("%s takes" % a.unit_name)
	ok(said.count("%s's %s ticks — the %s" % [a.unit_name, String(info[0]), String(scene.STATUS_INFO["burn"][0])]) == 1
			and said.count("%s's %s ticks — the Break" % [a.unit_name, String(info[0])]) == 1
			and plain_lines == 0,
		"§2: the ruptured body's pass did not log ONE tick, its Burn and its Break apart (%d plain lines)" % plain_lines)
	# AND ON A BROKEN BODY THE BREAK HALF IS SKIPPED, AND THE LOG SAYS SO (Decay's shape:
	# a Broken body takes no Break). Broken through the live door, then one pass more.
	a.take_hit(0, 999)
	ok(a.broken, "§2: the ruptured body would not Break — the Broken arm below reads nothing")
	var hp_k := a.hp
	var pr_k := a.pressure
	var log_k := _log_text(scene).length()
	Engine.time_scale = 50.0
	await scene.call("_dot_pass", a)
	Engine.time_scale = 1.0
	var said_k := _log_text(scene).substr(log_k)
	print("    broken: -%d HP +%d Break; %s" % [hp_k - a.hp, a.pressure - pr_k,
		"the Break's line says it is Broken" if said_k.contains("the Break: none") else "no Break line"])
	ok(hp_k - a.hp > 0 and a.pressure == pr_k and said_k.count("the Break: none, while %s is Broken" % a.unit_name) == 1
			and not said_k.contains("+%d Break damage" % int(scene.RUPTURE_BREAK_PER_TICK)),
		"§2: on a Broken body the Rupture's Burn did not tick alone, or its log did not say why no Break landed")
	scene.queue_free()
	await process_frame


# ── §2c — TIER IS WEIGHT ────────────────────────────────────────────────────

func _s2c_tier_is_weight() -> void:
	print("\n§2c — every breadth reader counts a tier-2 as two")
	var scene: Node = await _board()
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var foes: Array = scene.get("enemies")
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var c: BattleUnit = foes[2]
	ok(a.enemy_kind == b.enemy_kind, "§2c: the two bodies this section compares are not one kind (%s, %s)" % [a.enemy_kind, b.enemy_kind])
	_clear(a)
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	_unmerged_twin(scene, b, c, pyro, sv, 3, 3)
	_clear(c)
	_burn(scene, c, pyro, 3)
	var rows := [
		["_status_count", int(scene.call("_status_count", a)), int(scene.call("_status_count", b))],
		["count_debuffs", a.count_debuffs(), b.count_debuffs()],
		["_harvest_yield", int(scene.call("_harvest_yield", a)), int(scene.call("_harvest_yield", b))],
	]
	for r in rows:
		print("    %-15s ruptured %d   unmerged %d" % r)
		ok(int(r[1]) == 2 and int(r[2]) == 2, "§2c: %s reads a Rupture as %d, its unmerged twin as %d — want two and two" % r)
	# The field's unique afflictions (Pleasure from Pain): a Rupture beside a lone
	# Burn is Burn and Chilled, two, never three.
	ok(int(scene.call("_unique_enemy_debuffs")) == 2,
		"§2c: the field's unique afflictions read %d — want Burn and Chilled, two" % int(scene.call("_unique_enemy_debuffs")))
	# THE TRAPPER, DRIVEN: the Survivalist's own strike, the same seed into each body,
	# and every body the same kind — a ruptured one, its unmerged twin, then the
	# ruptured one again carrying a lone Burn (armor differs between kinds, and a
	# comparison across kinds reads the armor, not the breadth).
	var basic: Ability = sv.abilities[0]
	var hits := []
	for k in 3:
		var tu: BattleUnit = b if k == 1 else a
		if k == 2:
			_clear(a)
			_burn(scene, a, pyro, 3)
		var was := tu.hp
		seed(STRIKE_SEED)
		Engine.time_scale = 50.0
		await scene.call("_resolve", sv, basic, tu, "good")
		Engine.time_scale = 1.0
		hits.append(was - tu.hp)
	print("    the Trapper's %s: ruptured %d, unmerged %d, a lone Burn %d" % [basic.display_name, hits[0], hits[1], hits[2]])
	ok(int(hits[0]) == int(hits[1]) and int(hits[0]) > int(hits[2]) and int(hits[2]) > 0,
		"§2c: the Trapper paid a Rupture %d, its unmerged twin %d and a lone Burn %d — a tier-2 must be two" % hits)
	scene.queue_free()
	await process_frame


# ── §2e — THE CLOCK ─────────────────────────────────────────────────────────

func _s2e_the_clock() -> void:
	print("\n§2e — the shorter ingredient's clock, and the longer stands alone after it")
	var scene: Node = await _board()
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var foes: Array = scene.get("enemies")
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var lname := String(scene.STATUS_INFO["rupture"][0])
	_clear(a)
	_burn(scene, a, pyro, 2)
	_chill(scene, a, sv, 3)
	var r: Dictionary = a.get_status("rupture")
	ok(BattleUnit.composition_turns(r) == 2 and int(r.get("turns", 0)) == 2,
		"§2e: Burn 2 and Chilled 3 made a clock of %d — want the shorter, 2" % int(r.get("turns", 0)))
	var log_was := _log_text(scene).length()
	a.tick_statuses()
	ok(_ids(a) == ["rupture"] and int(a.get_status("rupture").get("turns", 0)) == 1,
		"§2e: one turn on, the Rupture is not standing at 1 (%s)" % [_ids(a)])
	a.tick_statuses()
	var said := _log_text(scene).substr(log_was)
	print("    after two turns: %s, Chilled %d turn(s) left" % [_ids(a), int(a.get_status("chilled").get("turns", 0))])
	ok(_ids(a) == ["chilled"] and int(a.get_status("chilled").get("turns", 0)) == 1 and a.status_stacks("chilled") == 1,
		"§2e: when the Burn ran out the Chilled did not stand alone with its own last turn (%s)" % [_ids(a)])
	ok(said.contains("%s ends on %s — the clock: its Burn ran out; Chilled stands alone (1 turn)" % [lname, a.unit_name]),
		"§2e: the clock's end was not logged with what ran out and what stands")
	# THE OTHER INGREDIENT SHORTER: Chilled 2, Burn 4 — the Burn keeps its own two.
	_clear(b)
	_chill(scene, b, sv, 2)
	_burn(scene, b, pyro, 4)
	b.tick_statuses()
	b.tick_statuses()
	ok(_ids(b) == ["burn"] and int(b.get_status("burn").get("turns", 0)) == 2,
		"§2e: when the Chilled ran out the Burn did not keep its own two turns (%s)" % [_ids(b)])
	# A SLOW BURN HOLDS THE BURN'S OWN CLOCK INSIDE THE RUPTURE: the Chilled ends it.
	_clear(b)
	_burn(scene, b, pyro, 2)
	_chill(scene, b, sv, 3)
	b.burn_clock_held = true
	b.tick_statuses()
	b.tick_statuses()
	b.burn_clock_held = false
	ok(_ids(b) == ["rupture"] and int(b.get_status("burn").get("turns", 0)) == 2
			and int(b.get_status("chilled").get("turns", 0)) == 1,
		"§2e: a held Burn's clock moved inside the Rupture, or the Chilled's did not (%s)" % [_ids(b)])
	scene.queue_free()
	await process_frame
	# A PERMANENT CHILL (the Cryomancer's Glacial Hold): the clock is the Burn's.
	var cscene: Node = await _board(["swordmaster", "cryomancer", "holy", "mystic"])
	var cryo := _hero(cscene, "Cryomancer")
	var cfoes: Array = cscene.get("enemies")
	var e: BattleUnit = cfoes[0]
	_clear(e)
	_chill(cscene, e, cryo, 3)
	_burn(cscene, e, cryo, 2)
	ok(_ids(e) == ["rupture"] and int(e.get_status("chilled").get("turns", 0)) < 0
			and int(e.get_status("rupture").get("turns", 0)) == 2,
		"§2e: a permanent Chilled and a 2-turn Burn made a clock of %d — want the Burn's, 2" % int(e.get_status("rupture").get("turns", 0)))
	e.tick_statuses()
	e.tick_statuses()
	ok(_ids(e) == ["chilled"] and int(e.get_status("chilled").get("turns", 0)) < 0,
		"§2e: the permanent Chilled did not stand alone, permanent, when the Burn ran out (%s)" % [_ids(e)])
	cscene.queue_free()
	await process_frame


# ── §2f — A CLEANSE TAKES IT WHOLE; A CONSUMER EATS ONE INGREDIENT ─────────────

func _s2f_cleanse_and_consumer() -> void:
	print("\n§2f — a cleanse takes it whole; a consumer eats one ingredient")
	var scene: Node = await _board()
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var holy := _hero(scene, "Holy")
	var foes: Array = scene.get("enemies")
	var a: BattleUnit = foes[0]
	var b: BattleUnit = foes[1]
	var lname := String(scene.STATUS_INFO["rupture"][0])
	# A HERO'S RUPTURE (the Hoarfrost bargain and an Ashblade's Burn): an enemy's
	# Burn and a Chilled with no hero behind it, as the bargain lays.
	var war := _hero(scene, "Swordmaster")
	_clear(war)
	scene.call("_apply_status", war, "burn", 2, 0, scene.call("_dot_tick", "burn", a), a)
	scene.call("_apply_status", war, "chilled", 3, 0, 0, null)
	ok(_ids(war) == ["rupture"], "§2f: a hero carrying an enemy's Burn and the bargain's Chilled did not compose: %s" % [_ids(war)])
	war.battle_turn = int(BattleUnit._sanctity_turn) + 1
	var ev0 := int(BattleUnit.sanctity_events)
	var lifted := war.dispel_one_debuff()
	ok(lifted == lname and not war.has_status("burn") and not war.has_status("chilled") and war.statuses.is_empty(),
		"§2f: one cleanse took '%s' and left %s — it must take the composition whole" % [lifted, _ids(war)])
	ok(int(BattleUnit.sanctity_events) - ev0 == 2,
		"§2f: a Rupture lifted booked %d Sanctity events — its two ingredients, as two chips would" % (int(BattleUnit.sanctity_events) - ev0))
	# The cleanse that hands back what it took hands back ONE entry, both inside it —
	# and Returned Burden casts the ingredients, never a bare composed id.
	scene.call("_apply_status", war, "burn", 2, 0, scene.call("_dot_tick", "burn", a), a)
	scene.call("_apply_status", war, "chilled", 3, 0, 0, null)
	war.battle_turn = int(BattleUnit._sanctity_turn) + 1
	var taken: Array = war.purge_debuffs_taken()
	ok(taken.size() == 1 and String(taken[0].get("id", "")) == "rupture"
			and ((taken[0] as Dictionary).get("parts", []) as Array).size() == 2 and war.statuses.is_empty(),
		"§2f: the purge handed back %d entries — want the Rupture, whole" % taken.size())
	for f in foes:
		_clear(f)
	scene.call("_return_burden", holy, war, taken)
	var bare := 0
	var carried := 0
	for f2 in foes:
		for s in (f2 as BattleUnit).statuses:
			if String(s.id) == "rupture" and not (s as Dictionary).has("parts"):
				bare += 1
		if (f2 as BattleUnit).has_status("burn") or (f2 as BattleUnit).has_status("chilled"):
			carried += 1
	ok(bare == 0 and carried >= 1 and a.has_status("burn"),
		"§2f: Returned Burden cast a bare composed status (%d), or did not send the Burn back to the Ashblade-shaped foe who laid it" % bare)
	# A CONSUMER EATS THE BURN: the Chilled stands alone, its stacks kept.
	_clear(b)
	_burn(scene, b, pyro, 3)
	_chill(scene, b, sv, 3)
	_chill(scene, b, sv, 3)
	var log_was := _log_text(scene).length()
	# Sanctity's ledger dedupes (body, status) inside a turn, and the Burn LANDED
	# on this body this turn: the removal is read on a later one.
	b.battle_turn = int(BattleUnit._sanctity_turn) + 1
	var ev1 := int(BattleUnit.sanctity_events)
	b.remove_status("burn")
	ok(_ids(b) == ["chilled"] and b.status_stacks("chilled") == 2,
		"§2f: the Burn eaten out of a Rupture did not leave the Chilled alone at x2: %s" % [_ids(b)])
	ok(int(BattleUnit.sanctity_events) - ev1 == 1, "§2f: a consumer eating one ingredient booked %d events — want one" % (int(BattleUnit.sanctity_events) - ev1))
	ok(_log_text(scene).substr(log_was).contains("%s ends on %s — a consumer: its Burn is consumed; Chilled stands alone" % [lname, b.unit_name]),
		"§2f: the consumer's end was not logged")
	# A LIVE CONSUMER: Detonation takes the Burn and pays for it; the Chilled stays.
	_clear(b)
	_burn(scene, b, pyro, 3)
	_chill(scene, b, sv, 3)
	pyro.resource = 999
	var det: Ability = Classes.pool_ability("Detonation")
	if det != null:
		Engine.time_scale = 50.0
		await scene.call("_resolve", pyro, det, b, "good")
		Engine.time_scale = 1.0
		ok(not b.dead and _ids(b) == ["chilled"], "§2f: Detonation on a Rupture did not leave the Chilled standing alone: %s" % [_ids(b)])
	else:
		ok(false, "§2f: no Detonation to drive")
	scene.queue_free()
	await process_frame


# ── §2g — A RE-APPLIED INGREDIENT RUNS ITS OWN RULE ───────────────────────────

func _s2g_reapplied() -> void:
	print("\n§2g — a re-applied ingredient runs its own rule; the clock follows")
	var scene: Node = await _board()
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var foes: Array = scene.get("enemies")
	var a: BattleUnit = foes[0]
	var p: BattleUnit = foes[1]
	var lname := String(scene.STATUS_INFO["rupture"][0])
	# The two rules §1 now states, on a body standing alone: Burn adds, Chilled resets.
	_clear(p)
	_burn(scene, p, pyro, 3)
	p.tick_statuses()
	_burn(scene, p, pyro, 3)
	var b_alone := int(p.get_status("burn").get("turns", 0))
	_clear(p)
	_chill(scene, p, sv, 3)
	p.tick_statuses()
	_chill(scene, p, sv, 3)
	var c_alone := int(p.get_status("chilled").get("turns", 0))
	var c_stacks := p.status_stacks("chilled")
	_clear(p)
	scene.call("_apply_status", p, "exposed", 3, 0, 0, sv)
	p.tick_statuses()
	scene.call("_apply_status", p, "exposed", 1, 0, 0, sv)
	var x_alone := int(p.get_status("exposed").get("turns", 0))
	print("    alone: Burn 3, a turn, 3 more -> %d; Chilled 3, a turn, 3 more -> %d (x%d); Exposed 3, a turn, 1 more -> %d" % [b_alone, c_alone, c_stacks, x_alone])
	ok(b_alone == 5, "§1: a Burn re-applied did not ADD its turns (%d, want 5)" % b_alone)
	ok(c_alone == 3 and c_stacks == 2, "§1: a Chilled re-applied did not add a stack and RESET its clock (%d turns x%d)" % [c_alone, c_stacks])
	ok(x_alone == 2, "§1: the default branch did not keep the larger duration (%d, want 2)" % x_alone)
	# INSIDE A RUPTURE: the same two rules on the ingredient, the clock the shorter.
	_clear(a)
	_burn(scene, a, pyro, 2)
	_chill(scene, a, sv, 3)
	var log_was := _log_text(scene).length()
	_burn(scene, a, pyro, 3)
	var r_burn := int(a.get_status("burn").get("turns", 0))
	var r_clock := int(a.get_status("rupture").get("turns", 0))
	ok(_ids(a) == ["rupture"] and r_burn == 5 and r_clock == 3,
		"§2g: Burn re-applied inside a Rupture read Burn %d, clock %d — want its turns ADDED (5) and the clock the Chilled's (3)" % [r_burn, r_clock])
	a.tick_statuses()
	_chill(scene, a, sv, 3)
	var r_chill := int(a.get_status("chilled").get("turns", 0))
	ok(_ids(a) == ["rupture"] and a.status_stacks("chilled") == 2 and r_chill == 3
			and int(a.get_status("rupture").get("turns", 0)) == 3,
		"§2g: Chilled re-applied inside a Rupture read x%d, %d turns — want a stack added and its clock RESET (x2, 3)" % [a.status_stacks("chilled"), r_chill])
	# A CARD THAT WRITES THE INGREDIENT'S CLOCK DIRECTLY (Flamewave on a burning body,
	# a skim) moves the composition's clock, and the log says so beside the card's line.
	var direct_was := int(a.get_status("burn").get("turns", 0))
	a.update_status("burn", String(scene.STATUS_INFO["burn"][1]), String(scene.STATUS_INFO["burn"][3]), -1, direct_was + 2)
	var said := _log_text(scene).substr(log_was)
	ok(said.contains("Burn inside %s's %s: its turns %d → %d; %s" % [a.unit_name, lname, direct_was, direct_was + 2, lname]),
		"§2g: a card writing the Burn's clock inside a Rupture went unlogged")
	ok(said.contains("%s's Burn re-applied inside %s's %s: its own rule — its turns 2 → 5; %s 3 turn" % [pyro.unit_name, a.unit_name, lname, lname])
			and said.contains("%s's Chilled re-applied inside %s's %s: its own rule — x1 → x2, its clock reset to 3" % [sv.unit_name, a.unit_name, lname]),
		"§2g: a re-application inside the Rupture was not logged with what its own rule did")
	scene.queue_free()
	await process_frame


# ── §3 — RUPTURE ────────────────────────────────────────────────────────────

func _s3_rupture() -> void:
	print("\n§3 — Rupture: its one figure, its chip, its words")
	var scene: Node = await _board()
	var fig := int(scene.RUPTURE_BREAK_PER_TICK)
	print("    Rupture's Break a tick: %d" % fig)
	# THE PIN. PROPOSED, flagged and not tuned — the designer's from play.
	ok(fig == RUPTURE_BREAK_PROPOSED,
		"§3a: Rupture's Break a tick is %d — PROPOSED at HS §3 as %d; a tuning pass moves this pin and the constant, nothing else" % [fig, RUPTURE_BREAK_PROPOSED])
	ok(int((scene.TICK_BREAK as Dictionary).get("rupture", 0)) == fig,
		"§3a: the tick's table does not read the one constant")
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var a: BattleUnit = scene.get("enemies")[0]
	_clear(a)
	_burn(scene, a, pyro, 3)
	_chill(scene, a, sv, 3)
	var desc := String(a.get_status("rupture").get("desc", ""))
	print("    the chip's words:\n      %s" % desc.replace("\n", "\n      "))
	ok(desc.contains("Each Burn tick also deals %d Break damage." % fig) and desc.contains("tier 2"),
		"§3b: the chip does not carry the figure computed off the constant, or its tier")
	var longest := 0
	for ln in desc.split("\n"):
		longest = maxi(longest, String(ln).length())
	ok(longest <= 44, "§3b: a line of the chip's words is %d characters — the tooltip does not wrap" % longest)
	# THE GLOSSARY: the rule and the recipe, in a player's words — and NO COPY OF THE
	# FIGURE, which the designer is about to move.
	var rule: Dictionary = Glossary.entry("conjunctions")
	var rec: Dictionary = Glossary.entry("status_rupture")
	ok(not rule.is_empty() and not rec.is_empty() and String(rule.get("retired", "")) == ""
			and String(rec.get("retired", "")) == "" and String(rec.get("category", "")) == "statuses",
		"§3c: the glossary does not carry the conjunction rule and the Rupture entry")
	ok(Glossary.status_short("rupture") != "", "§3c: the Rupture chip finds no glossary line")
	var digits := 0
	var rx := RegEx.create_from_string("[0-9]")
	for e in [rule, rec]:
		digits += rx.search_all(String(e.get("short", "")) + " " + String(e.get("long", ""))).size()
	ok(digits == 0, "§3c: the glossary's conjunction entries carry %d digits — the figure is computed on the chip, never authored" % digits)
	ok((rule.get("see_also", []) as Array).has("status_rupture") and (rec.get("see_also", []) as Array).has("conjunctions"),
		"§3c: the rule and the recipe do not point at each other")
	scene.queue_free()
	await process_frame


# ── §5 — THE LOG IS THE INSTRUMENT ──────────────────────────────────────────

# One body's whole conjunction log out of a fight as it runs: formed and re-applied
# by hand on a foe nothing can kill, then the turns come round on their own — each
# tick logged by the DoT pass, and the end by the clock. Enemies act on no one, so
# the only hands on it are the gate's and the heroes' autoplay, none of whom eats a
# Burn or lays a Chilled in this party.
func _s5_the_log() -> void:
	print("\n§5 — the conjunction log, out of a running fight")
	var scene: Node = await _board(["berserker", "arcanist", "inquisitor", "beastmaster"])
	var heroes: Array = scene.get("heroes")
	var foes: Array = scene.get("enemies")
	var mark: BattleUnit = foes[0]
	mark.max_hp = 99999
	mark.hp = 99999
	_clear(mark)
	var lname := String(scene.STATUS_INFO["rupture"][0])
	var from := _log_text(scene).length()
	_burn(scene, mark, heroes[1], 2)
	_chill(scene, mark, heroes[3], 3)
	_burn(scene, mark, heroes[1], 2)
	await _answer_parked(scene, mark)
	OS.set_environment("DOD_AUTOPLAY", "1")
	scene.set("autoplay", true)
	var frames := 0
	while frames < FRAME_CAP and not _log_text(scene).substr(from).contains("%s ends on %s" % [lname, mark.unit_name]) \
			and not bool(scene.get("battle_over")):
		await Gate.frames(self, 20)
		frames += 20
	OS.set_environment("DOD_AUTOPLAY", "")
	scene.set("autoplay", false)
	var lines: Array = []
	for ln in _log_text(scene).substr(from).split("\n"):
		if ln.contains(lname) or ln.contains("re-applied inside"):
			lines.append(String(ln).strip_edges())
	print("    %d frames; %s's conjunction log:" % [frames, mark.unit_name])
	for ln2 in lines:
		print("      " + ln2)
	var forms := -1
	var reapp := -1
	var ends := -1
	var burns := 0
	var breaks := 0
	for i in lines.size():
		var l3 := String(lines[i])
		if forms < 0 and l3.contains("%s forms on %s" % [lname, mark.unit_name]):
			forms = i
		if reapp < 0 and l3.contains("re-applied inside %s's %s" % [mark.unit_name, lname]):
			reapp = i
		if l3.contains("%s's %s ticks — the Burn" % [mark.unit_name, lname]):
			burns += 1
		if l3.contains("%s's %s ticks — the Break" % [mark.unit_name, lname]):
			breaks += 1
		if ends < 0 and l3.contains("%s ends on %s" % [lname, mark.unit_name]):
			ends = i
	ok(forms >= 0 and reapp > forms and ends > reapp,
		"§5: the log did not read forms, re-applied, ends in that order (%d, %d, %d)" % [forms, reapp, ends])
	ok(burns == 3 and breaks == 3,
		"§5: the Rupture ticked %d times for its Burn and %d for its Break — want its three turns, each with both" % [burns, breaks])
	ok(ends >= 0 and String(lines[ends]).contains("the clock: its Chilled ran out; Burn stands alone (1 turn)"),
		"§5: the end did not say the clock ran its Chilled out and the Burn stands on (%s)" % (String(lines[ends]) if ends >= 0 else "none"))
	ok(lines.size() >= 1 and String(lines[forms if forms >= 0 else 0]).contains("lands on its Burn — tier 2, 2 turns (the Burn's, the shorter)"),
		"§5: the forming line does not say what landed on what, its tier, its clock and whose clock it took")
	scene.queue_free()
	await process_frame


# ── §6 — THE BOT DOES NOT CHOKE ─────────────────────────────────────────────

# A real fight on autoplay with the enemies acting, a Rupture standing on one of
# them from the first turn: it must run to its end. What the bot DOES there is
# printed (the report reads it); that it finishes is asserted.
func _s6_the_bot() -> void:
	print("\n§6 — the bot fights a field with a Rupture on it, to the end")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	var scene: Node = await _board(PARTY, {"deterministic": false})
	scene.set("debug_enemies_off", false)
	var pyro := _hero(scene, "Pyromancer")
	var sv := _hero(scene, "Survivalist")
	var foes: Array = scene.get("enemies")
	var lname := String(scene.STATUS_INFO["rupture"][0])
	_burn(scene, foes[0], pyro, 3)
	_chill(scene, foes[0], sv, 3)
	ok(_ids(foes[0]).has("rupture"), "§6: the Rupture the bot is handed did not form")
	var from := _log_text(scene).length()
	await _answer_parked(scene, null)
	OS.set_environment("DOD_AUTOPLAY", "1")
	scene.set("autoplay", true)
	var frames := 0
	while frames < FRAME_CAP and not bool(scene.get("battle_over")):
		await Gate.frames(self, 20)
		frames += 20
	OS.set_environment("DOD_AUTOPLAY", "")
	scene.set("autoplay", false)
	var said := _log_text(scene).substr(from)
	print("    %d frames; battle over: %s; %d Rupture lines, %d formed" % [frames,
		bool(scene.get("battle_over")), said.count(lname), said.count("%s forms on" % lname)])
	for ln in said.split("\n"):
		if ln.contains(lname):
			print("      " + String(ln).strip_edges())
	ok(bool(scene.get("battle_over")), "§6: a fight with a Rupture standing did not reach its end in %d frames" % FRAME_CAP)
	scene.queue_free()
	await process_frame


# ── §9 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
