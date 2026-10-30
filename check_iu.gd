# BATCH IU — THE CLAIMS, THE RULES AGAINST THEIR GATES, AND WHAT IT's RULINGS NEEDED.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS.
#   §1   THE CLAIMS: every one IU's census read carries a disposition; a repaired claim's false words are gone from its
#        file, and its true ones are found; a measurement repaired to the past tense names its batch; and the claims left
#        standing are a CEILING that does not rise (the live claims in dead names are `check_hx` §1d(c)'s ceiling).
#   §2   THE RULES AGAINST THEIR GATES: the census of record parses whole, every block of `CLAUDE.md` has a row, every
#        row's words stand in `CLAUDE.md`, and every HELD or PARTLY row names a gate whose own source holds its needle.
#   §3   THE NINE CONSTANTS: each holds the figure its card states — the card reads it through its door, the cast applies
#        exactly it (driven), no `+ 1` stands beside it, and its declaration names its card and never its figure.
#   §4   THE BOT's SWAP: one builder prices a swap for the player's picker and the bot alike, at the player's price, and
#        the bot at capacity is driven onto it; (b) the divergence census of record sorts every row, and every RULE row
#        is repaired or owed where the owed things are named.
#   §5   THE POSITIONAL CENSUS's STANDING ROWS: a ceiling that does not rise, and each row stamped with its target, so a
#        batch that touches a target carrying a MISSES row repairs the row (or this reds).
#   §6   THE MANIFEST's PIN COUNT IS A FLOOR: the pins the manifest holds are not fewer than the floor it records, and
#        every fall the record carries names its batch and its reason.
#   §7   A BARE PROBE IS A LANE: `lane.sh probe` names a probe inside a spent pattern and refuses a file of the game's,
#        and the user-data folders outside every spent pattern are the live one and the named strays — no new one.
#   §8   THE ROUTING IS A STEP: the last batch's routing of record stands, with its subjects, the rows the triggers
#        matched (each a block the state file or its archive carries), the core, the three lists — every miss with
#        ROUTED or NOT ROUTED — and the upkeep as a rate.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** §1 holds the claims IU's census read and the ceiling on the ones left; a NEW
# false claim that names only live things is not mechanically visible — it reds here only once a batch records it (and
# recording one raises the count past the ceiling), or `check_hx` §1d once it names a dead thing in a rule file. §2's
# HELD reads a gate's needle, not that the gate's assertion is sound, and its anchors are its tree's. §7 reads the
# folders on this machine; a probe whose name happens to fall inside a spent pattern is indistinguishable from one made
# by the driver. §8 holds the routing record's shape, never that its rows were read.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_iu.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _docs := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IU — THE CLAIMS, THE RULES AGAINST THEIR GATES, AND WHAT IT's RULINGS NEEDED")
	_s0_the_rulings()
	_s1_the_claims()
	_s2_the_rules_census()
	await _s3_the_nine()
	await _s4_the_swap()
	_s4b_the_divergence_census()
	_s5_the_standing_misses()
	_s6_the_pin_floor()
	_s7_the_bare_probe()
	_s8_the_routing()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# A FILE READ ONCE, BY ITS FULL `res://` PATH — the path written at the call, so `build_pin_manifest.py` binds the holder
# off its initializer and every needle asserted against it is a pin (IU §6: a helper that holds a needle is taught).
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


# A TSV of record, its header the first line: an array of {column: value}, or empty if it does not parse whole.
func _tsv(path: String, need: Array) -> Array:
	var lines := _doc("res://" + path).split("\n", false)
	ok(lines.size() > 1, "%s is not in the tree" % path)
	if lines.size() < 2:
		return []
	var head := lines[0].split("\t")
	for c in need:
		ok(head.has(c), "%s has no '%s' column" % [path, c])
	var out: Array = []
	var bad := 0
	for k in range(1, lines.size()):
		var f := lines[k].split("\t")
		if f.size() != head.size():
			bad += 1
			continue
		var row := {}
		for i in head.size():
			row[String(head[i])] = String(f[i])
		out.append(row)
	ok(bad == 0, "%s: %d rows do not carry every column" % [path, bad])
	return out


# ── §0 — THE RULINGS, EACH WHERE A FUTURE SESSION READS IT ─────────────────────
# Each needle is the ruling's own words, never its provenance (EA §2), in the file whose subject it binds — asserted
# against a holder bound by its path, so each is a pin `check_ed` re-resolves.
func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var cm := _doc("res://CLAUDE.md")
	var ir := _doc("res://docs/instrument-rules.md")
	var st := _doc("res://docs/state.md")
	ok(cm.contains("A CONSTANT A TEXT READS HOLDS THE FIGURE THE TEXT STATES"),
		"§0.1: CLAUDE.md does not carry the nine's ruling — a constant a text reads holds the figure the text states")
	ok(cm.contains("BETWEEN A CONSTANT AND ITS TEXT IS A SECOND COPY OF ONE RULE"),
		"§0.1: CLAUDE.md does not say why — every `+ 1` between a constant and its text is a second copy of one rule")
	ok(cm.contains("THE BOT MAY PLAY WORSE THAN A PLAYER. IT MAY NOT PLAY BY DIFFERENT RULES"),
		"§0.2: CLAUDE.md does not carry the swap price's ruling — the bot may play worse, never by different rules")
	ok(ir.contains("THE CENSUS's MISSES COUNT IS A CEILING THAT DOES NOT RISE"),
		"§0.3: the instrument rules do not hold the positional census's MISSES count to a ceiling")
	ok(ir.contains("TOUCHES A TARGET CARRYING A MISSES ROW REPAIRS THAT ROW"),
		"§0.3: the instrument rules do not say a batch touching a MISSES row's target repairs the row")
	ok(cm.contains("RE-TUNES GETS A CONSTANT THEN"),
		"§0.4: CLAUDE.md does not say a pinned figure gets its constant when it is re-tuned")
	ok(st.contains("THE INDEX DOES NOT BOUND THE READ. IT MAKES THE BOUNDING CORRECT"),
		"§0.5: docs/state.md's index does not say what the pilot is for — making the bounding correct")
	ok(st.contains("THE ROUTING IS A STEP WITH A WRITTEN OUTPUT"),
		"§0.5: docs/state.md's index does not make the routing a step with a written output")
	ok(ir.contains("A NEW STALE CLAIM IS A RED, NOT A ROW IN A CENSUS"),
		"§1b: the instrument rules do not carry the claims ratchet")
	ok(ir.contains("A COVERAGE LOSS IS INVISIBLE TO THE INSTRUMENT THAT MEASURES COVERAGE"),
		"§6: the instrument rules do not say why the manifest's count is a floor")
	ok(ir.contains("A RULE WITH NO AFFORDANCE FOR A THING A BATCH NEEDS GETS BROKEN"),
		"§7: the instrument rules do not carry the bare probe's ruling")


