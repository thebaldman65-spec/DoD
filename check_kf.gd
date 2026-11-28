# BATCH KF — A CHIP ON THE HERO SIDE SAYS WHICH WAY IT CUTS, AND A ZONE FIELDS ITS OWN KINDS (the designer's two asks, 24 November,
# after playtesting KE's build: *"a distinction on the hero name plates between buffs and debuffs"*; *"enemies are not showing up
# in there correct zones"*).
#
# What this gate asserts, section by section (`docs/reports/KF.md` has the working):
#
#   §1  THE PLATES, DRIVEN: on a hero's plate a debuff's chip and a cost's are framed red and thick, a buff's and a display
#       chip's green and thin — a frame that is no `ColorRect` (a chip is still one), takes no mouse and stands between its chip's
#       fill and its tag — and its hover leads with its word (*Debuff:*, *Cost:*, *Buff:*); an engine chip is unframed; an enemy's
#       plate is unframed. Every status STATUS_INFO holds, and every id a line of unit.gd or battle.gd lays by its literal, is
#       classed in KF's census of record (`docs/reports/KF-cuts.tsv`), and
#       `BattleUnit.status_cut` draws each as its row says — so a status written later reds until it is classed; the costs are
#       `PLATE_COST_IDS`, none in the registry; Broken and the Bleed chip debuffs (the census's three rows outside STATUS_INFO);
#       a composition the worst of its ingredients. Rime's row a buff holds it out of the registry (S4-177).
#   §2  THE ROSTERS: the zones read off `Run.ZONE_ORDER`; no kind of a zone past the Forest and the Scarlands stands in either of
#       theirs or in another new zone's, but
#       the Hollow Crown (never composed) — since KG §1 the Orc Chief is the old zones' elite alone; at every budget a node of each
#       kind can roll, some theme of that node composes in every zone's roster, so no node falls to the plain fallback; twenty maps
#       of each of the two zones compose every fight, elite and boss node from that zone's roster, none empty, no Orc among them,
#       every elite node fielding its zone's own elite, and
#       every boss node the zone's own boss and no other boss-tagged kind (S2-090, GI's rule; the Hollow Crown is in both rosters).
#   §3  THE RECORD: `CLAUDE.md` holds the zone rule's block and the chip bullet.
#   §4  The player's files are as this gate found them.
#
# What it cannot assert, said so it is not mistaken for coverage: whether a player reads the frames at a glance — the frame's
# colours and widths are the batch's, the designer's to re-rule; and what fields an elite node in the two zones is the
# designer's (KF's NEEDS A RULING), answered (a) and built at KG §1: §2 holds each zone's own elite.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "archer"]}
const SCRATCH_PROFILE := "user://kf_profile.json"
const SCRATCH_RELICS := "user://kf_relics.json"
# The two zones whose rosters the Orcs held first; every zone `Run.ZONE_ORDER` holds past them is a new zone, read off the order.
const ZONES_OLD := ["forest", "scarlands"]
# The kind that may stand in an old zone's roster and a new one's: the end boss no node composes. BATCH KG §1 — the Orc Chief
# travelled too until each new zone took its own elite (the designer's (a)); repaired to its intent, never deleted.
const MAY_TRAVEL := ["hollow_crown"]
const ZONE_BLOCK := "## STANDING DESIGN RULE — A ZONE FIELDS ITS OWN KINDS"
const CHIP_WORDS := "A CHIP ON THE HERO SIDE SAYS WHICH WAY IT CUTS"
const CUTS := "res://docs/reports/KF-cuts.tsv"
# BATCH KJ — the census classes the rework's seven statuses by its own rows' meanings: the four hexes the warband lays on a hero
# (Silenced, Branded, Doomed, Singled Out) are debuffs in DEBUFF_IDS; the three a body of the warband wears (Guarding, Hunkered,
# Fury) are an enemy's own boons, on a plate that is unframed.
# The three the registry names that STATUS_INFO does not, each drawn on a plate by its own writer (Broken, the Bleed meter's chip,
# Melt Armor's display chip): the census classes them too, beside every id a line lays by its literal (§1's walk).
const OUTSIDE_INFO := ["broken", "bleed", "melted"]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH KF — THE PLATES' CUT, AND A ZONE's OWN KINDS")
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
	await _s1_plates()
	_s2_rosters()
	_s3_record()
	Engine.time_scale = 1.0
	_s4_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


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


