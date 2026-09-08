# BATCH FK — FORTY RUNES, EIGHT SPECS, AND THE INSTRUMENT FOR WHAT BINDS THEM.
#
#   §1  the pool census: 60 live across all twelve specs, flat 100g, and the
#       TWO SCOPE STRINGS THAT WOULD ROLL FOR NOBODY are absent by assertion
#   §2  NO THRESHOLD AND NO BREADTH among the thirty-nine — the secondaries the
#       designer retired going forward — with the six already-shipped gated
#       runes asserted STILL GATED, because "none is authored" must not be
#       satisfiable by quietly ungating the six that are owed a repair
#   §3  THE ANTI-INERT WALK, and it is this gate's reason to exist: every field
#       every FK payload writes is DECLARED on `BattleUnit` and READ somewhere
#       in `scripts/`. A payload that applies and pays nothing is this project's
#       most common shipped defect
#   §4  the int-coercion list, both arms — every FK int is in
#       `Runes.STAT_INT_KEYS` and the one FLOAT is not
#   §5  `requires_ability` resolves against the real corpus, and against the
#       scoped hero's own reachable pool
#   §6  THE RUNE OF THE STANDING GROUND IS ABSENT, AND THE REASON IS ASSERTED
#       RATHER THAN WRITTEN DOWN — Consecrated Ground already kindles every
#       hero standing in it, so the rune would have shipped 100% inert. If a
#       later batch makes that clause false, THIS is what says the rune is now
#       authorable rather than a comment nobody re-reads
#
# **WHY §3 IS THE LOAD-BEARING SECTION.** DK measured Empower attaching to a
# beast at exactly 1.0000 and BI measured a rune-condition that could never be
# met; both read as working. A rune is a JSON entry, a declared field and a read
# site, and only the middle one is visible to a reader of `runes.json`. This
# walks all three for all thirty-nine.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fk.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# **THE THIRTY-NINE, BY ID.** Listed rather than derived, and that is deliberate:
# a walk that derived "the FK runes" from a property (a scope not in EZ's four,
# say) would go stale the moment a later batch authored a fortieth, and it would
# go stale QUIETLY — the walk would simply cover more and still pass. A batch
# adding a rune adds a line here, which is a person reading this comment.
const FK_IDS := [
	"last_word", "blood_debt_rune", "butchers_bill", "open_vein",
	"slaughterhouse_rune",
	"long_fuse", "ashfall", "chain_fire", "ember_leap", "pyre_debt",
	"second_winter", "killing_cold_fk", "glass_prison", "cold_snap_fk",
	"deep_cold",
	"resonant_core_fk", "half_note", "overtone", "dissonance", "overflow",
	"whetstone", "mirror_guard", "open_line", "long_blade", "naked_blade",
	"vigil", "open_hand_fk", "long_watch_holy", "grace", "martyr_fk",
	"layered_aegis", "deep_absorb", "fourth_stack", "bare_altar",
	"long_poison", "second_barb", "full_board", "carrion", "thin_blood",
]

# The six gated runes EZ and FC shipped, which FK does NOT repair. They are
# owed to a later batch and §2 asserts they are STILL GATED — see that section.
const STILL_GATED := ["deepening_hex", "wide_rite", "bracing_line",
	"long_watch", "heavy_bolts", "wide_watch", "answering_pack", "shared_scent"]

# The ONE float among the thirty-nine's payload fields. Coercing it would
# flatten 0.03 to zero, which is the failure that reads exactly like the rune
# working (the Bared Guard's -0.15 precedent).
const FK_FLOAT := "rune_seasoned_off_bonus"

# The two display names that are NOT code keys. A rune scoped to either rolls
# for nobody, silently — FJ §0's finding, and the one this gate can keep true.
const NOT_KEYS := ["spec:devout", "spec:survivalist"]

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	_s1_the_pool()
	_s2_no_threshold_no_breadth()
	_s3_every_field_declared_and_read()
	_s4_the_int_list()
	_s5_requires_ability_resolves()
	_s6_the_standing_ground_is_absent()
	_g.report(self)


