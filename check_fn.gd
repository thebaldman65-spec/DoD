# BATCH FN — THE EIGHT GATED RUNES COME OFF THEIR CONDITIONS.
#
#   §1  THE EIGHT ARE UNGATED — payload, label and `desc`, over a NAMED
#       population that is HEAD's own `check_fk.STILL_GATED` list carried here
#       verbatim, plus a CENSUS of all 126 entries so a ninth cannot appear
#   §2  THE MACHINERY IS GONE — nine functions absent AND uncalled, with the
#       seven that STAY asserted PRESENT, because a gate that only checked
#       absence passes on a file somebody emptied
#   §3  THE TWO SCREENS, DRIVEN — the `CARRIED BY TAG` census stays and the
#       `RUNE CONDITIONS` line goes, on the loadout panel and the hero sheet
#   §4  EACH OF THE EIGHT, ON A LOADOUT THAT WOULD HAVE FAILED ITS OLD
#       CONDITION — through the payload door and through a REAL SPAWN, each
#       arm paired with the retired predicate re-implemented here as its
#       control, so "it lands" is not what an arm built on a PASSING loadout
#       would print
#
# **WHY THIS BATCH EARNS A GATE.** It encodes a RULING — THRESHOLD and BREADTH
# are retired and the eight runes that carried them are unconditional — and the
# ruling decays in four directions, all of them silent:
#
#   §1 DECAYS BY RE-AUTHORING. A `"condition"` key is four characters in a JSON
#     payload and nothing else in the tree would notice one arriving. The
#     population is a CENSUS of every entry rather than the eight, so a NINTH
#     gated rune is caught by the same assertion that watches these eight.
#   §2 DECAYS BY RE-ADDITION, and a re-added helper is invisible: nine dead
#     functions came out and every one of them is the obvious thing to write
#     again the day somebody wants a loadout question answered. The absence is
#     asserted at the DEFINITION and again at every CALL SITE, because a
#     function can come back under a different name and still be the same rule.
#   §3 IS THE HALF NO SOURCE READ CAN SEE. A screen line is a DRAW-time fact
#     (FE §2's 604 dead buttons, FM §2's header over white space), so these
#     arms open the real panel and the real sheet and read the Labels.
#   §4 IS THE CLAIM THE BRIEF ASKS FOR IN ITS OWN WORDS — *drive each of the
#     eight on a loadout that would have FAILED its old condition and confirm
#     it now lands.* **The retired predicate is re-implemented here** for one
#     reason: without it the arm cannot prove its loadout would have failed,
#     and an arm built on a loadout that PASSES the old rule tests nothing.
#
# **THE FOUR SPECS ARE THE FOUR THAT CARRY THESE RUNES**, not a convenient
# party: `spec:occultist`, `spec:warden`, `spec:sharpshooter`, `spec:beastmaster`
# — asserted off the entries rather than written in, so a rune re-scoped
# elsewhere moves this list rather than quietly leaving the gate driving the
# wrong four heroes.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_fn.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# **THE EIGHT, BY ID — HEAD's `check_fk.STILL_GATED`, CARRIED VERBATIM.** Listed
# rather than derived, and the reason is FK's own: a walk that derived "the
# gated eight" from a property (carries a `condition`, say) would be EMPTY after
# this batch and would then pass on a tree where all eight had been quietly
# deleted. The list is the population; the census below is what catches a ninth.
const UNGATED := ["deepening_hex", "wide_rite", "bracing_line", "long_watch",
	"heavy_bolts", "wide_watch", "answering_pack", "shared_scent"]

# **THE ORDER THE LIVE BOARD IS SPAWNED IN, AND IT IS NOT THE SORTED ONE.**
# `gate_fixture.spawn` builds a warrior/mage/cleric/hunter party and stamps the
# specs onto it positionally, so this list is a SEATING and the sorted set below
# is the POPULATION; §4 asserts they hold the same four names rather than
# assuming it. (Two of the four are Hunter specs, so the seats cannot be made to
# agree with the class keys — `check_ez` §5 spawns exactly this way.)
const DRIVE_ORDER := ["occultist", "warden", "sharpshooter", "beastmaster"]

