# test_batch_aw.gd — THE DEVOUT: INVESTMENT. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_aw.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 CONVICTION'S THIRD CLAUSE. The growth is 3% of BASE and never of
#      current (linear, not 1.03^N), it HEALS him for the amount it grants,
#      and — the important one — MAX_HP RETURNS TO ITS PRE-BATTLE VALUE on the
#      party member after a victory, with hp clamped under it. Tenacity's own
#      battle-long gain is handled in the same sync and is asserted alongside.
#   §2 CONSECRATED GROUND IS A FAITH SOURCE IN THE BASE KIT — the drip lands
#      with FERVOR UNLEARNED, and the node deepens it 1 -> 2.
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, every final magnitude on the
#      node that owes it, and every counter ADDITIVE at its read site.
#   §4 THE STALWART <-> BASTION PAIR IS DISSOLVED: rows 5 and 6, both legal.
#   §5 BOTH AUTHORED FALLBACKS (Sacred Resolve -> 5 turns, Bulwark of
#      Fortitude -> 4 turns), and Bulwark is the first CLERIC capstone
#      that grants an ability (the brief said "in the game" — corrected).
#   §6 THE RUNE AUDIT: every re-pointed counter lands on a live read site and
#      pays its advertised number; the three cleric class-wide runes touch no
#      Devout counter.
#   §7 THE BOT: the ground goes up whenever it is off cooldown, the shield
#      aims at whoever is drawing fire, the blessing still finds a shield.
#   §9 THE HOLY RENAME leaves holy_vigil_pct and its read site untouched.
#   NEGATIVE CONTROLS for the three that would fail silently: the growth
#      reading current instead of base, the victory sync leaving the growth on
#      the party member, and Fervor still being required for the drip.
# BATCH BM RE-POINTED THIS FILE IN PLACE, mechanically and in two ways only:
# the capstone SHELF moved from row 8 to row 9 (rows 1-8 are lane rows now),
# and the tree gained a ROW-8 NODE PER LANE, so 24 became 27. Every magnitude,
# every id and every question this file asks is otherwise untouched — the
# tables below are the batch's own record of its 24 nodes and stay that.
extends SceneTree

# BATCH DD — THE ONE AUTHORED BATTLE FIXTURE FOR THE SUITES. `_spawn` stood in
# 37 suites as 36 bodies and `_kill` in 14 as one; both are authored once now.
# This suite keeps its own SIGNATURE and delegates, so not one call site moved.
const Fixture = preload("res://suite_fixture.gd")

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
	Profile.save_path = "user://profile_batch_aw_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_magnitudes()
	_additive_units()
	_dissolved_pair()
	_authored_fallbacks()
	_rune_audit()
	_bot_policy_source()
	_holy_rename()
	_negative_control_source()

	await _live_growth()
	await _live_growth_heals()
	await _live_apostle_stream()
	await _live_victory_sync()
	await _live_ground_drip()
	await _live_fallbacks()
	await _live_bastion_and_stalwart()

	if FileAccess.file_exists("user://profile_batch_aw_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_aw_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_aw: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("inquisitor", "cleric")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


# A cfg field the hero spawn block reads (as opposed to a BattleUnit property
# that setup() pushes straight into). set() SILENTLY DROPS an unknown name, so
# "something actually reads it" is the honest question either way.
func _cfg_consumed(field: String) -> bool:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	return bsrc.contains(field)


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


# The party is warrior/mage/cleric/hunter, so the Devout is slot 2.
func _spawn(learned: Dictionary, member_patch := {},
		lineup := ["raider"]) -> Node:
	# A crit is the worst coin to leave live on a spec measured in healing.
	return await Fixture.spawn(self,
		["berserker", "pyromancer", "inquisitor", "beastmaster"],
		{"enemies": lineup, "talents": {2: learned.duplicate()}, "patch": {2: member_patch},
		"deterministic": true, "crit": -10.0})


func _kill(scene: Node) -> void:
	await Fixture.kill(self, scene)


# ---------- §3 the tree's shape ----------

const IDS := ["dv_barrier", "dv_aegis", "dv_afterglow", "dv_warded",
	"dv_stalwart", "dv_bastion", "dv_unyielding",
	"dv_communion", "dv_unwavering", "dv_devoutness", "dv_faithful",
	"dv_covenant", "dv_fervor", "dv_oath",
	"dv_waters", "dv_righteous", "dv_resolve", "dv_pulse", "dv_crusade",
	"dv_purity", "dv_lifewell",
	"dv_bulwark", "dv_apostle", "dv_judgement"]


func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 27, "the Devout tree holds 24 nodes (got %d)" % tree.size())
	# EVERY ID SURVIVES AND RE-SPECS IN PLACE — no new ids, none deleted, so
	# saved picks migrate and no save version moves.
	var seen := {}
	for t in tree:
		seen[String(t.get("id", ""))] = true
	for id in IDS:
		ok(seen.has(id), "the id %s survives" % id)
	ok(seen.size() == 27, "...and no id was added (got %d distinct)" % seen.size())
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
			ok(row >= 1 and row <= Talents.CAPSTONE_ROW,
				"%s sits on a real row (got %d)" % [t.get("id", ""), row])
			per_lane[lane] = per_lane.get(lane, 0) + 1
	ok(caps == 3, "exactly three capstones (got %d)" % caps)
	ok(cap_lanes.size() == 3, "the three capstones sit on three different lanes")
	for lane in ["Bulwark", "Faith", "Zeal"]:
		ok(per_lane.get(lane, 0) == Talents.ROWS,
			"lane %s holds 8 row nodes (got %d)" % [lane, per_lane.get(lane, 0)])
	# Every row of every lane is filled exactly once — the row IS the choice.
	var slots := {}
	for t in tree:
		var key := "%s/%d" % [t.get("lane", ""), t.get("row", 0)]
		ok(not slots.has(key), "no two nodes share the slot %s" % key)
		slots[key] = true
	# Any exclusive reference must name a node that exists (the shape audit
	# test_batch_ai does generically, repeated here because AW moves lanes'
	# contents around).
	for t in tree:
		for ex in t.get("exclusive_with", []):
			ok(seen.has(String(ex)),
				"%s's exclusive reference %s names a live node" % [t.get("id", ""), ex])
	# The lane NAMES stay; only two theses were re-aimed.
	for pair in [["dv_barrier", "Bulwark", 1], ["dv_aegis", "Bulwark", 2],
			["dv_afterglow", "Bulwark", 3], ["dv_warded", "Bulwark", 4],
			["dv_stalwart", "Bulwark", 5], ["dv_bastion", "Bulwark", 6],
			["dv_unyielding", "Bulwark", 7],
			["dv_communion", "Faith", 1], ["dv_unwavering", "Faith", 2],
			["dv_devoutness", "Faith", 3], ["dv_faithful", "Faith", 4],
			["dv_covenant", "Faith", 5], ["dv_fervor", "Faith", 6],
			["dv_oath", "Faith", 7],
			["dv_waters", "Zeal", 1], ["dv_righteous", "Zeal", 2],
			["dv_resolve", "Zeal", 3], ["dv_pulse", "Zeal", 4],
			["dv_crusade", "Zeal", 5], ["dv_purity", "Zeal", 6],
			["dv_lifewell", "Zeal", 7]]:
		var n := _node(String(pair[0]))
		ok(String(n.get("lane", "")) == String(pair[1])
			and int(n.get("row", 0)) == int(pair[2]),
			"%s sits at %s row %d (got %s row %s)" % [pair[0], pair[1], pair[2],
				n.get("lane", ""), n.get("row", 0)])
	# The names, by name rather than by id — a re-spec that forgot its label
	# would pass every structural check above.
	for pair in [["dv_barrier", "Blessed Barrier"], ["dv_aegis", "Radient Aegis"],
			["dv_afterglow", "Afterglow"], ["dv_warded", "Warded Robes"],
			["dv_stalwart", "Stalwart"], ["dv_bastion", "Bastion"],
			["dv_unyielding", "Unyielding Aegis"], ["dv_communion", "Communion"],
			["dv_unwavering", "Unwavering Faith"], ["dv_devoutness", "Devoutness"],
			["dv_faithful", "Blessed are the Faithful"],
			["dv_covenant", "Sacred Covenant"], ["dv_fervor", "Fervor"],
			["dv_oath", "Binding Oath"], ["dv_waters", "Cleansing Waters"],
			["dv_righteous", "Righteous Fire"], ["dv_resolve", "Sacred Resolve"],
			["dv_pulse", "Healing Pulse"], ["dv_crusade", "Crusader's Tempo"],
			["dv_purity", "Purity"], ["dv_lifewell", "Lifewell"],
			["dv_bulwark", "Bulwark of Fortitude"], ["dv_apostle", "Apostle"],
			["dv_judgement", "Judgement"]]:
		ok(String(_node(String(pair[0])).get("name", "")) == String(pair[1]),
			"%s is named %s" % [pair[0], pair[1]])


