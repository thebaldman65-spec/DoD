# BATCH JW — THE DROWNED BARROW: A FOURTH ZONE, ITS BOSS AND TWO KINDS; A BODY NO PICK MAY REACH; AND `advance_zone` ASKS FIRST.
#
#   §0   THE RECORD: JV's rulings stand archived, not owed; the standing value (every boss fight has a strategy of its own) stands
#        in `CLAUDE.md`, and every zone boss `Run.ZONE_DEFS` names is built to it or named there as owed
#   §1   THE ZONE: the Drowned Barrow is slot 2's second candidate with one roster of its own; the roster is the travelling core,
#        JU's four (moved, in no other roster) and the Barrow's three; both slot-2 candidates are drawn on a player's road and a
#        sim's, and `DOD_ZONE_ROTATION=0` holds a sim to the Scarlands; every node of a Barrow map composes from its roster, the
#        boss node fields the Bone Shepherd; the backdrops name it; the Scarland Mirage is the Scarlands' alone
#   §2   THE BONE SHEPHERD, DRIVEN: Soul Leech heals half of what it lands, no more than the pool holds unspent, paid point for
#        point; Noxious Fumes lays its status on every hero it strikes, and the hit chance moves by its figure
#   §3   THE ROTFIEND AND THE FEN LURKER, DRIVEN: Rake lays a stack of Black Rot; Corpse Explosion is withheld above half health,
#        strikes every hero with a stack, kills the Rotfiend through the death door (a kill's Malice) and heals a neighbour paid
#        by Malice; Swipe strikes two heroes, never a stale pick of the warband's; Lacerate opens 20 Bleed; Black Rot stacks,
#        never runs out, ticks its share of maximum health and is cleansable
#   §4   A BODY NO PICK MAY REACH: every site of the battle that reads the warband is in the census of record, classified;
#        the door refuses a single blow onto a submerged body; an area and a scatter pass it by; Submerge is once a fight,
#        under half, while another body can be picked; the last pickable body falls and the submerged surface
#   §5   `advance_zone` ASKS FIRST: every caller in `scripts/` asks `has_next_zone` before it calls, and at the last zone the
#        function moves nothing
#
# ── WHY THIS GATE EXISTS ────────────────────────────────────────────────────
# The record (JW's report) adds a zone, a boss built to a new standing value, two kinds and three statuses, and asks that a
# submerged body be reached by no path that picks a target. **That last is a claim about every site of a 32,000-line file**,
# and a site added later is exactly how it would stop being true, so §4 holds the census of record (`docs/reports/JW-picks.tsv`)
# against the sites it derives from the source, the IT §7 shape: it reds the day a site arrives unclassified. §5 is the cheap
# gate JT named for FOUND AT JS.
#
# ── WHAT IT CANNOT DO, SAID FIRST ───────────────────────────────────────────
# §4's derivation reads a line that names the warband (`enemies`, `_adjacent_enemies(`); a pick reached through a variable that
# holds the warband under another name, built where no such line stands, is outside it — the door's backstop in `_resolve`
# (a single blow onto a submerged body does not land) is what holds that case, and §4 drives it. §2 and §3 drive each move once
# on a board the gate builds; what the bot or the dice make of them over a run is the designer's to judge in play. The figures
# the record leaves to play (the lifesteal's share, the Fumes' points, Black Rot's share) are read off their constants, never
# asserted as numbers.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _cache := {}

const ZONE := "drowned_barrow"
const ZONE_NAME := "The Drowned Barrow"
const BOSS := "bone_shepherd"
const SLOT := 2
const OLD := "scarlands"
const FOUR := ["mossback", "blight_speaker", "grave_husk", "carrion_pack"]
const KINDS := ["rotfiend", "fen_lurker"]
const OLD_ROSTERS := [1, 2, 3]
const BACKDROPS := ["scripts/battle.gd", "scripts/map_screen.gd", "scripts/event_screen.gd"]
const STATE := "res://docs/state.md"
const ARCHIVE := "res://DoD-archive/state-archive.md"
const CLAUDE := "res://CLAUDE.md"
const CENSUS := "res://docs/reports/JW-picks.tsv"
# The files whose sites §4 derives — the battle and every script the census found reading the warband's bodies.
const PICK_FILES := ["scripts/battle.gd", "scripts/run_sim.gd"]
const PICK_CLASSES := ["P", "C", "S", "R", "SELF"]
# §0's needles, each read in its file with its line breaks flattened.
const VALUE_HEAD := "## STANDING DESIGN RULE — EVERY BOSS FIGHT HAS A STRATEGY SPECIFIC TO IT"
const VALUE_NEEDLES := ["EACH BOSS FIGHT ASKS THE PARTY ONE QUESTION OF ITS OWN", "A PURE DAMAGE CHECK",
	"TO BE REVISITED THE SAME WAY — RULED, NOT BUILT"]