# **THE CONDITIONS THEY CARRIED, RE-IMPLEMENTED HERE SO §4 CAN BUILD AN ARM THAT
# FAILS THEM.** This is the retired rule, kept in the gate that retired it —
# `check_fd` §2's `_pre_fd_peak` precedent, and for the same reason: an arm
# asserting "the payload lands on a loadout that used to refuse it" is worth
# nothing unless the loadout really used to be refused.
const OLD_CONDITION := {
	"deepening_hex": {"tag_threshold": "DEBUFF"},
	"wide_rite": {"tag_breadth": true},
	"bracing_line": {"tag_threshold": "DEFENSE"},
	"long_watch": {"tag_breadth": true},
	"heavy_bolts": {"tag_threshold": "MARK"},
	"wide_watch": {"tag_breadth": true},
	"answering_pack": {"tag_threshold": "DEFENSE"},
	"shared_scent": {"tag_breadth": true},
}

# The field each of the eight writes, and the value it writes. Held here so §4
# asserts the VALUE landed rather than merely that a key appeared — a payload
# that landed a zero would satisfy `cfg.has(field)` and pay nothing.
# **BATCH FO — THE ONE OF THE EIGHT THAT MAY CARRY A RETIREMENT, AND WHY.**
# The Wide Watch was authored against a base the Sharpshooter's OVERKILL node
# already provided and was worth exactly zero to a holder of both; FO retired it
# on the Melted Armor contract and replaced it with the Shared Mark. **The list
# is the population, so an eighth quietly retired rune still reds §1a.**
const RETIRED_BY_RULING := ["wide_watch"]

const FIELD := {
	# BATCH FO §1 — DEEPENING HEX SUBTRACTS 2 rather than installing 8, and the
	# field is RENAMED with it: `rune_hex_threshold` holding a decrement would be
	# a name that lies, and EM's charter says the field name is the rule.
	"deepening_hex": ["rune_hex_deepen", 2],
	"wide_rite": ["rune_wide_rite", 1],
	"bracing_line": ["rune_bracing_line", 5],
	"long_watch": ["rune_long_watch", 1],
	"heavy_bolts": ["rune_heavy_bolts", 20],
	"wide_watch": ["rune_wide_watch", 1],
	"answering_pack": ["rune_answering_pack", 1],
	"shared_scent": ["rune_shared_scent", 1],
}

# The two clause shapes the eight `desc` strings carried. Both are the fraction
# wording `docs/text-standard.html` §4.10 made binding at EZ and FN retired.
const CLAUSE := ["while at least HALF", "while NO tag holds"]

# **GONE, AND THE SPELLING IS THE `func` DECLARATION, NOT THE BARE NAME.** A
# bare-name sweep would match this gate's own prose and every comment recording
# the removal — `check_da` §3's own scar, twice in one file at FM.
const REMOVED := [
	["scripts/runes.gd", "threshold_met"],
	["scripts/runes.gd", "breadth_met_fraction"],
	["scripts/runes.gd", "drafted_names"],
	["scripts/runes.gd", "loadout_condition_met"],
	["scripts/runes.gd", "threshold_line"],
	["scripts/runes.gd", "breadth_line"],
	["scripts/classes.gd", "primary_tag_count"],
	["scripts/classes.gd", "primary_tag_census"],
	["scripts/classes.gd", "primary_tag_peak"],
]

# **AND THE POSITIVE ARM, WHICH IS WHAT STOPS §2 PASSING ON AN EMPTIED FILE.**
# Every one of these is a tag-layer reader that SURVIVES, each for a stated
# reason: the three censuses are ES §4's and `check_es` §4 prints them every
# battery; `card_tag_primary` arrived at EK with the vocabulary itself and is
# the accessor for the primary-first ordering `check_ek` §2 pins; the two ES
# §4/§5 shapes are the door a future rune comes back through; `rune_tag_line`
# is FE §1b's zero-caller reader, kept for the deferred rune-offer surface.
const KEPT := [
	["scripts/classes.gd", "tag_count"],
	["scripts/classes.gd", "tag_census"],
	["scripts/classes.gd", "tag_breadth"],
	["scripts/classes.gd", "card_tag_primary"],
	["scripts/runes.gd", "tag_threshold_met"],
	["scripts/runes.gd", "breadth_met"],
	["scripts/runes.gd", "rune_tag_line"],
]

# The two names that have ZERO callers in `scripts/` and are kept anyway, said
# out loud so the day one gains a caller this gate reports it rather than the
# claim quietly becoming false in four documents (FE §1b's shape).
const KEPT_UNCALLED := ["card_tag_primary", "rune_tag_line"]