# ---------- §3 the magnitudes, which are final ----------

func _magnitudes() -> void:
	for probe in [
			["dv_barrier", "blessed_barrier_ranks", 20],
			["dv_aegis", "aegis_ranks", 60],
			["dv_afterglow", "afterglow_ranks", 20],
			["dv_warded", "warded_ranks", 25],
			["dv_stalwart", "stalwart_step", 20],       # 35 + 20 = 55% (CV §2.1)
			["dv_unyielding", "unyielding_ranks", 90],
			# RE-POINTED IN PLACE BY BATCH BE, with the reason in the file: AW
			# priced this at 40 and BC's leave-one-out grid then measured the
			# node carrying the whole FAITH row (80% contribution against 47%
			# withheld). At 40 an ally at three or more stacks advanced with
			# CERTAINTY; 15 is the first value at which nothing is guaranteed.
			# The counter's meaning and units are untouched — see test_batch_be
			# for the three measured rates the number buys.
			["dv_communion", "communion_ranks", 15],
			["dv_devoutness", "devoutness_ranks", 20],
			["dv_faithful", "faithful_step", 20],       # 15 + 20 = 35%
			["dv_covenant", "covenant_heal", 25],
			["dv_covenant", "covenant_faith", 2],
			# BATCH BH §2 RE-POINTED BOTH OF THESE IN PLACE. Fervor and Binding
			# Oath were re-specced off the release-frequency axis, so neither
			# counter exists any more: `fervor_step` (the +1 on the ground's
			# drip) and `oath_ranks` (the remnant a release left standing) were
			# DELETED WITH THEIR READ SITES, not renamed. The question AW is
			# asking here — "every node writes its own magnitude in the units
			# its read site sums" — is asked of the replacements instead.
			["dv_fervor", "fervor", 1],                 # a GATE, like apostle
			["dv_oath", "oath_faith", 1],               # Faith HE gains per ally release
			["dv_waters", "waters_ranks", 50],
			["dv_righteous", "righteous_step", 25],     # 10 + 25 = 35%
			["dv_pulse", "pulse_ranks", 8],
			["dv_crusade", "crusade_ranks", 3],
			["dv_purity", "purity_ranks", 35],
			["dv_lifewell", "lifewell_ranks", 80],
			["dv_apostle", "apostle", 1],
			["dv_judgement", "judgement", 40]]:
		var got = _stat_of(String(probe[0]), String(probe[1]))
		ok(got != null and int(got) == int(probe[2]),
			"%s writes %s = %s (got %s)" % [probe[0], probe[1], probe[2], got])
	# Unwavering Faith rides the generic max-HP stat, so it is a float.
	var unw = _stat_of("dv_unwavering", "max_hp_pct")
	ok(unw != null and abs(float(unw) - 0.20) < 0.0001,
		"Unwavering Faith raises his maximum 20%% (got %s)" % unw)
	# BASTION GOES TO ZERO — a SET, not the old -1 add. The distinction is the
	# node: "a shield every turn" is what makes it a Faith engine.
	var bas := _payload("dv_bastion")
	ok(String(bas.get("ability", "")) == "Divine Shield"
		and bas.has("set") and int(bas["set"].get("cooldown", -1)) == 0,
		"Bastion SETS Divine Shield's cooldown to 0 (got %s)" % str(bas))
	ok(not bas.has("add"),
		"...and no longer merely subtracts a turn (%s)" % str(bas.get("add", {})))
	# The tooltips render the DESIGN value, and for most of this tree that is
	# the only place the number appears outside a battle.gd read site.
	# BATCH BH §2: `dv_fervor` left this list because it no longer HAS a
	# rendered total — like Apostle it is a gate whose two magnitudes are
	# battle.gd constants, so its tooltip states them outright and
	# test_batch_bh asserts them there.
	for pair in [["dv_stalwart", "55"], ["dv_faithful", "35"],
			["dv_righteous", "35"]]:
		var n := _node(String(pair[0]))
		var shown := Talents.desc_for(n, 1)
		ok(shown.contains(String(pair[1])),
			"%s's tooltip renders its total %s (got %s)" % [pair[0], pair[1], shown])


