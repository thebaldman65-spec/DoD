# test_batch_ba.gd — THE SURVIVALIST: ATTRITION THROUGH CRAFT. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ba.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins:
#   §1 THE CONTAGION SPACE IS RESERVED: nothing in his tree, his abilities or
#      his read sites spreads on its own — no enemy-to-enemy transmission, no
#      transfer from a corpse, no field-wide infection.
#   §2 EACH VENOM NODE HANGS A DIFFERENT AFFLICTION off the poison: Coated
#      Blades' Cripple, Distillate's Exposed, Slow Acting's Slowed, and the
#      Trapper count rising as they land.
#   §3 THE TREE: 24 ids, 7/7/7 + 3 capstones, every final magnitude on the node
#      that owes it, every counter ADDITIVE at its read site.
#   §3 Creeping Death REFRESHES rather than transfers; Quartermaster poisons
#      from an ALLY'S attack and credits HIM; Perfected Toxin survives a dispel
#      and its tick rises.
#   §4 BOTH NAMED PAIRS ARE GONE — and every surviving prose pair in CLAUDE.md
#      is one row exclusivity already enforces.
#   §5 THE TROPHY-POOL COLLISION CANNOT ARISE: no Survivalist node grants an
#      ability, so he owes no AU §1 fallback in either direction.
#   §6 the four spec runes re-pointed onto live counters in the new units, the
#      three Hunter class-wide runes touching none of them, and NO rune riding
#      a counter whose MEANING changed.
#   §7 HARVEST PAYS FOR WHAT IT REMOVED — sticky poison survives the purge and
#      is not billed for.
#   §8 THE BOT: breadth before depth, and Harvest reading the same yield the
#      ability is paid on.
#   NEGATIVE CONTROLS for the four that would fail silently: Creeping Death
#      still firing on death, Perfected Toxin poisoning the whole field at
#      battle start, Harvest counting sticky poison it did not remove, and
#      Quartermaster's poison being credited to the ally rather than to him.
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
	Profile.save_path = "user://profile_batch_ba_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_magnitudes()
	_additive_units()
	_contagion_reserved()
	_no_ability_grants()
	_rune_audit()
	_meaning_changed_audit()
	_bot_policy_source()
	_exclusive_pairs()
	_docs()
	_negative_control_source()

	await _live_carriers()
	await _live_slow_acting()
	await _live_breadth_rises()
	await _live_creeping_refresh()
	await _live_quartermaster()
	await _live_perfected_toxin()
	await _live_harvest_count()
	await _live_trap_cap()
	await _live_quick_rigging()
	await _live_snares_magnitudes()
	await _live_guerilla_magnitudes()

	if FileAccess.file_exists("user://profile_batch_ba_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ba_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	for line in _report:
		print("  REPORT: %s" % line)
	print("test_batch_ba: %d checks / %d failures" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: %s" % f)
	quit(1 if fails.size() > 0 else 0)


# ---------- helpers ----------

func _tree() -> Array:
	return Talents.generate_tree("mystic", "hunter")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


func _payload(id: String) -> Dictionary:
	return _node(id).get("payload", {})


func _stat_of(id: String, field: String):
	return _payload(id).get("stat", {}).get(field, null)


func _hero(scene: Node, idx: int) -> BattleUnit:
	var hs: Array = scene.get("heroes")
	return hs[idx] if idx < hs.size() else null


# The Survivalist sits in the HUNTER slot (index 3). His spec id is "mystic"
# and must never be renamed — saves and trees key on it.
func _spawn(learned: Dictionary, lineup := ["raider", "raider"]) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "inquisitor", "mystic"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 3 else {}
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
	# Determinism FORCED, not retried (the AK/AL/AR/AS/AT/AU/AV/AW/AX/AY/AZ
	# discipline). A driven _resolve still rolls miss, parry AND crit.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	return scene


func _rune_pool() -> Dictionary:
	var pool := {}
	for rid in Runes.ids():
		pool[rid] = Runes.config(rid)
	return pool


func _kill(scene: Node) -> void:
	scene.queue_free()
	# queue_free is DEFERRED (the AS gotcha) — give it a frame before the next
	# spawn, or two battle scenes briefly share the tree.
	await process_frame
	await process_frame


# ---------- §3 the tree's shape ----------

const IDS := ["sv_potent", "sv_coated", "sv_virulence", "sv_slow_acting",
	"sv_creeping", "sv_necrosis", "sv_plague",
	"sv_wire", "sv_rigging", "sv_cruel", "sv_snap_shut", "sv_caught",
	"sv_bone", "sv_network",
	"sv_woodcraft", "sv_hitrun", "sv_scavenger", "sv_medic", "sv_vulture",
	"sv_ghillie", "sv_improvised",
	"sv_epidemic", "sv_forest", "sv_force"]


func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 24, "the Survivalist tree holds 24 nodes (got %d)" % tree.size())
	var by_lane := {"Venom": 0, "Snares": 0, "Guerilla": 0}
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
		ok(not t.has("exclusive_with"),
			"%s carries no stale exclusive_with — rows do the barring" % id)
	ok(caps == 3, "three capstones (got %d)" % caps)
	for lane in by_lane:
		ok(by_lane[lane] == 7, "%s holds 7 rows (got %d)" % [lane, by_lane[lane]])
	# §10: EVERY ONE OF THE 24 IDS SURVIVES AND RE-SPECS IN PLACE. This is what
	# lets a saved tree migrate without a save version move.
	for id in IDS:
		ok(seen.has(id), "id %s survives the re-author" % id)
	ok(seen.size() == IDS.size(),
		"no id was added or dropped (got %d, expected %d)" % [seen.size(), IDS.size()])
	# The three lane names STAND — only what Venom's nodes DO was re-aimed.
	for lane in ["Venom", "Snares", "Guerilla"]:
		ok(by_lane.has(lane), "the lane %s still exists" % lane)


# ---------- §3 the magnitudes, on the node that owes each one ----------

func _magnitudes() -> void:
	# Venom
	ok(_stat_of("sv_potent", "potent_ranks") == 8, "Potent Toxins pays 8 flat per stack")
	ok(_stat_of("sv_coated", "coated_blades") == 1, "Coated Blades is a FLAG, not an amount")
	ok(_stat_of("sv_virulence", "virulence_ranks") == 2, "Distillate adds 2 extra stacks")
	ok(_stat_of("sv_slow_acting", "slow_acting") == 1, "Slow Acting is a FLAG")
	ok(_stat_of("sv_creeping", "creeping_death") == 1, "Creeping Death is a FLAG")
	ok(_stat_of("sv_necrosis", "necrosis") == 35, "Necrosis pays 35 percentage points")
	ok(_stat_of("sv_plague", "quartermaster") == 1, "Quartermaster is a FLAG")
	# Snares
	ok(_stat_of("sv_wire", "wire_ranks") == 35, "Reinforced Wire pays 35 percentage points")
	ok(_stat_of("sv_rigging", "quick_rigging") == 2, "Quick Rigging carries its own 2")
	ok(_stat_of("sv_cruel", "cruel_ranks") == 50, "Cruel Devices pays 50 percentage points")
	ok(_stat_of("sv_snap_shut", "snap_shut") == 1, "Snap Shut is a BYPASS, not a magnitude")
	ok(_stat_of("sv_caught", "caught_fast") == 5, "Caught Fast holds 5 turns")
	ok(_stat_of("sv_bone", "bone_breaker") == 90, "Bone Breaker holds 90 Break damage")
	ok(_stat_of("sv_network", "deadfall_network") == 3,
		"Deadfall Network holds the CAP it installs — gate and magnitude in one field")
	# Guerilla
	ok(abs(float(_stat_of("sv_woodcraft", "max_hp_pct")) - 0.20) < 0.0001,
		"Woodcraft pays 20% maximum Health")
	ok(_stat_of("sv_hitrun", "hit_and_run") == 2, "Hit and Run holds 2 turns of Elusive")
	ok(_stat_of("sv_scavenger", "scavenger_ranks") == 25, "Scavenger pays 25 percentage points")
	ok(_stat_of("sv_medic", "field_medic") == 2, "Field Medic holds a COUNT of 2")
	ok(_stat_of("sv_vulture", "vulture") == 60, "Vulture pays 60 percentage points")
	ok(_stat_of("sv_ghillie", "ghillie") == 65, "Ghillie Suit holds a 65% chance")
	ok(_stat_of("sv_improvised", "improvised") == 2, "Improvised holds a COUNT of 2")
	# Row 8
	ok(_stat_of("sv_epidemic", "perfected_toxin") == 2,
		"Perfected Toxin holds the per-turn rise — gate and magnitude in one field")
	ok(_stat_of("sv_forest", "whole_forest") == 1, "The Whole Forest is unchanged")
	ok(_stat_of("sv_force", "force_of_nature") == 20,
		"Force of Nature carries its percentage rather than deriving it from a flag")
	# THE TOOLTIP IS THE OTHER PLACE THE DESIGN NUMBER APPEARS. A magnitude that
	# lives only in a payload can drift from the text that sells it.
	var pairs := {"sv_potent": "+8", "sv_virulence": "+2", "sv_necrosis": "+35%",
		"sv_wire": "+35%", "sv_rigging": "by 2", "sv_cruel": "+50%",
		"sv_caught": "5 turns", "sv_bone": "90 Break", "sv_network": "THREE",
		"sv_woodcraft": "+20%", "sv_hitrun": "2 turns", "sv_scavenger": "25%",
		"sv_medic": "2 debuffs", "sv_vulture": "+60%", "sv_ghillie": "65%",
		"sv_improvised": "first 2", "sv_epidemic": "by 2", "sv_force": "+20%"}
	for id in pairs:
		var shown := Talents.desc_for(_node(id), 1)
		ok(shown.contains(String(pairs[id])),
			"%s's tooltip renders its magnitude (%s not in \"%s\")" % [
				id, pairs[id], shown])
	# The two renames, in the data rather than in a comment.
	ok(String(_node("sv_virulence")["name"]) == "Distillate",
		"sv_virulence carries Distillate — the mechanic kept, the pathogen name gone")
	ok(String(_node("sv_plague")["name"]) == "Quartermaster",
		"sv_plague carries Quartermaster")
	ok(String(_node("sv_epidemic")["name"]) == "Perfected Toxin",
		"sv_epidemic carries Perfected Toxin")
	ok(String(_node("sv_creeping")["name"]) == "Creeping Death",
		"sv_creeping KEEPS its name — it is a re-spec, not a replacement")
	ok(String(_node("sv_necrosis")["name"]) == "Necrosis",
		"Necrosis keeps its name: tissue death from venom is craft, not contagion")


# ---------- §6 every counter is ADDITIVE at its READ SITE ----------
#
# The payload half is checked above; this is the other half, and it is the one
# that fails silently. A counter carrying 35 into a read site that still
# multiplies by 0.10 pays 350%, and nothing crashes.

func _additive_units() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var must := {
		"0.01 * fn_h.force_of_nature * sv_n": "Force of Nature reads percentage points",
		"0.01 * attacker.vulture": "Vulture reads percentage points",
		"0.01 * nec_h.necrosis": "Necrosis reads percentage points (hero strikes)",
		"0.01 * nec_c.necrosis": "Necrosis reads percentage points (companion jaws)",
		"0.01 * trapper.wire_ranks": "Reinforced Wire reads percentage points",
		"0.01 * trapper.cruel_ranks": "Cruel Devices reads percentage points (tripwire)",
		"0.01 * placer.cruel_ranks": "Cruel Devices reads percentage points (traps)",
		"0.01 * sc_h.scavenger_ranks": "Scavenger reads percentage points",
		"0.01 * target.ghillie": "Ghillie Suit reads its own chance",
		"maxi(u.deadfall_network, 1)": "the trap gate reads the counter, not a hardcoded 2",
		"placer.bone_breaker)": "Bone Breaker's Break damage comes off the counter",
		"placer.caught_fast)": "Caught Fast's duration comes off the counter",
		"_apply_status(src, \"elusive\", src.hit_and_run)":
			"Hit and Run's duration comes off the counter",
	}
	for needle in must:
		ok(src.contains(needle), "%s (missing: %s)" % [must[needle], needle])
	# ...and the OLD units are gone. A leftover would keep paying the old rate
	# from a second site while the new one looks correct.
	var gone := ["0.10 * trapper.wire_ranks", "0.15 * trapper.cruel_ranks",
		"0.15 * placer.cruel_ranks", "0.08 * sc_h.scavenger_ranks",
		"raw *= 1.30", "raw *= 1.20",
		"target.ghillie > 0 and randf() < 0.40",
		"victim.take_hit(0, 30)", "attacker.take_hit(0, 30)",
		"_apply_status(attacker, \"caught\", 3)",
		"_apply_status(victim, \"caught\", 3)"]
	for needle in gone:
		ok(not src.contains(needle),
			"the pre-BA unit is gone from battle.gd (still present: %s)" % needle)


# ---------- §1 the contagion space is RESERVED ----------
#
# The four nodes that occupied it are re-specced, and the rule is recorded in
# CLAUDE.md as a STANDING DESIGN RULE rather than as four edits — without that,
# a later batch re-adds "spreads to another enemy" innocently and spends the
# reserved spec's idea a second time.

func _contagion_reserved() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# Nothing in his tree names the retired designs.
	for t in _tree():
		var text := String(t["name"]) + " " + String(t["desc"])
		for banned in ["Epidemic", "Plague Bearer", "Virulence", "spreads", "leaps",
				"transfer", "Every enemy"]:
			ok(not text.contains(banned),
				"%s's node text carries nothing self-propagating (found \"%s\")" % [
					t["id"], banned])
	# The three read sites are gone, not merely unreachable.
	for needle in ["u.plague_bearer", "ep_h.epidemic", "Plague Bearer: the rot leaps",
			"Creeping Death: the rot crawls", "Epidemic: every enemy is already rotting"]:
		ok(not src.contains(needle),
			"the retired site is DELETED, not left gated (still present: %s)" % needle)
	# The fields themselves no longer exist, so a later batch cannot write one.
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(not usrc.contains("var plague_bearer"),
		"BattleUnit has no plague_bearer field — the concept is gone, not renamed in place")
	ok(not usrc.contains("var epidemic"),
		"BattleUnit has no epidemic field")
	ok(usrc.contains("var quartermaster"), "...and quartermaster exists in its place")
	ok(usrc.contains("var perfected_toxin"), "...and perfected_toxin exists in its place")
	# The standing rule, in the file a later batch actually reads.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("CONTAGION"),
		"CLAUDE.md records the reservation as a standing design rule")
	ok(cm.to_lower().contains("self-propagating"),
		"...and names what is off-limits, so a later batch cannot re-add it innocently")
	# SNARES and GUERILLA were never disease and are untouched by the rule.
	ok(String(_node("sv_snap_shut")["desc"]).contains("RANGED"),
		"Snap Shut is untouched by §1")
	ok(String(_node("sv_forest")["desc"]).contains("Tripwire"),
		"The Whole Forest is untouched by §1")


