# test_batch_ar.gd — the Pyromancer re-authored around OVERBURN. Run headless:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_ar.gd
#
# NOTE: run it WITHOUT --quit-after. It spawns live battles, and --quit-after
# kills a --script run mid-way and prints nothing at all (the AN gotcha).
#
# What it pins, and why each one is here rather than left to a playtest:
#   1. THE SHAPE — 3 lanes x 7 exclusive rows + a capstone shelf, one node per
#      lane per row, single ranks. (test_batch_ai asserts this generically for
#      all twelve trees; it is repeated here because AR moved four ids BETWEEN
#      lanes and a shape break would otherwise only surface there.)
#   2. ALL 24 IDS — id, row, lane, name. EVERY id survives and re-specs in
#      place, which is the whole migration promise: saved picks resolve and no
#      save version moves. A dropped or renamed id silently voids a saved tree,
#      so the table is transcribed here and a re-cut has to come and say so.
#   3. THE MAGNITUDES — both halves: the payload the node applies AND the
#      number its tooltip renders. Several fields are ADDITIVE and fed by a
#      rune as well, so the payload is the design number, not a bare 1.
#   4. OVERBURN AT ITS READ SITES — the drain, the bonus, the refund, and
#      THE ASYMMETRY: the reward caps and the cost does not. That asymmetry is
#      the spec, so it is asserted directly and in both directions — a bonus
#      that stops climbing at 20 burn-turns while the drain keeps going.
#   5. THE RUNE AUDIT (§4) — every counter the four Pyromancer runes and the
#      three Mage runes ride is either written by a node or still has a live
#      read site. The one that has neither (pyromaniac_ranks) is asserted
#      INERT on purpose, so "flagged, not fixed" is a fact in the test rather
#      than a note in a changelog nobody re-reads.
#   6. THE KIT — Detonation at 250%, Immolate where Flame Shield was, Pyroblast
#      and Phoenix Rebirth resolving out of the vault, "Flame Shield" gone from
#      both pools, and NO DEFENSIVE OPTION anywhere in kit or tree.
#   7. LIVE — a spawned battle, because the drain, the refund, the chip and
#      Immolate's uncapping only exist at battle time.
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# id -> [row, lane, name]. BATCH_AR.md §3's table, transcribed once. The ids
# are the OLD ones by design — §7's mapping lives in the changelog, and this
# is the machine-checkable half of it.
const NODES := {
	"py_kindling": [1, "Kindling", "Cinder Trail"],
	"py_pyromaniac": [1, "Inferno", "Fire Walker"],
	"py_shockwave": [1, "Detonation", "Focused Flame"],
	"py_accelerant": [2, "Kindling", "Accelerant"],
	"py_invigorating": [2, "Inferno", "Invigorating Ashes"],
	"py_supernova": [2, "Detonation", "Pressure Cooker"],
	"py_arson": [3, "Kindling", "Conflagration"],
	"py_firebrand": [3, "Inferno", "Heat Shimmer"],
	"py_implosion": [3, "Detonation", "Aftershock"],
	"py_melt": [4, "Kindling", "Backdraft"],
	"py_flame_shield": [4, "Inferno", "Immolate"],
	"py_focused": [4, "Detonation", "Pyroblast"],
	"py_ashes": [5, "Kindling", "Wildfire Spread"],
	"py_molten": [5, "Inferno", "Kiln-Forged"],
	"py_seeding": [5, "Detonation", "Crucible"],
	"py_explosive": [6, "Kindling", "Explosive Force"],
	"py_undying_flame": [6, "Inferno", "Ash Lung"],
	"py_rekindle": [6, "Detonation", "Twin Detonation"],
	"py_spreading": [7, "Kindling", "Chain Ignition"],
	"py_cauterize": [7, "Inferno", "Cauterise"],
	"py_warm_glow": [7, "Detonation", "Total Commitment"],
	"py_firestorm": [8, "Kindling", "Firestorm"],
	"py_rebirth": [8, "Inferno", "Phoenix Rebirth"],
	"py_hellfire": [8, "Detonation", "Cataclysm"],
}

# id -> [stat field, the value the PAYLOAD writes]. Only the stat nodes; the
# ability-payload ones are checked in their own section.
const PAYLOADS := {
	"py_kindling": ["cinder_trail_ranks", 1],
	"py_accelerant": ["accelerant_ranks", 4],
	"py_arson": ["conflagration_ranks", 2],
	"py_ashes": ["wildfire_spread", 1],
	"py_explosive": ["explosive_ranks", 2],
	"py_spreading": ["ember_wind", 1],
	"py_pyromaniac": ["fire_walker", 1],
	"py_invigorating": ["invigorating_ranks", 20],
	"py_firebrand": ["heat_haze_ranks", 20],
	"py_molten": ["kiln_forged", 1],
	"py_undying_flame": ["ash_lung", 1],
	"py_cauterize": ["cauterise", 1],
	"py_shockwave": ["focused_flame", 1],
	"py_supernova": ["pressure_cooker", 1],
	"py_implosion": ["aftershock", 2],
	"py_seeding": ["crucible", 1],
	"py_warm_glow": ["total_commitment", 1],
	"py_hellfire": ["cataclysm", 1],
}