# ---------- §6 additive, not ranked ----------

# Every counter must hold its OWN magnitude in the units its read site sums.
# Asserted against the SOURCE, because a read site that still multiplies by a
# rank pays a node's 20 as 400 and nothing crashes.
func _additive_units() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for pair in [
			["0.01 * devout.blessed_barrier_ranks", "Blessed Barrier"],
			["0.01 * attacker.aegis_ranks", "Radient Aegis"],
			["0.01 * devout.afterglow_ranks", "Afterglow"],
			["0.01 * devout.warded_ranks", "Warded Robes"],
			["0.01 * attacker.stalwart_step", "Stalwart"],
			["0.01 * devout.unyielding_ranks", "Unyielding Aegis"],
			["0.01 * devout.communion_ranks", "Communion"],
			["0.01 * devout.faithful_step", "Blessed are the Faithful"],
			["0.01 * devout.covenant_heal", "Sacred Covenant"],
			# BATCH BH §2: Fervor is a gate on the multiplier now, not an
			# addend on the drip. Its read site is `_faith_stack_mult`.
			["devout.fervor > 0", "Fervor"],
			["devout.oath_faith > 0", "Binding Oath"],
			["0.01 * zl_dv.waters_ranks", "Cleansing Waters"],
			["0.01 * cg_dv.righteous_step", "Righteous Fire"],
			["0.01 * zl_dv.pulse_ranks", "Healing Pulse"],
			["1 + attacker.crusade_ranks", "Crusader's Tempo"],
			["0.01 * attacker.purity_ranks", "Purity"],
			["0.01 * cg_dv.lifewell_ranks", "Lifewell"],
			["0.01 * cg_dv.judgement", "Judgement"]]:
		ok(bsrc.contains(String(pair[0])),
			"%s reads its counter additively (%s)" % [pair[1], pair[0]])
	# No old ranked counter may survive anywhere.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var rsrc := FileAccess.get_file_as_string("res://data/runes.json")
	# BATCH BH §2 ADDED `fervor_step` AND `oath_ranks` to this sweep: both were
	# live AW counters and both are deleted now, so the same rule that keeps an
	# old ranked name from surviving keeps these from surviving either.
	for dead in ["stalwart_ranks", "righteous_ranks", "faithful_ranks",
			"fervor_ranks", "covenant_ranks", "fervor_step", "oath_ranks"]:
		# BATCH BH §2 SHARPENED THE PREDICATE, and it is a sharpening rather
		# than a weakening: the question is "can anything READ OR WRITE this
		# counter", and a bare `contains` also trips on a COMMENT naming the
		# field — which is exactly how this project records that a field was
		# deleted deliberately (the BA `plague_bearer` precedent asks a later
		# batch not to re-add one, and it can only ask by naming it). So the
		# three greps now look for a read (`.name`), a declaration (`var name`)
		# and a rune key (`"name"`) rather than for the string anywhere.
		ok(not bsrc.contains("." + dead) and not usrc.contains("var " + dead)
			and not rsrc.contains('"%s"' % dead),
			"the ranked counter %s has no read site, no declaration and no rune key" % dead)
	# Nor may an old ranked MULTIPLIER survive on a counter that kept its name.
	for dead_math in ["0.04 * devout.blessed_barrier_ranks",
			"0.15 * attacker.aegis_ranks", "0.05 * devout.afterglow_ranks",
			"0.10 * devout.warded_ranks", "0.30 * devout.unyielding_ranks",
			"0.20 * devout.communion_ranks", "0.15 * zl_dv.waters_ranks",
			"0.02 * zl_dv.pulse_ranks", "0.10 * attacker.purity_ranks",
			"0.20 * cg_dv.lifewell_ranks", "5 * dvn_ranks"]:
		ok(not bsrc.contains(dead_math),
			"no ranked multiplier survives: %s" % dead_math)
	# THE GROWTH HAS EXACTLY ONE IMPLEMENTATION — a second one could disagree
	# about the base, which is the whole load-bearing part of §1.
	ok(bsrc.count("func _conviction_growth") == 1
		and bsrc.count("_conviction_growth(") == 2,
		"Conviction's growth has one definition and one caller")
	ok(bsrc.count("conviction_hp_gained +=") == 1,
		"...and exactly one place accumulates the leak guard")


# ---------- §4 the dissolved pair ----------

func _dissolved_pair() -> void:
	# Batch K authored Stalwart <-> Bastion as an in-lane fork — a bigger
	# shield, or a more frequent one. BATCH AI'S ROW EXCLUSIVITY DESTROYED
	# THAT FORK: they sit in rows 5 and 6 of one lane, so a player holds both.
	var st := _node("dv_stalwart")
	var ba := _node("dv_bastion")
	ok(int(st.get("row", 0)) == 5 and int(ba.get("row", 0)) == 6,
		"Stalwart and Bastion sit in DIFFERENT rows (5 and 6)")
	ok(String(st.get("lane", "")) == String(ba.get("lane", "")),
		"...of the same lane, so both are reachable on one build")
	ok(not (st.get("exclusive_with", []) as Array).has("dv_bastion")
		and not (ba.get("exclusive_with", []) as Array).has("dv_stalwart"),
		"neither node still names the other as exclusive")
	# The prose list in CLAUDE.md is the last place the pair survived, and it
	# has to stop claiming it (test_runes._exclusives has been a bare `pass`
	# since Batch AI, so nothing else was watching).
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(claude.contains("stalwart/bastion DISSOLVED IN BATCH AW"),
		"CLAUDE.md's exclusive list records the pair as DISSOLVED, not live")
	var live_list := claude.substr(claude.find("no rune may write"), 120)
	ok(not live_list.contains("stalwart/bastion"),
		"...and it is out of the LIVE half of that list")