# The row's live children of one kind, in the order they were drawn.
func _row(u: BattleUnit, frames: bool) -> Array:
	var out: Array = []
	var r: Node = u.get("_chips_root")
	for c in (r.get_children() if r != null else []):
		if c.is_queued_for_deletion():
			continue
		if frames and c is ReferenceRect:
			out.append(c)
		elif not frames and c is ColorRect:
			out.append(c)
	return out


# The chip past the engine chips whose hover names `label` (its first line), or null — an engine chip's own name can hold a
# status's (the Berserker's beside Berserk), so the engine chips, drawn first, are passed over.
func _chip_named(u: BattleUnit, label: String) -> ColorRect:
	var rects := _row(u, false)
	for i in range(u.engine_chips.size(), rects.size()):
		var c: ColorRect = rects[i]
		var first := String(c.tooltip_text).get_slice("\n", 0)
		if first.contains(label):
			return c
	return null


# The frame standing where `chip` stands, or null.
func _frame_at(u: BattleUnit, chip: ColorRect) -> ReferenceRect:
	if chip == null:
		return null
	for f in _row(u, true):
		if (f as ReferenceRect).position == chip.position and (f as ReferenceRect).size == chip.size:
			return f
	return null


# ── §1 — THE PLATES ──────────────────────────────────────────────────────────

