# THE GATE FOR THE FROZEN PLAINS.
#
#   §0   THE RECORD: JR's five rulings answered and archived; the batch's own choices each owed as a ruling with its reversal; the
#        state's ceiling at 520 KiB in the sentence `check_fg` §4 reads, its reason beside it and the 440 it supersedes recorded (C15).
#   §1   THE ZONE: the Frozen Plains a candidate at slots 1 and 3 and never at 2, the slot count three (C01); a roster for each slot
#        it hosts (C02); every kind tagged for all three old rosters takes both new ones, and no kind tagged for fewer travels (C04);
#        each new roster fields four to six bodies, DERIVED through the composer's list (which the game's draw counts, `check_jv`)
#        for every budget a fight node rolls
#        (C03); a player's run and a sim's draw both candidates at both slots and the Scarlands alone at slot 2, and a sim's flag
#        holds the first (DRIVEN); each of the six's shares of a fight node as the state records it; and every background dict
#        names the zone and a zone it does not name falls back (C05: the battle's DRIVEN, the map's and the event screen's read).
#   §2   THE SIX KINDS: each its role, power and enemy role, its Attack its role's (C07), the zone's signature — frost resisted,
#        fire not, slower and more armoured than the kind it stands for (the rule that picks it, DERIVED); each second move the
#        least whole damage that clears JI's line with its Break in the sum, priced through `check_ji.line_blow`, and its
#        cooldown the line's band (C06); the line's reference board where it stood, so no existing band moved; what each lays an
#        existing status, and no status new (C08); the Sleetveil Matron a mender that Raises and heals — its heal chosen by the
#        warband's door, DRIVEN — and the Stillwrought a second carrier of Sap (C09); the kept table `JS-kinds.tsv` re-derived
#        row by row, and master §9's table row for each of the seven read against the data (H02).
#   §3   THE ICEWROUGHT TITAN: the Frozen Plains' boss lays `frozen` on one hero for one turn with a blow (C10); DRIVEN on a real
#        board — the freeze lands and costs the hero exactly one turn, a Block or a miss lays nothing, Ironclad and Hallowed refuse
#        it, a cleanse lifts it (C11); no ability of its tagged with a rung, its kit the same at every rung (C12).
#   §4   THE COUNT: the kept table carries the attacking fights' number on every row and says why a kind it never met was not met (C13).
#   §5   WHAT IS DELIBERATELY NOT DONE: the warband's data with JS's additions taken out reads as JR landed it, the Cleric's cut
#        stands (C14); the deck closed at twenty-five (C16).
#   §6   the two readings and the projection; the player's files, as this gate found them.
#   Every needle is the rule's own words, never the batch code beside them — but for the blocks' headings §0 reads, which are named for
#   their batches, the ceiling's record of the raise it supersedes (*raised at JJ §1*), and §4's row label (*a JS kind*), the count's own.
#   Every new kind is asked for before it is read, so HEAD's tree reds here (H01, H02) rather than throwing.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_js.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
# JI's LINE AND ITS BREAK PRICE (JO §1): the one blow and the one price, read where they stand.
const JI = preload("res://check_ji.gd")

const DECK_CLOSED_AT := 25
# ── §1's ZONE ─────────────────────────────────────────────────────────────────
const ZONE := "frozen_plains"
const ZONE_NAME := "The Frozen Plains"
const BOSS := "icewrought_titan"
# BATCH JU §1 — THE FOUR KINDS JU ADDED TO THE FOREST OF OLD, set aside where this gate sets its own seven aside: JS's rule for
# the kind each of the six stands for reads the kinds JS stood among, and §5's digest is the warband beside JS's additions.
const ADDED_SINCE := ["grave_husk", "mossback", "blight_speaker", "carrion_pack"]
# THE SLOTS IT HOSTS (1-based, as `ZONE_DEFS`' rosters key them) and the slot it never takes: the Scarlands keeps its own.
const HOSTS := [1, 3]
const NOT_HOST := 2
const SLOTS := 3
# THE OLD ROSTERS, whose every-one-of-them kinds are the universal core the new rosters take (§1's derivation).
const OLD_ROSTERS := [1, 2, 3]
# A FIGHT NODE's BODIES, AS A ROSTER MUST FIELD THEM: four to six, in at least this share of the fight draws (the old rosters
# field them in 61–70%, derived here too and printed beside).
const FOUR_TO_SIX := [4, 5, 6]
const FOUR_TO_SIX_SHARE := 0.5
# THE DRAWS A DRIVE MAKES: enough that a candidate drawn half the time is met at each slot (0.5^48 to miss one).
const DRAWS := 48
# THE BACKGROUND DICTS: each names the zone, and reads a name it lacks through a fallback.
const BACKGROUNDS := {"scripts/battle.gd": "_build_arena", "scripts/map_screen.gd": "", "scripts/event_screen.gd": ""}
# ── §2's SIX ──────────────────────────────────────────────────────────────────
# Each kind: its role tag, power, enemy role, the kind it stands for elsewhere (whose speed it is slower than and whose armour it
# exceeds), the roster it is in, its second move, what that move lays ("" a Break move, "heal" a heal), and its Malice spend.
const SIX := {
	"frostbitten_thrall": ["skirmisher", 1, "damage", "whelp", "opener", "Hobbling Bite", "slow", "malice_rally"],
	"icebound_bulwark": ["bulwark", 2, "tank", "shieldmaster", "opener", "Glacier Press", "", "malice_entrench"],
	"hailcaster": ["sniper", 1, "damage", "slinger", "opener", "Hailstorm", "dazed", "malice_rally"],
	"rimehorn": ["brute", 3, "damage", "brute", "finale", "Trampling Charge", "", "malice_rally"],
	"hoarfrost_warden": ["mender", 2, "support", "shaman", "finale", "Healing Wave", "heal", "malice_raise"],
	"stillwrought": ["hexer", 2, "support", "hexer", "finale", "Leaching Stillness", "sap", "malice_entrench"],
}
# THE KIND EACH STANDS FOR, BY ONE RULE (JS's ruling 2): the first kind in data order of its role tag, power and enemy role that the
# Forest's opener roster fields, one that does not travel (not tagged for every old roster) before one that does. SIX's fourth field
# is asserted to be the rule's pick, so the comparison is the rule's and not a hand's. Not every kind of the role: the Orc Raider beside the Thrall is slower and
# more armoured still, and the Orc Archer as armoured as the Hailcaster.
const STANDS_FOR_ROSTER := 1
# THE ROLE's ATTACK (master §9, `battle._enemy_config`'s comment): Damage 100, Tank 75, Support 50.
const ROLE_ATTACK := {"damage": 100, "tank": 75, "support": 50}
# A BREAK MOVE: its Break damage above its damage, so the plate declares it a crush.
# THE STATUSES THE SEVEN LAY, every one standing before JS (C08): Slowed, Dazed, Sap and Frozen.
const LAID := ["slow", "dazed", "sap", "frozen"]
# STATUS_INFO's ids as JR landed them: their count and their digest (sorted, joined by `|`). A status authored reds here.
const STATUS_IDS_AT_HEAD := 168
const STATUS_IDS_MD5 := "73daa5a35fc15fe44b74bf493d079976"
# THE REFERENCE BOARD THE LINE PRICES HEALS AND SPENDS ON (`check_ji` §1a, `check_jk` §2): the median composable body and the
# median basic, DERIVED with the seven taken out and with them in. JS's six straddle both, so no band of an existing kind moved.
# THE STATE's RECORD OF THE SIX SECOND MOVES' FIGURES (R01): the sentence and the moves it names, each read against the data.
const RECORD_HEAD := "### THE FROZEN PLAINS"
const RECORD_SAYS := "each the least whole damage that clears the line"
# ── §3's TITAN ────────────────────────────────────────────────────────────────
const FREEZE := "Entomb"
# THE FREEZE's LENGTH: one turn, the ordinary freeze's (JS's ruling 4) — the turn the card's *a turn lost* and master's rows state.
const FREEZE_TURNS := 1
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["icewrought_titan"]}
const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://js_profile.json"
const SCRATCH_RELICS := "user://js_relics.json"
# THE KEPT TABLE OF THE SEVEN's FIGURES, RE-DERIVED ROW BY ROW (R01), AND THE MASTER's ENEMY TABLE, READ FOR EACH OF THE SEVEN (H02).
const KINDS_TABLE := "res://docs/reports/JS-kinds.tsv"
const MASTER := "res://docs/master.html"
# ── §4's COUNT ────────────────────────────────────────────────────────────────
const COUNT_TABLE := "res://docs/reports/JS-count.tsv"
const DENOMINATOR := "the fights where the warband attacks"
# ── §5 ────────────────────────────────────────────────────────────────────────
# THE WARBAND's DATA AS JQ LANDED IT (`check_jr` §1's digest): with JS's seven taken out, rosters 4 and 5 off every kind, and JR's
# three tags put back as `check_jr` puts them, the tree's data must read it — nothing else in a kind moved (C14).
const JR_PUT_BACK := {"grave_totem": {"zones": [1.0, 3.0]}, "behemoth": {"zones": [2.0, 3.0]}, "hexer": {"roles": ["hexer"]}}
const WARBAND_AT_JQ_MD5 := "f261e6345f22f42bc41a7f81276e066b"
const CLERIC_CUT := 0.5
const DECK_MD5 := "1d1f37491e4611bb78f94577074ede99"
# ── §0 and §6 ─────────────────────────────────────────────────────────────────
const ANSWERED := "all accepted as taken"
const OWED_HEAD := "### JR's RULINGS OWED"
const STRUCK_HEAD := "### ~~JR's RULINGS OWED~~"
const NEW_OWED_HEAD := "### JS's RULINGS OWED"
const NEW_STRUCK_HEAD := "### ~~JS's RULINGS OWED~~"
const REVERSAL := "**Reversing it**"
const CEILING_KIB := 520
const CEILING_REASON := "THE CEILING's JOB WAS TO BOUND WHAT A BATCH READS, AND THE ROUTING DOES THAT NOW"
const CEILING_SUPERSEDED := "raised at JJ §1"
const CEILING_WAS := "above the 440 KiB"
const READINGS := ["`CLAUDE.md`", "`docs/state.md`"]
const PROJECTED := "\\*\\*PROJECTED FOR [A-Z]{2}\\*\\*"

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("THE GATE FOR THE FROZEN PLAINS")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_fresh_meta()
	_s0_the_record()
	_s1_the_zone()
	_s1_the_draw()
	_s2_the_six()
	_s3_the_titan_data()
	var s: Node = await _board(ZONE_NAME, false)
	var art_here := _art(s)
	await _s3_the_freeze(s)
	_s2_the_warden_heals(s)
	var s2: Node = await _board("JS nowhere", true)
	_s1_the_backdrop(art_here, _art(s2))
	await _s3_the_lost_turn(s2)
	_s4_the_count()
	_s5_not_done()
	_s6_the_readings()
	_s6_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────

# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true).strip_edges()


# A `## ` or `### ` block by its heading, to the next heading of the same depth or shallower.
func _block(text: String, head: String) -> String:
	var at := text.find("\n" + head)
	if at < 0:
		return ""
	var depth := head.split(" ")[0].length()
	var next := text.find("\n#", at + 1)
	while next >= 0:
		var hashes := 0
		while text[next + 1 + hashes] == "#":
			hashes += 1
		if hashes <= depth and text[next + 1 + hashes] == " ":
			return text.substr(at, next - at)
		next = text.find("\n#", next + 1)
	return text.substr(at)


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


func _zones(kd: Dictionary) -> Array:
	var out: Array = []
	for z in kd.get("zones", []):
		out.append(int(z))
	return out


func _basic(kd: Dictionary) -> Dictionary:
	for a in kd.get("abilities", []):
		if int((a as Dictionary).get("damage", 0)) > 0 and int((a as Dictionary).get("cost", 0)) == 0:
			return a
	return {}


func _move(kd: Dictionary, name: String) -> Dictionary:
	for a in kd.get("abilities", []):
		if String((a as Dictionary).get("display_name", "")) == name:
			return a
	return {}


func _median(xs: Array) -> float:
	var v := xs.duplicate()
	v.sort()
	var n := v.size()
	if n == 0:
		return 0.0
	return (float(v[n / 2 - 1]) + float(v[n / 2])) / 2.0 if n % 2 == 0 else float(v[n / 2])


# THE LINE's BAND FOR A MULTIPLE, off check_ji's own constants: none under the line, then each figure's bound, then the top.
func _band(m: float) -> int:
	if m < float(JI.LINE):
		return 0
	for b in JI.FIGURES:
		if m < float(b[0]):
			return int(b[1])
	return int(JI.TOP)


func _dot(s: Node) -> Dictionary:
	if s == null:
		return (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("DOT_STATUSES", {})
	return (s.get_script() as Script).get_script_constant_map().get("DOT_STATUSES", {})


# ── §0 — THE RECORD ───────────────────────────────────────────────────────────

func _s0_the_record() -> void:
	print("\n§0 — JR's five rulings answered and archived; the batch's own choices owed with their reversals; the ceiling at 520 KiB")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n" + OWED_HEAD), "§0: %s is still in the open queue — it was answered" % OWED_HEAD)
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), STRUCK_HEAD))
	var items := 0
	for n in range(1, 6):
		if struck.contains(" %d. **" % n):
			items += 1
	print("    the archive's struck block: %d of its five rulings, answered: %s" % [items, str(struck.contains(ANSWERED))])
	ok(struck.contains(ANSWERED) and items == 5, "§0: the archive does not hold JR's five rulings struck and answered (%d items)" % items)
	var owed := _block(state, NEW_OWED_HEAD)
	if owed == "":
		owed = _block(_doc("res://DoD-archive/state-archive.md"), NEW_STRUCK_HEAD)
		print("    JS's rulings answered and archived: read struck in the archive")
	var n_owed := 0
	var bare: Array = []
	for raw in owed.split("\n"):
		var line := String(raw)
		if line.length() > 3 and line[0].is_valid_int() and line.substr(1, 2) == ". ":
			n_owed += 1
			if not line.contains(REVERSAL):
				bare.append(line.substr(0, 60))
	print("    the rulings owed: %d items" % n_owed)
	ok(n_owed >= 3 and bare.is_empty(), "§0: the batch's own choices are not each owed with a reversal (%d items; without one: %s)" % [n_owed, bare])
	# C15 — THE CEILING, IN THE SENTENCE `check_fg` §4 PARSES, WITH ITS REASON AND THE RAISE IT SUPERSEDES.
	var st := _flat(state)
	var rx := RegEx.new()
	rx.compile("THIS FILE'S CEILING IS ([0-9]+) KiB")
	var bars: Array = []
	for m in rx.search_all(st):
		if not bars.has(int(m.get_string(1))):
			bars.append(int(m.get_string(1)))
	print("    the state's ceiling reads %s KiB" % str(bars))
	ok(bars == [CEILING_KIB], "§0: the state's ceiling reads %s KiB, not %d" % [str(bars), CEILING_KIB])
	var at := st.find("THIS FILE'S CEILING IS")
	var para := st.substr(at, 3500) if at >= 0 else ""
	ok(para.contains(CEILING_REASON), "§0: the ceiling was raised without its reason beside it — the routing bounds what a batch reads")
	ok(para.contains(CEILING_SUPERSEDED) and para.contains(CEILING_WAS), "§0: the raise the new ceiling supersedes, or the figure it set, is gone from beside it — a supersession is recorded, never deleted")


# ── §1 — THE ZONE ─────────────────────────────────────────────────────────────

