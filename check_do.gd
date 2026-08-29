# BATCH DO — THE TALENT CHARTER, ASSERTED AS A PROPERTY.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_do.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR"
#
# **THE RULE THIS FILE EXISTS FOR:** a talent may not grant an ability, and may
# not depend on an ability the hero is not guaranteed to have. Talents are
# chosen before the run knowing nothing; abilities come from the draft and runes
# sharpen them. A talent modifying the spec's PROTECTED CORE is guaranteed and
# permitted — that is the settled reading of the charter's own §1, and it is
# what makes the trees 324-of-324 clean rather than 235.
#
# **IT ASSERTS THE PROPERTY AND PRINTS THE LIVE COUNT, AND THAT ORDER IS THE
# WHOLE LESSON OF DN.** DN's own gate asserted a NUMBER (`check_da` at 36) and
# its first battery caught it, costing a second thirty-five-minute frozen run.
# A number is a fact about today; a property is a fact about the rule. Every
# count below is PRINTED beside its assertion so a regression names itself,
# and not one of them is asserted.
#
# IT DELIBERATELY READS ONLY THE **SPEC** DRAFT POOL AND NEVER THE CLASS ONE.
# `check_da` §3 fingerprints a hand-rolled corpus walk as the PAIR of
# draft-pool calls, and this gate needs only the spec half — so it needs no
# `WALK_EXEMPT` entry, which is better than having one. (DN paid a whole
# battery to learn that.)
#
# AND THE OTHER HALF OF THE SAME LESSON, LEARNED HERE: **the fingerprint is a
# plain substring, so a COMMENT naming the forbidden call accuses the file just
# as loudly as calling it would.** This block said "does not call
# `Classes.class_draft` + "_pool("` in its first draft and `check_da` went
# 37/2 on it — the exact self-accusation `check_da`'s own header warns about,
# and it does not care that the mention was a denial.
extends SceneTree

var checks := 0
var fails := 0

# The twenty-two abilities that left the talent trees for the draft, with the
# node id each one used to hang on. THE ID IS THE HALF THAT MATTERS: every one
# of those cells still exists, in the same lane and the same row, because a
# node that MOVES row is mispriced by `Talents.cells_spent` and DN measured
# that as a silent negative purse.
const MOVED := {
	"Battle Shout": "bz_battle_shout", "Rampage": "bz_rampage",
	"Lunge": "sm_lunge", "Execute": "sm_execute",
	"Hold the Line": "wd_hold_line", "Backdraft": "py_melt",
	"Immolate": "py_flame_shield", "Pyroblast": "py_focused",
	"Firestorm": "py_firestorm", "Phoenix Rebirth": "py_rebirth",
	"Rime": "cr_rime", "Glacial Prison": "cr_numbing",
	"Cryoclasm": "cr_lance_focus", "Shatter": "cr_shatter",
	"Overcharge": "ar_overcharge", "Magi's Wrath": "ar_wrath",
	"Divine Plea": "hl_divine_plea", "Intercession": "hl_inner_faith",
	"Sacred Resolve": "dv_resolve", "Bulwark of Fortitude": "dv_bulwark",
	"Mind Flay": "oc_mind_flay", "Mass Hysteria": "oc_hysteria",
}

# Where each re-authored cell sat before DO opened it. Asserted rather than
# derived, because "no node moves row or lane" is the batch's own promise and a
# promise checked against the thing it describes is not checked at all.
const CELL_HOME := {
	"bz_battle_shout": ["Fury", 3], "bz_rampage": ["Warpath", 9],
	"sm_lunge": ["Blade", 2], "sm_execute": ["Blade", 9],
	"wd_hold_line": ["Banner", 9], "py_melt": ["Kindling", 4],
	"py_flame_shield": ["Inferno", 4], "py_focused": ["Detonation", 4],
	"py_firestorm": ["Kindling", 9], "py_rebirth": ["Inferno", 9],
	"cr_rime": ["Winter", 4], "cr_numbing": ["Deep Freeze", 4],
	"cr_lance_focus": ["Thaw", 4], "cr_shatter": ["Thaw", 9],
	"ar_overcharge": ["Resonance", 4], "ar_wrath": ["Overload", 9],
	"hl_divine_plea": ["Radiance", 4], "hl_inner_faith": ["Vigil", 4],
	"dv_resolve": ["Zeal", 3], "dv_bulwark": ["Bulwark", 9],
	"oc_mind_flay": ["Madness", 3], "oc_hysteria": ["Madness", 9],
	# The three re-authored for the OTHER reason — they read a drawn ability
	# rather than granting one.
	"bm_devoted_fury": ["devotion", 4], "bm_reserves": ["handler", 3],
	"cr_icy_resolve": ["Winter", 5],
}