func _s1_plates() -> void:
	print("\n§1 — the plates: a debuff and a cost framed red and thick, a buff green and thin, on the hero side alone")
	var s: Node = await _battle()
	var info: Dictionary = (s.get_script() as Script).get_script_constant_map().get("STATUS_INFO", {})
	ok(info.size() > 100, "§1: the battle's STATUS_INFO read %d statuses" % info.size())
	# THE CENSUS OF RECORD: every status the battle knows is classed, and the class is the one `status_cut` draws.
	var census := {}
	for line in FileAccess.get_file_as_string(CUTS).split("\n", false).slice(1):
		var c := String(line).split("\t")
		if c.size() >= 5:
			census[c[0]] = c[3]
	var unclassed: Array = []
	var wrong: Array = []
	var n := {"debuff": 0, "cost": 0, "buff": 0}
	for id in info:
		if not census.has(id):
			unclassed.append(String(id))
			continue
		var cut := BattleUnit.status_cut({"id": String(id)})
		if cut != String(census[id]):
			wrong.append("%s draws %s, the census says %s" % [id, cut, census[id]])
		if n.has(cut):
			n[cut] += 1
	for o in OUTSIDE_INFO:
		if not census.has(o):
			unclassed.append(String(o))
		elif BattleUnit.status_cut({"id": String(o)}) != String(census[o]):
			wrong.append("%s draws %s, the census says %s" % [o, BattleUnit.status_cut({"id": String(o)}), census[o]])
	# EVERY STATUS A LINE LAYS BY ITS LITERAL ID, outside STATUS_INFO too: a new one reds until the census classes it.
	var laid := {}
	var re_laid := RegEx.create_from_string("(?:add_status\\(\\s*|_apply_status\\([^,\\n]+,\\s*)\"([a-z0-9_]+)\"")
	for f in ["res://scripts/unit.gd", "res://scripts/battle.gd"]:
		for m in re_laid.search_all(FileAccess.get_file_as_string(f)):
			laid[m.get_string(1)] = true
	var outside: Array = laid.keys().filter(func(k): return not info.has(k))
	outside.sort()
	print("    CHECKED %d ids laid by a literal, %d outside STATUS_INFO: %s" % [laid.size(), outside.size(), ", ".join(PackedStringArray(outside))])
	for o2 in outside:
		if not census.has(o2):
			unclassed.append(String(o2))
		elif BattleUnit.status_cut({"id": String(o2)}) != String(census[o2]):
			wrong.append("%s draws %s, the census says %s" % [o2, BattleUnit.status_cut({"id": String(o2)}), census[o2]])
	ok(laid.size() >= 100 and outside.size() >= 5, "§1: the literal walk read %d ids, %d outside STATUS_INFO — the walk is broken" % [laid.size(), outside.size()])
	var stale: Array = census.keys().filter(func(k): return not info.has(k) and not OUTSIDE_INFO.has(k) and not laid.has(k))
	print("    CHECKED %d of %d statuses against the census of record: %d debuff, %d cost, %d buff" % [
		info.size() - unclassed.size(), info.size(), n["debuff"], n["cost"], n["buff"]])
	ok(unclassed.is_empty(), "§1: a status no row of the census classes: %s" % str(unclassed))
	ok(stale.is_empty(), "§1: a census row names no status the battle knows: %s" % str(stale))
	ok(wrong.is_empty(), "§1: a status cut against the census: %s" % str(wrong))
	ok(n["debuff"] >= 30 and n["buff"] >= 100, "§1: the census reads %s" % str(n))
	var cost_rows: Array = census.keys().filter(func(k): return String(census[k]) == "cost")
	cost_rows.sort()
	var cost_ids: Array = BattleUnit.PLATE_COST_IDS.duplicate()
	cost_ids.sort()
	ok(cost_rows == cost_ids and not cost_ids.any(func(c): return BattleUnit.DEBUFF_IDS.has(c)),
		"§1: the census's costs %s are not PLATE_COST_IDS %s, or one is in the registry" % [str(cost_rows), str(cost_ids)])
	ok(BattleUnit.status_cut({"id": "broken"}) == "debuff", "§1: Broken does not draw as a debuff")
	ok(BattleUnit.status_cut({"id": "rupture_gate", "parts": [{"id": "burn"}, {"id": "chilled"}]}) == "debuff"
			and BattleUnit.status_cut({"id": "pair_gate", "parts": [{"id": "fortify"}, {"id": "ward"}]}) == "buff"
			and BattleUnit.status_cut({"id": "cost_gate", "parts": [{"id": "fortify"}, {"id": "berserk_risk"}]}) == "cost"
			and BattleUnit.status_cut({"id": "mixed_gate", "parts": [{"id": "berserk_risk"}, {"id": "sunder"}]}) == "debuff",
		"§1: a composition does not cut as the worst of its ingredients")
	# THE PLATE, DRIVEN.
	var h: BattleUnit = null
	for x in s.get("heroes"):
		if not (x as BattleUnit).is_companion:
			h = x
			break
	var foe: BattleUnit = (s.get("enemies") as Array)[0]
	for st in h.statuses.duplicate():
		h.remove_status(String(st.id))
	for dc in h.display_chips.duplicate():
		h.remove_display_chip(String(dc.id))
	await Gate.frames(self, 1)
	var before := _row(h, false).size()
	var frames0 := _row(h, true).size()
	print("    the hero bare: %d chips (%d engine), %d frames" % [before, h.engine_chips.size(), frames0])
	ok(h.engine_chips.size() >= 1, "§1: the hero holds no engine chip — the unframed engine chip is not driven")
	ok(frames0 == 0, "§1: a hero holding only his engine chip draws %d frames — want none" % frames0)
	s._apply_status(h, "sunder", 3, 0, 0, foe)
	s._apply_status(h, "fortify", 3, 10, 0, h)
	s._apply_status(h, "berserk_risk", 3, 0, 0, h)
	h.set_display_chip("kf_gate_chip", "Gate Chip", "GC", Color(0.7, 0.7, 0.7), "A display chip the gate lays.")
	await Gate.frames(self, 2)
	var chips := _row(h, false)
	var frames := _row(h, true)
	print("    the hero: %d chips before, %d after; %d frames" % [before, chips.size(), frames.size()])
	ok(chips.size() == before + 4, "§1: three statuses and a display chip drew %d chips beside %d — a frame drawn as a ColorRect?" % [chips.size(), before])
	ok(frames.size() == 4, "§1: three statuses and a display chip on the hero drew %d frames" % frames.size())
	var arms := [["Sunder", "debuff", "Debuff: "], ["Fortify", "buff", "Buff: "], ["Berserk", "cost", "Cost: "], ["Gate Chip", "buff", "Buff: "]]
	for arm in arms:
		var c := _chip_named(h, String(arm[0]))
		var f := _frame_at(h, c)
		var red: bool = arm[1] != "buff"
		var tip := String(c.tooltip_text) if c != null else ""
		var look := "none"
		if f != null:
			look = "%s %.0f px" % ["red" if f.border_color == BattleUnit.PLATE_DEBUFF_FRAME else "green" if f.border_color == BattleUnit.PLATE_BUFF_FRAME else "?", f.border_width]
		print("    %-9s chip %s, frame %s, its hover '%s'" % [arm[0], "found" if c != null else "MISSING", look, tip.get_slice("\n", 0)])
		ok(c != null and f != null, "§1: the %s chip has no frame where it stands" % arm[0])
		if f != null:
			ok(f.border_color == (BattleUnit.PLATE_DEBUFF_FRAME if red else BattleUnit.PLATE_BUFF_FRAME)
					and f.border_width == (BattleUnit.PLATE_DEBUFF_FRAME_W if red else BattleUnit.PLATE_BUFF_FRAME_W)
					and String(f.get_meta("chip_cut", "")) == arm[1] and not f.editor_only,
				"§1: the %s chip's frame is not a %s's" % [arm[0], arm[1]])
			ok(f.mouse_filter == Control.MOUSE_FILTER_IGNORE, "§1: the %s chip's frame takes the mouse" % arm[0])
			var tag_at := -1
			for k in _chips_children(h):
				if k is Label and (k as Label).position == c.position and k.get_index() > c.get_index():
					tag_at = k.get_index()
			ok(f.get_index() > c.get_index() and tag_at > f.get_index(),
				"§1: the %s chip's frame is not between its fill and its tag (fill %d, frame %d, tag %d)" % [arm[0], c.get_index(), f.get_index(), tag_at])
		ok(tip.begins_with(String(arm[2])), "§1: the %s chip's hover does not lead with its word: '%s'" % [arm[0], tip.get_slice("\n", 0)])
	ok(BattleUnit.PLATE_DEBUFF_FRAME_W > BattleUnit.PLATE_BUFF_FRAME_W,
		"§1: a debuff's frame is no thicker than a buff's — the two read apart by colour alone")
	h.remove_display_chip("kf_gate_chip")
	# AN ENEMY's PLATE IS DRAWN AS IT WAS.
	s._apply_status(foe, "sunder", 3, 0, 0, h)
	s._apply_status(foe, "warband_rally", 3, 0, 0, foe)
	await Gate.frames(self, 2)
	print("    the enemy: %d chips, %d frames" % [_row(foe, false).size(), _row(foe, true).size()])
	ok(_row(foe, false).size() >= 2 and _row(foe, true).is_empty(), "§1: an enemy's plate draws %d frames" % _row(foe, true).size())
	var etip := ""
	for c2 in _row(foe, false):
		etip += String((c2 as ColorRect).tooltip_text).get_slice("\n", 0) + " | "
	ok(not etip.contains("Debuff: ") and not etip.contains("Buff: ") and not etip.contains("Cost: "),
		"§1: an enemy's chip hover leads with a word: %s" % etip)
	Engine.time_scale = 1.0
	OS.set_environment("DOD_ENEMIES_OFF", "")