const OWED_LIVE := "\n### JV's RULINGS OWED"
const OWED_STRUCK := "\n### ~~JV's RULINGS OWED~~"
const SEATS := ["berserker", "cryomancer", "inquisitor", "beastmaster"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _flat(s: String) -> String:
	return s.replace("\n", " ").replace("  ", " ")


func _initialize() -> void:
	await process_frame
	print("BATCH JW — THE DROWNED BARROW, A BODY NO PICK MAY REACH, AND advance_zone ASKS FIRST")
	_run = root.get_node("/root/Run")
	var data: Dictionary = Enemies._load()
	# A tree without the Barrow (HEAD's, under a control) reds here and reads no drive past it, rather than throwing.
	var built: bool = (_run.ZONE_DEFS as Dictionary).has(ZONE) and data.has(BOSS) and data.has("rotfiend") and data.has("fen_lurker")
	ok(built, "§0: the tree holds no Drowned Barrow (ZONE_DEFS, the Bone Shepherd, the Rotfiend, the Fen Lurker)")
	_s0_the_record()
	if built:
		_s1_the_zone(data)
		await _s2_the_shepherd()
		await _s3_the_kinds()
		await _s4_no_pick(data)
	_s5_advance_zone()
	_g.report(self)


# ── §0 — THE RECORD ────────────────────────────────────────────────────────
func _s0_the_record() -> void:
	print("\n§0 — JV's rulings stand archived; the standing value stands where a gate reaches it")
	var state := FileAccess.get_file_as_string(STATE)
	var arch := FileAccess.get_file_as_string(ARCHIVE)
	print("    JV's RULINGS OWED in the open queue: %s; struck in the archive: %s" % [str(state.contains(OWED_LIVE)), str(arch.contains(OWED_STRUCK))])
	ok(state.length() > 1000 and not state.contains(OWED_LIVE), "§0: JV's RULINGS OWED is still in the open queue")
	ok(arch.contains(OWED_STRUCK), "§0: the archive does not hold JV's RULINGS OWED struck")
	var cm := FileAccess.get_file_as_string(CLAUDE)
	var at := cm.find("\n" + VALUE_HEAD)
	var end := cm.find("\n## ", at + 4) if at >= 0 else -1
	var block := _flat(cm.substr(at, end - at)) if at >= 0 and end > at else ""
	var missing: Array = VALUE_NEEDLES.filter(func(n): return not block.contains(String(n)))
	print("    the standing value's block: %d chars; its needles %d of %d" % [block.length(), VALUE_NEEDLES.size() - missing.size(), VALUE_NEEDLES.size()])
	ok(block.length() > 500 and missing.is_empty(), "§0: CLAUDE.md's standing value block is gone or lost its words: %s" % str(missing))
	# EVERY ZONE BOSS IS BUILT TO IT OR NAMED AS OWED — derived off ZONE_DEFS, so a zone added later is read by doing nothing.
	var unplaced: Array = []
	var bosses: Array = []
	for z in (_run.ZONE_DEFS as Dictionary):
		bosses.append(String(_run.ZONE_DEFS[z]["boss"]))
	# AND THE END BOSS: a boss fight the ruling did not name, placed under the marker by JW's reading.
	bosses.append(String(_run.END_BOSS_KIND))
	# BUILT OR OWED, READ BY BULLET: the built boss in the bullet that says it is built to the value, every other in a bullet that
	# carries the marker — a name anywhere else in the block (its reasoning) places nothing.
	var built_text := ""
	var owed_text := ""
	for bullet in block.split(" - **"):
		if String(bullet).contains("IS THE FIRST BUILT TO IT"):
			built_text += String(bullet).to_upper()
		if String(bullet).contains("RULED, NOT BUILT"):
			owed_text += String(bullet).to_upper()
	for b in bosses:
		var name := String(Enemies._load().get(b, {}).get("unit_name", b))
		if b == BOSS:
			if not built_text.contains(name.to_upper()):
				unplaced.append("%s (built, not named as built)" % name)
		elif not owed_text.contains(name.to_upper()):
			unplaced.append("%s (not in a bullet marked RULED, NOT BUILT)" % name)
	print("    bosses read (every zone's and the end boss): %d; placed: %d" % [bosses.size(), bosses.size() - unplaced.size()])
	ok(bosses.size() >= 5 and unplaced.is_empty(), "§0: a zone boss is neither built to the standing value nor named there as owed: %s" % str(unplaced))
	var where := state.substr(0, state.find("\n## THE OPEN QUEUE"))
	ok(not state.contains("FOUND AT JS's advance_zone (its gate owed)"), "§0: the latent shapes' row still says advance_zone's gate is owed")
	ok(where.contains("Lane A"), "§0: the state's WHERE names no lane")


# ── §1 — THE ZONE ──────────────────────────────────────────────────────────
func _zones(k: Dictionary) -> Array:
	var out: Array = []
	for z in k.get("zones", []):
		out.append(int(z))
	return out


func _s1_the_zone(data: Dictionary) -> void:
	print("\n§1 — the Drowned Barrow: slot 2's second candidate, its roster, its draw, its map, its backdrop, its events")
	var zd: Dictionary = _run.ZONE_DEFS[ZONE]
	var pools: Array = _run.SLOT_POOLS
	print("    %s: '%s', boss %s, rosters %s; slot %d's pool %s" % [ZONE, String(zd["name"]), String(zd["boss"]), str(zd["rosters"]), SLOT, str(pools[SLOT - 1])])
	ok(String(zd["name"]) == ZONE_NAME and String(zd["boss"]) == BOSS, "§1: the zone def names '%s' and boss %s, not '%s' and %s" % [String(zd["name"]), String(zd["boss"]), ZONE_NAME, BOSS])
	ok((pools[SLOT - 1] as Array) == [OLD, ZONE], "§1: slot %d's pool is %s — the Scarlands first, the Barrow its second candidate" % [SLOT, str(pools[SLOT - 1])])
	var rosters: Dictionary = zd["rosters"]
	ok(rosters.size() == 1 and rosters.has(SLOT), "§1: the Barrow does not host slot %d alone: it carries %s" % [SLOT, str(rosters)])
	var roster := int(rosters.get(SLOT, -1))
	var taken: Array = []
	for z2 in (_run.ZONE_DEFS as Dictionary):
		if z2 != ZONE:
			for r in (_run.ZONE_DEFS[z2]["rosters"] as Dictionary).values():
				taken.append(int(r))
	ok(roster > 0 and not taken.has(roster), "§1: the Barrow's roster %d is another zone's" % roster)
	# THE ROSTER, DERIVED: the core (every kind tagged for rosters 1, 2 and 3), JU's four and the Barrow's three, and nothing else.
	var want: Array = []
	for k in data:
		var z := _zones(data[k])
		if OLD_ROSTERS.all(func(r): return z.has(r)):
			want.append(String(k))
	want.append_array(FOUR)
	want.append_array(KINDS)
	want.append(BOSS)
	want.sort()
	var have: Array = Enemies.kinds_for_roster(roster).duplicate()
	have.sort()
	print("    roster %d holds %d kinds: %s" % [roster, have.size(), ", ".join(PackedStringArray(have))])
	ok(have == want, "§1: roster %d holds %s, not the core, JU's four and the Barrow's three (%s)" % [roster, str(have), str(want)])
	var strays: Array = []
	for k2 in FOUR + KINDS + [BOSS]:
		if _zones(data[k2]) != [roster]:
			strays.append("%s %s" % [k2, str(_zones(data[k2]))])
	ok(strays.is_empty(), "§1: a kind of the Barrow's stands in another roster too: %s" % str(strays))
	var counts := []
	for r2 in [1, 2, 3, 4, 5, roster]:
		counts.append("%d: %d" % [r2, Enemies.kinds_for_roster(r2).size()])
	print("    kinds a roster holds — %s" % ", ".join(PackedStringArray(counts)))
	# THE DRAW: a player's road and a sim's each draw both of slot 2's candidates; the flag holds a sim to the first.
	var seen := {"player": {}, "sim": {}, "held": {}}
	for arm in ["player", "sim", "held"]:
		_run.sim_run = arm != "player"
		OS.set_environment("DOD_ZONE_ROTATION", "0" if arm == "held" else "")
		seed(20261114)
		for i in 60:
			_run.draw_zones()
			seen[arm][String(_run.zone_draw[SLOT - 1])] = true
	_run.sim_run = false
	OS.set_environment("DOD_ZONE_ROTATION", "")
	print("    slot %d drawn — a player's road %s; a sim's %s; a sim held by DOD_ZONE_ROTATION=0 %s" % [SLOT, str(seen["player"].keys()), str(seen["sim"].keys()), str(seen["held"].keys())])
	ok(seen["player"].has(ZONE) and seen["player"].has(OLD), "§1: a player's road never draws one of slot %d's candidates: %s" % [SLOT, str(seen["player"].keys())])
	ok(seen["sim"].has(ZONE) and seen["sim"].has(OLD), "§1: a sim's road never draws one of slot %d's candidates: %s" % [SLOT, str(seen["sim"].keys())])
	ok(seen["held"].keys() == [OLD], "§1: DOD_ZONE_ROTATION=0 does not hold a sim to the Scarlands: %s" % str(seen["held"].keys()))
	# THE MAP: a Barrow zone's every fight node composes from its roster, the boss node fields the Shepherd.
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	_run.zone_draw[SLOT - 1] = ZONE
	_run.zone_idx = SLOT - 1
	_run._enter_zone()
	var outside: Array = []
	var empty: Array = []
	var boss_seen := 0
	var nodes := 0
	for m in 20:
		_run._generate_map()
		for col in _run.map:
			for node in col:
				var en: Array = (node as Dictionary).get("enemies", [])
				if not String(node.get("type", "")) in ["fight", "elite", "miniboss", "boss"]:
					continue
				nodes += 1
				if en.is_empty():
					empty.append(String(node.get("type", "")))
				for e in en:
					if not _zones(data.get(String(e), {})).has(roster):
						outside.append(String(e))
				if String(node.get("type", "")) == "boss" and en.has(BOSS):
					boss_seen += 1
	print("    20 Barrow maps: %d fight, elite and boss nodes; %d empty; %d bodies from outside roster %d; the Shepherd on %d boss nodes" % [nodes, empty.size(), outside.size(), roster, boss_seen])
	ok(nodes >= 100 and empty.is_empty(), "§1: a Barrow node composed no warband: %s" % str(empty.slice(0, 5)))
	ok(outside.is_empty(), "§1: a Barrow node fields a kind outside roster %d: %s" % [roster, str(outside.slice(0, 5))])
	ok(boss_seen >= 20, "§1: the Barrow's boss node fields the Shepherd on %d of 20 maps" % boss_seen)
	_run.active = false
	# THE BACKDROPS, read where each screen names a zone's art.
	var named: Array = BACKDROPS.filter(func(f): return FileAccess.get_file_as_string("res://" + String(f)).contains("\"%s\": \"res://assets/backgrounds/" % ZONE_NAME))
	ok(named.size() == BACKDROPS.size(), "§1: a screen names no backdrop for the Barrow — read %s of %s" % [str(named), str(BACKDROPS)])
	# THE SCARLAND MIRAGE IS THE SCARLANDS': refused in the Barrow at slot 2, offered in the Scarlands.
	var cfg := Events.config("scarland_mirage")
	var req: Dictionary = cfg.get("requires", {})
	ok((req.get("zone", []) as Array).has(OLD) and not (req.get("zone", []) as Array).has(ZONE), "§1: the Scarland Mirage is not the Scarlands' alone: %s" % str(req))


# ── THE BOARD ──────────────────────────────────────────────────────────────
func _board() -> Node:
	var s: Node = await Gate.spawn(self, SEATS, {"deterministic": true})
	return s


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array)


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(h): return not (h as BattleUnit).is_companion)


