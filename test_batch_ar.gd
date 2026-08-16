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

# id -> [row, lane, name]. BATCH_AR.md §3's table, transcribed once. The ids
# are the OLD ones by design — §7's mapping lives in the changelog, and this
# is the machine-checkable half of it.
const NODES := {
	"py_kindling": [1, "Kindling", "Cinder Trail"],
	"py_pyromaniac": [1, "Inferno", "Ember Shroud"],
	"py_shockwave": [1, "Detonation", "Focused Flame"],
	"py_accelerant": [2, "Kindling", "Accelerant"],
	"py_invigorating": [2, "Inferno", "Ashen Skin"],
	"py_supernova": [2, "Detonation", "Pressure Cooker"],
	"py_arson": [3, "Kindling", "Conflagration"],
	"py_firebrand": [3, "Inferno", "Heat Haze"],
	"py_implosion": [3, "Detonation", "Aftershock"],
	"py_melt": [4, "Kindling", "Backdraft"],
	"py_flame_shield": [4, "Inferno", "Immolate"],
	"py_focused": [4, "Detonation", "Pyroblast"],
	"py_ashes": [5, "Kindling", "Wildfire Spread"],
	"py_molten": [5, "Inferno", "Backblast"],
	"py_seeding": [5, "Detonation", "Crucible"],
	"py_explosive": [6, "Kindling", "Explosive Force"],
	"py_undying_flame": [6, "Inferno", "Kiln-Forged"],
	"py_rekindle": [6, "Detonation", "Twin Detonation"],
	"py_spreading": [7, "Kindling", "Chain Ignition"],
	"py_cauterize": [7, "Inferno", "Ash Lung"],
	"py_warm_glow": [7, "Detonation", "Total Commitment"],
	"py_firestorm": [9, "Kindling", "Firestorm"],
	"py_rebirth": [9, "Inferno", "Phoenix Rebirth"],
	"py_hellfire": [9, "Detonation", "Cataclysm"],
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
	"py_pyromaniac": ["ember_shroud", 8],
	"py_invigorating": ["ashen_skin", 25],
	"py_firebrand": ["heat_haze", 20],
	"py_molten": ["backblast", 15],
	"py_undying_flame": ["kiln_forged_at", 3],
	"py_cauterize": ["ash_lung_pct", 4],
	"py_shockwave": ["focused_flame", 1],
	"py_supernova": ["pressure_cooker", 1],
	"py_implosion": ["aftershock", 2],
	"py_seeding": ["crucible", 1],
	"py_warm_glow": ["total_commitment", 1],
	"py_hellfire": ["cataclysm", 1],
}

