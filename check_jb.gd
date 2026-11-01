# BATCH JB — THE FOUR.
#
#   §0   THE RULINGS, EACH PINNED IN THE FILE IT BINDS: a bargain may not pay the heroes, and whether the warband feels it too is
#        flavour (JB §0.1, `CLAUDE.md`'s ladder block); what costs the party and what the share sets (JB §0.2, standing where IP's
#        rule stood, replacing it); and the two records the old sentences keep in the design notes.
#   §1   THE TWO RULES, IN THE LIVING DOCUMENTS: no living document makes the one-sidedness promise (C01), its positive arm the
#        sentence that replaced it, through the glossary's own door; IP's sentence replaced, not beside its replacement (C02); and
#        the cards whose quantity only the heroes produce — derived from the census — name no side (C03).
#   §2a  AMBUSHED: the figure read off its constant in the card's words (C04); DRIVEN on a real board, the Hunter's opening turn and
#        then the warband's run, every turn of it the warband's (C05), the heroes' clocks moved on when it ends, the bar drawing the
#        order the loop keeps, and nothing moved with no card. Only the Tracker's turn stands before the run (C13), and a hero seated
#        during it is not moved on twice (C14).
#   §2b  OUTPACED, THE RESERVE §2b AUTHORED IN INVERTED'S PLACE: its words; DRIVEN, in a span every enemy due acts before any hero due (C06),
#        the Hunter's opening turn first, a later span still later, the bar the order the loop keeps; and with no card the same
#        seats read the timeline alone — and Inverted, which paid the party, is gone from the code, its record in the design notes.
#   §2c  FRACTURED: the meter's share at its constant; DRIVEN, a recovered body stands one short of full, no blow without Break damage
#        re-Breaks it, one with Break damage does, a body nobody strikes gets its turn back, on both sides.
#   §2d  POROUS: a barrier holds its share of its face value and no more, spent over blows; the heroes' side alone, stamped (C08),
#        and no warband ability lays a barrier — the arm that reds the day one does.
#   §3   THE FOUR, MEASURED AND PLACED: each arm's own arithmetic; the deck holds the value its reading was taken at (C07) at the grade
#        the reading gives, naming its population and batch (C09); the tally.
#   §4   THE DECK, RE-READ: the axis table re-derived from the deck (C10); what Warden's gambles deal; the deck in `master.html`,
#        its cards at their severities and its tally the code's.
#   §5   THE CUT: the condition, at the open's reading (C11); the archive's newest cut is JB's.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jb.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")
const IZ = preload("res://check_iz.gd")
const JB := ["ambushed", "outpaced", "fractured", "porous"]

var _g := Gate.new()
var _run: Node
var _docs := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH JB — THE FOUR")
	_run = root.get_node("/root/Run")
	_s0_the_rulings()
	_s1_the_two_rules()
	await _s2a_ambushed()
	await _s2b_outpaced()
	await _s2c_fractured()
	await _s2d_porous()
	_s3_measured()
	_s4_the_deck()
	_s5_the_cut()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true)


func _tsv(path: String, need: Array) -> Array:
	var lines := _doc(path).split("\n", false)
	ok(lines.size() > 1, "%s is not in the tree" % path)
	if lines.size() < 2:
		return []
	var head := lines[0].split("\t")
	var missing: Array = []
	for c in need:
		if not head.has(c):
			missing.append(c)
	ok(missing.is_empty(), "%s lacks the columns %s" % [path, str(missing)])
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


func _konst(name: String) -> Variant:
	return (_run.get_script() as Script).get_script_constant_map().get(name, null)


func _cuts() -> Array:
	var out: Array = []
	var seen := {}
	for r in _tsv("res://docs/reports/IZ-scale.tsv", ["level", "cut_iz"]):
		var lv := int(r["level"])
		if lv <= 5 and not seen.has(lv):
			seen[lv] = true
			out.append(float(r["cut_iz"]))
	return out


func _band(cost_points: float, z: float, cuts: Array) -> int:
	if z < 2.0:
		return 0
	var b := 0
	for k in cuts.size():
		if cost_points >= float(cuts[k]):
			b = k + 1
	return b


# ── §0 — THE RULINGS ─────────────────────────────────────────────────────────
func _s0_the_rulings() -> void:
	print("\n§0 — the rulings, each pinned in the file it binds")
	var claude := _doc("res://CLAUDE.md")
	var notes := _doc("res://docs/design-notes.md")
	var flat := _flat(claude)
	ok(flat.contains("A BARGAIN MAY NOT PAY THE PARTY"), "§0.1: CLAUDE.md does not say a bargain may not pay the party")
	ok(flat.contains("WHETHER THE WARBAND FEELS IT TOO IS A QUESTION OF FLAVOUR, NOT OF FAIRNESS"),
		"§0.1: CLAUDE.md does not say whether the warband feels it is flavour, not fairness")
	ok(flat.contains("A RULE COSTS THE PARTY WHEN IT ADDS TO THE WARBAND's PRESSURE ON THE PARTY's HEALTH"),
		"§0.2: CLAUDE.md does not state what costs the party")
	ok(flat.contains("THE SHARE SETS HOW MUCH THE PARTY's OWN OUTPUT CLAWS BACK"),
		"§0.2: CLAUDE.md does not state what the share sets")
	# THE PRACTICE STAYS (§0.2): a new modifier still names the two sides' shares, read off the census of record, beside the rule.
	var rule_at := flat.find("A RULE COSTS THE PARTY WHEN IT ADDS TO THE WARBAND's PRESSURE ON THE PARTY's HEALTH")
	var practice_at := flat.find("A NEW MODIFIER NAMES THE TWO SIDES' SHARES OF ITS QUANTITY BEFORE IT IS BUILT")
	ok(rule_at >= 0 and practice_at > rule_at and practice_at - rule_at < 6000,
		"§0.2: the share practice does not stand beside the rule that replaced IP's (%d bytes apart)" % (practice_at - rule_at))
	# THE RECORD (§1: nothing is quietly edited into having always said this): each old sentence survives where a record does.
	ok(notes.contains("Why the one-sidedness promise went") and notes.contains("Why IP's sentence went"),
		"§1: docs/design-notes.md keeps no record of the two sentences that went")
	print("    CHECKED the two rulings and the practice in CLAUDE.md, and the two records in the design notes")


