# test_batch_ax.gd — THE OCCULTIST: CORRUPTION. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ax.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 RUIN HAS NO MAXIMUM AND NEVER CLEARS, and it detonates on every TENTH
#      stack. The stacks SURVIVE 10, 20 and 30; a stack landing on 11 does not
#      re-arm; the detonation is 90% of Attack and 25% party heal; the
#      lifesteal is 2% PER STACK and REFUSES to exceed 40% with Soul Leech,
#      Gluttony and Soul Glut all learned; the amplification is uncapped.
#   §2 THE BOSS RULE IS LEGIBLE, not patched: the lane text, the glossary and
#      the ability tooltips all say it and all name BREAK as the key — and no
#      boss workaround was added to the guard.
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, every final magnitude on the node
#      that owes it, and every counter ADDITIVE at its read site.
#   §4 BOTH AUTHORED FALLBACKS (Mind Flay -> three minds, Mass Hysteria -> 2cd).
#   §5 THE RUNE AUDIT: every re-pointed counter lands on a live read site, the
#      three Cleric class-wide runes touch no Occultist counter, and the
#      Hollow Chalice's healing clamp is CHECKED rather than trusted.
#   §6 THE BOT: it focuses Ruin, and it holds the madness casts against an
#      unbroken boss.
#   §7 FERVOR: the brief's premise was stale — the ground already paid 2 a turn
#      with the node learned, which is the end state §7 asked for. Pinned at
#      that value so the finding cannot rot.
#   NEGATIVE CONTROLS for the three that would fail silently: a detonation
#      clearing the stacks, the lifesteal uncapped, and Ruin arming on any
#      stack rather than only on a multiple of the threshold.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false
var _report: Array = []


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
	Profile.save_path = "user://profile_batch_ax_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_magnitudes()
	_additive_units()
	_no_exclusive_pairs()
	_boss_legibility()
	_rune_audit()
	_bot_policy_source()
	_fervor_unmoved()
	_negative_control_source()

	await _live_thresholds()
	await _live_stacks_survive()
	await _live_detonation_payload()
	await _live_avatar_of_ruin()
	await _live_lifesteal_per_stack()
	await _live_lifesteal_cap()
	await _live_amplification()
	await _live_fallbacks()
	await _live_fervor()

	if FileAccess.file_exists("user://profile_batch_ax_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ax_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_ax: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("occultist", "cleric")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _find(u: BattleUnit, name: String) -> Ability:
	if u == null:
		return null
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


func _hero(scene: Node, idx: int) -> BattleUnit:
	var live: Array = []
	for h in scene.get("heroes"):
		if not h.is_companion:
			live.append(h)
	return live[idx] if idx < live.size() else null


func _foe(scene: Node, idx: int) -> BattleUnit:
	var foes: Array = scene.get("enemies")
	return foes[idx] if idx < foes.size() else null


# The party is warrior/mage/cleric/hunter, so the Occultist is slot 2.
func _spawn(learned: Dictionary, member_patch := {},
		lineup := ["raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "occultist", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 2 else {}
		run.sync_spec_hp(i)
	for key in member_patch:
		run.party[2][key] = member_patch[key]
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/AS/AT/AU/AV/AW discipline).
	# A driven _resolve still rolls miss, parry AND crit, and a crit is the
	# worst coin to leave live in a test that reads an exact heal.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
	return scene


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


# ---------- §3 the tree's shape ----------

const IDS := ["oc_emp_hex", "oc_deep_hex", "oc_channeling", "oc_broken_will",
	"oc_grim", "oc_entropy", "oc_unravel",
	"oc_spread", "oc_whispers", "oc_mind_flay", "oc_mirror", "oc_delirium",
	"oc_cackling", "oc_torment",
	"oc_soul_leech", "oc_invigoration", "oc_gluttony", "oc_pleasure",
	"oc_murderous", "oc_pact_flesh", "oc_barter",
	"oc_avatar_ruin", "oc_hysteria", "oc_soul_glut"]


func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 24, "the Occultist tree holds 24 nodes (got %d)" % tree.size())
	# EVERY ID SURVIVES AND RE-SPECS IN PLACE — no new ids, none deleted, so
	# saved picks migrate and no save version moves.
	var seen := {}
	for t in tree:
		seen[String(t.get("id", ""))] = true
	for id in IDS:
		ok(seen.has(id), "the id %s survives" % id)
	ok(seen.size() == 24, "...and no id was added (got %d distinct)" % seen.size())
	var per_lane := {}
	var caps := 0
	var cap_lanes := {}
	for t in tree:
		var lane := String(t.get("lane", ""))
		var row := int(t.get("row", 0))
		ok(t.has("ranks") and int(t["ranks"]) == 1,
			"%s is a single-rank node" % t.get("id", ""))
		if row == Talents.CAPSTONE_ROW:
			caps += 1
			cap_lanes[lane] = true
			ok(bool(t.get("capstone", false)),
				"%s on row 8 is flagged capstone" % t.get("id", ""))
		else:
			ok(row >= 1 and row <= 7,
				"%s sits on a real row (got %d)" % [t.get("id", ""), row])
			per_lane[lane] = per_lane.get(lane, 0) + 1
	ok(caps == 3, "exactly three capstones (got %d)" % caps)
	ok(cap_lanes.size() == 3, "the three capstones sit on three different lanes")
	for lane in ["Ruin", "Madness", "Leech"]:
		ok(per_lane.get(lane, 0) == 7,
			"lane %s holds 7 row nodes (got %d)" % [lane, per_lane.get(lane, 0)])
	# Every row of every lane is filled exactly once — the row IS the choice.
	var slots := {}
	for t in tree:
		var key := "%s/%d" % [t.get("lane", ""), t.get("row", 0)]
		ok(not slots.has(key), "no two nodes share the slot %s" % key)
		slots[key] = true
	# Any exclusive reference must name a node that exists.
	for t in tree:
		for ex in t.get("exclusive_with", []):
			ok(seen.has(String(ex)),
				"%s's exclusive reference %s names a live node" % [t.get("id", ""), ex])
	# ALL THREE LANE NAMES AND THESES STAND — this is the one Cleric tree that
	# did not need re-aiming, so every node sits exactly where Batch L put it.
	for pair in [["oc_emp_hex", "Ruin", 1], ["oc_deep_hex", "Ruin", 2],
			["oc_channeling", "Ruin", 3], ["oc_broken_will", "Ruin", 4],
			["oc_grim", "Ruin", 5], ["oc_entropy", "Ruin", 6],
			["oc_unravel", "Ruin", 7],
			["oc_spread", "Madness", 1], ["oc_whispers", "Madness", 2],
			["oc_mind_flay", "Madness", 3], ["oc_mirror", "Madness", 4],
			["oc_delirium", "Madness", 5], ["oc_cackling", "Madness", 6],
			["oc_torment", "Madness", 7],
			["oc_soul_leech", "Leech", 1], ["oc_invigoration", "Leech", 2],
			["oc_gluttony", "Leech", 3], ["oc_pleasure", "Leech", 4],
			["oc_murderous", "Leech", 5], ["oc_pact_flesh", "Leech", 6],
			["oc_barter", "Leech", 7],
			["oc_avatar_ruin", "Ruin", 8], ["oc_hysteria", "Madness", 8],
			["oc_soul_glut", "Leech", 8]]:
		var n := _node(String(pair[0]))
		ok(String(n.get("lane", "")) == String(pair[1])
			and int(n.get("row", 0)) == int(pair[2]),
			"%s sits at %s row %d (got %s row %s)" % [pair[0], pair[1], pair[2],
				n.get("lane", ""), n.get("row", 0)])
	# The names, by name rather than by id — a re-spec that forgot its label
	# would pass every structural check above.
	for pair in [["oc_emp_hex", "Empowered Hex"], ["oc_deep_hex", "Deeper Hex"],
			["oc_channeling", "Corrupted Channeling"], ["oc_broken_will", "Broken Will"],
			["oc_grim", "Grim Focus"], ["oc_entropy", "Entropy"],
			["oc_unravel", "Unraveling"], ["oc_spread", "Spread of Madness"],
			["oc_whispers", "Whispers"], ["oc_mind_flay", "Mind Flay"],
			["oc_mirror", "Umbral Mirror"], ["oc_delirium", "Delirium"],
			["oc_cackling", "Cackling Mirror"], ["oc_torment", "Lingering Torment"],
			["oc_soul_leech", "Soul Leech"], ["oc_invigoration", "Invigoration"],
			["oc_gluttony", "Gluttony"], ["oc_pleasure", "Pleasure from Pain"],
			["oc_murderous", "Murderous Intent"], ["oc_pact_flesh", "Pact of Flesh"],
			["oc_barter", "Dark Barter"], ["oc_avatar_ruin", "Avatar of Ruin"],
			["oc_hysteria", "Mass Hysteria"], ["oc_soul_glut", "Soul Glut"]]:
		ok(String(_node(String(pair[0])).get("name", "")) == String(pair[1]),
			"%s is named %s (got %s)" % [pair[0], pair[1],
				_node(String(pair[0])).get("name", "")])


# ---------- §3 the magnitudes, one per node ----------

func _magnitudes() -> void:
	# Field, node, value. THE COUNTER HOLDS THE MAGNITUDE, so the number here
	# is the number the tooltip prints and the number the read site uses.
	for row in [["oc_emp_hex", "emp_hex_ranks", 100],
			["oc_deep_hex", "deep_hex_step", 3],
			["oc_channeling", "channeling_ranks", 60],
			["oc_broken_will", "broken_will_ranks", 25],
			["oc_grim", "grim_ranks", 80],
			["oc_entropy", "entropy_ranks", 20],
			["oc_unravel", "unravel_ranks", 4],
			["oc_spread", "spread_ranks", 60],
			["oc_spread", "spread_ruin", 2],
			["oc_whispers", "whispers_step", 45],
			["oc_mirror", "mirror_ranks", 45],
			["oc_delirium", "delirium_ranks", 3],
			["oc_cackling", "cackling_ranks", 15],
			["oc_torment", "torment_ranks", 5],
			["oc_soul_leech", "soul_leech_step", 3],
			["oc_invigoration", "invigoration_ranks", 8],
			["oc_gluttony", "gluttony_ranks", 3],
			["oc_murderous", "murderous_ranks", 35],
			["oc_pact_flesh", "pact_flesh_ranks", 15],
			["oc_barter", "barter_step", 20],
			["oc_avatar_ruin", "avatar_ruin", 5],
			["oc_soul_glut", "soul_glut", 1]]:
		var got = _stat_of(String(row[0]), String(row[1]))
		ok(got != null and int(got) == int(row[2]),
			"%s writes %s = %d (got %s)" % [row[0], row[1], int(row[2]), got])
	# PLEASURE FROM PAIN IS FRACTIONAL, and that is why its field was renamed:
	# Runes.STAT_INT_KEYS coerces anything ending in "_ranks" to an int, which
	# would silently round 2.5 down to 2.
	var pp = _stat_of("oc_pleasure", "pleasure_pct")
	ok(pp != null and is_equal_approx(float(pp), 2.5),
		"Pleasure from Pain writes pleasure_pct = 2.5 (got %s)" % pp)
	ok(_stat_of("oc_pleasure", "pleasure_ranks") == null,
		"...and NOT pleasure_ranks, which would be coerced to an int")
	ok(not Runes.STAT_INT_KEYS.has("pleasure_pct"),
		"...and pleasure_pct is deliberately absent from STAT_INT_KEYS")
	# The three counters holding an INCREASE on a base the kit already pays are
	# named `_step` (and a FOURTH, barter_step, has the same shape and takes the
	# same treatment — reported rather than silently generalised).
	for step_field in ["deep_hex_step", "soul_leech_step", "whispers_step",
			"barter_step"]:
		ok(Runes.STAT_INT_KEYS.has(step_field),
			"%s is registered in STAT_INT_KEYS (the AA trap)" % step_field)
	ok(Runes.STAT_INT_KEYS.has("spread_ruin"),
		"spread_ruin is registered too — a rune writes it")
	# The rendered tooltip, which is what a player actually reads.
	for pair in [["oc_deep_hex", "take 5% more damage"],
			["oc_whispers", "seizes its victim 95% of the time"],
			["oc_soul_leech", "rises to 5% per stack"],
			["oc_barter", "heals every other ally 35%"],
			["oc_pact_flesh", "a cost of 5% rather than 20%"],
			["oc_pleasure", "the party heals 2.5%"],
			["oc_avatar_ruin", "every 5th stack instead of every 10th"]]:
		var txt := Talents.desc_for(_node(String(pair[0])), 1)
		ok(txt.contains(String(pair[1])),
			"%s's tooltip reads '%s' (got: %s)" % [pair[0], pair[1], txt])
	# Empowered Hex is "always" now, so it has no {v} left to render.
	ok(Talents.desc_for(_node("oc_emp_hex"), 1).contains("ALWAYS")
		and not Talents.desc_for(_node("oc_emp_hex"), 1).contains("{v}"),
		"Empowered Hex's tooltip says ALWAYS and leaves no placeholder behind")


# ---------- §5 the counters are ADDITIVE at their read sites ----------

func _additive_units() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for pair in [
			["0.01 * (2 + ruin_occ.deep_hex_step)", "Deeper Hex"],
			["0.01 * chan_r", "Corrupted Channeling"],
			["0.01 * attacker.broken_will_ranks", "Broken Will"],
			["0.01 * occ.grim_ranks", "Grim Focus"],
			["u.take_hit(0, ent_occ.entropy_ranks)", "Entropy"],
			["_gain_ruin(e, occ.unravel_ranks)", "Unraveling"],
			["0.01 * spread_r", "Spread of Madness"],
			['_gain_ruin(infected, _max_hero_rank("spread_ruin"))',
				"Spread of Madness (the Ruin it marks)"],
			["0.01 * psy_occ.whispers_step", "Whispers"],
			["0.01 * mirror_r", "Umbral Mirror"],
			["_gain_ruin(strike_target, mad_occ.delirium_ranks)", "Delirium"],
			["0.01 * mad_occ.cackling_ranks", "Cackling Mirror"],
			["var torment_turns := occ.torment_ranks", "Lingering Torment"],
			["(2 + occ_leech.soul_leech_step + occ_leech.gluttony_ranks)",
				"Soul Leech / Gluttony"],
			["0.01 * u.pleasure_pct", "Pleasure from Pain"],
			["0.01 * mi_ranks", "Murderous Intent"],
			["0.20 - 0.01 * attacker.pact_flesh_ranks", "Pact of Flesh"],
			["0.15 + 0.01 * attacker.barter_step", "Dark Barter"],
			["0.01 * attacker.invigoration_ranks", "Invigoration"],
			["0.01 * attacker.emp_hex_ranks", "Empowered Hex"]]:
		ok(bsrc.contains(String(pair[0])),
			"%s reads its counter additively (%s)" % [pair[1], pair[0]])
	# No old ranked counter may survive anywhere.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var rsrc := FileAccess.get_file_as_string("res://data/runes.json")
	for dead in ["deep_hex_ranks", "soul_leech_ranks", "whispers_ranks",
			"barter_ranks", "pleasure_ranks"]:
		ok(not bsrc.contains(dead) and not usrc.contains(dead)
			and not rsrc.contains(dead),
			"the ranked counter %s is gone from every read site" % dead)
	# Nor may an old ranked MULTIPLIER survive on a counter that kept its name.
	for dead_math in ["0.25 * occ.grim_ranks", "5 * ent_occ.entropy_ranks",
			"0.15 * spread_r", "0.10 * mirror_r", "0.25 * attacker.emp_hex_ranks",
			"0.25 * chan_r", "0.10 * mi_ranks", "0.03 * mad_occ.cackling_ranks",
			"2 * occ.torment_ranks", "0.10 * attacker.pact_flesh_ranks",
			"0.05 * attacker.broken_will_ranks", "0.02 * attacker.invigoration_ranks"]:
		ok(not bsrc.contains(dead_math),
			"no ranked multiplier survives: %s" % dead_math)
	# §1's machinery has ONE implementation each — a second threshold or a
	# second cap could disagree with the first and nothing would crash.
	ok(bsrc.count("func _ruin_threshold") == 1,
		"the detonation threshold has exactly one implementation")
	ok(bsrc.count("const RUIN_LEECH_CAP") == 1
		and bsrc.count("RUIN_LEECH_CAP)") == 1,
		"the lifesteal cap has one definition and one read site")
	ok(bsrc.contains("const RUIN_THRESHOLD := 10"),
		"the base threshold is 10")
	ok(bsrc.contains("const RUIN_LEECH_CAP := 0.40"),
		"the lifesteal cap is 40% of the damage dealt")


# ---------- §5 no named exclusive pair of his survives ----------

func _no_exclusive_pairs() -> void:
	# Batch L already retired Pact of Flesh <-> Grim Focus (a CROSS-LANE pair
	# that Batch AI's row exclusivity would have destroyed anyway). §5 asked
	# whether another survives: none does, in the data OR in CLAUDE.md's prose.
	var pf := _node("oc_pact_flesh")
	var gf := _node("oc_grim")
	ok((pf.get("exclusive_with", []) as Array).is_empty()
		and (gf.get("exclusive_with", []) as Array).is_empty(),
		"the retired Pact of Flesh <-> Grim Focus pair left nothing behind")
	ok(String(pf.get("lane", "")) != String(gf.get("lane", "")),
		"...and they are still in different lanes, so both are reachable")
	var live_pairs := 0
	for t in _tree():
		live_pairs += (t.get("exclusive_with", []) as Array).size()
	ok(live_pairs == 0, "the Occultist tree names no exclusive pair at all (%d)" % live_pairs)
	var guide := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not guide.contains("oc_pact_flesh↔") and not guide.contains("oc_grim↔"),
		"...and CLAUDE.md's prose list names none of his either")
	_report.append("exclusive pairs on the Occultist tree: 0 (data and prose)")