# One foe on the board made a kind: its kit, its health; nothing cooling, no status.
func _as_kind(f: BattleUnit, kind: String) -> void:
	var cfg := Enemies.config(kind)
	f.abilities = cfg["abilities"]
	f.unit_name = String(cfg.get("unit_name", kind))
	f.max_hp = int(cfg.get("max_hp", f.max_hp))
	f.hp = f.max_hp
	f.cooldowns = {}
	f.intent = {}
	f.statuses.clear()


func _ab(u: BattleUnit, name: String) -> Ability:
	for a in u.abilities:
		if (a as Ability).display_name == name:
			return a
	return null


func _done(s: Node) -> void:
	s.queue_free()
	await Gate.frames(self, 2)


# ── §2 — THE BONE SHEPHERD ─────────────────────────────────────────────────
func _s2_the_shepherd() -> void:
	print("\n§2 — the Bone Shepherd: Soul Leech heals on the pool, Noxious Fumes moves the hit chance")
	var s := await _board()
	var foes := _foes(s)
	var sh: BattleUnit = foes[0]
	_as_kind(sh, BOSS)
	var leech := _ab(sh, "Soul Leech")
	var fumes := _ab(sh, "Noxious Fumes")
	var call := _ab(sh, "Call the Drowned")
	# FOUR MOVES (the record's Q9, its first branch): the fourth his pattern's, the Tyrant's Rally — JK's floor, a Rally or an Entrench.
	var rally := _ab(sh, "Rally")
	ok(leech != null and fumes != null and call != null and rally != null and sh.abilities.size() == 4, "§2: the Shepherd's kit is not Soul Leech, Noxious Fumes, Call the Drowned and a Rally: %s" % str(sh.abilities.map(func(a): return (a as Ability).display_name)))
	if leech == null or fumes == null or call == null:
		await _done(s)
		return
	ok(s._cheapest_attack(sh) == leech and leech.lifesteal > 0.0, "§2: Soul Leech is not the Shepherd's basic, or carries no lifesteal")
	ok(call.special == "malice_raise" and rally != null and rally.special == "malice_rally", "§2: Call the Drowned is not JK's Raise (%s), or the fourth no Rally" % call.special)
	var h: BattleUnit = _heroes(s)[0]
	# A POOL OF NOTHING: the blow lands, the heal asks and gets nothing, the pool pays nothing.
	for arm in [0, 9999]:
		sh.hp = sh.max_hp / 2
		h.hp = h.max_hp
		s.malice = arm
		var paid0 := int(s.malice_ledger["spent"])
		var hp0 := sh.hp
		var hh0 := h.hp
		await s._resolve(sh, leech, h, "good")
		var dealt := hh0 - h.hp
		var gained := sh.hp - hp0
		var paid := int(s.malice_ledger["spent"]) - paid0
		var asked := int(dealt * leech.lifesteal)
		print("    Malice %d: Soul Leech dealt %d, asked %d, healed %d, paid %d" % [arm, dealt, asked, gained, paid])
		ok(dealt > 0, "§2: Soul Leech dealt nothing to a hero (Malice %d)" % arm)
		ok(gained == paid, "§2: the Shepherd gained %d health and the pool paid %d (Malice %d) — a heal unpaid" % [gained, paid, arm])
		if arm == 0:
			ok(gained == 0, "§2: with the pool empty Soul Leech still healed %d" % gained)
		else:
			ok(gained == mini(asked, sh.max_hp - hp0) and gained > 0, "§2: with the pool full Soul Leech healed %d, not the %d it asked" % [gained, asked])
	# NOXIOUS FUMES: every hero it strikes carries the status, and the hit chance moves by the constant.
	var before: Array = []
	for hh in _heroes(s):
		hh.hp = hh.max_hp
		# The board's heroes carry `no_cover` (deterministic: no miss); the hit chance is read with it off, before and after.
		hh.no_cover = 0
		before.append(s._miss_chance(hh))
	await s._resolve(sh, fumes, h, "good")
	var carried := 0
	var moved := 0
	var i := 0
	for hh2 in _heroes(s):
		if hh2.has_status("noxious_fumes"):
			carried += 1
			if is_equal_approx(s._miss_chance(hh2) - float(before[i]), float(s.NOXIOUS_FUMES_MISS_PCT)):
				moved += 1
		i += 1
	print("    Noxious Fumes: %d of %d heroes carry it; the miss chance moved by %.2f on %d" % [carried, _heroes(s).size(), float(s.NOXIOUS_FUMES_MISS_PCT), moved])
	ok(carried == _heroes(s).size() and moved == carried, "§2: Noxious Fumes reached %d heroes and moved the miss chance on %d" % [carried, moved])
	ok(BattleUnit.DEBUFF_IDS.has("noxious_fumes"), "§2: Noxious Fumes is not a debuff a cleanse lifts")
	await _done(s)