# ── §1 ──────────────────────────────────────────────────────────────────────
func _s1_the_pool() -> void:
	print("\n§1 — the pool: 60 live across twelve specs, flat 100g")
	var live: Array = []
	var by_spec := {}
	var priced_wrong: Array = []
	var bad_scope: Array = []
	for id in Runes.ids():
		if Runes.is_retired(String(id)):
			continue
		live.append(String(id))
		var cfg: Dictionary = Runes.config(String(id))
		var scope := String(cfg.get("scope", ""))
		if NOT_KEYS.has(scope):
			bad_scope.append("%s=%s" % [id, scope])
		if not scope.begins_with("spec:"):
			bad_scope.append("%s=%s" % [id, scope])
		if int(cfg.get("price", 0)) != 100:
			priced_wrong.append("%s=%s" % [id, cfg.get("price", 0)])
		by_spec[scope] = int(by_spec.get(scope, 0)) + 1
	ok(live.size() == 60, "§1: the live pool is %d, not 60" % live.size())
	ok(by_spec.size() == 12,
		"§1: the live pool spans %d specs, not all 12 — %s" % [
			by_spec.size(), by_spec.keys()])
	# **THE TWO NAMES THAT ROLL FOR NOBODY, ASSERTED BOTH WAYS.** The absence of
	# `spec:devout` is one arm; the PRESENCE of `spec:inquisitor` is the other,
	# and without it a batch that deleted the Devout's four entirely would pass
	# the first arm cleanly.
	ok(bad_scope.is_empty(),
		"§1: a live rune carries a scope that rolls for nobody — %s" % [bad_scope])
	ok(int(by_spec.get("spec:inquisitor", 0)) > 0,
		"§1: nothing is scoped `spec:inquisitor` — the Devout's set is gone")
	ok(int(by_spec.get("spec:mystic", 0)) > 0,
		"§1: nothing is scoped `spec:mystic` — the Survivalist's set is gone")
	ok(priced_wrong.is_empty(),
		"§1: price is not flat 100g across the live pool — %s" % [priced_wrong])
	# EZ §0's own rule, carried forward: a live rune carrying a `lane` is ES §5's
	# severed rule coming back.
	var laned: Array = []
	for id2 in FK_IDS:
		if Runes.config(String(id2)).has("lane"):
			laned.append(id2)
	ok(laned.is_empty(), "§1: an FK rune carries a `lane` — %s" % [laned])
	print("    live by spec: %s" % [by_spec])


