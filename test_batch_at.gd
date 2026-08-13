# test_batch_at.gd — the Arcanist re-authored around ESCALATION, plus §8's
# Shatter re-spec. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_at.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE SHAPE — 3 lanes x 7 exclusive rows + a capstone shelf, single ranks,
#      every one of the 24 ids present. (test_batch_ai asserts this generically
#      for all twelve trees; it is repeated here because AT renamed a lane and
#      moved an id between lanes, and a shape break would otherwise only
#      surface there.)
#   2. ALL 24 IDS — id, row, lane, name. EVERY id survives and re-specs in
#      place, which is the whole migration promise: saved picks resolve and no
#      save version moves. A dropped or renamed id silently voids a saved tree.
#   3. THE MAGNITUDES, ADDITIVE — both halves: the payload the node applies AND
#      the number its tooltip renders.
#   4. §1 — THE COMPOUNDING CURVE, at BOTH read sites, against the batch's own
#      worked table. This is the one thing the batch said to report on, so it
#      is checked as arithmetic rather than trusted: 5 -> +22%/+11%,
#      8 -> +54%/+27%, 12 -> +117%/+59%, 16 -> +204%/+102%. Plus the two shapes
#      that make it an escalation rather than a ramp — the curve is CONVEX (its
#      differences grow), and NOTHING CAPS EITHER END.
#   5. §2 — THE SQUARING TRAP. Neither Arcane Cannon nor Magi's Wrath may carry
#      a per-stack DAMAGE term, in the source or in live damage. Their Break
#      terms must survive, because Break is a different axis.
#   6. §2 — DEATH RAY's 5-stack gate, and that it CONSUMES NOTHING. Stabilize
#      out of the opening three and earnable from the spec pool.
#   7. §8 — SHATTER scales on TURNS HELD, caps at 12, and a held entry's
#      counter advances ONCE PER TURN and not once per unit per turn. The last
#      clause is the one worth a test: `_hold_sync` walks a ledger, and a
#      nested walk would look identical until two enemies were held at once.
#   8. §4/§5 — the rune audit: every counter the four Arcanist runes and the
#      three Mage runes ride is written by a node or still has a live read
#      site, the re-points pay their advertised numbers ALONE AND STACKED, and
#      the dissolved exclusive pair is gone from CLAUDE.md's prose.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# id -> [row, lane, name]. BATCH_AT.md §3's three tables, transcribed once.
# The ids are the OLD ones by design — §9's mapping lives in the changelog,
# and this is the machine-checkable half of it.
const NODES := {
	"ar_harmonics": [1, "Resonance", "Harmonics"],
	"ar_mastery": [2, "Resonance", "Attunement"],
	"ar_charged": [3, "Resonance", "Charged Bolts"],
	"ar_overcharge": [4, "Resonance", "Overcharge"],
	"ar_core": [5, "Resonance", "Resonant Core"],
	"ar_critical_mass": [6, "Resonance", "Critical Mass"],
	"ar_unlimited": [7, "Resonance", "Cascade"],
	"ar_conduit": [1, "Overload", "Conduit"],
	"ar_volatility": [2, "Overload", "Volatility"],
	"ar_temporal": [3, "Overload", "Temporal Rift"],
	"ar_suppressing": [4, "Overload", "Suppressing Fire"],
	"ar_cannoneer": [5, "Overload", "Cannoneer"],
	"ar_barrister": [6, "Overload", "Barrage Master"],
	"ar_mindfulness": [7, "Overload", "Terminal Velocity"],
	"ar_conversion": [1, "Entropy", "Conversion"],
	"ar_on_edge": [2, "Entropy", "On the Edge"],
	"ar_meltdown": [3, "Entropy", "Feedback Loop"],
	"ar_stable": [4, "Entropy", "Stable Alignment"],
	"ar_still": [5, "Entropy", "Backlash"],
	"ar_attunement": [6, "Entropy", "Siphon"],
	"ar_ward": [7, "Entropy", "Event Horizon"],
	"ar_singularity": [9, "Resonance", "Singularity"],
	"ar_wrath": [9, "Overload", "Magi's Wrath"],
	"ar_timelord": [9, "Entropy", "Perfect Conversion"],
}

# id -> [stat field, the value the PAYLOAD writes]. ADDITIVE units: each is the
# design number in the units its read site sums, never a bare 1 standing in for
# a multiplier.
const PAYLOADS := {
	"ar_harmonics": ["harmonics_ranks", 1],
	"ar_mastery": ["attunement_crit", 1],
	"ar_charged": ["charged_bolts_ranks", 5],
	"ar_core": ["resonant_core_ranks", 1],
	"ar_critical_mass": ["critical_mass_stacks", 4],
	"ar_unlimited": ["cascade_stacks", 1],
	"ar_conduit": ["conduit_step", 0.5],
	"ar_volatility": ["volatility_ranks", 30],
	"ar_temporal": ["temporal_ranks", 40],
	"ar_suppressing": ["suppressing_ranks", 2],
	"ar_cannoneer": ["cannoneer_ranks", 4],
	"ar_mindfulness": ["terminal_velocity", 15],
	"ar_conversion": ["conversion_ranks", 30],
	"ar_on_edge": ["on_edge_threshold", 35.0],
	"ar_meltdown": ["feedback_ranks", 30],
	"ar_stable": ["stable_ranks", 25],
	"ar_still": ["backlash_stacks", 1],
	"ar_attunement": ["siphon_ranks", 20],
	"ar_ward": ["event_horizon", 15],
	# RE-POINTED BY BATCH AU §4, in place with the reason here: the two
	# capstones were crossed and are uncrossed now. The step-doubling moved to
	# Magi's Wrath (Overload, whose thesis it always was) and Singularity took
	# a BUILD-RATE effect instead. It writes two fields; the second is asserted
	# below beside the kill clause.
	"ar_singularity": ["singularity_crit_build", 2],
	"ar_timelord": ["perfect_conversion", 1],
}