func _s1_the_zone() -> void:
	print("\n§1 — the Frozen Plains: its slots, its rosters, the kinds that travel and the bodies each roster fields")
	var defs: Dictionary = _run.ZONE_DEFS
	var pools: Array = _run.SLOT_POOLS
	ok(int(_run.SLOT_COUNT) == SLOTS and pools.size() == SLOTS, "§1: the run is %d slots over %d pools — not three, and a zone takes no fourth" % [int(_run.SLOT_COUNT), pools.size()])
	ok(defs.has(ZONE), "§1: ZONE_DEFS holds no %s" % ZONE)
	for slot in HOSTS:
		ok(pools.size() >= slot and (pools[slot - 1] as Array).has(ZONE), "§1: the Frozen Plains is no candidate at slot %d" % slot)
	ok(pools.size() >= NOT_HOST and not (pools[NOT_HOST - 1] as Array).has(ZONE) and pools[NOT_HOST - 1] == ["scarlands"],
		"§1: slot %d's pool is %s — the Scarlands keeps its single candidacy, and the Frozen Plains is no candidate there" % [NOT_HOST, str(pools[NOT_HOST - 1]) if pools.size() >= NOT_HOST else "[]"])
	if not defs.has(ZONE):
		return
	var zd: Dictionary = defs[ZONE]
	var rosters: Dictionary = zd.get("rosters", {})
	print("    %s: '%s', boss %s, rosters %s; the pools %s" % [ZONE, String(zd.get("name", "")), String(zd.get("boss", "")), str(rosters), str(pools)])
	ok(String(zd.get("name", "")) == ZONE_NAME and String(zd.get("boss", "")) == BOSS, "§1: the zone def names '%s' and boss %s" % [String(zd.get("name", "")), String(zd.get("boss", ""))])
	# C02 — A ROSTER FOR EACH SLOT IT HOSTS, EACH ITS OWN, NEITHER AN OLD ONE.
	var ids: Array = []
	for slot in HOSTS:
		ok(rosters.has(slot), "§1: the zone hosts slot %d and carries no roster for it" % slot)
		if rosters.has(slot):
			ids.append(int(rosters[slot]))
	ok(ids.size() == HOSTS.size() and ids[0] != ids[ids.size() - 1], "§1: the zone hosts two slots and carries %s — one roster for both" % str(ids))
	for r in ids:
		ok(not OLD_ROSTERS.has(r), "§1: the zone's roster %d is an old zone's" % r)
	# C04 — THE KINDS THAT TRAVEL, DERIVED: every kind tagged for all three old rosters takes both new ones; nothing else of the old does.
	var data: Dictionary = Enemies._load()
	var core: Array = []
	var travelled: Array = []
	var stayed: Array = []
	for k in data:
		var z := _zones(data[k])
		var everywhere := true
		for r in OLD_ROSTERS:
			if not z.has(r):
				everywhere = false
		var is_new: bool = SIX.has(k) or String(k) == BOSS
		if everywhere:
			core.append(k)
			for r2 in ids:
				if not z.has(r2):
					stayed.append("%s (no roster %d)" % [k, r2])
		elif not is_new:
			for r3 in ids:
				if z.has(r3):
					travelled.append("%s (tagged %s)" % [k, str(z)])
	print("    the universal core (tagged for rosters 1, 2 and 3): %d kinds — %s" % [core.size(), ", ".join(core)])
	ok(core.size() >= 10 and stayed.is_empty(), "§1: a kind of the universal core did not take both new rosters: %s" % [stayed])
	ok(travelled.is_empty(), "§1: a kind tagged for fewer than all three old rosters travelled into a new one — a zone's own kind: %s" % [travelled])
	# THE OPENER TAKES §2's THREE OPENER KINDS, THE FINALE ALL SIX.
	var wrong: Array = []
	for k2 in SIX:
		if not data.has(k2):
			wrong.append("%s is not in the data" % k2)
			continue
		var z2 := _zones(data[k2])
		var want: Array = ids.duplicate() if String(SIX[k2][4]) == "opener" else [ids[ids.size() - 1]]
		if z2 != want:
			wrong.append("%s carries rosters %s, not %s" % [k2, str(z2), str(want)])
	ok(wrong.is_empty(), "§1: a kind is not in the roster the brief puts it in: %s" % [wrong])
	# C03 — EACH NEW ROSTER FIELDS FOUR TO SIX BODIES, DERIVED THROUGH THE COMPOSER's OWN DOOR.
	var fours := {}
	for r4 in OLD_ROSTERS + ids:
		var sz := _sizes(int(r4))
		var four := 0.0
		for n in FOUR_TO_SIX:
			four += float(sz.get(n, 0.0))
		fours[int(r4)] = four
		var line := ", ".join(sz.keys().map(func(x): return "%d: %.3f" % [int(x), float(sz[x])]))
		print("    roster %d (%d kinds): a fight node fields %s — four to six in %.3f" % [int(r4), Enemies.kinds_for_roster(int(r4)).size(), line, four])
		if ids.has(r4):
			var each := FOUR_TO_SIX.filter(func(x): return float(sz.get(x, 0.0)) > 0.0)
			ok(each.size() == FOUR_TO_SIX.size() and four >= FOUR_TO_SIX_SHARE,
				"§1: roster %d cannot field four to six bodies: it fields %s of them, and four to six in %.3f of fight draws" % [int(r4), str(each), four])
	# R01 — THE SHARES THE STATE RECORDS, DERIVED THROUGH THE SAME DOOR: every roster's four-to-six share, each of the six's share of a
	# fight node on each new roster it is in, and the finale's Sap carriers together and the Orc Hexer alone. Each figure, to one
	# place, stands in THE FROZEN PLAINS' block, so a re-tune that moves one leaves a text that reds here.
	var rec := _flat(_block(_doc("res://docs/state.md"), RECORD_HEAD))
	var said: Array = []
	for r6 in fours:
		said.append("%.1f%%" % (100.0 * float(fours[r6])))
	var shares: Array = []
	for k5 in SIX:
		for r7 in ids:
			if data.has(k5) and _zones(data[k5]).has(r7):
				var sh := float((_cache.get("kinds_%d" % r7, {}) as Dictionary).get(k5, 0.0))
				shares.append("%s %d %.1f%%" % [k5, r7, 100.0 * sh])
				said.append("%.1f%%" % (100.0 * sh))
	var fin: int = int(ids[ids.size() - 1]) if not ids.is_empty() else -1
	var sap_all := float(_cache.get("sap_%d" % fin, 0.0))
	var sap_hexer := float((_cache.get("kinds_%d" % fin, {}) as Dictionary).get("hexer", 0.0))
	said.append("%.1f%%" % (100.0 * sap_all))
	said.append("%.1f%%" % (100.0 * sap_hexer))
	print("    a fight node fields: %s; in roster %d a Sap carrier %.1f%%, the Orc Hexer %.1f%%" % [", ".join(shares), fin, 100.0 * sap_all, 100.0 * sap_hexer])
	var unstated := said.filter(func(x): return not rec.contains(String(x)))
	ok(not rec.is_empty() and unstated.is_empty(), "§1: the state's record of the Frozen Plains does not state a share as the composer fields it: %s" % [unstated])


func _fight_themes() -> Array:
	var out: Array = []
	for t in (_run.THEMES as Dictionary):
		if (_run.THEMES[t]["nodes"] as Array).has("fight"):
			out.append(t)
	return out


# THE BUDGET BAND A TIER ROLLS (`Run.battle_budget`): read off the door, every tier drawn until both ends of its band are met.
func _bands() -> Dictionary:
	if _cache.has("bands"):
		return _cache["bands"]
	var out := {}
	seed(20261109)
	for tier in range(1, int(_run.SLOTS_PER_ZONE)):
		var lo := 1 << 20
		var hi := -1
		for i in 96:
			var b: int = _run.battle_budget(tier)
			lo = mini(lo, b)
			hi = maxi(hi, b)
		out[tier] = [lo, hi]
	_cache["bands"] = out
	return out


# HOW MANY BODIES A FIGHT NODE FIELDS ON A ROSTER, AS `Run.compose` DRAWS THEM: every budget a tier rolls equally likely, a theme
# uniform among the fight themes that can spend it, a combo uniform among the theme's exact-budget combos. {bodies: share}; and
# beside it, cached, each kind's share of the fight nodes that field it and the share that fields a Sap carrier.
func _sizes(roster: int) -> Dictionary:
	var themes := _fight_themes()
	var bands := _bands()
	var out := {}
	var kinds := {}
	var sap := 0.0
	var data: Dictionary = Enemies._load()
	var carriers := {}
	for k0 in data:
		for a0 in (data[k0] as Dictionary).get("abilities", []):
			if String(((a0 as Dictionary).get("applies_status", {}) as Dictionary).get("id", "")) == "sap":
				carriers[k0] = true
	var n := 0
	for tier in bands:
		for b in range(int(bands[tier][0]), int(bands[tier][1]) + 1):
			n += 1
			var feasible: Array = []
			for t in themes:
				var combos: Array = _run._theme_combos(_run.THEMES[t], b, roster)
				if not combos.is_empty():
					feasible.append(combos)
			for combos in feasible:
				for c in combos:
					var w := 1.0 / float((combos as Array).size()) / float(feasible.size())
					var k := (c as Array).size()
					out[k] = float(out.get(k, 0.0)) + w
					var met := {}
					for kk in c:
						met[kk] = true
					for kk2 in met:
						kinds[kk2] = float(kinds.get(kk2, 0.0)) + w
					if met.keys().any(func(x): return carriers.has(x)):
						sap += w
	for kk3 in kinds:
		kinds[kk3] = float(kinds[kk3]) / float(maxi(n, 1))
	_cache["kinds_%d" % roster] = kinds
	_cache["sap_%d" % roster] = sap / float(maxi(n, 1))
	var keys := out.keys()
	keys.sort()
	var sorted := {}
	for k2 in keys:
		sorted[k2] = float(out[k2]) / float(maxi(n, 1))
	return sorted


