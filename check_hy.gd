# BATCH HY — THE ATTRIBUTION FRAME, PUT BACK.
#
# The frame (`battle._dmg_frame`) names who is dealing the damage landing now, and since HF it decides
# damage: Vow of Silence refuses what it credits to a vowed hero, Penance bills the dealer it names, the
# rule engines pay and mark off it, the Reaver counts kills by it, and the recap books by it. HX §4 drove
# it wrong in two shapes; this gate is the drive HX specified, built for real.
#
#   §1  THE VOW'S CARRIED HALF IS THE RAIDER'S DAMAGE ON A SECOND BODY (re-tuned at HZ §0.1, the designer's ruling
#       on HY's first). An Orc Raider's own Slash on a Warden on the Devout's Consecrated Ground, the Survivalist's
#       Tripwire up, Penance on the raider from the Pyromancer — three blows an arm, the vow's share and the Devout's
#       Vow of Silence each on and off. In every arm, every blow: the frame after is the raider's own Slash; the
#       raider loses EXACTLY the mirror on what each body lost — the whole blow between the two — the wire on the
#       whole blow, and the reflect unless its layer wears the vow; the recap books the Warden's wound and the
#       Devout's carried half to the raider, and the wire to the Tripwire.
#   §2  THE SPRINGS AT A TURN START — Snare Line's and the Deadfall's, each called as the turn loop calls it,
#       after a real action: an enemy's Slash, the Devout's Smite with his vow, and without. The same roll in
#       every arm, never silenced, booked to the layer under the trap's name, and the frame put back.
#   §3  THE DETONATION AND THE BOMB. A Ruin detonation is the Occultist's whoever acted last (his vow
#       silences it either way); a bomb is the pouch's (no vow blanks it, no ledger books it).
#   §4  THE OTHER CALLBACKS, AND THE KILLING COLD — Rite of Return, Bloodbond, Bear the Brunt, Blight the Well
#       and the rune's own bite each put the frame back; the Killing Cold's cast is booked under the cast and
#       the Weaver's repeat sees it.
#   §5  THE RETALIATIONS INSIDE AN ENEMY'S SWING ARE THEIR OWNERS' (GO's and HF's items): the Tripwire and the
#       Whole Forest lay the Tracker's mark, Feint, Mirror Guard and Spite credit the Reaver's kill, and the
#       Consecrated Ground reflect judges for the Arbiter — and its layer's own vow silences it.
#   §6  THE CENSUS, HELD. Every function of the game that deals damage is a known one, with what frame it
#       deals under; every borrowed frame is put back; every out-of-action site sets its own.
#   §7  THE RULE, WHERE A FIGHT'S RULES LIVE (`docs/combat-rules.md`), and the retirement doctrine HY §4 read off
#       twenty batches' practice, recorded where the instrument rules live.
#   §9  The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §6 reads the source, so it holds the SHAPE — a damage site a
# batch adds reds until its frame is said — and not whether the frame it names is the right owner; that is
# the drives' work, and they reach the sites listed above and no others. `Run` is fetched off the tree.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_hy.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://hy_profile.json"
const SCRATCH_RELICS := "user://hy_relics.json"
const SPECS := ["warden", "pyromancer", "inquisitor", "mystic"]
const SEED := 4242
const SPRING_SEED := 99
const PENANCE_POWER := 50

# §6 — EVERY FUNCTION OF THE GAME THAT DEALS DAMAGE, AND WHAT FRAME IT DEALS UNDER. Derived from the source
# and held here: a function not on this table that calls `take_hit` or `take_tick_damage` reds until its
# frame is said; one that has gone prints a notice. The class decides what §6 asks of its body:
#   BORROWS  — deals inside another unit's action under its own frame, and must put the one it found back;
#   OWN      — deals outside every action, and must set a frame before it deals;
#   CALLER   — sets none; every caller that makes it deal sets the frame;
#   ACTION   — deals inside its dealer's own action, under the frame that action set;
#   BREAK    — deals Break and no health, so no reader of the frame is reached;
#   DEALER   — deals under the frame of the wound it carries, by design.
const DAMAGE_FUNCS := {
	"battle.gd::_dot_pass": "OWN — a tick at its bearer's turn start; the frame names the status's applier (BL §2)",
	"battle.gd::_run_battle": "BREAK — Decay, Entropy and Cold Snap take Break and no health",
	"battle.gd::_player_turn": "ACTION — Entropy's Toll, the hero's own price after his own action (no writer of its field since FX)",
	"battle.gd::_use_item": "OWN — the bomb is the pouch's, so its frame names nobody (HY §1b)",
	"battle.gd::_resolve": "ACTION — framed at its entry and re-established after every nested resolve; its retaliations borrow (HY §1c)",
	"battle.gd::_killing_cold_cast": "BORROWS — inside the caster's own cast, before its strike (HY's census)",
	"battle.gd::_dot_tick_rider": "BREAK — a Rupture's tick rider",
	"battle.gd::_arcane_arrow_splash": "ACTION",
	"battle.gd::_crossfire_splash": "ACTION",
	"battle.gd::_arcane_echo_repeat": "ACTION",
	"battle.gd::_on_covenant_share": "DEALER — the bond's half of a wound is its dealer's (GO); a body's own price is not shared",
	"battle.gd::_echo_fire": "ACTION — the cast's own frame, re-established by its one caller after",
	"battle.gd::_forge_body_throw": "BORROWS",
	"battle.gd::_overburn_refund": "ACTION — the Pyromancer's own price",
	"battle.gd::_on_rite_return": "BORROWS (HY §1a)",
	"battle.gd::_on_vow_share": "DEALER — the carried half is the swing's own wound on a second body; it keeps the frame it found (HZ §0.1)",
	"battle.gd::_on_bloodbond_guard": "BORROWS (HY §1a)",
	"battle.gd::_on_brunt_guard": "BORROWS (HY §1a)",
	"battle.gd::_on_blight_heal": "BORROWS (HY §1a)",
	"battle.gd::_mirror_guard_return": "BORROWS (HY §1c)",
	"battle.gd::_detonate_ruin": "OWN — at its bearer's turn start; the Occultist's (HY §1b)",
	"battle.gd::_ward_detonate": "BORROWS",
	"battle.gd::_burning_ground_tick": "OWN — at the Cleric's turn start",
	"battle.gd::_resolve_special": "ACTION",
	"battle.gd::_ghost_hit": "ACTION — a companion's work is its hunter's",
	"battle.gd::_companion_hit": "ACTION — a companion's work is its hunter's",
	"battle.gd::_forest_bite": "BORROWS (HY §1c; no writer of its field since FX)",
	"battle.gd::_spring_trap": "CALLER — Snare Line's and the Deadfall's ticks set the trap's frame; the snare's spring deals none",
	"battle.gd::_add_bleed_with_burst": "ACTION",
	"battle.gd::_on_damage_taken": "BORROWS — Frostbind's and Penance's mirrors",
	"unit.gd::take_hit": "DEALER — One Soul's split of a wound among the bond, under the wound's own frame",
}

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HY — THE ATTRIBUTION FRAME, PUT BACK")
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
	await _s1_the_vow_share()
	await _s2_the_springs()
	await _s3_the_detonation_and_the_bomb()
	await _s4_the_other_callbacks()
	await _s5_the_retaliations()
	_s6_the_census()
	_s7_the_rule()
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


