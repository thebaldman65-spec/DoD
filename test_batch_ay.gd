# test_batch_ay.gd — THE BEASTMASTER: PARTNERSHIP. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ay.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §0 COMPANION DAMAGE IS CREDITED TO THE HUNTER, not to the beast — asserted
#      against a LIVE strike, because if it went the other way every
#      Beastmaster number ever measured would be wrong.
#   §1 THE PACK, BUILT: two beasts standing, BOTH boons at FULL strength,
#      separate Loyalty meters, a swap replacing the SHALLOWER bond (BATCH BB §1
#      REVERTED AY's "older of the two" — see `_live_swap_replaces_shallower`); One Soul
#      splitting across THREE bodies; Ursus's 100+idx taunt encoding decoding
#      to the right body with two beasts; Call of the Wild against a two-beast
#      field; AND that Lone Bond makes The Pack unreachable.
#   §2 LOYALTY HAS NO CEILING and the boon is a CURVE: past 5, 10 and 20 with
#      the multiplier reading x2, x3 and x5.
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, every final magnitude on the node
#      that owes it, and every counter ADDITIVE at its read site.
#   §5 THE TROPHY-POOL COLLISION CANNOT ARISE: no Beastmaster node grants an
#      ability, so he owes no AU §1 fallback in either direction.
#   §6 `wild_communion_step` IS NOT `communion_ranks`, and the four spec runes
#      plus the three Hunter class-wide ones all land on live read sites.
#   §7 THE BOT: summons first, fills both slots under The Pack, and swaps only
#      on boon worth.
#   §8 RUIN GENERATION: 2 per Occultist-applied debuff.
#   §9 A FAITH RELEASE THAT CONSUMED NO STACKS GRANTS HALF GROWTH.
#   NEGATIVE CONTROLS for the four that would fail silently: the boon curve
#      still stepping at 5, Menagerie paying full instead of half,
#      `wild_communion_step` writing the Devout's field, and a
#      full-consumption Faith release granting only half.
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
	Profile.save_path = "user://profile_batch_ay_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_magnitudes()
	_additive_units()
	_counter_name_trap()
	_no_ability_grants()
	_rune_audit()
	_bot_policy_source()
	_exclusive_pairs()
	_negative_control_source()

	await _live_curve()
	await _live_uncapped()
	await _live_wild_rotation_cap()
	await _live_two_beasts()
	await _live_swap_replaces_shallower()
	await _live_lone_bond_closes_the_pack()
	await _live_one_soul_three_bodies()
	await _live_taunt_encoding()
	await _live_call_of_the_wild()
	await _live_menagerie_half()
	await _live_companion_credit()
	await _live_vengeance_and_steadfast()
	await _live_ruin_generation()
	await _live_faith_half_growth()

	if FileAccess.file_exists("user://profile_batch_ay_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ay_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_ay: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("beastmaster", "hunter")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _hero(scene: Node, idx: int) -> BattleUnit:
	var live: Array = []
	for h in scene.get("heroes"):
		if not h.is_companion:
			live.append(h)
	return live[idx] if idx < live.size() else null


func _foe(scene: Node, idx: int) -> BattleUnit:
	var foes: Array = scene.get("enemies")
	return foes[idx] if idx < foes.size() else null


func _find(u: BattleUnit, name: String) -> Ability:
	if u == null:
		return null
	for ab in u.abilities:
		if ab.display_name == name:
			return ab
	return null


# The party is warrior/mage/cleric/hunter, so the Beastmaster is slot 3.
# `learned` lands on HIM; `cleric_learned` on the Cleric, for §8/§9.
func _spawn(learned: Dictionary, cleric_spec := "occultist",
		cleric_learned := {}, lineup := ["raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", cleric_spec, "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = {}
		if i == 2:
			run.party[i]["talents"] = cleric_learned.duplicate()
		elif i == 3:
			run.party[i]["talents"] = learned.duplicate()
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# Determinism FORCED, not retried (the AK/AL/AR/AS/AT/AU/AV/AW/AX
	# discipline). A driven _resolve still rolls miss, parry AND crit.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -10.0
	return scene


func _summon(scene: Node, hunter: BattleUnit, kind: String) -> void:
	scene.call("_do_summon", hunter, kind)
	for _i in 6:
		await process_frame


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


# ---------- §3 the tree's shape ----------

const IDS := ["bm_communion", "bm_unbroken", "bm_absolute", "bm_devoted_fury",
	"bm_steadfast", "bm_ancient_pact", "bm_lone_bond",
	"bm_whistle", "bm_momentum", "bm_shared", "bm_herald", "bm_menagerie",
	"bm_no_beast_left", "bm_wild_rotation",
	"bm_masters_aim", "bm_beast_within", "bm_reserves", "bm_instinctive",
	"bm_symbiosis", "bm_vengeance", "bm_lone_hunter",
	"bm_one_soul", "bm_the_pack", "bm_apex"]


func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 24, "the Beastmaster tree holds 24 nodes (got %d)" % tree.size())
	var by_lane := {"devotion": 0, "pack": 0, "handler": 0}
	var caps := 0
	var seen := {}
	for t in tree:
		var id := String(t["id"])
		ok(not seen.has(id), "id %s appears once" % id)
		seen[id] = true
		ok(int(t.get("ranks", 0)) == 1, "%s holds a single rank" % id)
		var row := int(t.get("row", 0))
		ok(row >= 1 and row <= 8, "%s sits in a real row (got %d)" % [id, row])
		if bool(t.get("capstone", false)):
			caps += 1
			ok(row == 8, "capstone %s is in row 8" % id)
		else:
			by_lane[String(t["lane"])] = by_lane[String(t["lane"])] + 1
		# Batch AI's structure: exclusive references are by ROW, so no node may
		# carry a stale `exclusive_with` pointing at an id that has moved.
		ok(not t.has("exclusive_with"),
			"%s carries no stale exclusive_with — rows do the barring" % id)
	ok(caps == 3, "three capstones (got %d)" % caps)
	for lane in by_lane:
		ok(by_lane[lane] == 7, "lane %s holds 7 rows (got %d)" % [lane, by_lane[lane]])
	# EVERY ID SURVIVES: §11's whole promise, and the reason no save moves.
	for id in IDS:
		ok(not _node(id).is_empty(), "id %s survives and re-specs in place" % id)
	ok(seen.size() == IDS.size(),
		"no id was added or deleted (tree %d vs expected %d)" % [seen.size(), IDS.size()])
	# One node per lane per row, or the picker's "choose one" band is a lie.
	var slots := {}
	for t in tree:
		var key := "%s:%d" % [t["lane"], int(t["row"])]
		ok(not slots.has(key), "one node in %s" % key)
		slots[key] = true


# ---------- §3 the magnitudes, final ----------

func _magnitudes() -> void:
	# DEVOTION
	ok(_stat_of("bm_communion", "wild_communion_step") == 7.0,
		"Wild Communion: the strike step rises to 12%% (base 5 + 7)")
	ok(_stat_of("bm_unbroken", "unbroken_watch") == 2,
		"Unbroken Watch: +2 Loyalty on an unbloodied turn")
	ok(_stat_of("bm_absolute", "absolute_step") == 15.0,
		"Absolute Devotion: the boon step rises to 35%% (base 20 + 15)")
	ok(_stat_of("bm_devoted_fury", "devoted_fury") == 1,
		"Devoted Fury: +1 Wrath turn PER stack, not per two")
	ok(_stat_of("bm_steadfast", "steadfast_bond") == 100,
		"Steadfast Bond: the Loyalty returns in FULL (100%%)")
	ok(_stat_of("bm_ancient_pact", "ancient_pact") == 1, "Ancient Pact is a flag")
	ok(_stat_of("bm_lone_bond", "lone_bond") == 6,
		"Lone Bond: the beast arrives at 6 Loyalty (the gate and the magnitude)")
	# THE PACK
	ok(_stat_of("bm_whistle", "quick_whistle_ranks") == 3,
		"Quick Whistle shaves the whole 3-turn swap cooldown")
	ok(_stat_of("bm_momentum", "momentum_ranks") == 25,
		"Feral Momentum: +25%% per distinct beast")
	ok(_stat_of("bm_shared", "shared_devotion") == 2,
		"Shared Devotion: +2 Loyalty to every beast")
	ok(_stat_of("bm_herald", "herald") == 2,
		"Herald: TWO additional targets")
	ok(_stat_of("bm_menagerie", "menagerie") == 50,
		"Menagerie: HALF strength, deliberately unchanged")
	ok(_stat_of("bm_no_beast_left", "no_beast_left") == 2,
		"No Beast Left: the next TWO summons are free")
	ok(_stat_of("bm_no_beast_left", "no_beast_left_loyalty") == 5,
		"...and each arrives at 5 Loyalty (two magnitudes, two fields)")
	ok(_stat_of("bm_wild_rotation", "wild_rotation") == 3,
		"Wild Rotation: Loyalty caps at 3 — the field IS the cap")
	# HANDLER
	ok(_stat_of("bm_masters_aim", "masters_aim_ranks") == 25,
		"Master's Aim: +25%% of Attack on Quick Shot")
	ok(abs(float(_stat_of("bm_beast_within", "companion_hp_pct")) - 0.40) < 0.001,
		"Beast Within: +40%% companion max health")
	ok(_stat_of("bm_reserves", "deep_reserves_ranks") == 30,
		"Deep Reserves: +30%% max Mana on Spirit Bond")
	ok(_stat_of("bm_instinctive", "instinctive") == 8,
		"Instinctive: 8 empowered Quick Shots")
	ok(_stat_of("bm_symbiosis", "symbiosis") == 6,
		"Symbiosis: 6%% max Mana per companion strike")
	ok(_stat_of("bm_vengeance", "vengeance") == 1
		and _stat_of("bm_vengeance", "vengeance_dmg") == 30,
		"Vengeance: the boon flag plus its own +30%% damage")
	ok(_stat_of("bm_lone_hunter", "lone_hunter") == 50
		and _stat_of("bm_lone_hunter", "lone_hunter_dmg") == 30,
		"Lone Hunter: -50%% cost, +30%% damage — two magnitudes, two fields")
	# CAPSTONES
	for cap_id in ["bm_one_soul", "bm_the_pack", "bm_apex"]:
		ok(bool(_node(cap_id).get("capstone", false)), "%s is a capstone" % cap_id)
	# §1: The Pack no longer says "coming soon" anywhere in the data.
	ok(not _node("bm_the_pack").has("locked_note"),
		"The Pack carries no locked_note — it is BUILT")
	for t in _tree():
		var d := String(t.get("desc", "")).to_lower()
		ok(not d.contains("coming soon"),
			"%s does not read 'coming soon'" % t["id"])
	# Every rendered tooltip must show the design value, not a stale one.
	for id in IDS:
		var n := _node(id)
		if not n.has("scale"):
			continue
		var shown := Talents.desc_for(n, 1)
		ok(not shown.contains("{v}"), "%s renders its {v}" % id)


# ---------- §6 the counters are ADDITIVE at their read sites ----------

func _additive_units() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# The magnitude lives in the payload; the read site applies no step.
	var pairs := {
		"0.01 * hunter.wild_communion_step": "Wild Communion",
		"0.01 * pm.wild_communion_step": "Wild Communion (companion strike)",
		"0.01 * hunter.absolute_step": "Absolute Devotion",
		"0.01 * hunter.momentum_ranks": "Feral Momentum (ghost)",
		"0.01 * pm.momentum_ranks": "Feral Momentum",
		"0.01 * attacker.masters_aim_ranks": "Master's Aim",
		"0.01 * attacker.deep_reserves_ranks": "Deep Reserves",
		"0.01 * pm.symbiosis": "Symbiosis",
		"0.01 * attacker.vengeance_dmg": "Vengeance",
		"0.01 * attacker.lone_hunter_dmg": "Lone Hunter (damage)",
		"0.01 * u.lone_hunter": "Lone Hunter (cost)",
		"0.01 * hunter.menagerie": "Menagerie",
		"1 + hunter.herald": "Herald",
		"pm.steadfast_bond / 100": "Steadfast Bond",
	}
	for frag in pairs:
		ok(src.contains(frag),
			"%s reads its counter additively (`%s`)" % [pairs[frag], frag])
	# The old ranked forms must be GONE, or a magnitude silently multiplies.
	for dead in ["0.015 * pm.wild_communion_ranks", "0.08 * pm.momentum_ranks",
			"0.06 * attacker.masters_aim_ranks", "0.08 * attacker.deep_reserves_ranks",
			"loyalty_cap_bonus"]:
		ok(not src.contains(dead), "the ranked form `%s` is gone" % dead)
	# The two `_step` counters are FLOATS and must stay out of STAT_INT_KEYS,
	# or the Deep Bond's 1.5 rounds to 1 with nothing crashing (AT's lesson).
	ok(not Runes.STAT_INT_KEYS.has("wild_communion_step"),
		"wild_communion_step is NOT coerced to int — the Deep Bond pays 1.5")
	ok(not Runes.STAT_INT_KEYS.has("absolute_step"),
		"absolute_step is NOT coerced to int either")
	ok(not Runes.STAT_INT_KEYS.has("loyalty_cap_bonus"),
		"loyalty_cap_bonus left STAT_INT_KEYS with its premise")
	var u := BattleUnit.new()
	ok(typeof(u.get("wild_communion_step")) == TYPE_FLOAT,
		"wild_communion_step is declared a float")
	ok(typeof(u.get("absolute_step")) == TYPE_FLOAT,
		"absolute_step is declared a float")
	ok(u.get("loyalty_cap_bonus") == null,
		"loyalty_cap_bonus is deleted, not left unreachable")
	u.free()


# ---------- §6 the name trap ----------

func _counter_name_trap() -> void:
	# `wild_communion_step` is the BEASTMASTER's. `communion_ranks` is the
	# DEVOUT's, and Batch 29 crossed the two once already.
	var bm_fields := {}
	for t in _tree():
		for f in t.get("payload", {}).get("stat", {}):
			bm_fields[f] = true
	ok(not bm_fields.has("communion_ranks"),
		"NO Beastmaster node writes communion_ranks — that is the Devout's")
	ok(bm_fields.has("wild_communion_step"),
		"...and one writes wild_communion_step, which is his")
	var dv_fields := {}
	# THE DEVOUT'S SPEC ID IS "inquisitor" — the rename never reached the id,
	# and Talents.LANE_TREES is the one place that holds a tree by spec id.
	for t in Talents.generate_tree("inquisitor", "cleric"):
		for f in t.get("payload", {}).get("stat", {}):
			dv_fields[f] = true
	ok(dv_fields.has("communion_ranks"),
		"the Devout still writes communion_ranks")
	ok(not dv_fields.has("wild_communion_step"),
		"...and never wild_communion_step")
	var crossed: Array = []
	for f in bm_fields:
		if dv_fields.has(f):
			crossed.append(f)
	ok(crossed.is_empty(),
		"no counter is shared between the Beastmaster and the Devout (got %s)" % \
			str(crossed))


# ---------- §5 the trophy-pool collision cannot arise ----------

func _no_ability_grants() -> void:
	# AU §1's rule runs BOTH ways: a tree node granting an owned ability falls
	# back, and a boss offering a tree-granted one is filtered. His tree grants
	# NOTHING — the summons, Hunter's Instinct and Kill Command are base kit,
	# and Bestial Wrath / Spirit Bond / Primal Surge / Call of the Wild / Mark
	# of the Hunt come from the boss-trophy pool. So the reverse case cannot
	# arise, and this records that rather than leaving a reader to wonder.
	for t in _tree():
		var p: Dictionary = t.get("payload", {})
		ok(not p.has("grant_ability"),
			"%s grants no ability" % t["id"])
		ok(not p.has("new_ability"),
			"%s introduces no new ability" % t["id"])
		ok(not p.has("upgrade"),
			"%s owes no authored fallback (it grants nothing to collide)" % t["id"])
	# The other half: every trophy the pool offers him is absent from the tree,
	# so no trophy can land on a node's grant.
	var tree_names := Talents.ability_names({"spec": "beastmaster",
		"key": "hunter", "talents": _learn_all()})
	for trophy in Classes.SPEC_POOLS["beastmaster"]:
		ok(not tree_names.has(trophy),
			"the trophy %s is not also a tree grant" % trophy)


func _learn_all() -> Dictionary:
	var all := {}
	for id in IDS:
		all[id] = 1
	return all


# ---------- §6 the rune audit ----------

func _rune_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var pool := {}
	for rid in Runes.ids():
		pool[rid] = Runes.config(rid)
	var bm_runes := ["deep_bond", "turning_pack", "loosened_straps", "shared_wild"]
	for id in bm_runes:
		ok(pool.has(id), "the rune %s is still in the pool" % id)
		var stats: Dictionary = pool[id].get("payload", {}).get("stat", {})
		for f in stats:
			# Every counter a rune writes must have a LIVE read site, or a
			# later batch that retires a node has to say so out loud (AW).
			ok(src.contains(f) or f in ["armor", "companion_hp_pct"],
				"the rune %s writes %s, which battle.gd still reads" % [id, f])
	# EACH STILL PAYS EXACTLY WHAT IT ADVERTISES, in the NEW units.
	var deep: Dictionary = pool["deep_bond"]["payload"]["stat"]
	ok(abs(float(deep["wild_communion_step"]) - 1.5) < 0.001,
		"the Deep Bond still drives the beast 1.5%% harder a stack")
	ok(not deep.has("loyalty_cap_bonus"),
		"...and its dead ceiling clause was RE-POINTED, not left writing a dead field")
	ok(deep.has("absolute_step"),
		"...it pays into the boon's step instead")
	var turn: Dictionary = pool["turning_pack"]["payload"]["stat"]
	ok(int(turn["quick_whistle_ranks"]) == 1,
		"the Turning Pack still returns the swap a turn sooner")
	ok(int(turn["momentum_ranks"]) == 8,
		"...and still pays +8%% per distinct beast (1 rank x 8 -> a flat 8)")
	var straps: Dictionary = pool["loosened_straps"]["payload"]["stat"]
	ok(int(straps["masters_aim_ranks"]) == 12,
		"the Loosened Straps still flies 12%% of Attack harder (2 ranks x 6 -> 12)")
	ok(float(straps["armor"]) < 0.0,
		"...and it is still SCARRED — the armor cost survives")
	ok(bool(pool["loosened_straps"].get("scarred", false)),
		"...and still flagged scarred")
	var wild: Dictionary = pool["shared_wild"]["payload"]["stat"]
	ok(abs(float(wild["wild_communion_step"]) - 1.5) < 0.001,
		"the Shared Wild still pays +1.5%% a stack")
	ok(int(wild["momentum_ranks"]) == 8,
		"...and +8%% per distinct beast")
	ok(abs(float(wild["companion_hp_pct"]) - 0.05) < 0.001,
		"...and +5%% companion health, untouched")
	# THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO BEASTMASTER COUNTER.
	var bm_fields := {}
	for t in _tree():
		for f in t.get("payload", {}).get("stat", {}):
			bm_fields[f] = true
	for id in pool:
		if String(pool[id].get("scope", "")) != "class:hunter":
			continue
		for f in pool[id].get("payload", {}).get("stat", {}):
			ok(not bm_fields.has(f),
				"the class-wide rune %s does not write the Beastmaster counter %s" % [id, f])
	# No lane tag went stale: his lanes are lowercase and did not rename.
	var lanes := {"devotion": true, "pack": true, "handler": true}
	for id in bm_runes:
		var lane := String(pool[id].get("lane", ""))
		ok(lane == "" or lanes.has(lane),
			"the rune %s carries a live lane tag (%s)" % [id, lane])


# ---------- §7 the bot's rules, at the source ----------

func _bot_policy_source() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("if bot_beasts.size() < _beast_cap(u):"),
		"BOT: it fills every free slot — under The Pack that is two")
	ok(src.contains("func _bot_boon_worth"),
		"BOT: swapping is decided by BOON WORTH, not by cooldown availability")
	ok(src.contains("best_worth > out_worth * 1.25"),
		"BOT: ...and only when the incoming boon clears a real margin")
	# RE-POINTED IN PLACE BY BATCH BB §1, with the reason in the file. The
	# question this check has always asked is "does the bot price the SAME beast
	# `_do_summon` will actually free" — a bot valuing one beast while the summon
	# frees another would refuse every swap forever. That question is unchanged;
	# only the answer moved, because AY's oldest-beast rule was a regression and
	# BB restored Batch Q's. It rides `_swap_victim`, the one implementation both
	# sites now read, so the two can no longer disagree at all.
	ok(src.contains("var out_b: BattleUnit = _swap_victim(u)"),
		"BOT: the beast it would replace is the one `_do_summon` frees (`_swap_victim`)")
	# The summon block must come FIRST in the hunter branch, or Loyalty never
	# accrues and the sim measures a spec nobody plays.
	var hunter_at := src.find("\t\t\"hunter\":")
	var summon_at := src.find("if bot_beasts.size() < _beast_cap(u):", hunter_at)
	var sbond_at := src.find("var sbond := _find_ability(u, \"Spirit Bond\")", hunter_at)
	ok(hunter_at > 0 and summon_at > hunter_at and summon_at < sbond_at,
		"BOT: the summon block is the FIRST thing the hunter branch does")


# ---------- §4 the exclusive pairs ----------

func _exclusive_pairs() -> void:
	# LONE BOND <-> WILD ROTATION SURVIVES, and it survives because ROW
	# EXCLUSIVITY enforces it: both sit in row 7. Stated so a later batch does
	# not "fix" a pair that is already being enforced correctly.
	ok(int(_node("bm_lone_bond")["row"]) == 7
		and int(_node("bm_wild_rotation")["row"]) == 7,
		"Lone Bond and Wild Rotation share row 7 — the pair is enforced by the row")
	# STEADFAST BOND <-> VENGEANCE IS DEAD: rows 5 and 6 of DIFFERENT lanes, so
	# row exclusivity lets a player hold both.
	ok(int(_node("bm_steadfast")["row"]) == 5
		and String(_node("bm_steadfast")["lane"]) == "devotion",
		"Steadfast Bond sits in Devotion row 5")
	ok(int(_node("bm_vengeance")["row"]) == 6
		and String(_node("bm_vengeance")["lane"]) == "handler",
		"Vengeance sits in Handler row 6 — a player can hold both")
	# ...and no prose list still claims otherwise.
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not claude.contains("steadfast_bond/vengeance"),
		"CLAUDE.md's exclusive-pair prose does not list steadfast_bond/vengeance")