# THE DRAW, DRIVEN: a player's run and a sim's draw within each pool of two, a pool of one takes its zone, and a sim's flag holds
# each pool's first author.
func _s1_the_draw() -> void:
	print("\n§1 — the draw: a player's run and a sim's meet both candidates at both slots; a sim's flag holds the first")
	var pools: Array = _run.SLOT_POOLS
	var was: bool = _run.sim_run
	var seen := {}
	OS.set_environment("DOD_ZONE_ROTATION", "")
	for who in ["player", "sim"]:
		_run.sim_run = who == "sim"
		seed(7070 if who == "player" else 7071)
		for i in DRAWS:
			_run.draw_zones()
			for slot in mini(pools.size(), (_run.zone_draw as Array).size()):
				var key := "%s/%d/%s" % [who, slot + 1, String(_run.zone_draw[slot])]
				seen[key] = int(seen.get(key, 0)) + 1
	var missed: Array = []
	for who2 in ["player", "sim"]:
		for slot2 in mini(pools.size(), int(_run.SLOT_COUNT)):
			for z in pools[slot2]:
				if int(seen.get("%s/%d/%s" % [who2, slot2 + 1, String(z)], 0)) == 0:
					missed.append("%s's run never drew %s at slot %d" % [who2, String(z), slot2 + 1])
	print("    over %d draws each: %s" % [DRAWS, str(seen)])
	ok(missed.is_empty(), "§1: a zone in a slot's pool is one a run never draws: %s" % [missed])
	# A SIM HELD BY ITS FLAG TAKES EACH POOL's FIRST; A PLAYER's RUN DOES NOT READ THE FLAG.
	OS.set_environment("DOD_ZONE_ROTATION", "0")
	_run.sim_run = true
	var held := true
	for i2 in 8:
		_run.draw_zones()
		for slot3 in mini(pools.size(), (_run.zone_draw as Array).size()):
			if String(_run.zone_draw[slot3]) != String((pools[slot3] as Array)[0]):
				held = false
	_run.sim_run = false
	var player_moved := false
	seed(7072)
	for i3 in DRAWS:
		_run.draw_zones()
		for slot4 in mini(pools.size(), (_run.zone_draw as Array).size()):
			if String(_run.zone_draw[slot4]) != String((pools[slot4] as Array)[0]):
				player_moved = true
	OS.set_environment("DOD_ZONE_ROTATION", "")
	_run.sim_run = was
	ok(held, "§1: a sim with DOD_ZONE_ROTATION=0 does not hold each pool's first author")
	ok(player_moved, "§1: a player's run read DOD_ZONE_ROTATION=0 and drew each pool's first — the flag is the sim's")
	# THE ROSTER A SLOT FIELDS FOLLOWS THE ZONE: the Frozen Plains' opener roster at slot 1, its finale at slot 3.
	if (_run.ZONE_DEFS as Dictionary).has(ZONE):
		_run.zone_draw = [ZONE, "scarlands", ZONE]
		var got: Array = []
		for zi in [0, 2]:
			_run.zone_idx = zi
			got.append(int(_run.active_roster()))
		_run.zone_idx = 0
		var rz: Dictionary = _run.ZONE_DEFS[ZONE].get("rosters", {})
		var want: Array = [int(rz.get(HOSTS[0], -1)), int(rz.get(HOSTS[1], -1))]
		print("    the Frozen Plains at slot 1 fields roster %d and at slot 3 roster %d; its boss %s" % [int(got[0]), int(got[1]), String(_run.boss_kind())])
		ok(got == want and String(_run.boss_kind()) == BOSS, "§1: the Frozen Plains fields rosters %s, not %s, or its boss is %s" % [str(got), str(want), String(_run.boss_kind())])
		_run.draw_zones()


# THE ARENA's ART: the background a battle scene drew, by its texture's path ("" when it drew none).
func _art(s: Node) -> String:
	if s == null:
		return ""
	for n in s.get_children():
		if n is Sprite2D and (n as Sprite2D).texture != null and (n as Sprite2D).texture.resource_path.contains("assets/backgrounds/"):
			return (n as Sprite2D).texture.resource_path
	return ""


# C05 — EVERY BACKGROUND DICT NAMES THE ZONE AND FALLS BACK, DRIVEN: a battle entered under the zone's name and one under a name no
# dict holds, each drawing an art.
func _s1_the_backdrop(here: String, nowhere: String) -> void:
	print("\n§1 — the backdrop: every dict names the Frozen Plains, and a zone it does not name falls back to an art")
	for path in BACKGROUNDS:
		var src := Gate.strip_comments(_doc("res://" + String(path)))
		ok(src.contains("\"%s\": \"res://assets/backgrounds/" % ZONE_NAME), "§1: %s's background dict does not name %s" % [path, ZONE_NAME])
		ok(src.contains(".get(zone, ") or src.contains(".get(Run.zone_name,"), "§1: %s reads its background dict with no fallback — a zone it lacks would crash it" % path)
	print("    a battle under '%s' drew %s; under a zone no dict names, %s" % [ZONE_NAME, here if here != "" else "nothing", nowhere if nowhere != "" else "nothing"])
	ok(here != "", "§1: a battle in %s drew no background art" % ZONE_NAME)
	ok(nowhere != "", "§1: a battle in a zone no dict names drew no background art — the dict did not fall back")


# ── §2 — THE SIX KINDS ────────────────────────────────────────────────────────

