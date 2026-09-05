# BATCH ES — THE RUNE LAYER'S NEW SHAPE.
#
#   §1  RARITY IS GONE, as a POPULATION and as a BEHAVIOUR — no file names the
#       surface, no entry carries the key, and the offer is FLAT across zones
#   §2  SCOPE IS THE SURVIVING AXIS, and nothing was stealth-retired by it
#   §3  THE LABEL WENT AND THE COSTS STAYED — driven live, before and after
#   §4  A RUNE CAN COUNT ITS HOLDER'S EQUIPPED CARDS BY TAG, and the count
#       moves on a SWAP
#   §5  A SPLASH PAYS FOR BREADTH
#
# **WHY THIS BATCH EARNS A GATE.** A gate encodes a RULING, and ES carries
# four: rarity is removed entirely, scope is the axis that survives, the
# Scarred label goes while every cost clause stays, and a rune reads its
# holder's EQUIPPED cards. Three of those four decay silently.
#
#   §1 DECAYS SILENTLY because a tier is the easiest thing in this project to
#     re-invent: it is one dictionary and one weighted roll, and the offer
#     distribution is the only place a re-invention would show. §1 MEASURES the
#     distribution at three zone slots rather than reading the source.
#   §3 DECAYS SILENTLY AND IS THE DANGEROUS ONE. `Runes.is_cost` is what holds a
#     negative term at its authored value under the sim's power arm, and it is
#     now the ONLY thing that knows a rune charges anything — the flag that used
#     to say so is gone. A cost that stopped being recognised would be scaled by
#     the arm and the rune would become pure upside with nothing red.
#   §4 IS DS's HEADS DOWN SHAPE OUTRIGHT. A tag count that is correct in the
#     source and never recomputes on a swap passes every static check in the
#     tree, and the swap is the entire lever. **IT IS DRIVEN.**
#
# §2 is the one that does NOT encode a ruling and says so: the five universals'
# classes are the designer's and are unmade, so §2 asserts that nothing was
# retired while the decision waits, and PRINTS the depth table the decision
# needs. A gate that asserted a class would be encoding a ruling nobody made.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_es.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	seed(20260903)
	print("BATCH ES — THE RUNE LAYER'S NEW SHAPE")
	_s1_rarity_is_gone()
	_s2_scope_is_the_axis()
	_s3_costs_survived_the_label()
	_s4_tags_are_read()
	_s5_breadth()
	_g.report(self)


# ── §1 — RARITY IS GONE ─────────────────────────────────────────────────────
#
# **THE SURFACE, AS A POPULATION.** Every `.gd` in the repo is swept
# comment-stripped for any name the rarity machinery went by, and the set that
# still carries one must be EMPTY. `check_ek` §3's shape: a rule that only
# forbade the one table would be blind to a second one under a new name, so the
# list is every identifier the old machinery exported.
#
# **THE MARKS ARE JOINED AT RUNTIME, NOT HELD AS LITERALS — `check_da` §3's own
# scar, paid again on the first run of this gate.** A gate whose source contains
# its own fingerprint accuses itself, and the fix that suggests itself the
# morning after is to exempt the file, which blinds the sweep to a real
# re-invention arriving here later.
func _rarity_marks() -> Array:
	var up := "RARIT"
	var lo := "rarit"
	var sc := "SCARR" + "ED_"
	return [up + "IES", up + "Y_WEIGHTS", up + "Y_KEYS",
		lo + "y_weights", lo + "y_color", "_roll_" + lo + "y",
		sc + "PREFIX", sc + "COLOR"]

# The zone slots the offer is measured at. THREE, because the old weights were
# authored for exactly these and the formula drifted epic-ward past them.
const ZONE_SLOTS := [1, 2, 3]
const OFFER_DRAWS := 900


func _all_gd() -> Array:
	var out: Array = []
	var d := DirAccess.open("res://")
	if d == null:
		return out
	d.list_dir_begin()
	var n := d.get_next()
	while n != "":
		if n.ends_with(".gd"):
			out.append(n)
		n = d.get_next()
	d.list_dir_end()
	var sd := DirAccess.open("res://scripts")
	if sd != null:
		sd.list_dir_begin()
		var m := sd.get_next()
		while m != "":
			if m.ends_with(".gd"):
				out.append("scripts/" + m)
			m = sd.get_next()
		sd.list_dir_end()
	out.sort()
	return out