# ── §1 — THE TWO RULES, IN THE LIVING DOCUMENTS ──────────────────────────────
func _s1_the_two_rules() -> void:
	print("\n§1 — the two rules: no living document promises one-sidedness, and the cards name no side they do not bind")
	# THE SWEEP (C01): THE NEEDLES ARE BUILT AT RUN TIME, so this gate holds no copy of what it sweeps for. A record keeps the words —
	# the changelog, the design notes, the reports, the archive, the recon documents — and a gate's history comment is a record too.
	var bind := "bind"
	# LOWER-CASED ON BOTH SIDES: a case-bound list read past the offer screen's own line, every bargain's (C12).
	var needles: Array = ["nothing in the deck " + bind + "s one", "every modifier " + bind + "s both", bind + "s both sides",
		bind + "ing both parties"]
	var files: Array = []
	for d in ["res://scripts/", "res://data/"]:
		for f in DirAccess.get_files_at(d):
			if f.ends_with(".gd") or f.ends_with(".json"):
				files.append(d + f)
	for p in ["res://CLAUDE.md", "res://README.md", "res://docs/instrument-rules.md", "res://docs/combat-rules.md",
			"res://docs/ways-of-working.md", "res://docs/master.html", "res://docs/text-standard.html"]:
		files.append(p)
	var hits: Array = []
	var replaced_in := 0
	for p in files:
		var src := FileAccess.get_file_as_string(String(p))
		var flat := _flat(src).to_lower()
		if flat.contains("costs your heroes"):
			replaced_in += 1
		for n in needles:
			if flat.contains(String(n)):
				hits.append("%s: %s" % [String(p).trim_prefix("res://"), n])
	ok(hits.is_empty(), "§1: %d living lines still promise one-sidedness: %s" % [hits.size(), str(hits.slice(0, 6))])
	ok(files.size() > 25 and replaced_in >= 2,
		"§1: the sweep read %d files and %d state what replaced the promise — its positive arm reads nothing" % [files.size(), replaced_in])
	ok(_flat(FileAccess.get_file_as_string("res://scripts/offer_screen.gd")).contains("the condition costs your heroes"),
		"§1: the offer screen's line does not say what replaced the promise")
	# THE GLOSSARY, THROUGH ITS OWN DOOR: what a player reads, its tokens resolved.
	var entry: Dictionary = Glossary.entry("modifier")
	var long_text := String(entry.get("long", ""))
	ok(long_text.contains("every modifier in the deck costs your heroes, and the severity says how much"),
		"§1: the glossary's modifier entry does not say what replaced the promise")
	# IP's SENTENCE, REPLACED AND NOT BESIDE ITS REPLACEMENT (C02): built at run time, for the sweep's reason.
	var claude := _doc("res://CLAUDE.md")
	var ip_old := "PRODUCE EQUALLY PAYS THE SIDE " + "THAT PRODUCES MORE OF IT"
	var ip_head := "TWO-SIDEDNESS DOES NOT MAKE A RULE " + "EVEN"
	ok(not _flat(claude).contains(ip_old) and not claude.contains(ip_head),
		"§1: IP's sentence stands in CLAUDE.md beside what replaced it")
	ok(_flat(claude).contains("A RULE COSTS THE PARTY WHEN IT ADDS TO THE WARBAND's PRESSURE ON THE PARTY's HEALTH"),
		"§1: the replacement is not in CLAUDE.md, so the absence above proves nothing")
	# THE CARDS (C03): THE POPULATION IS THE CENSUS's — every modifier ALL of whose quantities the warband produces none or nearly none
	# of (the heroes forty times over or more on the reference party). A card there names no side the census says it does not bind.
	var quantity_rows := {}
	for r in _tsv("res://docs/reports/JA-shares.tsv", ["quantity", "modifiers", "ref_ratio"]):
		for m in String(r["modifiers"]).split(","):
			if m != "-":
				if not quantity_rows.has(m):
					quantity_rows[m] = []
				(quantity_rows[m] as Array).append(String(r["ref_ratio"]))
	var one_sided: Array = []
	for m in quantity_rows:
		var all_party := true
		for ratio in quantity_rows[m]:
			if ratio != "inf" and float(ratio) < 40.0:
				all_party = false
		if all_party:
			one_sided.append(m)
	one_sided.sort()
	ok(one_sided == ["encumbered", "parched", "thinair", "warded"],
		"§1: the census names %s as the cards only the heroes' quantities key — four are the ruling's" % str(one_sided))
	var mods: Dictionary = _run.MODIFIERS
	var named: Array = []
	var rx := RegEx.new()
	rx.compile("(?i)\\b(warband|both parties|both sides|everyone|everybody|either side)\\b")
	for m in one_sided:
		if rx.search(String(mods[m].get("desc", ""))) != null:
			named.append("%s: %s" % [m, mods[m].get("desc", "")])
	ok(named.is_empty(), "§1: %d one-sided cards name a side they do not bind: %s" % [named.size(), str(named)])
	print("    CHECKED %d files against %d needles, %d carry the replacement; the census's %d one-sided cards, none names a side" % [
		files.size(), needles.size(), replaced_in, one_sided.size()])