# ── §2 ──────────────────────────────────────────────────────────────────────
# **"NONE OF THE FORTY CARRIES A THRESHOLD OR A BREADTH" IS TWO CLAIMS, NOT
# ONE**, and a gate asserting only the first is one a batch could satisfy by
# ungating the six that ARE gated. The second arm is why the negative here is
# safe to assert.
func _s2_no_threshold_no_breadth() -> void:
	print("\n§2 — no THRESHOLD and no BREADTH among the thirty-nine")
	var gated_payload: Array = []
	var gated_label: Array = []
	for id in FK_IDS:
		var cfg: Dictionary = Runes.config(String(id))
		var payload: Dictionary = cfg.get("payload", {})
		var cond: Dictionary = payload.get("condition", {})
		if cond.has("tag_threshold") or cond.has("tag_breadth"):
			gated_payload.append("%s=%s" % [id, cond])
		var shape: Array = Runes.rune_shape(String(id))
		if shape.has("THRESHOLD") or shape.has("BREADTH"):
			gated_label.append("%s=%s" % [id, shape])
	ok(gated_payload.is_empty(),
		"§2: an FK payload carries a retired secondary's condition — %s" % [gated_payload])
	ok(gated_label.is_empty(),
		"§2: an FK shape row is labelled THRESHOLD or BREADTH — %s" % [gated_label])
	# THE POSITIVE ARM: the six shipped gated runes are NOT repaired here, so
	# every one of them still carries its condition AND its label.
	var ungated: Array = []
	for id2 in STILL_GATED:
		var p2: Dictionary = Runes.config(String(id2)).get("payload", {})
		var c2: Dictionary = p2.get("condition", {})
		var s2: Array = Runes.rune_shape(String(id2))
		if not (c2.has("tag_threshold") or c2.has("tag_breadth")):
			ungated.append("%s payload" % id2)
		if not (s2.has("THRESHOLD") or s2.has("BREADTH")):
			ungated.append("%s label" % id2)
	ok(ungated.is_empty(),
		"§2: a gated rune FK does not repair has been quietly ungated — %s" % [ungated])
	# ...and every FK shape is a real one. A TRADEOFF is the ONE secondary that
	# survives, so its presence is the positive arm of the negative above.
	var bad_shape: Array = []
	var tradeoffs := 0
	for id3 in FK_IDS:
		var s3: Array = Runes.rune_shape(String(id3))
		if s3.is_empty() or not Runes.RUNE_TYPES.has(String(s3[0])):
			bad_shape.append("%s=%s" % [id3, s3])
			continue
		for extra in s3.slice(1):
			if not Runes.RUNE_SECONDARIES.has(String(extra)):
				bad_shape.append("%s=%s" % [id3, s3])
			elif String(extra) == "TRADEOFF":
				tradeoffs += 1
	ok(bad_shape.is_empty(),
		"§2: an FK shape row is not [TYPE] or [TYPE, SECONDARY] — %s" % [bad_shape])
	ok(tradeoffs == 8,
		"§2: %d FK runes carry a TRADEOFF, not the 8 authored" % tradeoffs)


# ── §3 ──────────────────────────────────────────────────────────────────────
# **THE ANTI-INERT WALK.** A rune is three things and `runes.json` shows one of
# them. This reads the payload's field names off the data, checks each is
# DECLARED on `BattleUnit`, and checks each is READ somewhere under `scripts/`
# other than its own declaration.
#
# **THE READ SWEEP STRIPS ONLY THE COMMENT AND KEEPS THE STRINGS**, which is
# FJ §5's finding taken as a rule: half this codebase's field reads are
# string-keyed (`_max_hero_rank("frigid_ranks", "rune_frigid_ranks")`), so a
# sweep that masked string literals reported five live fields as dead. It fails
# toward the alarming answer, which is why it is worth stating.
func _s3_every_field_declared_and_read() -> void:
	print("\n§3 — every FK payload field is declared, and every one is read")
	var unit_src := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var sources: Array = []
	for f in ["res://scripts/battle.gd", "res://scripts/unit.gd",
			"res://scripts/run_state.gd", "res://scripts/runes.gd"]:
		sources.append(_strip_comments(FileAccess.get_file_as_string(f)))
	var undeclared: Array = []
	var unread: Array = []
	var fields: Array = []
	for id in FK_IDS:
		var stat: Dictionary = Runes.config(String(id)).get("payload", {}).get("stat", {})
		ok(not stat.is_empty(), "§3: %s carries no `stat` payload at all" % id)
		for f2 in stat:
			var field := String(f2)
			if not fields.has(field):
				fields.append(field)
			if not unit_src.contains("var %s " % field) \
					and not unit_src.contains("var %s:" % field) \
					and not unit_src.contains("var %s	" % field):
				undeclared.append("%s <- %s" % [field, id])
			# A READ is any mention outside the declaration line. The declaration
			# lives in `unit.gd` alone, so counting mentions there against 1 and
			# every other file against 0 is the whole test.
			var hits := 0
			for src in sources:
				hits += src.count(field)
			if hits <= 1:
				unread.append("%s <- %s (%d mentions)" % [field, id, hits])
	ok(undeclared.is_empty(),
		"§3: an FK payload writes a field `BattleUnit` does not declare — %s" % [undeclared])
	ok(unread.is_empty(),
		"§3: an FK payload writes a field NOTHING READS — %s" % [unread])
	# **FORTY FIELDS FOR THIRTY-NINE RUNES**, and the extra one is the
	# Whetstone: it writes a FLAG (which arms the growth) and a STEP (the idle
	# `rune_seasoned_off_bonus` the Bared Guard used to write), because "grows
	# each turn" is not a magnitude one field can hold.
	ok(fields.size() == 40,
		"§3: the thirty-nine write %d distinct fields, not 40" % fields.size())
	print("    %d distinct payload fields, all declared, all read" % fields.size())


