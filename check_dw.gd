# BATCH DW — the gate for a fingerprint with three holes, and the two
# populations that were pinned over a walk that could not see them.
#
#   §0  THE THREE WALKS ARE DELEGATIONS NOW, ASSERTED AT THE SOURCE. DV found
#       one hand-rolled corpus walk by accident. Widening `check_da` §3 found
#       THREE, and the two it had not found were the two that reached LESS —
#       43 and 91 against `test_batch_cp`'s 207, out of a corpus of 227. Each
#       is asserted to delegate AND to carry no source-family mark of its own,
#       because "it calls `ability_corpus()` now" and "it no longer walks the
#       pools itself" are two different claims and a batch can satisfy one.
#   §1  THE LITERAL-DIGIT POPULATION IS EIGHT AND IS DERIVED. It stood at
#       `["Shatter"]` as an EQUALITY because the walk under it reached 207.
#   §2  THE CHECKED-BUT-PERFECTLESS POPULATION IS EIGHT, for the same reason
#       and out of the same blind spot. ARCANE EXPLOSION is a LIVE BASIC
#       ATTACK that broke both rules on arrival at DU §4 with nothing red.
#   §3  THE 49-CHARACTER OVERRUN WAS TWO AUTHORED SITES AND THE OLDER ONE WAS
#       ALWAYS VISIBLE. DV recorded Shadowrend's Perfect as the one thing DU's
#       corpus fix surfaced; SMITE carried the identical string and has been in
#       the corpus since long before DU. Both are repaired and BOTH are
#       asserted, because fixing one of two copies is how two copies start.
#   §4  THE FOUR OVERRIDES, MEASURED AGAINST THE CEILING AS A POPULATION —
#       what DU §4 made checkable, whether it broke a rule or not.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_dw.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# `check_cl_width`'s measured ceiling, named here rather than re-derived: this
# gate asserts against the same number that gate reports against, and a second
# copy of it is exactly what DW §3 is about. It is 44.
const CEILING := 44

# The three walks DW repaired, and what each reached before it was repointed.
# THE FIGURES ARE THE FINDING and they are carried here so a later batch reads
# how badly each one was blind rather than re-deriving it from nothing.
const REPAIRED_WALKS := {
	"check_cl_resolver.gd": ["_every_ability", 43],
	"test_batch_bh.gd": ["_all_ability_names", 91],
	"test_batch_cp.gd": ["_corpus", 207],
}

var _g := Gate.new()


# THE SEVEN SOURCE FAMILIES, SPLIT ACROSS A `+` FOR THE REASON `check_da`'s
# marks are: this file is swept by both halves of `check_da` §3, and a gate
# whose source carries its own fingerprint accuses itself on the first run and
# gets suppressed on the second.
func _family_marks() -> Array:
	return [
		"Classes.ki" + "t(",
		"Classes.class_" + "pool(", "Classes.CLASS_" + "POOLS",
		"Classes.class_draft_" + "pool(", "Classes.CLASS_DRAFT_" + "POOLS",
		"Classes.spec_abili" + "ties(",
		"Classes.spec_" + "pool(", "Classes.SPEC_" + "POOLS",
		"Classes.spec_draft_" + "pool(", "Classes.SPEC_DRAFT_" + "POOLS",
		"Talents.LANE_" + "TREES", "Classes.talent_granted_" + "names(",
	]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH DW — the fingerprint's three holes, and the two blind populations")
	_s0_walks_are_delegations()
	_s1_digit_population()
	_s2_perfectless_population()
	_s3_the_overrun_was_two_sites()
	_s4_what_du_made_checkable()
	_g.report(self)