# id -> the value scale.base + scale.step must render. THE DESIGN NUMBER as
# the player reads it: where the payload is a bare flag, this is the only
# place the magnitude appears in the data at all.
const SCALE_VALUES := {
	"py_kindling": 1.0,
	"py_accelerant": 4.0,
	"py_arson": 2.0,
	"py_ashes": 1.0,
	"py_explosive": 2.0,
	"py_pyromaniac": 25.0,
	"py_invigorating": 20.0,
	"py_firebrand": 60.0,
	"py_molten": 20.0,
	"py_undying_flame": 15.0,
	"py_shockwave": 325.0,
	"py_supernova": 25.0,
	"py_implosion": 2.0,
	"py_seeding": 2.0,
	"py_rekindle": 1.0,
}

# The four nodes that grant an ability, and the four numbers each one's def
# has to carry. §2 and §3 both name these, so they are pinned rather than
# eyeballed.
const ABILITY_NODES := {
	"py_melt": ["Backdraft", 20, 2.0, 3],
	"py_flame_shield": ["Immolate", 15, 1.5, 2],
	"py_focused": ["Pyroblast", 45, 6.0, 0],
	"py_firestorm": ["Firestorm", 30, 3.5, 4],
	"py_rebirth": ["Phoenix Rebirth", 0, 2.0, 4],
}


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
	Profile.save_path = "user://profile_batch_ar_test.json"
	Profile.loaded = false
	Profile.data = {}

	_tree_shape()
	_node_table()
	_magnitudes()
	_ability_nodes()
	_kit()
	_pools()
	_no_defence()
	_rune_audit()
	await _live_passive_math()
	await _live_drain()
	await _live_refund()
	await _live_asymmetry()
	await _live_chip()
	await _live_immolate()
	await _live_detonation()
	await _live_kit_nodes()

	if FileAccess.file_exists("user://profile_batch_ar_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_ar_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH AR: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


func _tree() -> Array:
	return Talents.generate_tree("pyromancer", "mage")


func _node(id: String) -> Dictionary:
	return Talents.node_in_tree(_tree(), id)


# ---------- 1. the shape ----------

func _tree_shape() -> void:
	var tree := _tree()
	ok(tree.size() == 24, "the Pyromancer tree holds 24 nodes (got %d)" % tree.size())
	var seen: Dictionary = {}
	var grid: Dictionary = {}
	for n in tree:
		var id := String(n["id"])
		ok(not seen.has(id), "node id %s appears exactly once" % id)
		seen[id] = true
		ok(int(n["ranks"]) == 1, "%s holds a single rank" % id)
		ok(not n.has("tier"), "%s carries no leftover tier" % id)
		ok(not n.has("exclusive_with"), "%s carries no leftover exclusive_with" % id)
		var key := "%d/%s" % [int(n["row"]), String(n["lane"])]
		ok(not grid.has(key), "row %s holds one node (%s)" % [key, id])
		grid[key] = id
	for row in range(1, 9):
		for lane in ["Kindling", "Inferno", "Detonation"]:
			ok(grid.has("%d/%s" % [row, lane]),
				"row %d has a %s node" % [row, lane])
	var caps := 0
	for n in tree:
		var is_cap: bool = int(n["row"]) == Talents.CAPSTONE_ROW
		ok(bool(n.get("capstone", false)) == is_cap,
			"%s carries the capstone flag iff it is on row 8" % String(n["id"]))
		if is_cap:
			caps += 1
	ok(caps == 3, "the capstone shelf holds 3 (got %d)" % caps)


# ---------- 2. every id, row, lane and name ----------

func _node_table() -> void:
	ok(NODES.size() == 24, "the transcribed table itself holds 24 entries")
	for id in NODES:
		var n := _node(String(id))
		ok(not n.is_empty(),
			"%s SURVIVES — a saved pick on it still resolves" % id)
		if n.is_empty():
			continue
		var want: Array = NODES[id]
		ok(int(n["row"]) == int(want[0]),
			"%s sits on row %d (got %d)" % [id, int(want[0]), int(n["row"])])
		ok(String(n["lane"]) == String(want[1]),
			"%s is in the %s lane (got %s)" % [id, want[1], n["lane"]])
		ok(String(n["name"]) == String(want[2]),
			"%s is named %s (got %s)" % [id, want[2], n["name"]])
	# ...and nothing NEW appeared: no id was added to carry a re-spec.
	for n in _tree():
		ok(NODES.has(String(n["id"])),
			"%s is one of the 24 surviving ids, not a new one" % String(n["id"]))
	# The names that must be GONE, because their nodes were re-specced away.
	# A leftover would mean an id got duplicated rather than re-used.
	var live_names: Array = []
	for n in _tree():
		live_names.append(String(n["name"]))
	for dead in ["Pyromaniac", "Molten Core", "Melt Armor", "Heat Haze",
			"Scorched Earth", "Ashes of Al'ar", "Living Flame", "Super Nova",
			"Implosion", "Seeding Embers", "Chain Reaction", "Fuse",
			"Blast Radius", "White Heat", "Ember Wind", "Flame Shield",
			"Avatar of Flame"]:
		ok(not live_names.has(dead),
			"'%s' is gone from the tree (Batch AR re-specced its id)" % dead)


# ---------- 3. the magnitudes, in the payload AND the tooltip ----------

func _magnitudes() -> void:
	for id in PAYLOADS:
		var n := _node(String(id))
		if n.is_empty():
			continue
		var want: Array = PAYLOADS[id]
		var pay: Dictionary = n["payload"].get("stat", {})
		ok(pay.has(want[0]),
			"%s writes %s (got %s)" % [id, want[0], str(pay.keys())])
		if pay.has(want[0]):
			ok(pay[want[0]] == want[1],
				"%s writes %s = %s (got %s)" % [id, want[0], str(want[1]),
					str(pay[want[0]])])
		ok(pay.size() == 1, "%s writes exactly one field" % id)
	for id in SCALE_VALUES:
		var n2 := _node(String(id))
		if n2.is_empty():
			continue
		ok(n2.has("scale"), "%s carries a scale so its tooltip renders a number" % id)
		var sc: Dictionary = n2.get("scale", {})
		var val := float(sc.get("base", 0.0)) + float(sc.get("step", 0.0))
		ok(is_equal_approx(val, float(SCALE_VALUES[id])),
			"%s renders %s (got %s)" % [id, str(SCALE_VALUES[id]), str(val)])
		# ...and the rendered tooltip really contains it, with no dead decimal
		# (the Batch AP trim).
		var shown := Talents.desc_for(n2, 1)
		var txt := String.num(float(SCALE_VALUES[id]), 2)
		if txt.contains("."):
			txt = txt.rstrip("0").rstrip(".")
		ok(shown.contains(txt), "%s's tooltip shows %s (%s)" % [id, txt, shown])
		ok(not shown.contains("{v}"), "%s's tooltip left no {v} unrendered" % id)
	# Twin Detonation is the ONE node whose magnitude is an ability field
	# rather than a stat: it SETS Detonation's cooldown, the way Relentless
	# sets Hack and Slash's bleed_chance.
	var twin := _node("py_rekindle")
	ok(twin.get("payload", {}).has("ability"),
		"Twin Detonation edits the ability, not a counter")
	ok(String(twin.get("payload", {}).get("ability", "")) == "Detonation",
		"...specifically Detonation")
	ok(int(twin.get("payload", {}).get("set", {}).get("cooldown", -1)) == 1,
		"...setting its cooldown to 1")


# ---------- the four ability grants ----------

func _ability_nodes() -> void:
	for id in ABILITY_NODES:
		var n := _node(String(id))
		if n.is_empty():
			continue
		var want: Array = ABILITY_NODES[id]
		var nab: Dictionary = n["payload"].get("new_ability", {})
		ok(not nab.is_empty(), "%s grants an ability" % id)
		if nab.is_empty():
			continue
		ok(String(nab["display_name"]) == String(want[0]),
			"%s grants %s (got %s)" % [id, want[0], nab["display_name"]])
		ok(int(nab.get("cost", -1)) == int(want[1]),
			"%s costs %d Mana" % [want[0], int(want[1])])
		ok(is_equal_approx(float(nab.get("delay", -1.0)), float(want[2])),
			"%s arrives at %s initiative" % [want[0], str(want[2])])
		ok(int(nab.get("cooldown", -1)) == int(want[3]),
			"%s has a %d-turn cooldown" % [want[0], int(want[3])])
		# ...and the tree is the ONE place each def lives, so the earnable
		# pools cannot drift from the copy a talent hands out.
		var resolved: Ability = Talents.granted_ability(String(want[0]))
		ok(resolved != null, "%s resolves through Talents.granted_ability" % want[0])
	# Phoenix Rebirth came out of the vault and the TREE owns it now. Its old
	# vault def must be gone, or two copies exist and one will drift.
	ok(Classes.vault_ability("Phoenix Rebirth") == null,
		"Phoenix Rebirth's vault copy is gone — the tree owns the only def")
	ok(Classes.pool_ability("Phoenix Rebirth") != null,
		"...and the mage class pool still resolves it")
	# THE EMPOWER CLAUSE IS DROPPED (§2): Empower is a named mechanic of the
	# Holy Cleric's Mercy system and this ability never should have granted it.
	var phoenix: Ability = Talents.granted_ability("Phoenix Rebirth")
	if phoenix != null:
		ok(not phoenix.description.contains("Empower"),
			"Phoenix Rebirth's text no longer promises Empower")
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not src.contains('_apply_status(attacker, "empower", 3)'),
		"the phoenix special no longer applies the Empower status")