# ---------- §5 the trophy-pool collision cannot arise ----------

func _no_ability_grants() -> void:
	# ASSERTED BOTH WAYS, the AY/AZ discipline: no node carries a grant, AND a
	# fully-learned tree adds nothing to the ability list.
	for t in _tree():
		var p: Dictionary = t.get("payload", {})
		ok(not p.has("new_ability"),
			"%s grants no ability inline" % t["id"])
		ok(not p.has("grant_ability"),
			"%s grants no ability by name" % t["id"])
		ok(Talents.granted_name(p) == "",
			"%s reports no granted name" % t["id"])
	var learned := {}
	for id in IDS:
		learned[id] = 1
	var bare := {"key": "hunter", "spec": "mystic", "tree": _tree(),
		"talents": {}, "bm_abilities": []}
	var full := {"key": "hunter", "spec": "mystic", "tree": _tree(),
		"talents": learned, "bm_abilities": []}
	var before: Array = Talents.ability_names(bare)
	var after: Array = Talents.ability_names(full)
	ok(after.size() == before.size(),
		"a fully-learned Survivalist tree adds NOTHING to the ability list (%d -> %d)" % [
			before.size(), after.size()])
	for n in after:
		ok(before.has(n), "the learned tree introduced no new ability (%s)" % n)
	# His three kit pieces are base kit and his five earnables are the pool, so
	# no trophy can ever land on a node's grant.
	var pool: Array = Classes.SPEC_POOLS["mystic"]
	for n in ["Explosive Shot", "Venom Coating", "Hamstring", "Deadfall", "Harvest"]:
		ok(pool.has(n), "%s is boss-trophy pool, not a tree grant" % n)
	for n in ["Tripwire", "Shrapnel Charge", "Snare Trap"]:
		ok(not pool.has(n), "%s is base kit, not earnable" % n)
	_report.append("§5: the Survivalist owes NO AU §1 fallback in either direction — "
		+ "his tree grants no abilities at all. With this batch, EVERY spec's "
		+ "fallback ownership is recorded.")