# ── §0 — THE THREE WALKS, ASSERTED AT THE SOURCE ────────────────────────────
func _s0_walks_are_delegations() -> void:
	print("\n§0 — the three hand-rolled walks are delegations now")
	var corpus_call := "Classes.ability_cor" + "pus("
	for f in REPAIRED_WALKS:
		var fname: String = REPAIRED_WALKS[f][0]
		var reached: int = REPAIRED_WALKS[f][1]
		var src := FileAccess.get_file_as_string("res://" + f)
		ok(src != "", "§0: %s is unreadable" % f)
		var bodies := Gate.returning_bodies(src)
		ok(bodies.has(fname), "§0: %s::%s no longer exists — the walk was renamed, not repaired" % [f, fname])
		if not bodies.has(fname):
			continue
		var body: String = bodies[fname]
		ok(body.contains(corpus_call),
			"§0: %s::%s does not call `Classes.ability_corpus()` — it reached %d of the corpus before DW"
				% [f, fname, reached])
		# AND THE SECOND HALF, WHICH IS THE ONE A PARTIAL REPAIR WOULD FAIL:
		# a body that calls the canonical walk AND still reads the pools itself
		# is the shape `check_da` §3's exemptions exist for, and none of these
		# three has a reason to be one.
		var still: Array = []
		for m in _family_marks():
			if body.contains(m):
				still.append(m)
		ok(still.is_empty(),
			"§0: %s::%s still reads %d ability source(s) of its own beside the corpus walk"
				% [f, fname, still.size()])
	# THE WIDENED SWEEP'S EXEMPTION TABLE, ASSERTED FROM HERE RATHER THAN FROM
	# INSIDE `check_da`. An exemption granted to a genuine violation is worse
	# than the violation, so the SIZE of that table is a claim worth pinning: it
	# is ONE, and a batch that adds a second has to move this line and say why.
	var da := load("res://check_da.gd")
	var consts: Dictionary = da.get_script_constant_map()
	var exempt: Dictionary = consts.get("RETURN_WALK_EXEMPT", {})
	ok(exempt.size() == 1,
		"§0: the widened sweep carries %d exemptions, not the ONE DW left it with — %s"
			% [exempt.size(), ", ".join(PackedStringArray(exempt.keys()))])
	ok(exempt.has("check_cz.gd::_cl_only_corpus"),
		"§0: `check_cz::_cl_only_corpus` is no longer the exemption — the CL negative control has moved or gone")
	print("  %d walks repaired; the widened sweep carries %d exemption(s)" % [
		REPAIRED_WALKS.size(), exempt.size()])


# ── §1 — THE LITERAL-DIGIT POPULATION ───────────────────────────────────────
# DERIVED HERE AND COMPARED AGAINST THE SUITE'S TABLE, which is the pairing
# that matters: the suite pins a NAMED population so a ninth has to be a
# decision, and this re-derives it live so the named population cannot quietly
# stop being the real one. That is precisely what happened between CN and DW.
func _s1_digit_population() -> void:
	print("\n§1 — the authored literal-digit population")
	var paren := RegEx.new()
	paren.compile("\\((?:[^()]*[0-9])[^()]*\\)")
	var live: Array = []
	for ab in Classes.ability_corpus():
		for f in [ab.description, ab.perfect_text]:
			var s := String(f)
			if s != "" and paren.search(s) != null and not live.has(ab.display_name):
				live.append(ab.display_name)
	live.sort()
	var cp := load("res://test_batch_cp.gd")
	var named: Array = Array(cp.get_script_constant_map().get("AUTHORED_DIGIT_ABILITIES", []))
	named.sort()
	ok(live == named,
		"§1: the live literal-digit population is %d and `test_batch_cp.AUTHORED_DIGIT_ABILITIES` names %d — %s against %s"
			% [live.size(), named.size(), ", ".join(PackedStringArray(live)),
				", ".join(PackedStringArray(named))])
	ok(live.size() == 8,
		"§1: the literal-digit population is %d, not the eight DW measured — %s"
			% [live.size(), ", ".join(PackedStringArray(live))])
	ok(live.has("Arcane Explosion"),
		"§1: Arcane Explosion is no longer a literal-digit offender — DU's fourth override has changed")
	print("  %d abilities carry an authored digit in parentheses: %s" % [
		live.size(), ", ".join(PackedStringArray(live))])


# ── §2 — THE CHECKED-BUT-PERFECTLESS POPULATION ─────────────────────────────
func _s2_perfectless_population() -> void:
	print("\n§2 — the abilities that run a check and advertise no Perfect")
	var live: Array = []
	for ab in Classes.ability_corpus():
		if ab.runs_skill_check() and ab.perfect_text.strip_edges() == "":
			live.append(ab.display_name)
	live.sort()
	var cp := load("res://test_batch_cp.gd")
	var named: Array = Array(cp.get_script_constant_map().get("CHECK_WITHOUT_PERFECT", []))
	named.sort()
	ok(live == named,
		"§2: the live checked-but-Perfectless population is %d and `test_batch_cp.CHECK_WITHOUT_PERFECT` names %d — %s against %s"
			% [live.size(), named.size(), ", ".join(PackedStringArray(live)),
				", ".join(PackedStringArray(named))])
	ok(live.size() == 8,
		"§2: the population is %d, not the eight DW measured — %s"
			% [live.size(), ", ".join(PackedStringArray(live))])
	# THE ONE WORTH NAMING. The other seven are pool cards; this is a hero's
	# BASIC ATTACK, so it is the timing bar a player sees most often with no
	# stated bonus behind it. Authoring one is a design decision and DW did not
	# take it — this asserts the GAP is still where DW found it.
	ok(live.has("Arcane Explosion"),
		"§2: Arcane Explosion no longer runs a check without a Perfect — the gap DW reported has been authored shut")
	print("  %d abilities run a check and state no Perfect: %s" % [
		live.size(), ", ".join(PackedStringArray(live))])