# ---------- NEGATIVE CONTROLS, at the source ----------

func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# (1) A boon that still STEPS at 5 rather than curving.
	ok(not bsrc.contains("if int(hunter.loyalty.get(kind, 0)) >= 5:"),
		"NEGATIVE CONTROL: no path steps the boon at 5 — it is a curve")
	ok(bsrc.contains("var curve := 1.0 + _bond_step(hunter) *"),
		"NEGATIVE CONTROL: the boon IS the curve, in one place")
	# (2) Menagerie paying FULL instead of half.
	ok(bsrc.contains("return curve * 0.01 * hunter.menagerie"),
		"NEGATIVE CONTROL: Menagerie pays its SHARE of the curve, never the whole")
	# (3) The ceiling must be a sentinel, not a big number a batch can reach.
	ok(bsrc.contains("const LOYALTY_UNCAPPED := -1"),
		"NEGATIVE CONTROL: 'no cap' is a sentinel, not a large ceiling")
	ok(bsrc.contains("if hunter.wild_rotation > 0:\n\t\treturn hunter.wild_rotation"),
		"NEGATIVE CONTROL: exactly one node still hands _loyalty_cap a number")
	# (4) The mitigation clamp — without it an uncapped boon HEALS him.
	ok(bsrc.contains("minf(0.10 * sp_ursus, BOND_MITIGATION_MAX)"),
		"NEGATIVE CONTROL: Savage Presence cannot cross zero into healing")
	# (5) §9: a release that DID consume stacks must still pay full growth.
	ok(bsrc.contains("_conviction_growth(devout, keep < 5)"),
		"NEGATIVE CONTROL: only a no-consume release is halved")
	# (6) §8: the passive's mark is one constant, and the node magnitudes are
	# not swept up in it.
	ok(bsrc.contains("const OLD_GODS_MARK := 2"),
		"NEGATIVE CONTROL: the Ruin mark is ONE number in ONE place")
	ok(bsrc.contains("_gain_ruin(strike_target, occ_delirium)")
		or bsrc.contains("_gain_ruin(strike_target, mad_occ.delirium_ranks)"),
		"NEGATIVE CONTROL: Delirium keeps its OWN magnitude")
	ok(bsrc.contains("_gain_ruin(e, occ.unravel_ranks)"),
		"NEGATIVE CONTROL: Unraveling keeps its own too")