# ---------- the kit ----------

func _kit() -> void:
	var kit: Array = Classes.spec_abilities("pyromancer")
	var by_name := {}
	for ab in kit:
		by_name[ab.display_name] = ab
	for want in ["Detonation", "Wildfire", "Flamewave"]:
		ok(by_name.has(want), "the kit still opens with %s" % want)
	ok(not by_name.has("Flame Shield"), "Flame Shield is not in the kit")
	# Detonation's own numbers are unchanged (§2 says cost, cooldown and Break
	# stay); only its Burn multiplier moved, and that lives in battle.gd.
	if by_name.has("Detonation"):
		var det: Ability = by_name["Detonation"]
		ok(det.cost == 25, "Detonation still costs 25 Mana")
		ok(det.cooldown == 2, "Detonation still has a 2-turn cooldown")
		ok(det.pressure == 20, "Detonation still carries 20 Break damage")
		ok(det.description.contains("250%"),
			"...and its text states the new 250%% (%s)" % det.description)
	# THE MULTIPLIER ITSELF, at its read site — a description saying 250% over
	# code saying 150% is exactly the drift this batch exists to correct.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("(2.5 + 0.75 * attacker.focused_flame)"),
		"Detonation's Burn bonus reads 250%, +75 points from Focused Flame")
	ok(not src.contains("* 1.5 \\\n"), "the old 150% multiplier is gone")
	# Wildfire's description is corrected too: master.html had it spreading
	# Burn at half duration, which Batch AG superseded and nobody caught.
	if by_name.has("Wildfire"):
		var wf: Ability = by_name["Wildfire"]
		ok(wf.description.contains("WIDE"),
			"Wildfire's text names it the wide release valve")
		ok(wf.description.contains("18%"),
			"...and states what it actually does — 18% of Attack per turn taken")
	# The passive id moved, and everything keys on it.
	ok(String(Classes.SPEC_INFO["pyromancer"]["passive"]) == "overburn",
		"the Pyromancer's passive id is overburn")
	var pdesc := String(Classes.SPEC_INFO["pyromancer"]["passive_desc"])
	ok(pdesc.contains("Overburn"), "the passive is named Overburn")
	ok(pdesc.contains("+2%"), "...its reward is stated")
	ok(pdesc.contains("+40%"), "...its cap is stated")
	ok(pdesc.contains("no cap"), "...and so is the fact that the COST has none")
	ok(pdesc.contains("refunds"), "...and the refund")


