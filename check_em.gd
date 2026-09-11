# BATCH EM — THE RUNES ARE OFF THE TALENT TREES, AND THIS IS WHAT KEEPS THEM OFF.
#
#   §1  THE CHARTER PROPERTY — no rune payload writes a live talent node's own
#       counter. Derived from the ONE tree (`Talents.TREE`, since BATCH FX) and
#       `data/runes.json`, never from a list of field names typed here
#   §2  EVERY RE-KEYED COUNTER IS READ BESIDE ITS PARTNER — a statement that
#       reads `X` and not `rune_X` is a rune paying nothing, in silence
#   §3  THE `rune_` FIELDS SURVIVE THE JSON LOAD AS THE TYPE THEY ARE — the AA
#       float-into-int trap, which a `rune_` prefix inherits nothing from
#   §4  THE SET WITH NO HOME IS EMPTY — BATCH EN ANSWERED THE LAST THREE.
#       EM named three as an EQUALITY and said the day one was answered this
#       gate would red and the answer would be to delete its row. All three
#       were answered at once, so the row is gone and the section asserts the
#       CLOSURE instead: no rune writes any live node counter, and each of
#       EN's three is written by its rune under the `rune_` name and by
#       nothing under the bare one. **IT IS NOT VACUOUS AND SAYS SO** — it
#       prints CHECKED n of m over a live population of three
#   §5  NO OTHER DOOR ONTO THE TREE (BATCH FX) — no rune NAMES a node, by id or
#       by name, anywhere in its entry: the door a condition, a grant or a
#       card's text would come through. Two negative controls ride it
#
# **WHY THIS GATE EXISTS AND WHY IT COULD NOT HAVE BEEN WRITTEN AT EJ.** EJ's
# own §5 says so: *"the property a future gate wants — that no rune writes a
# live node's counter — is about twenty lines from `LANE_TREES` and
# `runes.json`, and belongs in the batch that takes the charter. Writing it now
# would encode today's 59 as an expectation."* This is that batch, and the 59
# are gone, so the property is assertable rather than a description.
#
# **§1 IS THE ONE THAT NEEDS A JUDGEMENT AND IT IS WRITTEN DOWN AS A TABLE.**
# A talent node writing the same field does NOT by itself make a rune
# talent-keyed. `crit_bonus`, `speed`, `max_hp_pct` and six others are the
# UNIT's own math — read in the global damage, crit, parry and turn-order
# pipelines, several of them written by relics too — and a node adding to one is
# a coincidence of target rather than a coupling. That is EJ §1's test, and the
# NINE fields it clears are `UNIT_MATH` below, **asserted as an EQUALITY**: a
# batch that wants a tenth has to move a line here and say why, and a batch
# that stops a node writing one of the nine trips this too — and BATCH FX was
# that batch: two rows out and one in, each with its reason at the table.
#
# **BATCH EN CORRECTED THIS PARAGRAPH AND THE ERROR IS WORTH THE LINE.** It read
# "`crit_bonus`, `speed`, `armor` and seven others" and "the TEN fields" — but
# `UNIT_MATH` holds NINE and `armor` is NOT one of them. **That is EJ's own
# off-by-one arriving in the gate whose §1 found it**: `armor` is the tenth name
# in EJ's list precisely BECAUSE no live talent node writes it, so it needs no
# exemption and was correctly left out of the table. The table was right and the
# sentence describing it was wrong — which is the direction that survives a
# battery, because nothing asserts on a comment.
#
# **§2 IS THE ONE THAT WOULD HAVE CAUGHT THE COST THIS BATCH NEARLY PAID.**
# Splitting `X` into `X` and `rune_X` is not the dangerous half — the guard
# above it is. `if occ.spread_ranks > 0` on an Occultist holding the Rune of the
# Whispering Dark and NOT the node is FALSE, so a 100g rune's clause pays
# nothing and nothing throws. Driven live before this gate existed, that hero
# spread a mark 0 times in 400; with the guard summing the pair, 58-66. **DP
# found this exact dud arriving through a re-pointed NODE; the repair for it is
# the other direction of the same door.**
#
# **AND THE INSTRUMENT BEHIND §2 WAS WRONG THE FIRST TIME, WHICH IS WHY ITS
# CONTROL IS DESCRIBED HERE.** The first sweep excluded a match preceded by a
# word character OR A DOT, to avoid matching `rune_X` — and `attacker.vulture`
# has a dot in front of it, so it was blind to 80 of the 85 sites and read a
# clean zero. A control armed on a DOTTED read is what found that; a control
# armed on the one `cfg.get("...")` site would have bitten and proved nothing.
#
# **BATCH FX DELETED THE TWELVE TREES THIS GATE WAS DERIVED FROM, AND THE
# DERIVATION DID WHAT IT WAS BUILT TO DO: THE TREES TOOK THEIR FIELDS WITH THEM.**
# §1 and §4 read the ONE tree now — twenty-seven stat nodes. §2 could not follow
# them there, because its question is not which node writes `X` but whether the
# rune PAYS: FX kept every read site, so a statement reading `X` alone is a rune
# paying nothing whether or not a node still writes `X` — and with its node gone
# `X` is dormant at zero, so that guard now fails for EVERY holder. §2's pairs
# are every `rune_X` whose partner `X` is DECLARED on `BattleUnit`, which is
# still derived from the engine, and which measured EM's own population exactly
# when FX re-pointed it (fifty of fifty, none in and none out).
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_em.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()