# ---------- §6 the rune audit ----------

func _rune_audit() -> void:
	var pool := _rune_pool()
	var mystic: Array = []
	for id in pool:
		if String(pool[id].get("scope", "")) == "spec:mystic":
			mystic.append(id)
	mystic.sort()
	ok(mystic.size() == 4, "four spec:mystic runes (got %d)" % mystic.size())
	# EACH STILL PAYS EXACTLY WHAT ITS TEXT ADVERTISES — only the units moved.
	var lh: Dictionary = pool["long_hunt"]["payload"]["stat"]
	ok(int(lh["cruel_ranks"]) == 15, "the Long Hunt still pays +15% trap damage")
	ok(int(lh["wire_ranks"]) == 10, "the Long Hunt still pays 10% more of his Attack")
	ok(int(lh["potent_ranks"]) == 1,
		"the Long Hunt's +1 Poison damage per stack is UNTOUCHED — "
		+ "Potent Toxins kept its units, so nothing about this clause moved")
	var cw: Dictionary = pool["carrion_wake"]["payload"]["stat"]
	ok(int(cw["vulture"]) == 30, "the Carrion Wake still strikes 30% harder")
	ok(int(cw["scavenger_ranks"]) == 16, "the Carrion Wake still drinks 16% max Mana")
	ok(abs(float(cw["max_hp_pct"]) + 0.12) < 0.0001, "...and its scar is untouched")
	var ww: Dictionary = pool["weeping_wound"]["payload"]["stat"]
	ok(int(ww["potent_ranks"]) == 2, "the Weeping Wound still bites 2 harder per stack")
	ok(int(ww["coated_blades"]) == 1,
		"...and writes coated_blades as a FLAG, which is still what that field is")
	ok(pool["quick_spring"]["payload"].has("ability"),
		"the Quick Spring is an ability payload and needed no re-point")
	# Every rune-written counter still has a LIVE read site.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for f in ["potent_ranks", "cruel_ranks", "wire_ranks", "scavenger_ranks",
			"vulture", "coated_blades"]:
		ok(bsrc.contains(f), "the rune-written counter %s still has a read site" % f)
	# THE THREE HUNTER CLASS-WIDE RUNES TOUCH NO SURVIVALIST COUNTER.
	var sv_fields := ["potent_ranks", "coated_blades", "virulence_ranks",
		"slow_acting", "creeping_death", "necrosis", "quartermaster", "wire_ranks",
		"quick_rigging", "cruel_ranks", "snap_shut", "caught_fast", "bone_breaker",
		"deadfall_network", "hit_and_run", "scavenger_ranks", "field_medic",
		"vulture", "ghillie", "improvised", "perfected_toxin", "whole_forest",
		"force_of_nature"]
	var hunter_runes := 0
	for id in pool:
		if String(pool[id].get("scope", "")) != "class:hunter":
			continue
		hunter_runes += 1
		var st: Dictionary = pool[id].get("payload", {}).get("stat", {})
		for f in sv_fields:
			ok(not st.has(f),
				"the class:hunter rune %s touches no Survivalist counter (writes %s)" % [id, f])
	ok(hunter_runes == 3, "three class:hunter runes checked (got %d)" % hunter_runes)
	# THE FLOAT TRAP, BOTH WAYS (§6, per AZ).
	for f in ["vulture", "coated_blades", "necrosis", "quartermaster",
			"perfected_toxin", "force_of_nature", "deadfall_network"]:
		ok(Runes.STAT_INT_KEYS.has(f),
			"%s is an int field that does not end _ranks — it must be in STAT_INT_KEYS" % f)
	ok(not Runes.STAT_INT_KEYS.has("max_hp_pct"),
		"max_hp_pct is FRACTIONAL and must stay OUT of STAT_INT_KEYS")