func _pools() -> void:
	# "Flame Shield" stopped existing, so a pool naming it would be a dud
	# offer — the exact failure Batch AP existed to close, through the door
	# of a re-specced node rather than an unread field.
	ok(not Classes.SPEC_POOLS["pyromancer"].has("Flame Shield"),
		"Flame Shield left the Pyromancer spec pool")
	ok(not Classes.CLASS_POOLS["mage"].has("Flame Shield"),
		"Flame Shield left the mage class pool")
	ok(Classes.SPEC_POOLS["pyromancer"].has("Immolate"),
		"Immolate took its place in the spec pool")
	# Immolate reads Overburn, so it must NOT be class-pool eligible.
	ok(not Classes.CLASS_POOLS["mage"].has("Immolate"),
		"Immolate is spec-only — it reads a passive a sibling will not have")
	ok(not Classes.CLASS_POOLS["mage"].has("Pyroblast"),
		"Pyroblast is spec-only for the same reason")
	# ...and every entry that remains still resolves.
	for name in Classes.SPEC_POOLS["pyromancer"]:
		ok(Classes.spec_pool_ability("pyromancer", name) != null,
			"spec pool -> %s resolves" % name)
	for name in Classes.CLASS_POOLS["mage"]:
		ok(Classes.pool_ability(name) != null, "mage class pool -> %s resolves" % name)


func _no_defence() -> void:
	# §2: "This leaves the Pyromancer with no defensive option anywhere in his
	# kit or tree. That is deliberate." Asserted, because the cheapest way to
	# undo this batch is for a later one to quietly add an escape hatch.
	var defensive := ["Flame Shield", "Mana Shield", "Molten Core",
		"Ashes of Al'ar", "Scorched Earth"]
	for n in _tree():
		ok(not defensive.has(String(n["name"])),
			"no defensive node in the tree (%s)" % String(n["name"]))
		var d := String(n.get("desc", "")).to_lower()
		ok(not d.contains("less damage"),
			"%s does not mitigate damage" % String(n["id"]))
		ok(not d.contains("revive"), "%s is not a self-revive" % String(n["id"]))
	for ab in Classes.spec_abilities("pyromancer"):
		ok(not defensive.has(ab.display_name),
			"no defensive ability in the kit (%s)" % ab.display_name)
	# Immolate is the ex-Flame Shield and must have kept NOTHING defensive.
	var imm: Ability = Talents.granted_ability("Immolate")
	ok(imm != null, "Immolate exists")
	if imm != null:
		ok(not imm.description.contains("less damage"),
			"Immolate kept no damage reduction (%s)" % imm.description)
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not src.contains("Flame Shield: the fire barrier"),
		"the 50%-less-damage branch is deleted, not left unreachable")


# ---------- §4: the rune audit, as a fact rather than a note ----------

