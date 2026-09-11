# BATCH DO — THE TALENT CHARTER, ASSERTED AS A PROPERTY.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_do.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR"
#
# **THE RULE THIS FILE EXISTS FOR, SINCE BATCH FX: THE DESIGNER'S LINE — a
# talent may not touch a rune, an ability, a passive or an engine.** Talents are
# chosen before the run knowing nothing; abilities come from the draft and runes
# sharpen them. DO's own rule was narrower — a talent may not GRANT an ability,
# nor depend on one the hero is not guaranteed to have — and it PERMITTED a node
# to modify the spec's PROTECTED CORE, which is what made the twelve spec trees
# 324-of-324 clean rather than 235. **FX superseded that permitted list and
# deleted the twelve trees with it** (CLAUDE.md's DO block now opens by saying
# so). The one tree is twenty-seven stat nodes, so §1 asserts the line over
# `Talents.TREE`; the no-grant half and the status half DO wrote still stand
# inside it, and §4 still sweeps the second.
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
# node id each one used to hang on. THE IDS ARE PROVENANCE NOW: they named cells
# of the twelve spec trees, which BATCH FX deleted, and the half of §3 that held
# each cell to its lane and row went with them (§3 says why). §2 reads only the
# NAMES — where each card landed — and that question is unchanged.
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

# `CELL_HOME` — the lane and row each of the twenty-five cells DO re-authored
# sat in, asserted rather than derived because "no node moves row or lane" was
# DO's own promise — is DELETED with the half of §3 that read it. BATCH FX
# deleted the twelve spec trees those cells belonged to; §3 gives the count and
# the reason at the site where the assertions stood.

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


# ---------------- §1 — THE LINE, AS TWO PROPERTIES OF THE ONE TREE ----------------
#
# **BATCH FX RE-POINTED BOTH PROPERTIES, AND THE RULE THEY ASSERT MOVED WITH
# THEM.** This walk read the twelve spec trees — 324 nodes — and asked two
# things: that no node GRANTS an ability, and that no node's text names an
# ability outside its own spec's PROTECTED CORE. FX deleted the twelve trees and
# superseded the permitted list with the designer's line, so both questions are
# asked of `Talents.TREE`, under the line:
#
#   PROPERTY ONE, THE PAYLOAD. Every node is ONE `stat` block and nothing else.
#   A stat block cannot grant, edit or condition anything, so the shape IS the
#   line's structural half — and on top of it no field may be a rune's own
#   (`rune_X`), and no grant or condition may hide anywhere in the payload.
#   PROPERTY TWO, THE TEXT. No node's text names an ability or a passive AT
#   ALL. The protected core is no longer an exemption — its permission is the
#   half FX superseded — and a class-keyed node is worn by every spec, so there
#   is no one spec whose core could guarantee the name anyway.
#
# **THE CONTROLS RUN THE PREDICATE THE WALK TRUSTS, NOT A COPY OF IT.** A
# well-formed stat node must pass; a node carrying an `ability` edit, a
# `grant_ability`, a rune's field, or text naming an ability must each be
# caught. A predicate that had stopped biting would read clean over twenty-seven
# honest nodes, which is the vacuous-check shape exactly.
#
# WHAT IS NOT DERIVED HERE, SAID RATHER THAN IMPLIED: an ENGINE reached through
# an ordinary-looking stat field. No table in the game says which `BattleUnit`
# fields belong to an engine, so that half is `check_fx` §4's, which drives
# every node's field live on all four classes.