# ---------- §5 the two authored fallbacks ----------

func _authored_fallbacks() -> void:
	var res := _payload("dv_resolve")
	ok(Talents.granted_name(res) == "Sacred Resolve",
		"the Zeal row-3 node grants Sacred Resolve")
	ok(Talents.collision_kind(res) == "authored",
		"...and carries an AUTHORED fallback, not the generic")
	var res_up: Array = res.get("upgrade", [])
	ok(res_up.size() == 1
		and int(res_up[0].get("stat", {}).get("resolve_extra_turns", 0)) == 2,
		"...already owned -> its split lasts 5 turns instead of 3")
	var bul := _payload("dv_bulwark")
	ok(Talents.granted_name(bul) == "Bulwark of Fortitude",
		"the Bulwark capstone grants Bulwark of Fortitude")
	ok(Talents.collision_kind(bul) == "authored",
		"...and carries an AUTHORED fallback")
	var bul_up: Array = bul.get("upgrade", [])
	ok(bul_up.size() == 1
		and int(bul_up[0].get("stat", {}).get("bulwark_extra_turns", 0)) == 1,
		"...already owned -> its effect lasts 4 turns instead of 3")
	# CORRECTION TO THE BATCH BRIEF, reported rather than glossed: §5 calls this
	# "the first capstone in the game that grants an ability and therefore needs
	# a fallback at all". IT IS NOT — NINE capstones grant one (the list is
	# reported below), and eight of them predate this batch. What is true is
	# the half the brief gives as its reason: Holy's three granted none, so
	# dv_bulwark is the first CLERIC capstone to owe a fallback. Asserted
	# across every tree, which is how the miscount surfaced.
	# NOTE Classes.SPEC_IDS is keyed by CLASS, not by spec — Talents.LANE_TREES
	# is the one place that holds every tree by spec id.
	var granting_caps: Array = []
	for spec in Talents.LANE_TREES:
		for t in Talents.LANE_TREES[spec]:
			if int(t.get("row", 0)) != Talents.CAPSTONE_ROW:
				continue
			if Talents.granted_name(t.get("payload", {})) != "":
				granting_caps.append(String(t.get("id", "")))
	ok(granting_caps.has("dv_bulwark"),
		"dv_bulwark is an ability-granting capstone")
	_report.append("ability-granting capstones in the game: %s" % str(granting_caps))
	# The other two Devout capstones grant nothing, so they owe nothing.
	for cap in ["dv_apostle", "dv_judgement"]:
		ok(Talents.granted_name(_payload(cap)) == "",
			"%s grants no ability, so it owes no fallback" % cap)


# ---------- §6 the rune audit ----------

func _rune_audit() -> void:
	var probe := BattleUnit.new()
	var spec_runes := ["warded_robes", "binding_oath", "burning_censer",
		"standing_vow"]
	for id in spec_runes:
		var cfg: Dictionary = Runes.config(id)
		ok(String(cfg.get("scope", "")) == "spec:inquisitor",
			"%s is a Devout spec rune" % id)
		for field in Runes.build(id)["payload"].get("stat", {}):
			var f := String(field)
			# A live field is either a BattleUnit property or a cfg field the
			# spawn block consumes — max_hp_pct is the latter, which is why
			# `f in probe` alone is not the whole question.
			ok(f in probe or _cfg_consumed(f),
				"%s writes a LIVE field: %s" % [id, f])
			# JSON parses every number as a float and BattleUnit.setup() pushes
			# cfg straight into typed vars — the Batch AA trap. Every one of
			# these is an int except the max-HP scar.
			var v = Runes.build(id)["payload"]["stat"][f]
			ok(typeof(v) == TYPE_INT or f == "max_hp_pct",
				"%s: %s survived typing as an int (got %s)" % [id, f, typeof(v)])
	probe.free()
	# THE RE-POINTS, BY THEIR ADVERTISED NUMBERS. Every one of the four pays
	# exactly what it paid before AW and exactly what its text says — the units
	# moved, not the magnitudes.
	var wr: Dictionary = Runes.build("warded_robes")["payload"]["stat"]
	ok(int(wr.get("blessed_barrier_ranks", 0)) == 4
		and int(wr.get("warded_ranks", 0)) == 10,
		"the Warded Robes pays its advertised 4%% absorb-heal and +10%% armor (got %s)" % str(wr))
	var bo: Dictionary = Runes.build("binding_oath")["payload"]["stat"]
	# BATCH BH §2 RE-POINTED THE FIRST CLAUSE IN PLACE. The node stopped
	# leaving a remnant, so "a release leaves 1 stack standing" had no
	# equivalent value; the rune keeps the RELATIONSHIP (Faith that persists)
	# through the Devout's own meter instead. Its SECOND clause is byte-
	# untouched, which is what this check is really guarding.
	ok(int(bo.get("oath_opening", 0)) == 1 and int(bo.get("faithful_step", 0)) == 5,
		"the Binding Oath opens with 1 Faith of his own and heals 5%% more (got %s)" % str(bo))
	var bc: Dictionary = Runes.build("burning_censer")["payload"]["stat"]
	ok(int(bc.get("righteous_step", 0)) == 10
		and int(bc.get("lifewell_ranks", 0)) == 20,
		"the Burning Censer reflects 10%% more and mends a fifth of it (got %s)" % str(bc))
	ok(float(bc.get("max_hp_pct", 0.0)) < 0.0,
		"...and the scarred rune still carries a real cost")
	var sv: Dictionary = Runes.build("standing_vow")["payload"]["stat"]
	ok(int(sv.get("blessed_barrier_ranks", 0)) == 4
		and int(sv.get("devoutness_ranks", 0)) == 5
		and int(sv.get("pulse_ranks", 0)) == 2,
		"the Standing Vow pays 4%% / -5%% BD / 2%% a turn (got %s)" % str(sv))
	# A rune writing an int field whose name does not end "_ranks" MUST be in
	# STAT_INT_KEYS or JSON's float slides into a typed int var and the hero
	# fails to spawn — the AA trap, through the AW door.
	# BATCH BH §2: `fervor_step` left the list with the field; `oath_opening`
	# joined it, being the bare int the re-pointed rune now writes.
	for f2 in ["faithful_step", "righteous_step", "stalwart_step", "oath_opening"]:
		ok(Runes.STAT_INT_KEYS.has(f2),
			"%s is listed in Runes.STAT_INT_KEYS" % f2)
	# Lane tags must name a live lane, or the rune is homeless in the bot's
	# build policy and in the per-lane coverage test (the AS Honed Lance).
	var lanes := {}
	for t in _tree():
		lanes[String(t.get("lane", ""))] = true
	for id2 in Runes.ids():
		var cfg2: Dictionary = Runes.config(id2)
		if String(cfg2.get("scope", "")) != "spec:inquisitor":
			continue
		var lane := String(cfg2.get("lane", ""))
		ok(lane == "" or lanes.has(lane),
			"%s's lane tag '%s' names a live Devout lane" % [id2, lane])
	# THE THREE CLERIC CLASS-WIDE RUNES TOUCH NO DEVOUT COUNTER.
	var dv_fields := {}
	for t2 in _tree():
		for f3 in t2.get("payload", {}).get("stat", {}):
			dv_fields[String(f3)] = true
		for extra in t2.get("payload", {}).get("also", []):
			for f4 in extra.get("stat", {}):
				dv_fields[String(f4)] = true
	for id3 in ["zealotry", "martyr", "binding_souls"]:
		var cfg3: Dictionary = Runes.config(id3)
		ok(String(cfg3.get("scope", "")) == "class:cleric", "%s is class-wide" % id3)
		for f5 in cfg3["payload"].get("stat", {}):
			ok(not dv_fields.has(String(f5)),
				"%s must not write the Devout tree counter %s" % [id3, f5])
	# A RUNE WHOSE NODE IS GONE KEEPS ITS READ SITE AND IS FLAGGED, never
	# silently deleted. AW retires no Devout node, so there is nothing to
	# vault — asserted so a later batch that DOES retire one has to say so.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# BATCH BH §2: `oath_ranks` -> `oath_opening`, the field the rune writes now.
	for still_live in ["blessed_barrier_ranks", "warded_ranks", "oath_opening",
			"faithful_step", "righteous_step", "lifewell_ranks",
			"devoutness_ranks", "pulse_ranks"]:
		ok(bsrc.contains(still_live),
			"every rune-written Devout counter still has a live read site: %s" % still_live)