# ── §1 — THE CLAIMS ───────────────────────────────────────────────────────────
# THE LEDGER OF RECORD: every claim IU's census read (HX's standing claims as IR recounted them, IQ's two, IT's 24, IS's
# readers' notes and the census's own), each with a disposition. A REPAIRED row carries the false words that must not
# stand again (`gone`) and the true ones the repair wrote (`stands`); a STANDS row the claim's own words and the ruling it
# waits on. The arms are absences — the false words gone — and the positive arm beside them is that the repaired words
# are found, so a reader that stopped opening the files is not read as a clean one.
const LEDGER := "docs/reports/IU-claims.tsv"
const DISPOSITIONS := ["REPAIRED", "TRUE", "STANDS", "SUPERSEDED"]
const KINDS := ["FALSE", "MEASUREMENT", "GONE-SUBJECT", "COPY", "POPULATION", "COUNT-GREW", "INCOMPLETE", "DECISION", "TRUE"]
# THE CLAIMS LEFT STANDING, each waiting on a ruling its row names: a ceiling that does not rise. BATCH IV §4 repaired
# three on the designer's rulings (IR01, IR09, IR50), and IW §0.1 the two GK's names waited on (ISN04, ISF12), so it
# stands at zero.
const CLAIMS_CEILING := 0
# How many repaired rows' words must be found for the arm to be reading the files at all — below the count IU left,
# because a later batch may rewrite a repaired sentence again (that is not a red; putting the false words back is).
const LOCATED_FLOOR := 120


func _unesc(s: String) -> String:
	return s.replace("\\n", "\n")


func _s1_the_claims() -> void:
	print("\n§1 — the claims: a disposition each, the false words gone, the remainder a ceiling")
	var rows := _tsv(LEDGER, ["id", "file", "kind", "disposition", "by", "stands", "gone", "waits_on", "tree"])
	ok(rows.size() >= 193, "§1: the ledger holds %d claims — IU's census read 193" % rows.size())
	var ids := {}
	for r in rows:
		ids[String(r["id"])] = r
	var undisposed: Array = []
	var back: Array = []
	var present: Array = []
	var no_batch: Array = []
	var dangling: Array = []
	var standing: Array = []
	var waits_none: Array = []
	var stands_gone: Array = []
	var located := 0
	var repaired := 0
	# A BATCH NAMED: a code cited as one — `EB §3`, `FH's`, `at EC` — in the repaired words or the sentences just before
	# them (a bare two-capital word is a caps word as often as a code: `IT`, `IS`).
	var batch := RegEx.new()
	batch.compile("\\b[A-Z]{2}(?: §\\d|'s\\b)|\\b(?:at|At|AT|since|by|until|Batch|BATCH|in) [A-Z]{2}\\b")
	for r in rows:
		var cid := String(r["id"])
		var d := String(r["disposition"])
		var k := String(r["kind"])
		var f := String(r["file"])
		if not DISPOSITIONS.has(d) or not KINDS.has(k):
			undisposed.append(cid)
			continue
		var txt := _doc("res://" + f)
		var gone := _unesc(String(r["gone"]))
		var stands := _unesc(String(r["stands"]))
		var by := String(r["by"])
		if d == "REPAIRED":
			repaired += 1
			if gone != "" and txt.contains(gone):
				(present if k == "MEASUREMENT" else back).append("%s (%s)" % [cid, f])
			if stands != "" and txt.contains(stands):
				located += 1
			var here := txt.find(stands) if stands != "" else -1
			if k == "MEASUREMENT" and here >= 0 and batch.search(txt.substr(maxi(here - 600, 0), mini(here, 600) + stands.length())) == null:
				no_batch.append(cid)
			if by != "" and String((ids.get(by, {}) as Dictionary).get("disposition", "")) != "REPAIRED":
				dangling.append(cid)
		elif d == "STANDS":
			standing.append(cid)
			if String(r["waits_on"]).strip_edges() == "":
				waits_none.append(cid)
			if stands == "" or not txt.contains(stands):
				stands_gone.append(cid)
		elif d == "SUPERSEDED":
			if not ids.has(by) or String(ids[by]["disposition"]) != "REPAIRED":
				dangling.append(cid)
	ok(undisposed.is_empty(), "§1: %d claims carry no disposition, or a kind §1a does not name: %s" % [undisposed.size(), str(undisposed)])
	ok(back.is_empty(),
		"§1: %d repaired claims' false words stand in their file again — a repair put back: %s" % [back.size(), str(back)])
	ok(present.is_empty(),
		"§1a: %d measurements stand in the present tense again — a batch's figure is written in the past tense with its batch named: %s" % [present.size(), str(present)])
	ok(no_batch.is_empty(), "§1a: %d measurements were repaired with no batch named: %s" % [no_batch.size(), str(no_batch)])
	ok(dangling.is_empty(), "§1: %d rows point at a row that is not repaired: %s" % [dangling.size(), str(dangling)])
	ok(located >= LOCATED_FLOOR,
		"§1: only %d of %d repaired claims' true words are found in their files — the arm has stopped reading them" % [located, repaired])
	ok(waits_none.is_empty(), "§1: %d standing claims name no ruling they wait on: %s" % [waits_none.size(), str(waits_none)])
	ok(stands_gone.is_empty(),
		"§1: %d standing claims are gone from their file — a batch repaired one: write its row's disposition: %s" % [stands_gone.size(), str(stands_gone)])
	ok(standing.size() <= CLAIMS_CEILING,
		"§1b: %d claims stand against a ceiling of %d — a ceiling that does not rise: %s" % [standing.size(), CLAIMS_CEILING, str(standing)])
	print("    CHECKED %d claims: %d repaired (%d of them located), %d standing (ceiling %d)" % [
		rows.size(), repaired, located, standing.size(), CLAIMS_CEILING])