# ---------- §2 the boss rule is LEGIBLE, and unpatched ----------

func _boss_legibility() -> void:
	# THE MECHANIC IS UNTOUCHED. The guard still refuses all three madness
	# statuses on an unbroken boss, and `force` is still the only way past it
	# (two callers, both Batch AH perfects) — no Occultist workaround was added.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains('if not force and id in ["stunned", "frozen", "psychosis", "bewitch", "hysteria"] \\'),
		"the boss guard still refuses all three madness statuses")
	ok(bsrc.count("force := false") == 1 and bsrc.count(", true)\n") >= 0,
		"...and `force` is still a single explicit argument, not a name check")
	# THE LANE TEXT says it, where a player picking talents reads it.
	for id in ["oc_spread", "oc_whispers", "oc_mind_flay", "oc_hysteria"]:
		var txt := Talents.desc_for(_node(id), 1)
		ok(txt.contains("Broken"),
			"%s's node text states the boss rule (got: %s)" % [id, txt])
	# THE GLOSSARY says it, and NAMES BREAK AS THE KEY.
	var gsrc := FileAccess.get_file_as_string("res://data/glossary.json")
	var gloss: Array = JSON.parse_string(gsrc)
	var by_id := {}
	for e in gloss:
		by_id[String(e.get("id", ""))] = e
	for gid in ["status_psychosis", "status_bewitch", "status_hysteria"]:
		var long := String(by_id.get(gid, {}).get("long", ""))
		ok(long.contains("BROKEN") and long.contains("Break meter"),
			"the %s glossary entry names Break as the key" % gid)
	# THE ABILITY TOOLTIPS say it, where a player MEETS the ability.
	for pair in [["Mind Flay", "occultist"], ["Mass Hysteria", "occultist"]]:
		var ab := Classes.pending_talent_ability(String(pair[0]))
		ok(ab != null and ab.description.contains("BOSS RESISTS"),
			"%s's own tooltip states the boss rule" % pair[0])
	var bw: Ability = null
	for a in Classes.spec_abilities("occultist"):
		if a.display_name == "Bewitch":
			bw = a
	ok(bw != null and bw.description.contains("BOSS RESISTS UNTIL BROKEN"),
		"Bewitch's tooltip states it too")
	# AND THE RUIN ENTRY WAS REWRITTEN WHOLESALE.
	var ruin_long := String(by_id.get("status_ruin", {}).get("long", ""))
	for phrase in ["NO MAXIMUM", "NEVER CLEARS", "TENTH", "40%", "SURVIVE"]:
		ok(ruin_long.contains(phrase),
			"the Ruin glossary entry states '%s'" % phrase)