var _g := Gate.new()
var _run: Node = null
var _specs: Array = []


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260908)
	print("BATCH FN — THE EIGHT GATED RUNES COME OFF THEIR CONDITIONS")
	_run = root.get_node("/root/Run")
	_s1_the_eight_are_ungated()
	_s2_the_machinery_is_gone()
	await _s3_the_two_screens()
	await _s4_on_a_failing_loadout()
	_g.report(self)


# ═══ §1 — THE EIGHT ARE UNGATED ══════════════════════════════════════════════

func _s1_the_eight_are_ungated() -> void:
	print("\n§1 — the eight are ungated: payload, label and desc")
	var raw: String = FileAccess.get_file_as_string("res://data/runes.json")
	var data: Dictionary = JSON.parse_string(raw) as Dictionary
	ok(data != null and data.size() >= 120,
		"§1: the rune file did not parse — the census below would read a clean tree")
	if data == null:
		return

	# ── (a) THE EIGHT THEMSELVES, BY NAME ────────────────────────────────────
	var missing: Array = []
	var retired: Array = []
	var priced: Array = []
	var still_gated: Array = []
	var scopes: Array = []
	for id in UNGATED:
		if not data.has(id):
			missing.append(String(id))
			continue
		var e: Dictionary = data[id]
		if e.has("retired"):
			retired.append(String(id))
		if int(e.get("price", 0)) != 100:
			priced.append("%s:%d" % [id, int(e.get("price", 0))])
		if (e.get("payload", {}) as Dictionary).has("condition"):
			still_gated.append(String(id))
		var sc := String(e.get("scope", ""))
		if not scopes.has(sc):
			scopes.append(sc)
	ok(missing.is_empty(), "§1a: an id of the eight is not in the file (%s)" % [missing])
	# **BATCH FO RETIRED ONE OF THE EIGHT, BY RULING, AND THIS ARM IS RE-POINTED
	# RATHER THAN WEAKENED.** It asserted that no one of the eight was quietly
	# RETIRED instead of ungated — a real guard, because a retirement removes a
	# rune from the offer and would satisfy "it is not gated" by making it
	# unreachable. **FO retired the Wide Watch for a different reason entirely**:
	# it duplicated Overkill's effect and was worth exactly zero to a holder of
	# that node. So the arm now names the ONE that may be retired and still
	# refuses the other seven, which is the same guard with the ruling written
	# into it (the `check_fk` §2 inversion, and for the same reason).
	ok(retired == RETIRED_BY_RULING,
		"§1a: the retired set among the eight is %s, not %s — a retirement is a RULING and this is the list of them"
			% [retired, RETIRED_BY_RULING])
	ok(priced.is_empty(), "§1a: one of the eight left the flat 100g (%s)" % [priced])
	ok(still_gated.is_empty(), "§1a: one of the eight STILL carries a condition (%s)" % [still_gated])
	scopes.sort()
	_specs = []
	for sc2 in scopes:
		_specs.append(String(sc2).replace("spec:", ""))
	ok(scopes == ["spec:beastmaster", "spec:occultist", "spec:sharpshooter",
			"spec:warden"],
		"§1a: the eight no longer sit on the four specs this gate drives (%s)" % [scopes])

	# ── (b) THE CENSUS, WHICH IS WHAT CATCHES A NINTH ────────────────────────
	#
	# **THE POPULATION IS EVERY ENTRY, LIVE AND RETIRED.** A retired entry is
	# still `config`-resolvable and a saved run can be holding one, so a
	# condition re-appearing there is the same defect arriving somewhere nobody
	# would look. 126 entries at FN; the number is printed, not pinned, because
	# the pool grows (DX §1) — the ZERO is the assertion.
	var gated_now: Array = []
	for id2 in data:
		if ((data[id2] as Dictionary).get("payload", {}) as Dictionary).has("condition"):
			gated_now.append(String(id2))
	ok(gated_now.is_empty(),
		"§1b: %d of %d entries carry a payload condition — THRESHOLD and BREADTH are retired (%s)"
			% [gated_now.size(), data.size(), gated_now])

	# ── (c) THE LABEL HALF, WHICH IS A DIFFERENT FILE ───────────────────────
	#
	# `check_ez` §0 asserts the label and the payload AGREE, so with both sides
	# empty that equality is satisfied by doing nothing. **This is the arm that
	# is not satisfied by nothing**: the words themselves are counted over
	# `RUNE_SHAPES`, with TRADEOFF's twelve as the positive arm — a table
	# somebody had emptied reads zero THRESHOLD too.
	var thr := 0
	var brd := 0
	var trade := 0
	var rows := 0
	for id3 in Runes.RUNE_SHAPES:
		rows += 1
		for w in Runes.RUNE_SHAPES[id3]:
			match String(w):
				"THRESHOLD": thr += 1
				"BREADTH": brd += 1
				"TRADEOFF": trade += 1
	ok(rows >= 60, "§1c: `RUNE_SHAPES` holds %d rows — the walk read nothing" % rows)
	ok(thr == 0 and brd == 0,
		"§1c: %d rows still carry THRESHOLD and %d BREADTH" % [thr, brd])
	ok(trade == 12,
		"§1c: TRADEOFF reads %d, not the 12 that survive the retirement" % trade)
	# **AND THE VOCABULARY IS KEPT RATHER THAN RE-SPELLED.** Deleting the two
	# words from `RUNE_SECONDARIES` would make a re-authored gate impossible to
	# express and would hide the retirement instead of stating it; the ruling
	# lives in the assertion above, not in the spelling.
	ok(Runes.RUNE_SECONDARIES.has("THRESHOLD")
			and Runes.RUNE_SECONDARIES.has("BREADTH")
			and Runes.RUNE_SECONDARIES.has("TRADEOFF"),
		"§1c: the secondary vocabulary was re-spelled instead of the rows being ungated (%s)"
			% [Runes.RUNE_SECONDARIES])

	# ── (d) THE `desc` HALF, AND THE ONE CLAUSE THAT MUST SURVIVE ───────────
	#
	# **BRACING LINE CARRIES TWO GATES AND ONLY ONE OF THEM IS THE SECONDARY**
	# (FL §2a/§2b). The retired one was `tag_threshold: DEFENSE`, read at the
	# SPAWN; the other is Heavy Plating standing at `BRACING_LINE_LEVEL`, read
	# in the FIGHT by `battle.gd`, which never saw the threshold. **It is
	# untouched, and its clause must still be on the card** — this arm is what
	# separates "the condition clause came off" from "the description was
	# trimmed".
	var clause_left: Array = []
	for id4 in data:
		var desc := String((data[id4] as Dictionary).get("desc", ""))
		for c in CLAUSE:
			if desc.contains(String(c)):
				clause_left.append("%s: %s" % [id4, c])
	ok(clause_left.is_empty(),
		"§1d: a rune's desc still states a retired condition (%s)" % [clause_left])
	var bl := String((data["bracing_line"] as Dictionary).get("desc", ""))
	ok(bl.contains("Heavy Plating") and bl.contains("+32%"),
		"§1d: Bracing Line's SURVIVING gate came off its card too — reads `%s`" % bl)
	# THE CODE HALF OF THAT SAME GATE, so the card and the fight agree.
	var bsrc := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bsrc.contains("BRACING_LINE_LEVEL := 32"),
		"§1d: ...and `BRACING_LINE_LEVEL` no longer reads 32 in the fight")
	print("    8 ungated, 0 of %d entries gated, THRESHOLD 0 / BREADTH 0 / TRADEOFF %d"
		% [data.size(), trade])