func _s1_rarity_is_gone() -> void:
	print("\n§1 — rarity is gone")
	var marks := _rarity_marks()
	var carriers: Array = []
	var walked := 0
	for path in _all_gd():
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
		if src == "":
			continue
		walked += 1
		for word in marks:
			if src.contains(String(word)):
				carriers.append("%s (%s)" % [path, word])
				break
	# **THE SWEEP ASSERTS ITS OWN POPULATION** (EA §5): a walk that read nothing
	# would report a clean tree.
	ok(walked >= 80, "§1: the rarity sweep read a real population (%d .gd files)" % walked)
	ok(carriers.is_empty(),
		"§1: no file may name the rarity surface — found %s" % [carriers])

	# **THE DATA, AND BOTH RETIRED KEYS.** A key nothing reads is a key a later
	# batch re-keys something to.
	var data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	var with_rarity: Array = []
	var with_scarred: Array = []
	for id in data:
		if (data[id] as Dictionary).has("rarity"):
			with_rarity.append(String(id))
		if (data[id] as Dictionary).has("scarred"):
			with_scarred.append(String(id))
	# **BATCH EZ: 65 -> 86.** ET §1 retired all 65 and left the pool empty; EZ
	# authors the first twenty-one under the new charter. The pin is MOVED, not
	# loosened to a `>=` — the count is what says a rune arrived or left without
	# anybody writing it down (CV's idiom, EY's `WANT_PROFILE` precedent).
	ok(data.size() == 86, "§1: the authored pool is %d entries, expected 86" % data.size())
	ok(with_rarity.is_empty(), "§1: %s still carry a `rarity` key" % [with_rarity])
	ok(with_scarred.is_empty(), "§1: %s still carry a `scarred` key" % [with_scarred])

	# **AND THE NAME IS THE AUTHORED NAME.** `display_name` prepended a tier
	# prefix or the Scarred one at eleven call sites; a survivor would put a
	# retired vocabulary back on a shop row.
	var prefixed: Array = []
	for id2 in data:
		if Runes.display_name(data[id2]) != String((data[id2] as Dictionary)["name"]):
			prefixed.append(String(id2))
	ok(prefixed.is_empty(), "§1: %s still wear a prefix" % [prefixed])

	# ── THE BEHAVIOUR, MEASURED RATHER THAN READ ──────────────────────────────
	# **THE OFFER IS FLAT ACROSS THE RUN.** This is the half a source sweep
	# cannot reach: a re-invented tier would be a new table and a new roll, and
	# the only place it shows is the distribution. The same member is drawn at
	# each of the three zone slots the old weights were authored for; the share
	# of draws that are generated stat sticks must be the SAME at all three,
	# where it used to run 50% / 33% / 21%.
	var member := {"key": "warrior", "spec": "berserker", "runes": [],
		"bm_abilities": []}
	var shares: Array = []
	for z in ZONE_SLOTS:
		var tpl := 0
		for i in OFFER_DRAWS:
			if String(Runes.generate(member, int(z)).get("id", "")).begins_with("tpl_"):
				tpl += 1
		shares.append(100.0 * tpl / OFFER_DRAWS)
	var lo: float = shares[0]
	var hi: float = shares[0]
	for sh in shares:
		lo = minf(lo, float(sh))
		hi = maxf(hi, float(sh))
	print("    stat-stick share of the offer by zone slot: %.1f%% / %.1f%% / %.1f%%" % [
		shares[0], shares[1], shares[2]])
	# A 4.5-point band over 900 draws a cell. Three EQUAL binomials at p≈0.35
	# have a standard error near 1.6 points each, so a spread past this is a
	# lever rather than noise; the OLD weights spread these by 29 points.
	ok(hi - lo < 4.5,
		"§1: the offer is not flat — the stat-stick share spans %.1f points across three zone slots" % (hi - lo))
	# **BATCH ET §2 — AND THE ARM SAYS SO WHEN IT CANNOT FAIL.** With ET §1
	# retiring every authored entry, the generated family is the whole pool and
	# the share is 100% at every slot BY CONSTRUCTION — so the flatness above is
	# arithmetic rather than evidence, and a re-invented tier could not show in
	# it. **A vacuous check prints exactly like a clean one**, so this one
	# prints which of the two it is. It wakes on its own the day a rune is
	# authored; nothing here has to be remembered or re-edited.
	if is_equal_approx(float(shares[0]), 100.0) and is_equal_approx(hi - lo, 0.0):
		print("    ^ DORMANT: the authored pool is empty (ET §1), so this is 100%"
			+ " by construction and the flatness arm cannot fail. It wakes with"
			+ " the first authored rune.")
	# AND THE ZONE ARGUMENT IS INERT RATHER THAN ABSENT, which is the claim the
	# signature makes. A parameter that had quietly started being read again
	# would show as a spread above and as a non-empty body here.
	var rsrc := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/runes.gd"))
	ok(rsrc.contains("static func generate(member: Dictionary, _zone_slot: int,"),
		"§1: `generate` still takes the zone slot as an UNREAD parameter")