func _rune_audit() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var stat_fields := {}
	for n in _tree():
		for f in n["payload"].get("stat", {}):
			stat_fields[f] = true
	# The counters that MOVED and were re-pointed, or that survive with a live
	# read site. Each is asserted to still DO something, so a future rename
	# cannot make one of these runes quietly inert.
	var live := {
		"rune_cinder_ember": "attacker.rune_cinder_ember > 0",
		"supernova_ranks": "attacker.supernova_ranks > 0",
		"molten_ranks": "strike_target.molten_ranks > 0",
		"blast_radius_ranks": "attacker.blast_radius_ranks",
	}
	for field in live:
		ok(src.contains(String(live[field])),
			"rune counter %s still has a read site" % field)
		ok(not stat_fields.has(field),
			"...and %s is rune-only now — no node writes it" % field)
	# The shared ones: a node AND a rune feed these, and because the read site
	# ADDS the field they must each pay their own advertised number.
	for field in ["accelerant_ranks", "conflagration_ranks"]:
		ok(stat_fields.has(field),
			"%s is written by a node as well as a rune" % field)
	# THE ONE WITH NEITHER. Overburn has no per-turn step to raise, and
	# inventing one would be the guess §4 forbids — so this is FLAGGED, and
	# the flag is this assertion. If a later batch re-authors the White Flame,
	# this check is the one it has to come and change.
	ok(not stat_fields.has("pyromaniac_ranks"),
		"pyromaniac_ranks has no node (Pyromaniac was re-specced away)")
	ok(not src.contains("attacker.pyromaniac_ranks")
		and not src.contains("h.pyromaniac_ranks")
		and not src.contains("u.pyromaniac_ranks"),
		"pyromaniac_ranks has no read site either — the White Flame's middle "
		+ "clause is INERT and flagged for re-authoring, not silently repaired")
	# The rune data itself: the re-point landed, and nothing still points at
	# the old field.
	var trail: Dictionary = Runes.config("cinder_trail")
	ok(not trail.is_empty(), "the Rune of the Cinder Trail is still there")
	if not trail.is_empty():
		var pay: Dictionary = trail["payload"]["stat"]
		ok(pay.has("rune_cinder_ember"),
			"...and was re-pointed onto rune_cinder_ember")
		ok(not pay.has("cinder_trail_ranks"),
			"...off cinder_trail_ranks, which the node took for a new meaning")
	# The int-restore trap (AA/AB): a bare 1 that does not end in "_ranks"
	# loads as a float and a float into an int var is a runtime error.
	ok(Runes.STAT_INT_KEYS.has("rune_cinder_ember"),
		"rune_cinder_ember is in STAT_INT_KEYS or it lands as a float")
	# Every pyromancer/mage rune's stat field is either a real BattleUnit
	# property or a cfg key battle.gd consumes at spawn — set() drops an
	# unknown name SILENTLY, so a typo here is a dud rune, not a crash.
	var probe := BattleUnit.new()
	for rid in Runes.ids():
		var r: Dictionary = Runes.config(String(rid))
		if not String(r.get("scope", "")) in ["spec:pyromancer", "class:mage"]:
			continue
		for f in r.get("payload", {}).get("stat", {}):
			var lands: bool = probe.get(f) != null \
				or src.contains('cfg.get("%s"' % f) or src.contains('cfg["%s"]' % f)
			ok(lands, "rune %s writes %s, which something actually reads" % [rid, f])
	probe.free()


# ---------- the live half ----------

func _spawn(learned: Dictionary, lineup: Array) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
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
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL discipline). Every
	# check below drives _resolve by hand, and a 5% miss or a 5% parry skips
	# the whole damage path — which reads as "the node did nothing" and turns
	# a real assertion into a coin flip. `no_cover` is the Sharpshooter's
	# existing miss BYPASS, not a modifier; parry and block are zeroed on both
	# sides. CAPTURED, NOT GUESSED: before this, "Fireball lit the target"
	# failed 1 run in 8 and Total Commitment's three checks failed together on
	# a parried Detonation.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
	return scene


func _py(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "overburn":
			return h
	return null


# Put a known number of Burn TURNS on the field, split across the lineup.
func _light(scene: Node, turns_each: int) -> int:
	var total := 0
	for foe in scene.get("enemies"):
		if foe.dead:
			continue
		scene.call("_apply_status", foe, "burn", turns_each, 0, 6)
		total += turns_each
	return total


func _live_passive_math() -> void:
	var scene := await _spawn({}, ["raider", "raider"])
	var py := _py(scene)
	ok(py != null, "the Pyromancer spawned")
	if py == null:
		scene.queue_free()
		return
	# Clause 2: +2% a turn, capped at +40%.
	ok(is_equal_approx(scene.call("_overburn_mult", py, 0), 1.0),
		"an unlit field pays nothing")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 5), 1.10),
		"5 burn-turns pay +10%")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 20), 1.40),
		"20 burn-turns pay +40% — the cap, exactly")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 40), 1.40),
		"40 burn-turns still pay +40% — the reward CAPS")
	# The worked curve from §1, so the spec's own arithmetic is checkable.
	ok(scene.call("_overburn_drain", py, 3) == 3,
		"one enemy at 3 turns costs 3 Mana a turn")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 3), 1.06),
		"...for +6%")
	ok(scene.call("_overburn_drain", py, 20) == 20,
		"a full field at 20 burn-turns costs 20 Mana a turn")
	ok(scene.call("_mana_regen", py) == 22,
		"...against a Mage's regen of 22, so he is treading water")
	ok(scene.call("_mana_regen", py) - scene.call("_overburn_drain", py, 20) < 25,
		"...and cannot bank Detonation's 25 out of a turn while he holds it")
	ok(scene.call("_overburn_drain", py, 24) > scene.call("_mana_regen", py),
		"at 24 burn-turns he is going backwards")
	scene.queue_free()
	await process_frame