# Everything the line forbids a node's payload to carry, as the reasons the node
# fails it — EMPTY for a node that passes. The tree walk and its controls share
# this one predicate.
func _line_violations(n: Dictionary) -> Array:
	var why: Array = []
	var pay: Dictionary = n.get("payload", {})
	if pay.keys() != ["stat"]:
		why.append("its payload carries %s — a node is one `stat` block and nothing else" % str(pay.keys()))
	var st: Dictionary = {}
	if pay.get("stat", {}) is Dictionary:
		st = pay.get("stat", {})
	if st.is_empty():
		why.append("it writes no field")
	for f in st:
		if String(f).begins_with("rune_"):
			why.append("it writes `%s`, a rune's own field" % String(f))
	var g := Talents.granted_name(pay)
	if g != "":
		why.append("it grants `%s`" % g)
	if _carries(pay, "condition"):
		why.append("it carries a condition")
	return why


# Does `key` appear anywhere in this payload, a sub-payload included?
func _carries(x: Variant, key: String) -> bool:
	if x is Dictionary:
		for k in x:
			if String(k) == key or _carries(x[k], key):
				return true
	elif x is Array:
		for e in x:
			if _carries(e, key):
				return true
	return false


# Every name a node's text may not carry under the line, longest first so
# "Battle Shout" is not eaten by a shorter name inside it: every ability in the
# corpus (`Classes.ability_corpus()`, the one walk), every class passive, and
# every spec passive as its own card names it — the words before the colon, or
# before the dash where the card runs on without one.
func _forbidden_names() -> Array:
	var out: Array = []
	for ab in Classes.ability_corpus():
		out.append(String(ab.display_name))
	for ck in Classes.CLASS_PASSIVES:
		out.append(String((Classes.CLASS_PASSIVES[ck] as Dictionary).get("name", "")))
	for spec in Classes.all_specs():
		var pd := String((Classes.SPEC_INFO[spec] as Dictionary).get("passive_desc", ""))
		var nm := pd.split(":")[0].split(" —")[0].strip_edges()
		if nm != "" and nm != pd:
			out.append(nm)
	out.sort_custom(func(a, b): return String(a).length() > String(b).length())
	return out


# The barred names a node's rendered text carries, word-bounded, with the tree's
# own node names resolved FIRST — a tree is a namespace, which is DN's rule and
# the `wd_spiked`/Spite trap it came from. "Berserk" sits inside "Berserker" and
# "Heal" inside "Health", which is why the match is bounded.
# Returns [names, named_another_node].
func _text_names(n: Dictionary, forbidden: Array, own: Dictionary) -> Array:
	var masked := Talents.desc_for(n, 1)
	var named: Array = []
	var tree_ref := false
	for nm in forbidden:
		var s := String(nm)
		if s.length() < 4 or not _bounded(masked, s):
			continue
		masked = masked.replace(s, "#".repeat(s.length()))
		if String(n.get("name", "")) == s or own.has(s):
			tree_ref = true
			continue
		named.append(s)
	return [named, tree_ref]


# A real ability name and a real rune-owned field, for the controls: a control
# armed on a name nothing uses proves only that the name is not used.
func _ability_needle() -> String:
	for ab in Classes.ability_corpus():
		if String(ab.display_name).length() >= 4:
			return String(ab.display_name)
	return ""


func _a_rune_field() -> String:
	var runes: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	if not (runes is Dictionary):
		return ""
	for rid in runes:
		var pay: Variant = (runes[rid] as Dictionary).get("payload", {})
		if not (pay is Dictionary):
			continue
		var st: Variant = (pay as Dictionary).get("stat", {})
		if st is Dictionary:
			for f in st:
				if String(f).begins_with("rune_"):
					return String(f)
	return ""