func _chips_children(u: BattleUnit) -> Array:
	var r: Node = u.get("_chips_root")
	return (r.get_children() if r != null else []).filter(func(k): return not k.is_queued_for_deletion())


# ── §2 — THE ROSTERS ─────────────────────────────────────────────────────────

func _roster_of(zone: String) -> int:
	return int((_run.ZONE_DEFS[zone] as Dictionary)["roster"])


func _s2_rosters() -> void:
	print("\n§2 — the rosters: every zone past the Forest and the Scarlands fields its own kinds")
	var order: Array = (_run.get_script() as Script).get_script_constant_map().get("ZONE_ORDER", [])
	ok(ZONES_OLD.all(func(z): return order.has(z)) and order.size() >= 4, "§2: Run.ZONE_ORDER %s does not hold the two old zones and a new one" % str(order))
	var ZONES_OWN: Array = order.filter(func(z): return not ZONES_OLD.has(z))
	print("    the zones, off Run.ZONE_ORDER: old %s, new %s" % [str(ZONES_OLD), str(ZONES_OWN)])
	var old := {}
	for z in ZONES_OLD:
		for k in Enemies.kinds_for_roster(_roster_of(z)):
			old[k] = true
	var strays: Array = []
	for z in ZONES_OWN:
		var ks: Array = Enemies.kinds_for_roster(_roster_of(z))
		print("    %-15s roster %d: %d kinds — %s" % [z, _roster_of(z), ks.size(), ", ".join(PackedStringArray(ks))])
		ok(ks.size() >= 7, "§2: %s's roster holds %d kinds" % [z, ks.size()])
		for k in ks:
			if old.has(k) and not MAY_TRAVEL.has(k):
				strays.append("%s in %s" % [k, z])
		ok(ks.has(String(_run.ZONE_DEFS[z]["boss"])), "§2: %s's boss is not in its roster" % z)
	for z in ZONES_OLD:
		print("    %-15s roster %d: %d kinds" % [z, _roster_of(z), Enemies.kinds_for_roster(_roster_of(z)).size()])
	ok(strays.is_empty(), "§2: a kind of the Forest's or the Scarlands' roster stands in a new zone's: %s" % str(strays))
	# AND NO NEW ZONE's KIND STANDS IN ANOTHER NEW ZONE's ROSTER, the named kind aside.
	var shared: Array = []
	for i in ZONES_OWN.size():
		for j in range(i + 1, ZONES_OWN.size()):
			for k in Enemies.kinds_for_roster(_roster_of(ZONES_OWN[i])):
				if Enemies.kinds_for_roster(_roster_of(ZONES_OWN[j])).has(k) and not MAY_TRAVEL.has(k):
					shared.append("%s in %s and %s" % [k, ZONES_OWN[i], ZONES_OWN[j]])
	ok(shared.is_empty(), "§2: a kind of one new zone's roster stands in another's: %s" % str(shared))
	# EVERY BUDGET A NODE CAN ROLL, SOME THEME OF THAT NODE COMPOSES — so no node falls to the plain fallback.
	var themes: Dictionary = _run.THEMES
	var holes: Array = []
	var asked := 0
	for z in ZONES_OWN + ZONES_OLD:
		var r := _roster_of(z)
		for kind in ["fight", "elite", "boss"]:
			var lo: int = {"fight": 3, "elite": 6, "boss": 10}[kind]
			var hi: int = {"fight": 10, "elite": 10, "boss": 12}[kind]
			var named := String(_run.ZONE_DEFS[z]["boss"]) if kind == "boss" else ""
			for budget in range(lo, hi + 1):
				asked += 1
				var n := 0
				for t in themes:
					if (themes[t]["nodes"] as Array).has(kind):
						n += int(_run._theme_count(themes[t], budget, r, named))
				if n <= 0:
					holes.append("%s %s %d" % [z, kind, budget])
	print("    CHECKED %d zone, node and budget cells: %d compose no theme" % [asked, holes.size()])
	# WHAT EACH ZONE NEVER FIELDS, PRINTED FOR THE DESIGNER's QUESTION (KF's NEEDS A RULING): a theme no budget of its node composes.
	for z in ZONES_OWN + ZONES_OLD:
		var never: Array = []
		for t in themes:
			var any := false
			for kind in themes[t]["nodes"]:
				var lo2: int = {"fight": 3, "elite": 6, "boss": 10}.get(kind, 3)
				var hi2: int = {"fight": 10, "elite": 10, "boss": 12}.get(kind, 10)
				var named2 := String(_run.ZONE_DEFS[z]["boss"]) if kind == "boss" else ""
				for b2 in range(lo2, hi2 + 1):
					if int(_run._theme_count(themes[t], b2, _roster_of(z), named2)) > 0:
						any = true
			if not any:
				never.append(String(t))
		print("    %-15s never fields: %s" % [z, ", ".join(PackedStringArray(never)) if not never.is_empty() else "—"])
	ok(asked == (ZONES_OWN.size() + ZONES_OLD.size()) * (8 + 5 + 3) and holes.is_empty(), "§2: a node falls to the plain fallback: %s" % str(holes))
	# TWENTY MAPS A ZONE, COMPOSED.
	for z in ZONES_OWN:
		var r := _roster_of(z)
		_run.new_run(SEATS, [], "standard")
		_run.zone_draw[0] = z
		_run.zone_idx = 0
		_run._enter_zone()
		var nodes := 0
		var empty: Array = []
		var outside: Array = []
		var orcs: Array = []
		var elites := 0
		var own_elites := 0
		# BATCH KG §1 — each new zone's own elite: a kind of its roster tagged `elite` that no old zone's roster holds.
		var own_elite_kinds: Array = Enemies.kinds_for_roster(r).filter(func(k): return Enemies.roles(String(k)).has("elite") and not old.has(String(k)))
		var bosses := 0
		var boss_wrong: Array = []
		var named_boss := String(_run.ZONE_DEFS[z]["boss"])
		for m in 20:
			_run._generate_map()
			for col in _run.map:
				for node in col:
					var ty := String((node as Dictionary).get("type", ""))
					if not ty in ["fight", "elite", "miniboss", "boss"]:
						continue
					nodes += 1
					var en: Array = (node as Dictionary).get("enemies", [])
					if en.is_empty():
						empty.append(ty)
					if ty == "boss":
						# S2-090 (GI's rule): a zone boss node fields its zone's boss_kind(), never another boss-tagged kind
						# of its roster — the Hollow Crown stands in both new rosters.
						bosses += 1
						var others: Array = en.filter(func(k): return String(k) != named_boss and Enemies.roles(String(k)).has("boss"))
						if not en.has(named_boss) or not others.is_empty():
							boss_wrong.append("%s %s" % [z, str(en)])
					if ty in ["elite", "miniboss"]:
						elites += 1
						if en.any(func(k): return own_elite_kinds.has(String(k))) and not en.has("chief"):
							own_elites += 1
					for e in en:
						if not Enemies.kinds_for_roster(r).has(String(e)):
							outside.append(String(e))
						if old.has(String(e)) and not MAY_TRAVEL.has(String(e)):
							orcs.append(String(e))
		print("    20 %s maps: %d fight, elite and boss nodes; %d empty; %d bodies outside roster %d; %d of the Forest's or the Scarlands'; %d of %d elite nodes field %s" % [
			z, nodes, empty.size(), outside.size(), r, orcs.size(), own_elites, elites, ", ".join(PackedStringArray(own_elite_kinds))])
		ok(nodes >= 100 and empty.is_empty(), "§2: a %s node composed no warband: %s" % [z, str(empty.slice(0, 5))])
		ok(outside.is_empty(), "§2: a %s node fields a kind outside its roster: %s" % [z, str(outside.slice(0, 5))])
		ok(orcs.is_empty(), "§2: a %s node fields an old zone's kind: %s" % [z, str(orcs.slice(0, 5))])
		# BATCH KG §1 — REPAIRED TO ITS INTENT: the arm held what KF built (the Chief on every elite node); since KG each new zone
		# fields its own, one kind, and no elite node fields the Chief.
		ok(own_elite_kinds.size() == 1 and elites > 0 and own_elites == elites, "§2: %d of %s's %d elite nodes field its own elite %s" % [own_elites, z, elites, str(own_elite_kinds)])
		print("    %d boss nodes, each fielding %s and no other boss-tagged kind: %s" % [bosses, named_boss, "yes" if boss_wrong.is_empty() else "NO"])
		ok(bosses >= 20 and boss_wrong.is_empty(), "§2: a boss node fields %s" % str(boss_wrong.slice(0, 3)) if not boss_wrong.is_empty() else "§2: a boss node fields nothing — %d boss nodes in 20 maps" % bosses)
	_run.active = false


# ── §3 — THE RECORD ──────────────────────────────────────────────────────────

func _s3_record() -> void:
	print("\n§3 — the record: CLAUDE.md holds the zone rule's block and the chip bullet")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var at := cm.find(ZONE_BLOCK)
	var end := cm.find("\n## ", at + 4) if at >= 0 else -1
	var block := cm.substr(at, end - at) if at >= 0 and end > at else ""
	ok(block.length() > 400 and block.contains("Frozen Plains") and block.contains("Drowned Barrow"),
		"§3: CLAUDE.md's zone block is gone or names neither new zone")
	ok(cm.contains(CHIP_WORDS), "§3: CLAUDE.md's chip block holds no bullet for the frame")
	print("    CHECKED the block (%d B) and the bullet" % block.length())


# ── §4 — THE PLAYER's FILES ──────────────────────────────────────────────────

func _s4_the_players_files() -> void:
	print("\n§4 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§4: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§4: %s was created" % p)
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