# ── §3 — THE ROTFIEND AND THE FEN LURKER ───────────────────────────────────
func _s3_the_kinds() -> void:
	print("\n§3 — the Rotfiend, the Fen Lurker and Black Rot, driven")
	var s := await _board()
	var foes := _foes(s)
	var rf: BattleUnit = foes[1]
	_as_kind(rf, "rotfiend")
	var rake := _ab(rf, "Rake")
	var boom := _ab(rf, "Corpse Explosion")
	ok(rake != null and boom != null and _ab(rf, "Sodden Claw") != null, "§3: the Rotfiend's kit is not Sodden Claw, Rake and Corpse Explosion")
	var h: BattleUnit = _heroes(s)[1]
	if rake != null:
		await s._resolve(rf, rake, h, "good")
		await s._resolve(rf, rake, h, "good")
		var st: Dictionary = h.get_status("black_rot")
		print("    Rake twice on %s: Black Rot %d stacks, turns %d" % [h.unit_name, h.status_stacks("black_rot"), int(st.get("turns", 0))])
		ok(h.status_stacks("black_rot") == 2 and int(st.get("turns", 0)) < 0, "§3: two Rakes laid %d stacks of Black Rot, turns %d — not two, battle-long" % [h.status_stacks("black_rot"), int(st.get("turns", 0))])
		# THE TICK: its share of the bearer's own maximum a stack, at the turn start.
		h.hp = h.max_hp
		var hp0 := h.hp
		await s._black_rot_tick(h)
		# Read off the script at run time, so the gate parses on a tree without it (HEAD's, under the control).
		var pct := float((load("res://scripts/unit.gd") as Script).get_script_constant_map().get("BLACK_ROT_PCT", 0.0))
		var want := maxi(int(round(h.max_hp * pct * 2)), 1)
		print("    the tick: %d (want %d of %d health); still carried after: %s" % [hp0 - h.hp, want, h.max_hp, str(h.has_status("black_rot"))])
		ok(hp0 - h.hp == want and h.has_status("black_rot"), "§3: Black Rot ticked %d, not %d, or ran out" % [hp0 - h.hp, want])
		ok(BattleUnit.DEBUFF_IDS.has("black_rot") and not s._cleansable_debuffs(h).filter(func(x): return String(x.id) == "black_rot").is_empty(), "§3: Black Rot is not a debuff a cleanse lifts")
	if boom != null:
		# WITHHELD ABOVE HALF; A CANDIDATE AT IT.
		rf.hp = rf.max_hp
		var held: bool = s._blow_withheld(rf, boom)
		rf.hp = int(rf.max_hp * float(s.CORPSE_EXPLOSION_AT))
		var free: bool = not s._blow_withheld(rf, boom)
		ok(held and free, "§3: Corpse Explosion is not withheld above half the Rotfiend's health and offered at it (%s, %s)" % [str(held), str(free)])
		# THE BLAST: every hero struck with a stack, the Rotfiend dead through the door, a neighbour healed and paid for.
		for hh in _heroes(s):
			hh.remove_status("black_rot")
			hh.hp = hh.max_hp
		var nb: BattleUnit = foes[0]
		nb.hp = nb.max_hp / 4
		foes[2].hp = foes[2].max_hp
		s.malice = 0
		var gen0 := int(s.malice_ledger["generated"])
		var paid0 := int(s.malice_ledger["spent"])
		var nb0 := nb.hp
		await s._resolve(rf, boom, _heroes(s)[0], "good")
		var rotted := _heroes(s).filter(func(x): return x.has_status("black_rot")).size()
		var healed := nb.hp - nb0
		var paid := int(s.malice_ledger["spent"]) - paid0
		print("    Corpse Explosion: %d of %d heroes rotted; the Rotfiend dead %s; Malice given %d; the neighbour healed %d, paid %d" % [rotted, _heroes(s).size(), str(rf.dead), int(s.malice_ledger["generated"]) - gen0, healed, paid])
		ok(rotted == _heroes(s).size(), "§3: Corpse Explosion laid Black Rot on %d heroes" % rotted)
		ok(rf.dead and int(s.malice_ledger["generated"]) - gen0 >= int(s.MALICE_PER_KILL), "§3: the Rotfiend did not die through the death door (dead %s)" % str(rf.dead))
		var want_heal := mini(maxi(int(round(nb.max_hp * float(s.CORPSE_EXPLOSION_HEAL_PCT))), 1), nb.max_hp - nb0)
		ok(healed == paid and healed == mini(want_heal, int(s.MALICE_PER_KILL)), "§3: the neighbour healed %d and the pool paid %d — want %d" % [healed, paid, mini(want_heal, int(s.MALICE_PER_KILL))])
		ok(s._raise_holds(rf), "§3: the burst Rotfiend cannot be Raised")
	await _done(s)
	# THE FEN LURKER.
	s = await _board()
	foes = _foes(s)
	var fl: BattleUnit = foes[0]
	_as_kind(fl, "fen_lurker")
	var swipe := _ab(fl, "Swipe")
	var lac := _ab(fl, "Lacerate")
	ok(swipe != null and lac != null and _ab(fl, "Submerge") != null, "§3: the Fen Lurker's kit is not Swipe, Lacerate and Submerge")
	if swipe != null:
		ok(swipe.choose_two and s._cheapest_attack(fl) == swipe, "§3: Swipe is not the Fen Lurker's two-hero basic")
		# A STALE PICK OF THE WARBAND's in the battle var: the second body still comes from the heroes' side.
		s.second_target = foes[1]
		var hs: Array = s._hero_side()
		var hp0: Array = hs.map(func(x): return x.hp)
		var f0: Array = foes.map(func(x): return x.hp)
		await s._resolve(fl, swipe, hs[0], "good")
		var struck_h := 0
		for j in hs.size():
			if hs[j].hp < int(hp0[j]):
				struck_h += 1
		var struck_f := 0
		for j2 in foes.size():
			if foes[j2] != fl and foes[j2].hp < int(f0[j2]):
				struck_f += 1
		print("    Swipe: %d heroes struck, %d of the warband" % [struck_h, struck_f])
		ok(struck_h == 2 and struck_f == 0, "§3: Swipe struck %d heroes and %d of the warband — not two heroes" % [struck_h, struck_f])
	# A SUBMERGE REFUSED AT ITS TURN FALLS BACK TO SWIPE — AT A HERO, NEVER AT THE LURKER (FOUND AT JI's first item, closed at JW).
	var dive0 := _ab(fl, "Submerge")
	if dive0 != null and swipe != null:
		fl.intent = {"ability": dive0, "target": fl, "support": true, "turns": 1, "malice": 0, "message": "", "logs": [], "category": "bolster"}
		fl.hp = fl.max_hp
		var fb: Dictionary = s._revalidate_intent(fl)
		var fb_t: Variant = fb.get("target")
		print("    a Submerge refused at its turn: falls back to %s at %s" % [
			(fb.get("ability") as Ability).display_name if fb.get("ability") is Ability else "nothing",
			(fb_t as BattleUnit).unit_name if fb_t is BattleUnit else "nobody"])
		ok(fb.get("ability") == swipe and fb_t is BattleUnit and fb_t != fl and s._hero_side().has(fb_t),
			"§3: a refused Submerge fell back onto its own side, not at a hero")
	if lac != null:
		var h2: BattleUnit = _heroes(s)[2]
		h2.bleed_buildup = 0
		await s._resolve(fl, lac, h2, "good")
		print("    Lacerate: %s's Bleed %d" % [h2.unit_name, h2.bleed_buildup])
		ok(lac.bleed_build > 0 and h2.bleed_buildup == lac.bleed_build, "§3: Lacerate opened %d Bleed, not its %d" % [h2.bleed_buildup, lac.bleed_build])
	await _done(s)


