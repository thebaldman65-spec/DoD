# BATCH DP — THE MADNESS LANE COMES OFF THE DRAW.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dp.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR"
#
# **THE RULE THIS FILE EXISTS FOR, AND IT EXTENDS DO's RATHER THAN REPLACING
# IT:** a talent may not read a status the spec has no guaranteed way to apply.
# The ability rule and the status rule are the same rule. DO's instrument
# matched ability NAMES and could not see this class of bet at all — a node can
# name no ability whatsoever and still be a bet, which is what `sm_precision`
# was and what the Occultist's four Madness cells became the moment Mind Flay
# and Mass Hysteria left the tree for the draft.
#
# **IT ASSERTS THE PROPERTY AND PRINTS THE COUNT.** DO's brief asserted nine
# grant-capstones and there were twenty-two; DN's gate asserted two and there
# were five; this brief said "the other eight" and there are six. A number is a
# fact about today. Every count below is PRINTED beside its assertion and not
# one of them is asserted.
#
# **THE TOLERATED PAIRS ARE NAMED WITH THEIR REASONS, AND THE RATCHET IS
# ASYMMETRIC ON PURPOSE** (`baselines.json`'s own rule, one layer up): a pair
# that is NOT in `KNOWN_PAIRS` is an ERROR, because it is a new bet; a known
# pair that has GONE is a NOTICE, because that is a repair. At DP four of the
# six tolerated pairs were instrument artefacts rather than bets, and each said so.
#
# **BATCH FX — THE POPULATION IS THE ONE TREE, WORN BY EVERY SPEC.** The twelve
# spec trees are deleted and `Talents.generate_tree` hands every spec with a
# class the same twenty-seven stat nodes, so §1 sweeps that tree once per spec
# against THAT spec's guarantees — the property is unchanged, because a node
# reading a status is still a bet for exactly the specs that cannot apply it.
# The table is two rows now: No Cover's immunity pair moved to its
# precedent-mapped successor (`tn_no_miss`, the same field and clause) and names
# no spec; the other four rows retired with their nodes. **§2 AND FOUR OF §1's
# CHECKS ARE DELETED UNDER DG §2 — SEVENTEEN IN ALL, RECORDED AT THE SITE** —
# because the four Madness cells they asked about exist nowhere; §3, which pins
# the READ SITES those cells moved, is untouched and still asks. §1 gained ONE
# positive arm: the sweep must read a non-empty population.
#
# **IT READS `check_do`'s TABLES RATHER THAN COPYING THEM.** `GUARANTEED_STATUS`
# and `STATUS_FORMS` are hand-authored maps of what each spec can reach without
# a draw, and a second copy of them here would be this project's oldest
# recurring defect wearing a new hat — DG found five live copies of one figure.
# The load is asserted, so the day that file moves this gate says so rather than
# silently sweeping against an empty table.
#
# IT READS ONLY THE **SPEC** DRAFT POOL, so `check_da` §3's two-call fingerprint
# does not match and it needs no `WALK_EXEMPT` entry — and, for the reason DO
# learned the hard way, this header does not spell the other call out either.
# The fingerprint is a plain substring and does not care that a mention is a
# denial.
extends SceneTree

var checks := 0
var fails := 0

# WHERE EACH RE-POINTED CELL SAT — THE TABLE IS DELETED AT BATCH FX, WITH THE
# CELLS. It held DP's four Madness cells — `oc_spread` (row 1, an APPLICATION),
# `oc_whispers` (row 2, an application MAGNITUDE), `oc_delirium` (row 5, an
# EVENT) and `oc_permanent` (row 8, a STACK COUNT) — with the lane and row each
# had to keep because `cells_spent` priced a cell off its ROW, and the four
# distinct Ruin quantities that kept the lane from flattening. None of the four
# exists after FX, so the table would describe nothing; what it fed is recorded
# where §2 stood.