# ---------- §5 the rune audit ----------

func _rune_audit() -> void:
	var data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	# RE-POINTED, and — except for the one that could not be — each still pays
	# exactly what it paid before this batch. Only the units moved.
	var dr: Dictionary = data["deepening_ruin"]["payload"]["stat"]
	ok(int(dr.get("deep_hex_step", 0)) == 1 and int(dr.get("entropy_ranks", 0)) == 5,
		"the Deepening Ruin pays +1%/stack and 5 Break damage — exactly its old value")
	var wd: Dictionary = data["whispering_dark"]["payload"]["stat"]
	ok(int(wd.get("broken_will_ranks", 0)) == 5
		and int(wd.get("spread_ranks", 0)) == 15
		and int(wd.get("spread_ruin", 0)) == 1
		and is_equal_approx(float(wd.get("pleasure_pct", 0.0)), 0.5),
		"the Whispering Dark pays +5% BD / +15% spread / 1 Ruin / 0.5% — its old values")
	# THE ONE THAT COULD NOT PAY WHAT IT PAID, and it is reported rather than
	# hidden: AX changed the lifesteal's UNIT from a flat rate to a per-stack
	# one, so "5% more from Ruined targets" has no equivalent. It keeps the
	# RELATIONSHIP it always had — exactly one node's worth of each dial.
	var hc: Dictionary = data["hollow_chalice"]["payload"]["stat"]
	ok(int(hc.get("soul_leech_step", 0)) == int(_stat_of("oc_soul_leech", "soul_leech_step"))
		and int(hc.get("gluttony_ranks", 0)) == int(_stat_of("oc_gluttony", "gluttony_ranks")),
		"the Hollow Chalice still pays one node's worth of each dial")
	ok(String(data["hollow_chalice"]["desc"]).contains("per stack"),
		"...and its description was rewritten to the new units, not left lying")
	# EVERY RUNE-WRITTEN COUNTER STILL HAS A LIVE READ SITE — this batch retires
	# no node, so nothing may be left homeless.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for rid in ["deepening_ruin", "whispering_dark", "hollow_chalice"]:
		for field in (data[rid]["payload"].get("stat", {}) as Dictionary):
			if field == "healing_received_mult":
				continue
			ok(bsrc.contains(String(field)),
				"%s's %s has a live read site" % [rid, field])
	# THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO OCCULTIST COUNTER.
	var oc_fields := ["emp_hex_ranks", "soul_leech_step", "pleasure_pct",
		"channeling_ranks", "murderous_ranks", "invigoration_ranks",
		"spread_ranks", "spread_ruin", "mirror_ranks", "broken_will_ranks",
		"deep_hex_step", "grim_ranks", "entropy_ranks", "unravel_ranks",
		"whispers_step", "delirium_ranks", "cackling_ranks", "torment_ranks",
		"gluttony_ranks", "pact_flesh_ranks", "barter_step", "avatar_ruin",
		"soul_glut"]
	for rid in data:
		if String(data[rid].get("scope", "")) != "class:cleric":
			continue
		for field in (data[rid]["payload"].get("stat", {}) as Dictionary):
			ok(not oc_fields.has(String(field)),
				"the class-wide %s touches no Occultist counter (%s)" % [rid, field])
	# THE HOLLOW CHALICE CLAMP, CHECKED RATHER THAN TRUSTED (§5 named it).
	# healing_received_mult is a running SUM onto 1.0 and heal_amount FLOORS it
	# at zero: if the reachable worst case crossed -1.0, two runes would
	# silently become "you cannot be healed at all".
	var uni := 0.0
	var by_scope := {}
	for rid in data:
		var v = (data[rid]["payload"].get("stat", {}) as Dictionary).get(
			"healing_received_mult", null)
		if v == null or float(v) >= 0.0:
			continue
		var scope := String(data[rid].get("scope", "universal"))
		if scope == "universal":
			uni += float(v)
		else:
			by_scope[scope] = float(by_scope.get(scope, 0.0)) + float(v)
	var worst := uni
	for scope in by_scope:
		worst = minf(worst, uni + float(by_scope[scope]))
	ok(1.0 + worst > 0.0,
		"the healing clamp is not reachable: worst loadout sums to %.2f" % worst)
	_report.append("healing_received_mult worst reachable sum: %.2f (floor is -1.00); Hollow Chalice contributes %.2f" % [
		worst, float(by_scope.get("spec:occultist", 0.0))])