func _live_asymmetry() -> void:
	# THE ASYMMETRY IS THE DESIGN AND MUST SURVIVE IMPLEMENTATION. Asserted
	# as a pair over the same range: past the cap the reward is flat and the
	# cost is still climbing, monotonically, with no ceiling anywhere.
	var scene := await _spawn({}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var prev_bonus := 0.0
	var prev_cost := -1
	for turns in range(0, 61):
		var bonus: float = scene.call("_overburn_mult", py, turns)
		var cost: int = scene.call("_overburn_drain", py, turns)
		ok(cost == turns, "the drain at %d burn-turns is %d, uncapped" % [turns, cost])
		ok(cost > prev_cost, "the cost is still climbing at %d turns" % turns)
		if turns > 20:
			ok(is_equal_approx(bonus, 1.40),
				"the bonus is STILL +40%% at %d turns — it caps" % turns)
			ok(is_equal_approx(bonus, prev_bonus),
				"...and stopped moving entirely past 20")
		prev_bonus = bonus
		prev_cost = cost
	# ...and the two nodes that lift the cap lift it ENTIRELY, while nothing
	# anywhere puts a ceiling on the drain.
	var shimmer := await _spawn({"py_firebrand": 1}, ["raider"])
	var py2 := _py(shimmer)
	if py2 != null:
		ok(py2.heat_haze_ranks == 20, "Heat Shimmer loads +20 cap points")
		ok(is_equal_approx(shimmer.call("_overburn_mult", py2, 40), 1.60),
			"Heat Shimmer raises the cap to +60% and NOT past it")
		ok(shimmer.call("_overburn_drain", py2, 40) == 40,
			"...and does not touch the drain")
	shimmer.queue_free()
	await process_frame
	scene.queue_free()
	await process_frame


func _live_drain() -> void:
	# Clause 1, at its read site. _player_turn cannot be driven headlessly (it
	# awaits an ability pick that never comes), so the clause lives in its own
	# _overburn_tick and the ORDER is asserted against the source instead:
	# the bill must be charged AFTER the regen drip, or the squeeze §1
	# describes never happens.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var turn_body := src.substr(src.find("func _player_turn(u: BattleUnit)"))
	turn_body = turn_body.substr(0, turn_body.find("Companions have no turns"))
	ok(turn_body.find("_mana_regen(u)") >= 0, "_player_turn drips the regen")
	ok(turn_body.find("_overburn_tick(u)") >= 0, "...and then charges the drain")
	ok(turn_body.find("_mana_regen(u)") < turn_body.find("_overburn_tick(u)"),
		"REGEN FIRST, THEN THE BILL — the order the worked curve depends on")
	ok(src.count("_overburn_tick(u)") == 1, "the drain has ONE call site")

	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var lit := _light(scene, 4)          # 12 burn-turns on the field
	ok(scene.call("_total_burn_turns") == lit,
		"the field reads %d burn-turns" % lit)
	py.resource = 50
	ok(not scene.call("_overburn_tick", py), "an ordinary drain is not lethal")
	ok(py.resource == 50 - lit,
		"the turn-start bill takes %d Mana (got %d)" % [lit, 50 - py.resource])
	# An unlit field costs nothing at all.
	for foe in scene.get("enemies"):
		foe.remove_status("burn")
	py.resource = 50
	scene.call("_overburn_tick", py)
	ok(py.resource == 50, "an unlit field bills nothing")
	scene.queue_free()
	await process_frame
	# Fire Walker takes a quarter off it.
	var walker := await _spawn({"py_pyromaniac": 1}, ["raider", "raider", "raider"])
	var py2 := _py(walker)
	if py2 != null:
		ok(py2.fire_walker == 1, "Fire Walker loads its flag")
		ok(walker.call("_overburn_drain", py2, 20) == 15,
			"Fire Walker cuts a 20-Mana drain to 15")
	walker.queue_free()
	await process_frame
	# Kiln-Forged floors it at 10 Mana and grants the fire resistance.
	var kiln := await _spawn({"py_molten": 1}, ["raider", "raider", "raider"])
	var py3 := _py(kiln)
	if py3 != null:
		ok(py3.kiln_forged == 1, "Kiln-Forged loads its flag")
		ok(is_equal_approx(float(py3.resists.get("fire", 0.0)), 0.50),
			"...+20% fire resistance on top of the spec block's 30% (got %s)" % \
				str(py3.resists.get("fire", 0.0)))
		_light(kiln, 8)
		py3.resource = 12
		kiln.call("_overburn_tick", py3)
		ok(py3.resource == 10,
			"the drain never takes him below 10 Mana (got %d)" % py3.resource)
	kiln.queue_free()
	await process_frame
	# Cauterise bills the shortfall to HEALTH, 1 HP per Mana.
	var caut := await _spawn({"py_cauterize": 1}, ["raider", "raider", "raider"])
	var py4 := _py(caut)
	if py4 != null:
		ok(py4.cauterise == 1, "Cauterise loads its flag")
		var burn_turns := _light(caut, 6)     # 18 on the field
		py4.resource = 4
		py4.hp = py4.max_hp
		var hp_before := py4.hp
		caut.call("_overburn_tick", py4)
		ok(py4.resource == 0, "Cauterise empties the pool first")
		ok(py4.hp == hp_before - (burn_turns - 4),
			"...then bills %d HP for the Mana it could not cover (took %d)" % [
				burn_turns - 4, hp_before - py4.hp])
		# ...and the cap comes off under 20 Mana, which is the OTHER half.
		py4.resource = 5
		ok(not caut.call("_overburn_capped", py4),
			"Cauterise removes the damage cap under 20 Mana")
		ok(is_equal_approx(caut.call("_overburn_mult", py4, 40), 1.80),
			"...so 40 burn-turns pay the full +80%")
		py4.resource = 40
		ok(caut.call("_overburn_capped", py4),
			"...and the cap returns above 20 Mana")
	caut.queue_free()
	await process_frame


func _live_refund() -> void:
	# Clause 3: ONE rule, ONE implementation. Detonation and Wildfire both go
	# through _overburn_refund, so the assertion is that the SAME helper pays
	# both — not that each ability happens to refund.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.count("func _overburn_refund") == 1,
		"the refund has exactly one implementation")
	ok(src.count("_overburn_refund(attacker,") == 2,
		"...and exactly two call sites: Detonation and Wildfire")
	var scene := await _spawn({}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	py.resource = 10
	scene.call("_overburn_refund", py, 6)
	ok(py.resource == 16, "consuming a six-turn Burn returns 6 Mana (got %d)" % py.resource)
	py.resource = py.max_resource - 2
	scene.call("_overburn_refund", py, 6)
	ok(py.resource == py.max_resource, "...and never overfills the bar")
	py.resource = 10
	scene.call("_overburn_refund", py, 0)
	ok(py.resource == 10, "consuming nothing refunds nothing")
	scene.queue_free()
	await process_frame
	# Crucible doubles the rate.
	var cruc := await _spawn({"py_seeding": 1}, ["raider", "raider"])
	var py2 := _py(cruc)
	if py2 != null:
		ok(py2.crucible == 1, "Crucible loads its flag")
		py2.resource = 10
		cruc.call("_overburn_refund", py2, 6)
		ok(py2.resource == 22, "Crucible refunds 2 a turn, not 1 (got %d)" % py2.resource)
	cruc.queue_free()
	await process_frame


func _live_chip() -> void:
	# THE SPEC CHIP MUST SHOW BOTH NUMBERS LIVE (§1) — the bonus AND the drain.
	# Half of a trade is not a readout.
	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var lit := _light(scene, 4)
	scene.call("_update_talent_chips")
	var chip: Dictionary = py.get_status("spec_passive")
	ok(not chip.is_empty(), "the Pyromancer carries a passive chip")
	var desc := String(chip.get("desc", ""))
	ok(desc.contains("Overburn"), "the chip names Overburn (%s)" % desc)
	ok(desc.contains("+%d%%" % (lit * 2)),
		"the chip shows the live BONUS of +%d%% (%s)" % [lit * 2, desc])
	ok(desc.contains("-%d Mana" % lit),
		"the chip shows the live DRAIN of %d Mana (%s)" % [lit, desc])
	ok(desc.contains("NO CAP"), "the chip says which of the two has no cap")
	ok(not desc.contains("Inferno Master"), "no trace of the old passive")
	scene.queue_free()
	await process_frame


func _live_immolate() -> void:
	var scene := await _spawn({"py_flame_shield": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var has_immolate := false
	for ab in py.abilities:
		if ab.display_name == "Immolate":
			has_immolate = true
	ok(has_immolate, "the node granted Immolate")
	ok(scene.call("_overburn_capped", py), "capped before the cast")
	ok(scene.call("_overburn_drain", py, 20) == 20, "and paying the plain drain")
	py.add_status("immolate", "Immolate", "IM", Color(1, 1, 1), 2, "")
	ok(not scene.call("_overburn_capped", py),
		"Immolate lifts the damage cap ENTIRELY")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 40), 1.80),
		"...so 40 burn-turns pay +80%")
	ok(scene.call("_overburn_drain", py, 20) == 40,
		"...and DOUBLES the drain (got %d)" % scene.call("_overburn_drain", py, 20))
	# The retaliation burn moved with it and reads the NEW status id — driven,
	# not hoped for. `no_cover` is the Sharpshooter's existing miss BYPASS: it
	# makes the strike land rather than retrying until it does (the AK/AL
	# discipline). The control below proves the check can fail.
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.no_cover = 1
	ok(not foe.has_status("burn"), "the attacker is not alight before it swings")
	await scene._resolve(foe, foe.abilities[0], py, "good")
	ok(foe.has_status("burn"),
		"whoever strikes the immolating Pyromancer is set Burning")
	if foe.has_status("burn"):
		ok(int(foe.get_status("burn").get("turns", 0)) == 3,
			"...for 3 turns (got %d)" % int(foe.get_status("burn").get("turns", 0)))
	scene.queue_free()
	await process_frame
	# CONTROL: the same strike with no Immolate up ignites nobody.
	var plain := await _spawn({"py_flame_shield": 1}, ["raider", "raider"])
	var py2 := _py(plain)
	if py2 != null:
		var foe2: BattleUnit = plain.get("enemies")[0]
		foe2.no_cover = 1
		ok(not py2.has_status("immolate"), "control: no Immolate is up")
		await plain._resolve(foe2, foe2.abilities[0], py2, "good")
		ok(not foe2.has_status("burn"), "control: nothing ignites")
	plain.queue_free()
	await process_frame