# ---------- §7 the bot ----------

func _bot_policy_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# The ground is the Faith engine now, so the old "3+ foes" mitigation gate
	# is gone and it comes BEFORE the shield in the policy.
	var ground_at := bsrc.find("var ground_ab := _find_ability(u, \"Consecrated Ground\")")
	var shield_at := bsrc.find("var shield_ab := _find_ability(u, \"Divine Shield\")")
	ok(ground_at > 0 and shield_at > ground_at,
		"the bot lays Consecrated Ground BEFORE it considers Divine Shield")
	ok(not bsrc.contains("and u.ability_ready(ground_ab) and foes.size() >= 3"),
		"...and no longer waits for three foes to do it")
	# The shield aims at whoever is drawing fire, falling back to lowest health.
	ok(bsrc.contains("var shield_t := _likeliest_target(allies)"),
		"the bot aims Divine Shield at the likeliest target")
	ok(bsrc.contains("shield_t = weakest_ally"),
		"...falling back to lowest health when nothing is drawing fire")
	ok(bsrc.count("func _likeliest_target") == 1,
		"the likeliest-target question has exactly one answer")
	# Blessing of Zeal onto a shield-holder is the Batch K fix and STAYS.
	ok(bsrc.contains("if zh.has_status(\"barrier\") \\"),
		"the bot still sends Blessing of Zeal to a shield-holder")


# ---------- §9 the Holy rename ----------

func _holy_rename() -> void:
	var holy := Talents.generate_tree("holy", "cleric")
	var beacon := Talents.node_in_tree(holy, "hl_beacon")
	ok(String(beacon.get("name", "")) == "Hour of Need",
		"hl_beacon is renamed Hour of Need (got %s)" % beacon.get("name", ""))
	# THE COUNTER AND EVERY READ SITE STAY EXACTLY AS THEY ARE — this is a
	# label only, and a rename that moved a counter would be a silent re-tune.
	ok(int(beacon.get("payload", {}).get("stat", {}).get("holy_vigil_pct", 0)) == 15,
		"...and still writes holy_vigil_pct = 15")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains("0.01 * hv_c.holy_vigil_pct"),
		"...against an untouched read site")
	ok(bsrc.contains("const HOLY_VIGIL_AT := 0.30"),
		"...and an untouched threshold")
	# The WARDEN keeps the name: his triggers on him standing strong, which is
	# what "Shared Vigil" describes.
	var warden := Talents.generate_tree("warden", "warrior")
	var fortress := Talents.node_in_tree(warden, "wd_fortress")
	ok(String(fortress.get("name", "")) == "Shared Vigil",
		"the Warden's Shared Vigil keeps its name")
	# And the collision is gone: no two nodes in the game share a name across
	# the Cleric and Warrior trees by accident again.
	var names := {}
	for spec in Talents.LANE_TREES:
		for t in Talents.LANE_TREES[spec]:
			var nm := String(t.get("name", ""))
			names[nm] = names.get(nm, 0) + 1
	ok(int(names.get("Shared Vigil", 0)) == 1,
		"exactly one node in the game is called Shared Vigil (got %d)" % names.get("Shared Vigil", 0))
	ok(int(names.get("Hour of Need", 0)) == 1,
		"...and exactly one is called Hour of Need")


# ---------- negative controls, at the source ----------