# ── §2 — SCOPE IS THE SURVIVING AXIS ────────────────────────────────────────
#
# **AND THE FIVE UNIVERSALS ARE STILL REACHABLE, WHICH IS THE ASSERTION THAT
# MATTERS.** ES §2 rules that scope becomes spec-and-class only and that the
# five are RE-SCOPED, not retired — and the class each lands on is content and
# is the designer's. So the live property while that decision waits is that
# nothing was lost: `universal` still resolves, all five still roll for all
# twelve specs, and the depth table the decision needs is PRINTED.
#
# **A ONE-LINE DATA EDIT CLOSES IT AND THIS GATE SAYS SO**: the day the five
# carry a `class:` scope, the count below moves to zero and this section is the
# thing that has to be re-pointed, which is where the ruling gets recorded.
func _s2_scope_is_the_axis() -> void:
	print("\n§2 — scope is the surviving axis")
	var data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	var bands := {"universal": 0, "class": 0, "spec": 0}
	var bad: Array = []
	for id in data:
		var scope := String((data[id] as Dictionary).get("scope", "universal"))
		var band := Runes.scope_band(scope)
		bands[band] = int(bands[band]) + 1
		# EVERY scope must resolve to a band, and the two narrow bands must name
		# something real — a scope naming an unknown class or spec is a rune that
		# rolls for nobody, which is a retirement wearing an eligibility rule.
		if band == "class" and not Classes.SPEC_IDS.has(scope.trim_prefix("class:")):
			bad.append("%s -> %s" % [id, scope])
		if band == "spec":
			var found := false
			for k in Classes.SPEC_IDS:
				if Array(Classes.SPEC_IDS[k]).has(scope.trim_prefix("spec:")):
					found = true
			if not found:
				bad.append("%s -> %s" % [id, scope])
	ok(bad.is_empty(), "§2: %s name a scope nothing resolves" % [bad])
	print("    scope bands: universal %d, class %d, spec %d" % [
		int(bands["universal"]), int(bands["class"]), int(bands["spec"])])

	# THE FIVE, REACHABLE BY EVERY SPEC. Driven through the live door.
	var universals: Array = []
	for id2 in data:
		if String((data[id2] as Dictionary).get("scope", "universal")) == "universal":
			universals.append(String(id2))
	universals.sort()
	ok(universals.size() == int(bands["universal"]),
		"§2: the universal count disagrees with itself")
	# **BATCH ET §1 SUPERSEDED THE RULING THIS ARM WAS WRITTEN FOR, AND THE
	# ALARM IT WAS REALLY MAKING IS KEPT RATHER THAN DELETED.**
	#
	# ES §2 ruled the five universals were RE-SCOPED and NOT retired, so this
	# required all five to roll for all twelve specs. **ET §1 retires all 53
	# offerable entries, the five included**, and against that ruling the old
	# form fired sixty times and would have had to be deleted to get green.
	#
	# **WHAT ES §2 WAS ACTUALLY GUARDING WAS NARROWER THAN THE FORM IT TOOK: a
	# STEALTH retirement through an ELIGIBILITY RULE.** A rune made undrawable
	# by a scope that stops resolving, a class key that names nothing, or a
	# filter that quietly excludes it is a retirement nobody wrote down and
	# nobody can find. **A DECLARED retirement is the opposite of that** — it is
	# a string in the entry saying what is lost, which is the whole of ET.
	#
	# So the arm asks the question that survives both rulings: **every entry a
	# spec cannot draw must be undrawable BECAUSE IT IS RETIRED.** One that
	# falls out of `eligible_ids` for any other reason still fires, on the five
	# and on all sixty-five — which is a WIDER population than ES §2 watched,
	# not a narrower one. The day a rune is authored it is covered on arrival.
	var unreachable: Array = []
	var specs_walked := 0
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			specs_walked += 1
			var mine := {"key": String(ckey), "spec": String(spec), "runes": [],
				"bm_abilities": []}
			var ids: Array = Runes.eligible_ids(mine, [])
			for u in universals:
				if not ids.has(u) and not Runes.is_retired(u):
					unreachable.append("%s/%s" % [spec, u])
	ok(specs_walked == 12, "§2: walked %d specs, expected 12" % specs_walked)
	ok(unreachable.is_empty(),
		"§2: %s are undrawable and carry no `retired` string — a retirement wearing an eligibility rule" % [unreachable])

	# AND THE SAME QUESTION OVER THE WHOLE FILE, WHICH IS THE HALF ES §2 COULD
	# NOT ASK WHILE ONLY TWELVE ENTRIES WERE RETIRED. Every entry in scope for a
	# spec is either drawable or carries its own retirement string; nothing is
	# silently absent from the pool.
	var silent: Array = []
	for ckey3 in Classes.SPEC_IDS:
		for spec3 in Classes.SPEC_IDS[ckey3]:
			var mine3 := {"key": String(ckey3), "spec": String(spec3), "runes": [],
				"bm_abilities": []}
			var ids3: Array = Runes.eligible_ids(mine3, [])
			for id4 in data:
				var e4: Dictionary = data[id4]
				if not _in_scope(String(e4.get("scope", "universal")),
						String(ckey3), String(spec3)):
					continue
				if String(e4.get("requires_ability", "")) != "":
					continue
				if not ids3.has(String(id4)) and not Runes.is_retired(String(id4)):
					silent.append("%s/%s" % [spec3, id4])
	ok(silent.is_empty(),
		"§2: %s are in scope for a spec, are not offered, and say nothing about why" % [silent])

	# THE DEPTH TABLE THE DECISION NEEDS, PRINTED. It is a report and not an
	# assertion, because how thin a pool may get is a ruling nobody has made.
	print("    OFFERABLE DEPTH PER SPEC (empty pouch, through the live door)")
	print("      spec            total  universal  class  spec")
	for ckey2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[ckey2]:
			var mine2 := {"key": String(ckey2), "spec": String(spec2), "runes": [],
				"bm_abilities": []}
			var ids2: Array = Runes.eligible_ids(mine2, [])
			var u2 := 0
			var c2 := 0
			var s2 := 0
			for id3 in ids2:
				var sc := Runes.scope_band(String(Runes.config(String(id3)).get("scope", "")))
				if sc == "universal":
					u2 += 1
				elif sc == "class":
					c2 += 1
				else:
					s2 += 1
			print("      %-15s %-6d %-10d %-6d %d" % [spec2, ids2.size(), u2, c2, s2])