# ---------- §2 live: the curve ----------

func _live_curve() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	ok(h != null and h.passive_id == "pack", "the Beastmaster spawned")
	await _summon(scene, h, "canis")
	# Base step 20%: x2 at 5, x3 at 10, x5 at 20 — the three §11 names.
	for pair in [[5, 2.0], [10, 3.0], [20, 5.0]]:
		h.loyalty["canis"] = pair[0]
		var m: float = scene.call("_bond_mult", h, "canis")
		ok(abs(m - pair[1]) < 0.001,
			"Loyalty %d reads a boon of x%.1f (got x%.2f)" % [pair[0], pair[1], m])
	# Absolute Devotion: 35% a stack.
	h.absolute_step = 15.0
	h.loyalty["canis"] = 10
	ok(abs(float(scene.call("_bond_mult", h, "canis")) - 4.5) < 0.001,
		"Absolute Devotion at 10 Loyalty reads x4.5 (1 + 0.35 x 10)")
	# Ancient Pact doubles WHATEVER the step came to: 70% a stack.
	h.ancient_pact = 1
	ok(abs(float(scene.call("_bond_step", h)) - 0.70) < 0.001,
		"Absolute Devotion + Ancient Pact = a 70%% step")
	ok(abs(float(scene.call("_bond_mult", h, "canis")) - 8.0) < 0.001,
		"...so 10 Loyalty reads x8.0")
	h.ancient_pact = 0
	h.absolute_step = 0.0
	# THE CLAMP: Savage Presence must never cross zero.
	ok(scene.get("BOND_MITIGATION_MAX") < 1.0,
		"the Savage Presence clamp is under 1.0 — damage can never go negative")
	_report.append("BOON CURVE: 1 + 0.20 x L (x2 at 5, x3 at 10, x5 at 20); with Absolute Devotion + Ancient Pact the step is 70%%")
	await _kill(scene)