# The payload terms §2's clause-cuts removed. A cut clause whose code keeps
# paying it is the defect this project has found five times, so the terms are
# asserted ABSENT from the whole of `scripts/` — field, read site and all.
const CUT_TERMS := ["sunder_guard_bd", "rallying_stomp_ranks",
	"bulwark_line_ranks"]

# Statuses each spec can reach without a draw, for §4's sweep. Hand-authored
# and NOT derived, for DN's reason: the declarative `applies_status` map covers
# only cards that declare one, and most of these are applied from inside a
# `battle.gd` handler or by the passive itself, where no table can see them.
# Every entry names the guaranteed source it comes from.
const GUARANTEED_STATUS := {
	"berserker": {"cripple": "bz_hemorrhage applies it from bloodloss"},
	"warden": {"sunder": "Crushing Blow, PROTECTED CORE",
		"shieldwall": "Shieldwall, PROTECTED CORE",
		"stunned": "wd_ricochet applies it on a Block"},
	"swordmaster": {"stunned": "Pommel Strike, PROTECTED CORE"},
	"pyromancer": {"burn": "Fireball and Wildfire, PROTECTED CORE"},
	"cryomancer": {"chilled": "Frostbolt and Razor Ice, PROTECTED CORE",
		"frozen": "the Glacial Hold passive, at 4 Chilled"},
	"arcanist": {},
	"holy": {"empower": "the Mercy passive", "renewal": "Renewal, PROTECTED CORE"},
	"inquisitor": {"faith": "the Conviction passive",
		"cons_ground": "Consecrated Ground, PROTECTED CORE",
		"zeal": "Blessing of Zeal, PROTECTED CORE",
		"sunder": "dv_judgement applies it itself"},
	"occultist": {"ruin": "the Wrath of the Old Gods passive",
		"cripple": "Shadowrend, PROTECTED CORE",
		"exposed": "Hex of Ruin, PROTECTED CORE",
		"bewitch": "Bewitch, PROTECTED CORE",
		"decay": "oc_emp_hex applies it itself"},
	"beastmaster": {"loyalty": "the Pack Bond passive",
		"instinct": "Hunter's Instinct, PROTECTED CORE"},
	"sharpshooter": {},
	"mystic": {"poison": "the Trapper passive and Venom Coating",
		"cripple": "Snare Trap, PROTECTED CORE", "slow": "Snare Trap"},
}

# The word forms a node's rendered text uses for each status id.
const STATUS_FORMS := {
	"dazed": ["Dazed", "Dazing"], "cripple": ["Crippled", "Cripples", "Cripple"],
	"exposed": ["Exposed", "Exposes"], "stunned": ["Stunned", "Stun"],
	"psychosis": ["Psychosis", "Psychotic"], "bewitch": ["Bewitched", "Bewitchment"],
	"hysteria": ["Hysterical", "Hysteria"], "burn": ["Burning", "Burn"],
	"chilled": ["Chilled"], "frozen": ["Frozen", "Freeze", "Freezing"],
	"poison": ["Poison", "Poisoned"], "sunder": ["Sundered", "Sundering", "Sunder"],
	"slow": ["Slowed"], "decay": ["Decay"], "ruin": ["Ruined", "Ruin"],
	"blind": ["Blinded", "Blind"], "frostbite": ["Frostbites", "Frostbite"],
	"empower": ["Empowering", "Empowered", "Empower"], "renewal": ["Renewal"],
	"shieldwall": ["Shieldwall"], "loyalty": ["Loyalty"],
	"instinct": ["Hunter's Instinct"], "faith": ["Faith"],
	"cons_ground": ["Consecrated Ground"], "zeal": ["Blessing of Zeal"],
}


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails += 1
		print("  FAIL: %s" % msg)


func _bounded(hay: String, needle: String) -> bool:
	var re := RegEx.create_from_string("(?<![A-Za-z])" + _esc(needle) + "(?![A-Za-z])")
	return re != null and re.search(hay) != null


func _esc(s: String) -> String:
	var out := ""
	for c in s:
		if c in "\\^$.|?*+()[]{}":
			out += "\\" + c
		else:
			out += c
	return out