func _s1_charter() -> void:
	print("\n§1 — the designer's line, asserted over the one tree and counted beside it")
	var tree: Array = Talents.tree()
	var crossed: Array = []
	for n in tree:
		for why in _line_violations(n):
			crossed.append("%s: %s" % [String(n.get("id", "?")), why])
	# PROPERTY ONE: every node is a stat block that touches no rune, grants
	# nothing and conditions nothing.
	ok(crossed.is_empty(),
		"a talent node crosses the designer's line — %s" % "; ".join(crossed))
	ok(tree.size() == Talents.TIERS * Talents.NODES_PER_TIER,
		"CHECKED %d nodes of the %d the tree's shape declares — the walk read less than the tree" % [
			tree.size(), Talents.TIERS * Talents.NODES_PER_TIER])
	ok(Classes.talent_granted_names().is_empty(),
		"`Classes.talent_granted_names()` is not empty")
	# THE CONTROLS FOR PROPERTY ONE — the positive arm, then one negative arm
	# for each door the line shuts that the payload shape alone could hide.
	var needle := _ability_needle()
	var rune_field := _a_rune_field()
	var good := {"id": "control_stat", "name": "Control", "tier": 1,
		"desc": "+10 Attack.", "payload": {"stat": {"attack": 10}}}
	ok(_line_violations(good).is_empty(),
		"§1 control: a well-formed stat node FAILS the line (%s) — the predicate rejects what it should pass" % [
			"; ".join(_line_violations(good))])
	var edit := {"id": "control_edit", "name": "Control", "tier": 1, "desc": "",
		"payload": {"ability": needle, "add": {"damage": 5}}}
	ok(not _line_violations(edit).is_empty(),
		"§1 control: a node EDITING `%s` passed the line — the walk above cannot see an ability edit" % needle)
	var grant := {"id": "control_grant", "name": "Control", "tier": 1, "desc": "",
		"payload": {"grant_ability": needle}}
	ok(not _line_violations(grant).is_empty(),
		"§1 control: a node GRANTING `%s` passed the line — the walk above cannot see a grant" % needle)
	var on_rune := {"id": "control_rune", "name": "Control", "tier": 1, "desc": "",
		"payload": {"stat": {rune_field: 1}}}
	ok(rune_field != "" and not _line_violations(on_rune).is_empty(),
		"§1 control: a node writing the rune field `%s` passed the line — the walk above cannot see a rune" % rune_field)

	# PROPERTY TWO: no node's text names an ability or a passive.
	var forbidden := _forbidden_names()
	var own := {}
	for n2 in tree:
		own[String(n2.get("name", ""))] = true
	var named: Array = []
	var tree_readers := 0
	for n3 in tree:
		var hit: Array = _text_names(n3, forbidden, own)
		for nm in hit[0]:
			named.append("%s names `%s`" % [String(n3.get("id", "?")), nm])
		if bool(hit[1]):
			tree_readers += 1
	ok(named.is_empty(),
		"a node's text names an ability or a passive — under the line a talent touches neither: %s" % ", ".join(named))
	var probe := {"id": "control_text", "name": "Control", "tier": 1,
		"desc": "%s strikes harder." % needle, "payload": {"stat": {"attack": 10}}}
	ok(not (_text_names(probe, forbidden, own)[0] as Array).is_empty(),
		"§1 control: a node whose text names `%s` was not caught — the text walk above is blind" % needle)
	print("  %d nodes; %d cross the line; %d names barred from a node's text (abilities and passives); %d nodes name one, %d name another node" % [
		tree.size(), crossed.size(), forbidden.size(), named.size(), tree_readers])


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