# The board's next `steps` turns, as `_run_battle` hands them out: the door, the spend, a basic attack's delay after each.
func _walk(scene: Node, steps: int) -> Array:
	var seq: Array = []
	for k in steps:
		var u: BattleUnit = scene.call("_next_unit")
		scene.set("_clock", u.next_time)
		scene.call("_ambush_spend", u)
		seq.append(u)
		u.next_time += Ability.BASIC_DELAY * 100.0 / u.effective_speed()
	return seq


func _arm(scene_mod: String) -> void:
	_run.pending_modifier = scene_mod


# The turn bar's portraits, each a unit's name, in the order drawn.
func _bar(scene: Node) -> Array:
	var bar: Array = []
	for slot in (scene.get("turn_bar") as Node).get_children():
		for c in slot.get_children():
			if c is TextureRect:
				bar.append(String((c as TextureRect).tooltip_text))
	return bar


# ── §2a — AMBUSHED ───────────────────────────────────────────────────────────
func _s2a_ambushed() -> void:
	print("\n§2a — Ambushed: the warband's run, seated in the one door the turn loop has")
	var mods: Dictionary = _run.MODIFIERS
	ok(mods.has("ambushed"), "§2a: the deck holds no Ambushed")
	if not mods.has("ambushed"):
		return
	var turns: Variant = _konst("AMBUSHED_WARBAND_TURNS")
	var words: Dictionary = _konst("COUNT_WORDS")
	ok(turns != null and words.has(int(turns)), "§2a: AMBUSHED_WARBAND_TURNS reads %s and has no word" % str(turns))
	# IT §2a, C04: THE FIGURE IN THE WORDS IS THE CONSTANT's.
	var want := "The warband takes %s turns before any hero but the Hunter acts." % String(words[int(turns)])
	ok(String(mods["ambushed"].get("desc", "")) == want,
		"§2a: the card's words are not its constant's figure ('%s', want '%s')" % [mods["ambushed"].get("desc", ""), want])
	# DRIVEN, ON A REAL BOARD: `_apply_battle_modifier` arms the run, as a fight's spawn does.
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var heroes: Array = scene.get("heroes")
	var enemies: Array = scene.get("enemies")
	var was_active: bool = _run.active
	var was_mod = _run.pending_modifier
	_run.active = true
	# THE UNSTAMPED BOARD FIRST, ITS POSITIVE ARM: no card, no run, and the door reads the timeline as it always did.
	ok(int(scene.get("_ambush_left")) == 0, "§2a: a board with no card carries a run of %d" % int(scene.get("_ambush_left")))
	_arm("ambushed")
	scene.call("_apply_battle_modifier")
	var left := int(scene.get("_ambush_left"))
	ok(left == int(turns), "§2a: the card arms a run of %d, the constant reads %d" % [left, int(turns)])
	# The seats as a fight's spawn leaves them: every hero's clock started, the Tracker's opening turn at -0.01.
	for k in heroes.size():
		heroes[k].next_time = 0.2 * (k + 1)
		if heroes[k].hero_key == "hunter":
			heroes[k].next_time = -0.01
	for k in enemies.size():
		enemies[k].next_time = 5.0 + 7.0 * k
	# THE BAR DRAWS WHAT THE LOOP KEEPS: its slots read off before the walk spends the run. A frame lets go the slots the last draw freed.
	scene.call("_rebuild_turn_bar")
	await process_frame
	var bar := _bar(scene)
	var walk := _walk(scene, int(turns) + 13)
	# THE PASSIVE STANDS (IO §0.5): the Hunter's opening turn stays before the run.
	ok((walk[0] as BattleUnit).hero_key == "hunter", "§2a: DRIVEN — the first turn went to %s, not the Hunter" % walk[0].unit_name)
	# C05: EVERY TURN OF THE RUN IS THE WARBAND's.
	var run_turns := 0
	for k in range(1, int(turns) + 1):
		if not (walk[k] as BattleUnit).is_hero:
			run_turns += 1
	ok(run_turns == int(turns), "§2a: DRIVEN — %d of the %d turns after the Hunter's went to the warband" % [run_turns, int(turns)])
	ok(int(scene.get("_ambush_left")) == 0, "§2a: the run did not end after its own count")
	# THE CLOCKS MOVED ON: the turn after the run is a hero's soon, and no burst of hero turns hands the run back.
	var after: Array = walk.slice(int(turns) + 1, int(turns) + 13)
	var hero_after := 0
	for u in after:
		if (u as BattleUnit).is_hero:
			hero_after += 1
	ok(hero_after >= 3, "§2a: DRIVEN — %d of the 12 turns after the run are heroes' — the run ended and they never came back" % hero_after)
	ok(hero_after <= 9, "§2a: DRIVEN — %d of the 12 turns after the run are heroes' — their clocks did not move on, and the run was handed back in a burst" % hero_after)
	var bar_matches := 0
	for k in mini(bar.size(), walk.size()):
		if String(bar[k]) == String((walk[k] as BattleUnit).unit_name):
			bar_matches += 1
	ok(bar.size() >= 10 and bar_matches == bar.size(),
		"§2a: the turn bar drew %s; the loop walked otherwise (%d of the %d slots agree)" % [str(bar.slice(0, 4)), bar_matches, bar.size()])
	scene.queue_free()
	await process_frame
	# ONLY THE TRACKER's TURN STANDS BEFORE THE RUN (C13): an ally seated beside him at -0.01, where a Resonating Hourglass in his
	# opening turn lands one at `_clock`, is not the Hunter, and the card says no hero but the Hunter acts.
	var seats: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var hs: Array = seats.get("heroes")
	var es: Array = seats.get("enemies")
	_arm("ambushed")
	seats.call("_apply_battle_modifier")
	var hunter: BattleUnit = null
	var others: Array = []
	for h in hs:
		h.next_time = 0.2
		if h.hero_key == "hunter":
			h.next_time = -0.01
			hunter = h
		else:
			others.append(h)
	ok(hunter != null and others.size() >= 3, "§2a: the board holds no Hunter and three others to seat")
	if hunter == null or others.size() < 3:
		_run.pending_modifier = was_mod
		_run.active = was_active
		seats.queue_free()
		await process_frame
		return
	var ally: BattleUnit = others[0]
	var seated: BattleUnit = others[1]
	var kept: BattleUnit = others[2]
	ally.next_time = -0.01
	for k in es.size():
		es[k].next_time = 5.0 + 7.0 * k
	var opening := _walk(seats, 2)
	ok(opening[0] == hunter, "§2a: DRIVEN — an ally seated before the run took the Hunter's opening turn from him (%s)" % opening[0].unit_name)
	ok(opening[1] != ally and not (opening[1] as BattleUnit).is_hero, "§2a: DRIVEN — %s went second, ahead of the run" % opening[1].unit_name)
	# A HERO SEATED DURING THE RUN IS NOT MOVED ON TWICE (C14): Watchtower's answer lands on the clock itself, and the run's end moves
	# every clock on, so with no cap she comes out of the run as late as it was long. A seed left where it stood is the positive arm.
	_walk(seats, int(turns) - 2)
	ok(int(seats.get("_ambush_left")) == 1, "§2a: the seats' run reads %d with one turn of it to go" % int(seats.get("_ambush_left")))
	seated.next_time = float(seats.get("_clock"))
	_walk(seats, 1)
	var run_end := float(seats.get("_clock"))
	var opening_most := 100.0 / maxf(seated.effective_speed(), 0.1)
	ok(run_end > opening_most, "§2a: the run ended at %.2f, inside one opening roll, so the arm below reads nothing" % run_end)
	ok(seated.next_time <= run_end + opening_most,
		"§2a: DRIVEN — a hero seated during the run stands at %.2f, the run ended at %.2f: moved on twice" % [seated.next_time, run_end])
	ok(is_equal_approx(kept.next_time, 0.2 + run_end), "§2a: DRIVEN — a hero left at his seed stands at %.2f, want %.2f" % [kept.next_time, 0.2 + run_end])
	ok(ally.next_time < run_end, "§2a: DRIVEN — the ally seated before the run stands at %.2f, behind the run's end at %.2f" % [ally.next_time, run_end])
	_run.pending_modifier = was_mod
	_run.active = was_active
	seats.queue_free()
	await process_frame
	# A card that was never armed moves nothing: the same door on a fresh board with no modifier hands out the plain timeline.
	var plain: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var all: Array = plain.get("heroes") + plain.get("enemies")
	var soonest: BattleUnit = all[0]
	for u in all:
		if u.next_time < soonest.next_time:
			soonest = u
	ok(plain.call("_next_unit") == soonest, "§2a: with no card the door does not hand the turn to the soonest clock")
	plain.queue_free()
	await process_frame
	print("    CHECKED the card at %d; DRIVEN the Hunter first, %d of %d to the warband, %d of 12 to the heroes after, the bar %d of %d" % [
		int(turns), run_turns, int(turns), hero_after, bar_matches, bar.size()])