# THE UNIT'S OWN MATH — EJ §1's test, as a table. Each of these is written by
# at least one talent node AND by at least one rune, and is nevertheless not a
# talent coupling: the read site is a global pipeline the whole game passes
# through, not the node's advertised mechanism. The rune is buying the STAT,
# which the charter permits in the same breath it forbids the counter.
#
# **THERE WERE NINE AND EJ's REPORT NAMED TEN.** Its §1 says *"nine such fields
# are classed STAT despite having a node"* and then lists ten, the tenth being
# `armor`. Three runes write `armor` and, until FX, **no live talent node wrote
# it at all**, so it was an ordinary stat and needed no exemption — which is the
# equality below saying so on its first run rather than a reading anybody had
# to take on trust. (FX changed exactly that fact: the next paragraph.)
#
# **BATCH FX MOVED THREE ROWS, AND EACH MOVE IS THE EQUALITY DOING ITS JOB.**
# The table is "written by a node AND by a rune", so the day the twelve spec
# trees went, every row had to be re-asked against the ONE tree:
#   - `block_chance` and `bleed_bonus` ARE DELETED. No node of the one tree
#     writes either (FX's twenty-seven are one stat each, and neither field is
#     among them), so a rune writing one writes no node's counter and needs no
#     exemption — which is EM's own reason `armor` was left out below. Both
#     fields and their read sites stand (the block roll; the Bleed a
#     bleed-building blow adds), and the judgement that they are the UNIT's
#     math is recorded here, so the batch that authors a node on either puts
#     the row back with it instead of re-deriving it.
#   - `armor` IS ADDED. The one tree writes it now (More Armor), three runes
#     write it too (all three retired — the charter binds every entry, retired
#     included), and it is the unit's own math on EJ's test: fraction of damage
#     blocked in the global damage pipeline, and the relic layer's
#     `hero_armor_add` writes the same field.
# **So the table holds EIGHT**, and the equality below asserts all eight are
# written by a node of the one tree.
const UNIT_MATH := {
	"crit_bonus": "the crit roll, for every unit in the game",
	"speed": "turn order",
	"max_hp_pct": "the health a unit spawns with",
	"parry_bonus": "the parry roll",
	"dmg_bonus": "the global damage multiplier relics also write",
	"dmg_taken_bonus": "the global damage-taken multiplier",
	"pierce_bonus": "armor penetration",
	"armor": "the fraction of damage blocked, which the relic armor hook also writes",
}