# ── §3 — THE OVERRUN WAS TWO SITES AND THE OLDER ONE WAS NEVER HIDDEN ───────
func _s3_the_overrun_was_two_sites() -> void:
	print("\n§3 — the shared Perfect, both sites")
	var sr = null
	var sm = null
	for ab in Classes.ability_corpus():
		if ab.display_name == "Shadowrend":
			sr = ab
		elif ab.display_name == "Smite":
			sm = ab
	ok(sr != null, "§3: Shadowrend is not in the corpus — DU §4's override walk has been reverted")
	ok(sm != null, "§3: Smite is not in the corpus — the class-kit walk has been reverted")
	if sr == null or sm == null:
		return
	# THE DIVERGENCE GUARD, AND IT IS THE POINT OF THE SECTION. Two authored
	# copies of one string is what made this a two-site repair; asserting they
	# AGREE is what stops the next batch fixing one of them.
	ok(sr.perfect_text == sm.perfect_text,
		"§3: Shadowrend's Perfect and Smite's have diverged — `%s` against `%s`"
			% [sr.perfect_text, sm.perfect_text])
	var cc := Classes.hero_config("cleric")
	var ctx := Classes.value_ctx_from_config(cc, {"hp": int(cc["max_hp"] * 0.7)})
	for pair in [[sr, "Shadowrend"], [sm, "Smite"]]:
		var rendered: String = "Perfect: " + Classes.resolve_values(pair[0].perfect_text, ctx)
		ok(rendered.length() <= CEILING,
			"§3: %s's rendered Perfect is %d against the %d ceiling — the DW repair has been reverted"
				% [pair[1], rendered.length(), CEILING])
		print("  %-11s rendered Perfect: %d of %d" % [pair[1], rendered.length(), CEILING])
	# AND THE CORRECTION TO DV's RECORD, ASSERTED RATHER THAN WRITTEN DOWN:
	# SMITE IS IN THE CLERIC CLASS KIT, so it is reachable with no override at
	# all and the corpus has held it since long before DU §4. Shadowrend is NOT
	# — it arrives only through `apply_kit_overrides`. That asymmetry is the
	# whole of why "the one thing DU made visible" was wrong.
	var kit_names := {}
	for kab in Classes.kit("cleric"):
		kit_names[kab.display_name] = true
	ok(kit_names.has("Smite"),
		"§3: Smite is no longer in `kit(\"cleric\")` — the claim that its overrun predates DU rests on this")
	ok(not kit_names.has("Shadowrend"),
		"§3: Shadowrend is in the UNOVERRIDDEN cleric kit — it should arrive only through `apply_kit_overrides`")


# ── §4 — WHAT DU §4 MADE CHECKABLE, AS A POPULATION ─────────────────────────
# Four abilities entered the corpus at DU and nobody had read the complete
# result. THREE OF THE FOUR WERE CLEAN and the fourth broke a rule that could
# not see it — which is the finding, and it is only visible if all four are
# measured rather than the one that failed.
func _s4_what_du_made_checkable() -> void:
	print("\n§4 — the four kit overrides, measured against the ceiling")
	var ctxs: Array = []
	for key in ["warrior", "mage", "cleric", "hunter"]:
		var cfg := Classes.hero_config(key)
		ctxs.append(Classes.value_ctx_from_config(cfg, {"hp": int(cfg["max_hp"] * 0.7)}))
	var found := 0
	for ab in Classes.ability_corpus():
		if not ab.display_name in ["Shadowrend", "Fireball", "Frostbolt", "Arcane Explosion"]:
			continue
		found += 1
		for fld in ["description", "perfect_text"]:
			var raw: String = String(ab.get(fld))
			if raw == "":
				continue
			var worst := 0
			for ctx in ctxs:
				var r: String = Classes.resolve_values(raw, ctx)
				if fld == "perfect_text":
					r = "Perfect: " + r
				for line in r.split("\n"):
					worst = maxi(worst, line.length())
			ok(worst <= CEILING,
				"§4: %s's rendered %s is %d against the %d ceiling"
					% [ab.display_name, fld, worst, CEILING])
			print("  %-17s %-13s %d of %d" % [ab.display_name, fld, worst, CEILING])
	ok(found == 4,
		"§4: %d of the four DU §4 overrides are in the corpus, not four" % found)