# ---------- §6 the bot ----------

func _bot_policy_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# (1) FOCUS RUIN. The helper exists, it is the ONLY thing the Occultist
	# branch aims, and the generic lowest-HP pick no longer reaches him.
	ok(bsrc.count("func _ruin_focus") == 1, "the focus rule has one implementation")
	ok(bsrc.contains("var oc_t := _ruin_focus(foes, target_foe)"),
		"...and the Occultist branch calls it")
	for cast in ["return [mflay, oc_t]", "return [bwitch, oc_t]",
			"return [hex, oc_t]", "return [u.abilities[0], oc_t]"]:
		ok(bsrc.contains(cast), "the bot aims %s at the focused mark" % cast)
	# (2) HOLD THE MADNESS AGAINST AN UNBROKEN BOSS — they are refused
	# outright, so casting one spends the turn on nothing.
	ok(bsrc.contains("var oc_gated: bool = oc_t.is_boss and not oc_t.broken"),
		"the bot knows when the madness casts are gated")
	ok(bsrc.count("and not oc_gated:") == 3,
		"...and all three madness casts are held behind it (Hysteria, Mind Flay, Bewitch)")
	# Hex and Shadowrend are NOT gated — they are the Break that opens the gate.
	ok(not bsrc.contains("if hex != null and u.resource >= hex.cost and u.ability_ready(hex) and not oc_gated"),
		"Hex of Ruin is never held back — grinding Break is the plan")