# ── §4 ──────────────────────────────────────────────────────────────────────
# **BOTH ARMS, BECAUSE THE LIST FAILS IN TWO DIRECTIONS.** An int MISSING from
# it is a runtime error at spawn — loud, and the hero simply does not appear. A
# FLOAT wrongly ON it is silent: JSON's 0.03 is coerced to 0 and the rune reads
# exactly like a rune that works.
func _s4_the_int_list() -> void:
	print("\n§4 — the coercion list, both directions")
	var missing: Array = []
	var wrongly_listed: Array = []
	for id in FK_IDS:
		var stat: Dictionary = Runes.config(String(id)).get("payload", {}).get("stat", {})
		for f in stat:
			var field := String(f)
			var v = stat[f]
			var is_int: bool = float(v) == floor(float(v)) and field != FK_FLOAT
			if is_int and not Runes.STAT_INT_KEYS.has(field) \
					and not field.ends_with("_ranks"):
				missing.append(field)
			if field == FK_FLOAT and Runes.STAT_INT_KEYS.has(field):
				wrongly_listed.append(field)
	ok(missing.is_empty(),
		"§4: an FK int field is not in STAT_INT_KEYS — the hero fails to spawn — %s" % [missing])
	ok(wrongly_listed.is_empty(),
		"§4: the ONE float is on the coercion list and would flatten to 0 — %s" % [wrongly_listed])
	# The float really is one, in the data. Without this the arm above passes on
	# a payload somebody quietly changed to an int.
	var wh: Dictionary = Runes.config("whetstone").get("payload", {}).get("stat", {})
	ok(wh.has(FK_FLOAT) and float(wh[FK_FLOAT]) != floor(float(wh[FK_FLOAT])),
		"§4: the Whetstone's step is no longer fractional — %s" % [wh])


# ── §5 ──────────────────────────────────────────────────────────────────────
# **A rune naming an ability its hero cannot own applies silently and does
# NOTHING** — `Talents.apply_payload` matches on `display_name`. So the name has
# to exist in the corpus, AND it has to be reachable by the spec the rune is
# scoped to, or the rune rolls and is inert for everyone who can buy it.
func _s5_requires_ability_resolves() -> void:
	print("\n§5 — every `requires_ability` resolves, and is reachable")
	var corpus: Array = []
	for ab in Classes.ability_corpus():
		corpus.append(String(ab.display_name))
	var unknown: Array = []
	var unreachable: Array = []
	var n := 0
	for id in FK_IDS:
		var cfg: Dictionary = Runes.config(String(id))
		var req := String(cfg.get("requires_ability", ""))
		if req == "":
			continue
		n += 1
		if not corpus.has(req):
			unknown.append("%s -> %s" % [id, req])
			continue
		var spec := String(cfg.get("scope", "")).trim_prefix("spec:")
		# **ALL FOUR CHANNELS, AND ALL FOUR ARE NAME LISTS.** FJ §1's finding:
		# `hold_ability()` is the one writer, so a zone-boss pick and an elite
		# draft both land in `bm_abilities` and either can satisfy a
		# `requires_ability`. Reading only the spec draft pool would call a
		# boss-pool rune unreachable — which is exactly what the Rune of Blood
		# Debt is (Blood Price is `SPEC_POOLS` only).
		var reach: Array = []
		reach.append_array(Classes.protected_names(spec))
		reach.append_array(Classes.spec_draft_pool(spec))
		reach.append_array(Classes.spec_pool(spec))
		reach.append_array(Classes.class_draft_pool(Classes.class_of_spec(spec)))
		if not reach.has(req):
			unreachable.append("%s -> %s (%s cannot earn it)" % [id, req, spec])
	ok(unknown.is_empty(),
		"§5: an FK rune requires an ability that is not in the corpus — %s" % [unknown])
	ok(unreachable.is_empty(),
		"§5: an FK rune requires an ability its own spec cannot earn — %s" % [unreachable])
	ok(n == 14, "§5: %d FK runes carry `requires_ability`, not 14" % n)