# ── §2b — OUTPACED ───────────────────────────────────────────────────────────
func _s2b_outpaced() -> void:
	print("\n§2b — Outpaced: in every span the warband acts first, in the one door that orders turns")
	var mods: Dictionary = _run.MODIFIERS
	ok(mods.has("outpaced"), "§2b: the deck holds no Outpaced")
	if not mods.has("outpaced"):
		return
	ok(String(mods["outpaced"].get("desc", "")) == "The warband acts before any hero every round, whatever the speeds. The Hunter's opening turn stands.",
		"§2b: the card's words are not its rule ('%s')" % mods["outpaced"].get("desc", ""))
	# INVERTED LEFT THE CODE WHEN IT PAID THE PARTY (JB §3), ITS READING AND ITS SHAPE THE DESIGN NOTES': built at run time, so this gate holds no copy.
	var gone := "INVERTED_SPEED" + "_PIVOT"
	ok(not _doc("res://scripts/unit.gd").contains(gone) and not mods.has("in" + "verted"), "§2b: Inverted's door stands beside its reserve")
	ok(_doc("res://docs/design-notes.md").contains("Why Inverted left"), "§2b: the design notes keep no record of Inverted's shape and reading")
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var heroes: Array = scene.get("heroes")
	var enemies: Array = scene.get("enemies")
	var was_active: bool = _run.active
	var was_mod = _run.pending_modifier
	_run.active = true
	var span := float(scene.get("OUTPACED_SPAN"))
	# THE SEATS, THE SAME UNDER BOTH ARMS: every hero due before every enemy, inside the first span.
	var seat := func() -> void:
		for k in heroes.size():
			heroes[k].next_time = span * (0.05 + 0.05 * k)
			if heroes[k].hero_key == "hunter":
				heroes[k].next_time = -0.01
		for k in enemies.size():
			enemies[k].next_time = span * (0.5 + 0.05 * k)
	_arm("")
	seat.call()
	var plain := _walk(scene, 2)
	ok((plain[1] as BattleUnit).is_hero, "§2b: with no card the timeline did not hand the seat after the Hunter's to a hero — the arm below proves nothing")
	_arm("outpaced")
	seat.call()
	scene.call("_rebuild_turn_bar")
	await process_frame
	var bar := _bar(scene)
	var walk := _walk(scene, 1 + enemies.size() + 1)
	ok((walk[0] as BattleUnit).hero_key == "hunter", "§2b: DRIVEN — the first turn went to %s, not the Hunter" % walk[0].unit_name)
	var first_enemies := 0
	for k in range(1, enemies.size() + 1):
		if not (walk[k] as BattleUnit).is_hero:
			first_enemies += 1
	# C06: THE ORDER PUT BACK, THE HEROES DUE FIRST TAKE THESE TURNS AND THIS READS LOW.
	ok(first_enemies == enemies.size(), "§2b: DRIVEN — %d of the warband's %d turns came before a hero due first" % [first_enemies, enemies.size()])
	var bar_matches := 0
	for k in mini(bar.size(), walk.size()):
		if String(bar[k]) == String((walk[k] as BattleUnit).unit_name):
			bar_matches += 1
	ok(bar_matches == walk.size(), "§2b: the turn bar drew %s; the loop walked otherwise (%d of %d)" % [str(bar.slice(0, 4)), bar_matches, walk.size()])
	# SPEED STILL COUNTS ACROSS SPANS: an enemy due in the next span waits for a hero due in this one.
	for k in heroes.size():
		heroes[k].next_time = span * 3.0 + k
	heroes[0].next_time = span * 0.5
	for k in enemies.size():
		enemies[k].next_time = span * 1.5 + 0.1 * k
	ok(scene.call("_next_unit") == heroes[0], "§2b: DRIVEN — an enemy due in a later span went ahead of a hero due in this one")
	_run.pending_modifier = was_mod
	_run.active = was_active
	scene.queue_free()
	await process_frame
	print("    CHECKED the words; DRIVEN the Hunter first, %d of %d to the warband, the bar %d of %d" % [first_enemies, enemies.size(), bar_matches, walk.size()])