# THE THREE THAT HAD NO HOME, AND THE `rune_` FIELD EACH ONE LANDED ON.
#
# EM could not re-key these: each is a per-turn drip that exists ONLY as its
# node, with no passive, stat, core ability or draft card underneath it to
# re-point onto, so EM §2 priced four options and authored nothing. **BATCH EN
# TOOK OPTION A** — each gets a field of its own and the drip's EXISTING tick
# sums the pair. There is no second tick: a hero holding the rune and the node
# would be paid twice, and a magnitude moving is the one thing the re-key
# forbids.
#
# **THE TABLE INVERTED RATHER THAN EMPTIED, WHICH IS THE POINT.** EM's row said
# "still on the node's counter"; deleting it outright would have left §4 looping
# over nothing and printing like a clean run. Each row is now a LIVE pair the
# section checks in both directions — the rune writes `rune_X`, and NOTHING
# writes the bare `X` from `runes.json`.
const RE_KEYED_AT_EN := {
	"divine_presence_pct": ["sleepless_vigil",
		"Divine Presence's per-turn heal to the most wounded"],
	"entropy_ranks": ["deepening_ruin",
		"Entropy's per-turn Break tick on anything bearing Ruin"],
	"pleasure_pct": ["whispering_dark",
		"Pleasure from Pain's per-turn heal, per unique enemy debuff"],
}