# ── §4 — A BODY NO PICK MAY REACH ──────────────────────────────────────────
# A line with every string's contents blanked: a word inside a quote (`encounter["enemies"]`, a log line) is no read of the warband.
func _mask(line: String) -> String:
	var out := ""
	var quote := ""
	var i := 0
	while i < line.length():
		var c := line[i]
		if quote != "":
			if c == "\\":
				i += 2
				continue
			if c == quote:
				quote = ""
				out += c
		elif c == "\"" or c == "'":
			quote = c
			out += c
		else:
			out += c
		i += 1
	return out


func _sites() -> Dictionary:
	# {"file|function|code": count} for every line of the pick files that names the warband, comments stripped.
	var out := {}
	var word := RegEx.new()
	word.compile("(?<![A-Za-z0-9_])enemies(?![A-Za-z0-9_])|_adjacent_enemies\\(")
	var fn := RegEx.new()
	fn.compile("^(static\\s+)?func\\s+(\\w+)\\s*\\(")
	for f in PICK_FILES:
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://" + String(f)))
		var cur := ""
		for line in src.split("\n"):
			var m := fn.search(line)
			if m != null:
				cur = m.get_string(2)
			if word.search(_mask(String(line))) != null:
				var key := "%s|%s|%s" % [f, cur, String(line).strip_edges().replace("\t", " ")]
				out[key] = int(out.get(key, 0)) + 1
	return out