# The three that would fail SILENTLY. A growth reading CURRENT looks like a
# working node until a long fight; a sync that forgets the subtraction looks
# like a working battle until the map card shows the swollen bar; a drip that
# still needs Fervor looks exactly like a spec whose party-wide source is
# simply not very good.
func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var rsrc := FileAccess.get_file_as_string("res://scripts/run_sim.gd")
	# RE-POINTED BY BATCH AY, with the reason in the file: §9 put the
	# percentage in a local (`pct`) so a no-consume release can halve it, so
	# the literal expression moved. THE QUESTION IS UNCHANGED — the growth
	# must read the CAPTURED BASE and never the current maximum.
	ok(bsrc.contains("devout.conviction_base_hp * pct"),
		"NEGATIVE CONTROL: the growth reads the captured BASE, not max_hp")
	ok(not bsrc.contains("devout.max_hp * CONVICTION_GROWTH_PCT"),
		"NEGATIVE CONTROL: no path multiplies the CURRENT maximum")
	ok(not bsrc.contains("devout.max_hp * pct"),
		"NEGATIVE CONTROL: ...and the halved path does not either")
	# RE-POINTED BY BATCH BJ §1, with the reason here: the two victory-sync
	# copies (battle.gd's and RunSim's) were deduplicated into ONE
	# implementation, BattleUnit.sync_victory_state. THE QUESTION IS
	# UNCHANGED — the growth must come off the saved maximum — but there is
	# only one site to ask it of now, plus the requirement that BOTH old
	# callers still route through it.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(usrc.contains("- conviction_hp_gained"),
		"NEGATIVE CONTROL: the shared victory sync subtracts the growth")
	ok(bsrc.contains("heroes[i].sync_victory_state(Run.party[i])"),
		"NEGATIVE CONTROL: battle.gd's victory branch calls the shared sync")
	ok(rsrc.contains("battle.heroes[i].sync_victory_state(run.party[i])"),
		"NEGATIVE CONTROL: RunSim's victory path calls the same shared sync")
	# The sync must keep subtracting Tenacity's own battle-long gain as well.
	# CORRECTION TO THE BATCH BRIEF, recorded not glossed: it describes
	# Tenacity's growth as PERMANENT. It is not — tenacity_hp_gained has been
	# excluded from the save sync since Batch W, exactly like this one. The two
	# fields still must not be merged, for a better reason: Unkillable's mend
	# reads `max_hp - tenacity_hp_gained` as "the pool he brought into the
	# battle" and must mean TENACITY'S growth alone.
	ok(usrc.contains("max_hp - tenacity_hp_gained"),
		"Tenacity's battle-long gain is still subtracted at the shared sync")
	ok(bsrc.contains("- strike_target.tenacity_hp_gained"),
		"...and Unkillable still reads tenacity_hp_gained alone (why they stay separate)")
	ok(bsrc.count("devout.conviction_hp_gained += step") == 1
		and not bsrc.contains("heroes[i].conviction_hp_gained"),
		"conviction_hp_gained has exactly one writer in battle.gd; the read moved to the shared sync")
	# The drip must not be gated on the node.
	# BATCH BH §2 STRENGTHENED THIS RATHER THAN RE-POINTING IT. AW's question
	# was "the drip is not GATED on Fervor"; the drip is not touched by Fervor
	# at all now, so the check asserts the stronger thing — the flat 1.
	ok(bsrc.contains("_gain_faith(u, 1, \"ground\")")
		and not bsrc.contains("devout.fervor_step"),
		"NEGATIVE CONTROL: the ground's Faith drip is a flat 1, un-gated and un-deepened")


# ---------- live: §1 the growth is LINEAR ON BASE ----------

func _live_growth() -> void:
	var scene := await _spawn({})
	var dv := _hero(scene, 2)
	var ally := _hero(scene, 0)
	ok(dv != null and dv.passive_id == "conviction", "slot 2 is the Devout")
	# A BIG base, deliberately: at 100 max HP a 3% step rounds to 3 whether the
	# clause is linear or compounding for the first several releases, so a
	# small hero cannot tell the two apart. At 1000 they diverge immediately.
	dv.max_hp = 1000
	dv.hp = 1000
	dv.conviction_hp_gained = 0
	dv.conviction_base_hp = 0
	for i in 10:
		ally.faith_stacks = 0
		scene._gain_faith(ally, 5, "absorb")
	ok(dv.conviction_base_hp == 1000,
		"the base is captured once, at the first release (got %d)" % dv.conviction_base_hp)
	ok(dv.max_hp == 1300,
		"TEN releases raise his maximum by 10 x 3%% of BASE = 300 (got %d)" % (dv.max_hp - 1000))
	ok(dv.conviction_hp_gained == 300,
		"...and the leak guard accumulated every point (got %d)" % dv.conviction_hp_gained)
	# 1.03^10 x 1000 = 1343.9. THE WHOLE POINT OF "3% OF BASE": the loop still
	# compounds THROUGH THE KIT, but the clause must never compound against
	# itself, because Apostle turns releases into a stream.
	ok(dv.max_hp < 1340,
		"NEGATIVE CONTROL: the growth is LINEAR — a compounding 1.03^10 would read 1344 (got %d)" % dv.max_hp)
	_report.append("Conviction growth: 10 releases, base 1000 -> max %d (linear 1300, compounding 1344)" % dv.max_hp)
	await _kill(scene)


# ---------- live: §1 it HEALS him for the amount ----------

func _live_growth_heals() -> void:
	var scene := await _spawn({})
	var dv := _hero(scene, 2)
	var ally := _hero(scene, 0)
	dv.max_hp = 1000
	dv.hp = 1000
	dv.conviction_hp_gained = 0
	dv.conviction_base_hp = 0
	# The release heals the ALLY, so the Devout's own health can only move
	# because of the growth clause — the point being that the dividend arrives
	# as USABLE health rather than as an empty bar.
	ally.faith_stacks = 0
	scene._gain_faith(ally, 5, "absorb")
	ok(dv.max_hp == 1030, "one release: maximum 1000 -> %d" % dv.max_hp)
	ok(dv.hp == dv.max_hp,
		"...and he is healed for the amount granted, so the new bar is FULL (%d/%d)" % [dv.hp, dv.max_hp])
	# And from a wounded start the heal lands rather than the ceiling merely
	# moving — an empty 30 HP would read as a working clause on a full bar.
	dv.hp = 500
	ally.faith_stacks = 0
	scene._gain_faith(ally, 5, "absorb")
	ok(dv.max_hp == 1060, "a second release: maximum -> %d" % dv.max_hp)
	ok(dv.hp >= 530,
		"...and a wounded Devout genuinely gains the health (500 -> %d)" % dv.hp)
	_report.append("growth heal from wounded: 500 -> %d against a step of 30" % dv.hp)
	await _kill(scene)