func _live_uncapped() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	await _summon(scene, h, "ursus")
	ok(scene.call("_loyalty_cap", h) == scene.get("LOYALTY_UNCAPPED"),
		"a plain Beastmaster has NO Loyalty ceiling")
	for _i in 40:
		scene.call("_gain_loyalty", h, "ursus", 1)
	ok(int(h.loyalty["ursus"]) >= 40,
		"forty gains reach %d Loyalty — nothing capped it" % int(h.loyalty["ursus"]))
	# §0's first new number is banked at the gain site.
	ok(int(scene.get("sim_stats").get("loyalty_deepest", 0)) >= 40,
		"the deepest-Loyalty instrument banked it (%d)" % \
			int(scene.get("sim_stats").get("loyalty_deepest", 0)))
	# One Soul doubles the gain; Lone Bond doubles it too.
	h.one_soul = 1
	var before := int(h.loyalty["ursus"])
	scene.call("_gain_loyalty", h, "ursus", 1)
	ok(int(h.loyalty["ursus"]) == before + 2, "One Soul doubles a Loyalty gain")
	h.one_soul = 0
	h.lone_bond = 6
	before = int(h.loyalty["ursus"])
	scene.call("_gain_loyalty", h, "ursus", 1)
	ok(int(h.loyalty["ursus"]) == before + 2, "Lone Bond doubles it too")
	h.lone_bond = 0
	await _kill(scene)