# Does this scope string admit this class/spec pair? The same three cases
# `Runes._scope_ok` reads, without needing a member dict to ask.
func _in_scope(scope: String, class_key: String, spec: String) -> bool:
	if scope.begins_with("class:"):
		return scope.trim_prefix("class:") == class_key
	if scope.begins_with("spec:"):
		return scope.trim_prefix("spec:") == spec
	return scope == "universal"

# ── §3 — THE LABEL WENT AND THE COSTS STAYED ────────────────────────────────
#
# **THE POPULATION IS DERIVED FROM `Runes.is_cost` AND PINNED AS A NAMED SET**,
# because with the flag gone that function is the only thing in the project that
# knows a rune charges anything. A count would let one entry lose its term while
# another gained one; the SET is what says which.
#
# **AND THE FLAG AND THE BEHAVIOUR HAD NEVER AGREED, WHICH IS THIS SECTION'S
# FINDING.** Both were 17 and they were different 17s — `exsanguination` was
# flagged and has no payload term to find (its cost and its promise are two
# behaviours of one field at one read site), and `anchor` carries a real
# −10 Speed and was never flagged because the old schema forbade a "scarred
# common" and it is the one common in the file. **A RARITY RULE WAS HIDING A
# COST**, and removing rarity is what surfaced it.
const COSTED := ["anchor", "bared_guard", "burning_censer", "carrion_wake",
	"glass", "hollow_chalice", "iron_promise", "killing_cold", "long_draw",
	"loosened_straps", "martyr", "reckless_channeling", "sleepless_vigil",
	"unquiet_mind", "vampiric", "white_flame", "wolfs_hunger"]