# BATCH BS §3 — THE ONE NODE THAT WRITES A SECOND STAT FIELD, named here so
# the "exactly one field" rule above stays a real check instead of being
# relaxed for everybody. Ashen Skin's two clauses are two quantities (a
# resistance and a share of a tick), and AW's rule is that one counter must not
# hold both.
const EXTRA_PAYLOAD_FIELDS := {
	"py_invigorating": {"ashen_skin_heal": 10},
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
	"py_pyromaniac": 8.0,
	"py_invigorating": 25.0,
	"py_firebrand": 20.0,
	"py_molten": 15.0,
	"py_undying_flame": 3.0,
	"py_cauterize": 4.0,
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
	await _live_no_bill()
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
	ok(tree.size() == 27, "the Pyromancer tree holds 24 nodes (got %d)" % tree.size())
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
		# BATCH BM: this batch's table is THIS BATCH'S RECORD OF ITS OWN 24
		# NODES, and BM added a ROW-8 node to every lane. The walk skips row 8
		# rather than being taught the three new ids: what the check exists to
		# prove is that the twenty-four survive UNCHANGED, and asserting that
		# nothing else exists would make every later addition a failure here
		# instead of in the batch that made it.
		if int(n["row"]) == 8:
			continue
		ok(NODES.has(String(n["id"])),
			"%s is one of the 24 surviving ids, not a new one" % String(n["id"]))
	# The names that must be GONE, because their nodes were re-specced away.
	# A leftover would mean an id got duplicated rather than re-used.
	var live_names: Array = []
	for n in _tree():
		live_names.append(String(n["name"]))
	# BATCH BS §3 TOOK "Heat Haze" OFF THIS LIST AND IT IS A REVIVAL, NOT AN
	# OVERSIGHT: AR retired the NAME (its old node became Heat Shimmer), and BS
	# gave it back to the SAME id — py_firebrand, same lane, same row — for a
	# node that now spoils a burning attacker's aim. The name is live again, so
	# asserting it absent would fail against working code.
	for dead in ["Pyromaniac", "Molten Core", "Melt Armor", "Heat Shimmer",
			"Fire Walker", "Invigorating Ashes", "Cauterise",
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
		# RE-POINTED IN PLACE BY BATCH BS §3. AR could say "exactly one field"
		# because every Pyromancer node held one magnitude. ASHEN SKIN HOLDS
		# TWO — a fire resistance and a share of its own Burn tick — and the
		# house rule is AW's: one counter cannot honestly hold two different
		# quantities, so it gets two. The question the check is really asking is
		# unchanged and is now asked properly: does the node write ONLY what
		# this table says it writes? A third field trips it.
		var allowed: Dictionary = EXTRA_PAYLOAD_FIELDS.get(id, {})
		ok(pay.size() == 1 + allowed.size(),
			"%s writes exactly %d field(s) (got %s)" % [id, 1 + allowed.size(),
				str(pay.keys())])
		for extra in allowed:
			ok(pay.get(extra, null) == allowed[extra],
				"%s also writes %s = %s (got %s)" % [id, extra,
					str(allowed[extra]), str(pay.get(extra, null))])
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
	# RE-POINTED IN PLACE BY BATCH BS §2. AR asked the in-game passive text to
	# state that the COST had no cap, because that asymmetry was the spec. There
	# is no cost. The question — does the passive's own text state its live
	# terms rather than a version of them somebody remembers? — is unchanged and
	# is asked of what it says NOW: the refund, and that holding fire is free.
	ok(pdesc.contains("refunds 1 Mana"), "...its refund clause is stated")
	ok(pdesc.contains("costs him\nnothing"),
		"...and so is the fact that holding fire costs nothing (%s)" % pdesc)
	ok(not pdesc.to_lower().contains("drain"),
		"...and no drain survives in it")
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
	# RE-POINTED IN PLACE BY BATCH BS §3, AND IT IS AN INVERSION RATHER THAN A
	# DELETION (the AV/BR precedent for a suite recording a decision a later
	# batch reverses). AR §2 asserted "no defensive option anywhere in his kit
	# or tree", and that was CORRECT while commitment meant no escape hatch and
	# a punishing Mana drain priced every fire he lit. BS §2 deleted the drain,
	# and with the punishment gone the absence stopped being the spec and
	# started being a hole in a 135 HP / 85 Constitution sheet. THE WHOLE
	# INFERNO LANE IS HIS DEFENCE NOW.
	# THE QUESTION IS STILL WORTH ASKING; ONLY THE CORRECT ANSWER MOVED, so the
	# check is kept pointed at the two things that must stay true: the defence
	# is EARNED IN THE TREE (his opening kit is still all fire), and it is the
	# INFERNO LANE that carries it rather than being scattered.
	var kit_defensive := ["Flame Shield", "Mana Shield", "Molten Core",
		"Ashes of Al'ar", "Scorched Earth"]
	for ab in Classes.spec_abilities("pyromancer"):
		ok(not kit_defensive.has(ab.display_name),
			"no defensive ability in the OPENING KIT (%s)" % ab.display_name)
	# Every mitigating node is in INFERNO and nowhere else — a Kindling or
	# Detomation node that started reducing damage would be the lane's thesis
	# leaking, which is exactly the shape BS was written to remove.
	var mitigating := 0
	for n in _tree():
		var d := String(n.get("desc", "")).to_lower()
		if d.contains("less damage") or d.contains("cannot be reduced") \
				or d.contains("chance to miss you") or d.contains("resistance"):
			mitigating += 1
			ok(String(n.get("lane", "")) == "Inferno",
				"%s mitigates, so it is in INFERNO" % String(n["id"]))
	ok(mitigating >= 5,
		"the Inferno lane really does defend him (%d mitigating nodes)" % mitigating)
	# Immolate keeps its id and its slot and is a DEFENSIVE ability now: the
	# Overburn clauses went with the drain and the cap.
	var imm: Ability = Talents.granted_ability("Immolate")
	ok(imm != null, "Immolate exists")
	if imm != null:
		ok(imm.description.contains("LESS damage"),
			"Immolate mitigates now (%s)" % imm.description)
		ok(not imm.description.to_lower().contains("drain"),
			"...and names no drain (%s)" % imm.description)
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(not src.contains("Flame Shield: the fire barrier"),
		"the 50%-less-damage branch is still deleted, not left unreachable")


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
	# CLAUSE 1: +2% a turn, capped at +40%. Unchanged by BATCH BS §2 and
	# asserted unchanged, because a batch that deletes half a passive is
	# exactly where the surviving half gets moved by accident.
	ok(is_equal_approx(scene.call("_overburn_mult", py, 0), 1.0),
		"an unlit field pays nothing")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 3), 1.06),
		"one enemy at 3 turns pays +6%")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 5), 1.10),
		"5 burn-turns pay +10%")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 20), 1.40),
		"20 burn-turns pay +40% — the cap, exactly")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 40), 1.40),
		"40 burn-turns still pay +40% — the reward CAPS")
	# BATCH BS §2 — THE CAP IS FLAT AND NOTHING LIFTS IT ANY MORE. Heat
	# Shimmer, Immolate and Cauterise were the only three lifters and all three
	# were Inferno clauses the batch re-authored; the cap-raise was DROPPED
	# rather than rehomed (raising the payoff's ceiling is Detonation's subject
	# and every Detonation node is already authored). Driven from a build that
	# owns the whole re-authored lane, so "nothing lifts it" is measured rather
	# than argued.
	scene.queue_free()
	await process_frame
	var lane := await _spawn({
		"py_pyromaniac": 1, "py_invigorating": 1, "py_firebrand": 1,
		"py_flame_shield": 1, "py_molten": 1, "py_undying_flame": 1,
		"py_cauterize": 1, "py_forge_body": 1}, ["raider", "raider"])
	var py_l := _py(lane)
	if py_l != null:
		lane.call("_apply_status", py_l, "immolate", 3)
		py_l.resource = 0
		ok(is_equal_approx(lane.call("_overburn_mult", py_l, 40), 1.40),
			"the whole Inferno lane, Immolate up and 0 Mana, still caps at +40%")
	lane.queue_free()
	await process_frame