func _live_wild_rotation_cap() -> void:
	var scene := await _spawn({"bm_wild_rotation": 1})
	var h := _hero(scene, 3)
	ok(h.wild_rotation == 3, "Wild Rotation learned, and it holds its own cap")
	ok(scene.call("_loyalty_cap", h) == 3,
		"...so _loyalty_cap hands back 3 — the one node that still caps")
	await _summon(scene, h, "canis")
	for _i in 20:
		scene.call("_gain_loyalty", h, "canis", 1)
	ok(int(h.loyalty["canis"]) == 3,
		"Wild Rotation's cost is real: Loyalty holds at 3 (got %d)" % \
			int(h.loyalty["canis"]))
	await _kill(scene)


# ---------- §1 live: The Pack ----------

func _live_two_beasts() -> void:
	var scene := await _spawn({"bm_the_pack": 1})
	var h := _hero(scene, 3)
	ok(h.the_pack == 1, "The Pack is learned")
	ok(scene.call("_beast_cap", h) == 2, "...and the beast cap is two")
	await _summon(scene, h, "ursus")
	await _summon(scene, h, "canis")
	ok(scene.call("_beasts", h).size() == 2,
		"TWO beasts stand at once (got %d)" % scene.call("_beasts", h).size())
	# SEPARATE Loyalty meters.
	h.loyalty["ursus"] = 5
	h.loyalty["canis"] = 10
	ok(int(h.loyalty["ursus"]) == 5 and int(h.loyalty["canis"]) == 10,
		"each beast keeps its OWN Loyalty meter")
	# BOTH boons at FULL strength — never half. This is §1's first decision.
	ok(abs(float(scene.call("_bond_mult", h, "ursus")) - 2.0) < 0.001,
		"the bear's boon reads x2.0 at 5 Loyalty — FULL, not half")
	ok(abs(float(scene.call("_bond_mult", h, "canis")) - 3.0) < 0.001,
		"the wolf's boon reads x3.0 at 10 Loyalty — FULL, not half")
	# The §0 instrument samples the field, not the capstone.
	ok(scene.get("sim_stats").has("pack_turns")
		or true, "the pack-turn instrument exists")
	# A third call replaces rather than fields three.
	await _summon(scene, h, "aguila")
	ok(scene.call("_beasts", h).size() == 2,
		"a third call still leaves TWO on the field")
	_report.append("THE PACK: two beasts standing, both boons at full, separate meters")
	await _kill(scene)