# The one whose cost is a BEHAVIOUR rather than a term. Named, never suppressed.
const COST_WITHOUT_A_TERM := "exsanguination"


func _s3_costs_survived_the_label() -> void:
	print("\n§3 — the label went, the costs stayed")
	var data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	var costed: Array = []
	for id in data:
		var pay: Dictionary = (data[id] as Dictionary).get("payload", {})
		var charges := false
		for field in pay.get("stat", {}):
			var v = pay["stat"][field]
			if (v is float or v is int) and Runes.is_cost(String(field), float(v)):
				charges = true
		for field2 in pay.get("add", {}):
			var v2 = pay["add"][field2]
			if (v2 is float or v2 is int) and float(v2) < 0.0 \
					and not Runes.INVERTED_AB_FIELDS.has(String(field2)):
				charges = true
		if charges:
			costed.append(String(id))
	costed.sort()
	ok(costed == COSTED,
		"§3: the costed set is %s, not the recorded %s" % [costed, COSTED])
	ok(data.has(COST_WITHOUT_A_TERM) and not costed.has(COST_WITHOUT_A_TERM),
		"§3: `%s` is the named exception — a cost that is a behaviour, not a term" % COST_WITHOUT_A_TERM)

	# ── THE BEHAVIOUR, DRIVEN ON A REAL HERO ─────────────────────────────────
	# **A COST CLAUSE THAT STOPPED BEING RECOGNISED IS A RUNE THAT QUIETLY BECAME
	# PURE UPSIDE.** Measured through `scale_payload` at the arm's own multiplier:
	# the UPSIDE must move and the COST must not, on an entry of each shape.
	#   glass  — a POSITIVE number that IS the cost (`dmg_taken_bonus`)
	#   anchor — a NEGATIVE number on an ordinary field (`speed`), and the entry
	#            the old flag never covered
	for pair in [["glass", "crit_bonus", "dmg_taken_bonus"],
			["anchor", "armor", "speed"]]:
		var id3 := String(pair[0])
		var base: Dictionary = Runes.build(id3)["payload"]["stat"]
		var big: Dictionary = Runes.scale_payload(
			Runes.build(id3)["payload"], 3.0)["stat"]
		var up := String(pair[1])
		var cost := String(pair[2])
		ok(not is_equal_approx(float(base[up]), float(big[up])),
			"§3: %s's upside (%s) did not move under the arm" % [id3, up])
		ok(is_equal_approx(float(base[cost]), float(big[cost])),
			"§3: %s's COST (%s) was scaled — it became pure upside (%s -> %s)" % [
				id3, cost, base[cost], big[cost]])
	# AND ON A LIVE UNIT, because a payload that is right and never lands is the
	# same defect one layer down. The cost must reach the hero's own field.
	var cfg: Dictionary = Classes.hero_config("warrior")
	Talents.apply_payload(cfg, Runes.build("anchor")["payload"], 1, {})
	ok(is_equal_approx(float(cfg.get("speed", 0.0)) + 10.0,
			float(Classes.hero_config("warrior").get("speed", 0.0))),
		"§3: the Anchor Rune's −10 Speed did not land on a real hero config")