# ── §2 — THE RULES AGAINST THEIR GATES ────────────────────────────────────────
# THE CENSUS OF RECORD (ID §0.6): one row a rule, its block named by `check_hx` §1c's own key, so the population is
# that gate's and not a second list. A block `check_hx` knows and this census has no row for is a block whose rules
# were never read against a gate; a HELD or PARTLY row whose gate's source does not hold the row's needle is a rule
# given a gate it does not have. The anchors are the census's tree's (HEAD before IU); they are counted, not each
# asserted, because a census of record reads at its tree.
const RULES_CENSUS := "docs/reports/IU-rules-census.tsv"
const VERDICTS := ["HELD", "PARTLY", "NONE", "NO-RULE"]
const ANCHOR_FLOOR := 700


func _s2_the_rules_census() -> void:
	print("\n§2 — the rules against their gates: a row a rule, every block read, every HELD held")
	var rows := _tsv(RULES_CENSUS, ["id", "block_key", "anchor", "gate", "section", "needle", "verdict", "cheap", "tree"])
	ok(rows.size() >= 817, "§2: the census holds %d rules — IU's read 817" % rows.size())
	var known: Array = (load("res://check_hx.gd") as Script).get_script_constant_map().get("KNOWN_BLOCKS", [])
	ok(known.size() >= 100, "§2: check_hx's KNOWN_BLOCKS read back %d blocks — the population has broken" % known.size())
	var cm := _flat(_doc("res://CLAUDE.md"))
	var by_block := {}
	var bad: Array = []
	var no_block: Array = []
	var unheld: Array = []
	var tally := {}
	var anchored := 0
	var cheap := 0
	for r in rows:
		var cid := String(r["id"])
		var v := String(r["verdict"])
		var key := String(r["block_key"])
		by_block[key] = true
		tally[v] = int(tally.get(v, 0)) + 1
		if not VERDICTS.has(v) or String(r["tree"]).strip_edges() == "":
			bad.append(cid)
		if not known.has(key):
			no_block.append("%s (%s)" % [cid, key.left(40)])
		if v == "HELD" or v == "PARTLY":
			var src := _doc("res://" + String(r["gate"]))
			if src == "" or String(r["needle"]) == "" or not src.contains(_unesc(String(r["needle"]))):
				unheld.append("%s → %s" % [cid, r["gate"]])
		elif v == "NONE" and String(r["gate"]) != "NONE":
			bad.append(cid)
		if (v == "NONE" or v == "PARTLY") and String(r["cheap"]).begins_with("YES"):
			cheap += 1
		if cm.contains(_flat(_unesc(String(r["anchor"])))):
			anchored += 1
	var rowless: Array = known.filter(func(b): return not by_block.has(b))
	ok(bad.is_empty(), "§2: %d rows carry no verdict §2 names, no tree, or a NONE naming a gate: %s" % [bad.size(), str(bad)])
	ok(rowless.is_empty(),
		"§2: %d blocks of CLAUDE.md have no row — their rules were never read against a gate: %s" % [rowless.size(), str(rowless)])
	ok(no_block.is_empty(),
		"§2: %d rows name a block CLAUDE.md no longer has — re-read them against what replaced it: %s" % [no_block.size(), str(no_block.slice(0, 5))])
	ok(unheld.is_empty(),
		"§2: %d rows say a gate holds the rule and that gate's source does not hold the row's needle — a rule given a gate it does not have: %s" % [unheld.size(), str(unheld.slice(0, 6))])
	ok(anchored >= ANCHOR_FLOOR,
		"§2: only %d of %d rules' words are found in CLAUDE.md — the census no longer reads the file it records" % [anchored, rows.size()])
	print("    CHECKED %d rules over %d blocks: HELD %d, PARTLY %d, NONE %d, NO-RULE %d; %d of the PARTLY and NONE a gate could cheaply hold; %d anchors found" % [
		rows.size(), known.size(), tally.get("HELD", 0), tally.get("PARTLY", 0), tally.get("NONE", 0), tally.get("NO-RULE", 0), cheap, anchored])


# ── §4 (the census) — EVERY PLACE THE BOT's RULES DIFFER FROM THE PLAYER's ─────
# Kept so the third one is not found by accident: one row each, sorted POLICY (the bot choosing) or RULE (the bot
# playing a different game), MODEL (the bot standing in for the player's hands) or CLOSED. Every RULE is a defect —
# repaired, or owed and named where the owed things are; every POLICY carries its reason.
const DIVERGENCE := "docs/reports/IU-bot-divergence.tsv"