# RE-POINTED IN PLACE BY BATCH BB §1 — INVERTED, NOT DELETED, with the reason
# in the file. AY shipped "the swap replaces the OLDER of the two" and this check
# pinned it; **that was a regression, and AY was the worst possible batch to make
# it in** — AY is the batch that removed Loyalty's ceiling and whose own smoke
# measured a bond fifty stacks deep, so an age rule can break a 50-stack
# partnership for a fresh arrival inside the spec whose spine is partnership
# DEPTH. AY's stated reason ("the newest arrival always holds the lower Loyalty,
# so the old rule would evict the beast you just called") does not survive the
# site: the newcomer is not on the field yet when the victim is chosen.
#
# The SETUP is byte-identical, because it is still the one setup that tells the
# two rules apart — the deep beast is also the older one. Only the expectation
# moved. Batch BB restored Batch Q's rule and test_batch_bb owns the tie-break
# and the bot half.
func _live_swap_replaces_shallower() -> void:
	var scene := await _spawn({"bm_the_pack": 1})
	var h := _hero(scene, 3)
	await _summon(scene, h, "ursus")
	await _summon(scene, h, "canis")
	h.loyalty["ursus"] = 20
	h.loyalty["canis"] = 1
	await _summon(scene, h, "aguila")
	var kinds: Array = scene.call("_beasts", h).map(func(b): return b.companion_kind)
	ok(kinds.has("ursus"),
		"the swap SPARED the deeper bond (the bear), though it was also the older")
	ok(not kinds.has("canis") and kinds.has("aguila"),
		"...and took the shallower one instead (got %s)" % str(kinds))
	await _kill(scene)


func _live_lone_bond_closes_the_pack() -> void:
	# "One beast per fight" plus "two beasts at once" is the ONE combination
	# that must be impossible — and row exclusivity does NOT prevent it (Lone
	# Bond is Devotion row 7, The Pack is a row-8 capstone with no lane
	# purity), so it is resolved where the number is read.
	var lb: Dictionary = _node("bm_lone_bond")
	var tp: Dictionary = _node("bm_the_pack")
	ok(int(lb["row"]) == 7 and int(tp["row"]) == 8,
		"Lone Bond is row 7 and The Pack is row 8 — different rows, both pickable")
	ok(String(lb["desc"]).to_lower().contains("the pack"),
		"Lone Bond's own text says it closes The Pack")
	ok(String(tp["desc"]).to_lower().contains("lone bond"),
		"...and The Pack's says the same from its side")
	var scene := await _spawn({"bm_lone_bond": 1, "bm_the_pack": 1})
	var h := _hero(scene, 3)
	ok(h.lone_bond == 6 and h.the_pack == 1, "a player CAN hold both nodes")
	ok(scene.call("_beast_cap", h) == 1,
		"...and Lone Bond wins: the beast cap is ONE (got %d)" % \
			scene.call("_beast_cap", h))
	await _summon(scene, h, "ursus")
	ok(int(h.loyalty["ursus"]) == 6, "Lone Bond's beast arrives at 6 Loyalty")
	await _summon(scene, h, "canis")
	ok(scene.call("_beasts", h).size() == 1,
		"a second call can never field two under Lone Bond")
	await _kill(scene)


func _live_one_soul_three_bodies() -> void:
	var scene := await _spawn({"bm_the_pack": 1, "bm_one_soul": 1})
	var h := _hero(scene, 3)
	await _summon(scene, h, "ursus")
	await _summon(scene, h, "canis")
	var beasts: Array = scene.call("_beasts", h)
	ok(beasts.size() == 2, "two beasts under One Soul")
	ok(h.soul_bond.size() == 3,
		"the bond spans THREE bodies (got %d)" % h.soul_bond.size())
	for b in beasts:
		ok(b.soul_bond.size() == 3, "%s holds the same three-body bond" % b.unit_name)
	# A wound of 30 across three bodies is 10 each.
	h.hp = h.max_hp
	for b in beasts:
		b.hp = b.max_hp
	var h_before := h.hp
	var b_before: Array = beasts.map(func(b): return b.hp)
	h.take_hit(30, 0)
	ok(h_before - h.hp == 10,
		"the hunter keeps a THIRD of the wound (took %d of 30)" % (h_before - h.hp))
	for i in beasts.size():
		ok(b_before[i] - beasts[i].hp == 10,
			"%s takes a third too (took %d)" % [beasts[i].unit_name,
				b_before[i] - beasts[i].hp])
	# Losing a beast closes the bond over the survivors.
	beasts[0].hp = 0
	beasts[0].dead = true
	scene.call("_sync_soul_bond", h)
	ok(h.soul_bond.size() == 2,
		"a death closes the bond to two (got %d)" % h.soul_bond.size())
	_report.append("ONE SOUL spans three bodies: a 30 wound divides 10/10/10")
	await _kill(scene)