# ── §2c — FRACTURED ──────────────────────────────────────────────────────────
func _s2c_fractured() -> void:
	print("\n§2c — Fractured: a recovery leaves the meter, and the next Break damage Breaks the body again")
	var mods: Dictionary = _run.MODIFIERS
	ok(mods.has("fractured"), "§2c: the deck holds no Fractured")
	if not mods.has("fractured"):
		return
	var share: Variant = _konst("FRACTURED_RECOVERY_MULT")
	ok(share != null, "§2c: Run carries no FRACTURED_RECOVERY_MULT")
	if share == null:
		return
	# THE DRIVE BELOW TAKES ITS WANT FROM THE CONSTANT, SO IT CANNOT SEE THE VALUE THAT DOES NOTHING: at 1.0 a recovery empties the meter as every fight's does.
	ok(float(share) < 1.0, "§2c: FRACTURED_RECOVERY_MULT reads %.2f — a recovery empties the meter as it does in every fight, a grade on a card that does nothing" % float(share))
	var words: Dictionary = _konst("SHARE_WORDS")
	var want := "A Broken body's meter does not empty. Any Break damage Breaks it again." if float(share) == 0.0 \
		else "A Broken body's meter empties only %s of the way." % String(words.get(float(share), "?"))
	ok(String(mods["fractured"].get("desc", "")) == want, "§2c: the card's words are not its constant's ('%s')" % mods["fractured"].get("desc", ""))
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var hero: BattleUnit = (scene.get("heroes") as Array)[0]
	var enemy: BattleUnit = (scene.get("enemies") as Array)[0]
	var bad: Array = []
	for u in [hero, enemy]:
		scene.call("_stamp_modifier", u, "fractured")
		var body := u as BattleUnit
		var top := int(body.stability)
		var want_meter := mini(int(round(top * (1.0 - float(share)))), top - 1)
		# Twice the meter: a body's Constitution takes a share off whatever lands.
		body.take_hit(0, top * 2)
		if not body.broken:
			bad.append("%s did not Break" % body.unit_name)
			continue
		body.recover_from_break()
		if body.broken or body.pressure != want_meter:
			bad.append("%s stands broken=%s at %d, want %d" % [body.unit_name, str(body.broken), body.pressure, want_meter])
		if body.pressure <= 0:
			bad.append("%s's recovery emptied its meter" % body.unit_name)
		# THE TWO ARMS OF THE CARD: a blow with no Break damage leaves the body standing; Break damage Breaks it again.
		body.take_hit(1, 0)
		if body.broken:
			bad.append("%s re-Broke on a blow with no Break damage" % body.unit_name)
		if float(share) == 0.0:
			body.take_hit(0, 5)
			if not body.broken:
				bad.append("%s did not re-Break on a small blow of Break damage" % body.unit_name)
			body.recover_from_break()
	ok(bad.is_empty(), "§2c: DRIVEN — the card does not do what it says on both sides: %s" % str(bad))
	# EVERY OTHER FIGHT: an unstamped body's recovery empties the whole meter (the positive arm of the same line).
	var plain: BattleUnit = (scene.get("heroes") as Array)[1]
	plain.take_hit(0, int(plain.stability) * 2)
	ok(plain.broken, "§2c: the unstamped body did not Break, so the line below reads nothing")
	plain.recover_from_break()
	ok(plain.pressure == 0, "§2c: an unstamped body's recovery left %d on the meter" % plain.pressure)
	scene.queue_free()
	await process_frame
	print("    CHECKED the words at %.2f; DRIVEN a hero and an enemy through a Break, a recovery and both blows" % float(share))