func _live_detonation() -> void:
	# The trigger, and the refund behind it, driven rather than hoped for.
	var scene := await _spawn({}, ["raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var foes: Array = scene.get("enemies")
	var mark: BattleUnit = foes[1]
	scene.call("_apply_status", mark, "burn", 6, 0, 6)
	py.resource = 60
	var mana_before := py.resource
	var hp_before: int = mark.hp
	var det: Ability = null
	for ab in py.abilities:
		if ab.display_name == "Detonation":
			det = ab
	ok(det != null, "Detonation is in the kit")
	if det != null:
		await scene._resolve(py, det, mark, "good")
		ok(not mark.has_status("burn"), "Detonation consumed the target's Burn")
		ok(mark.hp < hp_before, "...and the consumed Burn landed as damage")
		ok(py.resource > mana_before - det.cost,
			"...and Overburn refunded Mana for the turns eaten (%d -> %d)" % [
				mana_before, py.resource])
	scene.queue_free()
	await process_frame
	# Total Commitment widens WHICH banks it empties.
	var tc := await _spawn({"py_warm_glow": 1}, ["raider", "raider", "raider"])
	var py2 := _py(tc)
	if py2 != null:
		var tfoes: Array = tc.get("enemies")
		for f in tfoes:
			tc.call("_apply_status", f, "burn", 4, 0, 6)
		var det2: Ability = null
		for ab in py2.abilities:
			if ab.display_name == "Detonation":
				det2 = ab
		ok(py2.total_commitment == 1, "Total Commitment loads its flag")
		if det2 != null:
			await tc._resolve(py2, det2, tfoes[1], "good")
			ok(not tfoes[1].has_status("burn"), "the target's Burn went in")
			ok(not tfoes[0].has_status("burn"), "...and its left neighbour's")
			ok(not tfoes[2].has_status("burn"), "...and its right neighbour's")
	tc.queue_free()
	await process_frame
	# Cataclysm takes the WHOLE field.
	var cat := await _spawn({"py_hellfire": 1}, ["raider", "raider", "raider", "raider"])
	var py3 := _py(cat)
	if py3 != null:
		var cfoes: Array = cat.get("enemies")
		for f in cfoes:
			cat.call("_apply_status", f, "burn", 3, 0, 6)
		var det3: Ability = null
		for ab in py3.abilities:
			if ab.display_name == "Detonation":
				det3 = ab
		ok(py3.cataclysm == 1, "Cataclysm loads its flag")
		if det3 != null:
			py3.resource = 100
			await cat._resolve(py3, det3, cfoes[0], "good")
			var still_lit := 0
			for f in cfoes:
				if not f.dead and f.has_status("burn"):
					still_lit += 1
			ok(still_lit == 0,
				"Cataclysm eats every burning enemy's Burn (%d left lit)" % still_lit)
	cat.queue_free()
	await process_frame


func _live_kit_nodes() -> void:
	# The three remaining nodes whose effect only exists at battle time.
	var scene := await _spawn({"py_kindling": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py != null:
		ok(py.cinder_trail_ranks == 1, "Cinder Trail loads +1 Fireball Burn turn")
		var foe: BattleUnit = scene.get("enemies")[0]
		await scene._resolve(py, py.abilities[0], foe, "good")
		var b: Dictionary = foe.get_status("burn")
		ok(not b.is_empty(), "Fireball lit the target")
		if not b.is_empty():
			ok(int(b.get("turns", 0)) == 4,
				"...for 4 turns instead of 3 (got %d)" % int(b.get("turns", 0)))
	scene.queue_free()
	await process_frame
	# Backdraft deepens only what is already alight.
	var bd := await _spawn({"py_melt": 1}, ["raider", "raider"])
	var py2 := _py(bd)
	if py2 != null:
		var bfoes: Array = bd.get("enemies")
		bd.call("_apply_status", bfoes[0], "burn", 2, 0, 6)
		var back: Ability = null
		for ab in py2.abilities:
			if ab.display_name == "Backdraft":
				back = ab
		ok(back != null, "the node granted Backdraft")
		if back != null:
			await bd._resolve(py2, back, py2, "good")
			ok(int(bfoes[0].get_status("burn").get("turns", 0)) == 4,
				"Backdraft adds 2 turns to a burning enemy (got %d)" % \
					int(bfoes[0].get_status("burn").get("turns", 0)))
			ok(not bfoes[1].has_status("burn"),
				"...and lights NOTHING new")
	bd.queue_free()
	await process_frame
	# Pyroblast: half again into a burning target, and no more into a cold one.
	var pb := await _spawn({"py_focused": 1}, ["raider", "raider"])
	var py3 := _py(pb)
	if py3 != null:
		var blast: Ability = null
		for ab in py3.abilities:
			if ab.display_name == "Pyroblast":
				blast = ab
		ok(blast != null, "the node granted Pyroblast")
		if blast != null:
			ok(blast.damage == 55, "Pyroblast hits for 55% of Attack")
			ok(is_equal_approx(blast.delay, 6.0), "...and arrives 6.0 down the bar")
			var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
			ok(src.contains('ab.display_name == "Pyroblast" and strike_target.has_status("burn")'),
				"its +50% reads the target's Burn at the damage site")
	pb.queue_free()
	await process_frame
	# Twin Detonation really lands on the ability.
	var twin := await _spawn({"py_rekindle": 1}, ["raider", "raider"])
	var py4 := _py(twin)
	if py4 != null:
		for ab in py4.abilities:
			if ab.display_name == "Detonation":
				ok(ab.cooldown == 1,
					"Twin Detonation drops the cooldown to 1 (got %d)" % ab.cooldown)
	twin.queue_free()
	await process_frame
	# Chain Ignition splits a burning death among the survivors.
	var chain := await _spawn({"py_spreading": 1}, ["raider", "raider", "raider"])
	var py5 := _py(chain)
	if py5 != null:
		ok(py5.ember_wind == 1, "Chain Ignition loads its flag")
		var cfoes: Array = chain.get("enemies")
		cfoes[0].burn_at_death = 5
		cfoes[0].burn_tick_at_death = 6
		cfoes[0].dead = true
		cfoes[0].ember_consumed = false
		chain.call("_update_talent_chips")
		var spread := 0
		for f in cfoes:
			if f.dead:
				continue
			spread += int(f.get_status("burn").get("turns", 0))
		ok(spread == 5,
			"5 turns of a burning death land whole across the survivors (got %d)" % spread)
		ok(cfoes[1].has_status("burn") and cfoes[2].has_status("burn"),
			"...and BOTH survivors caught, rather than one taking the lot")
	chain.queue_free()
	await process_frame