# ═══ §2 — THE MACHINERY IS GONE ══════════════════════════════════════════════

func _s2_the_machinery_is_gone() -> void:
	print("\n§2 — the machinery: nine gone and uncalled, seven kept and present")
	var bodies := {}
	for path in ["scripts/runes.gd", "scripts/classes.gd", "scripts/talents.gd",
			"scripts/party_screen.gd", "scripts/map_screen.gd"]:
		bodies[path] = Gate.strip_comments(
			FileAccess.get_file_as_string("res://" + String(path)))
		ok(String(bodies[path]).length() > 1000,
			"§2: `%s` read as %d characters — the sweep read nothing"
				% [path, String(bodies[path]).length()])

	# ── (a) THE DEFINITIONS ARE GONE ────────────────────────────────────────
	var still_defined: Array = []
	for row in REMOVED:
		var src := String(bodies[String(row[0])])
		if src.contains("func %s(" % String(row[1])):
			still_defined.append("%s: %s" % [row[0], row[1]])
	ok(still_defined.is_empty(),
		"§2a: a removed condition function is still defined (%s)" % [still_defined])

	# ── (b) AND THE KEPT ONES ARE STILL THERE ───────────────────────────────
	var lost: Array = []
	for row2 in KEPT:
		var src2 := String(bodies[String(row2[0])])
		if not src2.contains("func %s(" % String(row2[1])):
			lost.append("%s: %s" % [row2[0], row2[1]])
	ok(lost.is_empty(),
		"§2b: a tag reader that must STAY is gone (%s) — §2a would pass on an emptied file"
			% [lost])

	# ── (c) NO CALLER ANYWHERE UNDER `scripts/` ─────────────────────────────
	#
	# **A DEFINITION SWEEP IS NOT A CALLER SWEEP.** The failure this arm exists
	# for is a caller left behind on a function that is gone — which is a parse
	# error here and would be caught, and a caller left behind on a name that
	# came BACK, which would not. The population is the whole directory rather
	# than the five files above, and it asserts its own size.
	var dir := DirAccess.open("res://scripts")
	var files: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.ends_with(".gd"):
				files.append(String(f))
	files.sort()
	ok(files.size() >= 15,
		"§2c: the caller sweep read %d files under `scripts/` — it read nothing"
			% files.size())
	# **THE MATCH IS BOUNDED, AND THE FIRST ARMING OF THIS SWEEP PROVED WHY.**
	# `tag_threshold_met(` CONTAINS `threshold_met(`, so a bare `contains` read
	# the ES §4 shape that SURVIVES as a caller of the EZ predicate that went —
	# one removed name reported live in the file that kept its neighbour.
	var callers: Array = []
	for f2 in files:
		var body := Gate.strip_comments(
			FileAccess.get_file_as_string("res://scripts/" + String(f2)))
		for row3 in REMOVED:
			if _names_call(body, String(row3[1])):
				callers.append("%s names %s" % [f2, row3[1]])
	ok(callers.is_empty(),
		"§2c: a removed condition function is still called (%s)" % [callers])

	# ── (d) THE TWO KEPT-BUT-UNCALLED, SAID OUT LOUD ────────────────────────
	var called: Array = []
	for name in KEPT_UNCALLED:
		var n := 0
		for f3 in files:
			var body2 := Gate.strip_comments(
				FileAccess.get_file_as_string("res://scripts/" + String(f3)))
			for line in body2.split("\n"):
				if _names_call(String(line), String(name)) \
						and not String(line).contains("func %s(" % String(name)):
					n += 1
		if n > 0:
			called.append("%s: %d" % [name, n])
	ok(called.is_empty(),
		"§2d: a kept-but-uncalled tag reader gained a caller (%s) — say so rather than let four documents go false"
			% [called])

	# ── (e) `talents.gd` NAMES NONE OF IT, AND ITS OWN CONDITIONS STILL WORK ─
	#
	# **THE NEGATIVE AND THE POSITIVE IN ONE PLACE.** EZ moved this file into
	# `check_ek` §3's `TAG_CONSUMERS` because it named the one door; FN moves it
	# back into `NO_TAG_FILES`. That is only an improvement if the file's OTHER
	# two condition keys still decide something, so both are driven.
	var tsrc := String(bodies["scripts/talents.gd"])
	var named: Array = []
	for row4 in REMOVED:
		if tsrc.contains(String(row4[1])):
			named.append(String(row4[1]))
	for tw in Classes.TAG_ORDER:
		if tsrc.contains('"%s"' % String(tw)):
			named.append(String(tw))
	ok(named.is_empty(),
		"§2e: `talents.gd` still names the tag surface (%s)" % [named])
	ok(Talents.condition_met({}, {}),
		"§2e: an EMPTY condition is no longer unconditional")
	ok(not Talents.condition_met({"has_node": "oc_avatar_ruin"}, {"learned": {}}),
		"§2e: a `has_node` condition no longer refuses on a hero without the node")
	ok(Talents.condition_met({"has_node": "oc_avatar_ruin"},
			{"learned": {"oc_avatar_ruin": 1}}),
		"§2e: ...and no longer PASSES on a hero who has it — the door is broken, not narrowed")
	print("    9 removed and uncalled; 7 kept and present; talents.gd names 0 tag words")