# ---------------- §3 — THE CUT CLAUSES TOOK THEIR TERMS ----------------------
func _s3_cells_and_terms() -> void:
	print("\n§3 — the cut clauses took their terms")
	# ── BATCH FX DELETED THIS SECTION'S FIRST HALF: FIFTY CHECKS, AND WHY. ──
	# It walked `CELL_HOME` — the twenty-five cells DO re-authored, across nine
	# specs — and asserted each one still EXISTED (25 checks) and still sat in
	# its ORIGINAL lane and row (25 more), because `Talents.cells_spent` priced a
	# saved cell off the row it currently sat in, and DN measured a moved cell
	# driving a Berserker ledger to -2 available points, silently.
	# **Every noun in that question is gone.** FX deleted the twelve spec trees
	# and all twenty-five cells with them; the v2 fold drops every saved v2 cell
	# (`Profile._migrate`), so no ledger can hold one; and the one tree has no
	# lanes and no rows. A cell is priced off its TIER now, and `check_fx` §2
	# drives that price through the ledger at every tier. There is no cell, lane
	# or row left for these assertions to ask about — the DG §2 exception.
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
#
# **BATCH FX RE-POINTED THE SWEEP AT THE ONE TREE, AND THE STATUS HALF STANDS**
# (CLAUDE.md's DO block says so). A node is worn by every spec of every class
# now, so the status a node reads is weighed against EVERY spec's guaranteed
# table rather than one spec's, and each row says how many specs lack a source.
# It is still a REPORT: a text sweep cannot tell a node that pays on a status
# from one that names a debuff landing on the HERO in order to shrug it off
# (DP's caveat), and the one tree has a node of that second shape.
func _s4_status_sweep() -> void:
	print("\n§4 — nodes reading a status a wearer cannot guarantee")
	print("  A REPORT, NOT A GATE. DN's instrument matched ability NAMES and this")
	print("  class of bet is invisible to it — `sm_precision` was found by reading.")
	var specs: Array = Classes.all_specs()
	var rows: Array = []
	for n in Talents.tree():
		var text := Talents.desc_for(n, 1)
		for sid in STATUS_FORMS:
			var reads := false
			for form in STATUS_FORMS[sid]:
				if _bounded(text, String(form)):
					reads = true
					break
			if not reads:
				continue
			var lacking := 0
			for spec in specs:
				if not (GUARANTEED_STATUS.get(spec, {}) as Dictionary).has(sid):
					lacking += 1
			if lacking > 0:
				rows.append("%-20s reads %-10s — no guaranteed source for %d of %d specs" % [
					String(n.get("id", "?")), sid, lacking, specs.size()])
	for r in rows:
		print("    %s" % r)
	print("  %d node/status pairs a wearer cannot guarantee." % rows.size())
	# ── THE ONE DO RULED ON: `sm_precision`. FX deleted the node, and the four
	# checks on it split along the line the repair rules draw. ──
	# DELETED, 1 CHECK: "the node's text reads Stunned". Its subject was the
	# node's desc, and the node is gone; the live half of the same question —
	# the PAYOUT moved onto `stunned` — is the read-site pin at the foot of this
	# section, which stands.
	# RE-POINTED, 3 CHECKS: "the text reads none of Dazed, Crippled, Exposed" is
	# asked of the READ SITE, which FX kept (`precision_ranks` is dormant, not
	# deleted — a later tree, rune or card may write it again). No statement
	# that reads the field may gate it on a status the Swordmaster cannot
	# guarantee, because that statement is where such a bet would be paid.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var reads_at: Array = []
	for stmt in _statements_of(bsrc):
		if String(stmt).contains("precision_ranks"):
			reads_at.append(String(stmt))
	for gone in ["dazed", "cripple", "exposed"]:
		var gated: Array = []
		for r2 in reads_at:
			if String(r2).contains('has_status("%s")' % gone):
				gated.append(String(r2).strip_edges().substr(0, 90))
		ok(gated.is_empty(),
			"the `precision_ranks` read site gates on `%s`, which the Swordmaster cannot guarantee: %s" % [
				gone, str(gated)])
	ok(bsrc.contains('attacker.precision_ranks > 0 and strike_target.has_status("stunned")'),
		"the read site did not follow the text onto `stunned`")
	print("  %d statements read `precision_ranks`; none gates it on dazed / cripple / exposed" % reads_at.size())


# The code half of a source line: everything before a `#` outside a string
# literal. A comment recording a removal names the thing removed (EV §5), so a
# read site is judged on its code alone.
func _code_part(line: String) -> String:
	var quote := ""
	var i := 0
	while i < line.length():
		var c := line[i]
		if quote != "":
			if c == "\\":
				i += 2
				continue
			if c == quote:
				quote = ""
		elif c == "\"" or c == "'":
			quote = c
		elif c == "#":
			return line.substr(0, i)
		i += 1
	return line