# ---------- §7 Fervor: the brief's premise was stale ----------

func _fervor_unmoved() -> void:
	# BATCH AX §7 asked for "Consecrated Ground pays 2 a turn rather than 3
	# with the node learned". THE GROUND ALREADY PAID 2: AW put a base drip of
	# 1 in the kit and priced Fervor as a +1 increase, so the end state the
	# brief specified was already shipped and the change is a NO-OP. Corrected
	# toward the code (the house rule), reported, and PINNED here so the
	# finding cannot rot into a silent regression.
	# BATCH BH §2 RE-POINTED THIS IN PLACE AND INVERTED IT, which is the honest
	# thing to do with it rather than deleting it. AX's finding was "the ground
	# already pays 2 with Fervor learned, so the brief's instruction is a
	# no-op". BH §2 re-specced Fervor off the drip entirely — a deeper drip is
	# a release-frequency multiplier and that is the whole subject of that
	# batch — so the ground pays 1 with the node or without it. The finding
	# AX pinned is now HISTORY; what is worth pinning at this site is that the
	# drip is Batch AW §2's base and nothing deepens it.
	var dv_tree := Talents.generate_tree("inquisitor", "cleric")
	var fervor := Talents.node_in_tree(dv_tree, "dv_fervor")
	ok(not (fervor.get("payload", {}).get("stat", {}) as Dictionary).has("fervor_step"),
		"Fervor no longer writes an increase on the drip at all (Batch BH §2)")
	ok(not Talents.desc_for(fervor, 1).contains("per ally per turn"),
		"...and its text no longer promises a deeper drip")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains("_gain_faith(u, 1, \"ground\")") and not bsrc.contains("devout.fervor_step"),
		"...the ground pays a flat 1, AW §2's base kit, un-deepened")
	_report.append("§7 was a NO-OP at AX (Fervor already paid +1). BATCH BH §2 then took "
		+ "Fervor off the drip entirely; the ground pays 1 with the node or without it.")