func _census() -> Dictionary:
	var out := {}
	var lines := FileAccess.get_file_as_string(CENSUS).split("\n", false)
	if lines.is_empty():
		return out
	var head := String(lines[0]).split("\t")
	var cf := head.find("file")
	var cn := head.find("function")
	var cc := head.find("code")
	var ck := head.find("class")
	for r in lines.slice(1):
		var c := String(r).split("\t")
		if c.size() <= maxi(maxi(cf, cn), maxi(cc, ck)):
			continue
		var key := "%s|%s|%s" % [c[cf], c[cn], c[cc]]
		if not out.has(key):
			out[key] = []
		out[key].append(c[ck])
	return out


func _s4_no_pick(data: Dictionary) -> void:
	print("\n§4 — a submerged body: the census of every site, the door, the area and the scatter, the stall")
	var sites := _sites()
	var census := _census()
	var unlisted: Array = []
	var gone: Array = []
	var bad_class: Array = []
	var counts := {}
	for k in sites:
		var have: Array = census.get(k, [])
		if have.size() != int(sites[k]):
			unlisted.append("%s (x%d in the source, x%d in the census)" % [k, int(sites[k]), have.size()])
	for k2 in census:
		if not sites.has(k2):
			gone.append(k2)
		for cl in census[k2]:
			counts[cl] = int(counts.get(cl, 0)) + 1
			if not PICK_CLASSES.has(String(cl)):
				bad_class.append("%s: %s" % [k2, cl])
	var total := 0
	for k3 in sites:
		total += int(sites[k3])
	var rows_n := 0
	for k4 in census:
		rows_n += (census[k4] as Array).size()
	print("    CHECKED %d sites in %s against %d census rows (%d distinct lines): %s" % [total, str(PICK_FILES), rows_n, census.size(), str(counts)])
	ok(total >= 150 and census.size() >= 100, "§4: the derivation read %d sites and the census %d rows — one of them has stopped reading" % [total, census.size()])
	ok(unlisted.is_empty(), "§4: %d sites of the battle read the warband and the census does not classify them: %s" % [unlisted.size(), str(unlisted.slice(0, 4))])
	ok(gone.is_empty(), "§4: %d census rows name a site the source no longer holds: %s" % [gone.size(), str(gone.slice(0, 4))])
	ok(bad_class.is_empty(), "§4: a census row carries no class this gate names: %s" % str(bad_class.slice(0, 4)))
	# THE DRIVES.
	var s := await _board()
	var foes := _foes(s)
	var fl: BattleUnit = foes[0]
	_as_kind(fl, "fen_lurker")
	var dive := _ab(fl, "Submerge")
	# ONCE A FIGHT, UNDER HALF, WHILE ANOTHER CAN BE PICKED.
	fl.hp = fl.max_hp
	var above: bool = s._submerge_holds(fl)
	fl.hp = int(fl.max_hp * float(s.SUBMERGE_AT)) - 1
	var under: bool = s._submerge_holds(fl)
	ok(not above and under, "§4: Submerge does not wait for half the Lurker's health (above %s, under %s)" % [str(above), str(under)])
	await s._resolve(fl, dive, fl, "good")
	ok(fl.has_status("submerged") and not s._pickable(fl), "§4: Submerge laid nothing, or the submerged Lurker can still be picked")
	ok(not s._submerge_holds(fl), "§4: a submerged Lurker could submerge again")
	# ONCE A FIGHT: surfaced, under half, its fellows standing to be picked — and still no second dive.
	fl.remove_status("submerged")
	var again: bool = s._submerge_holds(fl)
	s._apply_status(fl, "submerged", int(s.SUBMERGE_TURNS), 0, 0, fl)
	ok(not again, "§4: a Lurker that has submerged once could submerge a second time in the fight")
	# THE DOOR: a single blow onto it does not land; an area and a scatter pass it by.
	var h: BattleUnit = _heroes(s)[0]
	var basic: Ability = s._cheapest_attack(h)
	var hp0 := fl.hp
	await s._resolve(h, basic, fl, "good")
	print("    a single blow onto the submerged Lurker: it lost %d" % (hp0 - fl.hp))
	ok(fl.hp == hp0, "§4: a single blow landed on a submerged body (%d)" % (hp0 - fl.hp))
	var area: Ability = Ability.make({"display_name": "JW Probe Sweep", "damage": 20, "pressure": 0, "aoe": true, "anim": "attack01", "delay": 2.0})
	var f1: BattleUnit = foes[1]
	var f1h := f1.hp
	hp0 = fl.hp
	await s._resolve(h, area, f1, "good")
	print("    an area blow: the Lurker lost %d, a pickable fellow %d" % [hp0 - fl.hp, f1h - f1.hp])
	ok(fl.hp == hp0 and f1.hp < f1h, "§4: an area blow struck the submerged Lurker (%d) or missed the pickable (%d)" % [hp0 - fl.hp, f1h - f1.hp])
	var scatter: Ability = Ability.make({"display_name": "JW Probe Scatter", "damage": 5, "pressure": 0, "random_hits": 12, "anim": "attack01", "delay": 2.0})
	hp0 = fl.hp
	await s._resolve(h, scatter, f1, "good")
	ok(fl.hp == hp0, "§4: a scatter struck the submerged Lurker (%d)" % (hp0 - fl.hp))
	# ALONE: a second Lurker under half, its one pickable fellow fallen and the first submerged — it may not dive.
	var f2: BattleUnit = foes[1]
	_as_kind(f2, "fen_lurker")
	f2.hp = int(f2.max_hp * float(s.SUBMERGE_AT)) - 1
	foes[2].hp = 0
	foes[2]._die()
	print("    a second Lurker under half with no fellow that can be picked: may submerge %s; the first still under %s" % [str(s._submerge_holds(f2)), str(fl.has_status("submerged"))])
	ok(fl.has_status("submerged") and not s._submerge_holds(f2), "§4: a Lurker could submerge with no other body of its warband to be picked")
	# THE STALL: the last pickable body falls, and the submerged surface.
	for f in foes:
		if f != fl and not f.dead:
			f.hp = 0
			f._die()
	print("    the last pickable body fell: the Lurker submerged %s, pickable %s" % [str(fl.has_status("submerged")), str(s._pickable(fl))])
	ok(not fl.has_status("submerged") and s._pickable(fl), "§4: the last pickable body fell and the submerged Lurker did not surface")
	await _done(s)