# ── §2d — POROUS ─────────────────────────────────────────────────────────────
func _s2d_porous() -> void:
	print("\n§2d — Porous: a barrier on the heroes' side holds its share of its face value")
	var mods: Dictionary = _run.MODIFIERS
	ok(mods.has("porous"), "§2d: the deck holds no Porous")
	if not mods.has("porous"):
		return
	var share: Variant = _konst("POROUS_BARRIER_MULT")
	ok(share != null, "§2d: Run carries no POROUS_BARRIER_MULT")
	if share == null:
		return
	var words: Dictionary = _konst("SHARE_WORDS")
	var want := "Barriers hold %s of what they would." % String(words.get(float(share), "?"))
	ok(String(mods["porous"].get("desc", "")) == want, "§2d: the card's words are not its constant's ('%s')" % mods["porous"].get("desc", ""))
	var scene: Node = await Gate.spawn(self, ["berserker", "cryomancer", "inquisitor", "beastmaster"])
	var hero: BattleUnit = (scene.get("heroes") as Array)[0]
	var enemy: BattleUnit = (scene.get("enemies") as Array)[0]
	# EVERY OTHER FIGHT FIRST: a barrier absorbs its whole face value.
	hero.max_hp = 100000
	hero.hp = 100000
	hero.add_status("barrier", "Barrier", "Ba", Color.WHITE, 3, "", 200)
	hero.take_hit(50, 0)
	hero.take_hit(50, 0)
	ok(hero.hp == 100000 and hero.status_power("barrier") == 100, "§2d: with no card a barrier of 200 did not eat two blows of 50 whole (hp %d, power %d)" % [hero.hp, hero.status_power("barrier")])
	hero.remove_status("barrier")
	scene.call("_stamp_modifier", hero, "porous")
	scene.call("_stamp_modifier", enemy, "porous")
	# C08: THE HEROES' SIDE ALONE — AND IT REDS ON THE ABSENCE: the warband has no barrier to read, so the stamp is what is read.
	ok(float(hero.mod_barrier_mult) == float(share), "§2d: the card did not stamp a hero (%.2f)" % float(hero.mod_barrier_mult))
	ok(float(enemy.mod_barrier_mult) == 1.0, "§2d: the card stamped the warband (%.2f) — it binds the heroes' side alone" % float(enemy.mod_barrier_mult))
	var face := 1000
	var holds := int(ceil(face * float(share)))
	hero.add_status("barrier", "Barrier", "Ba", Color.WHITE, 3, "", face)
	var taken := 0
	var hp0 := int(hero.hp)
	for k in 6:
		hero.take_hit(100, 0)
		taken += 100
	var through := hp0 - int(hero.hp)
	ok(absi((taken - through) - holds) <= 1, "§2d: DRIVEN — a barrier of %d ate %d of %d over six blows, want %d" % [face, taken - through, taken, holds])
	ok(not hero.has_status("barrier"), "§2d: DRIVEN — a barrier of %d still stands after eating %d" % [face, taken - through])
	scene.queue_free()
	await process_frame
	# THE WARBAND LAYS NO BARRIER (the census read it absorbing none): the arm that reds the day one is authored, and the card with it.
	var enemy_specials := {}
	var data: Variant = JSON.parse_string(_doc("res://data/enemies.json"))
	var abilities := 0
	for k in (data as Dictionary):
		for ab in ((data as Dictionary)[k] as Dictionary).get("abilities", []):
			abilities += 1
			enemy_specials[String((ab as Dictionary).get("special", ""))] = true
			var st: Variant = (ab as Dictionary).get("applies_status", {})
			if st is Dictionary and String((st as Dictionary).get("id", "")) == "barrier":
				enemy_specials["barrier"] = true
	ok(abilities >= 40, "§2d: %d enemy abilities read, so the absence below reads little" % abilities)
	ok(not enemy_specials.has("barrier"), "§2d: an enemy ability lays a barrier")
	var ward := Gate.strip_comments(_resolve_arm("enemy_shield"))
	ok(ward.contains("\"shielded\""), "§2d: the warband's ward arm was not read")
	ok(not ward.contains("\"barrier\""), "§2d: the warband's ward lays a barrier")
	print("    CHECKED the words at %.2f; DRIVEN the heroes' side stamped, the warband's not; %d of a %d face eaten; %d enemy abilities lay none" % [
		float(share), taken - through, face, abilities])