func _s4b_the_divergence_census() -> void:
	print("\n§4b — the divergence census: every RULE a defect, every POLICY its reason")
	var rows := _tsv(DIVERGENCE, ["id", "sort", "reason", "iu_disposition", "tree"])
	ok(rows.size() >= 33, "§4b: the census holds %d rows — IU's read 33" % rows.size())
	var state := _doc("res://docs/state.md")
	var unsorted: Array = []
	var loose: Array = []
	var unnamed: Array = []
	var reasonless: Array = []
	var tally := {}
	for r in rows:
		var cid := String(r["id"])
		var s := String(r["sort"])
		var d := String(r["iu_disposition"])
		tally[s] = int(tally.get(s, 0)) + 1
		if not ["POLICY", "RULE", "MODEL", "CLOSED"].has(s):
			unsorted.append(cid)
		if s == "RULE":
			if d.begins_with("OWED"):
				if not state.contains(cid):
					unnamed.append(cid)
			elif not d.begins_with("REPAIRED AT"):
				loose.append(cid)
		if s == "POLICY" and String(r["reason"]).strip_edges().length() < 20:
			reasonless.append(cid)
	ok(unsorted.is_empty(), "§4b: %d rows are sorted neither POLICY, RULE, MODEL nor CLOSED: %s" % [unsorted.size(), str(unsorted)])
	ok(loose.is_empty(), "§4b: %d RULE rows are neither repaired nor owed — a bot playing a different game with nobody owing it: %s" % [loose.size(), str(loose)])
	ok(unnamed.is_empty(), "§4b: %d owed RULE rows are not named in docs/state.md: %s" % [unnamed.size(), str(unnamed)])
	ok(reasonless.is_empty(), "§4b: %d POLICY rows carry no reason: %s" % [reasonless.size(), str(reasonless)])
	print("    CHECKED %d rows: RULE %d, POLICY %d, MODEL %d, CLOSED %d" % [rows.size(), tally.get("RULE", 0), tally.get("POLICY", 0), tally.get("MODEL", 0), tally.get("CLOSED", 0)])


# ── §3 — THE NINE ─────────────────────────────────────────────────────────────
# Each: the constant, its card, the card text's door form (a number read through a token, or a word the card types),
# the cast to drive, and where the applied figure lands. A card text that typed a figure no constant could hold was the
# shape — each constant held one less than its card and the difference was added at the apply (IT's finding). Re-valued
# at IU, so the text reads the constant and the cast applies it bare.
const NINE := [
	["SLOW_BURN_TURNS", "Slow Burn", "desc", "status_enemies", "slow_burn"],
	["HOARFROST_TURNS", "Hoarfrost Armor", "desc", "status_self", "rimeguard"],
	["FROSTBIND_TURNS", "Frostbind", "desc", "status_two_enemies", "frostbind"],
	["RESONANT_FIELD_TURNS", "Resonant Field", "desc", "status_allies", "resonant_field"],
	["EMBERKEEP_TURNS", "Emberkeep", "desc", "status_self", "emberkeep"],
	["PRECISION_GRANT_TURNS", "Precision Strike", "desc", "precision", "good"],
	["PRECISION_PERFECT_GRANT_TURNS", "Precision Strike", "perfect", "precision", "perfect"],
	["BERSERK_STRIKES", "Berserk", "desc", "berserk", ""],
	["MANTLE_HOPS", "Mantle", "word:three", "mantle", ""],
]


func _s3_the_nine() -> void:
	print("\n§3 — the nine constants: each holds the figure its card states")
	var consts := (load("res://scripts/battle.gd") as Script).get_script_constant_map()
	var battle_src := Gate.strip_comments(_doc("res://scripts/battle.gd"))
	var raw := _doc("res://scripts/battle.gd")
	var classes_src := _doc("res://scripts/classes.gd")
	var drove := 0
	var scene: Node = await Gate.spawn(self, ["swordmaster", "pyromancer", "inquisitor", "beastmaster"], {"deterministic": true})
	var heroes: Array = scene.get("heroes")
	var enemies: Array = scene.get("enemies")
	for row in NINE:
		var cname: String = row[0]
		var card: String = row[1]
		var form: String = row[2]
		ok(consts.has(cname), "§3: battle.gd declares no %s" % cname)
		if not consts.has(cname):
			continue
		var v := int(consts[cname])
		# THE DOOR: the card's text names its figure through the constant, and the text a player reads states it.
		var ab: Ability = Classes.pool_ability(card)
		ok(ab != null, "§3: %s resolves to no card" % card)
		if ab == null:
			continue
		if form.begins_with("word:"):
			var w := form.substr(5)
			ok(ab.description.contains(w + " times") and v == {"three": 3, "four": 4, "two": 2}[w],
				"§3: %s's card says '%s times' and %s holds %d — a word the card types is the constant's figure" % [card, w, cname, v])
		else:
			var txt := ab.perfect_text if form == "perfect" else ab.description
			ok(classes_src.contains("{=Battle.%s}" % cname),
				"§3: %s's card text does not read %s through its door — it types the figure" % [card, cname])
			ok(txt.contains("%d turns" % v) or txt.contains("%d STRIKES" % v) or txt.contains("%d\nturns" % v),
				"§3: %s's %s does not state %s's %d" % [card, form, cname, v])
		# NO `+ 1` BESIDE IT: the difference between a constant and its card lived at the apply, a second copy of one rule.
		var plus := RegEx.new()
		plus.compile("\\b%s\\s*\\+\\s*1\\b" % cname)
		ok(plus.search(battle_src) == null, "§3: battle.gd still adds 1 to %s somewhere — the card's figure is the constant's" % cname)
		# THE DECLARATION NAMES ITS CARD AND WHAT THE FIGURE IS, NEVER THE FIGURE (HO §0).
		var decl := RegEx.new()
		decl.compile("(?m)^const %s\\s*:?=\\s*[^#\\n]*(#.*)?$" % cname)
		var dm := decl.search(raw)
		ok(dm != null, "§3: %s's declaration is not a plain `const` line" % cname)
		if dm != null:
			var note := dm.get_string(1)
			var digit := RegEx.new()
			digit.compile("\\d")
			ok(digit.search(note) == null, "§3: %s's declaration comment states a figure: %s" % [cname, note])
		# THE CAST APPLIES IT — driven at a Good grade (a Perfect where the constant is the Perfect's), on a fresh board.
		var got := await _drive_one(scene, heroes, enemies, ab, row[3], row[4])
		ok(got == v, "§3: %s's cast applied %d where %s holds %d — a magnitude the constant does not hold" % [card, got, cname, v])
		if got == v:
			drove += 1
	ok(battle_src.find("ps_turns + 1") < 0, "§3: Precision Strike still adds 1 to its grant at the apply")
	print("    CHECKED %d of %d constants: the door, the bare apply, the declaration, and the cast" % [drove, NINE.size()])
	scene.queue_free()
	await process_frame