func _rune(id: String) -> Dictionary:
	var r: Dictionary = Runes.build(id)
	r["equipped"] = true
	return r


func _engines(pids: Array) -> Array:
	var out: Array = []
	for pid in pids:
		out.append(_rune(Runes.engine_rune_id(String(pid))))
	return out


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


func _melee(scene: Node, skip: Array = []) -> BattleUnit:
	for e in _foes(scene):
		if not (e as BattleUnit).is_ranged and not skip.has(e):
			return e
	return null


func _ranged(scene: Node) -> BattleUnit:
	for e in _foes(scene):
		if (e as BattleUnit).is_ranged:
			return e
	return null


# The frame as three plain values: who, the label, the name a frame carries for a source no longer a unit.
func _frame(scene: Node) -> Array:
	var src = scene.get("_dmg_src")
	var who: BattleUnit = src if src != null and is_instance_valid(src) else null
	return [who, String(scene.get("_dmg_label")), String(scene.get("_dmg_src_name"))]


func _frame_str(scene: Node) -> String:
	var f := _frame(scene)
	return "%s / %s / %s" % ["<nobody>" if f[0] == null else (f[0] as BattleUnit).unit_name, f[1], f[2]]


func _dealt(scene: Node, h: BattleUnit) -> Dictionary:
	return ((scene.get("_run_dealt") as Dictionary).get(h.unit_name, {}) as Dictionary).duplicate()


func _taken(scene: Node, h: BattleUnit) -> Dictionary:
	return ((scene.get("_run_taken") as Dictionary).get(h.unit_name, {}) as Dictionary).duplicate()


func _log_text(scene: Node) -> String:
	return String(scene.get("history").get_parsed_text())


func _label(scene: Node, sid: String) -> String:
	return String((scene.get("STATUS_INFO") as Dictionary)[sid][0])


# ── §1 — THE VOW'S CARRIED HALF IS THE RAIDER'S ────────────────────────────
#
# HX's drive, made a gate. HX read the raider losing 26, 27, 24 with no share and 0, 0, 0 with the share
# and the Devout's vow: the share's bill left the Devout's frame standing for the rest of the raider's
# swing, so the Survivalist's wire and the reflect were read as his and silenced, and the mirror — which
# reads the dealer — never fired. HY put the frame back; **HZ §0.1 took the share out of the frame's
# business altogether**: the vow moves where a blow LANDS, not who swung it, so the share keeps the frame it
# found and the half the Devout carries is the raider's damage on a second body. **The figures are not
# compared ACROSS arms**: the reflect is the layer's, so his vow silences it with or without a share. What
# every arm must read is the same FUNCTION of its own blow: the mirror on what each body lost — the whole
# blow between the Warden and the Devout, so the share's term is gone from the raider's loss — the wire on
# the whole blow, the reflect on the whole blow unless the ground's layer wears the vow. **The mirror rounds
# per body**, so a blow whose two parts are both odd mirrors one more than the whole blow would (18 → 9 + 9
# mirrors 5 + 5 against 9): asserted per blow as never more than one body's rounding, and every such blow
# printed.
func _mirror(lost: int) -> int:
	return maxi(int(round(lost * 0.01 * PENANCE_POWER)), 1) if lost > 0 else 0