func _s2_the_six() -> void:
	print("\n§2 — the six kinds: role, Attack, the zone's signature, each second move at JI's line, the statuses they lay")
	var data: Dictionary = Enemies._load()
	var price := float(JI.break_figures().get("price", -1.0))
	ok(price > 0.0, "§2: the Break price could not be read off check_ji")
	var dot := _dot(null)
	var wrong: Array = []
	var line_wrong: Array = []
	var laid_wrong: Array = []
	var top_armor := ""
	var top := -1.0
	for k in data:
		if float((data[k] as Dictionary).get("armor", 0.0)) > top:
			top = float(data[k]["armor"])
			top_armor = k
	for k in SIX:
		if not data.has(k):
			wrong.append("%s is not in the data" % k)
			continue
		var kd: Dictionary = data[k]
		var spec: Array = SIX[k]
		if not (kd.get("roles", []) as Array) == [spec[0]] or int(kd.get("power", 0)) != int(spec[1]) or String(kd.get("enemy_role", "")) != String(spec[2]):
			wrong.append("%s is %s, power %d, %s — not %s, %d, %s" % [k, str(kd.get("roles", [])), int(kd.get("power", 0)), String(kd.get("enemy_role", "")), spec[0], int(spec[1]), spec[2]])
		# C07 — ITS ATTACK IS ITS ROLE's.
		if int(kd.get("attack", 0)) != int(ROLE_ATTACK.get(String(kd.get("enemy_role", "")), -1)):
			wrong.append("%s's Attack is %d, not its role's %d (C07)" % [k, int(kd.get("attack", 0)), int(ROLE_ATTACK.get(String(kd.get("enemy_role", "")), -1))])
		# THE SIGNATURE: frost resisted, fire not, slower and more armoured than the kind it stands for.
		var res: Dictionary = kd.get("resists", {})
		var eq: Dictionary = data.get(String(spec[3]), {})
		if not (float(res.get("frost", 0.0)) > 0.0 and float(res.get("fire", 0.0)) < 0.0):
			wrong.append("%s does not resist frost and fall to fire: %s" % [k, str(res)])
		if eq.is_empty() or not (float(kd.get("speed", 999.0)) < float(eq.get("speed", 0.0)) and float(kd.get("armor", 0.0)) > float(eq.get("armor", 1.0))):
			wrong.append("%s is not slower and more armoured than the %s it stands for" % [k, String(spec[3])])
		var picked := _stands_for(data, kd)
		if picked != String(spec[3]):
			wrong.append("%s stands for the %s by the rule, not the %s" % [k, picked, String(spec[3])])
		# C06 — THE SECOND MOVE: the least whole damage that clears the line, its cooldown the line's band.
		var basic := _basic(kd)
		var second := _move(kd, String(spec[5]))
		if basic.is_empty() or second.is_empty():
			line_wrong.append("%s holds no basic or no %s" % [k, spec[5]])
			continue
		var atk := float(kd.get("attack", 0))
		var bp: float = JI.line_blow(basic, dot, atk, price)
		var m := -1.0
		var least := true
		if String(spec[6]) == "heal":
			var bodies: Array = []
			for k2 in data:
				if not bool((data[k2] as Dictionary).get("is_boss", false)):
					bodies.append(float(data[k2]["max_hp"]))
			m = float(JI.HEALS.get(String(second.get("special", "")), 0.0)) * _median(bodies) / bp
		else:
			m = JI.line_blow(second, dot, atk, price) / bp
			var under: Dictionary = second.duplicate(true)
			under["damage"] = int(second.get("damage", 0)) - 1
			least = JI.line_blow(under, dot, atk, price) / bp < float(JI.LINE)
		var band := _band(m)
		print("    %-18s %-18s %5.3f of its basic (%.2f), band %d, the data %d%s" % [k, spec[5], m, bp, band, int(second.get("cooldown", 0)), "" if least else " — NOT the least whole damage"])
		if m < float(JI.LINE) or not least:
			line_wrong.append("%s's %s prices %.3f of its basic — %s" % [k, spec[5], m, "under the line" if m < float(JI.LINE) else "a point less still clears it"])
		if band != int(second.get("cooldown", 0)):
			line_wrong.append("%s's %s cools %d, the line's band is %d" % [k, spec[5], int(second.get("cooldown", 0)), band])
		# WHAT IT LAYS: an existing status (C08), or nothing on a Break move, or a heal (C09).
		var lays := String((second.get("applies_status", {}) as Dictionary).get("id", ""))
		if String(spec[6]) == "heal":
			if String(second.get("special", "")) != "healing_wave":
				laid_wrong.append("%s's %s is no heal" % [k, spec[5]])
		elif String(spec[6]) == "":
			if lays != "" or int(second.get("pressure", 0)) <= int(second.get("damage", 0)):
				laid_wrong.append("%s's %s is not a Break move: it lays '%s', Break %d against damage %d" % [k, spec[5], lays, int(second.get("pressure", 0)), int(second.get("damage", 0))])
		elif lays != String(spec[6]):
			laid_wrong.append("%s's %s lays '%s', not %s" % [k, spec[5], lays, spec[6]])
		if String(spec[6]) == "dazed" and not bool(second.get("aoe", false)):
			laid_wrong.append("%s's %s lays Dazed on one hero, not over an area" % [k, spec[5]])
		# ITS SPEND.
		var spend := false
		for a in kd.get("abilities", []):
			if String((a as Dictionary).get("special", "")) == String(spec[7]) and int((a as Dictionary).get("cooldown", 0)) > 0:
				spend = true
		if not spend:
			laid_wrong.append("%s holds no cooling %s" % [k, spec[7]])
	print("    the highest armour in the game: %s (%.2f)" % [top_armor, top])
	if data.has("icebound_bulwark") and data.has("rimehorn"):
		if top_armor != "icebound_bulwark":
			wrong.append("the Icebound Bulwark's armour is not the highest in the game (%s's %.2f is)" % [top_armor, top])
		var most := ""
		var hp := -1
		for k3 in SIX:
			if data.has(k3) and int(data[k3]["max_hp"]) > hp:
				hp = int(data[k3]["max_hp"])
				most = k3
		if most != "rimehorn":
			wrong.append("the Rimehorn does not carry the most health of the six (%s does)" % most)
	ok(wrong.is_empty(), "§2: a kind is not the shape the brief gives it: %s" % [wrong])
	ok(line_wrong.is_empty(), "§2: a second move is not at JI's line, or does not cool at its band (C06): %s" % [line_wrong])
	ok(laid_wrong.is_empty(), "§2: a kind does not lay, heal or spend what the brief gives it: %s" % [laid_wrong])
	# C09 — THE WARDEN IS A MENDER THAT HEALS AND RAISES IN THE FINALE; THE STILLWROUGHT CARRIES SAP THERE.
	var sap_by: Array = []
	for k4 in data:
		for a2 in (data[k4] as Dictionary).get("abilities", []):
			if String(((a2 as Dictionary).get("applies_status", {}) as Dictionary).get("id", "")) == "sap" and not sap_by.has(k4):
				sap_by.append(k4)
	sap_by.sort()
	print("    Sap is laid by %s" % str(sap_by))
	ok(sap_by.has("stillwrought") and sap_by.has("hexer"), "§2: Sap is laid by %s — the Stillwrought is its second carrier, beside the Orc Hexer" % str(sap_by))
	ok(data.has("hoarfrost_warden") and (data["hoarfrost_warden"]["roles"] as Array).has("mender") and not _move(data.get("hoarfrost_warden", {}), "Raise").is_empty(),
		"§2: the Sleetveil Matron is not a mender that Raises")
	# C08 — NO STATUS AUTHORED: what the seven lay stood before JS, and STATUS_INFO holds the ids it held.
	var bad: Array = []
	for k5 in SIX.keys() + [BOSS]:
		for a3 in (data.get(k5, {}) as Dictionary).get("abilities", []):
			var id := String(((a3 as Dictionary).get("applies_status", {}) as Dictionary).get("id", ""))
			if id != "" and not LAID.has(id):
				bad.append("%s lays %s" % [k5, id])
	var info: Dictionary = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("STATUS_INFO", {})
	var ids: Array = info.keys()
	ids.sort()
	var dig := ("|".join(ids)).md5_text()
	print("    STATUS_INFO holds %d ids (%s); JR landed %d" % [ids.size(), dig, STATUS_IDS_AT_HEAD])
	ok(bad.is_empty(), "§2: a JS kind lays a status that is not one of %s: %s" % [str(LAID), bad])
	ok(ids.size() == STATUS_IDS_AT_HEAD and dig == STATUS_IDS_MD5, "§2: STATUS_INFO holds %d ids, not the %d it held — a status was authored or retired" % [ids.size(), STATUS_IDS_AT_HEAD])
	# THE REFERENCE BOARD STANDS: the median composable body and the median basic where JR left them.
	var bodies2: Array = []
	var basics: Array = []
	var bodies_before: Array = []
	var basics_before: Array = []
	for k6 in data:
		if not bool((data[k6] as Dictionary).get("is_boss", false)):
			var is_js: bool = SIX.has(k6) or String(k6) == BOSS
			bodies2.append(float(data[k6]["max_hp"]))
			if not is_js:
				bodies_before.append(float(data[k6]["max_hp"]))
			var b6 := _basic(data[k6])
			if not b6.is_empty():
				var w6: float = JI.line_blow(b6, dot, float(data[k6]["attack"]), price)
				basics.append(w6)
				if not is_js:
					basics_before.append(w6)
	var body := _median(bodies2)
	var med := _median(basics)
	var body_before := _median(bodies_before)
	var med_before := _median(basics_before)
	print("    the reference board: the median composable body %.1f (%.1f without the seven), the median basic %.3f (%.3f without)" % [body, body_before, med, med_before])
	ok(absf(body - body_before) < 0.001 and absf(med - med_before) < 0.001,
		"§2: the seven moved the line's reference board — the median body %.1f against %.1f without them, the median basic %.3f against %.3f — so an existing kind's heal or spend is priced anew" % [body, body_before, med, med_before])
	# R01 — THE STATE's RECORD OF THE SIX SECOND MOVES' DAMAGE FOLLOWS THE DATA.
	var rec := _flat(_block(_doc("res://docs/state.md"), RECORD_HEAD))
	ok(rec.contains(RECORD_SAYS), "§2: the state holds no record of the second moves' figures (%s)" % RECORD_HEAD)
	var stale: Array = []
	for k7 in SIX.keys() + [BOSS]:
		if not data.has(k7):
			continue
		var nm := String(SIX[k7][5]) if SIX.has(k7) else FREEZE
		var mv := _move(data[k7], nm)
		if mv.is_empty() or int(mv.get("damage", 0)) <= 0:
			continue
		if not rec.contains("%s %d" % [nm, int(mv["damage"])]):
			stale.append("%s %d" % [nm, int(mv["damage"])])
	ok(stale.is_empty(), "§2: the state's record does not state the second moves as the data holds them: %s" % [stale])
	_s2_the_kept_table(data, dot, price)
	_s2_the_master_rows(data)


# THE KIND A NEW KIND STANDS FOR (JS's ruling 2): the first in data order of its role tag, power and enemy role that the Forest's opener
# roster fields, one that does not travel (not tagged for every old roster) before one that does. "" when none.
func _stands_for(data: Dictionary, kd: Dictionary) -> String:
	var role := String((kd.get("roles", [""]) as Array)[0]) if not (kd.get("roles", []) as Array).is_empty() else ""
	var own := ""
	var travels := ""
	for k in data:
		if SIX.has(k) or String(k) == BOSS or ADDED_SINCE.has(String(k)):
			continue
		var c: Dictionary = data[k]
		if bool(c.get("is_boss", false)) or not (c.get("roles", []) as Array).has(role) or int(c.get("power", 0)) != int(kd.get("power", -1)) \
				or String(c.get("enemy_role", "")) != String(kd.get("enemy_role", "")) or not _zones(c).has(STANDS_FOR_ROSTER):
			continue
		var everywhere := OLD_ROSTERS.all(func(r): return _zones(c).has(r))
		if not everywhere and own == "":
			own = k
		elif everywhere and travels == "":
			travels = k
	return own if own != "" else travels