func _drive_one(scene: Node, heroes: Array, enemies: Array, ab: Ability, how: String, arg: String) -> int:
	for u in heroes + enemies:
		u.statuses.clear()
	var war: BattleUnit = heroes[0]
	var mage: BattleUnit = heroes[1]
	var cler: BattleUnit = heroes[2]
	var foe: BattleUnit = null
	for e in enemies:
		if not e.dead:
			foe = e
			break
	match how:
		"status_enemies":
			await scene._resolve_special(mage, ab, foe, "good", 1.0)
			var least := 999
			for e in enemies:
				if not e.dead:
					least = mini(least, int(e.get_status(arg).get("turns", -99)))
			return least
		"status_self":
			await scene._resolve_special(mage, ab, mage, "good", 1.0)
			return int(mage.get_status(arg).get("turns", -99))
		"status_two_enemies":
			await scene._resolve_special(mage, ab, foe, "good", 1.0)
			var seen: Array = []
			for e in enemies:
				if not e.dead and e.has_status(arg):
					seen.append(int(e.get_status(arg).get("turns", -99)))
			return seen[0] if seen.size() == 2 and seen[0] == seen[1] else -1
		"status_allies":
			await scene._resolve_special(mage, ab, mage, "good", 1.0)
			return int(war.get_status(arg).get("turns", -99))
		"precision":
			await scene._resolve_special(war, ab, foe, arg, 1.0)
			for sid in ["open_guard", "parry_up"]:
				if war.has_status(sid):
					return int(war.get_status(sid).get("turns", -99))
			return -1
		"berserk":
			var before: int = war.berserk_strikes
			await scene._resolve_special(war, ab, war, "good", 1.0)
			return war.berserk_strikes - before
		"mantle":
			await scene._resolve_special(cler, ab, war, "good", 1.0)
			return int(war.get_status("barrier").get("mantle", -99))
	return -1


# ── §4 — THE BOT's SWAP ───────────────────────────────────────────────────────
func _s4_the_swap() -> void:
	print("\n§4 — the bot's swap: the player's price, from the one builder")
	var src := Gate.strip_comments(_doc("res://scripts/battle.gd"))
	var at := src.find("func _swap_choice(u: BattleUnit, call: Ability) -> Ability:")
	ok(at > 0, "§4: battle.gd has no `_swap_choice` — the one builder of a swap")
	var body := Gate.block(src, at)
	ok(body.contains("\"cost\": SUMMON_SWAP_COST") and body.contains("\"delay\": SUMMON_SWAP_DELAY") and body.contains("\"cooldown\": 0"),
		"§4: `_swap_choice` does not price a swap at the player's SUMMON_SWAP_COST and SUMMON_SWAP_DELAY with no cooldown of its own")
	var pick_at := src.find("func _open_summon_picker(u: BattleUnit) -> void:")
	ok(pick_at > 0 and Gate.block(src, pick_at).contains("_summon_opts.append(_swap_choice(u, a))"),
		"§4: the player's picker does not build its swap buttons through `_swap_choice`")
	ok(not Gate.block(src, pick_at).contains("SUMMON_SWAP_COST"),
		"§4: the picker prices a swap itself — a second builder")
	var bot_at := src.find("elif u.wild_rotation > 0 or u.cooldowns.get(\"Swap Companion\", 0) == 0:")
	var bot := Gate.block(src, bot_at) if bot_at > 0 else ""
	ok(bot_at > 0 and bot.contains("_bot_boon_worth(u, out_b.companion_kind)") and bot.contains("_swap_choice(u, _summon_choice(u, want))") and bot.contains("return [_swap_choice(u, _summon_choice(u, best_in)), u]"),
		"§4: the bot at capacity does not swap through `_swap_choice` — it is casting a call at the card's price")
	# DRIVEN: a hunter at capacity on a healthy field, whose rotation prefers the eagle over the standing wolf.
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "mystic"], {"deterministic": true})
	var hunter: BattleUnit = scene.get("heroes")[3]
	hunter.resource = hunter.max_resource
	hunter.cooldowns.clear()
	await scene._do_summon(hunter, "canis")
	var bots: Array = scene._beasts(hunter)
	ok(bots.size() == 1, "§4: the drive's hunter fields %d companions, not one" % bots.size())
	var pick: Array = scene._autoplay_pick(hunter)
	var sw: Ability = pick[0] if not pick.is_empty() else null
	ok(sw != null and sw.special == "summon" and sw.display_name.begins_with("Swap "),
		"§4: at capacity on a healthy field the bot did not swap (it picked %s)" % (sw.display_name if sw != null else "nothing"))
	if sw != null and sw.display_name.begins_with("Swap "):
		var mirror: Ability = scene._swap_choice(hunter, scene._summon_choice(hunter, sw.display_name.get_slice(" ", 1).to_lower()))
		ok(sw.cost == int(scene.get("SUMMON_SWAP_COST")) and is_equal_approx(sw.delay, float(scene.get("SUMMON_SWAP_DELAY"))) and sw.cooldown == 0,
			"§4: the bot's swap costs %d at %.1f with cooldown %d — the player's is %d at %.1f with none" % [
				sw.cost, sw.delay, sw.cooldown, int(scene.get("SUMMON_SWAP_COST")), float(scene.get("SUMMON_SWAP_DELAY"))])
		ok(mirror != null and scene._eff_cost(hunter, sw) == scene._eff_cost(hunter, mirror) and sw.description == mirror.description,
			"§4: the bot's swap and the picker's are not one swap (price at the door, or words)")
	scene.queue_free()
	await process_frame