func _s1_the_vow_share() -> void:
	print("\n§1 — the vow's carried half is the raider's damage on a second body, under the raider's own frame")
	var arms := [["A0 no share, the Devout vowed", false, true], ["A1 the share, the Devout vowed", true, true],
		["A2 the share, no vow", true, false], ["A3 no share, no vow", false, false]]
	var checked := 0
	var splits: Array = []
	for arm in arms:
		var share: bool = arm[1]
		var vowed: bool = arm[2]
		var over := {2: {"bm_abilities": ["Vow of Suffering"], "bm_equipped": ["Vow of Suffering"]}}
		if vowed:
			over[2]["runes"] = [_rune("vow_of_silence")]
		var s: Node = await _board(SPECS, over)
		var w := _hero(s, "warrior")
		var py := _hero(s, "mage")
		var c := _hero(s, "cleric")
		var h := _hero(s, "hunter")
		var foe := _melee(s)
		if [w, py, c, h, foe].any(func(x): return x == null):
			ok(false, "§1 (%s): the board seats a Warden, a Pyromancer, a Devout, a Survivalist and a raider" % arm[0])
			await _clear(s)
			continue
		ok(w.vow_cb.is_valid(), "§1 (%s): the vow's hook is not armed on the Warden — the Devout carries the card" % arm[0])
		ok((c.rune_vow_of_silence > 0.0) == vowed, "§1 (%s): the Devout's Vow of Silence reads %.2f" % [arm[0], c.rune_vow_of_silence])
		s._apply_status(w, "cons_ground", 3, 0, 0, c)
		s._apply_status(h, "tripwire", 6, 0, 0, h)
		s._apply_status(foe, "penance", 4, PENANCE_POWER, 0, py)
		if share:
			s._apply_status(w, "vow", 4, 0, 0, c)
		var wire := _label(s, "tripwire")
		var slash: String = (foe.abilities[0] as Ability).display_name
		var wound_key := "%s / %s" % [Enemies.unit_name(foe.enemy_kind), slash]
		seed(SEED)
		var line := "  %-30s" % arm[0]
		for k in 3:
			w.hp = w.max_hp
			c.hp = c.max_hp
			foe.hp = foe.max_hp
			w.refresh_bars()
			var w0 := w.hp
			var c0 := c.hp
			var f0 := foe.hp
			var tw0 := float(_dealt(s, h).get(wire, 0.0))
			var pn0 := float(_dealt(s, py).get("Penance", 0.0))
			await s._resolve(foe, foe.abilities[0], w, "good")
			var wl := w0 - w.hp
			var cl := c0 - c.hp
			var fl := f0 - foe.hp
			var blow := wl + cl
			var tw := int(round(float(_dealt(s, h).get(wire, 0.0)) - tw0))
			var pn := int(round(float(_dealt(s, py).get("Penance", 0.0)) - pn0))
			var want_pn := _mirror(wl) + _mirror(cl)
			var whole_pn := _mirror(blow)
			var want_tw := maxi(int(blow * 0.75), 1)
			var want_rf := 0 if vowed else maxi(int(round(blow * 0.10)), 1)
			var fr := _frame(s)
			ok(fr[0] == foe and fr[1] == slash,
				"§1 (%s) blow %d: the frame after the raider's Slash is %s — it should be the raider's own Slash again" % [
					arm[0], k + 1, _frame_str(s)])
			ok(blow > 0 and (cl > 0) == share,
				"§1 (%s) blow %d: the Warden lost %d and the Devout %d — the share should %s" % [
					arm[0], k + 1, wl, cl, "carry half" if share else "carry nothing"])
			ok(tw == want_tw, "§1 (%s) blow %d: the Survivalist's wire booked %d, the whole blow's wire is %d — silenced or mis-booked" % [
				arm[0], k + 1, tw, want_tw])
			ok(pn == want_pn and pn > 0, "§1 (%s) blow %d: Penance's mirror paid %d, on what each body lost (%d and %d) it is %d" % [
				arm[0], k + 1, pn, wl, cl, want_pn])
			ok(pn - whole_pn >= 0 and pn - whole_pn <= (1 if cl > 0 else 0),
				"§1 (%s) blow %d: the mirror on the bodies is %d against %d on the whole blow of %d — more than one body's rounding" % [
					arm[0], k + 1, pn, whole_pn, blow])
			if pn != whole_pn:
				splits.append("%s, blow %d: %d → %d + %d mirrors %d + %d = %d, the whole blow %d" % [
					arm[0], k + 1, blow, wl, cl, _mirror(wl), _mirror(cl), pn, whole_pn])
			ok(fl == pn + tw + want_rf,
				"§1 (%s) blow %d: the raider lost %d — the mirror %d, the wire %d and the reflect %d make %d" % [
					arm[0], k + 1, fl, pn, tw, want_rf, pn + tw + want_rf])
			line += "  %2d+%2d → %2d (%d/%d/%d)" % [wl, cl, fl, pn, tw, want_rf]
			checked += 1
		var wt := _taken(s, w)
		ok(wt.keys() == [wound_key], "§1 (%s): the Warden's wounds are booked %s — every one is the raider's Slash" % [arm[0], wt])
		var dt := _dealt(s, h)
		ok(dt.keys() == [wire], "§1 (%s): the Survivalist's dealt ledger reads %s — the wire is booked as the wire" % [arm[0], dt])
		if share:
			var ct := _taken(s, c)
			ok(ct.keys() == [wound_key],
				"§1 (%s): the Devout's carried share is booked %s — it is the raider's wound on a second body (HZ §0.1)" % [arm[0], ct])
		print(line + "   [W+C → raider (mirror/wire/reflect)]")
		await _clear(s)
	ok(checked == 12, "§1: %d of 12 blows were read — the drive has gone vacuous" % checked)
	print("  CHECKED %d blows across four arms; the mirror's rounding splits %d of them%s" % [checked, splits.size(),
		"" if splits.is_empty() else ":\n    " + "\n    ".join(PackedStringArray(splits))])