# ---------- the negative controls, in source ----------

func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	# (1) A DETONATION CLEARING THE STACKS. This is the whole batch, and it
	# would look exactly like a working detonation if it regressed.
	ok(not bsrc.contains('target.remove_status("ruin")\n'),
		"NEGATIVE CONTROL: nothing removes the Ruin status on detonation")
	ok(bsrc.contains('target.remove_status("ruin_primed")'),
		"...only the PRIMER is consumed")
	# (2) THE LIFESTEAL UNCAPPED. Per-stack against uncapped stacks would let
	# the party heal more than it deals — with no error anywhere.
	ok(bsrc.contains("RUIN_LEECH_CAP)"),
		"NEGATIVE CONTROL: the lifesteal passes through minf() with the cap")
	ok(not bsrc.contains("var leech_pct := 0.10 +"),
		"...and the old flat 10%-while-any-Ruin rate is gone")
	# (3) RUIN ARMING ON ANY STACK. A `>=` here would arm on every stack past
	# the first threshold and the bomb would fire every turn.
	ok(bsrc.contains("st % step == 0"),
		"NEGATIVE CONTROL: the arming test is a MULTIPLE of the threshold")
	ok(not bsrc.contains('target.status_stacks("ruin") >= 5'),
		"...not a >= against the old fixed 5")
	ok(bsrc.contains("if st > 0 and st % step == 0"),
		"...and a REFUSED stack (0 % step == 0) cannot arm it either")
	# (4) THE CAP ON THE STACKS THEMSELVES. mini() in unit.add_status would
	# quietly hold Ruin at 5 forever and every other check here would pass.
	ok(not usrc.contains('s.stacks = mini(int(s.get("stacks", 1)) + 1, 5)'),
		"NEGATIVE CONTROL: unit.add_status no longer caps Ruin at 5")
	ok(usrc.contains('elif id == "ruin":'),
		"...but the Ruin branch is still there to stack it")


# ---------- live: §1 the threshold is every TENTH stack ----------

func _live_thresholds() -> void:
	var scene := await _spawn({})
	var occ := _hero(scene, 2)
	var foe := _foe(scene, 0)
	ok(occ != null and occ.passive_id == "old_gods", "slot 2 is the Occultist")
	ok(scene._ruin_threshold() == 10, "the threshold is 10 with no capstone")
	# Nine stacks is nothing at all — the old design would have blown twice by
	# now, which is exactly §1's stated cost.
	scene._gain_ruin(foe, 9)
	ok(foe.status_stacks("ruin") == 9, "nine stacks land (got %d)" % foe.status_stacks("ruin"))
	ok(not foe.has_status("ruin_primed"), "...and nine does not arm the mark")
	# THE TENTH ARMS IT.
	scene._gain_ruin(foe, 1)
	ok(foe.status_stacks("ruin") == 10, "the tenth stack lands")
	ok(foe.has_status("ruin_primed"), "...and IT arms the mark")
	# AND A STACK LANDING ON 11 DOES NOT RE-ARM (§9 names this one).
	scene._detonate_ruin(foe)
	ok(not foe.has_status("ruin_primed"), "the detonation consumed the primer")
	scene._gain_ruin(foe, 1)
	ok(foe.status_stacks("ruin") == 11, "an eleventh stack lands (got %d)" % foe.status_stacks("ruin"))
	ok(not foe.has_status("ruin_primed"),
		"NEGATIVE CONTROL LIVE: the eleventh stack does NOT re-arm the mark")
	await _kill(scene)


# ---------- live: §1 the stacks survive 10, 20 and 30 ----------