# id -> the number its TOOLTIP must render. Most of this tree's magnitudes live
# in a battle.gd read site, so the tooltip is the only place the DESIGN number
# appears beside the payload — and the two can drift apart silently.
const TOOLTIPS := {
	"ar_harmonics": "2", "ar_mastery": "3", "ar_charged": "5",
	"ar_core": "1", "ar_critical_mass": "4", "ar_unlimited": "1",
	"ar_conduit": "2", "ar_volatility": "30", "ar_temporal": "40",
	"ar_suppressing": "2", "ar_cannoneer": "9", "ar_barrister": "3",
	"ar_mindfulness": "15", "ar_conversion": "30", "ar_on_edge": "35",
	"ar_meltdown": "30", "ar_stable": "25", "ar_still": "1",
	"ar_attunement": "20", "ar_ward": "15",
}

# §1's worked table, verbatim: stacks -> [damage %, damage-taken %].
const CURVE := {5: [22, 11], 8: [54, 27], 12: [117, 59], 16: [204, 102]}


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
	Profile.save_path = "user://profile_batch_at_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_table()
	_magnitudes()
	_curve_maths()
	_kit()
	_source_audit()
	_rune_audit()
	_claude_md()

	await _live_curve()
	await _live_no_per_stack()
	await _live_death_ray()
	await _live_build_rate()
	await _live_entropy()
	await _live_shatter()

	if FileAccess.file_exists("user://profile_batch_at_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_at_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("test_batch_at: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- §3 the shape ----------

func _tree_shape() -> void:
	var tree: Array = Talents.LANE_TREES["arcanist"]
	ok(tree.size() == 27, "the tree holds 24 nodes (got %d)" % tree.size())
	var per_lane := {}
	var caps := 0
	var seen := {}
	for n in tree:
		var lane := String(n["lane"])
		var row := int(n["row"])
		per_lane[lane] = per_lane.get(lane, []) + [row]
		if n.get("capstone", false):
			caps += 1
			ok(row == Talents.CAPSTONE_ROW, "%s is a capstone and sits on the shelf" % n["id"])
		ok(int(n["ranks"]) == 1, "%s is a single-rank node" % n["id"])
		ok(not seen.has(n["id"]), "%s appears exactly once" % n["id"])
		seen[n["id"]] = true
		# The tree carries no exclusive_with references at all — the ROW does
		# the barring since Batch AI — so "valid exclusive references" is the
		# assertion that none has crept back in pointing at a node that moved.
		var excl := String(n.get("exclusive_with", ""))
		ok(excl == "" or seen.has(excl) or tree.any(func(m): return String(m["id"]) == excl),
			"%s's exclusive_with names a node that exists" % n["id"])
	ok(caps == 3, "exactly 3 capstones (got %d)" % caps)
	ok(per_lane.size() == 3, "exactly 3 lanes (got %d)" % per_lane.size())
	for lane in ["Resonance", "Overload", "Entropy"]:
		var rows: Array = per_lane.get(lane, [])
		rows.sort()
		ok(rows == [1, 2, 3, 4, 5, 6, 7, 8, 9],
			"lane %s holds rows 1-8 plus its capstone (got %s)" % [lane, rows])
	# §3: the lane formerly called Control is ENTROPY, because after AS
	# "Control" is the Cryomancer's identity word.
	ok(not per_lane.has("Control"),
		"the Control lane is gone — it is ENTROPY now")


func _node_table() -> void:
	var by_id := {}
	for n in Talents.LANE_TREES["arcanist"]:
		by_id[String(n["id"])] = n
	for id in NODES:
		ok(by_id.has(id), "%s survives (a dropped id voids a saved tree)" % id)
		if not by_id.has(id):
			continue
		var n: Dictionary = by_id[id]
		ok(int(n["row"]) == NODES[id][0],
			"%s sits on row %d (got %d)" % [id, NODES[id][0], int(n["row"])])
		ok(String(n["lane"]) == NODES[id][1],
			"%s is in lane %s (got %s)" % [id, NODES[id][1], n["lane"]])
		ok(String(n["name"]) == NODES[id][2],
			"%s is named %s (got %s)" % [id, NODES[id][2], n["name"]])
	# NO NEW IDS EITHER — the promise runs both ways, and a 25th id would mean
	# a save version move nobody asked for.
	for id in by_id:
		# BATCH BM: skip row 8 — this batch's table is ITS OWN record of ITS OWN
		# 24 nodes, and BM added a row-8 node to every lane. The check exists to
		# prove the twenty-four survive unchanged, not that nothing else exists.
		if int(by_id[id]["row"]) == 8:
			continue
		ok(NODES.has(id), "%s is one of the 24 authored ids" % id)


func _magnitudes() -> void:
	var by_id := {}
	for n in Talents.LANE_TREES["arcanist"]:
		by_id[String(n["id"])] = n
	for id in PAYLOADS:
		if not by_id.has(id):
			continue
		var stat: Dictionary = by_id[id].get("payload", {}).get("stat", {})
		var field: String = PAYLOADS[id][0]
		ok(stat.has(field), "%s writes %s" % [id, field])
		if stat.has(field):
			ok(abs(float(stat[field]) - float(PAYLOADS[id][1])) < 0.001,
				"%s writes %s = %s (got %s)" % [id, field, PAYLOADS[id][1], stat[field]])
		# ADDITIVE, NOT RANKED: a bare 1 standing in for a multiplier is the
		# form this batch removed. The four legitimate 1s are counted stacks.
		if not field in ["harmonics_ranks", "attunement_crit", "resonant_core_ranks",
				"cascade_stacks", "backlash_stacks",
				"perfect_conversion"]:
			ok(float(stat.get(field, 0)) != 1.0,
				"%s's %s is a real magnitude, not a rank-1 stand-in" % [id, field])
	# Conduit's counter must be a FLOAT and must NOT end in "_ranks", or
	# Runes.STAT_INT_KEYS coerces 0.5 to 0 and the node goes silently inert.
	var cd: Dictionary = by_id["ar_conduit"].get("payload", {}).get("stat", {})
	ok(cd.get("conduit_step", 0) is float, "conduit_step is a FLOAT")
	ok(not "conduit_step".ends_with("_ranks"),
		"conduit_step does not end in _ranks (the AA float-into-int trap)")
	ok(not Runes.STAT_INT_KEYS.has("conduit_step"),
		"conduit_step is not in STAT_INT_KEYS either")
	# Volatility carries TWO magnitudes: the damage add and the recoil SET.
	var vol: Dictionary = by_id["ar_volatility"].get("payload", {}).get("stat", {})
	ok(int(vol.get("volatility_recoil", 0)) == 25,
		"Volatility sets Cannon's recoil to 25%")
	# On the Edge carries the threshold AND the payout.
	var oe: Dictionary = by_id["ar_on_edge"].get("payload", {}).get("stat", {})
	ok(int(oe.get("on_edge_stacks", 0)) == 4, "On the Edge pays 4 Resonance")
	# Barrage Master rides the ability, not a stat.
	var bm: Dictionary = by_id["ar_barrister"].get("payload", {})
	ok(String(bm.get("ability", "")) == "Arcane Barrage"
			and int(bm.get("add", {}).get("random_hits", 0)) == 3,
		"Barrage Master adds 3 bolts to Arcane Barrage")
	# ...and the tooltip half: the rendered number a player actually reads.
	for id in TOOLTIPS:
		if not by_id.has(id):
			continue
		var shown := String(Talents.desc_for(by_id[id], 1))
		ok(shown.contains(TOOLTIPS[id]),
			"%s's tooltip renders %s (got %s)" % [id, TOOLTIPS[id], shown])
		ok(not shown.contains("{v}"), "%s's tooltip resolved its {v}" % id)


# ---------- §1 the compounding curve ----------

func _curve_maths() -> void:
	var u := BattleUnit.new()
	u.second_resource_name = "Resonance"
	for n in CURVE:
		u.second_resource = n
		# ROUNDED, not truncated, because that is how the game displays it and
		# how §1's table is written: 0.75 x 78 is 58.5, which the table calls 59.
		var dmg := int(round(u.resonance_dmg_bonus() * 100.0))
		var taken := int(round(u.resonance_taken_bonus() * 100.0))
		ok(dmg == CURVE[n][0],
			"§1 table: %d stacks give +%d%% damage (got +%d%%)" % [n, CURVE[n][0], dmg])
		ok(taken == CURVE[n][1],
			"§1 table: %d stacks give +%d%% taken (got +%d%%)" % [n, CURVE[n][1], taken])
	# COMPOUNDING, NOT LINEAR — the one thing the batch asked to be reported on.
	# A slope has constant differences; a curve's differences grow. Checked as a
	# PROPERTY rather than against four sampled numbers, because four points sit
	# on plenty of wrong functions.
	var prev_step := -1.0
	var last := 0.0
	for n in range(1, 21):
		u.second_resource = n
		var here := u.resonance_dmg_bonus()
		var step := here - last
		ok(step > prev_step + 0.0001,
			"the curve is CONVEX at %d stacks — each stack is worth more than the last" % n)
		prev_step = step
		last = here
	# NEITHER END IS CAPPED. At 40 stacks the curve is still climbing on both
	# sides; a ceiling anywhere would show up here as two equal readings.
	u.second_resource = 39
	var d39 := u.resonance_dmg_bonus()
	var t39 := u.resonance_taken_bonus()
	u.second_resource = 40
	ok(u.resonance_dmg_bonus() > d39, "the damage curve is uncapped at 40 stacks")
	ok(u.resonance_taken_bonus() > t39, "the taken curve is uncapped at 40 stacks")
	# CLAUSE 3 is LINEAR and stays that way — one stable term a player can hold
	# in their head. Its read site is asserted live below; here it is the shape.
	u.second_resource = 10
	var half := u.resonance_curve()
	u.second_resource = 20
	ok(u.resonance_curve() > 3.0 * half,
		"T(2N) grows faster than 2 x T(N) — the curve is not a slope in disguise")
	# Conduit and the Magi's Wrath capstone move the DAMAGE step, nothing else.
	u.second_resource = 12
	var base_taken := u.resonance_taken_bonus()
	u.conduit_step = 0.5
	ok(int(u.resonance_dmg_bonus() * 100.0) == 156,
		"Conduit at 12 stacks: +156%% (2%% x 78, got %d)" % int(u.resonance_dmg_bonus() * 100.0))
	u.conduit_step = 0.0
	# BATCH AU §4: the step-doubling is MAGI'S WRATH'S now, not Singularity's.
	# Same arithmetic, different capstone — the field is what moved.
	u.wrath_step_double = 1
	ok(int(u.resonance_dmg_bonus() * 100.0) == 234,
		"Magi's Wrath at 12 stacks: +234%% (3%% x 78, got %d)" % int(u.resonance_dmg_bonus() * 100.0))
	ok(abs(u.resonance_taken_bonus() - base_taken) < 0.0001,
		"...and neither one touches the damage-TAKEN step")
	u.free()


# ---------- §2 the kit ----------

func _kit() -> void:
	var kit: Array = Classes.spec_abilities("arcanist")
	var names := kit.map(func(a): return a.display_name)
	ok(names.size() == 3, "the opening three is three (got %d)" % names.size())
	ok(names.has("Arcane Cannon") and names.has("Arcane Barrage")
			and names.has("Death Ray"),
		"the opening three is Cannon, Barrage, DEATH RAY (got %s)" % [names])
	ok(not names.has("Stabilize"),
		"STABILIZE IS OUT of the opening three — it is the escape hatch")
	# Death Ray's own numbers, from §2 verbatim.
	for ab in kit:
		if ab.display_name == "Death Ray":
			# BATCH AU §3 raised it 40 -> 55.
			ok(ab.cost == 55, "Death Ray costs 55 Mana (got %d)" % ab.cost)
			ok(abs(ab.delay - 5.0) < 0.001, "Death Ray is 5.0 initiative")
			ok(ab.cooldown == 3, "Death Ray is 3cd (got %d)" % ab.cooldown)
			ok(ab.damage == 150, "Death Ray is 150%% of Attack (got %d)" % ab.damage)
			ok(String(ab.dmg_type) == "arcane", "Death Ray is arcane")
			ok(not ab.aoe and ab.random_hits == 0 and ab.multi_hits == 0,
				"Death Ray is single target")
	# Stabilize is EARNABLE, and exactly one def of it exists — the AK resolver
	# rule. A second copy is how a pool entry drifts from the kit it came from.
	ok(Classes.SPEC_POOLS["arcanist"].has("Stabilize"),
		"Stabilize joins SPEC_POOLS[arcanist] so it can be EARNED")
	var pooled := Classes.pool_ability("Stabilize")
	ok(pooled != null and String(pooled.special) == "stabilize",
		"...and it resolves out of the pool with its machinery intact")
	ok(Classes.trimmed_kit_ability("Stabilize") != null,
		"...from trimmed_kit_ability, which is its ONE def")
	ok(not Classes.CLASS_POOLS["mage"].has("Stabilize"),
		"...and it is spec-only: it reads Resonance, so AH's curation rule bars it")
	# Every pool entry still resolves (a pool naming an ability nothing defines
	# is an offer that pays nothing).
	for entry in Classes.SPEC_POOLS["arcanist"]:
		ok(Classes.pool_ability(entry) != null,
			"the Arcanist's pool entry %s resolves" % entry)
	# The passive's own text has to describe the passive that shipped.
	var pd := String(Classes.SPEC_INFO["arcanist"]["passive_desc"])
	ok(pd.contains("Runaway Resonance"), "the passive is called Runaway Resonance")
	ok(pd.contains("NO") and pd.contains("MAXIMUM"), "...and it says there is no maximum")
	ok(not pd.contains("max 5"), "...and no longer claims a cap of 5")
	ok(not pd.contains("Backlash Ward"),
		"...and no longer promises Backlash Ward, which is deleted")


# ---------- §2's trap, and §1's read sites, asserted against the SOURCE ----------

func _source_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	# THE SQUARING TRAP. These are the two exact expressions Batch AT removed;
	# either one back in the source multiplies a curve by a slope.
	ok(not src.contains("0.075 + 0.025 * attacker.cannoneer_ranks"),
		"Arcane Cannon carries no per-stack DAMAGE term (the squaring trap)")
	ok(not src.contains("raw *= 1.0 + 0.04 * attacker.second_resource"),
		"Magi's Wrath carries no per-stack DAMAGE term either")
	# ...but the Break terms MUST survive: Break is a different axis.
	ok(src.contains("(5.0 + attacker.cannoneer_ranks)"),
		"Cannon's BD is still 5 x stacks, deepened by Cannoneer")
	ok(src.contains("2.5 * attacker.second_resource"),
		"Wrath's BD is still 2.5 x stacks")
	# ONE implementation of the curve, in unit.gd, delegated to from battle.gd —
	# so the nameplate, the tooltip and the damage path cannot disagree.
	ok(usrc.contains("n * (n + 1.0) * 0.5"),
		"the triangular curve has exactly one implementation")
	ok(src.count("n * (n + 1.0) * 0.5") == 0,
		"...and battle.gd does not carry a second copy")
	ok(src.contains("func _resonance_dmg_mult") and src.contains("func _resonance_taken_mult"),
		"battle.gd reads the curve through two named sites")
	ok(src.count("_resonance_dmg_mult(") == 3,
		"the damage side has exactly its two read sites plus the definition")
	ok(src.count("_resonance_taken_mult(") == 2,
		"the taken side has exactly one read site plus the definition")
	# Overcharge's cap-weighting is gone with the cap.
	ok(not src.contains("_resonance_power"),
		"the Overcharge stack-weighting helper is gone with the ceiling")
	ok(not src.contains("Backlash Ward") and not src.contains("Unlimited Power"),
		"Backlash Ward and Unlimited Power are DELETED, not left unreachable")
	ok(not src.contains("\"unlimited\":"), "...and the Unlimited Power status went with them")
	# The vault pattern: kept, gated, and reachable only from a rune.
	for kept in ["mindfulness_ranks", "arcane_mastery_ranks", "critical_mass_ranks",
			"mana_attune_ranks", "still_mind_ranks"]:
		ok(usrc.contains("var %s" % kept),
			"%s is KEPT rather than silently deleted (the AR vault pattern)" % kept)


# ---------- §4/§5 the runes ----------

func _rune_audit() -> void:
	var arcanist_runes := []
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) == "spec:arcanist":
			arcanist_runes.append(id)
	ok(arcanist_runes.size() == 4,
		"the Arcanist has 4 spec runes (got %d)" % arcanist_runes.size())
	# Every counter a rune writes must be written by a node OR still have a live
	# read site. This is the assertion that caught real breakage in AR and AS.
	var node_fields := {}
	for n in Talents.LANE_TREES["arcanist"]:
		for f in n.get("payload", {}).get("stat", {}):
			node_fields[String(f)] = true
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	for id in arcanist_runes:
		for f in Runes.config(id).get("payload", {}).get("stat", {}):
			var field := String(f)
			if field == "mana_regen_bonus":
				continue
			var noded: bool = node_fields.has(field)
			var live: bool = bsrc.contains(field) or usrc.contains(field)
			ok(noded or live,
				"rune %s writes %s, which is noded or still read" % [id, field])
			ok(usrc.contains("var %s" % field),
				"...and %s is a real BattleUnit field (set() drops a typo silently)" % field)
	# THE RE-POINTS, each one named so a silent revert trips here.
	var core: Dictionary = Runes.config("resonant_core").get("payload", {}).get("stat", {})
	ok(core.has("conduit_step") and not core.has("conduit_ranks"),
		"the Resonant Core rune was RE-POINTED conduit_ranks -> conduit_step")
	ok(abs(float(core.get("conduit_step", 0.0)) - 0.5) < 0.001,
		"...and pays the node's own 0.5 points of curve step")
	var unquiet: Dictionary = Runes.config("unquiet_mind").get("payload", {}).get("stat", {})
	ok(int(unquiet.get("feedback_ranks", 0)) == 20,
		"the Unquiet Mind rune was RE-POINTED feedback_ranks 2 -> 20 (percentage POINTS)")
	ok(String(Runes.config("unquiet_mind").get("lane", "")) == "Entropy",
		"...and its lane tag followed Control -> Entropy (a dead lane name leaves it homeless)")
	var wide: Dictionary = Runes.config("wide_current").get("payload", {}).get("stat", {})
	ok(wide.has("rune_on_edge_ranks") and not wide.has("on_edge_ranks"),
		"the Wide Current rune keeps its OWN On the Edge term (the AR Cinder Trail pattern)")
	ok(int(wide.get("arcane_mastery_ranks", 0)) == 1
			and int(wide.get("critical_mass_ranks", 0)) == 1,
		"...and its other two clauses are untouched, because their read sites were kept")
	# THE THREE MAGE CLASS-WIDE RUNES TOUCH NO ARCANIST COUNTER — asserted, not
	# assumed, because a collision there would re-tune a rune for every mage.
	var arc_fields := node_fields.duplicate()
	for extra in ["mindfulness_ranks", "arcane_mastery_ranks", "critical_mass_ranks",
			"rune_on_edge_ranks", "on_edge_stacks", "volatility_recoil"]:
		arc_fields[extra] = true
	var mage_runes := 0
	for id in Runes.ids():
		if String(Runes.config(id).get("scope", "")) != "class:mage":
			continue
		mage_runes += 1
		for f in Runes.config(id).get("payload", {}).get("stat", {}):
			ok(not arc_fields.has(String(f)),
				"the Mage-wide rune %s does not write the Arcanist counter %s" % [id, f])
	ok(mage_runes == 3, "there are 3 Mage class-wide runes (got %d)" % mage_runes)