# ---------- §6 the three counters whose MEANING changed ----------
#
# A rune riding one of these is not mis-scaled, it is pointed at something that
# no longer means what it meant — a harder failure than a wrong number, because
# the value still applies and nothing crashes.

func _meaning_changed_audit() -> void:
	var pool := _rune_pool()
	var homeless: Array = []
	for id in pool:
		var st: Dictionary = pool[id].get("payload", {}).get("stat", {})
		for f in ["plague_bearer", "epidemic", "creeping_death"]:
			if st.has(f):
				homeless.append("%s writes %s" % [id, f])
	ok(homeless.is_empty(),
		"NO rune rides a counter whose meaning changed (found: %s)" % [homeless])
	_report.append("§6: the audit came back CLEAN — no spec:mystic or class:hunter "
		+ "rune ever rode plague_bearer, epidemic or creeping_death, so nothing "
		+ "needed flagging for re-authoring. Recorded rather than assumed.")
	# And the replacement is not silently wearing the old one's clothes.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("Quartermaster is NOT Plague Bearer"),
		"the code says in as many words that Quartermaster is not a renamed Plague Bearer")


# ---------- §8 the bot ----------

func _bot_policy_source() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# BREADTH BEFORE DEPTH: the two breadth options are gated on the target
	# LACKING the status they would add.
	ok(src.contains("_ability_usable(u, snare) and not target_foe.has_status(\"snared\")"),
		"the bot skips a Snare on an already-snared mark")
	ok(src.contains("not (target_foe.has_status(\"slow\") and target_foe.has_status(\"exposed\"))"),
		"the bot skips a Hamstring whose two statuses are both already standing")
	# ...and depth is still reachable, LAST, once breadth has nothing to add.
	var snare_at := src.find("var snare := _find_ability(u, \"Snare Trap\")")
	var depth_at := src.find("# Depth last: another poison application only after")
	ok(snare_at > 0 and depth_at > snare_at,
		"the depth fallback sits BELOW the breadth options, not above them")
	# HARVEST READS THE SAME YIELD THE ABILITY IS PAID ON.
	ok(src.contains("_harvest_yield(target_foe) >= HARVEST_BOT_YIELD"),
		"the bot's Harvest threshold reads _harvest_yield, not a raw status count")
	ok(not src.contains("_status_count(target_foe) >= 4"),
		"the old raw-count threshold of 4 is gone")
	ok(src.contains("const HARVEST_BOT_YIELD := 3"),
		"the threshold is a named constant, shared with nothing that can disagree")


