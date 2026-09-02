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
# pair that has GONE is a NOTICE, because that is a repair. Four of the six
# tolerated pairs are instrument artefacts rather than bets and each says so.
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

# WHERE EACH RE-POINTED CELL SITS, AND WHAT RUIN QUANTITY IT NOW READS.
# The lane and row are asserted rather than derived: "no cell moves row or
# lane" is this batch's own promise, and `Talents.cells_spent` prices a cell off
# the row it CURRENTLY sits in — DN measured a move driving a full Berserker
# ledger to -2 available points, silently, with nothing to refuse or log it.
#
# THE FOURTH COLUMN IS THE ANSWER TO "REPORT HOW THE FOUR DIFFER FROM EACH
# OTHER". Four cells all reading "stacks of Ruin" would have flattened a lane
# that was authored as a theme into one idea repeated four times. NONE OF THE
# FOUR READS A DETONATION, and that is deliberate: Grim Focus (Ruin 5),
# Unraveling (Ruin 7) and Avatar of Ruin (Ruin 9) already own that event.
const REPOINTED := {
	"oc_spread": ["Madness", 1, "APPLICATION (probabilistic) — a landing mark leaps"],
	"oc_whispers": ["Madness", 2, "APPLICATION MAGNITUDE — how deep each mark bites"],
	"oc_delirium": ["Madness", 5, "EVENT — an enemy-on-enemy strike, converted to Ruin"],
	"oc_permanent": ["Madness", 8, "STACK COUNT — a depth threshold"],
}

# THE PAIRS §1 TOLERATES. A pair only matters if the status has NO guaranteed
# source, and FOUR OF THESE SIX ARE NOT BETS AT ALL — the instrument matches a
# rendered WORD, so it cannot tell a node reading a status from a node applying
# one, nor an enemy's debuff landing on the HERO from the hero's landing on an
# enemy. Every entry carries which of the three it is.
const KNOWN_PAIRS := {
	"swordmaster/sm_guarded/cripple":
		"A REAL BET, AND A BONUS CLAUSE. Off Balance pays against BROKEN unconditionally; the Exposed/Crippled half is gated on `sm_punish`, a TREE-INTERNAL condition the charter permits, and the Swordmaster's core declares only `stunned` (Pommel Strike). The node cannot go dead — only that clause can.",
	"swordmaster/sm_guarded/exposed":
		"The same clause and the same reasoning as its Crippled half.",
	"mystic/sv_virulence/exposed":
		"NOT A BET — THE NODE IS ITS OWN SOURCE. Distillate's first clause APPLIES Exposed ('Your Poison applications add +N extra stacks and apply Exposed for 3 turns'); there is nothing here it does not supply itself.",
	"sharpshooter/ss_exposed_nerve/exposed":
		"NOT A BET — THE NODE IS ITS OWN SOURCE. Exposed Nerve applies Exposed on a critical hit and then pays out against Exposed enemies. Clause one is the source of what clause two reads.",
	"sharpshooter/ss_no_cover/dazed":
		"NOT A BET, AND NOT A PAYOFF. No Cover is an IMMUNITY: Blind and Dazed are read on the HERO, applied by ENEMIES. 'Who applies it' has a different answer here than anywhere else in this sweep.",
	"sharpshooter/ss_no_cover/blind":
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


func _node(nid: String) -> Dictionary:
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			if String(n["id"]) == nid:
				return n
	return {}


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

	var live: Dictionary = {}
	var nodes := 0
	for spec in Talents.LANE_TREES:
		var guaranteed: Dictionary = guaranteed_by_spec.get(spec, {})
		for n in Talents.LANE_TREES[spec]:
			nodes += 1
			var text := Talents.desc_for(n, 1)
			for sid in forms:
				if guaranteed.has(sid):
					continue
				for form in forms[sid]:
					if _bounded(text, String(form)):
						live["%s/%s/%s" % [spec, String(n["id"]), sid]] = true
						break
	var fresh: Array = []
	for key in live:
		if not KNOWN_PAIRS.has(key):
			fresh.append(String(key))
	fresh.sort()
	for f in fresh:
		ok(false, "%s reads a status with no guaranteed applier — a NEW bet on the draw" % f)
	ok(fresh.is_empty(),
		"no talent node reads a status its spec cannot guarantee, outside the named six")
	# THE OTHER DIRECTION IS A NOTICE, NOT AN ASSERTION: a known pair going
	# quiet is a REPAIR, and a gate that reds on a repair teaches the next
	# batch to leave the defect alone.
	var healed: Array = []
	for key2 in KNOWN_PAIRS:
		if not live.has(key2):
			healed.append(String(key2))
	healed.sort()
	for h in healed:
		print("    NOTICE: `%s` is no longer live — a pair was repaired; retire its row." % h)
	print("  %d nodes swept; %d live pairs, %d tolerated and named, %d new" % [
		nodes, live.size(), live.size() - fresh.size(), fresh.size()])
	for key3 in live:
		var mark := "known" if KNOWN_PAIRS.has(key3) else "NEW"
		print("    %-42s %s" % [String(key3), mark])
	# AND THE BATCH'S OWN PROPERTY: not one of the four is in that set any more.
	for nid in REPOINTED:
		var still: Array = []
		for key4 in live:
			if String(key4).contains("/" + nid + "/"):
				still.append(String(key4))
		ok(still.is_empty(),
			"`%s` still reads a status off the draw: %s" % [nid, ", ".join(still)])


# ---------------- §2 — THE FOUR CELLS, WHERE THEY WERE ----------------
func _s2_cells() -> void:
	print("\n§2 — the four re-pointed cells, and what each one reads")
	for nid in REPOINTED:
		var want: Array = REPOINTED[nid]
		var n := _node(nid)
		ok(not n.is_empty(), "re-pointed cell `%s` no longer exists" % nid)
		if n.is_empty():
			continue
		ok(String(n["lane"]) == String(want[0]) and int(n["row"]) == int(want[1]),
			"`%s` moved to %s/%d — it must stay at %s/%d (cells_spent prices off the ROW)" % [
				nid, n["lane"], int(n["row"]), want[0], int(want[1])])
		var text := Talents.desc_for(n, 1)
		ok(_bounded(text, "Ruin"),
			"`%s` does not name Ruin — the lane was re-pointed onto it (got: %s)" % [nid, text])
		print("    %-14s %-9s row %d   reads %s" % [nid, want[0], int(want[1]), want[2]])
	# THE LANE'S CHARACTER SURVIVED, ASSERTED RATHER THAN CLAIMED: four distinct
	# reads, not one idea repeated four times.
	var reads := {}
	for nid2 in REPOINTED:
		reads[String((REPOINTED[nid2] as Array)[2])] = true
	ok(reads.size() == REPOINTED.size(),
		"the four cells read %d distinct quantities, not %d — the lane flattened" % [
			reads.size(), REPOINTED.size()])
	print("  %d cells, %d distinct Ruin quantities read, 0 reading a detonation" % [
		REPOINTED.size(), reads.size()])


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
	_s2_cells()
	_s3_read_sites()
	_s4_rune_coupling()
	_s5_rune_grants()
	_s6_recorded()
	print("\ncheck_dp: %d checks, %d failures" % [checks, fails])
	quit()