func _resolve_arm(special: String) -> String:
	var src := _doc("res://scripts/battle.gd")
	var marker := "\n\t\t\"%s\":\n" % special
	var a := src.find(marker)
	if a < 0:
		return ""
	var b := src.find("\n\t\t\"", a + marker.length())
	return src.substr(a, b - a)


# ── §3 — MEASURED AND PLACED ─────────────────────────────────────────────────
func _s3_measured() -> void:
	print("\n§3 — the four, measured and placed: the grade follows the reading")
	var cuts := _cuts()
	ok(cuts.size() == 5, "§3: the scale yields %d cuts — five expected" % cuts.size())
	var rows := _tsv("res://docs/reports/JB-arms.tsv", ["arm", "id", "handle", "value", "population", "runs", "reading", "se", "cost", "d_se", "z", "band", "shipped"])
	var mods: Dictionary = _run.MODIFIERS
	var top := {}
	var read: Dictionary = {}
	var bad: Array = []
	var grades_tsv := {}
	for r in _tsv("res://docs/reports/JB-grades.tsv", ["modifier", "id", "handle", "value", "ref_cost", "ref_se", "ref_z", "grade", "population", "batch"]):
		grades_tsv[String(r["id"])] = r
	for r in rows:
		if String(r["arm"]) == "none":
			continue
		var z := float(r["cost"]) / maxf(float(r["d_se"]), 1e-9)
		if absf(z - float(r["z"])) > 0.01 or int(r["runs"]) != 60:
			bad.append("%s: z %s over %s runs; its figures give %.2f" % [r["arm"], r["z"], r["runs"], z])
		if int(r["band"]) != _band(float(r["cost"]), z, cuts):
			bad.append("%s: band %s; its figures give %d" % [r["arm"], r["band"], _band(float(r["cost"]), z, cuts)])
		if String(r["shipped"]) == "yes":
			var id := String(r["id"])
			# THE GRADE IS THE HIGHEST COST ON ANY POPULATION (IY §0.3), SO BOTH POPULATIONS' SHIPPED READINGS ARE READ.
			top[id] = maxi(int(top.get(id, 0)), int(r["band"]))
			if not read.has(id):
				read[id] = []
			(read[id] as Array).append(r)
	ok(bad.is_empty() and rows.size() >= 5, "§3: %d arms are not their own arithmetic: %s" % [bad.size(), str(bad)])
	var graded_bad: Array = []
	for id in JB:
		if not top.has(id) or not mods.has(id) or (read[id] as Array).size() != 2:
			graded_bad.append("%s has not its two shipped readings, or no row" % id)
			continue
		var card: Dictionary = mods[id]
		# C09: THE GRADE IS THE ARM's, AND THE ROW NAMES ITS POPULATION AND BATCH.
		if int(card.get("severity", 0)) != int(top[id]):
			graded_bad.append("%s: the deck holds %d, its arms read %d" % [id, int(card.get("severity", 0)), int(top[id])])
		if String(card.get("graded", "")).find("JB §3") < 0:
			graded_bad.append("%s: graded '%s' names no JB reading" % [id, card.get("graded", "")])
		# C07: THE DECK HOLDS THE VALUE THE READING WAS TAKEN AT.
		for r in read[id]:
			var h := String(r["handle"])
			if h != "-" and float(_konst(h)) != float(r["value"]):
				graded_bad.append("%s: its reading was taken at %s %s and the deck holds %s" % [id, h, r["value"], str(_konst(h))])
		if not grades_tsv.has(id) or int(grades_tsv[id]["grade"]) != int(top[id]):
			graded_bad.append("%s: JB-grades.tsv does not carry its arms' grade" % id)
	ok(graded_bad.is_empty(), "§3: %s" % str(graded_bad))
	var placed := top
	# THE TALLY, DERIVED: every modifier has its severity, and the kept table holds the deck.
	var counts := {}
	for id in mods:
		var s := int(mods[id].get("severity", 0))
		counts[s] = int(counts.get(s, 0)) + 1
	ok(not counts.has(0), "§3: a modifier carries no severity: %s" % str(counts))
	ok(grades_tsv.size() == mods.size(), "§3: JB-grades.tsv holds %d rows, the deck %d" % [grades_tsv.size(), mods.size()])
	print("    CHECKED %d arms' arithmetic; the four placed at %s; the deck %s" % [rows.size(), str(placed), str(counts)])