# ---------- §4 the exclusive pairs ----------

func _exclusive_pairs() -> void:
	# BOTH NAMED PAIRS GO. Virulence <-> Slow Acting dissolved on its own (rows
	# 3 and 4 of ONE lane, so row exclusivity lets a player hold both), and
	# Plague Bearer <-> Deadfall Network went with Plague Bearer.
	var v_row := int(_node("sv_virulence")["row"])
	var s_row := int(_node("sv_slow_acting")["row"])
	ok(v_row != s_row and String(_node("sv_virulence")["lane"]) \
			== String(_node("sv_slow_acting")["lane"]),
		"Distillate and Slow Acting sit in DIFFERENT rows of ONE lane — a player holds both")
	ok(int(_node("sv_plague")["row"]) == int(_node("sv_network")["row"]),
		"Quartermaster and Deadfall Network share row 7, so row exclusivity "
		+ "already enforces the choice and the pair needs no entry")
	# The prose list in CLAUDE.md must not name either.
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(not cm.contains("plague_bearer/deadfall") and not cm.contains("virulence/slow_acting"),
		"CLAUDE.md's prose pair list names neither retired pair")
	_report.append("§4: with this batch the prose exclusive-pair list is EMPTY. "
		+ "Every pair ever authored has either dissolved under Batch AI's row "
		+ "exclusivity or is a same-row pair row exclusivity already enforces. "
		+ "`test_runes._exclusives` has been a bare `pass` since AI.")


# ---------- §9 the documentation ----------

func _docs() -> void:
	var doc := FileAccess.get_file_as_string("res://docs/master.html")
	for banned in ["Plague Bearer", "Epidemic", "Virulence"]:
		ok(not doc.contains(banned),
			"master.html no longer documents %s" % banned)
	for wanted in ["Quartermaster", "Perfected Toxin", "Distillate"]:
		ok(doc.contains(wanted), "master.html documents %s" % wanted)
	ok(doc.contains("+8%") and doc.contains("DIFFERENT status effect"),
		"master.html still states Trapper's rate — the one ceiling that stays")
	ok(doc.contains("bounded by how many distinct debuffs exist"),
		"...and says WHY that ceiling is correct rather than an oversight")
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(not gloss.contains("Epidemic"),
		"the glossary's Poison entry no longer names Epidemic")
	ok(gloss.contains("Perfected Toxin"), "...and names Perfected Toxin instead")
	# The passive the player reads on the awakening screen and the hero sheet.
	var pd := String(Classes.SPEC_INFO["mystic"]["passive_desc"])
	ok(pd.contains("DIFFERENT status"), "the in-game passive text still names breadth")
	# The spec id is load-bearing and must never be renamed.
	ok(Classes.SPEC_INFO.has("mystic"),
		"the spec id is still \"mystic\" — saves and trees key on it")


# ---------- NEGATIVE CONTROLS, at the source ----------
#
# The four the batch named, each of which would fail SILENTLY: the code still
# runs, nothing logs an error, and the spec quietly becomes the one §1 forbids.