# ── §2 — THE SPRINGS AT A TURN START ───────────────────────────────────────
#
# HX §4c: Snare Line's spring dealt 15 after an enemy's Slash and 0 after the Devout's Smite — it set no
# frame and took the last action's, his vow included. Each spring now carries its layer's frame for as
# long as it bites, so the same roll reads the same in every arm, and the frame the action left is put back.
func _s2_the_springs() -> void:
	print("\n§2 — Snare Line's and the Deadfall's springs, called as the turn loop calls them, after a real action")
	var lines := {}
	var deadfalls := {}
	for arm in [["after an enemy's Slash", "enemy", true], ["after the Devout's Smite, vowed", "devout", true],
			["after the Devout's Smite, no vow", "devout", false]]:
		var over := {}
		if arm[2]:
			over[2] = {"runes": [_rune("vow_of_silence")]}
		var s: Node = await _board(SPECS, over)
		var w := _hero(s, "warrior")
		var c := _hero(s, "cleric")
		var h := _hero(s, "hunter")
		var foe := _melee(s)
		var other := _melee(s, [foe])
		var archer := _ranged(s)
		if [w, c, h, foe, other, archer].any(func(x): return x == null):
			ok(false, "§2 (%s): the board seats the four heroes and three enemies" % arm[0])
			await _clear(s)
			continue
		if arm[1] == "enemy":
			await s._resolve(other, other.abilities[0], w, "good")
		else:
			await s._resolve(c, c.abilities[0], other, "good")
		var before := _frame(s)
		s._apply_status(foe, "snare_line", 3, (s.get("heroes") as Array).find(h), 0, h)
		foe.hp = foe.max_hp
		var f0 := foe.hp
		seed(SPRING_SEED)
		# The turn loop's own call, which only a function of its own can be driven through (`_run_battle`
		# cannot be stepped headlessly). Asked first, so a tree without it reds here rather than throwing.
		ok(s.has_method("_snare_line_tick"), "§2: Snare Line's spring is not a function the turn loop calls")
		if s.has_method("_snare_line_tick"):
			s.call("_snare_line_tick", foe)
		var sl_loss := f0 - foe.hp
		var after := _frame(s)
		ok(after == before, "§2 (%s): the frame after Snare Line's spring is %s — the one the action left was not put back" % [
			arm[0], _frame_str(s)])
		ok(sl_loss > 0, "§2 (%s): Snare Line's spring dealt nothing — silenced by a frame that was not the layer's" % arm[0])
		var sl_book := int(round(float(_dealt(s, h).get(_label(s, "snare_line"), 0.0))))
		ok(sl_book == sl_loss, "§2 (%s): the spring dealt %d and the Survivalist's ledger books %d under Snare Line" % [
			arm[0], sl_loss, sl_book])
		lines[arm[0]] = sl_loss
		h.deadfall_armed = 1
		h.deadfall_dormant = 0
		archer.hp = archer.max_hp
		var a0 := archer.hp
		seed(SPRING_SEED)
		s._deadfall_tick(archer)
		var df_loss := a0 - archer.hp
		ok(_frame(s) == before, "§2 (%s): the frame after the Deadfall's spring is %s — not put back" % [arm[0], _frame_str(s)])
		ok(df_loss > 0, "§2 (%s): the Deadfall's spring dealt nothing" % arm[0])
		var df_book := int(round(float(_dealt(s, h).get("Deadfall", 0.0))))
		ok(df_book == df_loss, "§2 (%s): the Deadfall dealt %d and is booked %d under its name" % [arm[0], df_loss, df_book])
		deadfalls[arm[0]] = df_loss
		print("  %-34s Snare Line %d, Deadfall %d; the frame stays %s" % [arm[0], sl_loss, df_loss, _frame_str(s)])
		await _clear(s)
	var sl_vals: Array = lines.values()
	var df_vals: Array = deadfalls.values()
	ok(sl_vals.size() == 3 and sl_vals.all(func(v): return v == sl_vals[0]),
		"§2: one roll read %s across the three last actions — the spring still depends on who acted before it" % [lines])
	ok(df_vals.size() == 3 and df_vals.all(func(v): return v == df_vals[0]),
		"§2: the Deadfall read %s across the three last actions" % [deadfalls])