func _claude_md() -> void:
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	# §5: the ar_ward <-> ar_still pair dissolves with the two designs, and the
	# prose is the only place it ever lived (Batch AI retired the test to a
	# bare `pass`). The entry must be GONE, and the other four left alone.
	# The pair must leave the ACTIVE list — read out of the parenthetical the
	# rule names, not the whole file, because the dissolution itself is recorded
	# in prose right after it (the AS pattern: never let an entry quietly vanish).
	var at := claude.find("EXCLUSIVE talent pair (")
	ok(at >= 0, "CLAUDE.md still states the no-rune-writes-an-exclusive-half rule")
	var active := claude.substr(at, claude.find(" — cold_snap", at) - at) if at >= 0 else ""
	ok(not active.contains("arcane_ward/still_mind"),
		"the arcane_ward/still_mind pair is gone from the ACTIVE list")
	ok(claude.contains("arcane_ward/still_mind DISSOLVED IN BATCH AT"),
		"...and it says so, rather than the entry quietly vanishing")
	ok(claude.contains("heat_haze/scorched") and claude.contains("cascade/overflow")
			and claude.contains("stalwart/bastion") and claude.contains("pact_flesh/barter"),
		"...and the remaining pairs are left alone")


# ---------- live ----------

func _spawn(learned: Dictionary, lineup: Array, specs: Array, ty := "fight") -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": ty, "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR/AS discipline). Every
	# check below drives _resolve by hand, and a 5% miss or a 5% parry skips the
	# whole damage path — which reads exactly like "the node did nothing".
	#
	# THE CRIT IS THE THIRD COIN, AND ON THIS SPEC IT IS THE WORST ONE: Runaway
	# Resonance adds +1% crit PER STACK, so a "same cast at 0 stacks vs 12"
	# comparison silently compares 10% crit against 22% crit and the 1.5x spikes
	# land only in the high sample. A build-rate check has the same problem from
	# the other side — a crit builds 2 where a normal hit builds 1, so ONE
	# unlucky roll turns "Harmonics grants 1 extra" into "it granted 2". A big
	# negative crit_bonus drives the roll below zero on both sides, so
	# `randf() < chance` can never be true. Tests that WANT a crit set it back.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
	return scene