# ═══ §3 — THE TWO SCREENS ════════════════════════════════════════════════════

func _s3_the_two_screens() -> void:
	print("\n§3 — the loadout panel and the hero sheet, driven")
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	var party_specs := ["warden", "occultist", "holy", "sharpshooter"]
	for i in _run.party.size():
		_run.party[i]["spec"] = party_specs[i]
		_run.party[i]["tree"] = Talents.generate_tree(party_specs[i],
			_run.party[i]["key"])
		_run.sync_spec_hp(i)
	_run.specs_chosen = true
	_run.active = true

	# GIVE HIM CARDS, THROUGH THE RUN'S OWN DOOR. A hero with an empty drafted
	# half is the one state EZ's two conditions were both vacuous on (FA §1), so
	# an empty bar is the wrong board to prove a line is gone on.
	var hero: Dictionary = _run.party[0]
	var drafted := 0
	for _i in 10:
		if not bool(_run.award_draft_pick(hero)):
			break
		var q: Array = hero.get("draft_candidates", [])
		if q.is_empty():
			break
		if String(_run.take_draft_ability(hero, String((q[0] as Array)[0]))) == "":
			drafted += 1
		else:
			break
	ok(drafted >= 3, "§3: only %d cards were drafted — the screens read an empty bar"
		% drafted)

	change_scene_to_file("res://scenes/map.tscn")
	for _i in 5:
		await process_frame
	var map: Node = current_scene
	ok(map != null and String(map.name).contains("Map"),
		"§3: the map screen did not open (got %s)" % [
			"<none>" if map == null else map.name])
	if map == null:
		return
	map.call("_open_loadout_panel", 0)
	await process_frame
	var panel: Node = _overlay(map, 60)
	ok(panel != null, "§3: the loadout panel did not open")
	if panel != null:
		# **THE POSITIVE ARM FIRST.** "The panel does not say RUNE CONDITIONS"
		# is exactly what an unopened panel prints, so the census line that
		# STAYS is read on the same node in the same breath.
		ok(_has_text(panel, "CARRIED BY TAG"),
			"§3: the loadout panel lost its `CARRIED BY TAG` census — the tags are player-facing (EK) and are not conditions")
		ok(not _has_text(panel, "RUNE CONDITIONS"),
			"§3: the loadout panel still draws a `RUNE CONDITIONS` line for conditions that no longer exist")
		ok(not _has_text(panel, "peak "),
			"§3: ...and it still draws the breadth line under it")

	_run.hero_screen_idx = 0
	change_scene_to_file("res://scenes/party.tscn")
	for _i in 5:
		await process_frame
	var sheet: Node = current_scene
	ok(sheet != null and String(sheet.name).contains("Party"),
		"§3: the hero sheet did not open (got %s)" % [
			"<none>" if sheet == null else sheet.name])
	if sheet != null:
		ok(_has_text(sheet, "CARRIED BY TAG"),
			"§3: the hero sheet lost its `CARRIED BY TAG` census")
		ok(not _has_text(sheet, "RUNE CONDITIONS"),
			"§3: the hero sheet still draws a `RUNE CONDITIONS` line")
		ok(not _has_text(sheet, "peak "),
			"§3: ...and it still draws the breadth line under it")
	# **LEAVE A MAP BEHIND, NOT A HERO SHEET.** §4 spawns a battle as a child of
	# `root` while `current_scene` stays whatever this section left; a sheet
	# holding a party dict that `new_run` is about to replace is a state no run
	# reaches, and the map is the screen a fight actually starts from.
	change_scene_to_file("res://scenes/map.tscn")
	for _i in 3:
		await process_frame
	print("    both screens keep the census and neither draws a condition line")