# ── §3 — THE DETONATION AND THE BOMB ───────────────────────────────────────
func _s3_the_detonation_and_the_bomb() -> void:
	print("\n§3 — a Ruin detonation is the Occultist's; a bomb is nobody's")
	var occ_specs := ["warden", "pyromancer", "occultist", "mystic"]
	for arm in [["vowed, after an enemy's Slash", true, "enemy"], ["vowed, after his own cast", true, "self"],
			["no vow, after an enemy's Slash", false, "enemy"]]:
		var over := {}
		if arm[1]:
			over[2] = {"runes": [_rune("vow_of_silence")]}
		var s: Node = await _board(occ_specs, over)
		var w := _hero(s, "warrior")
		var occ := _hero(s, "cleric")
		var foe := _melee(s)
		var other := _melee(s, [foe])
		if [w, occ, foe, other].any(func(x): return x == null):
			ok(false, "§3 (%s): the board seats a Warden, an Occultist and two raiders" % arm[0])
			await _clear(s)
			continue
		if arm[2] == "enemy":
			await s._resolve(other, other.abilities[0], w, "good")
		else:
			await s._resolve(occ, occ.abilities[0], other, "good")
		var before := _frame(s)
		s._gain_ruin(foe, int(s._ruin_threshold()))
		ok(foe.has_status("ruin_primed"), "§3 (%s): a full threshold of Ruin did not prime the mark" % arm[0])
		foe.hp = foe.max_hp
		var f0 := foe.hp
		var d0 := float(_dealt(s, occ).get(_label(s, "ruin"), 0.0))
		s._detonate_ruin(foe)
		var loss := f0 - foe.hp
		var booked := int(round(float(_dealt(s, occ).get(_label(s, "ruin"), 0.0)) - d0))
		ok(_frame(s) == before, "§3 (%s): the frame after the detonation is %s — not put back" % [arm[0], _frame_str(s)])
		if arm[1]:
			ok(loss == 0, "§3 (%s): the vowed Occultist's detonation took %d — it is his damage, whoever acted last" % [arm[0], loss])
		else:
			ok(loss > 0 and booked > 0, "§3 (%s): the detonation took %d and booked %d to the Occultist under Ruin" % [
				arm[0], loss, booked])
		print("  detonation %-34s took %d; booked to the Occultist under Ruin %d" % [arm[0], loss, booked])
		await _clear(s)
	# THE BOMB, thrown after the vowed Devout's Smite — the frame his action left would have blanked it.
	var s2: Node = await _board(SPECS, {2: {"runes": [_rune("vow_of_silence")]}})
	var c2 := _hero(s2, "cleric")
	var target := _melee(s2)
	if c2 == null or target == null:
		ok(false, "§3: the bomb's board seats a vowed Devout and a raider")
		await _clear(s2)
		return
	await s2._resolve(c2, c2.abilities[0], target, "good")
	var before2 := _frame(s2)
	var pouch: Dictionary = s2.get("items")
	if not pouch.has("bomb") or int(pouch["bomb"][1]) <= 0:
		pouch["bomb"] = [String(_run.ITEM_INFO["bomb"][0]), 1, String(_run.ITEM_INFO["bomb"][1])]
	s2.set("item_used", false)
	var bomb_dmg: int = int(_run.bomb_damage()) if bool(_run.active) else int(_run.BOMB_BASE_DAMAGE)
	var hp0 := {}
	for e in _foes(s2):
		e.hp = e.max_hp
		hp0[e] = e.hp
	var ledgers0 := {}
	for hh in s2.get("heroes"):
		ledgers0[hh.unit_name] = _dealt(s2, hh)
	await s2._use_item("bomb")
	var landed := 0
	for e2 in hp0:
		if int(hp0[e2]) - (e2 as BattleUnit).hp == bomb_dmg:
			landed += 1
	ok(landed == hp0.size() and landed > 0,
		"§3: the bomb landed its %d on %d of %d enemies after the vowed Devout's Smite" % [bomb_dmg, landed, hp0.size()])
	ok(_frame(s2) == before2, "§3: the frame after the bomb is %s — not put back" % _frame_str(s2))
	var moved := 0
	for hh2 in s2.get("heroes"):
		if _dealt(s2, hh2) != ledgers0[hh2.unit_name]:
			moved += 1
	ok(moved == 0, "§3: the bomb moved %d hero's dealt ledger — it is the pouch's and books nobody" % moved)
	print("  the bomb: %d on %d of %d enemies, %d ledgers moved; the frame stays %s" % [
		bomb_dmg, landed, hp0.size(), moved, _frame_str(s2)])
	await _clear(s2)