# ── §4 — A RUNE CAN COUNT ITS HOLDER'S EQUIPPED CARDS BY TAG ────────────────
#
# **DRIVEN, BECAUSE THIS IS DS's HEADS DOWN SHAPE.** A count that is correct in
# the source and never recomputes when the loadout moves passes every static
# check in the tree, and the swap is the entire lever the design rests on. Every
# assertion below reads the count through the same door a rune would.
func _s4_tags_are_read() -> void:
	print("\n§4 — the tag count, driven live")
	var run: Node = root.get_node("/root/Run")

	# (1) THE LIST IS THE FIGHT'S LIST. A census taken over names the spawn does
	# not use is a number about nothing, so the spawn's own non-earned kit is
	# re-derived for all twelve and required to be `protected_names` name for
	# name — the half `loadout_ability_names` contributes before anything is
	# drafted.
	var mismatched: Array = []
	for ckey in Classes.SPEC_IDS:
		for spec in Classes.SPEC_IDS[ckey]:
			var cfg: Dictionary = Classes.hero_config(String(ckey))
			cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(String(spec))
			Classes.apply_kit_overrides(cfg, String(spec))
			var spawned := {}
			for ab in cfg["abilities"]:
				spawned[ab.display_name] = true
			var prot := {}
			for n in Classes.protected_names(String(spec)):
				prot[String(n)] = true
			if spawned.keys().size() != prot.keys().size():
				mismatched.append(String(spec))
				continue
			for k in spawned:
				if not prot.has(k):
					mismatched.append(String(spec))
					break
	ok(mismatched.is_empty(),
		"§4: %s — the spawn's kit and `protected_names` disagree, so the census counts the wrong cards" % [mismatched])

	# (2) THE CORE BASELINE, PRINTED EVERY RUN. **A THRESHOLD'S MAGNITUDE HAS TO
	# BE CHOSEN AGAINST THIS TABLE OR IT IS ON FROM THE FIRST FIGHT AND NO SWAP
	# CAN TURN IT OFF** — the flat increment the equipped/owned distinction exists
	# to avoid, arriving through the cores instead of through the pool. It is a
	# REPORT: what a rune may ask for is content and is the designer's.
	print("    CORE-KIT TAG CENSUS PER SPEC — the baseline before a card is drafted")
	var hdr := "      spec           "
	for t in Classes.TAG_ORDER:
		hdr += String(t).substr(0, 4).rpad(6)
	print(hdr + "cards breadth")
	var met_at_two := {}
	for t2 in Classes.TAG_ORDER:
		met_at_two[String(t2)] = 0
	for ckey2 in Classes.SPEC_IDS:
		for spec2 in Classes.SPEC_IDS[ckey2]:
			var names: Array = Classes.protected_names(String(spec2))
			var census: Dictionary = Classes.tag_census(names)
			var line := "      %-15s" % spec2
			for t3 in Classes.TAG_ORDER:
				line += ("%d" % int(census[String(t3)])).rpad(6)
				if int(census[String(t3)]) >= 2:
					met_at_two[String(t3)] = int(met_at_two[String(t3)]) + 1
			print(line + "%-6d%d" % [names.size(), Classes.tag_breadth(names)])
	var summary: Array = []
	for t4 in Classes.TAG_ORDER:
		summary.append("%s %d" % [t4, int(met_at_two[String(t4)])])
	print("    specs meeting a 2+ threshold on the CORE KIT ALONE, of 12:  %s"
		% "  ".join(summary))

	# (3) THE CENSUS IS COMPLETE AND ITS ZEROS ARE REAL. A census that omitted an
	# absent tag would make "you hold none of this" indistinguishable from "this
	# tag was retired", which is what a threshold's off-state has to say.
	var empty: Dictionary = Classes.tag_census([])
	ok(empty.size() == Classes.TAG_ORDER.size(),
		"§4: an empty census has %d rows against %d tags" % [
			empty.size(), Classes.TAG_ORDER.size()])
	var all_zero := true
	for t5 in Classes.TAG_ORDER:
		if int(empty[String(t5)]) != 0:
			all_zero = false
	ok(all_zero, "§4: an empty loadout does not census to zero")
	ok(Classes.tag_breadth([]) == 0, "§4: an empty loadout has non-zero breadth")

	# (4) BOTH TAGS ON A CARD COUNT. Counting the primary alone would make every
	# secondary decorative, which is the opposite of why the secondary exists.
	var two_tagged := ""
	for nm in Classes.CARD_TAGS:
		if Array(Classes.CARD_TAGS[nm]).size() == 2:
			two_tagged = String(nm)
			break
	ok(two_tagged != "", "§4: no two-tag card in the table to measure against")
	if two_tagged != "":
		var pair: Array = Classes.card_tags(two_tagged)
		ok(Classes.tag_count([two_tagged], String(pair[0])) == 1
				and Classes.tag_count([two_tagged], String(pair[1])) == 1,
			"§4: '%s' carries %s but does not count on both" % [two_tagged, pair])
		ok(Classes.tag_breadth([two_tagged]) == 2,
			"§4: a two-tag card reads breadth %d" % Classes.tag_breadth([two_tagged]))

	# ── (5) THE SWAP, DRIVEN THROUGH THE REAL DOORS ──────────────────────────
	# **THE COUNT MUST MOVE BY EXACTLY THE SWAPPED CARD'S OWN TAGS, IN BOTH
	# DIRECTIONS.** A cached count would read the same before and after; a count
	# that recomputed off the POOL rather than the LOADOUT would also read the
	# same, which is the specific defect §4 rules against. Both fail here.
	run.sim_run = true
	run.new_run(["warrior", "mage", "cleric", "hunter"])
	for i in run.party.size():
		run.party[i]["spec"] = ["berserker", "cryomancer", "inquisitor",
			"beastmaster"][i]
	run.specs_chosen = true
	var m: Dictionary = run.party[0]
	var spec3 := String(m["spec"])
	# A card with at least one tag, taken off the hero's own draft pool so the
	# swap is one a player could actually make.
	var card := ""
	for n2 in Classes.spec_draft_pool(spec3):
		if not Classes.card_tags(String(n2)).is_empty():
			card = String(n2)
			break
	ok(card != "", "§4: no tagged card in the %s draft pool to swap" % spec3)
	run.hold_ability(m, card, true)
	var carried: Dictionary = Classes.tag_census(run.loadout_ability_names(m))
	ok(run.loadout_ability_names(m).has(card),
		"§4: the carried card is not in the loadout list")

	run.unequip_earned_ability(m, card)
	var benched: Dictionary = Classes.tag_census(run.loadout_ability_names(m))
	ok(not run.loadout_ability_names(m).has(card),
		"§4: a BENCHED card is still in the loadout list")
	ok(run.earned_ability_names(m).has(card),
		"§4: benching removed the card from the POOL — a bench is not a drop")

	var moved: Array = []
	for t6 in Classes.TAG_ORDER:
		var d: int = int(carried[String(t6)]) - int(benched[String(t6)])
		if d != 0:
			moved.append("%s %+d" % [t6, d])
	var expect: Array = []
	for t7 in Classes.card_tags(card):
		expect.append("%s +1" % t7)
	ok(moved == expect,
		"§4: benching '%s' (%s) moved the census by %s, expected %s" % [
			card, Classes.card_tags(card), moved, expect])

	run.equip_earned_ability(m, card)
	var again: Dictionary = Classes.tag_census(run.loadout_ability_names(m))
	ok(again == carried,
		"§4: carrying '%s' again did not restore the census" % card)
	print("    swap drive: '%s' %s — census moved %s and came back" % [
		card, Classes.card_tags(card), moved])

	# ── (6) THE TWO SHAPES A RUNE ASKS THROUGH ──────────────────────────────
	# The predicates, on the loadout that is standing. A threshold at the live
	# count must be MET and one above it must not, in both directions, so a
	# predicate wired to a constant fails here.
	var lo_names: Array = run.loadout_ability_names(m)
	var live: Dictionary = Classes.tag_census(lo_names)
	var probe := ""
	for t8 in Classes.TAG_ORDER:
		if int(live[String(t8)]) > 0:
			probe = String(t8)
			break
	ok(probe != "", "§4: the standing loadout carries no tag at all")
	if probe != "":
		var n3: int = int(live[probe])
		ok(Runes.tag_threshold_met(lo_names, probe, n3),
			"§4: a threshold AT the live count (%s %d) is not met" % [probe, n3])
		ok(not Runes.tag_threshold_met(lo_names, probe, n3 + 1),
			"§4: a threshold ABOVE the live count (%s %d) reads as met" % [probe, n3 + 1])
	ok(not Runes.tag_threshold_met(lo_names, "NOT_A_TAG", 1),
		"§4: a threshold on a word that is not a tag reads as met")