func _negative_control_source() -> void:
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# (1) Creeping Death still firing on death — the corpse transfer §1 reserves.
	ok(not bsrc.contains("_living_hero_with(\"creeping_death\") != null"),
		"NEG 1: no death-path site reads creeping_death any more")
	ok(bsrc.contains("func _creeping_refresh"),
		"...and the re-spec lives on the status-application path instead")
	var death_at := bsrc.find("func _on_enemy_death")
	var creep_at := bsrc.find("_creeping_refresh(target, id)")
	ok(creep_at > 0 and creep_at < death_at,
		"NEG 1: the Creeping Death hook is in _apply_status, not in _on_enemy_death")
	# (2) Perfected Toxin poisoning the whole field at battle start.
	ok(not bsrc.contains("for ep_e in enemies"),
		"NEG 2: no battle-start loop poisons the field")
	ok(not bsrc.contains("perfected_toxin > 0:\n\t\t\tfor "),
		"NEG 2: the capstone has no field-wide hook of its own")
	# (3) Harvest counting sticky poison it did not remove.
	ok(bsrc.contains("hv_n = maxi(hv_before - _status_count(target), 0)"),
		"NEG 3: Harvest's count is measured AFTER the purge, as a delta")
	ok(not bsrc.contains("var hv_n := _status_count(target)"),
		"NEG 3: the pre-purge count is gone")
	# (4) Quartermaster's poison credited to the ally rather than to him.
	ok(bsrc.contains("_apply_poison(qm_h, qm_t, 2)"),
		"NEG 4: Quartermaster applies the poison with the SURVIVALIST as src")
	ok(not bsrc.contains("_apply_poison(attacker, qm_t"),
		"NEG 4: it is never applied with the swinging ally as src")


# ---------- §2 live: each Venom node hangs a DIFFERENT affliction ----------

func _live_carriers() -> void:
	# Distillate: extra stacks AND Exposed.
	var scene := await _spawn({"sv_virulence": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 4)
	ok(foe.has_status("poison"), "Distillate's poison lands")
	ok(foe.status_stacks("poison") == 3,
		"...as 1 + 2 extra stacks (got %d)" % foe.status_stacks("poison"))
	ok(foe.has_status("exposed"), "...AND it applies Exposed — the carrier clause")
	ok(scene.call("_status_count", foe) == 2,
		"...so ONE application is worth TWO distinct statuses to the passive")
	await _kill(scene)
	# Coated Blades: Poison AND Cripple, off a basic attack.
	scene = await _spawn({"sv_coated": 1})
	h = _hero(scene, 3)
	foe = scene.get("enemies")[0]
	await scene.call("_resolve", h, h.abilities[0], foe, "good")
	ok(foe.has_status("poison"), "Coated Blades poisons off the basic attack")
	ok(foe.has_status("cripple"), "...AND Cripples — the carrier clause")
	await _kill(scene)


func _live_slow_acting() -> void:
	var scene := await _spawn({"sv_slow_acting": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 3)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("turns", 0)) == 6, "Slow Acting doubles the duration (got %d)" % ps.get("turns", 0))
	ok(bool(ps.get("sticky", false)), "...and the poison is uncleansable")
	ok(foe.has_status("slow"),
		"...and it applies Slowed — the pun the node has carried unclaimed since Batch 33")
	foe.purge_debuffs()
	ok(foe.has_status("poison"), "...the sticky poison survives a cleanse")
	await _kill(scene)


func _live_breadth_rises() -> void:
	# THE PASSIVE'S OWN COUNT, which is the number §0 measures: it rises as the
	# carriers land, which is the whole point of §2.
	var scene := await _spawn({"sv_virulence": 1, "sv_slow_acting": 1, "sv_coated": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(scene.call("_status_count", foe) == 0, "the mark opens clean")
	scene.call("_apply_poison", h, foe, 3)
	var n := int(scene.call("_status_count", foe))
	ok(n == 3, "one poison application from a full carrier build is worth THREE "
		+ "distinct statuses — Poison, Exposed and Slowed (got %d)" % n)
	_report.append(("§2 MEASURED: one poison application under Distillate + Slow "
		+ "Acting lands %d distinct statuses, i.e. Trapper pays +%d%% off a "
		+ "single cast where the pre-BA lane paid +8%%.") % [n, 8 * n])
	await _kill(scene)


# ---------- §3 live: Creeping Death REFRESHES, it does not transfer ----------

func _live_creeping_refresh() -> void:
	var scene := await _spawn({"sv_creeping": 1})
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	var other: BattleUnit = foes[1]
	scene.call("_apply_poison", h, foe, 5)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("full", 0)) == 5, "the poison remembers the duration it was applied with")
	ps["turns"] = 1        # let it run down
	scene.call("_apply_status", foe, "cripple", 2, 0, 0, h)
	ok(int(foe.get_status("poison").get("turns", 0)) == 5,
		"Creeping Death refreshes the Poison to FULL when another status lands (got %d)" \
			% foe.get_status("poison").get("turns", 0))
	ok(not other.has_status("poison"),
		"...and NOTHING crawls to a second enemy — the transmission is gone")
	# The old behaviour, gone: a poisoned death passes nothing on.
	foe.hp = 0
	scene.call("_on_enemy_death", foe)
	ok(not other.has_status("poison"),
		"a poisoned corpse passes its stacks to nobody")
	await _kill(scene)


# ---------- §3 live: Quartermaster poisons from an ALLY'S attack ----------