# ── §4 — THE OTHER CALLBACKS, AND THE KILLING COLD ────────────────────────
func _s4_the_other_callbacks() -> void:
	print("\n§4 — Rite of Return, Bloodbond, Bear the Brunt, Blight the Well and the Killing Cold put the frame back")
	# RITE OF RETURN — a lethal blow on the Warden, the Holy Cleric's rite answering it.
	var s: Node = await _board(["warden", "pyromancer", "holy", "mystic"],
		{2: {"bm_abilities": ["Rite of Return"], "bm_equipped": ["Rite of Return"]}})
	var w := _hero(s, "warrior")
	var holy := _hero(s, "cleric")
	var foe := _melee(s)
	if [w, holy, foe].any(func(x): return x == null) or not w.rite_cb.is_valid():
		ok(false, "§4: the rite's board seats a Warden, a Holy Cleric carrying the rite, and a raider")
	else:
		s._apply_status(w, "rite_return", 3, 0, 0, holy)
		w.hp = 1
		var hc0 := holy.hp
		await s._resolve(foe, foe.abilities[0], w, "good")
		ok(not w.dead and holy.hp < hc0, "§4: the rite did not answer the lethal blow (Warden %d, the Cleric paid %d)" % [w.hp, hc0 - holy.hp])
		var fr := _frame(s)
		ok(fr[0] == foe and fr[1] == (foe.abilities[0] as Ability).display_name,
			"§4: after the rite answered, the frame is %s — it should be the raider's Slash" % _frame_str(s))
		print("  Rite of Return: the Warden stands at %d, the Cleric paid %d; the frame is %s" % [w.hp, hc0 - holy.hp, _frame_str(s)])
	await _clear(s)
	# BLOODBOND AND BEAR THE BRUNT — a Hunter with a companion, each guard under a lethal blow.
	for arm in ["Bloodbond", "Bear the Brunt"]:
		var over := {}
		if arm == "Bear the Brunt":
			over[3] = {"runes": [_rune("answering_pack")]}
		var s3: Node = await _board(["warden", "pyromancer", "inquisitor", "beastmaster"], over)
		var h := _hero(s3, "hunter")
		var foe3 := _melee(s3)
		await s3._do_summon(h, "canis")
		var comp: BattleUnit = null
		for b in h.beasts:
			if is_instance_valid(b) and not b.dead:
				comp = b
		if comp == null or foe3 == null:
			ok(false, "§4 (%s): a companion stands beside the Hunter" % arm)
			await _clear(s3)
			continue
		# The fixture's dice are set at the spawn; a body called in after it gets them here.
		comp.no_cover = 1
		comp.parry_chance = 0.0
		comp.block_chance = -10.0
		comp.crit_bonus = -1.0
		var victim: BattleUnit = comp
		var payer: BattleUnit = h
		if arm == "Bloodbond":
			s3._apply_status(h, "bloodbond", -1, 50, 0, h)
			comp.hp = 1
		else:
			ok(h.brunt_cb.is_valid(), "§4: the Answering Pack does not arm the Hunter's guard")
			victim = h
			payer = comp
			h.hp = 1
		var p0 := payer.hp
		await s3._resolve(foe3, foe3.abilities[0], victim, "good")
		ok(not victim.dead and payer.hp < p0, "§4 (%s): the guard did not take the lethal blow (%s %d, the payer paid %d)" % [
			arm, victim.unit_name, victim.hp, p0 - payer.hp])
		var fr3 := _frame(s3)
		ok(fr3[0] == foe3 and fr3[1] == (foe3.abilities[0] as Ability).display_name,
			"§4 (%s): after the guard paid, the frame is %s — it should be the raider's Slash" % [arm, _frame_str(s3)])
		print("  %-14s %s stands at %d, %s paid %d; the frame is %s" % [arm, victim.unit_name, victim.hp,
			payer.unit_name, p0 - payer.hp, _frame_str(s3)])
		await _clear(s3)
	# BLIGHT THE WELL — a heal on a blighted raider, inside another enemy's mending.
	var s4: Node = await _board(["warden", "pyromancer", "occultist", "mystic"], {})
	var occ := _hero(s4, "cleric")
	var bf := _melee(s4)
	var mender := _melee(s4, [bf])
	if [occ, bf, mender].any(func(x): return x == null):
		ok(false, "§4: the blight's board seats an Occultist and two raiders")
	else:
		s4._apply_status(bf, "blight", 3, 0, 0, occ)
		bf.hp = bf.max_hp - 40
		s4._dmg_frame(mender, "Cleansing Rite")
		var b0 := bf.hp
		var bl0 := float(_dealt(s4, occ).get("Blight the Well", 0.0))
		bf.heal_amount(20)
		var fr4 := _frame(s4)
		ok(fr4[0] == mender and fr4[1] == "Cleansing Rite",
			"§4: after Blight the Well turned the heal, the frame is %s — the mending's own should be back" % _frame_str(s4))
		ok(b0 - bf.hp == 20 and int(round(float(_dealt(s4, occ).get("Blight the Well", 0.0)) - bl0)) == 20,
			"§4: the blighted heal dealt %d and booked the Occultist %d" % [b0 - bf.hp,
				int(round(float(_dealt(s4, occ).get("Blight the Well", 0.0)) - bl0))])
		print("  Blight the Well: the heal dealt %d; the frame is %s" % [b0 - bf.hp, _frame_str(s4)])
	await _clear(s4)
	# THE KILLING COLD — it bites at the cast's own line, before the strike; the strike and the Weaver's
	# repeat must read the cast's frame after it.
	var s5: Node = await _board(["warden", "cryomancer", "inquisitor", "mystic"],
		{1: {"engines": _engines(["permafrost", "cast_echo"]), "runes": [_rune("killing_cold_fk")]}})
	var m := _hero(s5, "mage")
	var chilled := _melee(s5)
	var struck := _melee(s5, [chilled])
	if [m, chilled, struck].any(func(x): return x == null) or m.rune_killing_cold <= 0:
		ok(false, "§4: the Killing Cold's board seats a Cryomancer wearing the rune and two raiders")
	else:
		s5._apply_status(chilled, "chilled", 3, 0, 0, m)
		chilled.set_chilled_stacks(4)
		m.echo_casts = Classes.ECHO_EVERY - 1
		var basic: Ability = m.abilities[0]
		var st0 := struck.hp
		await s5._resolve(m, basic, struck, "good")
		var fr5 := _frame(s5)
		var dealt5 := _dealt(s5, m)
		ok(fr5[0] == m and fr5[1] == basic.display_name,
			"§4: after the Killing Cold bit, the cast's frame is %s — it should be the cast's own" % _frame_str(s5))
		ok(float(dealt5.get("Rune: the Killing Cold", 0.0)) > 0.0,
			"§4: the Killing Cold did not bite the chilled raider (%s)" % [dealt5])
		ok(float(dealt5.get(basic.display_name, 0.0)) >= float(st0 - struck.hp) and st0 - struck.hp > 0,
			"§4: the cast's strike is booked %s under %s against %d dealt — the rune's frame kept it" % [
				dealt5.get(basic.display_name, 0.0), basic.display_name, st0 - struck.hp])
		var lg := _log_text(s5)
		ok(lg.contains("the %s repeats for" % basic.display_name),
			"§4: the Weaver's repeat did not see the cast it followed the Killing Cold into")
		print("  the Killing Cold: dealt %s; the frame is %s" % [dealt5, _frame_str(s5)])
	await _clear(s5)