# THE PAIRS §1 TOLERATES. A pair only matters if the status has NO guaranteed
# source. The instrument matches a rendered WORD, so it cannot tell a node
# reading a status from a node applying one, nor an enemy's debuff landing on
# the HERO from the hero's landing on an enemy. Every entry carries which of the
# three it is.
#
# **BATCH FX — A KEY MAY NAME `*` FOR ITS SPEC.** The one tree is worn by EVERY
# spec, so a node reading a status now appears once per spec that cannot apply
# it. A row whose reason holds whatever the wearer — an IMMUNITY's does — says
# `*`; a row that is a bet for some specs and not others still names its spec.
#
# **FOUR ROWS RETIRED WITH THEIR NODES AT FX**, and they were rows, not checks,
# so no count moved: `swordmaster/sm_guarded/cripple` and `.../exposed` (Off
# Balance's Punishment clause — a real bet, and a bonus clause),
# `mystic/sv_virulence/exposed` (Distillate, its own source) and
# `sharpshooter/ss_exposed_nerve/exposed` (Exposed Nerve, its own source). None
# of those three nodes exists in the one tree or anywhere else. The fifth and
# sixth rows were No Cover's, and they moved to its successor below.
const KNOWN_PAIRS := {
	"*/tn_no_miss/dazed":
		"NOT A BET, AND NOT A PAYOFF. You Cannot Miss is an IMMUNITY: Blind and Dazed are read on the HERO, applied by ENEMIES. 'Who applies it' has a different answer here than anywhere else in this sweep. (No Cover's row until FX: `tn_no_miss` is its precedent-mapped successor — the same `no_cover` field, the same clause — and every spec wears it.)",
	"*/tn_no_miss/blind":
		"NOT A BET — the other half of the same immunity.",
}

# THE FIELD THAT WAS RETIRED, asserted absent from the whole of `scripts/` with
# COMMENT LINES STRIPPED FIRST. That is DO's scar and it is not a loophole: the
# prose recording a removal necessarily NAMES what was removed, and a bare
# substring search cannot tell a record of a cut from the cut not having
# happened. DO's third negative control found exactly that, in this shape.
const RETIRED := ["permanent_delusion"]


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


# Every line of a source file that is not a comment. See RETIRED.
func _code_of(path: String) -> String:
	var body := ""
	for line in FileAccess.get_file_as_string(path).split("\n"):
		if not String(line).strip_edges().begins_with("#"):
			body += line + "\n"
	return body


# A LIVE PAIR IS KNOWN IF ITS ROW MATCHES EXACTLY, OR ON THE `*` ROW FOR ITS
# NODE AND STATUS — see KNOWN_PAIRS. (BATCH FX; this replaces the lookup that
# found a node by id across the twelve deleted trees.)
func _known(key: String) -> bool:
	if KNOWN_PAIRS.has(key):
		return true
	var parts := key.split("/")
	return parts.size() == 3 and KNOWN_PAIRS.has("*/%s/%s" % [parts[1], parts[2]])


# Is a known row still matched by some live pair? The NOTICE direction.
func _row_live(row: String, live: Dictionary) -> bool:
	if not row.begins_with("*/"):
		return live.has(row)
	var tail := row.substr(1)
	for k in live:
		if String(k).ends_with(tail):
			return true
	return false