# ── §5 — THE POSITIONAL CENSUS's STANDING ROWS ───────────────────────────────
const POS_CENSUS := "docs/reports/IT-positional-census.tsv"
const MISSES_CEILING := 13


func _stamp_of(path: String) -> String:
	return FileAccess.get_file_as_string("res://" + path).md5_text().substr(0, 6)


func _s5_the_standing_misses() -> void:
	print("\n§5 — the positional census's standing rows: a ceiling, and a stamp a touch breaks")
	var rows := _tsv(POS_CENSUS, ["target", "section", "verdict", "it_disposition", "iu_disposition"])
	var standing := 0
	var repaired := 0
	var touched: Array = []
	var silent: Array = []
	var bad: Array = []
	for r in rows:
		var iu := String(r.get("iu_disposition", ""))
		var t := String(r["target"])
		var path := t if t.ends_with(".gd") else t + ".gd"
		if String(r["it_disposition"]) == "REPORTED":
			if iu.begins_with("STANDING #"):
				standing += 1
				if _stamp_of(path) != iu.substr(10, 6):
					touched.append("%s %s" % [path, r["section"]])
			elif iu == "REPAIRED AT IU §5":
				repaired += 1
				if not _doc("res://" + path).contains("IU §5"):
					silent.append(path)
			else:
				bad.append("%s %s carries '%s'" % [path, r["section"], iu])
		elif iu != "—":
			bad.append("%s %s is not IT's REPORTED and carries '%s'" % [path, r["section"], iu])
	ok(bad.is_empty(), "§5: rows with no IU disposition, or one where none belongs: %s" % str(bad))
	ok(standing + repaired == 20, "§5: IT reported 20 picks; %d stand and %d are repaired" % [standing, repaired])
	ok(standing <= MISSES_CEILING,
		"§5: %d MISSES rows stand against a ceiling of %d — a ceiling that does not rise: a new miss is repaired, never recorded" % [standing, MISSES_CEILING])
	ok(touched.is_empty(),
		"§5: a batch touched a target carrying a MISSES row and left the row standing — repair it (the row's stamp is its file's): %s" % str(touched))
	ok(repaired >= 7 and silent.is_empty(), "§5: %d rows repaired at IU, and these targets do not say so in their source: %s" % [repaired, str(silent)])
	print("    CHECKED %d rows: %d standing (ceiling %d), %d repaired at IU" % [rows.size(), standing, MISSES_CEILING, repaired])


# ── §6 — THE MANIFEST's FLOOR ─────────────────────────────────────────────────
func _s6_the_pin_floor() -> void:
	print("\n§6 — the manifest's pin count is a floor")
	var m: Variant = JSON.parse_string(_doc("res://pin-manifest.json"))
	ok(m is Dictionary, "§6: pin-manifest.json does not parse")
	if not (m is Dictionary):
		return
	var pins: Array = m.get("pins", [])
	var floor_pins := int((m.get("floor", {}) as Dictionary).get("pins", -1))
	ok(floor_pins > 0, "§6: the manifest records no floor — `build_pin_manifest.py` writes one beside the pins")
	ok(pins.size() >= floor_pins,
		"§6: THE PIN COUNT FELL — the manifest holds %d pins against its floor of %d, and no fall names its batch and its reason (`build_pin_manifest.py --fall \"<BATCH>: <why>\"`)" % [pins.size(), floor_pins])
	ok(int((m.get("counts", {}) as Dictionary).get("total", -1)) == pins.size(),
		"§6: the manifest's own total is not the pins it holds")
	var falls: Array = m.get("falls", [])
	var nameless := 0
	for f in falls:
		if String((f as Dictionary).get("batch", "")).strip_edges() == "" or String((f as Dictionary).get("reason", "")).strip_edges() == "":
			nameless += 1
	ok(nameless == 0, "§6: %d recorded falls name no batch or no reason" % nameless)
	var builder := _doc("res://build_pin_manifest.py")
	ok(builder.contains("\"floor\": dict(pins=floor)") and builder.contains("--fall"),
		"§6: the builder no longer records the floor beside the pins")
	print("    CHECKED %d pins against a floor of %d; %d recorded falls" % [pins.size(), floor_pins, falls.size()])