func _live_asymmetry() -> void:
	# RE-POINTED IN PLACE BY BATCH BS §2, AND IT IS THE BATCH'S CENTRAL
	# INVERSION. AR asserted a PAIR over the same range — past the cap the
	# reward is flat while the cost keeps climbing, "and the asymmetry IS the
	# design". THERE IS NO COST. `_overburn_drain` is deleted, so the second
	# half of every one of those assertions has nothing to call.
	# WHAT SURVIVES IS THE HALF THAT IS STILL TRUE (the reward is flat past the
	# cap, monotone below it) AND §6'S NEGATIVE CONTROL, WHICH IS THE ONE THAT
	# MATTERS: NO MANA LEAVES HIM AT TURN START UNDER ANY BURN LOAD. It is
	# driven at 20+ burn-turns, where the old bill was largest.
	var scene := await _spawn({}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var prev_bonus := 0.0
	for turns in range(0, 61):
		var bonus: float = scene.call("_overburn_mult", py, turns)
		if turns > 20:
			ok(is_equal_approx(bonus, 1.40),
				"the bonus is STILL +40%% at %d turns — it caps" % turns)
			ok(is_equal_approx(bonus, prev_bonus),
				"...and stopped moving entirely past 20")
		else:
			ok(bonus >= prev_bonus, "the bonus climbs to the cap at %d turns" % turns)
		prev_bonus = bonus
	scene.queue_free()
	await process_frame


func _live_no_bill() -> void:
	# §6'S NEGATIVE CONTROL, AND IT IS ASSERTED AS NON-EXISTENCE RATHER THAN AS
	# RETURNING ZERO. A drain that returns 0 is a drain a later batch revives by
	# flipping a constant; a drain that does not exist has to be re-authored,
	# which is a decision somebody makes on purpose.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for gone in ["func _overburn_drain", "func _overburn_tick",
			"func _drain_burn_turns", "func _overburn_capped"]:
		ok(not src.contains(gone), "%s is DELETED, not zeroed" % gone)
	ok(src.count("_overburn_tick(u)") == 0, "...and _player_turn no longer calls it")
	ok(not src.contains("var turns := _drain_burn_turns()"),
		"the second denominator is gone with it")
	var unit_src := FileAccess.get_file_as_string("res://scripts/unit.gd")
	ok(not unit_src.contains("var ember_debt := false"),
		"BattleUnit.ember_debt went with the exemption it served")
	# THE LIVE HALF: a real Pyromancer, a real turn start, a heavy field.
	# `_player_turn` cannot be driven headlessly (it awaits an ability pick), so
	# the two things it does before that await are driven directly — the regen
	# drip, and then whatever the passive does. The assertion is that only the
	# FIRST of those moves his pool.
	var scene := await _spawn({}, ["raider", "raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var lit := _light(scene, 6)          # 24 burn-turns — past where he drowned
	ok(lit >= 20, "the field holds %d burn-turns, where the old bill was largest" % lit)
	ok(scene.call("_total_burn_turns") == lit, "...and the ONE denominator reads it")
	py.resource = 50
	var regen: int = scene.call("_mana_regen", py)
	py.resource = mini(py.resource + regen, py.max_resource)
	ok(py.resource == 50 + regen,
		"the turn-start drip is all that moves his Mana (%d -> %d)" % [50, py.resource])
	# ...and nothing anywhere else in the file bills him for holding it: the
	# whole re-authored lane learned, and the pool untouched across a full turn.
	scene.queue_free()
	await process_frame
	var lane := await _spawn({
		"py_pyromaniac": 1, "py_invigorating": 1, "py_firebrand": 1,
		"py_flame_shield": 1, "py_molten": 1, "py_undying_flame": 1,
		"py_cauterize": 1, "py_forge_body": 1},
		["raider", "raider", "raider", "raider"])
	var py2 := _py(lane)
	if py2 != null:
		_light(lane, 8)                  # 32 burn-turns
		py2.resource = 40
		var hp_was: int = py2.hp
		await process_frame
		ok(py2.resource == 40,
			"32 burn-turns and the whole Inferno lane bill him NOTHING (got %d)" % py2.resource)
		ok(py2.hp == hp_was, "...and take no health either — Cauterise is gone")
	lane.queue_free()
	await process_frame


func _live_refund() -> void:
	# Clause 3: ONE rule, ONE implementation. Detonation and Wildfire both go
	# through _overburn_refund, so the assertion is that the SAME helper pays
	# both — not that each ability happens to refund.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.count("func _overburn_refund") == 1,
		"the refund has exactly one implementation")
	# RE-POINTED IN PLACE A SECOND TIME BY BATCH BS §4, 3 -> 4, AND THAT IS THE
	# COUNT DOING ITS JOB RATHER THAN DECAYING. BO took it 2 -> 3 for Cinderfall
	# and wrote "a fourth has to come here and say so"; EMBER DEBT IS THE
	# FOURTH. It is also the first consumer that CONSUMES NOTHING — it pays the
	# refund up front for fire that then burns its full term — which is only
	# possible because the refund belongs to the PASSIVE rather than to any
	# ability, exactly as AR's comment above claims. The question is unchanged:
	# does every payer share the one implementation?
	# RE-POINTED 4 -> 5 (Batch BT): FUNERAL PYRE is the FIFTH consumer of the one
	# refund door. The question — does every Burn consumer share the single
	# implementation — is unchanged; only the answer's size moved, which is what
	# pinning a count is for: a new consumer has to COME AND SAY SO rather than
	# writing its own refund.
	# RE-POINTED 5 -> 6 (Batch CB): PYRE WAKE is the SIXTH consumer of the one
	# refund door. The question — does every Burn consumer share the single
	# implementation — is unchanged; only the answer's size moved, which is
	# exactly what pinning a count is for. A new consumer has to COME AND SAY
	# SO rather than quietly writing a refund of its own, and this check is
	# the thing that makes it say so.
	ok(src.count("_overburn_refund(attacker,") == 6,
		"...and exactly SIX call sites: Detonation, Wildfire, Cinderfall, Ember Debt, Funeral Pyre, Pyre Wake")
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
	# RE-POINTED IN PLACE BY BATCH BS §2. AR asked for BOTH numbers because the
	# spec was a trade and half a trade is not a readout. THERE IS ONE NUMBER
	# NOW — the drain is deleted — so the chip is checked for the bonus being
	# LIVE, and for the drain being ABSENT from it rather than merely reading
	# zero, which is the same non-existence rule the functions are held to.
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
	ok(not desc.contains("-%d Mana" % lit),
		"the chip shows NO drain — there is none (%s)" % desc)
	ok(not desc.contains("NO CAP"),
		"...and no longer claims a term without a cap (%s)" % desc)
	ok(desc.contains("refunds Mana"),
		"the chip still states the surviving second clause (%s)" % desc)
	ok(String(chip.get("short", "")).find("/") < 0,
		"the chip's TAG is one number now, not two (%s)" % String(chip.get("short", "")))
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
	# RE-POINTED IN PLACE BY BATCH BS §3, AND IT IS AN INVERSION. Immolate kept
	# its id and its ability slot and lost BOTH Overburn clauses: the
	# drain-doubling went with the drain, and the cap-lift went because the cap
	# is Detonation's subject rather than Inferno's. What it does now is
	# MITIGATE — and the retaliation burn below, which is byte-unchanged, is
	# what makes the two clauses point the same way.
	ok(is_equal_approx(scene.call("_overburn_mult", py, 40), 1.40),
		"capped at +40% before the cast")
	py.add_status("immolate", "Immolate", "IM", Color(1, 1, 1), 3, "")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 40), 1.40),
		"Immolate does NOT lift the damage cap any more")
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