# ---------------- §1 — THE PROPERTY, AND THE COUNT BESIDE IT ----------------
func _s1_property() -> void:
	print("\n§1 — no talent node reads a status its own spec cannot guarantee")
	var do_consts: Dictionary = load("res://check_do.gd").get_script_constant_map()
	ok(do_consts.has("GUARANTEED_STATUS") and do_consts.has("STATUS_FORMS"),
		"`check_do`'s status tables no longer load — this sweep would run against nothing")
	if not (do_consts.has("GUARANTEED_STATUS") and do_consts.has("STATUS_FORMS")):
		return
	var guaranteed_by_spec: Dictionary = do_consts["GUARANTEED_STATUS"]
	var forms: Dictionary = do_consts["STATUS_FORMS"]
	ok(not forms.is_empty() and not guaranteed_by_spec.is_empty(),
		"the loaded tables are empty — the sweep would be vacuously green")

	# BATCH FX — EACH SPEC'S TREE IS THE ONE TREE, asked for through the
	# unchanged `generate_tree` door every caller uses and swept against THAT
	# spec's guarantees, because one node can be a bet for one spec and not for
	# another. The property is unchanged; only the population moved.
	var live: Dictionary = {}
	var nodes := 0
	var specs := 0
	for spec in Classes.all_specs():
		var tree_nodes: Array = Talents.generate_tree(String(spec),
			Classes.class_of_spec(String(spec)))
		if tree_nodes.is_empty():
			continue
		specs += 1
		var guaranteed: Dictionary = guaranteed_by_spec.get(spec, {})
		for n in tree_nodes:
			nodes += 1
			var text := Talents.desc_for(n, 1)
			for sid in forms:
				if guaranteed.has(sid):
					continue
				for form in forms[sid]:
					if _bounded(text, String(form)):
						live["%s/%s/%s" % [spec, String(n["id"]), sid]] = true
						break
	# THE POSITIVE ARM, ADDED AT FX WITH THE POPULATION IT GUARDS. The sweep read
	# twelve hand-authored trees; it now reads one 27-node tree through
	# `generate_tree`, and a door that handed every spec an empty tree would
	# leave the negative arm below green on nothing at all.
	ok(nodes > 0,
		"§1 read no talent node — `generate_tree` handed every spec an empty tree, so the property below is vacuously green")
	var fresh: Array = []
	for key in live:
		if not _known(String(key)):
			fresh.append(String(key))
	fresh.sort()
	for f in fresh:
		ok(false, "%s reads a status with no guaranteed applier — a NEW bet on the draw" % f)
	ok(fresh.is_empty(),
		"no talent node reads a status its spec cannot guarantee, outside the named pairs")
	# THE OTHER DIRECTION IS A NOTICE, NOT AN ASSERTION: a known pair going
	# quiet is a REPAIR, and a gate that reds on a repair teaches the next
	# batch to leave the defect alone.
	var healed: Array = []
	for key2 in KNOWN_PAIRS:
		if not _row_live(String(key2), live):
			healed.append(String(key2))
	healed.sort()
	for h in healed:
		print("    NOTICE: `%s` is no longer live — a pair was repaired; retire its row." % h)
	print("  %d nodes swept across %d specs; %d live pairs, %d tolerated and named, %d new" % [
		nodes, specs, live.size(), live.size() - fresh.size(), fresh.size()])
	var keys: Array = live.keys()
	keys.sort()
	for key3 in keys:
		var mark := "known" if _known(String(key3)) else "NEW"
		print("    %-42s %s" % [String(key3), mark])
	# FOUR CHECKS STOOD HERE AND ARE DELETED AT BATCH FX UNDER DG §2 — counted
	# with §2's thirteen where §2 stood. Each asked that one of DP's four
	# re-pointed Madness cells (`oc_spread`, `oc_whispers`, `oc_delirium`,
	# `oc_permanent`) no longer appeared in the live set. The four nodes are
	# deleted, so the question has no subject; the property above covers every
	# node that does exist.


# ---------------- §2 — THE FOUR CELLS, WHERE THEY WERE — DELETED AT FX ------
# **THIRTEEN CHECKS STOOD HERE AND ARE DELETED UNDER DG §2 — SEVENTEEN IN ALL,
# WITH THE FOUR §1 ASKED OF THE SAME FOUR NODES.** DP §2 asserted that the four
# Madness cells DP re-pointed onto Ruin — `oc_spread` (row 1), `oc_whispers`
# (row 2), `oc_delirium` (row 5) and `oc_permanent` (row 8) — still existed (4);
# still sat in their ORIGINAL lane and row, because `cells_spent` priced a cell
# off its row (4); still named Ruin in their rendered text (4); and between them
# read four DISTINCT quantities, so the lane had not flattened into one idea
# repeated four times (1). **FX deleted the twelve spec trees**: none of the four
# exists, the Occultist has no Madness lane, the one tree has no lanes and no
# rows (`cells_spent` prices off the TIER now), and no node of it touches Ruin —
# FX's line forbids a talent touching an engine. No live subject exists for any
# of the thirteen to be re-pointed at.
# **WHAT SURVIVES THEM IS §3, UNTOUCHED**: the fields those cells wrote
# (`spread_ranks`/`spread_ruin`, `whispers_step`, `delirium_ranks`,
# `broken_mind`) are dormant rather than deleted, and every read site DP moved
# is still pinned there, so the half of DP that is about the GAME is still asked.