# ── §7 — THE BARE PROBE ───────────────────────────────────────────────────────
# THE FOLDERS NO SPENT PATTERN HOLDS, EACH WITH HOW IT CAME: the two that predate the driver's probe. A new one reds.
const KNOWN_STRAYS := {
	"IT const probe": "IT §6 — a three-file probe run with `--path`, around lane.sh; carried by name in IT's clearing command",
	"[unnamed project]": "a project with no config/name, made 2026-07-02, before the batches counted their folders",
}


func _driver(args: Array) -> Array:
	var out: Array = []
	var code := OS.execute("/bin/zsh", PackedStringArray([ProjectSettings.globalize_path("res://lane.sh")] + args), out, true)
	return [code, "\n".join(PackedStringArray(out)).strip_edges()]


func _s7_the_bare_probe() -> void:
	print("\n§7 — a bare probe is a lane")
	var lane := _doc("res://lane.sh")
	ok(lane.contains("PROBE_PREFIX=\"DoD probe \"") and lane.contains("probe)   shift; make_probe \"$@\" ;;"),
		"§7: lane.sh has no bare-probe mode naming its probe `DoD probe <name>`")
	var pats: Array = []
	var pm := RegEx.new()
	pm.compile("SPENT_PATTERNS=\\(([^)]*)\\)")
	var hit := pm.search(lane)
	if hit != null:
		var each := RegEx.new()
		each.compile("'([^']*)'")
		for e in each.search_all(hit.get_string(1)):
			pats.append(e.get_string(1))
	var inside := false
	for p in pats:
		if ("DoD probe IU gate").matchn(String(p)):
			inside = true
	ok(pats.size() >= 3 and inside, "§7: a probe's name falls inside no spent pattern (%s)" % str(pats))
	# THE THREE ANSWERS, DRIVEN (nothing is launched, so no user folder is made): a scratch file makes a probe named
	# inside the pattern and recorded; a file of the repository's is refused; and so is a COPY of one, by content.
	var base := "/tmp/dod_iu_probe_%d" % OS.get_process_id()
	DirAccess.make_dir_recursive_absolute(base)
	var scratch := base + "/scratch_probe.gd"
	var f := FileAccess.open(scratch, FileAccess.WRITE)
	f.store_string("extends SceneTree\nfunc _initialize():\n\tquit()\n")
	f.close()
	var made: Array = _driver(["probe", base + "/made", "IU gate", scratch])
	var made_name := FileAccess.get_file_as_string(base + "/made/project.godot")
	ok(int(made[0]) == 0 and made_name.contains("config/name=\"DoD probe IU gate\"")
			and FileAccess.get_file_as_string(base + "/made/.lane").begins_with("kind=probe name=DoD probe IU gate"),
		"§7: `lane.sh probe` made no probe named and recorded inside the pattern: exit %d, '%s'" % [int(made[0]), made[1]])
	var game_file := ProjectSettings.globalize_path("res://scripts/unit.gd")
	var r_repo: Array = _driver(["probe", base + "/inrepo", "IU refused", game_file])
	ok(int(r_repo[0]) == 1 and String(r_repo[1]).contains("lives in the repository") and not DirAccess.dir_exists_absolute(base + "/inrepo"),
		"§7: a probe holding a file of the repository was not refused: exit %d, '%s'" % [int(r_repo[0]), r_repo[1]])
	var copy := base + "/copy_of_unit.gd"
	# RE-POINTED AT IZ: the copy is of the file AS THE REPOSITORY TRACKS IT — the index's blob, which is what `lane.sh` compares
	# against — never the working tree's, which differs from it whenever a batch has edited `unit.gd` and not committed: IZ
	# re-keyed Frenzied there, and the arm read red on every tree carrying the edit, a copy of nothing the repository tracks.
	var blob: Array = []
	OS.execute("/usr/bin/git", PackedStringArray(["-C", ProjectSettings.globalize_path("res://"), "show", ":scripts/unit.gd"]), blob, false)
	var g := FileAccess.open(copy, FileAccess.WRITE)
	g.store_string(String(blob[0]) if blob.size() > 0 else "")
	g.close()
	var r_copy: Array = _driver(["probe", base + "/copy", "IU refused", copy])
	ok(int(r_copy[0]) == 1 and String(r_copy[1]).contains("is a copy of a file the repository tracks"),
		"§7: a probe holding a copy of a tracked file was not refused: exit %d, '%s'" % [int(r_copy[0]), r_copy[1]])
	for p in [base + "/made/project.godot", base + "/made/.lane", base + "/made/scratch_probe.gd", scratch, copy]:
		DirAccess.remove_absolute(p)
	DirAccess.remove_absolute(base + "/made")
	DirAccess.remove_absolute(base)
	# THE FOLDERS NO SPENT PATTERN HOLDS, as the driver lists them: the named strays and nothing else.
	var r_strays: Array = _driver(["strays"])
	var strays: Array = []
	for line in String(r_strays[1]).split("\n", false):
		strays.append(String(line).strip_edges())
	var unknown: Array = strays.filter(func(x): return not KNOWN_STRAYS.has(x))
	ok(int(r_strays[0]) == 0 and unknown.is_empty(),
		"§7: a user-data folder no spent pattern holds and nobody named — a launch went around lane.sh: %s" % str(unknown))
	for k in KNOWN_STRAYS:
		if not strays.has(k):
			print("  [notice] §7: the named stray `%s` is gone — delete its line" % k)
	print("    CHECKED the probe's three answers; %d folders outside the spent patterns, %d of them named" % [strays.size(), strays.size() - unknown.size()])