func _live_quartermaster() -> void:
	var scene := await _spawn({"sv_plague": 1, "sv_potent": 1})
	var h := _hero(scene, 3)
	var ally := _hero(scene, 0)          # the Berserker, who owns none of this
	var foe: BattleUnit = scene.get("enemies")[0]
	ok(h.quartermaster == 1, "the Survivalist carries Quartermaster")
	ok(ally.quartermaster == 0, "...and his ally does not")
	await scene.call("_resolve", ally, ally.abilities[0], foe, "good")
	ok(foe.has_status("poison"),
		"an ALLY'S basic attack applies the Survivalist's Poison")
	# THE CREDIT, which is negative control 4: the tick is HIS, so it reads HIS
	# Attack and HIS Potent Toxins rather than the swinging ally's.
	var tick := int(foe.get_status("poison").get("tick", 0))
	var his := maxi(int(round(0.03 * h.attack)), 1) + h.potent_ranks
	ok(tick == his,
		"...and the tick is HIS (%d), not the ally's — the poison is the Survivalist's work" % his)
	ok(tick != maxi(int(round(0.03 * ally.attack)), 1),
		"...demonstrably not the ally's own %d" % maxi(int(round(0.03 * ally.attack)), 1))
	await _kill(scene)


# ---------- §3 live: Perfected Toxin ----------

func _live_perfected_toxin() -> void:
	var scene := await _spawn({"sv_epidemic": 1})
	var h := _hero(scene, 3)
	var foes: Array = scene.get("enemies")
	var foe: BattleUnit = foes[0]
	# NEGATIVE CONTROL 2, live — AND THE FIRST DRAFT OF THIS CHECK COULD NOT
	# FAIL, which the control caught. `_run_battle` opens with `await _wait(0.6)`
	# on a REAL SceneTreeTimer, so 20 process_frames land BEFORE the battle-start
	# block runs and a reinstated field-wide infection sailed past. Engine
	# time_scale scales those timers and nothing else (the AC gotcha), so the
	# opening genuinely happens before the count is taken.
	Engine.time_scale = 50.0
	for _i in 60:
		await process_frame
	Engine.time_scale = 1.0
	var poisoned_at_start := 0
	for e in foes:
		if e.has_status("poison"):
			poisoned_at_start += 1
	ok(poisoned_at_start == 0,
		"Perfected Toxin poisons NOBODY at battle start (got %d) — that was Epidemic" \
			% poisoned_at_start)
	scene.call("_apply_poison", h, foe, 3)
	var ps: Dictionary = foe.get_status("poison")
	ok(int(ps.get("turns", 0)) == -1, "his Poison never expires")
	ok(bool(ps.get("sticky", false)), "...and cannot be cleansed")
	foe.purge_debuffs()
	ok(foe.has_status("poison"), "...it survives a full cleanse")
	ok(scene.call("_cleansable_debuffs", foe).is_empty()
		or not scene.call("_cleansable_debuffs", foe).any(func(s): return s.id == "poison"),
		"...and a Cleansing Rite cannot reach it either")
	# THE TICK RISES. Its own function precisely because _run_battle cannot be
	# driven headlessly (the AR trap).
	var t0 := int(foe.get_status("poison").get("tick", 0))
	scene.call("_perfected_toxin_tick", foe)
	var t1 := int(foe.get_status("poison").get("tick", 0))
	scene.call("_perfected_toxin_tick", foe)
	var t2 := int(foe.get_status("poison").get("tick", 0))
	ok(t1 == t0 + 2 and t2 == t0 + 4,
		"the tick rises by 2 each turn it persists (%d -> %d -> %d)" % [t0, t1, t2])
	_report.append(("§3 MEASURED: a Perfected Toxin tick opens at %d and reads %d "
		+ "after two turns — it is the only poison in the game that gets worse "
		+ "by standing still.") % [t0, t2])
	await _kill(scene)


# ---------- §7 live: Harvest pays for what it REMOVED ----------