func _arc(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.second_resource_name) == "Resonance":
			return h
	return null


func _find(u: BattleUnit, name: String) -> Ability:
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


# §1's curve at the two LIVE read sites — the same numbers the table promises,
# measured through _resolve rather than off the helper.
func _live_curve() -> void:
	var scene := await _spawn({}, ["raider", "raider"], ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	ok(arc != null, "the Arcanist spawned holding Resonance")
	if arc == null:
		scene.queue_free()
		return
	ok(arc.second_max >= 99, "his Resonance ceiling is a sentinel, not a cap")
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.armor = 0.0
	foe.resists = {}
	var explosion: Ability = arc.abilities[0]
	# The DAMAGE side: the same cast at 0 stacks and at 12 must differ by the
	# table's +117%. Each hit still carries a +/-10% variance roll, so this SUMS
	# TEN CASTS at each level — one pair of samples has a +/-22% envelope, which
	# is wide enough to pass a wrong curve.
	var at0 := 0
	var at12 := 0
	for _i in 10:
		arc.second_resource = 0
		foe.hp = 999999
		await scene.call("_resolve", arc, explosion, foe, "good")
		at0 += 999999 - foe.hp
		arc.second_resource = 12
		foe.hp = 999999
		await scene.call("_resolve", arc, explosion, foe, "good")
		at12 += 999999 - foe.hp
	ok(at0 > 0 and at12 > 0, "both casts landed")
	if at0 > 0:
		var ratio := float(at12) / float(at0)
		ok(ratio > 2.0 and ratio < 2.35,
			"12 stacks roughly DOUBLE his damage (ratio %.2f, table says 2.17)" % ratio)
	# The TAKEN side, measured the same way on the way in.
	var hitter: BattleUnit = scene.get("enemies")[1]
	arc.max_hp = 999999
	arc.armor = 0.0
	arc.resists = {}
	arc.dmg_taken_bonus = 0.0
	var swing: Ability = hitter.abilities[0]
	var took0 := 0
	var took12 := 0
	for _i in 10:
		arc.second_resource = 0
		arc.hp = 999999
		await scene.call("_resolve", hitter, swing, arc, "good")
		took0 += 999999 - arc.hp
		arc.second_resource = 12
		arc.hp = 999999
		await scene.call("_resolve", hitter, swing, arc, "good")
		took12 += 999999 - arc.hp
	ok(took0 > 0 and took12 > took0,
		"12 stacks make him take MORE (%d -> %d)" % [took0, took12])
	if took0 > 0:
		var tratio := float(took12) / float(took0)
		ok(tratio > 1.48 and tratio < 1.70,
			"...by roughly the table's +59%% (ratio %.2f)" % tratio)
	# CLAUSE 3, live: +1% crit per stack, LINEAR. Read off the source's own
	# expression rather than sampled, because a crit rate is a coin.
	var csrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(csrc.contains("(0.01 + 0.01 * attacker.arcane_mastery_ranks) \\\n\t\t\t\t\t* attacker.second_resource"),
		"crit is +1% per stack, linear and off the raw stack count")
	scene.queue_free()
	await process_frame


# §2's trap, live: the same Cannon cast at 0 and at 8 stacks must differ by the
# PASSIVE's curve alone. If a per-stack term were still on the ability the gap
# would be the square of it.
func _live_no_per_stack() -> void:
	var scene := await _spawn({}, ["raider"], ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.armor = 0.0
	foe.resists = {}
	var cannon := _find(arc, "Arcane Cannon")
	ok(cannon != null, "Arcane Cannon is in the kit")
	if cannon == null:
		scene.queue_free()
		return
	arc.max_resource = 9999
	arc.resource = 9999
	arc.second_resource = 0
	foe.hp = 999999
	await scene.call("_resolve", arc, cannon, foe, "good")
	var c0 := 999999 - foe.hp
	arc.second_resource = 8
	foe.hp = 999999
	foe.pressure = 0
	await scene.call("_resolve", arc, cannon, foe, "good")
	var c8 := 999999 - foe.hp
	if c0 > 0:
		var r := float(c8) / float(c0)
		# The passive alone gives 1.54x at 8 stacks. The old ability term would
		# have made it 1.54 x 1.60 = 2.46 — outside this band by a mile.
		ok(r > 1.35 and r < 1.85,
			"Cannon at 8 stacks scales by the PASSIVE alone (%.2fx, not ~2.5x)" % r)
	# ...and its Break damage still rides the stacks.
	ok(foe.pressure >= 40,
		"Cannon still pays BD = 5 x stacks (8 stacks -> %d Break)" % foe.pressure)
	scene.queue_free()
	await process_frame


# §2: Death Ray's gate, and that pressing it costs him nothing but Mana.
func _live_death_ray() -> void:
	var scene := await _spawn({}, ["raider"], ["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var dray := _find(arc, "Death Ray")
	ok(dray != null, "Death Ray is in the opening three")
	if dray == null:
		scene.queue_free()
		return
	arc.max_resource = 9999
	arc.resource = 9999
	# BATCH AU §3 raised the gate 5 -> 8, so 5 and 7 are DARK where they lit.
	for n in [0, 1, 4, 5, 7]:
		arc.second_resource = n
		ok(not scene.call("_ability_usable", arc, dray),
			"Death Ray is DARK at %d Resonance" % n)
	for n in [8, 9, 20]:
		arc.second_resource = n
		ok(scene.call("_ability_usable", arc, dray),
			"Death Ray LIGHTS at %d Resonance" % n)
	# IT CONSUMES NOTHING — the whole point of "the ramp never comes down". Note
	# what that does NOT mean: Death Ray is a damaging cast, so it still BUILDS
	# one like every other one. The assertion is that the count never FALLS.
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.hp = 999999
	arc.second_resource = 9
	await scene.call("_resolve", arc, dray, foe, "good")
	ok(arc.second_resource >= 9,
		"Death Ray consumed NO stacks (9 -> %d)" % arc.second_resource)
	ok(arc.second_resource == 10,
		"...and, being a damaging cast, it built one like any other")
	ok(foe.hp < 999999, "...and it landed")
	# Terminal Velocity: at 15+ the cooldown never starts.
	var tv := await _spawn({"ar_mindfulness": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc2 := _arc(tv)
	if arc2 != null:
		ok(arc2.terminal_velocity == 15, "Terminal Velocity's threshold is 15")
		var dr2 := _find(arc2, "Death Ray")
		var foe2: BattleUnit = tv.get("enemies")[0]
		foe2.max_hp = 999999
		foe2.hp = 999999
		arc2.max_resource = 9999
		arc2.resource = 9999
		arc2.second_resource = 9
		await tv.call("_resolve", arc2, dr2, foe2, "good")
		ok(arc2.cooldown_left(dr2) > 0, "below 15 stacks Death Ray still cools")
		arc2.cooldowns.erase("Death Ray")
		arc2.second_resource = 16
		await tv.call("_resolve", arc2, dr2, foe2, "good")
		ok(arc2.cooldown_left(dr2) == 0,
			"TERMINAL VELOCITY: at 16 stacks Death Ray has no cooldown")
	tv.queue_free()
	scene.queue_free()
	await process_frame


# §3's Resonance lane: every node that moves the build rate, at its read site.
func _live_build_rate() -> void:
	var scene := await _spawn({"ar_harmonics": 1}, ["raider", "raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.max_hp = 999999
	foe.hp = 999999
	var explosion: Ability = arc.abilities[0]
	# Harmonics: the free basic builds 2, not 1. res_cast_this_turn is forced
	# true so Resonant Core cannot be mistaken for this.
	arc.second_resource = 0
	arc.res_cast_this_turn = true
	await scene.call("_resolve", arc, explosion, foe, "good")
	ok(arc.second_resource == 2,
		"HARMONICS: Arcane Explosion builds 2 (got %d)" % arc.second_resource)
	scene.queue_free()
	await process_frame
	# Cascade: at 10+ stacks every cast builds one extra. Below 10 it does not,
	# which is the half that proves the gate is real.
	var cas := await _spawn({"ar_unlimited": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a2 := _arc(cas)
	if a2 != null:
		var f2: BattleUnit = cas.get("enemies")[0]
		f2.max_hp = 999999
		f2.hp = 999999
		a2.second_resource = 5
		a2.res_cast_this_turn = true
		await cas.call("_resolve", a2, a2.abilities[0], f2, "good")
		ok(a2.second_resource == 6, "Cascade is DARK at 5 stacks (got %d)" % a2.second_resource)
		a2.second_resource = 10
		a2.res_cast_this_turn = true
		await cas.call("_resolve", a2, a2.abilities[0], f2, "good")
		ok(a2.second_resource == 12,
			"CASCADE: at 10 stacks a cast builds 2 (got %d)" % a2.second_resource)
	cas.queue_free()
	await process_frame
	# Resonant Core: the FIRST cast of a turn only. The second must not pay.
	var rc := await _spawn({"ar_core": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a3 := _arc(rc)
	if a3 != null:
		var f3: BattleUnit = rc.get("enemies")[0]
		f3.max_hp = 999999
		f3.hp = 999999
		a3.second_resource = 0
		a3.res_cast_this_turn = false
		await rc.call("_resolve", a3, a3.abilities[0], f3, "good")
		ok(a3.second_resource == 2,
			"RESONANT CORE: the first cast of a turn builds 2 (got %d)" % a3.second_resource)
		await rc.call("_resolve", a3, a3.abilities[0], f3, "good")
		ok(a3.second_resource == 3,
			"...and the second cast of the same turn builds 1 (got %d)" % a3.second_resource)
	rc.queue_free()
	await process_frame


# §3's Entropy lane: danger into fuel, and the capstone that ends it.
func _live_entropy() -> void:
	# Backlash: being hit builds Resonance.
	var scene := await _spawn({"ar_still": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var arc := _arc(scene)
	if arc == null:
		scene.queue_free()
		return
	var hitter: BattleUnit = scene.get("enemies")[0]
	arc.max_hp = 999999
	arc.hp = 999999
	arc.second_resource = 0
	await scene.call("_resolve", hitter, hitter.abilities[0], arc, "good")
	ok(arc.second_resource >= 1,
		"BACKLASH: a blow received builds Resonance (got %d)" % arc.second_resource)
	scene.queue_free()
	await process_frame
	# Event Horizon: at 15+ stacks no single attack can put him down.
	var eh := await _spawn({"ar_ward": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a2 := _arc(eh)
	if a2 != null:
		ok(a2.event_horizon == 15, "Event Horizon's threshold is 15")
		a2.max_hp = 200
		a2.hp = 40
		a2.second_resource = 14
		a2.take_hit(500, 0)
		ok(a2.hp == 0 or a2.dead,
			"below 15 stacks a lethal blow is still lethal (hp %d)" % a2.hp)
		a2.dead = false
		a2.hp = 40
		a2.second_resource = 15
		a2.take_hit(500, 0)
		ok(a2.hp == 1,
			"EVENT HORIZON: at 15 stacks a lethal blow leaves him on 1 (hp %d)" % a2.hp)
	eh.queue_free()
	await process_frame
	# Perfect Conversion: ALL recoil is paid as Mana. Cannon recoils 15%, so a
	# capstone Arcanist takes a full-Mana Cannon and loses no health at all.
	var pc := await _spawn({"ar_timelord": 1}, ["raider"],
		["berserker", "arcanist", "inquisitor", "beastmaster"])
	var a3 := _arc(pc)
	if a3 != null:
		ok(a3.perfect_conversion == 1, "Perfect Conversion landed as a capstone")
		var f3: BattleUnit = pc.get("enemies")[0]
		f3.max_hp = 999999
		f3.hp = 999999
		f3.armor = 0.0
		f3.resists = {}
		var cannon := _find(a3, "Arcane Cannon")
		a3.max_resource = 9999
		a3.resource = 9999
		a3.max_hp = 999999
		a3.hp = 999999
		a3.second_resource = 8
		await pc.call("_resolve", a3, cannon, f3, "good")
		ok(a3.hp == 999999,
			"PERFECT CONVERSION: Cannon's recoil cost him NO health (hp %d)" % a3.hp)
		ok(a3.resource < 9999, "...it came out of his Mana instead")
	pc.queue_free()
	await process_frame


# ---------- §8 Shatter ----------

func _live_shatter() -> void:
	var scene := await _spawn({"cr_shatter": 1}, ["raider", "archer", "shaman"],
		["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var cryo: BattleUnit = null
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "permafrost":
			cryo = h
	ok(cryo != null, "the Cryomancer spawned")
	if cryo == null:
		scene.queue_free()
		return
	var foes: Array = scene.get("enemies")
	for f in foes:
		f.max_hp = 999999
		f.hp = 999999
		f.armor = 0.0
		f.resists = {}
	# Freeze one through the normal door, so the whole cascade behaves.
	for _i in 4:
		scene.call("_apply_status", foes[0], "chilled", 3, 0, 0, cryo)
	ok(scene.get("_holds").has(foes[0]), "the first enemy is HELD")
	ok(foes[0].hold_turns == 0, "a fresh prison starts on a charge of 0")
	# THE COUNTER ADVANCES ONCE PER TURN, NOT ONCE PER UNIT PER TURN. This is
	# the clause worth a test: `_hold_sync` walks the ledger, and a nested walk
	# would look identical until two enemies were held at once.
	for _i in 3:
		scene.call("_hold_sync")
	ok(foes[0].hold_turns == 3,
		"three _hold_sync passes charge it 3 turns (got %d)" % foes[0].hold_turns)
	# Now hold a SECOND enemy and prove neither one advances twice per pass.
	cryo.second_prison = 1
	for _i in 4:
		scene.call("_apply_status", foes[1], "chilled", 3, 0, 0, cryo)
	ok(scene.get("_holds").size() == 2, "two prisons stand")
	var was0: int = foes[0].hold_turns
	var was1: int = foes[1].hold_turns
	scene.call("_hold_sync")
	ok(foes[0].hold_turns == was0 + 1 and foes[1].hold_turns == was1 + 1,
		"ONE increment each per pass with TWO held — not one per unit per unit")
	# The chip shows the charge, because a charge the player cannot see is a
	# decision they cannot make.
	# `short` is what the chip actually PRINTS (_refresh_chips renders it into
	# the tag Label); `label` is the tooltip's heading. Asserting the wrong one
	# is how a test proves a chip that says nothing.
	var chip: Dictionary = foes[0].get_status("frozen")
	ok(String(chip.get("short", "")).begins_with("HELD"),
		"the nameplate chip still reads HELD (got %s)" % chip.get("short", ""))
	ok(String(chip.get("short", "")).contains(str(foes[0].hold_turns)),
		"...and it SHOWS THE COUNT (%s)" % chip.get("short", ""))
	ok(String(chip.get("desc", "")).contains("TURNS HELD"),
		"...and its tooltip says what the number buys")
	# THE 12-TURN CAP.
	for _i in 40:
		scene.call("_hold_sync")
	ok(foes[0].hold_turns == 12,
		"the charge CAPS at 12 turns (got %d)" % foes[0].hold_turns)
	# THE SCALING: 10% of Attack per turn held. Set two prisons to different
	# charges and prove the damage follows the charge, not the stacks — both
	# carry 4 stacks of Chilled, so a stack-based reading would tie them.
	ok(foes[0].status_stacks("chilled") == foes[1].status_stacks("chilled"),
		"both prisons carry the SAME Chilled pile — a stack reading would tie")
	foes[0].hold_turns = 10
	foes[1].hold_turns = 2
	foes[0].hp = 999999
	foes[1].hp = 999999
	var shat := _find(cryo, "Shatter")
	ok(shat != null, "Shatter is in the kit")
	if shat != null:
		cryo.max_resource = 9999
		cryo.resource = 9999
		await scene.call("_resolve", cryo, shat, foes[0], "good")
		var d0: int = 999999 - foes[0].hp
		var d1: int = 999999 - foes[1].hp
		ok(d0 > 0 and d1 > 0, "the mass release hit both prisons")
		if d1 > 0:
			var r := float(d0) / float(d1)
			ok(r > 3.5 and r < 7.0,
				"SHATTER SCALES ON TURNS HELD: 10 turns vs 2 is %.2fx (want ~5x)" % r)
		ok(scene.get("_holds").is_empty(), "...and every prison broke")
	# The bot prefers Shatter once the oldest hold has charged 5 turns.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains("SHATTER_BOT_TURNS := 5"),
		"the bot's Shatter/Lance crossover is 5 turns held")
	ok(bsrc.find("var shat := _find_ability(u, \"Shatter\")")
			< bsrc.find("if lance_up and not _holds.is_empty():"),
		"...and the Shatter check comes BEFORE the Ice Lance release")
	ok(not bsrc.contains("_ability_usable(u, shat) and _holds.size() >= 2"),
		"...and the two-prison gate that made it never fire is gone")
	scene.queue_free()
	await process_frame