# ── §8 — THE ROUTING IS A STEP ────────────────────────────────────────────────
# FROM IU THE ROUTING HAS A WRITTEN OUTPUT, and this holds the step, not one batch's copy of it: the record read is the
# LAST batch's (`docs/state.md` names it), `docs/reports/<code>-routing.md`, written before the work began. What it can
# hold is the shape — the subjects, the rows the triggers matched (a heading the state file or its archive carries), the
# core, the three lists with a diagnostic per miss, and the upkeep as a rate. **Whether the rows were read is the
# batch's** (IT §5's own honesty: a stamp proves a touch, not a read).
const ROUTING_HEADS := ["## THE BRIEF'S SUBJECTS", "## THE ROWS THE TRIGGERS MATCHED", "## THE CORE", "## OPENED", "## NEEDED",
	"## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED", "## THE INDEX's UPKEEP"]


func _section(txt: String, head: String) -> String:
	var a := txt.find("\n" + head)
	if a < 0:
		return ""
	var b := txt.find("\n## ", a + 1)
	return txt.substr(a + 1, (b - a - 1) if b > 0 else -1)


func _s8_the_routing() -> void:
	print("\n§8 — the routing is a step: the last batch's routing of record")
	var state := _doc("res://docs/state.md")
	var arch := _doc("res://DoD-archive/state-archive.md")
	var lb := RegEx.new()
	lb.compile("Last batch: ([A-Z]{2})\\b")
	var m := lb.search(state)
	ok(m != null, "§8: docs/state.md names no last batch")
	if m == null:
		return
	var code := m.get_string(1)
	var path := "docs/reports/%s-routing.md" % code
	var rec := _doc("res://" + path)
	ok(rec.length() > 500, "§8: %s is not in the tree — the routing is a step with a written output, before the work" % path)
	if rec.length() <= 500:
		return
	ok(not rec.contains("@@"), "§8: %s still carries a placeholder" % path)
	var at := -1
	var order := true
	for h in ROUTING_HEADS:
		var i := rec.find("\n" + String(h))
		ok(i > 0, "§8: %s has no '%s' section" % [path, h])
		if i <= at:
			order = false
		at = i
	ok(order, "§8: %s's sections are out of order" % path)
	var num := RegEx.new()
	num.compile("— (\\d+)")
	# THE MATCHED LIST: a table row a block, the block a heading the state file or its archive carries.
	var matched := _section(rec, "## THE ROWS THE TRIGGERS MATCHED")
	var said := num.search(matched.get_slice("\n", 0))
	var heads := RegEx.new()
	# A heading may hold a backtick of its own (`… IN A `const``): the cell closes at the double one.
	heads.compile("``\\s*(#{2,3} .+?)\\s*``")
	# A block's key is its heading up to the first " — " (`check_is` §5's reading), in the state file or its archive. The
	# archive strikes a section every item of which is answered (`### ~~X~~ — …`, its own header's rule), and that is still
	# block X: IW is the first batch to archive whole a block its routing matched (WHAT IV's DRIVE MOVED, FOUND AT IV).
	var keys := {}
	for f in [state, arch]:
		for line in String(f).split("\n"):
			if String(line).begins_with("## ") or String(line).begins_with("### "):
				var dash := String(line).find(" — ")
				keys[(String(line).left(dash) if dash > 0 else String(line)).replace("~~", "").strip_edges()] = true
	var rows := 0
	var homeless: Array = []
	var bare: Array = []
	for line in matched.split("\n"):
		if not String(line).begins_with("| ``"):
			continue
		rows += 1
		var cells := String(line).split("|")
		var h := heads.search(String(line))
		if h == null or not keys.has(h.get_string(1).strip_edges()):
			homeless.append(h.get_string(1) if h != null else String(line).left(40))
		if cells.size() < 5 or String(cells[3]).strip_edges() == "":
			bare.append(h.get_string(1) if h != null else String(line).left(40))
	ok(rows >= 1 and said != null and int(said.get_string(1)) == rows,
		"§8: %s's matched list holds %d rows against the %s its heading states — the routed list is the batch's first output" % [
			path, rows, said.get_string(1) if said != null else "nothing"])
	ok(homeless.is_empty(), "§8: %d matched rows name a block neither the state file nor its archive carries: %s" % [homeless.size(), str(homeless)])
	ok(bare.is_empty(), "§8: %d matched rows cite no trigger: %s" % [bare.size(), str(bare)])
	# THE CORE, read whole.
	var core := _section(rec, "## THE CORE")
	var said_c := num.search(core.get_slice("\n", 0))
	var n_core := 0
	for line in core.split("\n"):
		if String(line).begins_with("- ``"):
			n_core += 1
	ok(n_core >= 1 and said_c != null and int(said_c.get_string(1)) == n_core,
		"§8: %s's core lists %d blocks against the %s its heading states" % [path, n_core, said_c.get_string(1) if said_c != null else "nothing"])
	# THE THIRD LIST: every miss carries its diagnostic, or the list says it is empty.
	var close := _section(rec, "## FOUND AT THE CLOSE TO HAVE BORNE ON THE WORK AND NOT OPENED")
	var misses := 0
	var undiagnosed: Array = []
	for line in close.split("\n"):
		if String(line).begins_with("- "):
			misses += 1
			if not String(line).contains("ROUTED"):
				undiagnosed.append(String(line).left(50))
	ok(misses > 0 or close.contains("NONE"), "§8: %s's third list is neither a list nor said to be empty" % path)
	ok(undiagnosed.is_empty(), "§8: %d misses carry no ROUTED / NOT ROUTED: %s" % [undiagnosed.size(), str(undiagnosed)])
	var rate := RegEx.new()
	rate.compile("(\\d+) of (\\d+)")
	ok(rate.search(_section(rec, "## THE INDEX's UPKEEP")) != null, "§8: %s states no upkeep as rows touched of the total" % path)
	print("    CHECKED %s: %d matched rows, %d core, %d misses at the close" % [path, rows, n_core, misses])