# ── §5 — A SPLASH PAYS FOR BREADTH ──────────────────────────────────────────
#
# **THE MACHINERY, AND NOT ONE SPLASH IS AUTHORED.** ES §5 redefines the
# category: a normal rune pays for DEPTH in one tag, a splash for BREADTH across
# tags. The live census of what a splash IS today is PRINTED — that is a report,
# because which specs should have one is content.
func _s5_breadth() -> void:
	print("\n§5 — a splash pays for breadth")
	var data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://data/runes.json"))
	# ── BATCH EZ RE-POINTED THIS DERIVATION AND THE OLD ONE WAS STALE, NOT
	# BROKEN ────────────────────────────────────────────────────────────────
	# **A SPLASH USED TO BE "A SPEC RUNE WITH NO `lane`"**, which was exact
	# while every authored rune carried a lane: the old rule was one rune per
	# talent lane PLUS ONE SPLASH, so the empty field WAS the splash. ES §5
	# severed the lane rule, and **EZ's twenty-one carry no `lane` at all** —
	# under the old derivation all twenty-one read as splashes and the count
	# went 12 -> 33. The gate was reporting the absence of a retired field.
	#
	# **THE NEW DERIVATION IS ES §5's OWN DEFINITION: A SPLASH PAYS FOR
	# BREADTH.** It reads `RUNE_SHAPES`' secondary, which is the axis EZ §0
	# authors, so the two halves of "what a splash is" can never disagree again.
	# The RETIRED population keeps the `lane` reading, because that is the rule
	# those entries were authored under and re-deriving them under a rule they
	# never saw would be inventing history.
	var live: Array = []
	var retired: Array = []
	for id in data:
		var e: Dictionary = data[id]
		if not String(e.get("scope", "")).begins_with("spec:"):
			continue
		if String(e.get("retired", "")) != "":
			if String(e.get("lane", "")) != "":
				continue
			retired.append(String(e["scope"]).trim_prefix("spec:"))
		else:
			if not (Runes.rune_shape(String(id)) as Array).has("BREADTH"):
				continue
			live.append(String(e["scope"]).trim_prefix("spec:"))
	live.sort()
	retired.sort()
	ok(retired.size() == 12,
		"§5: %d retired splashes, expected one per spec" % retired.size())
	# **THE LIVE COUNT IS PRINTED AND FLOORED, NOT PINNED.** Which specs get a
	# splash is CONTENT and is the designer's; four specs are authored and eight
	# are not, so an equality here would go red on the next authoring batch for
	# doing exactly the right thing. The floor is what stops the shape going
	# quietly extinct.
	ok(live.size() >= 4,
		"§5: %d live splashes — the BREADTH shape has gone extinct" % live.size())
	print("    splashes: %d live (%s)" % [live.size(), ", ".join(live)])
	print("    splashes: %d retired (%s)" % [retired.size(), ", ".join(retired)])

	# THE PREDICATE, on a list whose breadth is known by construction. Both
	# directions, so a `breadth_met` wired to true fails here.
	var one_of_each: Array = []
	for t in Classes.TAG_ORDER:
		for nm in Classes.CARD_TAGS:
			if Array(Classes.CARD_TAGS[nm]).size() == 1 \
					and String(Array(Classes.CARD_TAGS[nm])[0]) == String(t):
				one_of_each.append(String(nm))
				break
	var want: int = one_of_each.size()
	ok(want >= 3, "§5: only %d tags have a single-tag card to build a probe from" % want)
	ok(Classes.tag_breadth(one_of_each) == want,
		"§5: %d single-tag cards read breadth %d" % [
			want, Classes.tag_breadth(one_of_each)])
	ok(Runes.breadth_met(one_of_each, want),
		"§5: a breadth test AT the live spread is not met")
	ok(not Runes.breadth_met(one_of_each, want + 1),
		"§5: a breadth test ABOVE the live spread reads as met")
	ok(not Runes.breadth_met([], 1), "§5: an empty loadout meets a breadth test")