# One logical statement per entry, comments stripped: a guard wrapped onto a
# continuation line — a trailing backslash, or a bracket left open — is still
# one statement. A bracket inside a string literal is not counted (EA §5).
func _statements_of(src: String) -> Array:
	var lines: Array = []
	for raw in src.split("\n"):
		lines.append(_code_part(String(raw)))
	var out: Array = []
	var i := 0
	while i < lines.size():
		var stmt := String(lines[i])
		var j := i
		while j < lines.size() - 1 and (stmt.strip_edges(false, true).ends_with("\\")
				or _open_brackets(stmt) > 0):
			j += 1
			stmt += "\n" + String(lines[j])
		out.append(stmt)
		i = j + 1
	return out


func _open_brackets(t: String) -> int:
	var depth := 0
	var quote := ""
	var i := 0
	while i < t.length():
		var c := t[i]
		if quote != "":
			if c == "\\":
				i += 2
				continue
			if c == quote:
				quote = ""
		elif c == "\"" or c == "'":
			quote = c
		elif c == "(" or c == "[" or c == "{":
			depth += 1
		elif c == ")" or c == "]" or c == "}":
			depth -= 1
		i += 1
	return depth


# ---------------- §5 — THE STANDING RULE IS WRITTEN DOWN ----------------
func _s5_recorded() -> void:
	print("\n§5 — the rule is recorded where a later batch will read it")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	# BATCH FX — BOTH CLAUDE.md PINS RE-POINTED, NEITHER DELETED. The first read
	# DO's charter sentence ("A talent may not grant an ability"); the rule this
	# gate asserts is the designer's line now, and it lives in the standing rule
	# for the one tree. The second read DO's ruling that a talent may modify the
	# spec's PROTECTED CORE; FX superseded it and CLAUDE.md's DO block records the
	# supersession, so the pin reads that record — a superseded rule is pinned at
	# the text that supersedes it. Neither needle carries a batch code (EA §2),
	# and each sits on ONE line of the file: the sentences around them wrap, and
	# a raw `contains` cannot see across a line break.
	ok(cm.contains("A talent may not touch a rune, an ability"),
		"CLAUDE.md does not carry the designer's line — a talent may not touch a rune, an ability, a passive or an engine")
	ok(cm.contains("its PROTECTED CORE and the cross-row conditional do not"),
		"CLAUDE.md does not record that the protected-core permission was superseded")
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	# **BATCH DY §1 — THE NEEDLE IS RENDERED FROM THE LIVE POOLS, NOT AUTHORED.**
	# It read the literal "149 of 149". That is a SECOND COPY OF A COUNT inside the check
	# written to catch a stale one, which is this project's oldest recurring
	# defect and the one CL §1 wrote a rule about — and it cost six files a
	# hand-edit the moment DY moved the draft 149 -> 154. **The DOCUMENT still
	# has to carry the figure; this file no longer carries a copy of it.**
	var dy_draft := 0
	for dy_s in Classes.SPEC_DRAFT_POOLS:
		dy_draft += (Classes.SPEC_DRAFT_POOLS[dy_s] as Array).size()
	for dy_c in Classes.CLASS_DRAFT_POOLS:
		dy_draft += (Classes.CLASS_DRAFT_POOLS[dy_c] as Array).size()
	ok(master.contains("%d of %d" % [dy_draft, dy_draft]),
		"master.html does not state the current draft total (%d)" % dy_draft)


func _initialize() -> void:
	print("check_do — the talent charter, asserted as a property")
	_s1_charter()
	_s2_landed()
	_s3_cells_and_terms()
	_s4_status_sweep()
	_s5_recorded()
	print("\ncheck_do: %d checks, %d failures" % [checks, fails])
	quit()