# ---------------- §1 — THE CHARTER, AS TWO PROPERTIES ----------------
func _s1_charter() -> void:
	print("\n§1 — the charter, asserted as a property and counted beside it")
	var granting: Array = []
	var nodes := 0
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			nodes += 1
			var g := Talents.granted_name(n.get("payload", {}))
			if g != "":
				granting.append("%s/%s -> %s" % [spec, n["id"], g])
	# PROPERTY ONE: no talent node grants an ability.
	ok(granting.is_empty(),
		"a talent node grants an ability: %s" % ", ".join(granting))
	ok(Classes.talent_granted_names().is_empty(),
		"`Classes.talent_granted_names()` is not empty")
	print("  %d nodes; %d grant an ability" % [nodes, granting.size()])

	# PROPERTY TWO: no node names an ability outside its spec's PROTECTED CORE.
	# Resolution order is DN's, and it is load-bearing: a talent tree is a
	# NAMESPACE, so a node's own tree beats the global corpus. `wd_spiked` is
	# NAMED "Spite" and the Berserker has a DRAFTED ability called Spite; a
	# matcher without same-tree precedence invents a cross-spec bet that does
	# not exist. Word boundaries matter for the same reason — "Berserk" sits
	# inside "Berserker" and "Heal" inside "Health".
	var corpus: Array = []
	for ab in Classes.ability_corpus():
		corpus.append(String(ab.display_name))
	corpus.sort_custom(func(a, b): return a.length() > b.length())
	var bets: Array = []
	var core_readers := 0
	var tree_readers := 0
	for spec in Talents.LANE_TREES:
		var own_names := {}
		for n2 in Talents.LANE_TREES[spec]:
			own_names[String(n2["name"])] = true
		var protected: Array = Classes.protected_names(spec)
		var enablers: Array = Classes.core_enablers(spec)
		for n3 in Talents.LANE_TREES[spec]:
			var text := Talents.desc_for(n3, 1)
			var masked := text
			var named_core := false
			var named_tree := false
			for nm in corpus:
				if nm.length() < 4 or not _bounded(masked, nm):
					continue
				masked = masked.replace(nm, "#".repeat(nm.length()))
				if String(n3["name"]) == nm or own_names.has(nm):
					named_tree = true
					continue
				if protected.has(nm) or enablers.has(nm):
					named_core = true
					continue
				bets.append("%s/%s names `%s`" % [spec, n3["id"], nm])
			if named_core:
				core_readers += 1
			if named_tree:
				tree_readers += 1
	ok(bets.is_empty(),
		"a node names an ability outside its protected core: %s" % ", ".join(bets))
	print("  %d nodes name a PROTECTED CORE ability; %d name a node in their own tree; %d name something drawn" % [
		core_readers, tree_readers, bets.size()])


# ---------------- §2 — WHERE THE TWENTY-TWO LANDED ----------------
func _s2_landed() -> void:
	print("\n§2 — the twenty-two moved into the draft, and none was deleted")
	var spec_total := 0
	for spec in Classes.all_specs():
		spec_total += Classes.spec_draft_pool(spec).size()
	print("  SPEC_DRAFT_POOLS holds %d entries across twelve pools" % spec_total)
	for ab_name in MOVED:
		var homes: Array = []
		for spec2 in Classes.all_specs():
			if Classes.spec_draft_pool(spec2).has(ab_name):
				homes.append(String(spec2))
		ok(homes.size() == 1,
			"`%s` drafts from %d spec pools, want exactly 1 (%s)" % [
				ab_name, homes.size(), str(homes)])
		if homes.size() != 1:
			continue
		var resolved = Classes.spec_pool_ability(homes[0], ab_name)
		ok(resolved != null, "`%s` no longer resolves to an ability" % ab_name)
		if resolved != null:
			ok(String(resolved.description) != "",
				"`%s` resolves to an ability with no card text" % ab_name)
	# EVERY POOL ENTRY IN THE GAME STILL RESOLVES. The move took the sixteen
	# `new_ability` definitions out of the node payloads, and eight of them were
	# reachable ONLY through `pool_ability`'s fall-through to the trees — so a
	# relocation that missed one would have silently emptied a SPEC_POOLS entry
	# the zone boss offers.
	var unresolved: Array = []
	for spec3 in Classes.all_specs():
		for nm2 in Classes.spec_pool(spec3):
			if Classes.spec_pool_ability(spec3, String(nm2)) == null:
				unresolved.append("SPEC_POOLS %s/%s" % [spec3, nm2])
		for nm3 in Classes.spec_draft_pool(spec3):
			if Classes.spec_pool_ability(spec3, String(nm3)) == null:
				unresolved.append("draft %s/%s" % [spec3, nm3])
	ok(unresolved.is_empty(), "pool entries resolve to nothing: %s" % ", ".join(unresolved))
	print("  %d pool entries checked, %d unresolved" % [spec_total, unresolved.size()])