# R01 — THE KEPT TABLE FOLLOWS THE DATA: every row of `JS-kinds.tsv` re-derived through `check_ji.line_blow` — the health, armour and
# speed, the basic and second move's damage and Break, each's worth, the multiple, a point less, the band and the cooldown — and every
# Malice spend the kind holds named with its cooldown, its multiple read off the worth the table carries (`check_jk` §2's, which
# re-derives it) and its band the cooldown the data holds.
func _s2_the_kept_table(data: Dictionary, dot: Dictionary, price: float) -> void:
	var lines := _doc(KINDS_TABLE).split("\n", false)
	ok(lines.size() > SIX.size() + 1, "§2: the kept table %s is not in the tree" % KINDS_TABLE)
	if lines.size() <= SIX.size() + 1:
		return
	var head := String(lines[0]).split("\t")
	var col := {}
	for i in head.size():
		col[String(head[i])] = i
	var off: Array = []
	var rows := 0
	for raw in lines.slice(1):
		var c := String(raw).split("\t")
		var k := String(c[0])
		if not (SIX.has(k) or k == BOSS) or not data.has(k) or c.size() < head.size():
			continue
		rows += 1
		var kd: Dictionary = data[k]
		var atk := float(kd.get("attack", 0))
		var basic := _basic(kd)
		var nm := String(SIX[k][5]) if SIX.has(k) else FREEZE
		var second := _move(kd, nm)
		var bw: float = JI.line_blow(basic, dot, atk, price)
		var sw := 0.0
		var less := "-"
		if String(second.get("special", "")) in JI.HEALS:
			var bodies: Array = []
			for k2 in data:
				if not bool((data[k2] as Dictionary).get("is_boss", false)):
					bodies.append(float(data[k2]["max_hp"]))
			sw = float(JI.HEALS[String(second["special"])]) * _median(bodies)
		else:
			sw = JI.line_blow(second, dot, atk, price)
			var under: Dictionary = second.duplicate(true)
			under["damage"] = int(second.get("damage", 0)) - 1
			less = "%.4f" % (JI.line_blow(under, dot, atk, price) / bw)
		var want := {"health": float(kd.get("max_hp", 0)), "armor": float(kd.get("armor", 0)), "speed": float(kd.get("speed", 0)),
			"basic damage": float(basic.get("damage", 0)), "basic Break": float(basic.get("pressure", 0)), "basic worth": bw,
			"second damage": float(second.get("damage", 0)), "second Break": float(second.get("pressure", 0)), "second worth": sw,
			"multiple": sw / bw, "band": float(_band(sw / bw)), "cooldown": float(second.get("cooldown", 0))}
		for h in want:
			if not col.has(h) or absf(float(c[int(col[h])]) - float(want[h])) > 0.00051:
				off.append("%s %s %s, the data %.4f" % [k, h, String(c[int(col.get(h, 0))]) if col.has(h) else "(no column)", float(want[h])])
		if col.has("a point less") and String(c[int(col["a point less"])]) != less and absf(float(c[int(col["a point less"])]) - float(less)) > 0.00051:
			off.append("%s a point less %s, the data %s" % [k, String(c[int(col["a point less"])]), less])
		# THE SPENDS: every Malice spend the kind holds, in its order, with its cooldown, multiple and band.
		var spends := (kd.get("abilities", []) as Array).filter(func(a): return String((a as Dictionary).get("special", "")).begins_with("malice_"))
		var names := String(c[int(col.get("spend", 0))]).split("; ")
		var worths := String(c[int(col.get("spend worth", 0))]).split("; ")
		var mults := String(c[int(col.get("spend multiple", 0))]).split("; ")
		var bands := String(c[int(col.get("spend band", 0))]).split("; ")
		var cools := String(c[int(col.get("spend cooldown", 0))]).split("; ")
		if names.size() != spends.size() or worths.size() != spends.size() or mults.size() != spends.size() or bands.size() != spends.size() or cools.size() != spends.size():
			off.append("%s holds %d spends and the table names %s" % [k, spends.size(), str(names)])
			continue
		for i2 in spends.size():
			var sp: Dictionary = spends[i2]
			var m2 := float(worths[i2]) / bw
			if String(names[i2]) != String(sp.get("display_name", "")) or int(cools[i2]) != int(sp.get("cooldown", 0)) \
					or absf(float(mults[i2]) - m2) > 0.00051 or int(bands[i2]) != _band(m2) or _band(m2) != int(sp.get("cooldown", 0)):
				off.append("%s's %s: the table %s, cools %s, %s, band %s; the data cools %d, its multiple %.4f, band %d" % [k, String(sp.get("display_name", "")), String(names[i2]), String(cools[i2]), String(mults[i2]), String(bands[i2]), int(sp.get("cooldown", 0)), m2, _band(m2)])
	print("    the kept table: %d of %d rows re-derived; %d off" % [rows, SIX.size() + 1, off.size()])
	ok(rows == SIX.size() + 1 and off.is_empty(), "§2: the kept table %s does not follow the data (%d rows read): %s" % [KINDS_TABLE, rows, off])


# H02 — THE MASTER's ENEMY TABLE (§9) CARRIES A ROW FOR EACH OF THE SEVEN, OPENING WITH ITS NAME, AND ITS POWER, ROLES, ROSTERS AND
# HEALTH CELLS READ AS THE DATA HOLDS THEM.
func _s2_the_master_rows(data: Dictionary) -> void:
	var html := _doc(MASTER)
	var off: Array = []
	for k in SIX.keys() + [BOSS]:
		if not data.has(k):
			off.append("%s is not in the data" % k)
			continue
		var kd: Dictionary = data[k]
		var at := html.find("<tr><td>" + String(kd.get("unit_name", "")))
		if at < 0:
			off.append("no row opens with %s" % String(kd.get("unit_name", "")))
			continue
		var row := html.substr(at, html.find("</tr>", at) - at).replace("\n", " ")
		var cells := row.trim_prefix("<tr><td>").split("</td><td>")
		var zs: Array = _zones(kd).map(func(z): return str(int(z)))
		var want := [str(int(kd.get("power", 0))), "·".join(kd.get("roles", [])), "·".join(zs), str(int(kd.get("max_hp", 0)))]
		var got: Array = Array(cells.slice(1, 5)) if cells.size() >= 5 else []
		if got != want:
			off.append("%s's row reads %s, the data %s" % [String(kd.get("unit_name", "")), str(got), str(want)])
	print("    master §9's table: %d of %d rows as the data holds them" % [SIX.size() + 1 - off.size(), SIX.size() + 1])
	ok(off.is_empty(), "§2: master.html's enemy table does not carry the seven as the data holds them: %s" % [off])


# ── §3 — THE ICEWROUGHT TITAN ─────────────────────────────────────────────────