func _live_stacks_survive() -> void:
	var scene := await _spawn({})
	var foe := _foe(scene, 0)
	# A pool big enough that three detonations cannot kill him — this test is
	# about the stacks, not about lethality.
	foe.max_hp = 100000
	foe.hp = 100000
	var seen := PackedInt32Array()
	for i in 30:
		scene._gain_ruin(foe, 1)
		if foe.has_status("ruin_primed"):
			seen.append(foe.status_stacks("ruin"))
			var before := foe.status_stacks("ruin")
			scene._detonate_ruin(foe)
			ok(foe.status_stacks("ruin") == before,
				"the mark survives its detonation at %d stacks (got %d)" % [
					before, foe.status_stacks("ruin")])
	ok(Array(seen) == [10, 20, 30],
		"Ruin detonates at 10, 20 and 30 and nowhere else (got %s)" % str(Array(seen)))
	ok(foe.status_stacks("ruin") == 30,
		"...and thirty stacks are still standing at the end (got %d)" % foe.status_stacks("ruin"))
	await _kill(scene)


# ---------- live: §1 the detonation is bigger ----------

func _live_detonation_payload() -> void:
	var scene := await _spawn({})
	var occ := _hero(scene, 2)
	var ally := _hero(scene, 0)
	var foe := _foe(scene, 0)
	foe.max_hp = 100000
	foe.hp = 100000
	foe.resists = {}
	ally.healing_received_mult = 1.0
	ally.hp = 1
	occ.attack = 100
	scene._gain_ruin(foe, 10)
	ok(foe.has_status("ruin_primed"), "the mark is primed at ten")
	var hp_before := foe.hp
	scene._detonate_ruin(foe)
	var dealt := hp_before - foe.hp
	# 90% of Attack with the engine's own +-10% roll on top.
	ok(dealt >= 81 and dealt <= 99,
		"the detonation deals 90%% of Attack +-10%% (got %d off a 100 Attack)" % dealt)
	# 25% of the Occultist's max health, to every ally.
	ok(ally.hp - 1 == maxi(int(round(occ.max_hp * 0.25)), 1),
		"the party feasts for 25%% of his max health (got %d, expected %d)" % [
			ally.hp - 1, maxi(int(round(occ.max_hp * 0.25)), 1)])
	await _kill(scene)


# ---------- live: §3 Avatar of Ruin moves the threshold to 5 ----------

func _live_avatar_of_ruin() -> void:
	var scene := await _spawn({"oc_avatar_ruin": 1})
	var occ := _hero(scene, 2)
	var foe := _foe(scene, 0)
	foe.max_hp = 100000
	foe.hp = 100000
	ok(occ.avatar_ruin == 5, "Avatar of Ruin stamps the threshold it installs (got %d)" % occ.avatar_ruin)
	ok(scene._ruin_threshold() == 5, "...and the threshold really is 5")
	var seen := PackedInt32Array()
	for i in 15:
		scene._gain_ruin(foe, 1)
		if foe.has_status("ruin_primed"):
			seen.append(foe.status_stacks("ruin"))
			scene._detonate_ruin(foe)
	ok(Array(seen) == [5, 10, 15],
		"with the capstone it detonates at 5, 10 and 15 (got %s)" % str(Array(seen)))
	ok(foe.status_stacks("ruin") == 15,
		"...and the stacks still survive (got %d)" % foe.status_stacks("ruin"))
	await _kill(scene)


# ---------- live: §1 the lifesteal is PER STACK ----------

func _live_lifesteal_per_stack() -> void:
	# The base rate, no talents: 2% of the damage dealt per stack.
	var scene := await _spawn({})
	var hero := _hero(scene, 0)      # the Berserker — no Holy Conduit on him
	var foe := _foe(scene, 0)
	hero.healing_received_mult = 1.0
	foe.max_hp = 100000
	foe.hp = 100000
	foe.armor = 0.0
	foe.resists = {}
	scene._gain_ruin(foe, 5)
	hero.hp = 1
	var foe_before := foe.hp
	await scene._resolve(hero, hero.abilities[0], foe, "good")
	var dealt := foe_before - foe.hp
	var healed := hero.hp - 1
	ok(dealt > 0, "the strike landed (%d damage)" % dealt)
	# 2% x 5 stacks = 10% of the damage dealt.
	ok(healed == maxi(int(round(dealt * 0.10)), 1),
		"five stacks drink 10%% of %d = %d (got %d)" % [dealt,
			maxi(int(round(dealt * 0.10)), 1), healed])
	await _kill(scene)


# ---------- live: §1 the lifesteal REFUSES to exceed 40% ----------

func _live_lifesteal_cap() -> void:
	# Soul Leech, Gluttony AND Soul Glut all learned — 2+3+3 = 8% a stack, so
	# the cap bites at five stacks and everything past it is refused.
	var scene := await _spawn({"oc_soul_leech": 1, "oc_gluttony": 1,
		"oc_soul_glut": 1})
	var occ := _hero(scene, 2)
	var hero := _hero(scene, 0)
	var mage := _hero(scene, 1)
	var foe := _foe(scene, 0)
	ok(occ.soul_leech_step == 3 and occ.gluttony_ranks == 3 and occ.soul_glut > 0,
		"all three Leech picks are stamped")
	hero.healing_received_mult = 1.0
	mage.healing_received_mult = 1.0
	foe.max_hp = 100000
	foe.hp = 100000
	foe.armor = 0.0
	foe.resists = {}
	# FIFTY stacks: an uncapped rate would be 400% of the damage dealt.
	scene._gain_ruin(foe, 50)
	ok(foe.status_stacks("ruin") == 50,
		"fifty stacks stand on one target (got %d)" % foe.status_stacks("ruin"))
	hero.hp = 1
	mage.hp = 1
	var foe_before := foe.hp
	await scene._resolve(hero, hero.abilities[0], foe, "good")
	var dealt := foe_before - foe.hp
	var healed := hero.hp - 1
	var capped := maxi(int(round(dealt * 0.40)), 1)
	ok(healed == capped,
		"fifty stacks still drink only 40%% of %d = %d (got %d)" % [dealt, capped, healed])
	ok(healed < dealt,
		"NEGATIVE CONTROL LIVE: the party cannot heal more than it deals (%d vs %d)" % [
			healed, dealt])
	# Soul Glut spreads the SAME capped draught, not a fresh uncapped one.
	ok(mage.hp - 1 == capped,
		"Soul Glut feeds the party the same capped amount (got %d, expected %d)" % [
			mage.hp - 1, capped])
	await _kill(scene)