# ── §5 — `advance_zone` ASKS FIRST ─────────────────────────────────────────
func _s5_advance_zone() -> void:
	print("\n§5 — every caller of advance_zone in scripts/ asks has_next_zone first; the function asks too")
	var callers: Array = []
	var unasked: Array = []
	var dir := DirAccess.open("res://scripts")
	var call := RegEx.new()
	call.compile("(?<![A-Za-z0-9_])advance_zone\\(")
	var fn := RegEx.new()
	fn.compile("^(static\\s+)?func\\s+(\\w+)\\s*\\(")
	for f in dir.get_files():
		if not String(f).ends_with(".gd"):
			continue
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
		var cur := ""
		var body := ""
		for line in src.split("\n"):
			var m := fn.search(line)
			if m != null:
				cur = m.get_string(2)
				body = ""
			body += String(line) + "\n"
			if call.search(line) != null and m == null:
				callers.append("%s:%s" % [f, cur])
				if not body.contains("has_next_zone("):
					unasked.append("%s:%s" % [f, cur])
	print("    CHECKED %d callers: %s" % [callers.size(), str(callers)])
	ok(callers.size() >= 2, "§5: the walk found %d callers of advance_zone in scripts/" % callers.size())
	ok(unasked.is_empty(), "§5: a caller calls advance_zone without asking has_next_zone first: %s" % str(unasked))
	var guard := Gate.fn_body("scripts/run_state.gd", "advance_zone", _cache)
	ok(guard.contains("if not has_next_zone():") and guard.find("if not has_next_zone():") < guard.find("zone_idx += 1"), "§5: advance_zone does not ask has_next_zone before it moves the index")
	# DRIVEN: at the last zone nothing moves.
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	_run.zone_idx = int(_run.SLOT_COUNT) - 1
	_run._enter_zone()
	_run._generate_map()
	var map0: Variant = _run.map
	var name0 := String(_run.zone_name)
	_run.advance_zone()
	print("    at the last zone: index %d, name '%s', map unchanged %s" % [int(_run.zone_idx), String(_run.zone_name), str(_run.map == map0)])
	ok(int(_run.zone_idx) == int(_run.SLOT_COUNT) - 1 and String(_run.zone_name) == name0 and _run.map == map0, "§5: advance_zone at the last zone moved the run (index %d)" % int(_run.zone_idx))
	_run.active = false