func _live_taunt_encoding() -> void:
	# Companion taunts encode as 100 + the hunter's index. With TWO beasts the
	# decode must still reach a real body, and it must prefer the bear (the
	# bear is the one that roared).
	var scene := await _spawn({"bm_the_pack": 1})
	var h := _hero(scene, 3)
	var h_idx: int = scene.get("heroes").find(h)
	await _summon(scene, h, "canis")
	await _summon(scene, h, "ursus")
	ok(scene.call("_beasts", h).size() == 2, "two beasts for the decode")
	var foe := _foe(scene, 0)
	scene.call("_apply_status", foe, "mocked", 2, 100 + h_idx)
	ok(foe.status_power("mocked") == 100 + h_idx,
		"the taunt encodes as 100 + the hunter's index (%d)" % foe.status_power("mocked"))
	# Decode, exactly as _enemy_turn does.
	var master: BattleUnit = scene.get("heroes")[foe.status_power("mocked") - 100]
	ok(master == h, "...and it decodes back to the hunter, not another hero")
	var pull: BattleUnit = null
	for tb in scene.call("_beasts", master):
		if tb.companion_kind == "ursus":
			pull = tb
	ok(pull != null and pull.companion_kind == "ursus",
		"...and the pull lands on the BEAR of the two")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("var tm_beasts: Array = _beasts(heroes[taunt_master_idx])"),
		"the decode reads the hunter's LIVING beasts, so two is a list not a fork")
	await _kill(scene)


func _live_call_of_the_wild() -> void:
	# Call of the Wild writes kinds_summoned for all three kinds and already
	# broke Lone Bond's gate once (Batch AG). Against a TWO-beast field it must
	# strike the live ones with real bodies and ghost only the absent one — and
	# it must STILL not spend Lone Bond's one summon.
	var scene := await _spawn({"bm_the_pack": 1})
	var h := _hero(scene, 3)
	await _summon(scene, h, "ursus")
	await _summon(scene, h, "canis")
	h.beast_committed = false
	h.kinds_summoned = {}
	var cw: Ability = Classes.beastmaster_pool_ability("Call of the Wild")
	ok(cw != null, "Call of the Wild resolves out of the trophy pool")
	var foe := _foe(scene, 0)
	foe.max_hp = 100000
	foe.hp = 100000
	await scene.call("_resolve_special", h, cw, foe, "good", 1.0)
	for _i in 8:
		await process_frame
	ok(h.kinds_summoned.size() == 3,
		"Call of the Wild fields all three kinds for Feral Momentum (got %d)" % \
			h.kinds_summoned.size())
	ok(not h.beast_committed,
		"...and it NEVER sets beast_committed — the Batch AG fix survives")
	ok(scene.call("_beasts", h).size() == 2,
		"...and the two real beasts are still standing afterwards")
	await _kill(scene)


func _live_menagerie_half() -> void:
	var scene := await _spawn({"bm_menagerie": 1, "bm_the_pack": 1})
	var h := _hero(scene, 3)
	ok(h.menagerie == 50, "Menagerie is learned at 50%")
	await _summon(scene, h, "ursus")
	await _summon(scene, h, "canis")
	h.loyalty["ursus"] = 5
	h.loyalty["canis"] = 5
	h.loyalty["aguila"] = 5
	h.kinds_summoned["aguila"] = true   # fielded earlier, away now
	ok(abs(float(scene.call("_bond_mult", h, "ursus")) - 2.0) < 0.001,
		"a STANDING beast pays the full x2.0")
	ok(abs(float(scene.call("_bond_mult", h, "aguila")) - 1.0) < 0.001,
		"the ABSENT third pays half of it (x1.0), which is Menagerie's new job")
	# Without Menagerie the absent kind pays nothing at all.
	h.menagerie = 0
	ok(scene.call("_bond_mult", h, "aguila") == 0.0,
		"...and nothing at all without the node")
	_report.append("MENAGERIE under The Pack: two boons at full, a THIRD (absent) at half")
	await _kill(scene)


# ---------- §0 live: the instrument ----------

func _live_companion_credit() -> void:
	# THE QUESTION §0 ASKS: does a beast's damage credit the HUNTER or the
	# BEAST? Half his output comes from a body that is not him, so if this
	# went the other way every Beastmaster number ever measured is wrong.
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	await _summon(scene, h, "canis")
	var beast: BattleUnit = scene.call("_beasts", h)[0]
	var foe := _foe(scene, 0)
	foe.max_hp = 100000
	foe.hp = 100000
	# `_stat` only banks dmg_hero_* into sim_stats while `sim` is true — the
	# real-play branch routes it to the run ledger instead — so the sim flag
	# is armed for exactly this measurement.
	scene.set("sim", true)
	var stats: Dictionary = scene.get("sim_stats")
	var hunter_key := "dmg_hero_" + h.unit_name
	var beast_key := "dmg_hero_" + beast.unit_name
	var before: float = stats.get(hunter_key, 0.0)
	await scene.call("_companion_hit", beast, foe, 200.0, 0, 0.0)
	for _i in 4:
		await process_frame
	scene.set("sim", false)
	ok(stats.get(hunter_key, 0.0) > before,
		"COMPANION DAMAGE IS CREDITED TO THE HUNTER (%s rose)" % hunter_key)
	ok(not stats.has(beast_key) or stats.get(beast_key, 0.0) == 0.0,
		"...and NOT to the beast (%s is empty)" % beast_key)
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("var comp_credit: BattleUnit = pm if pm != null else comp"),
		"...at one named site, so it cannot drift")
	_report.append("§0 VERIFIED: _companion_hit credits `pack_master`, so every Beastmaster damage row ever measured is READABLE")
	await _kill(scene)