func _s3_the_titan_data() -> void:
	print("\n§3 — the Icewrought Titan: the zone's boss, a blow that freezes one hero, no rung tag")
	var data: Dictionary = Enemies._load()
	ok(data.has(BOSS), "§3: the data holds no %s" % BOSS)
	if not data.has(BOSS):
		return
	var kd: Dictionary = data[BOSS]
	ok(bool(kd.get("is_boss", false)) and (kd.get("roles", []) as Array) == ["boss"], "§3: the Titan is not a boss: %s" % str(kd.get("roles", [])))
	# C10 — A BLOW THAT LAYS `frozen` ON ONE HERO.
	var fz := _move(kd, FREEZE)
	var st: Dictionary = fz.get("applies_status", {})
	print("    %s: damage %d, Break %d, lays %s, %s, cools %d" % [FREEZE, int(fz.get("damage", 0)), int(fz.get("pressure", 0)), str(st), "every hero" if bool(fz.get("aoe", false)) else "one hero", int(fz.get("cooldown", 0))])
	ok(String(st.get("id", "")) == "frozen" and int(st.get("turns", 0)) == FREEZE_TURNS, "§3: the Titan's %s lays no freeze of %d turn: %s" % [FREEZE, FREEZE_TURNS, str(st)])
	ok(not bool(fz.get("aoe", false)) and String(fz.get("target", "")) != "ally" and int(fz.get("damage", 0)) > 0 and String(fz.get("special", "")) == "",
		"§3: the Titan's freeze does not ride a blow at one hero — a blow, single, struck at the heroes, no special")
	var spends := (kd.get("abilities", []) as Array).filter(func(a): return String((a as Dictionary).get("special", "")).begins_with("malice_"))
	ok(spends.size() == 1, "§3: the Titan holds %d Malice spends, not one" % spends.size())
	# C12 — NO RUNG TAG, AND ITS KIT THE SAME AT EVERY RUNG.
	var tagged := (kd.get("abilities", []) as Array).filter(func(a): return (a as Dictionary).has("rung"))
	var low: Array = (Enemies.config(BOSS, 1)["abilities"] as Array).map(func(a): return (a as Ability).display_name)
	var high: Array = (Enemies.config(BOSS, Enemies.MAX_RUNG)["abilities"] as Array).map(func(a): return (a as Ability).display_name)
	print("    its kit at rung 1 %s, at rung %d %s" % [str(low), Enemies.MAX_RUNG, str(high)])
	ok(tagged.is_empty() and low == high, "§3: the Titan carries a rung tag (%d) or its kit differs by rung" % tagged.size())
	ok(String(_run.ZONE_DEFS.get(ZONE, {}).get("boss", "")) == BOSS, "§3: the Frozen Plains' boss is not the Titan")


# THE ONE DOOR EVERY DRIVE ENTERS BY: the real battle scene in the zone named, the enemies' own turns held off so only this gate
# moves a body.
func _board(zone_name: String, autoplay: bool) -> Node:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	_run.zone_name = zone_name
	for i in _run.party.size():
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(String(SEATS[i]))[0])))
	_run.specs_chosen = true
	_run.active = true
	_run.items = {}
	OS.set_environment("DOD_AUTOPLAY", "1" if autoplay else "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


func _heroes(s: Node) -> Array:
	return (s.get("heroes") as Array).filter(func(u): return not (u as BattleUnit).is_companion and not (u as BattleUnit).dead)


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not (e as BattleUnit).dead)


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


# A HERO CLEAN AND WHOLE, NOTHING TO BLOCK OR PARRY A BLOW WITH: the drive reads what the blow lands, not what a guard took.
func _clean(h: BattleUnit) -> void:
	for st in h.statuses.duplicate():
		h.remove_status(String((st as Dictionary).get("id", "")))
	h.hp = h.max_hp
	h.pressure = 0
	h.broken = false
	h.broken_pending = false
	h.block_chance = -10.0
	h.parry_chance = 0.0
	h.no_cover = 1


# C11 — THE FREEZE RIDES A BLOW AS JO's RULING 5 SHAPES ONE: it lands on a hit and costs the hero one turn; a Block or a miss lays
# nothing; Ironclad and Hallowed refuse it; a cleanse lifts it.
func _s3_the_freeze(s: Node) -> void:
	print("\n§3 — the freeze, driven: it lands on a hit and costs a turn; a Block, a miss, Ironclad and Hallowed stop it; a cleanse lifts it")
	if s == null:
		ok(false, "§3: no board to drive")
		return
	Engine.time_scale = 20.0
	var foes := _foes(s)
	var heroes := _heroes(s)
	ok(foes.size() >= 1 and heroes.size() == 4, "§3: the board holds %d foes and %d heroes" % [foes.size(), heroes.size()])
	if foes.is_empty() or heroes.size() < 4:
		Engine.time_scale = 1.0
		return
	var f: BattleUnit = foes[0]
	var cfg := Enemies.config(BOSS)
	var fz: Ability = null
	for x in cfg["abilities"]:
		if (x as Ability).display_name == FREEZE:
			fz = x
	ok(fz != null, "§3: the Titan's kit holds no %s to drive" % FREEZE)
	if fz == null:
		Engine.time_scale = 1.0
		return
	f.abilities = cfg["abilities"]
	f.attack = int(cfg.get("attack", f.attack))
	f.no_cover = 1
	f.cooldowns = {}
	f.crit_bonus = -1.0
	# THE AIM STANDS OFF THE TIMELINE WHILE IT IS STRUCK, so no turn of its own passes between a blow and the reading.
	var aim: BattleUnit = heroes[1]
	var aim_next := aim.next_time
	aim.next_time = INF
	var rows := {}
	# ON A HIT: it lands, and the hero is hurt.
	_clean(aim)
	seed(5151)
	await s._resolve(f, fz, aim, "good")
	rows["hit"] = [aim.has_status("frozen"), aim.hp < aim.max_hp]
	# A BLOCK: the blow is blocked, and nothing rides it.
	_clean(aim)
	aim.block_chance = 10.0
	await s._resolve(f, fz, aim, "good")
	rows["block"] = [aim.has_status("frozen"), aim.hp < aim.max_hp]
	# A MISS: a hero behind a Mirror Image takes a single blow's miss, as every single blow rolls one (the attacker's cover roll on).
	_clean(aim)
	f.no_cover = 0
	s._apply_status(aim, "mirror", 3, 2)
	await s._resolve(f, fz, aim, "good")
	rows["miss"] = [aim.has_status("frozen"), aim.hp < aim.max_hp]
	f.no_cover = 1
	# IRONCLAD AND HALLOWED refuse it at the status door.
	_clean(aim)
	s._apply_status(aim, "ironclad", 3, 0)
	await s._resolve(f, fz, aim, "good")
	rows["ironclad"] = [aim.has_status("frozen"), aim.hp < aim.max_hp]
	_clean(aim)
	s._apply_status(aim, "sanctified", 3, 0)
	await s._resolve(f, fz, aim, "good")
	rows["hallowed"] = [aim.has_status("frozen"), aim.hp < aim.max_hp]
	# A CLEANSE lifts it: the single-pick cleanse every hero's door reaches.
	_clean(aim)
	await s._resolve(f, fz, aim, "good")
	var lifted := aim.dispel_one_debuff() if aim.has_status("frozen") else ""
	rows["cleanse"] = [aim.has_status("frozen"), lifted]
	print("    [frozen, hurt]: %s" % str(rows))
	ok(rows["hit"] == [true, true], "§3: the Titan's freeze did not land on a hero it struck: %s" % str(rows["hit"]))
	ok(not bool(rows["block"][0]), "§3: a blocked blow still laid the freeze — the Block stops nothing riding it")
	ok(rows["miss"] == [false, false], "§3: the freeze landed through a miss: %s" % str(rows["miss"]))
	ok(not bool(rows["ironclad"][0]) and not bool(rows["hallowed"][0]), "§3: Ironclad or Hallowed did not refuse the freeze: %s" % str(rows))
	ok(rows["cleanse"][0] == false and String(rows["cleanse"][1]) != "", "§3: a cleanse did not lift the freeze: %s" % str(rows["cleanse"]))
	aim.next_time = aim_next
	Engine.time_scale = 1.0


# C09 — THE HOARFROST WARDEN's HEAL IS CHOSEN BY THE DOOR EVERY WARBAND HEAL IS (`_enemy_support_action`), BY ITS NAME: a body of
# the board in the Warden's kit, hurt by a quarter, with a pool that pays — the Wave on itself; with an empty pool — no heal. The
# battery's one Warden fight declared none (§4's count says so); this is the choice itself, driven.
func _s2_the_warden_heals(s: Node) -> void:
	print("\n§2 — the Sleetveil Matron's heal, chosen by the warband's door: hurt and paid for, the Wave; an empty pool, none")
	var foes := _foes(s) if s != null else []
	if foes.is_empty() or not Enemies._load().has("hoarfrost_warden"):
		ok(false, "§2: no board, or no Sleetveil Matron, to drive the heal on")
		return
	var f: BattleUnit = foes[0]
	var was_ab: Array = f.abilities
	var was_hp := f.hp
	var was_pool := int(s.get("malice"))
	f.abilities = Enemies.config("hoarfrost_warden")["abilities"]
	f.cooldowns = {}
	f.intent = {}
	f.hp = f.max_hp - int(ceil(f.max_hp * 0.25))
	s.set("malice", 999)
	var paid: Array = s._enemy_support_action(f)
	s.set("malice", 0)
	var broke: Array = s._enemy_support_action(f)
	var healed: bool = paid.size() == 2 and (paid[0] as Ability).display_name == "Healing Wave" and paid[1] == f
	var refused: bool = broke.is_empty() or (broke[0] as Ability).display_name != "Healing Wave"
	print("    hurt by a quarter: %s; with an empty pool: %s" % [str(paid.map(func(x): return (x as Ability).display_name if x is Ability else (x as BattleUnit).unit_name)), str(broke.map(func(x): return (x as Ability).display_name if x is Ability else (x as BattleUnit).unit_name))])
	ok(healed and refused, "§2: the warband's door does not choose the Sleetveil Matron's Healing Wave when a body is hurt and the pool pays, or chooses it with none to pay")
	f.abilities = was_ab
	f.hp = was_hp
	s.set("malice", was_pool)