# ── §4 — THE DECK, RE-READ ───────────────────────────────────────────────────
func _s4_the_deck() -> void:
	print("\n§4 — the deck, re-read: the axis table, derived from the deck in the code")
	var rows := _tsv("res://docs/reports/JB-axes.tsv", ["axis", "modifiers", "grades", "top", "holds_4"])
	var mods: Dictionary = _run.MODIFIERS
	var seen := {}
	var bad: Array = []
	for r in rows:
		for pair in String(r["modifiers"]).split(","):
			var kv := String(pair).split(":")
			var id := String(kv[0])
			seen[id] = int(seen.get(id, 0)) + 1
			if not mods.has(id):
				bad.append("%s names %s, which the deck lacks" % [r["axis"], id])
			elif int(mods[id].get("severity", 0)) != int(kv[1]):
				bad.append("%s: %s is written at %s, the deck holds it at %d" % [r["axis"], id, kv[1], int(mods[id].get("severity", 0))])
	ok(bad.is_empty(), "§4: %s" % str(bad))
	var unplaced: Array = []
	for id in mods:
		if int(seen.get(id, 0)) != 1:
			unplaced.append("%s on %d" % [id, int(seen.get(id, 0))])
	# C10: JA's ten rows hold twenty-one, so the table left at them leaves the four unplaced.
	ok(unplaced.is_empty(), "§4: %d modifiers are not on exactly one axis: %s" % [unplaced.size(), str(unplaced)])
	# WARDEN's GAMBLES (§4): the count its offers deal, read off its own band, beside the ruling that band rests on.
	var band: Array = (_run.DIFFICULTIES as Dictionary)["warden"]["gamble_band"]
	ok(band == [4, 4], "§4: Warden's gamble band reads %s — JB moves no band" % str(band))
	var gambles := 0
	for id in mods:
		var s := int(mods[id].get("severity", 0))
		if s >= int(band[0]) and s <= int(band[1]):
			gambles += 1
	ok(gambles >= 2, "§4: Warden's gambles hold %d" % gambles)
	# THE DECK IN THE DOCUMENT (H02): every card of the code stands in the table at its severity, and the tally it states is the code's.
	var master := _doc("res://docs/master.html")
	var tally := {}
	var unlisted: Array = []
	for id in mods:
		var s := int(mods[id].get("severity", 0))
		tally[s] = int(tally.get(s, 0)) + 1
		if not master.contains("<tr><td>%s</td><td>%d</td>" % [String(mods[id].get("name", "")), s]):
			unlisted.append(id)
	ok(unlisted.is_empty(), "§4: %d cards do not stand in master.html's table at their severity: %s" % [unlisted.size(), str(unlisted)])
	var said := {3: "three", 4: "four", 5: "five", 6: "six", 7: "seven", 8: "eight"}
	var line := "%s at severity 1, %s at 2, %s at 3, %s at 4 and %s at 5" % [said.get(tally.get(1, 0), "?"), said.get(tally.get(2, 0), "?"),
		said.get(tally.get(3, 0), "?"), said.get(tally.get(4, 0), "?"), said.get(tally.get(5, 0), "?")]
	ok(_flat(master).contains(line), "§4: master.html's tally does not read the deck's (%s)" % line)
	ok(master.contains("The pool is %d" % mods.size()), "§4: master.html's pool does not read the deck's %d" % mods.size())
	print("    CHECKED %d axes place the deck's %d once each; Warden's gambles hold %d; master.html's table and its tally read the code's" % [rows.size(), mods.size(), gambles])


# ── §5 — THE CUT ─────────────────────────────────────────────────────────────
func _s5_the_cut() -> void:
	print("\n§5 — the cut: taken on the condition written before the reading")
	var rows := _tsv("res://docs/reports/JB-cut.tsv", ["open_bytes", "ceiling_bytes", "condition_room", "cut_bytes", "written_bytes", "close_bytes"])
	ok(rows.size() == 1, "§5: JB-cut.tsv holds %d rows" % rows.size())
	if rows.size() != 1:
		return
	var r: Dictionary = rows[0]
	var room := int(r["ceiling_bytes"]) - int(r["open_bytes"])
	# C11: A CUT IS TAKEN ONLY UNDER THE CONDITION.
	ok(int(r["cut_bytes"]) == 0 or room < int(r["condition_room"]),
		"§5: the cut took %s B with %d B of room, and the condition was under %s B" % [r["cut_bytes"], room, r["condition_room"]])
	ok(int(r["open_bytes"]) + int(r["written_bytes"]) - int(r["cut_bytes"]) == int(r["close_bytes"]),
		"§5: the net does not sum: %s + %s - %s against %s" % [r["open_bytes"], r["written_bytes"], r["cut_bytes"], r["close_bytes"]])
	var arch := _doc("res://DoD-archive/state-archive.md")
	var at := arch.find("\n## ARCHIVED AT ")
	ok(at >= 0 and arch.substr(at, 40).contains("AT JB"), "§5: the archive's newest cut is not JB's")
	var live := FileAccess.get_file_as_string("res://docs/state.md").to_utf8_buffer().size()
	ok(live == int(r["close_bytes"]), "§5: docs/state.md reads %d B and the table's close %s B" % [live, r["close_bytes"]])
	print("    CHECKED the condition at %d B of room; the cut %s B; the net to %s B" % [room, r["cut_bytes"], r["close_bytes"]])