# ---------------- §3 — THE CELLS DID NOT MOVE, AND THE TERMS DID GO ----------
func _s3_cells_and_terms() -> void:
	print("\n§3 — no cell changed row or lane; the cut clauses took their terms")
	for nid in CELL_HOME:
		var want: Array = CELL_HOME[nid]
		var found: Dictionary = {}
		for spec in Talents.LANE_TREES:
			for n in Talents.LANE_TREES[spec]:
				if String(n["id"]) == nid:
					found = n
		ok(not found.is_empty(), "re-authored cell `%s` no longer exists" % nid)
		if found.is_empty():
			continue
		ok(String(found["lane"]) == String(want[0]) and int(found["row"]) == int(want[1]),
			"`%s` moved to %s/%d — it must stay at %s/%d (cells_spent prices off the ROW)" % [
				nid, found["lane"], int(found["row"]), want[0], int(want[1])])
	print("  %d re-authored cells, all in their original lane and row" % CELL_HOME.size())
	# THE NEGATIVE CONTROL'S PERMANENT HALF: the three terms are gone from the
	# whole of `scripts/`, not just from the payload that used to write them.
	#
	# **COMMENT LINES ARE STRIPPED FIRST, AND THAT IS NOT A LOOPHOLE — IT IS THE
	# `check_da` SELF-ACCUSATION TRAP IN A SECOND PLACE.** The comments that
	# RECORD a cut necessarily NAME the thing that was cut ("`rallying_stomp_ranks`
	# went with the clause"), and a bare substring search cannot tell a record
	# of a removal from the removal not having happened. It fired on exactly
	# that during DO's own negative-control run. What must be absent is the
	# CODE; the prose explaining its absence is the point of keeping it.
	var srcs := {}
	for f in ["talents.gd", "battle.gd", "unit.gd", "runes.gd", "classes.gd"]:
		var body := ""
		for line in FileAccess.get_file_as_string("res://scripts/" + f).split("\n"):
			if not String(line).strip_edges().begins_with("#"):
				body += line + "\n"
		srcs[f] = body
	for term in CUT_TERMS:
		var where: Array = []
		for f2 in srcs:
			if String(srcs[f2]).contains(term):
				where.append(String(f2))
		ok(where.is_empty(),
			"`%s` survives in %s — a cut clause whose code still pays it" % [
				term, ", ".join(where)])
	print("  %d cut payload terms, all absent from scripts/" % CUT_TERMS.size())


# ---------------- §4 — THE STATUS SWEEP. REPORTS, RULES ON NOTHING ----------
func _s4_status_sweep() -> void:
	print("\n§4 — nodes reading a status their own spec cannot guarantee")
	print("  A REPORT, NOT A GATE. DN's instrument matched ability NAMES and this")
	print("  class of bet is invisible to it — `sm_precision` was found by reading.")
	var rows: Array = []
	for spec in Talents.LANE_TREES:
		var guaranteed: Dictionary = GUARANTEED_STATUS.get(spec, {})
		for n in Talents.LANE_TREES[spec]:
			var text := Talents.desc_for(n, 1)
			for sid in STATUS_FORMS:
				if guaranteed.has(sid):
					continue
				for form in STATUS_FORMS[sid]:
					if _bounded(text, String(form)):
						rows.append("%-13s %-20s reads %s" % [spec, String(n["id"]), sid])
						break
	for r in rows:
		print("    %s" % r)
	print("  %d node/status pairs have no guaranteed source in their own spec." % rows.size())
	# THE ONE THIS BATCH DID RULE ON, and it is asserted because §3 of the brief
	# singled it out. `sm_precision` read Dazed, Crippled and Exposed; the
	# Swordmaster guarantees none of the three, and the last non-drawn source of
	# the other two — `sm_lunge` — left the tree in this same batch.
	var prec := ""
	for n2 in Talents.LANE_TREES["swordmaster"]:
		if String(n2["id"]) == "sm_precision":
			prec = Talents.desc_for(n2, 1)
	ok(prec.contains("Stunned"), "sm_precision no longer reads Stunned")
	for gone in ["Dazed", "Crippled", "Exposed"]:
		ok(not prec.contains(gone),
			"sm_precision still reads %s, which the Swordmaster cannot guarantee" % gone)
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(bsrc.contains('attacker.precision_ranks > 0 and strike_target.has_status("stunned")'),
		"the read site did not follow the text onto `stunned`")


# ---------------- §5 — THE STANDING RULE IS WRITTEN DOWN ----------------
func _s5_recorded() -> void:
	print("\n§5 — the rule is recorded where a later batch will read it")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("A talent may not grant an ability"),
		"CLAUDE.md does not carry the charter sentence")
	ok(cm.contains("PROTECTED CORE is guaranteed and permitted")
		or cm.contains("protected core is guaranteed and permitted"),
		"CLAUDE.md does not carry the ruling that settles §0 versus §1")
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(master.contains("149 of 149"), "master.html does not state the current draft total")


func _initialize() -> void:
	print("check_do — the talent charter, asserted as a property")
	_s1_charter()
	_s2_landed()
	_s3_cells_and_terms()
	_s4_status_sweep()
	_s5_recorded()
	print("\ncheck_do: %d checks, %d failures" % [checks, fails])
	quit()