# ═══ §4 — EACH OF THE EIGHT, ON A LOADOUT THAT WOULD HAVE FAILED ═════════════

func _s4_on_a_failing_loadout() -> void:
	print("\n§4 — the eight, on loadouts that would have failed the old condition")
	# The two arms' card lists, built off the live corpus rather than named:
	# a THRESHOLD fails on a bar carrying NONE of its tag, and a BREADTH fails
	# on a bar stacked entirely on one tag.
	var by_tag := {}
	for nm in Classes.CARD_TAGS:
		var p := Classes.card_tag_primary(String(nm))
		if p == "":
			continue
		if not by_tag.has(p):
			by_tag[p] = []
		(by_tag[p] as Array).append(String(nm))
	ok(by_tag.size() >= 4,
		"§4: the corpus supplied %d primary tags — the arms cannot be built" % by_tag.size())

	# ONE BAR PER SPEC, BUILT FROM THAT SPEC'S OWN EARNABLE POOL. A hero cannot
	# draft another spec's card, so a bar assembled out of the whole corpus is a
	# state no run reaches — and `battle.gd`'s spawn drops a foreign name
	# silently (`spec_pool_ability` returns null), which would leave the live
	# arm below driving a hero carrying nothing.
	var bars := {}
	for sp in DRIVE_ORDER:
		bars[sp] = _spec_bar(String(sp), _threshold_tag_of(String(sp)))
		ok((bars[sp] as Array).size() == 5,
			"§4: %s — no five-card single-tag bar exists in his own pool (%d)"
				% [sp, (bars[sp] as Array).size()])

	var landed := 0
	var proved := 0
	for id in UNGATED:
		var cond: Dictionary = OLD_CONDITION[id]
		var fail_bar: Array = bars.get(_spec_of(String(id)), [])
		if fail_bar.size() < 5:
			continue
		# **THE CONTROL, AND IT RUNS FIRST.** The retired predicate,
		# re-implemented from EZ §0's own arithmetic, says this bar FAILS. An
		# arm that skipped this would pass on a loadout that met the condition
		# all along and would prove nothing about the ungating.
		ok(not _old_condition_met(cond, fail_bar),
			"§4: %s — the `failing` loadout MEETS the retired condition %s; the arm proves nothing"
				% [id, cond])
		proved += 1
		var member := {"key": _class_of(id), "spec": _spec_of(id), "runes": [],
			"abilities": [], "bm_abilities": fail_bar.duplicate(),
			"bm_equipped": fail_bar.duplicate()}
		var payload: Dictionary = Runes.build(id).get("payload", {})
		var cfg := {"abilities": []}
		Talents.apply_payload(cfg, payload, 1, {"learned": {}, "member": member})
		var field := String((FIELD[id] as Array)[0])
		var want: int = int((FIELD[id] as Array)[1])
		if cfg.has(field) and int(cfg[field]) == want:
			landed += 1
		ok(cfg.has(field),
			"§4: %s — `%s` did not land on a loadout that used to refuse it" % [id, field])
		ok(cfg.get(field, 0) == want,
			"§4: %s — `%s` landed as %s, not %d" % [id, field, cfg.get(field, "<absent>"), want])
	ok(landed == 8, "§4: %d of 8 payloads landed on a failing loadout" % landed)
	ok(proved == 8, "§4: only %d of 8 arms were proved to fail the retired rule" % proved)

	# ── AND THE SAME EIGHT THROUGH A REAL SPAWN ─────────────────────────────
	#
	# **`apply_payload` IS THE DOOR, BUT IT IS NOT THE RUN.** `battle.gd`'s spawn
	# reaches it through `Run.party[i]["runes"]` with the member attached, so a
	# rune that landed in a hand-built cfg and failed to reach a real BattleUnit
	# would read exactly the same above. Every hero here wears every rune of his
	# own spec, on a bar that fails all four of the retired conditions at once.
	var seated: Array = DRIVE_ORDER.duplicate()
	seated.sort()
	ok(seated == _specs,
		"§4: the seating and the population disagree — seats %s against scopes %s"
			% [seated, _specs])
	var wear := {}
	for i in DRIVE_ORDER.size():
		var sp2 := String(DRIVE_ORDER[i])
		var mine: Array = []
		for id2 in UNGATED:
			if _spec_of(String(id2)) == sp2:
				var built: Dictionary = Runes.build(String(id2))
				built["equipped"] = true
				mine.append(built)
		var bar: Array = (bars.get(sp2, []) as Array).duplicate()
		wear[i] = {"runes": mine, "bm_abilities": bar.duplicate(),
			"bm_equipped": bar.duplicate()}
	var scene: Node = await Gate.spawn(self, DRIVE_ORDER, {"party": wear})
	var heroes: Array = scene.get("heroes")
	ok(heroes.size() >= 4, "§4: the spawn returned %d heroes" % heroes.size())
	var on_unit := 0
	for id3 in UNGATED:
		var sp3 := _spec_of(String(id3))
		var idx: int = DRIVE_ORDER.find(sp3)
		if idx < 0 or idx >= heroes.size():
			continue
		var u: BattleUnit = heroes[idx]
		var field2 := String((FIELD[id3] as Array)[0])
		var want2: int = int((FIELD[id3] as Array)[1])
		var got: int = int(u.get(field2))
		if got == want2:
			on_unit += 1
		ok(got == want2,
			"§4: %s — the live %s reads %s on `%s`, not %d" % [
				id3, sp3, got, field2, want2])
	ok(on_unit == 8,
		"§4: %d of 8 reached a live BattleUnit through the real spawn" % on_unit)
	scene.queue_free()
	await process_frame
	print("    %d payloads land on loadouts that fail the retired rule; %d reach a live unit"
		% [landed, on_unit])