# ── §6 ──────────────────────────────────────────────────────────────────────
# **THE RUNE THAT IS NOT HERE, AND WHY — AS AN ASSERTION RATHER THAN A NOTE.**
# The brief authored a Rune of the Standing Ground reading *"Consecrated Ground
# grants Faith to allies standing in it, not only to its caster."* That is the
# BASE KIT and has been since Batch AW §2, so the rune would have shipped 100%
# inert and the brief's own ruling is that a rune which ships inert is worse
# than one that does not ship.
#
# **BOTH HALVES ARE ASSERTED, AND THE SECOND IS THE ONE THAT MATTERS.** The
# first (no such rune) is a fact about the data. The second is the REASON: the
# ground's status is applied to EVERY living non-companion hero, and the drip is
# paid to whichever hero holds it. **If a later batch narrows that to the
# caster, this arm reds and the rune becomes authorable** — which is the whole
# point of asserting a reason rather than writing it in a report nobody re-reads.
func _s6_the_standing_ground_is_absent() -> void:
	print("\n§6 — the Standing Ground is absent, and the reason is asserted")
	var named: Array = []
	for id2 in Runes.ids():
		if String(Runes.config(String(id2)).get("name", "")).contains("Standing Ground"):
			named.append(id2)
	ok(named.is_empty(),
		"§6: a Rune of the Standing Ground is in the pool — %s" % [named])
	var battle := _strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	# The ground is laid on EVERY hero — the loop, not a single `_apply_status`.
	ok(battle.contains('_apply_status(h, "cons_ground", 3, 0, 0, attacker)'),
		"§6: Consecrated Ground no longer stamps the whole party — the rune is authorable now")
	ok(battle.contains('_gain_faith(u, FAITH_PER_GROUND_TURN, "ground")'),
		"§6: the ground's drip no longer pays the hero standing in it")
	# ...and Fervor still grants no Faith, which is the brief's OTHER false
	# premise. It is a payout multiplier and it has never touched the drip.
	var talents := FileAccess.get_file_as_string("res://scripts/talents.gd")
	ok(talents.contains("It grants no extra Faith at all."),
		"§6: Fervor's own text no longer says it grants no Faith")


# **STRIP THE COMMENT, KEEP THE STRINGS.** FJ §5's rule: half this codebase's
# field reads are string-keyed, so masking string literals reports live fields
# as dead. Quotes are tracked so a `#` inside `"#e05050"` does not truncate.
func _strip_comments(src: String) -> String:
	var out := ""
	for line in src.split("\n"):
		var q := ""
		var cut := line.length()
		for i in line.length():
			var c := line[i]
			if q != "":
				if c == q and (i == 0 or line[i - 1] != "\\"):
					q = ""
			elif c == '"' or c == "'":
				q = c
			elif c == "#":
				cut = i
				break
		out += line.substr(0, cut) + "\n"
	return out