# ---------- live: §1 the AMPLIFICATION is deliberately uncapped ----------

func _live_amplification() -> void:
	var scene := await _spawn({"oc_deep_hex": 1})
	var occ := _hero(scene, 2)
	var hero := _hero(scene, 0)
	var foe := _foe(scene, 0)
	ok(occ.deep_hex_step == 3, "Deeper Hex is stamped as the +3 increase")
	foe.max_hp = 1000000
	foe.hp = 1000000
	foe.armor = 0.0
	foe.resists = {}
	# SUM ~10 casts a side: even with crit off, a single pair sits inside a
	# +-22% envelope and would pass a wrong curve (the AT lesson).
	var clean := 0
	for i in 10:
		var before := foe.hp
		await scene._resolve(hero, hero.abilities[0], foe, "good")
		clean += before - foe.hp
	scene._gain_ruin(foe, 20)
	var marked := 0
	for i in 10:
		var before2 := foe.hp
		await scene._resolve(hero, hero.abilities[0], foe, "good")
		marked += before2 - foe.hp
	# 20 stacks x 5% = +100% damage taken. No ceiling anywhere in the path.
	var ratio := float(marked) / maxf(float(clean), 1.0)
	ok(ratio > 1.80 and ratio < 2.20,
		"twenty stacks under Deeper Hex is +100%% damage taken (ratio %.2f)" % ratio)
	_report.append("Deeper Hex at 20 stacks measured x%.2f damage taken (uncapped by design)" % ratio)
	await _kill(scene)


# ---------- live: §4 both authored fallbacks ----------

func _live_fallbacks() -> void:
	# The node GRANTS when the ability was not already in hand.
	var granted := await _spawn({"oc_mind_flay": 1, "oc_hysteria": 1})
	var occ := _hero(granted, 2)
	var mf := _find(occ, "Mind Flay")
	var mh := _find(occ, "Mass Hysteria")
	ok(mf != null and mh != null, "the row-3 node and the capstone grant their abilities")
	ok(mf != null and mf.choose_two and not mf.choose_three,
		"...and Mind Flay still takes TWO minds, because nothing collided")
	ok(mh != null and mh.cooldown == 4, "...and Mass Hysteria keeps its 4 cooldown")
	await _kill(granted)
	# EARNED FIRST, then the node: it upgrades instead of granting. Earned picks
	# go on BEFORE the tree at both kit-assembly sites (the AH ordering fix),
	# which is what makes cfg["abilities"] the honest question.
	var owned := await _spawn({"oc_mind_flay": 1, "oc_hysteria": 1},
		{"bm_abilities": ["Mind Flay", "Mass Hysteria"]})
	var occ2 := _hero(owned, 2)
	var mf2 := _find(occ2, "Mind Flay")
	var mh2 := _find(occ2, "Mass Hysteria")
	ok(mf2 != null and mh2 != null, "the earned abilities are in the kit")
	ok(mf2 != null and mf2.choose_three and not mf2.choose_two,
		"MIND FLAY ALREADY OWNED -> it strikes THREE minions instead of two")
	ok(mf2 != null and mf2.description.contains("THREE"),
		"...and its tooltip says so")
	ok(mh2 != null and mh2.cooldown == 2,
		"MASS HYSTERIA ALREADY OWNED -> its cooldown drops 4 -> 2 (got %d)" % (
			mh2.cooldown if mh2 != null else -1))
	# The kit holds ONE of each — an upgrade must never double-grant.
	var n_flay := 0
	for a in occ2.abilities:
		if a.display_name == "Mind Flay":
			n_flay += 1
	ok(n_flay == 1, "...and neither node double-granted (%d Mind Flays)" % n_flay)
	await _kill(owned)
	# NEITHER NODE OWES A GENERIC ANY MORE — the Cleric class is done.
	for id in ["oc_mind_flay", "oc_hysteria"]:
		ok(Talents.collision_kind(_payload(id)) == "authored",
			"%s carries an AUTHORED fallback" % id)


# ---------- live: §7 the ground still pays 2 a turn with Fervor ----------

func _live_fervor() -> void:
	# §7 asked for this number and it was already the shipped one. Driven, not
	# grepped, so the report's claim is a measurement.
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {"dv_fervor": 1} if i == 2 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": ["raider"]}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	var dv := _hero(scene, 2)
	var ally := _hero(scene, 0)
	ok(dv != null and dv.fervor == 1, "Fervor is stamped as a gate on the HELD half")
	ally.faith_stacks = 0
	scene._apply_status(ally, "cons_ground", 3)
	scene._ground_faith_tick(ally)
	ok(ally.faith_stacks == 1,
		"Consecrated Ground pays 1 a turn WITH the node learned too (got %d)" % ally.faith_stacks)
	await _kill(scene)