# EZ §0's THRESHOLD and BREADTH, re-implemented from the arithmetic rather than
# copied from a call: `count(tag) * 2 >= n` and `peak * 3 <= n`, with FA §1's
# empty-list guard, because a bar of nothing met BOTH and is not a failing arm.
func _old_condition_met(cond: Dictionary, bar: Array) -> bool:
	if bar.is_empty():
		return false
	var census := {}
	for nm in bar:
		var p := Classes.card_tag_primary(String(nm))
		if p != "":
			census[p] = int(census.get(p, 0)) + 1
	if cond.has("tag_threshold"):
		if int(census.get(String(cond["tag_threshold"]), 0)) * 2 < bar.size():
			return false
	if bool(cond.get("tag_breadth", false)):
		var peak := 0
		for k in census:
			peak = maxi(peak, int(census[k]))
		if peak * 3 > bar.size():
			return false
	return true


# **A FIVE-CARD BAR OUT OF ONE SPEC'S OWN DRAFTABLE POOL, ALL SHARING ONE
# PRIMARY.** That is a peak of 5 of 5, so BREADTH fails; and it carries none of
# any OTHER tag, so a THRESHOLD on any other tag fails. **The stacked tag is
# chosen AGAINST that spec's own threshold rune**, so an Occultist is not handed
# the DEBUFF stack that would satisfy Deepening Hex.
# **THE POOL COMES THROUGH `Run.draft_pool_left`, THE LIVE DOOR, AND NOT OFF THE
# TWO POOL ACCESSORS.** `check_fd` §2's idiom, and `check_da` §3's rule: a gate
# that names both draft pools is hand-rolling the corpus walk and has to be
# exempted. This one asks the run what this hero can still draft, which is the
# question anyway — a bar he could not reach is a state no run produces.
func _spec_bar(spec: String, avoid: String) -> Array:
	var probe := {"key": Classes.class_of_spec(spec), "spec": spec,
		"abilities": [], "bm_abilities": [], "bm_equipped": [], "runes": []}
	var left: Dictionary = _run.draft_pool_left(probe)
	var pool: Array = []
	for src in [left.get("spec", []), left.get("class", [])]:
		for n in src:
			if not pool.has(String(n)):
				pool.append(String(n))
	for t in Classes.TAG_ORDER:
		var tag := String(t)
		if tag == avoid:
			continue
		var of_tag: Array = []
		for nm in pool:
			if Classes.card_tag_primary(String(nm)) == tag:
				of_tag.append(String(nm))
		if of_tag.size() >= 5:
			return of_tag.slice(0, 5)
	return []