# ---------------- §3 — THE READ SITES FOLLOWED THE TEXT ----------------
func _s3_read_sites() -> void:
	print("\n§3 — every text that moved took its read site with it")
	var code := _code_of("res://scripts/battle.gd")
	for pair in [
			["func _old_gods_mark() -> int:",
				"Whispers's new home — the helper the five passive sites call"],
			["return OLD_GODS_MARK + occ.whispers_step", "Whispers (the magnitude)"],
			# BATCH EM RE-KEYED THE RUNE'S HALF, AND THE GUARD IS WHY THIS ROW
			# MOVED RATHER THAN THE PAYOUT. The Whispering Dark writes
			# `rune_spread_ranks`/`rune_spread_ruin` now, so the guard that used
			# to read the node's counter alone would be FALSE on a hero holding
			# the rune and not the node — the same dud DP found, arriving through
			# the repair for it. Both halves are summed into locals at the site
			# and the locals are what these rows now name.
			["_gain_ruin(caught, sp_ruin)", "Spread of Madness (the Ruin it marks)"],
			["var sp_ruin := occ.spread_ruin + occ.rune_spread_ruin",
				"Spread of Madness (the Ruin it marks — both halves)"],
			["if not _ruin_spreading and sp_chance > 0", "Spread of Madness (the guard and the chance)"],
			["var sp_chance := occ.spread_ranks + occ.rune_spread_ranks",
				"Spread of Madness (the guard reads the rune too)"],
			["_gain_ruin(strike_target, mad_occ.delirium_ranks)", "Delirium (unmoved — its site never named a status)"],
			['and target.status_stacks("ruin") >= src.broken_mind', "Ruined Mind (the depth gate)"]]:
		ok(code.contains(String(pair[0])),
			"the read site for %s is missing: `%s`" % [pair[1], pair[0]])
	# THE OLD SITES ARE GONE. A field read in two places under two meanings is a
	# silent order-dependence, which is the one thing nobody finds by reading.
	for dead in [
			'_max_hero_rank("spread_ranks")',
			'_max_hero_rank("spread_ruin")',
			"psy_occ.whispers_step",
			'_apply_status(infected, "psychosis", 3)']:
		ok(not code.contains(dead),
			"the old read site `%s` survives — the field is read under two meanings" % dead)
	for term in RETIRED:
		var where: Array = []
		for f in ["talents.gd", "battle.gd", "unit.gd", "runes.gd", "classes.gd"]:
			if _code_of("res://scripts/" + f).contains(term):
				where.append(String(f))
		ok(where.is_empty(),
			"retired field `%s` survives in %s" % [term, ", ".join(where)])
	# AND THE PROPERTY BEHIND THE HELPER: no `_gain_ruin` call quotes the
	# constant any more, so a sixth passive site cannot be added that Whispers
	# silently does not reach. THE BASE ITSELF STAYS — it is the authored copy.
	ok(not code.contains(", OLD_GODS_MARK)"),
		"a `_gain_ruin` call still quotes OLD_GODS_MARK directly — Whispers will not reach it")
	ok(code.contains("const OLD_GODS_MARK := 2"),
		"the passive's base mark is no longer authored in one place")
	print("  %d retired field(s) absent; the five passive mark sites all route through the helper" % RETIRED.size())


# ---------------- §4 — THE RUNE THE RE-POINT COULD HAVE KILLED ----------------
func _s4_rune_coupling() -> void:
	print("\n§4 — a re-pointed node must not leave a rune paying nothing")
	var runes: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	var wd: Dictionary = runes.get("whispering_dark", {})
	ok(not wd.is_empty(), "the Rune of the Whispering Dark is gone")
	var wd_stat: Dictionary = wd.get("payload", {}).get("stat", {})
	# BATCH EM — REPAIRED TO INTENT, NOT LOOSENED. DP's question was *does this
	# rune still pay?*, and it asked it by pinning the field the rune shared with
	# the node. The charter says a rune may not write a node's counter, so the
	# shared field is exactly what had to go: the rune owns `rune_spread_ranks`
	# and `rune_spread_ruin` now and the read site sums the pair. **The row that
	# would have gone quietly vacuous is the one below it** — a `has()` on the
	# old name returns false and says the rune is dead, which is the opposite of
	# what happened. The VALUES are pinned here too, because a re-key that
	# renamed the key and dropped the number would pass a name check.
	for f in ["rune_spread_ranks", "rune_spread_ruin"]:
		ok(wd_stat.has(f),
			"the Whispering Dark no longer writes `%s` — its own re-keyed field" % f)
	ok(int(wd_stat.get("rune_spread_ranks", 0)) == 15
			and int(wd_stat.get("rune_spread_ruin", 0)) == 1,
		"the Whispering Dark's contagion clauses moved off 15%%/1 in the re-key")
	for f in ["spread_ranks", "spread_ruin"]:
		ok(not wd_stat.has(f),
			"the Whispering Dark still writes the NODE's `%s` — the charter forbids it" % f)
	ok(not String(wd.get("desc", "")).contains("Psychosis"),
		"the Whispering Dark still sells Psychosis, which its node no longer touches")
	# THE GENERAL PROPERTY, AND IT IS THE ONE THAT WOULD HAVE CAUGHT THE COST
	# THIS BATCH NEARLY PAID: every stat field any rune writes has a live read
	# site somewhere in `scripts/`, COMMENTS STRIPPED. Re-pointing a node onto a
	# fresh field name would have left two of this rune's four clauses paying
	# nothing, in silence — the exact dud the rune schema exists to prevent.
	var code := ""
	for f2 in ["talents.gd", "battle.gd", "unit.gd", "runes.gd", "classes.gd"]:
		code += _code_of("res://scripts/" + f2)
	var dead_fields: Array = []
	var field_count := 0
	for rid in runes:
		for field in (runes[rid].get("payload", {}).get("stat", {}) as Dictionary):
			field_count += 1
			if not code.contains(String(field)):
				dead_fields.append("%s/%s" % [rid, field])
	for d in dead_fields:
		ok(false, "`%s` writes a field nothing reads — a rune clause paying nothing" % d)
	ok(dead_fields.is_empty(), "every rune stat field has a live read site")
	print("  %d rune stat fields across %d runes; %d read nowhere" % [
		field_count, runes.size(), dead_fields.size()])