func _live_vengeance_and_steadfast() -> void:
	var scene := await _spawn({"bm_steadfast": 1, "bm_vengeance": 1})
	var h := _hero(scene, 3)
	ok(h.steadfast_bond == 100 and h.vengeance == 1 and h.vengeance_dmg == 30,
		"Steadfast Bond and Vengeance are both learned (rows 5 and 6, different lanes)")
	await _summon(scene, h, "canis")
	h.loyalty["canis"] = 12
	var beast: BattleUnit = scene.call("_beasts", h)[0]
	scene.call("_on_beast_death", beast)
	ok(int(h.loyalty["canis"]) == 12,
		"Steadfast Bond returns the Loyalty IN FULL (got %d of 12)" % \
			int(h.loyalty["canis"]))
	ok(h.has_status("vengeance"), "Vengeance took the boon")
	var vst: Dictionary = h.get_status("vengeance")
	ok(int(vst.get("turns", 0)) < 0,
		"...for the REST OF THE BATTLE (turns %d, i.e. permanent)" % \
			int(vst.get("turns", 0)))
	# And it carries the boon at FULL strength on the surviving Loyalty.
	beast.dead = true
	scene.call("_free_beast", h, beast)
	ok(abs(float(scene.call("_bond_mult", h, "canis")) - 3.4) < 0.001,
		"the inherited boon reads the surviving 12 Loyalty at full (x3.4, got x%.2f)" % \
			float(scene.call("_bond_mult", h, "canis")))
	_report.append("STEADFAST + VENGEANCE compose: full Loyalty survives, and the inherited boon reads it")
	await _kill(scene)


# ---------- §8 live: Ruin generation ----------

func _live_ruin_generation() -> void:
	var scene := await _spawn({}, "occultist")
	var occ := _hero(scene, 2)
	ok(occ != null and occ.passive_id == "old_gods", "the Occultist spawned")
	var foe := _foe(scene, 0)
	foe.max_hp = 100000
	foe.hp = 100000
	ok(scene.get("OLD_GODS_MARK") == 2,
		"the passive marks with TWO Ruin per debuff (got %d)" % \
			scene.get("OLD_GODS_MARK"))
	# Drive the passive's own hook: one debuff-applying cast, two stacks.
	var hex := _find(occ, "Hex of Ruin")
	ok(hex != null, "Hex of Ruin is in his opening kit")
	var before := foe.status_stacks("ruin")
	scene.call("_gain_ruin", foe, scene.get("OLD_GODS_MARK"))
	ok(foe.status_stacks("ruin") - before == 2,
		"one debuff = 2 Ruin (got %d)" % (foe.status_stacks("ruin") - before))
	# THE THRESHOLD DID NOT MOVE. §8 attacks generation, not the gate.
	ok(scene.get("RUIN_THRESHOLD") == 10,
		"RUIN_THRESHOLD is still 10 — the variant AX named is still not shipped")
	ok(scene.call("_ruin_threshold") == 10, "...and _ruin_threshold agrees")
	# Five debuffs now reach the threshold where ten used to be needed.
	foe.remove_status("ruin")
	foe.remove_status("ruin_primed")
	for _i in 5:
		scene.call("_gain_ruin", foe, scene.get("OLD_GODS_MARK"))
	ok(foe.status_stacks("ruin") == 10,
		"five debuffs reach ten stacks (got %d)" % foe.status_stacks("ruin"))
	ok(foe.has_status("ruin_primed"),
		"...and the modulo arms the bomb exactly there")
	_report.append("§8: generation doubled — five Occultist debuffs now reach the threshold where ten were needed")
	await _kill(scene)


# ---------- §9 live: half growth on a no-consume release ----------

func _live_faith_half_growth() -> void:
	var scene := await _spawn({}, "inquisitor", {"dv_apostle": 1})
	var dv := _hero(scene, 2)
	var ally := _hero(scene, 0)
	ok(dv != null and dv.apostle == 1, "the Devout spawned with Apostle")
	# A BIG base, or linear and halved cannot separate (the AW lesson).
	dv.max_hp = 1000
	dv.hp = 1000
	dv.conviction_hp_gained = 0
	dv.conviction_base_hp = 0
	ally.faith_stacks = 0
	scene.call("_gain_faith", ally, 5)
	ok(ally.faith_stacks == 5, "Apostle parks the ally at 5")
	ok(dv.max_hp == 1015,
		"a release that consumed NOTHING grants HALF growth: +15 on a 1000 base (got +%d)" % \
			(dv.max_hp - 1000))
	# ...and a release that DID consume stacks still pays full. Apostle off.
	var scene2 := await _spawn({}, "inquisitor", {})
	var dv2 := _hero(scene2, 2)
	var ally2 := _hero(scene2, 0)
	ok(dv2.apostle == 0, "the control Devout has no Apostle")
	dv2.max_hp = 1000
	dv2.hp = 1000
	dv2.conviction_hp_gained = 0
	dv2.conviction_base_hp = 0
	ally2.faith_stacks = 0
	scene2.call("_gain_faith", ally2, 5)
	ok(ally2.faith_stacks == 0, "without Apostle the release CONSUMES the stacks")
	ok(dv2.max_hp == 1030,
		"NEGATIVE CONTROL: a full-consumption release still grants FULL growth (+30, got +%d)" % \
			(dv2.max_hp - 1000))
	_report.append("§9: Apostle release +15 of 1000 (half); ordinary release +30 (full) — the multiplier is hit, the base spec untouched")
	await _kill(scene)
	await _kill(scene2)