func _live_harvest_count() -> void:
	# Slow Acting makes his poison sticky, so the purge cannot take it — and
	# THAT is the status Harvest used to be paid for anyway.
	var scene := await _spawn({"sv_slow_acting": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_poison", h, foe, 3)               # poison (sticky) + slowed
	scene.call("_apply_status", foe, "cripple", 3, 0, 0, h)
	var standing := int(scene.call("_status_count", foe))
	var reapable := int(scene.call("_harvest_yield", foe))
	ok(standing == 3, "three statuses stand on the mark (got %d)" % standing)
	ok(reapable == 2,
		"...but only TWO can actually be reaped — the sticky poison refuses (got %d)" % reapable)
	ok(reapable < standing,
		"the two numbers genuinely differ, so the test can fail")
	var hp_before := foe.hp
	var harv := Classes.survivalist_pool_ability("Harvest")
	await scene.call("_resolve", h, harv, foe, "good")
	ok(foe.has_status("poison"),
		"Harvest leaves the sticky poison standing — it did not remove it")
	# The bill: 12% of Attack per status, and it must be the REAPED count.
	var dealt := hp_before - foe.hp
	var per := 0.12 * h.attack * (1.0 - foe.effective_armor()) \
		* (1.0 - float(foe.resists.get("nature", 0.0)))
	ok(dealt < per * 2.6,
		"...and is paid for TWO statuses, not three (dealt %d, three would be ~%d)" % [
			dealt, int(per * 3.0)])
	_report.append("§7 MEASURED: Harvest against 3 standing / 2 reapable statuses "
		+ "dealt %d, against ~%d for the old over-count." % [dealt, int(per * 3.0)])
	await _kill(scene)


# ---------- §3 live: the trap cap reads the counter ----------

func _live_trap_cap() -> void:
	var scene := await _spawn({})
	var h := _hero(scene, 3)
	var snare: Ability = null
	for a in h.abilities:
		if a.display_name == "Snare Trap":
			snare = a
	ok(snare != null, "Snare Trap is in his opening kit")
	ok(scene.call("_ability_usable", h, snare), "with no traps out, a snare is usable")
	h.deadfall_armed = 1
	ok(not scene.call("_ability_usable", h, snare),
		"one trap out and no Deadfall Network: the second is refused")
	await _kill(scene)
	scene = await _spawn({"sv_network": 1})
	h = _hero(scene, 3)
	ok(h.deadfall_network == 3, "Deadfall Network installs a cap of THREE")
	h.deadfall_armed = 2
	ok(scene.call("_ability_usable", h, snare),
		"two traps out under Deadfall Network: a THIRD is allowed")
	h.deadfall_armed = 3
	ok(not scene.call("_ability_usable", h, snare),
		"...and a fourth is refused — the cap is the counter, not a hardcoded 2")
	await _kill(scene)


# ---------- §3 live: Quick Rigging's cooldown clause, which was INERT ----------

func _live_quick_rigging() -> void:
	var base := await _spawn({})
	var bh := _hero(base, 3)
	var base_cd := 0
	for a in bh.abilities:
		if a.display_name == "Snare Trap":
			base_cd = a.cooldown
	ok(base_cd == 3, "Snare Trap's base cooldown is 3 (got %d)" % base_cd)
	await _kill(base)
	var scene := await _spawn({"sv_rigging": 1})
	var h := _hero(scene, 3)
	var cd := 99
	for a in h.abilities:
		if a.display_name == "Snare Trap":
			cd = a.cooldown
	ok(cd == base_cd - 2,
		"Quick Rigging really reduces Snare Trap's cooldown by 2 (%d -> %d) — "
		% [base_cd, cd] + "the clause had NO implementation at all before this batch")
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_spring_trap", h, foe, 0.0)
	ok(foe.has_status("cripple"), "...and its spring still applies Cripple")
	await _kill(scene)


# ---------- §3 live: the Snares magnitudes land as written ----------

func _live_snares_magnitudes() -> void:
	var scene := await _spawn({"sv_bone": 1})
	var h := _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	var pr_before := foe.pressure
	scene.call("_spring_trap", h, foe, 0.0)
	ok(foe.pressure > pr_before,
		"Bone Breaker's Break damage lands (pressure %d -> %d)" % [pr_before, foe.pressure])
	await _kill(scene)
	scene = await _spawn({"sv_caught": 1})
	h = _hero(scene, 3)
	foe = scene.get("enemies")[0]
	scene.call("_spring_trap", h, foe, 0.0)
	ok(foe.has_status("caught"), "Caught Fast lands")
	ok(int(foe.get_status("caught").get("turns", 0)) == 5,
		"...for 5 turns (got %d)" % foe.get_status("caught").get("turns", 0))
	foe.hp = maxi(foe.max_hp / 2, 1)
	var before := foe.hp
	foe.heal_amount(50)
	ok(foe.hp == before, "...and the wound genuinely refuses healing")
	await _kill(scene)


# ---------- §3 live: the Guerilla magnitudes land as written ----------

func _live_guerilla_magnitudes() -> void:
	var scene := await _spawn({"sv_woodcraft": 1})
	var h := _hero(scene, 3)
	var bare := await _spawn_bare_hp()
	ok(h.max_hp > bare,
		"Woodcraft raises his maximum Health (%d over a bare %d)" % [h.max_hp, bare])
	ok(abs(float(h.max_hp) / float(bare) - 1.20) < 0.02,
		"...by 20%% (ratio %.3f)" % (float(h.max_hp) / float(bare)))
	await _kill(scene)
	scene = await _spawn({"sv_hitrun": 1})
	h = _hero(scene, 3)
	var foe: BattleUnit = scene.get("enemies")[0]
	scene.call("_apply_status", foe, "cripple", 3, 0, 0, h)
	scene.call("_hit_and_run", h)
	ok(h.has_status("elusive"), "Hit and Run grants Elusive")
	ok(int(h.get_status("elusive").get("turns", 0)) == 2,
		"...for 2 turns (got %d)" % h.get_status("elusive").get("turns", 0))
	await _kill(scene)
	scene = await _spawn({"sv_improvised": 1})
	h = _hero(scene, 3)
	ok(h.improvised == 2, "Improvised covers TWO opening abilities")
	ok(h.improvised_used == 0, "...and the spend counter opens at zero, not false")
	await _kill(scene)
	scene = await _spawn({"sv_scavenger": 1})
	h = _hero(scene, 3)
	h.resource = 0
	var dying: BattleUnit = scene.get("enemies")[0]
	dying.hp = 0
	scene.call("_on_enemy_death", dying)
	ok(h.resource == int(h.max_resource * 0.25),
		"Scavenger restores 25%% of maximum Mana on a death (got %d of %d)" % [
			h.resource, h.max_resource])
	await _kill(scene)


# A Survivalist with no talents at all, for Woodcraft's ratio.
func _spawn_bare_hp() -> int:
	var scene := await _spawn({})
	var hp: int = _hero(scene, 3).max_hp
	await _kill(scene)
	return hp