const SCRIPTS := ["battle.gd", "unit.gd", "party_screen.gd", "classes.gd",
	"run_state.gd", "map_screen.gd", "talents_screen.gd", "run_sim.gd",
	"ability.gd", "relics.gd", "events.gd", "shop_screen.gd", "offer_screen.gd",
	"draft_screen.gd", "blacksmith_screen.gd", "spec_choice_screen.gd",
	"profile.gd", "talents.gd", "runes.gd"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("check_em — the runes are off the talent tree")
	var node_fields := _node_stat_fields()
	var runes: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	_s1_charter(node_fields, runes)
	_s2_read_beside(node_fields, runes)
	_s3_types(runes)
	_s4_no_home(node_fields, runes)
	_s5_no_other_door(runes)
	_g.report(self)


# Every stat field ANY live talent node writes -> the nodes that write it.
# Derived through the running engine, so a tree that stops existing takes its
# fields with it rather than leaving this gate asserting against a memory — and
# at BATCH FX twelve did: this reads the ONE tree, `Talents.tree()`, in their
# place.
func _node_stat_fields() -> Dictionary:
	var out := {}
	for n in Talents.tree():
		var st: Dictionary = (n.get("payload", {}) as Dictionary).get("stat", {})
		for f in st:
			if not out.has(f):
				out[f] = []
			(out[f] as Array).append(String(n["id"]))
		# A node's second half is a full payload and writes its own fields. The
		# line forbids one (`check_do` §1 asserts it); the walk reads it anyway,
		# so a node that grew one could not hide a field from §1.
		for extra in (n.get("payload", {}) as Dictionary).get("also", []):
			for f2 in (extra as Dictionary).get("stat", {}):
				if not out.has(f2):
					out[f2] = []
				(out[f2] as Array).append(String(n["id"]))
	return out


# ── §1 — THE CHARTER ────────────────────────────────────────────────────────
func _s1_charter(node_fields: Dictionary, runes: Dictionary) -> void:
	print("\n§1 — no rune writes a live talent node's own counter")
	var offenders: Array = []
	var clauses := 0
	var rune_owned := 0
	for rid in runes:
		for f in ((runes[rid].get("payload", {}) as Dictionary).get("stat", {}) as Dictionary):
			clauses += 1
			var field := String(f)
			if field.begins_with("rune_"):
				rune_owned += 1
			if not node_fields.has(field):
				continue
			# BATCH EN — `or NO_HOME.has(field)` IS GONE WITH THE SET. It
			# exempted the three drips EM could not re-key; EN re-keyed all
			# three, so leaving the arm standing would exempt a road nothing
			# drives on and would silently re-admit any of the three if a later
			# batch put one back on the node's counter.
			if UNIT_MATH.has(field):
				continue
			offenders.append("%s/%s (node %s)" % [rid, field,
				", ".join(node_fields[field] as Array)])
	for o in offenders:
		ok(false, "`%s` writes a live talent node's counter — the charter forbids it" % o)
	ok(offenders.is_empty(),
		"a rune writes a talent node's counter (%d)" % offenders.size())
	# THE POPULATION IS PRINTED AND NOT ASSERTED. A rune added or retired moves
	# these numbers and neither is a defect; the PROPERTY above is what holds.
	print("  %d stat clauses across %d runes; %d rune-owned; %d node fields in the tree" % [
		clauses, runes.size(), rune_owned, node_fields.size()])
	# ...but `UNIT_MATH` is an equality, because each row is a judgement. A field
	# that stops being written by a node, or a row added without a reason,
	# should have to come here — and at FX two stopped and one was added.
	var live_math: Array = []
	for f in UNIT_MATH:
		if node_fields.has(f):
			live_math.append(String(f))
	ok(live_math.size() == UNIT_MATH.size(),
		"`UNIT_MATH` holds %d fields and only %d are still written by a node — a row is stale" % [
			UNIT_MATH.size(), live_math.size()])
	var rune_math := 0
	for rid2 in runes:
		for f3 in ((runes[rid2].get("payload", {}) as Dictionary).get("stat", {}) as Dictionary):
			if UNIT_MATH.has(String(f3)):
				rune_math += 1
	ok(rune_math > 0,
		"no rune writes a `UNIT_MATH` field any more — the exemption guards a road nothing drives on")
	print("  UNIT_MATH: %d fields, all still node-written, %d rune clauses riding them" % [
		UNIT_MATH.size(), rune_math])


# ── §2 — READ BESIDE ITS PARTNER ────────────────────────────────────────────
# For every `rune_X` a rune writes whose partner `X` is a field the unit
# DECLARES: every STATEMENT in the game's scripts that reads `X` must also read
# `rune_X`. A statement rather than a line, because a guard and its payout are
# often two statements and an expression is often three lines.
#
# **BATCH FX — THE PARTNER IS A DECLARED FIELD NOW, NOT A NODE-WRITTEN ONE.** EM
# derived the pairs from the fields a live node wrote, because every partner was
# a node counter then. FX deleted those nodes and KEPT every field and every
# read site ("dormant, not deleted"), and the hazard this section exists for
# does not care which: a guard reading `X` alone pays the rune nothing — and
# with `X` dormant at zero it now fails for EVERY holder, not only for one
# without the node. The pairing is the field NAME (CLAUDE.md: `rune_X` beside
# `X`, read at the same site), so the population is every `rune_X` whose `X`
# `BattleUnit` declares: derived from the engine, and measured when FX
# re-pointed it to be EM's population exactly — fifty of fifty.
func _s2_read_beside(node_fields: Dictionary, runes: Dictionary) -> void:
	print("\n§2 — every re-keyed counter is read beside the rune's half")
	var u := BattleUnit.new()
	var pairs: Array = []
	for rid in runes:
		for f in ((runes[rid].get("payload", {}) as Dictionary).get("stat", {}) as Dictionary):
			var field := String(f)
			if not field.begins_with("rune_"):
				continue
			var bare := field.substr(5)
			if u.get(bare) != null and not pairs.has(bare):
				pairs.append(bare)
	u.free()
	pairs.sort()
	var in_tree := 0
	for p in pairs:
		if node_fields.has(p):
			in_tree += 1
	var holes: Array = []
	var read_statements := 0
	for src_name in SCRIPTS:
		var stmts := _stmts_of(src_name)
		for stmt in stmts:
			for bare2 in pairs:
				if not _reads(String(stmt), String(bare2)):
					continue
				# `talents.gd` holds the NODE payloads — the one place the bare
				# name is written on purpose and has no rune half.
				if src_name == "talents.gd":
					continue
				# The declaration of the field itself.
				if String(stmt).contains("var %s :=" % bare2):
					continue
				read_statements += 1
				if not String(stmt).contains("rune_" + bare2):
					holes.append("%s: %s" % [src_name,
						String(stmt).strip_edges().substr(0, 90)])
	for h in holes:
		ok(false, "reads a re-keyed counter without the rune's half — `%s`" % h)
	ok(holes.is_empty(),
		"%d read site(s) take the node's counter alone — the rune pays nothing there" % holes.size())
	ok(pairs.size() > 40,
		"only %d re-keyed pairs found — this sweep is guarding almost nothing" % pairs.size())
	print("  %d re-keyed counters (%d written by a node of the one tree, %d dormant since FX), %d reading statements, %d taking only one half" % [
		pairs.size(), in_tree, pairs.size() - in_tree, read_statements, holes.size()])


# ── §3 — THE TYPES SURVIVE THE LOAD ─────────────────────────────────────────
# `rune_X` INHERITS NOTHING FROM `X`. `Runes._typed_payload` restores ints for a
# field ending `_ranks` or listed in `STAT_INT_KEYS`, and a float landing in a
# typed int var is a runtime error mid-spawn rather than a rounding (the AA
# trap); an int coercion landing on a float field rounds the rune quietly under
# strength (AT's `conduit_step`, and the Bared Guard's -0.15 would flatten to 0).
func _s3_types(runes: Dictionary) -> void:
	print("\n§3 — every `rune_` field loads as the type its partner is declared")
	var u := BattleUnit.new()
	var ints := 0
	var floats := 0
	for rid in runes:
		var built: Dictionary = Runes.build(String(rid))
		for f in ((built.get("payload", {}) as Dictionary).get("stat", {}) as Dictionary):
			var field := String(f)
			if not field.begins_with("rune_"):
				continue
			var declared = u.get(field)
			ok(declared != null, "`%s` is written by %s and declared nowhere" % [field, rid])
			if declared == null:
				continue
			var loaded = built["payload"]["stat"][field]
			if typeof(declared) == TYPE_INT:
				ints += 1
				ok(typeof(loaded) == TYPE_INT,
					"`%s` is a declared int and loads as a float — %s fails to spawn" % [field, rid])
				ok(field.ends_with("_ranks") or Runes.STAT_INT_KEYS.has(field),
					"`%s` is an int field in no int registry — the AA trap" % field)
			else:
				floats += 1
				ok(typeof(loaded) == TYPE_FLOAT,
					"`%s` is a declared float and loads as an int — %s goes under strength" % [field, rid])
				ok(not field.ends_with("_ranks") and not Runes.STAT_INT_KEYS.has(field),
					"`%s` is a float field being coerced to int — %s goes under strength" % [field, rid])
	u.free()
	print("  %d int clauses and %d float clauses, each loading as its declaration" % [ints, floats])


# ── §4 — THE SET IS CLOSED, AND THE CLOSURE IS CHECKED IN BOTH DIRECTIONS ───
#
# **A CHECK OVER AN EMPTY SET PRINTS EXACTLY LIKE A CLEAN ONE**, which is why
# this does not simply assert that `NO_HOME` is empty and stop. It asserts the
# closure (nothing writes a live node's counter) AND walks EN's three as a live
# population of three, in both directions, and PRINTS `CHECKED n of m` so a
# walk that silently reached nothing cannot read as a pass.
func _s4_no_home(node_fields: Dictionary, runes: Dictionary) -> void:
	print("\n§4 — the last three landed at EN; the un-re-keyed set is closed")
	var u := BattleUnit.new()
	# ── the closure: NOT ONE clause anywhere still writes a node's counter,
	# `UNIT_MATH` aside. §1 asserts the same property with its exemption table;
	# this asserts it with NO exemption for a drip, which is the arm EN's three
	# used to sit behind.
	var still: Array = []
	for rid in runes:
		for f in ((runes[rid].get("payload", {}) as Dictionary).get("stat", {}) as Dictionary):
			var field := String(f)
			if node_fields.has(field) and not UNIT_MATH.has(field):
				still.append("%s/%s" % [rid, field])
	still.sort()
	ok(still.is_empty(),
		"%d clause(s) still write a live node's counter — %s" % [still.size(), str(still)])
	# ── EN's three, checked BOTH WAYS over a live population.
	var checked := 0
	for bare in RE_KEYED_AT_EN:
		var row: Array = RE_KEYED_AT_EN[bare]
		var rid2 := String(row[0])
		var what := String(row[1])
		if not runes.has(rid2):
			ok(false, "`%s` is named by RE_KEYED_AT_EN and is not a rune — the row is stale" % rid2)
			continue
		var stat: Dictionary = (runes[rid2].get("payload", {}) as Dictionary).get("stat", {})
		checked += 1
		# 1. THE PAIR IS STILL A PAIR — otherwise the `rune_` half is a lone
		#    field wearing a prefix. EN asked it of the NODE (a live node still
		#    wrote the bare name); FX deleted all three nodes — each drip was a
		#    node of the twelve trees — and KEPT the field and its tick, so the
		#    live form of the question is the field's: the bare name is still
		#    DECLARED, and at least one statement still reads it beside the
		#    rune's half. §2 alone cannot say so: it only looks at statements
		#    that DO read the bare name, so a pair read nowhere reads clean there.
		var beside := _read_beside_count(String(bare))
		ok(u.get(String(bare)) != null and beside > 0,
			"`%s` is no longer declared, or no statement reads it beside `rune_%s` — %s's pair is half a pair" % [
				bare, bare, rid2])
		# 2. the rune writes the `rune_` half...
		ok(stat.has("rune_" + String(bare)),
			"%s does not write `rune_%s` — %s is not paid" % [rid2, bare, what])
		# 3. ...and NOT the bare one. Both at once would double-pay a holder of
		#    the node, which is the magnitude EN was forbidden to move.
		ok(not stat.has(String(bare)),
			"%s writes BOTH `%s` and its rune half — a holder of the node is paid twice" % [
				rid2, bare])
	ok(checked == RE_KEYED_AT_EN.size(),
		"CHECKED %d of %d — the walk reached fewer rows than the table holds" % [
			checked, RE_KEYED_AT_EN.size()])
	u.free()
	print("  0 clauses on a node's counter; CHECKED %d of %d EN pairs, both directions" % [
		checked, RE_KEYED_AT_EN.size()])


# ── §5 — NO OTHER DOOR ONTO THE TREE (BATCH FX) ─────────────────────────────
#
# §1 shuts the FIELD door — a rune writing a node's counter. The one tree leaves
# three more ways a rune could lean on a node, and all three go through a NAME:
# a payload condition naming a node's id (`has_node`), a grant or a requirement
# naming what a node is called, and card text pointing at one. So the property
# is that no rune NAMES a node: no string anywhere in a rune's entry — key or
# value, at any depth, and the rune's own id — is or contains a node's id or a
# node's name. Asserted over EVERY entry, retired included, because a retired
# rune still resolves for a saved run (EO §3).
#
# **THE TREE GRANTS NOTHING, SO "A GRANT SHARED WITH A NODE" HAS NO SECOND
# HALF** — `Talents.granted_name` is empty for all twenty-seven, which
# `check_do` §1 asserts. A rune grant NAMING a node is still caught here, by the
# name arm. `check_fx` §5 asserts that no rune carries a condition at all; this
# does not repeat it — it asks what a rune names, which a condition count
# cannot see.
#
# **THE NAME ARM IS CASE-SENSITIVE ON PURPOSE.** Several node names are plain
# stat phrases, and two retired runes' cards say "more armor" in lower case
# while describing their own number, not the node. A node's name is a
# title-case label, and a card that means the node writes it as one.
#
# TWO NEGATIVE CONTROLS RUN THE SAME PREDICATE: a condition naming a node's id,
# and card text naming a node. A walk blind to either would read clean over
# every rune in the file, which is the vacuous-check shape.
func _s5_no_other_door(runes: Dictionary) -> void:
	print("\n§5 — no rune names a node: not by id, not by name")
	var tree: Array = Talents.tree()
	var ids := {}
	var names := {}
	for t in tree:
		ids[String(t["id"])] = true
		names[String(t["name"])] = true
	var hits: Array = []
	var strings := 0
	for rid in runes:
		var found: Array = _names_a_node(String(rid), runes[rid], ids, names)
		strings += int(found[0])
		hits.append_array(found[1])
	for h in hits:
		ok(false, "%s — a rune leaning on the talent tree" % h)
	ok(hits.is_empty(), "%d rune string(s) name a talent node" % hits.size())
	ok(ids.size() == Talents.TIERS * Talents.NODES_PER_TIER and strings > runes.size(),
		"CHECKED %d strings across %d runes against %d node ids — the walk read less than the file or the tree" % [
			strings, runes.size(), ids.size()])
	var an_id := String(tree[0]["id"])
	var a_name := String(tree[0]["name"])
	var cond := {"payload": {"stat": {"rune_control": 1}, "condition": {"has_node": an_id}}}
	ok(not (_names_a_node("control_condition", cond, ids, names)[1] as Array).is_empty(),
		"§5 control: a rune whose condition names `%s` was not caught — the walk cannot see a node's id" % an_id)
	var text := {"desc": "Doubles %s while held." % a_name, "payload": {}}
	ok(not (_names_a_node("control_text", text, ids, names)[1] as Array).is_empty(),
		"§5 control: a rune whose text names `%s` was not caught — the walk cannot see a node's name" % a_name)
	print("  CHECKED %d strings across %d runes against %d node ids and %d names; %d name a node" % [
		strings, runes.size(), ids.size(), names.size(), hits.size()])


# Does any string in this entry name a node? Every key and value at every depth,
# plus the rune's own id: a node id on IDENTIFIER boundaries (so one id is not
# read inside a longer one), a node name on WORD boundaries — an exact-match
# sweep is blind to containment. Returns [strings_walked, hits].
func _names_a_node(rid: String, entry: Variant, ids: Dictionary, names: Dictionary) -> Array:
	var strings: Array = [rid]
	_strings_in(entry, strings)
	var hits: Array = []
	for s in strings:
		var hay := String(s)
		for nid in ids:
			if hay.contains(String(nid)) and _bounded_by(hay, String(nid), "[A-Za-z0-9_]"):
				hits.append("`%s` names the node id `%s` (in \"%s\")" % [rid, nid, hay.substr(0, 60)])
		for nm in names:
			if hay.contains(String(nm)) and _bounded_by(hay, String(nm), "[A-Za-z]"):
				hits.append("`%s` names the node `%s` (in \"%s\")" % [rid, nm, hay.substr(0, 60)])
	return [strings.size(), hits]


func _strings_in(x: Variant, out: Array) -> void:
	if x is Dictionary:
		for k in x:
			out.append(String(k))
			_strings_in(x[k], out)
	elif x is Array:
		for e in x:
			_strings_in(e, out)
	elif x is String:
		out.append(x)


func _bounded_by(hay: String, needle: String, word: String) -> bool:
	var esc := ""
	for c in needle:
		esc += ("\\" + c) if "\\^$.|?*+()[]{}".contains(c) else c
	var re := RegEx.create_from_string("(?<!%s)%s(?!%s)" % [word, esc, word])
	return re != null and re.search(hay) != null


# ── THE INSTRUMENTS ─────────────────────────────────────────────────────────

# THE STATEMENTS OF ONE SCRIPT, built once and shared by §2 and §4's liveness
# arm — each is a full comment-stripped pass over the file, and `battle.gd` is
# the largest file in the project.
var _stmt_cache := {}


func _stmts_of(src_name: String) -> Array:
	if not _stmt_cache.has(src_name):
		_stmt_cache[src_name] = _statements(_code_of("res://scripts/" + src_name))
	return _stmt_cache[src_name]


# How many statements read `bare` AND its rune half, across every script but the
# tree's own file. §4's liveness arm for a pair: a field can be declared and
# read nowhere, and §2 — which only looks at statements that DO read it — would
# then find no hole and say nothing.
func _read_beside_count(bare: String) -> int:
	var n := 0
	for src_name in SCRIPTS:
		if src_name == "talents.gd":
			continue
		for stmt in _stmts_of(src_name):
			if _reads(String(stmt), bare) and _reads(String(stmt), "rune_" + bare):
				n += 1
	return n


# Comment-stripped source, LINE COUNT AND BYTE LENGTH PRESERVED, so a `#` inside
# a string literal survives and a comment naming a field cannot be read as a
# read site (DO's scar — prose recording a removal necessarily names it).
func _code_of(path: String) -> String:
	var raw := FileAccess.get_file_as_string(path)
	var out := ""
	for line in raw.split("\n"):
		var quote := ""
		var cut := -1
		for i in String(line).length():
			var c := String(line)[i]
			if quote != "":
				if c == quote:
					quote = ""
				continue
			if c == "\"" or c == "'":
				quote = c
			elif c == "#":
				cut = i
				break
		if cut >= 0:
			out += String(line).substr(0, cut) + "\n"
		else:
			out += String(line) + "\n"
	return out


# One logical statement per entry: GDScript continues a line with a trailing
# backslash, and an expression also runs on while a bracket is open.
func _statements(code: String) -> Array:
	var out: Array = []
	var lines := code.split("\n")
	var i := 0
	while i < lines.size():
		var stmt := String(lines[i])
		var j := i
		while j < lines.size() - 1 and (stmt.strip_edges(false, true).ends_with("\\")
				or _unbalanced(stmt) > 0):
			j += 1
			stmt += "\n" + String(lines[j])
		out.append(stmt)
		i = j + 1
	return out


func _unbalanced(t: String) -> int:
	return t.count("(") - t.count(")") + t.count("[") - t.count("]") \
		+ t.count("{") - t.count("}")


# Does this statement read `field` under its OWN name? A match preceded by a
# word character is part of a longer identifier — which is exactly how
# `rune_vulture` must not count as a read of `vulture`. **A DOT IS NOT A WORD
# CHARACTER HERE AND THAT IS THE WHOLE POINT**: `attacker.vulture` is the
# ordinary shape and excluding it blinded the first version of this sweep to 80
# of its 85 sites while it printed a clean zero.
func _reads(stmt: String, field: String) -> bool:
	var from := 0
	while true:
		var at := stmt.find(field, from)
		if at < 0:
			return false
		var before := "" if at == 0 else stmt[at - 1]
		var after_at := at + field.length()
		var after := "" if after_at >= stmt.length() else stmt[after_at]
		if not _word_char(before) and not _word_char(after):
			return true
		from = at + 1
	return false


func _word_char(c: String) -> bool:
	if c == "":
		return false
	return c == "_" or (c.to_lower() != c.to_upper()) or c.is_valid_int()