# ── §5 — THE RETALIATIONS INSIDE AN ENEMY'S SWING ──────────────────────────
#
# GO §1a: a Tripwire, a Feint's return and a Mirror Guard return dealt their damage under the attacker's
# frame — self-inflicted by identity — so the Reaver counted no kill, and the Leech, the Arbiter and the
# marks saw nothing; HF found the reflect slipping past its layer's vow. Each is read here through the
# reader that names its owner: a Tracker's or an Arbiter's mark (the first enemy a holder damages) and a
# Reaver's kill. And the frame comes back to the swing.
func _s5_the_retaliations() -> void:
	print("\n§5 — a retaliation inside an enemy's swing is its owner's")
	# THE TRIPWIRE, read through the Tracker's mark.
	var s: Node = await _board(SPECS, {3: {"engines": _engines(["trapper", "quarry_hunt"])}})
	var w := _hero(s, "warrior")
	var h := _hero(s, "hunter")
	var foe := _melee(s)
	if [w, h, foe].any(func(x): return x == null):
		ok(false, "§5: the Tripwire's board seats a Warden, a Survivalist and a raider")
	else:
		ok(_foes(s).all(func(e): return not e.has_status("tracked")), "§5: an enemy is tracked before the Survivalist has dealt anything")
		s._apply_status(h, "tripwire", 6, 0, 0, h)
		await s._resolve(foe, foe.abilities[0], w, "good")
		ok(foe.has_status("tracked") and String(foe.get_status("tracked").get("src_name", "")) == h.unit_name,
			"§5: the Tripwire ripped the raider and the Tracker's mark did not land — the wire was not the Survivalist's")
		ok(_frame(s)[0] == foe, "§5: after the Tripwire, the frame is %s — the swing's own should be back" % _frame_str(s))
		print("  the Tripwire: the raider is tracked by %s" % String(foe.get_status("tracked").get("src_name", "")))
	await _clear(s)
	# THE WHOLE FOREST — the wire's bite on a support cast (no writer of the field since FX; set by hand).
	var sf: Node = await _board(SPECS, {3: {"engines": _engines(["trapper", "quarry_hunt"])}})
	var hf := _hero(sf, "hunter")
	var ff := _melee(sf)
	if hf == null or ff == null:
		ok(false, "§5: the forest's board seats a Survivalist and a raider")
	else:
		hf.whole_forest = 1
		sf._apply_status(hf, "tripwire", 6, 0, 0, hf)
		sf._dmg_frame(ff, "Regenerate")
		sf._forest_bite(ff)
		ok(ff.has_status("tracked"), "§5: the forest bit the raider and the Tracker's mark did not land")
		ok(_frame(sf)[0] == ff and _frame(sf)[1] == "Regenerate",
			"§5: after the forest bit, the frame is %s — the raider's own action should be back" % _frame_str(sf))
	await _clear(sf)
	# FEINT, MIRROR GUARD AND SPITE — each kills the raider with its return, read through the Reaver.
	for arm in ["Feint", "Mirror Guard", "Spite"]:
		var spec := "warden" if arm == "Spite" else "swordmaster"
		var lineage := "heavy_plating" if arm == "Spite" else "seasoned"
		var over := {0: {"engines": _engines([lineage, "savage_assault"])}}
		if arm == "Mirror Guard":
			over[0]["runes"] = [_rune("mirror_guard")]
		var s2: Node = await _board([spec, "pyromancer", "inquisitor", "mystic"], over)
		var war := _hero(s2, "warrior")
		var foe2 := _melee(s2)
		if war == null or foe2 == null or not war.has_engine("savage_assault"):
			ok(false, "§5 (%s): the board seats a Warrior holding the Reaver and a raider" % arm)
			await _clear(s2)
			continue
		if arm == "Feint":
			war.feint_guards = 1
		elif arm == "Mirror Guard":
			war.stance = "defensive"
			war.banked_guards = 1
		else:
			war.spite_ranks = 1
		foe2.hp = 1
		var k0 := war.reaver_kills
		await s2._resolve(foe2, foe2.abilities[0], war, "good")
		ok(foe2.dead, "§5 (%s): the return did not kill the raider at 1 health" % arm)
		ok(war.reaver_kills == k0 + 1, "§5 (%s): the return killed the raider and the Reaver counted %d — it was filed to the raider" % [
			arm, war.reaver_kills - k0])
		print("  %-13s the raider falls to the return; the Reaver counts %d" % [arm, war.reaver_kills - k0])
		await _clear(s2)
	# CONSECRATED GROUND'S REFLECT — read through the Arbiter's mark, and silenced by its layer's own vow.
	for vowed in [false, true]:
		var over3 := {2: {"engines": _engines(["conviction", "judgment"])}}
		if vowed:
			over3[2]["runes"] = [_rune("vow_of_silence")]
		var s3: Node = await _board(SPECS, over3)
		var w3 := _hero(s3, "warrior")
		var c3 := _hero(s3, "cleric")
		var foe3 := _melee(s3)
		if [w3, c3, foe3].any(func(x): return x == null):
			ok(false, "§5: the reflect's board seats a Warden, a Devout and a raider")
			await _clear(s3)
			continue
		s3._apply_status(w3, "cons_ground", 3, 0, 0, c3)
		foe3.hp = foe3.max_hp
		var f0 := foe3.hp
		await s3._resolve(foe3, foe3.abilities[0], w3, "good")
		var lost := f0 - foe3.hp
		if vowed:
			ok(lost == 0, "§5: the vowed Devout's ground reflected %d — his vow silences his own reflect (HF's item)" % lost)
			ok(not foe3.has_status("judged"), "§5: a silenced reflect judged the raider")
		else:
			ok(lost > 0 and foe3.has_status("judged") \
					and String(foe3.get_status("judged").get("src_name", "")) == c3.unit_name,
				"§5: the ground reflected %d and the Arbiter's mark %s — the reflect was not the Devout's" % [
					lost, "landed" if foe3.has_status("judged") else "did not land"])
		ok(_frame(s3)[0] == foe3, "§5: after the reflect, the frame is %s — the swing's own should be back" % _frame_str(s3))
		print("  Consecrated Ground (%s): reflected %d; judged: %s" % ["vowed" if vowed else "no vow", lost,
			str(foe3.has_status("judged"))])
		await _clear(s3)


# ── §6 — THE CENSUS, HELD ───────────────────────────────────────────────────
func _bodies(path: String) -> Dictionary:
	var out := {}
	var name := ""
	var body: PackedStringArray = []
	for line in Gate.strip_comments(FileAccess.get_file_as_string(path)).split("\n"):
		if line.begins_with("func ") or line.begins_with("static func "):
			if name != "":
				out[name] = body
			var at := line.find("func ") + 5
			name = line.substr(at, line.find("(", at) - at)
			body = []
		elif name != "":
			body.append(line)
	if name != "":
		out[name] = body
	return out