# The tag the spec's own THRESHOLD rune named, off `OLD_CONDITION` rather than
# written in a second time — the two would otherwise be free to disagree.
func _threshold_tag_of(spec: String) -> String:
	for id in UNGATED:
		if _spec_of(String(id)) == spec \
				and (OLD_CONDITION[id] as Dictionary).has("tag_threshold"):
			return String((OLD_CONDITION[id] as Dictionary)["tag_threshold"])
	return ""


# `name(` with the character before it not part of an identifier — so
# `tag_threshold_met(` does not read as a call to `threshold_met`, and
# `func threshold_met(` still does (the space before `threshold_met` is not an
# identifier character, which is correct: a DEFINITION is caught by §2a).
func _names_call(body: String, name: String) -> bool:
	var needle := "%s(" % name
	var at := body.find(needle)
	while at >= 0:
		if at == 0:
			return true
		var prev := body[at - 1]
		if not (prev == "_" or (prev >= "a" and prev <= "z")
				or (prev >= "A" and prev <= "Z")
				or (prev >= "0" and prev <= "9")):
			return true
		at = body.find(needle, at + 1)
	return false


func _spec_of(id: String) -> String:
	return String(Runes.config(id).get("scope", "")).replace("spec:", "")


func _class_of(id: String) -> String:
	return Classes.class_of_spec(_spec_of(id))


func _overlay(screen: Node, z: int) -> Node:
	var found: Node = null
	for c in screen.get_children():
		if c is Control and (c as Control).z_index == z \
				and not c.is_queued_for_deletion():
			found = c
	return found


func _texts(n: Node, out: Array) -> void:
	if n is Label:
		out.append((n as Label).text)
	elif n is RichTextLabel:
		out.append((n as RichTextLabel).text)
	elif n is Button:
		out.append((n as Button).text)
	for c in n.get_children():
		_texts(c, out)


func _has_text(n: Node, needle: String) -> bool:
	var t: Array = []
	_texts(n, t)
	for x in t:
		if String(x).contains(needle):
			return true
	return false