# IT COSTS ONE TURN, DRIVEN ON A BOARD THE BOT PLAYS: every hero held off the timeline (`next_time` INF) until the loop has passed to
# the warband, then each struck by Entomb, then all four put due at the clock's now — so no hero's turn, a cleanse among them, falls
# between a freeze and the turn it costs, and each loses its next turn before any thawed hero acts again: exactly one each.
func _s3_the_lost_turn(s: Node) -> void:
	print("\n§3 — the freeze costs a turn, driven: every hero frozen at once, each passed by once and thawed")
	if s == null:
		ok(false, "§3: no board to drive the lost turn on")
		return
	var foes := _foes(s)
	var heroes := _heroes(s)
	var cfg := Enemies.config(BOSS)
	var fz: Ability = null
	for x in cfg["abilities"]:
		if (x as Ability).display_name == FREEZE:
			fz = x
	if foes.is_empty() or heroes.size() < 4 or fz == null:
		ok(false, "§3: the lost turn has no board: %d foes, %d heroes, Entomb %s" % [foes.size(), heroes.size(), str(fz != null)])
		return
	var f: BattleUnit = foes[0]
	f.abilities = cfg["abilities"]
	f.no_cover = 1
	f.crit_bonus = -1.0
	var at0 := {}
	var on0 := {}
	for h in heroes:
		_clean(h)
		at0[h] = _log_text(s).count("%s is frozen solid and loses their turn" % (h as BattleUnit).unit_name)
		on0[h] = _log_text(s).count("→ Frozen on %s (" % (h as BattleUnit).unit_name)
	Engine.time_scale = 20.0
	for h8 in heroes:
		(h8 as BattleUnit).next_time = INF
	var skips0 := _log_text(s).count("skips its turn (enemy attacks off)")
	var passed := 0
	while passed < 600 and _log_text(s).count("skips its turn (enemy attacks off)") <= skips0 and not bool(s.get("battle_over")):
		await process_frame
		passed += 1
	for h2 in heroes:
		await s._resolve(f, fz, h2, "good")
	var now := float(s.get("_clock"))
	for h9 in heroes:
		(h9 as BattleUnit).next_time = now
	# A LANDING IS READ OFF THE STATUS DOOR's OWN LINE: a hero whose turn falls inside the drive has lost it and thawed before a chip
	# could be read.
	var landed := 0
	for h6 in heroes:
		if _log_text(s).count("→ Frozen on %s (" % (h6 as BattleUnit).unit_name) > int(on0[h6]):
			landed += 1
	var waited := 0
	while waited < 6000 and heroes.any(func(h3): return (h3 as BattleUnit).has_status("frozen") and not (h3 as BattleUnit).dead) and not bool(s.get("battle_over")):
		await process_frame
		waited += 1
	var lost := {}
	var total := 0
	for h4 in heroes:
		var n := _log_text(s).count("%s is frozen solid and loses their turn" % (h4 as BattleUnit).unit_name) - int(at0[h4])
		lost[(h4 as BattleUnit).unit_name] = n
		total += n
	var still := heroes.filter(func(h5): return (h5 as BattleUnit).has_status("frozen"))
	print("    the loop passed to the warband in %d frames; %d of %d heroes frozen; turns lost %s in %d frames; still frozen: %d" % [passed, landed, heroes.size(), str(lost), waited, still.size()])
	ok(landed == heroes.size() and still.is_empty() and total == heroes.size() and lost.values().all(func(v): return int(v) == 1),
		"§3: the freeze did not cost each hero one turn and then thaw (frozen %d, turns lost %s, still frozen %d)" % [landed, str(lost), still.size()])
	Engine.time_scale = 1.0


# ── §4 — THE COUNT ────────────────────────────────────────────────────────────

func _s4_the_count() -> void:
	print("\n§4 — the count: every row carries the attacking fights' number, and a kind never met says why")
	var lines := _doc(COUNT_TABLE).split("\n", false)
	ok(lines.size() > 4, "§4: the kept count %s is not in the tree" % COUNT_TABLE)
	if lines.size() <= 4:
		return
	var head := String(lines[0]).split("\t")
	var den := head.find(DENOMINATOR)
	ok(den >= 0, "§4: the count carries no column for %s" % DENOMINATOR)
	var bare: Array = []
	var unsaid: Array = []
	var named := {}
	var why := head.find("why")
	for r in lines.slice(1):
		var c := String(r).split("\t")
		if c.size() < head.size():
			continue
		if den >= 0 and int(c[den]) <= 0:
			bare.append(c[0] + " " + c[1])
		if String(c[0]) == "a JS kind":
			named[String(c[1])] = true
			var count_col := head.find("count")
			if count_col >= 0 and int(c[count_col]) == 0 and (why < 0 or String(c[why]).strip_edges() == ""):
				unsaid.append(c[1])
	var missing := (SIX.keys() + [BOSS]).filter(func(k): return not named.has(String(k)))
	print("    %d rows; the JS kinds named %d of %d" % [lines.size() - 1, named.size(), SIX.size() + 1])
	ok(bare.is_empty(), "§4: a row carries no attacking-fight number beside it: %s" % [bare])
	ok(missing.is_empty(), "§4: the count names no row for %s" % [missing])
	ok(unsaid.is_empty(), "§4: a kind fielded nought times does not say which roster it is in and why the gates never met it: %s" % [unsaid])


# ── §5 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s5_not_done() -> void:
	print("\n§5 — the warband as JR landed it beside JS's additions, the Cleric's cut, the deck at twenty-five")
	var data: Dictionary = Enemies._load().duplicate(true)
	for k in SIX.keys() + [BOSS] + ADDED_SINCE:
		data.erase(k)
	for k2 in data:
		var z: Array = []
		for r in (data[k2] as Dictionary).get("zones", []):
			if OLD_ROSTERS.has(int(r)):
				z.append(r)
		(data[k2] as Dictionary)["zones"] = z
	for k3 in JR_PUT_BACK:
		if data.has(k3):
			for field in JR_PUT_BACK[k3]:
				(data[k3] as Dictionary)[field] = (JR_PUT_BACK[k3][field] as Array).duplicate()
	var d := JSON.stringify(data, "", true).md5_text()
	print("    the warband's data without JS's seven and rosters 4 and 5, JR's three tags put back: %s" % d)
	ok(d == WARBAND_AT_JQ_MD5, "§5: something in the warband's data moved besides JS's seven kinds and the two new roster tags — a move, a figure, a kind (C14)")
	var cut: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get("CLERIC_MANA_CUT")
	ok(cut != null and absf(float(cut) - CLERIC_CUT) < 0.0001, "§5: the Cleric's cut was pulled (%s)" % str(cut))
	var deck: Array = (_run.MODIFIERS as Dictionary).keys()
	deck.sort()
	ok(deck.size() == DECK_CLOSED_AT and ("%d|" % deck.size() + "|".join(deck)).md5_text() == DECK_MD5,
		"§5: the deck holds %d, not the twenty-five it closed at, or a card was swapped in it" % deck.size())


# ── §6 — THE TWO READINGS AND THE PLAYER's FILES ─────────────────────────────

func _s6_the_readings() -> void:
	print("\n§6 — both files read at the open and the close, and the room projected for the next batch")
	var where := _block(_doc("res://docs/state.md"), "## WHERE THE PROJECT IS")
	for f in READINGS:
		var hit := false
		for raw in where.split("\n"):
			var line := String(raw)
			if line.contains(String(f)) and line.contains("at the open") and line.contains("at the close") and line.contains("%d KiB" % CEILING_KIB if f == "`docs/state.md`" else "KiB"):
				hit = true
		ok(hit, "§6: the WHERE block does not read %s at the open and at the close%s" % [f, " against its 520 KiB" if f == "`docs/state.md`" else ""])
	var rx := RegEx.new()
	rx.compile(PROJECTED)
	ok(rx.search(where) != null, "§6: the WHERE block projects no room for the next batch (no PROJECTED FOR line)")


func _s6_the_players_files() -> void:
	print("\n§6 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§6: %s changed under this gate" % p)