# ---------- live: §1 the Apostle row, which is the one that matters ----------

func _live_apostle_stream() -> void:
	# RE-POINTED TWICE, AND THE SECOND TIME THE STREAM ITSELF WENT AWAY.
	# AW wrote this against an Apostle that stopped releases consuming stacks,
	# so every further Faith gain re-triggered one; AY §9 halved what those
	# free re-triggers paid; BATCH BG §2 MOVED THE CAPSTONE OFF THE RELEASE
	# AXIS ENTIRELY. Nothing parks an ally at five any more, so the stream is
	# not a thing the game can produce and the row it fed cannot be re-measured.
	#
	# What survives is the QUESTION this check was really asking — how much
	# maximum health a long fight's worth of releases lends the Devout — and
	# it is now asked of the shape the game actually has: thirteen releases,
	# each one rebuilt from zero, each one consuming its stacks and paying the
	# full 3%. The old number (13 x 15 on a 1000 base) is what it read while
	# Apostle multiplied frequency; the new one is 13 x 30, and BG's own suite
	# holds the negative control that the park is gone.
	var scene := await _spawn({"dv_apostle": 1})
	var dv := _hero(scene, 2)
	var ally := _hero(scene, 0)
	ok(dv.apostle == 1, "Apostle is learned")
	dv.max_hp = 1000
	dv.hp = 1000
	dv.conviction_hp_gained = 0
	dv.conviction_base_hp = 0
	ally.faith_stacks = 0
	scene._gain_faith(ally, 5, "absorb")
	ok(ally.faith_stacks == 0,
		"Batch BG: a release under Apostle consumes the stacks like any other")
	# Twelve further releases, i.e. a long fight's worth of absorbs — but each
	# one now costs five gains rather than one, which IS the repair.
	for i in 12:
		scene._gain_faith(ally, 5, "absorb")
	ok(ally.faith_stacks == 0, "...and each of them resets him again")
	ok(dv.max_hp == 1000 + 13 * 30,
		"13 releases = +39%% of base at the full step (got +%d%%)" % (
			(dv.max_hp - 1000) * 100 / 1000))
	_report.append("APOSTLE ROW (AW's number, re-pointed by BG): 13 releases in one fight = max_hp 1000 -> %d, +%d%% — and under BG each one costs five Faith gains, not one" % [
		dv.max_hp, (dv.max_hp - 1000) * 100 / 1000])
	await _kill(scene)


# ---------- live: §1 THE LANDMINE — max_hp must not leave the battle ----------

func _live_victory_sync() -> void:
	var scene := await _spawn({})
	var dv := _hero(scene, 2)
	var warrior := _hero(scene, 0)
	var run := root.get_node("/root/Run")
	var before_max: int = int(run.party[2]["max_hp"])
	var w_before_max: int = int(run.party[0]["max_hp"])
	ok(dv.max_hp == before_max,
		"the Devout spawns at his saved maximum (%d)" % before_max)
	# Grow him hard, and give the WARRIOR a Tenacity gain in the same battle —
	# the two loans are handled at one site and a merge would show up here.
	for i in 6:
		warrior.faith_stacks = 0
		scene._gain_faith(warrior, 5, "absorb")
	warrior.max_hp += 45
	warrior.tenacity_hp_gained += 45
	var grown: int = dv.max_hp
	ok(grown > before_max,
		"he really is bigger inside the fight (%d -> %d)" % [before_max, grown])
	# Wound him, so the hp clamp has something to bite on.
	dv.hp = dv.max_hp
	# Clear the field and let the NORMAL victory branch run — no special path.
	for e in scene.get("enemies"):
		e.hp = 0
		e._die()
	await scene._check_end()
	for _i in 4:
		await process_frame
	ok(int(run.party[2]["max_hp"]) == before_max,
		"MAX_HP RETURNS TO ITS PRE-BATTLE VALUE on the party member (%d -> %d, was %d in the fight)" % [
			before_max, int(run.party[2]["max_hp"]), grown])
	ok(int(run.party[2]["hp"]) <= int(run.party[2]["max_hp"]),
		"...with hp clamped under the restored maximum (%d/%d)" % [
			int(run.party[2]["hp"]), int(run.party[2]["max_hp"])])
	ok(int(run.party[0]["max_hp"]) == w_before_max,
		"Tenacity's battle-long gain is handled the same way at the same site (%d)" % int(run.party[0]["max_hp"]))
	_report.append("victory sync: Devout %d in-fight -> %d saved (pre-battle %d)" % [
		grown, int(run.party[2]["max_hp"]), before_max])
	await _kill(scene)


# ---------- live: §2 the ground is a Faith source with NO node ----------