# ---------------- §5 — THE RUNES THAT NOW SHARE A CARD WITH THE DRAFT -------
func _s5_rune_grants() -> void:
	print("\n§5 — the grants: DO's move resolved two duplications and created a state")
	var runes: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	var overlaps := 0
	for rid in runes:
		var pay: Dictionary = runes[rid].get("payload", {})
		var gname := ""
		if pay.has("grant_ability"):
			gname = String(pay["grant_ability"])
		elif pay.has("new_ability"):
			gname = String((pay["new_ability"] as Dictionary).get("display_name", ""))
		if gname == "":
			continue
		# THE HALF THAT COULD HAVE BROKEN AND DID NOT. A rune's grant resolves
		# through `Classes.pending_talent_ability` and NOT through the draft
		# resolver, so DO moving a card's NAME into a pool while its definition
		# stayed put is what kept these alive. Had the definition moved with the
		# name, every one of these runes would grant nothing, silently.
		if pay.has("grant_ability"):
			ok(Classes.pending_talent_ability(gname) != null,
				"the %s grants `%s`, which no longer resolves — the rune is dead" % [rid, gname])
		var pools: Array = []
		for sp in Classes.all_specs():
			if Classes.spec_draft_pool(sp).has(gname):
				pools.append(String(sp))
		if not pools.is_empty():
			overlaps += 1
		print("    %-14s -> %-16s draftable by: %s" % [
			rid, gname, "nobody" if pools.is_empty() else ", ".join(pools)])
	# A REPORT, NOT A GATE. Holding both is NOT a dead rune: the grant collides,
	# `_collided` finds no authored `upgrade` arm and no `no_fallback`, so the
	# rune OWES ITS GENERIC and `Run.apply_upgrades` — which runs last — turns it
	# into an upgrade on the very card it would have granted. That is the Rune of
	# the Last Rites' shipped behaviour since AV, now reachable by two more.
	print("  %d rune grant(s) also live in a spec draft pool." % overlaps)
	print("  Holding both is an UPGRADE on the drafted card, not a wasted rune.")


# ---------------- §6 — THE STANDING RULE IS WRITTEN DOWN ----------------
func _s6_recorded() -> void:
	print("\n§6 — the rule is recorded where a later batch will read it")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.contains("A talent may not read a status the spec has no guaranteed way to apply"),
		"CLAUDE.md does not carry the status half of the charter sentence")
	ok(cm.contains("The ability rule and the status rule are the same rule"),
		"CLAUDE.md does not say the two rules are one — the instrument could not see `sm_precision`")


func _initialize() -> void:
	print("check_dp — the Madness lane comes off the draw")
	_s1_property()
	# §2 — deleted at BATCH FX with the four cells it asked about (DG §2); the
	# record of what it asserted is where the section stood.
	_s3_read_sites()
	_s4_rune_coupling()
	_s5_rune_grants()
	_s6_recorded()
	print("\ncheck_dp: %d checks, %d failures" % [checks, fails])
	quit()