func _s6_the_census() -> void:
	print("\n§6 — every function that deals damage, and the frame it deals under")
	var found := {}
	var deal := RegEx.new()
	deal.compile("\\b(take_hit|take_tick_damage)\\(")
	var sites := 0
	var bodies_by_file := {}
	for f in ["battle.gd", "unit.gd"]:
		var bodies := _bodies("res://scripts/%s" % f)
		bodies_by_file[f] = bodies
		for fn in bodies:
			var n := 0
			for line in bodies[fn]:
				n += deal.search_all(String(line)).size()
			if n > 0:
				found["%s::%s" % [f, fn]] = n
				sites += n
	var unknown: Array = []
	for k in found:
		if not DAMAGE_FUNCS.has(k):
			unknown.append(k)
	ok(unknown.is_empty(), "§6: %d function(s) deal damage and are not in the census — say what frame each deals under: %s" % [
		unknown.size(), ", ".join(PackedStringArray(unknown))])
	for k2 in DAMAGE_FUNCS:
		if not found.has(k2):
			print("  [notice] §6: `%s` deals no damage any more — delete its row" % k2)
	ok(found.size() >= 25 and sites >= 60, "§6: the census read %d functions and %d sites — the walk has gone vacuous" % [found.size(), sites])
	# EVERY BORROWED FRAME IS PUT BACK BY THE FUNCTION THAT BORROWED IT: each `X_was_src` a body saves, that body restores
	# by name. **Read per function, never file-wide** — Forge Body and `_book_self_cost` both save under the bare `was_`
	# names, so a file-wide test read one's restore as the other's, and Forge Body's could go missing in silence (C19).
	var save := RegEx.new()
	save.compile("var (\\w*)was_src(?:\\s*:\\s*BattleUnit)?\\s*:?=\\s*_dmg_src\\b")
	var unrestored: Array = []
	var borrows := 0
	var bat_bodies: Dictionary = bodies_by_file["battle.gd"]
	for fn2 in bat_bodies:
		var btext := "\n".join(bat_bodies[fn2])
		for mm in save.search_all(btext):
			var p := mm.get_string(1)
			borrows += 1
			if not btext.contains("_dmg_frame(%swas_src, %swas_label, %swas_name)" % [p, p, p]):
				unrestored.append("%s (%swas_src)" % [fn2, p])
	ok(unrestored.is_empty(), "§6: a borrowed frame is never put back by the function that borrowed it: %s" % ", ".join(PackedStringArray(unrestored)))
	ok(borrows >= 18, "§6: only %d borrowed frames were found — the save pattern has changed under this arm" % borrows)
	# A BORROWING FUNCTION BORROWS; AN OUT-OF-ACTION ONE SETS ITS OWN FRAME BEFORE IT DEALS.
	var bad: Array = []
	for k3 in found:
		var cls := String(DAMAGE_FUNCS.get(k3, ""))
		var parts := String(k3).split("::")
		var body: PackedStringArray = (bodies_by_file[parts[0]] as Dictionary)[parts[1]]
		var text := "\n".join(body)
		if cls.begins_with("BORROWS") and not save.search(text):
			bad.append("%s borrows no frame" % k3)
		elif cls.begins_with("OWN"):
			var first_set := text.find("_dmg_frame(")
			var first_deal := deal.search(text)
			if first_set < 0 or first_deal == null or first_set > first_deal.get_start():
				bad.append("%s deals before it sets a frame" % k3)
	ok(bad.is_empty(), "§6: %s" % "; ".join(PackedStringArray(bad)))
	# THE TRAP'S CALLERS: each spring that deals sets the trap's frame first; the snare's deals none.
	var trap_callers := 0
	for k4 in bodies_by_file["battle.gd"]:
		var tx := "\n".join((bodies_by_file["battle.gd"] as Dictionary)[k4])
		var at := tx.find("_spring_trap(")
		while at >= 0:
			trap_callers += 1
			var call := tx.substr(at, tx.find("\n", at) - at)
			var dealing := not call.contains(", 0.0)")
			var framed := tx.substr(0, at).contains("_dmg_frame(")
			ok(not dealing or framed, "§6: `%s` springs a trap that deals with no frame of its own: %s" % [k4, call.strip_edges()])
			at = tx.find("_spring_trap(", at + 1)
	ok(trap_callers >= 3, "§6: %d trap springs found — the snare, Snare Line and the Deadfall should all be read" % trap_callers)
	print("  CHECKED %d functions, %d damage sites, %d borrowed frames, %d trap springs" % [found.size(), sites, borrows, trap_callers])


# ── §7 — THE RULE, WHERE A FIGHT'S RULES LIVE ───────────────────────────────
func _s7_the_rule() -> void:
	print("\n§7 — the frame's rule in the combat rules")
	var cr := FileAccess.get_file_as_string("res://docs/combat-rules.md")
	ok(cr.contains("THE FRAME NAMES WHOEVER THE SITE CREDITS, AND ONLY WHILE IT DEALS"),
		"§7: docs/combat-rules.md does not state the frame's rule")
	ok(cr.contains("A SITE THAT BORROWS THE FRAME INSIDE ANOTHER UNIT'S ACTION PUTS BACK THE ONE IT FOUND"),
		"§7: the combat rules have lost the borrow-and-put-back half")
	# THE DOCTRINE READ OFF THE PRACTICE (HY §4): DG §2's exception struck, kept as a record, and the live doctrine in the
	# file the strike points at. Read flattened, because a struck sentence is reflowed with its block.
	var flat := RegEx.new()
	flat.compile("\\s+")
	var ir := flat.sub(FileAccess.get_file_as_string("res://docs/instrument-rules.md"), " ", true)
	ok(ir.contains("~~**THE ONE EXCEPTION, AND IT IS NARROW"),
		"§7: the instrument rules do not strike DG §2's exception")
	ok(ir.contains("SO THIS TEXT IS STALE. DO NOT APPLY IT."),
		"§7: the struck exception does not say it is stale on the practice")
	ok(ir.contains("## STANDING RULE — A SUPERSESSION IS A CLAIM, AND IT IS DRIVEN LIKE ONE"),
		"§7: the live doctrine is not in the file the strike points at")


# ── §9 — THE PLAYER'S FILES ────────────────────────────────────────────────
func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