func _live_ground_drip() -> void:
	# WITH FERVOR UNLEARNED. This is the whole of §2: Faith had one real source
	# on a 2-turn cooldown, so a passive promising a party-wide system
	# delivered to one ally at a time.
	var bare := await _spawn({})
	var dv := _hero(bare, 2)
	var ally := _hero(bare, 0)
	ok(dv.fervor == 0, "Fervor is NOT learned")
	ally.faith_stacks = 0
	# NO GROUND, NO FAITH — the gate has to be real or the next check is
	# measuring nothing.
	ally.remove_status("cons_ground")
	bare._ground_faith_tick(ally)
	ok(ally.faith_stacks == 0, "without the ground there is no drip at all")
	# THE REAL CLAUSE, driven the way a turn drives it.
	bare._apply_status(ally, "cons_ground", 3)
	bare._ground_faith_tick(ally)
	ok(ally.faith_stacks == 1,
		"the holy ground grants 1 Faith per ally per turn with NO node (got %d)" % ally.faith_stacks)
	bare._ground_faith_tick(ally)
	ok(ally.faith_stacks == 2, "...and again on the next turn (got %d)" % ally.faith_stacks)
	# It is one clause in one place, and the turn-start block calls it.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.count("func _ground_faith_tick") == 1
		and bsrc.count("_ground_faith_tick(u)") == 1,
		"the drip has one implementation and one caller")
	ok(bsrc.contains("_gain_faith(u, 1, \"ground\")"),
		"...and it is a flat 1, which is the whole of AW §2's base kit")
	await _kill(bare)
	# BATCH BH §2 RE-POINTED THE SECOND HALF OF THIS CHECK, and INVERTED it
	# rather than deleting it — which is the point. AW asked "does the node
	# DEEPEN the drip"; a deeper drip is a release-frequency multiplier, and
	# taking that off this lane is BH §2's whole subject. So the question the
	# check asks now is the opposite one, and it is the negative control that
	# would catch the node being put back: does Fervor leave the drip ALONE?
	var deep := await _spawn({"dv_fervor": 1})
	var dv2 := _hero(deep, 2)
	var ally2 := _hero(deep, 0)
	ok(dv2.fervor == 1, "Fervor is stamped as a gate on the HELD half")
	ally2.faith_stacks = 0
	deep._apply_status(ally2, "cons_ground", 3)
	deep._ground_faith_tick(ally2)
	ok(ally2.faith_stacks == 1,
		"...and with the node the drip is STILL 1 (got %d)" % ally2.faith_stacks)
	await _kill(deep)


# ---------- live: §5 both fallbacks, in BOTH acquisition orders ----------

func _live_fallbacks() -> void:
	# The node GRANTS when the ability was not already in hand.
	var granted := await _spawn({"dv_resolve": 1, "dv_bulwark": 1})
	var dv := _hero(granted, 2)
	ok(_find(dv, "Sacred Resolve") != null, "the row-3 node grants Sacred Resolve")
	ok(_find(dv, "Bulwark of Fortitude") != null, "the capstone grants Bulwark")
	ok(dv.resolve_extra_turns == 0 and dv.bulwark_extra_turns == 0,
		"...and neither fallback fired, because neither collided")
	await _kill(granted)
	# EARNED FIRST, then the node: it upgrades instead of granting. Earned
	# picks go on BEFORE the tree at both kit-assembly sites (the AH ordering
	# fix), which is what makes cfg["abilities"] the honest question.
	var owned := await _spawn({"dv_resolve": 1, "dv_bulwark": 1},
		{"bm_abilities": ["Sacred Resolve", "Bulwark of Fortitude"]})
	var dv2 := _hero(owned, 2)
	ok(dv2.resolve_extra_turns == 2,
		"Sacred Resolve already owned -> the node pays +2 turns (got %d)" % dv2.resolve_extra_turns)
	ok(dv2.bulwark_extra_turns == 1,
		"Bulwark already owned -> the node pays +1 turn (got %d)" % dv2.bulwark_extra_turns)
	var res_count := 0
	for ab in dv2.abilities:
		if ab.display_name == "Sacred Resolve":
			res_count += 1
	ok(res_count == 1, "...and nothing was double-granted (got %d copies)" % res_count)
	# LIVE: the split really lasts 5 turns, not 3.
	var resolve := _find(dv2, "Sacred Resolve")
	ok(resolve != null, "Sacred Resolve is in hand")
	if resolve != null:
		var mark := _hero(owned, 0)
		mark.remove_status("unity")
		await owned._resolve_special(dv2, resolve, dv2, "good", 1.0)
		var st: Dictionary = mark.get_status("unity")
		ok(not st.is_empty() and int(st.get("turns", 0)) >= 5,
			"...and the party's souls stay bound 5 turns (got %s)" % st.get("turns", 0))
	var bulwark := _find(dv2, "Bulwark of Fortitude")
	if bulwark != null:
		var mark2 := _hero(owned, 1)
		mark2.remove_status("bulwark")
		await owned._resolve_special(dv2, bulwark, dv2, "good", 1.0)
		var st2: Dictionary = mark2.get_status("bulwark")
		ok(not st2.is_empty() and int(st2.get("turns", 0)) >= 4,
			"...and the Bulwark holds 4 turns (got %s)" % st2.get("turns", 0))
	await _kill(owned)


# ---------- live: §4 the pair a player now holds BOTH of ----------

func _live_bastion_and_stalwart() -> void:
	# MEASURE THE COMBINATION, because it is legal now and it is large: a
	# shield absorbing 55% of his maximum, on no cooldown.
	# BATCH CQ §3 — 55 SINCE CN §3'S FOLD: Divine Shield's base went 30% -> 35%
	# (the perfect's share, folded in) and Stalwart still adds its 20 points.
	var scene := await _spawn({"dv_stalwart": 1, "dv_bastion": 1})
	var dv := _hero(scene, 2)
	var ally := _hero(scene, 0)
	ok(dv.stalwart_step == 20, "Stalwart is stamped as the +20-point increase")
	var shield_ab := _find(dv, "Divine Shield")
	ok(shield_ab != null, "Divine Shield is in hand")
	if shield_ab != null:
		ok(shield_ab.cooldown == 0,
			"Bastion leaves Divine Shield with NO cooldown (got %d)" % shield_ab.cooldown)
		ally.remove_status("barrier")
		# aegis is unlearned here, so no echo can muddy the reading.
		await scene._resolve_special(dv, shield_ab, ally, "good", 1.0)
		var st: Dictionary = ally.get_status("barrier")
		ok(not st.is_empty(), "the shield lands")
		if not st.is_empty():
			var pow_got := int(st.get("power", 0))
			var want := int(round(dv.max_hp * 0.55))
			ok(abs(pow_got - want) <= 1,
				"...absorbing 55%% of his maximum (want %d, got %d)" % [want, pow_got])
			_report.append("STALWART + BASTION, now legal together: %d absorb (55%% of %d max) on a 0-turn cooldown" % [
				pow_got, dv.max_hp])
		# And the absorb feeds Faith — the reason the pair is an engine.
		ally.faith_stacks = 0
		ally.take_hit(20, 0)
		ok(ally.faith_stacks >= 1,
			"...and the absorb builds Faith (got %d)" % ally.faith_stacks)
	await _kill(scene)
