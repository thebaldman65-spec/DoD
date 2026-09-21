# BATCH GQ — THE ENGINE CARDS SAY ONLY WHAT DIFFERS.
#
#   §0  WHAT A RUNE ADDS, DERIVED — for all twenty-four engines, what the rune's
#       hero opens with beyond a hero holding no engine. Since BATCH GS that is
#       exactly its engine's enablers: nothing, for the three spines, the nine
#       rule engines and the six lineages whose engine runs on the bare kit; and
#       no rune takes a card of the bare kit away (GS ended the basic overrides)
#   §1  EVERY DEAL, DRAWN — all twenty deals of three of each class's six on the
#       real screen: each card is its rune's name, its rule and what it adds, and
#       nothing else — no archetype line, no blurb, no ability's figures — and
#       each keeps its one button
#   §2  THE KIT, ONCE, BELOW — the class basic and class kit under the cards, at
#       the figures of a hero holding no engine, the same on every deal of a
#       class; the class passive where it was, above the cards
#   §3  THE NOTE — shown exactly when a dealt rune's hero still holds a kit card
#       whose figure his lineage's Attack moves, and naming that rune
#   §4  THE FIT — the kit and every button inside the 720px screen; which cards
#       scroll, printed for all twenty-four
#   §5  A SPINE IN THE DEAL, PRESSED — through the real buttons, into the map
#   §6  THE WORDS THIS SCREEN WRITES — no pronoun, no retired word and no internal
#       engine name
#   §7  THE PLAYER'S FILES — as this gate found them
#
# ── WHY EVERY DEAL ───────────────────────────────────────────────────────────
# **A CARD'S CONTENT DEPENDS ON THE RUNE, AND THE NOTE DEPENDS ON THE DEAL**, so
# a sample of deals can miss the one that shows a wrong note. Each class has
# twenty deals of three from six; all eighty are drawn, which costs a few
# seconds. The screen reads the frozen deal off the member (`Run.deal_engines`)
# and redraws through its own `_draw_screen`, the function its `_ready` and its
# buttons already call.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM BESIDE IT**: no archetype line
# beside the rune's name heading the card; no kit card on a card beside every
# kit card once below; no lineage's figures in the kit beside the no-engine
# figures there; no note on a deal that moves nothing shown beside the note on
# every deal that does; no `in place of` on a rune that keeps the basic beside
# the clause on every rune that replaces it. (BATCH GS: no rune replaces it now,
# so the clause's arm reads "on no card", and §0 asserts why.)
#
# ── WHAT IS READ, AND WHAT IS DERIVED ────────────────────────────────────────
# The expected card and the expected kit are derived here off
# `Classes.opening_kit` — the one kit builder the battle reads — and not off the
# screen's own helpers, so a screen that computes the wrong list is compared
# against the kit a fight would really open with. `Run` writes its harness save
# under `--script` (FI); `Profile` and `Relics` are pointed at scratch files of
# this gate's own before §5's walk reaches the map, and §7 reads the player's
# three files byte for byte.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_gq.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const SCRATCH_PROFILE := "user://gq_profile.json"
const SCRATCH_RELICS := "user://gq_relics.json"
const SCREEN := Vector2(1280, 720)
# The nine engine names that reach no player (GO's ruling), as the stems a
# prefix-bounded match needs. Split so this file's own source never spells them
# whole, as `check_go` splits its own.
const ENGINE_STEMS := ["savage" + " assault", "redo" + "ubt", "ec" + "ho",
	"sip" + "hon", "cove" + "nant", "judg" + "ment", "quar" + "r",
	"open" + "ing", "field" + " kit"]

var _g := Gate.new()
var _run: Node = null
var _player := {}
# rune id -> [content height, window height], the first time its card is drawn.
var _scroll := {}
# BATCH GS — class -> [the lowest line on any of its screens, the deal that drew
# it]. §4 asserts every screen fits; this prints how close the tallest came,
# because GS put Pommel Strike's five-line text in the Warrior's kit row.
var _lowest := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH GQ — THE ENGINE CARDS SAY ONLY WHAT DIFFERS")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a screen is drawn")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_scratch_files()
	_s0_what_a_rune_adds()
	await _s1_every_deal()
	await _s5_a_spine_pressed()
	_s7_the_players_files()
	Engine.time_scale = 1.0
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────
func _scratch_files() -> void:
	Profile.save_path = SCRATCH_PROFILE
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	Profile.loaded = false
	Profile.data = {}
	Relics.save_path = SCRATCH_RELICS
	var rf := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	rf.store_string("[]")
	rf.close()
	Relics.loaded = false


func _names(abilities: Array) -> Array:
	return abilities.map(func(a): return a.display_name)


func _rid(pid: String) -> String:
	return Runes.engine_rune_id(pid)


# The hero BEFORE he takes anything — his basic and his class kit — off the one
# kit builder a fight reads, with no lineage and no engine.
func _bare(key: String) -> Array:
	return Classes.opening_kit(key, "", [])


func _base_atk(key: String) -> int:
	return int(Classes.hero_config(key)["attack"])


func _atk_of(key: String, pid: String) -> int:
	var lineage := Classes.engine_spec(pid)
	return Classes.spec_attack(lineage) if lineage != "" else _base_atk(key)


# What a rune adds over the bare kit, in its bar's order, and the bare cards it
# takes away (none, or the class basic). Derived off the kit builder a fight reads.
func _adds(key: String, pid: String) -> Array:
	var own: Array = _names(Classes.opening_kit(key, Classes.engine_spec(pid), [pid]))
	var bare: Array = _names(_bare(key))
	var added: Array = own.filter(func(n): return not bare.has(n))
	var gone: Array = bare.filter(func(n): return not own.has(n))
	return [added, gone]


# The line an ability prints on this screen at `atk`: the name, its damage range
# and scaling, and its description flattened under it. Written out here rather
# than read off the screen, so a screen that prints the wrong figure is caught.
func _render(ab: Ability, atk: int) -> String:
	var line: String = "• %s" % ab.display_name
	if ab.damage > 0:
		var hit: float = ab.damage * 0.01 * atk
		line += " — %d–%d %s dmg (%d%% Atk)" % [int(hit * 0.9), int(round(hit * 1.1)),
			ab.dmg_type.capitalize(), ab.damage]
	return "%s\n   %s" % [line, Classes.resolve_values(ab.description,
		{"attack": atk}).replace("\n", " ")]


func _rule(key: String, pid: String) -> String:
	return Classes.resolve_values(Classes.engine_desc(pid),
		{"attack": _atk_of(key, pid)}).replace("\n", " ")


# The runes of a deal whose hero still holds a kit card that his lineage's Attack
# prints differently — the note must name exactly these.
func _movers(key: String, deal: Array) -> Array:
	var out: Array = []
	var base := _base_atk(key)
	for rid in deal:
		var pid := String(Runes.config(String(rid)).get("engine", ""))
		var atk := _atk_of(key, pid)
		if atk == base:
			continue
		var held: Array = _names(Classes.opening_kit(key, Classes.engine_spec(pid), [pid]))
		for ab in _bare(key):
			if held.has(ab.display_name) and _render(ab, atk) != _render(ab, base):
				out.append(String(rid))
				break
	return out


func _triples(ids: Array) -> Array:
	var out: Array = []
	for i in ids.size():
		for j in range(i + 1, ids.size()):
			for k in range(j + 1, ids.size()):
				out.append([ids[i], ids[j], ids[k]])
	return out


func _live(n: Node) -> bool:
	return n != null and not n.is_queued_for_deletion() \
		and (not (n is CanvasItem) or (n as CanvasItem).is_visible_in_tree())


func _collect(n: Node, cls: String, out: Array) -> void:
	if not _live(n):
		return
	if n.is_class(cls):
		out.append(n)
	for c in n.get_children():
		_collect(c, cls, out)


# Inside a scroll window, so the window clips it and its own rect says nothing
# about the screen.
func _clipped(n: Node) -> bool:
	var p := n.get_parent()
	while p != null:
		if p is ScrollContainer:
			return true
		p = p.get_parent()
	return false


func _inside(n: Node, root_node: Node) -> bool:
	var p := n.get_parent()
	while p != null:
		if p == root_node:
			return true
		p = p.get_parent()
	return false


# ── §0 — WHAT A RUNE ADDS, DERIVED ──────────────────────────────────────────
func _s0_what_a_rune_adds() -> void:
	print("--- GQ §0: what each rune adds over a hero holding no engine ---")
	var none := 0
	var some := 0
	var added_total := 0
	var lineage_less := 0
	# BATCH GS — the runes whose engine needs no card beyond the bare kit.
	var no_travel := 0
	var replaced: Array = []
	for key in SEATS:
		var bare: Array = _names(_bare(key))
		var basic := String(Classes.hero_config(key)["abilities"][0].display_name)
		ok(bare == [basic] + Classes.class_kit_names(key),
			"§0: a %s holding no engine opens with his basic and his class kit (%s)" % [key, str(bare)])
		for pid in Classes.class_engines(key):
			var lineage := Classes.engine_spec(String(pid))
			var ad: Array = _adds(key, String(pid))
			var added: Array = ad[0]
			var gone: Array = ad[1]
			if lineage == "":
				lineage_less += 1
			# BATCH GS §1 — A RUNE ADDS EXACTLY ITS ENGINE'S ENABLERS. This asked
			# "a rune adds something exactly when it carries a lineage", which held
			# while a lineage opened with its whole kit. An engine brings only what
			# it cannot run without now, so six lineages add nothing either: what a
			# rune adds is `engine_enablers` less any the bare kit already holds
			# (the Sharpshooter's is Quick Shot, every Hunter's basic). Compared as
			# sets, read off the enabler table rather than the kit builder, so a
			# lineage card slipping back into an opening kit reds here.
			var travels: Array = Classes.engine_enablers(String(pid)).filter(
				func(n): return not bare.has(n))
			if travels.is_empty():
				no_travel += 1
			var added_set: Array = added.duplicate()
			added_set.sort()
			var travels_set: Array = travels.duplicate()
			travels_set.sort()
			ok(added_set == travels_set,
				"§0: %s adds %s — exactly its engine's enablers outside the bare kit (%s), and nothing else of its lineage (%s)"
					% [pid, str(added), str(travels), lineage])
			# BATCH HB §4 — AND THE PET, WHICH ONE ENGINE DISMISSES. Two kinds of bare
			# card can leave now: the class basic (no engine replaces it since GS)
			# and the kit's Summon Companion, which the Sharpshooter's Lethal Aim
			# dismisses — and only a dismisser may take it. One arm, both lists.
			var dismissed: Array = gone.filter(func(n): return String(n) == Classes.PET_CARD)
			gone = gone.filter(func(n): return String(n) != Classes.PET_CARD)
			ok((gone.is_empty() or gone == [basic])
					and dismissed == ([Classes.PET_CARD] if Classes.dismisses_pet([pid]) else []),
				"§0: the one bare card %s can take away is the class basic, and the pet only where it dismisses it (basic: %s; pet: %s)"
					% [pid, str(gone), str(dismissed)])
			if not gone.is_empty():
				var own: Array = _names(Classes.opening_kit(key, lineage, [pid]))
				ok(not bare.has(own[0]),
					"§0: %s puts its own card in slot 0 where the basic was (%s)" % [pid, own[0]])
				replaced.append("%s: %s for %s" % [pid, own[0], basic])
			if added.is_empty():
				none += 1
			else:
				some += 1
				added_total += added.size()
			print("    %-24s %s" % [Runes.display_name(Runes.config(_rid(String(pid)))),
				"adds nothing" if added.is_empty() else ", ".join(PackedStringArray(added))])
	# BATCH GS — THE RUNES THAT ADD NOTHING ARE THE ONES WHOSE ENGINE NEEDS NO CARD
	# BEYOND THE BARE KIT: the spines and the rule engines (pinned as before), and
	# the lineages whose engine runs on the class basic and kit (the rest).
	ok(none == no_travel and lineage_less == Classes.SPINE_INFO.size() + Classes.RULE_ENGINES.size(),
		"§0: the runes that add nothing are exactly those whose engine needs no card beyond the bare kit — the spines, the rule engines and %d lineages (%d of %d)"
			% [no_travel - lineage_less, none, none + some])
	# THE POSITIVE ARM of the `in place of` clause: without a replacement anywhere,
	# the check on the card that carries one would be vacuous.
	# **BATCH GS §1 — INVERTED, BECAUSE THE REPLACEMENT IS GONE.** No engine replaces
	# the class basic any more (the four overrides are draft cards defined by
	# `Classes.basic_override_ability`), and the `(in place of …)` clause left the
	# screen with them. §1's clause check still runs on every card drawn and now
	# reads "no card carries it", which a screen still printing it would fail;
	# this line asserts the reason that arm can no longer have a positive one.
	ok(replaced.is_empty(), "§0: no rune replaces the class basic — the overrides ended with GS (%s)" % str(replaced))
	print("  %d runes add nothing; %d add %d cards between them; %d replace the class basic: %s"
		% [none, some, added_total, replaced.size(), "; ".join(PackedStringArray(replaced))])


# ── §1–§4, §6 — EVERY DEAL, ON THE REAL SCREEN ──────────────────────────────
func _s1_every_deal() -> void:
	print("--- GQ §1-§4, §6: every deal of every class, drawn ---")
	_run.sim_run = false
	_run.new_run(SEATS, [], "wanderer")
	_run.specs_chosen = false
	_run.active = true
	change_scene_to_file("res://scenes/spec_choice.tscn")
	await Gate.frames(self, 6)
	ok(Gate.scene_name(self) == "SpecChoice", "§1: class selection is on screen (%s)" % Gate.scene_name(self))
	if Gate.scene_name(self) != "SpecChoice":
		return
	var scene: Node = current_scene
	var screens := 0
	var notes_shown := 0
	var notes_owed := 0
	var raised_no_note := 0
	for seat in SEATS.size():
		var key: String = SEATS[seat]
		var six: Array = Classes.class_engines(key).map(func(p): return _rid(String(p)))
		var kit_seen := ""
		for deal in _triples(six):
			for j in _run.party.size():
				_run.party[j]["awakened"] = (j != seat)
			_run.party[seat]["engine_offer"] = (deal as Array).duplicate()
			scene._draw_screen()
			await Gate.frames(self, 4)
			var r: Dictionary = _read_screen(scene, seat, key, deal)
			screens += 1
			if not r.is_empty():
				notes_shown += int(r["note"])
				notes_owed += int(r["owed"])
				raised_no_note += int(r["raised_no_note"])
				if kit_seen == "":
					kit_seen = String(r["kit"])
				ok(String(r["kit"]) == kit_seen,
					"§2: the %s's kit reads the same on every deal (%s)" % [key, str(deal)])
	ok(screens == 80, "§1: every deal of every class was drawn (%d of 80)" % screens)
	# BOTH ARMS OF THE NOTE ARE POPULATED, or the equality above proves nothing.
	ok(notes_owed > 0 and notes_owed < screens,
		"§3: the note is owed on some deals and not others (%d of %d)" % [notes_owed, screens])
	print("  §3: the note shown on %d of %d screens, owed on %d; on %d more a dealt rune moves the hero's Attack and no figure the kit shows"
		% [notes_shown, screens, notes_owed, raised_no_note])
	# §4 — THE SCROLL CENSUS. Printed, not asserted: GQ's brief asked which card
	# scrolls and by how much, and a text that outgrows the window scrolls in it
	# rather than being shrunk.
	var scrolling: Array = []
	for rid in _scroll:
		var s: Array = _scroll[rid]
		if float(s[0]) > float(s[1]):
			scrolling.append("%s by %dpx" % [rid, int(float(s[0]) - float(s[1]))])
	ok(_scroll.size() == 24, "§4: every rune's card was measured (%d of 24)" % _scroll.size())
	print("  §4: CHECKED %d of 24 runes' cards; %d scroll%s" % [_scroll.size(), scrolling.size(),
		(": " + ", ".join(PackedStringArray(scrolling))) if not scrolling.is_empty() else ""])
	var tallest := ""
	var tallest_h := 0.0
	for rid2 in _scroll:
		if float(_scroll[rid2][0]) > tallest_h:
			tallest_h = float(_scroll[rid2][0])
			tallest = String(rid2)
	if tallest != "":
		print("  §4: the tallest card text is %s's at %dpx in a %dpx window" % [tallest, int(tallest_h),
			int(float(_scroll[tallest][1]))])
	# BATCH GS — THE FIT, PRINTED PER CLASS: the lowest line any deal of the class
	# drew, against the 720px screen every one of them was asserted inside.
	for key2 in SEATS:
		if _lowest.has(key2):
			print("  §4: the lowest line on any %s screen ends at %dpx of %d (%s)" % [key2,
				int(float(_lowest[key2][0])), int(SCREEN.y), String(_lowest[key2][1])])


func _read_screen(scene: Node, seat: int, key: String, deal: Array) -> Dictionary:
	var tag := "%s %s" % [key, str(deal)]
	var panels: Array = []
	_collect(scene, "PanelContainer", panels)
	ok(panels.size() == 3, "§1: three cards on the %s screen (%d)" % [tag, panels.size()])
	if panels.size() != 3:
		return {}
	var labels: Array = []
	_collect(scene, "Label", labels)
	var card_top := INF
	var card_bottom := 0.0
	for p in panels:
		card_top = minf(card_top, (p as Control).get_global_rect().position.y)
		card_bottom = maxf(card_bottom, (p as Control).get_global_rect().end.y)
	var bare: Array = _bare(key)
	var base := _base_atk(key)
	var screen_text := PackedStringArray()
	for l in labels:
		screen_text.append(String((l as Label).text))
	var all_text := "\n".join(screen_text)
	var authored := PackedStringArray()

	# ── §1 — THE CARDS ──
	for i in deal.size():
		var rid := String(deal[i])
		var rcfg: Dictionary = Runes.config(rid)
		var pid := String(rcfg.get("engine", ""))
		var lineage := Classes.engine_spec(pid)
		var btn: Button = Gate.bound_button(scene, "_choose", [seat, rid])
		ok(btn != null, "§1: %s — the card for %s keeps its button" % [tag, rid])
		var card: Node = null
		for p2 in panels:
			if btn != null and _inside(btn, p2):
				card = p2
		ok(card != null, "§1: %s — %s's button is on its own card" % [tag, rid])
		if card == null:
			continue
		var card_buttons: Array = []
		_collect(card, "Button", card_buttons)
		ok(card_buttons.size() == 1, "§1: %s — %s's card has exactly one button (%d)"
			% [tag, rid, card_buttons.size()])
		var in_card: Array = labels.filter(func(l): return _inside(l, card))
		var name := Runes.display_name(rcfg)
		var heading: Array = in_card.filter(func(l): return String(l.text) == name)
		var bodies: Array = in_card.filter(func(l): return String(l.text) != name)
		# THE NEGATIVE ANCHOR: the lineage's archetype, or the class word a spine
		# printed in its place, heads no line of the card — beside the rune's own
		# name heading it (the positive arm) and the body being the one other line.
		var old_line: String = String(Classes.SPEC_INFO[lineage].get("archetype", "")) \
			if lineage != "" else "%s engine" % key.capitalize()
		ok(heading.size() == 1 and bodies.size() == 1,
			"§1: %s — %s's card is its name and one body, nothing else (%d labels)" % [tag, rid, in_card.size()])
		ok(in_card.all(func(l): return String(l.text) != old_line),
			"§1: %s — %s's card carries no \"%s\" line under its name" % [tag, rid, old_line])
		if bodies.size() != 1:
			continue
		var body := String(bodies[0].text)
		var rule := _rule(key, pid)
		ok(body.begins_with("Engine: %s" % rule),
			"§1: %s — %s's card opens with its engine rule" % [tag, rid])
		if lineage != "":
			var blurb := String(Classes.SPEC_INFO[lineage].get("blurb", ""))
			ok(blurb == "" or not all_text.contains(blurb),
				"§1: %s — %s's blurb is on no line of the screen" % [tag, rid])
		# WHAT IT ADDS: exactly the derived cards, in the bar's order, and the
		# class basic named as what the first replaces where one does.
		var ad: Array = _adds(key, pid)
		var added: Array = ad[0]
		var gone: Array = ad[1]
		# BATCH HB §4 — A DISMISSED PET IS NOT A REPLACED BASIC: the card says what
		# the hero opens WITHOUT on a line of its own, after what it adds.
		var dismissed: Array = gone.filter(func(n): return String(n) == Classes.PET_CARD)
		gone = gone.filter(func(n): return String(n) != Classes.PET_CARD)
		var parts := PackedStringArray()
		for n in added:
			var part := String(n)
			if not gone.is_empty() and part == String(added[0]):
				part += " (in place of %s)" % String(gone[0])
			parts.append(part)
		var want := "Engine: %s" % rule
		if not parts.is_empty():
			want += "\n\nAlso opens with: %s" % ", ".join(parts)
		if not dismissed.is_empty():
			want += "\n\nOpens without: %s" % ", ".join(PackedStringArray(dismissed))
		ok(body == want, "§1: %s — %s's card reads its rule and what it adds, exactly (%s)"
			% [tag, rid, body.substr(("Engine: %s" % rule).length()).strip_edges()])
		ok(body.contains("(in place of ") == (not gone.is_empty()),
			"§1: %s — %s's card names a replaced basic exactly when it replaces one" % [tag, rid])
		# THE KIT IS ON NO CARD: no ability line, no figure and no bare card's
		# description — beside §2's kit carrying every one of them.
		ok(not body.contains("•") and not body.contains(" dmg ("),
			"§1: %s — %s's card lists no ability and prints no figure" % [tag, rid])
		for ab in bare:
			var desc := Classes.resolve_values(ab.description, {"attack": base}).replace("\n", " ")
			ok(not body.contains(desc),
				"§1: %s — %s's card does not repeat %s" % [tag, rid, ab.display_name])
		# What the card LISTS, read back off it: the added cards and nothing of the
		# kit, the replaced basic appearing only inside its clause.
		var tail := body.substr(("Engine: %s" % rule).length()).strip_edges()
		# BATCH HB — what it ADDS is read up to its "Opens without" line, which
		# `want` above has already held to the dismissed card exactly.
		var without_at := tail.find("Opens without: ")
		var with_tail := (tail.substr(0, without_at) if without_at >= 0 else tail).strip_edges()
		var listed: Array = []
		if with_tail != "":
			for piece in with_tail.substr(with_tail.find(": ") + 2).split(", "):
				listed.append(String(piece).split(" (in place of ")[0])
		ok(listed == added and not bare.any(func(ab3): return listed.has(ab3.display_name)),
			"§1: %s — %s's card lists exactly what it adds and nothing the kit shows (%s)"
				% [tag, rid, str(listed)])
		if tail != "":
			var scrub := tail
			for n2 in added + gone + dismissed:
				scrub = scrub.replace(String(n2), "")
			authored.append(scrub)
		# §4 — the card's window, measured the first time this rune is drawn.
		var scrolls: Array = []
		_collect(card, "ScrollContainer", scrolls)
		if scrolls.size() == 1 and not _scroll.has(rid):
			var sc := scrolls[0] as ScrollContainer
			_scroll[rid] = [(bodies[0] as Control).get_combined_minimum_size().y, sc.size.y]

	# ── §2 — THE KIT, ONCE, BELOW; THE PASSIVE WHERE IT WAS ──
	var outside: Array = labels.filter(func(l): return not panels.any(func(p): return _inside(l, p)))
	var cp: Dictionary = Classes.CLASS_PASSIVES[key]
	var passive := "Class Passive — %s: %s" % [cp["name"], String(cp["desc"]).replace("\n", " ")]
	var pl: Array = outside.filter(func(l): return String(l.text) == passive)
	ok(pl.size() == 1 and (pl[0] as Control).get_global_rect().position.y == 110.0
			and (pl[0] as Control).get_global_rect().end.y <= card_top,
		"§2: %s — the class passive stands where it stood, above the cards" % tag)
	var below: Array = outside.filter(func(l): return (l as Control).get_global_rect().position.y >= card_bottom)
	var cols: Array = below.filter(func(l): return String(l.text).begins_with("• "))
	cols.sort_custom(func(a, b): return (a as Control).get_global_rect().position.x < (b as Control).get_global_rect().position.x)
	var want_cols: Array = bare.map(func(ab): return _render(ab, base))
	var got_cols: Array = cols.map(func(l): return String(l.text))
	ok(got_cols == want_cols,
		"§2: %s — below the cards, the bare kit once, at the figures of a hero with no engine" % tag)
	for ab2 in bare:
		ok(all_text.count("• %s" % ab2.display_name) == 1,
			"§2: %s — %s is listed once on the screen" % [tag, ab2.display_name])
	# The lines between the cards and the kit, read by POSITION rather than by
	# their words: the first introduces the kit, and any after it is the note.
	var others: Array = below.filter(func(l): return not String(l.text).begins_with("• "))
	others.sort_custom(func(a, b): return (a as Control).get_global_rect().position.y < (b as Control).get_global_rect().position.y)
	ok(others.size() >= 1 and String(others[0].text).contains(key.capitalize()),
		"§2: %s — one line introduces the %s's kit (%d lines)" % [tag, key, others.size()])
	if others.size() >= 1:
		authored.append(String(others[0].text))

	# ── §3 — THE NOTE ──
	var movers: Array = _movers(key, deal)
	var notes: Array = others.slice(1)
	ok(notes.size() == (1 if not movers.is_empty() else 0),
		"§3: %s — the note stands exactly when a dealt rune moves a figure the kit shows (%s; %d shown)"
			% [tag, str(movers), notes.size()])
	for nl in notes:
		var nt := String(nl.text)
		authored.append(nt)
		for rid3 in movers:
			var pid3 := String(Runes.config(String(rid3)).get("engine", ""))
			ok(nt.contains(Runes.display_name(Runes.config(String(rid3))))
					and nt.contains("Attack to %d" % _atk_of(key, pid3)),
				"§3: %s — the note names %s and the Attack it sets" % [tag, rid3])
	var raised := 0
	for rid4 in deal:
		var pid4 := String(Runes.config(String(rid4)).get("engine", ""))
		if _atk_of(key, pid4) != base and not movers.has(rid4):
			raised += 1

	# ── §4 — THE FIT ──
	var controls: Array = []
	_collect(scene, "Control", controls)
	var low := 0.0
	for c in controls:
		if c is ColorRect or _clipped(c):
			continue
		low = maxf(low, (c as Control).get_global_rect().end.y)
	ok(low <= SCREEN.y, "§4: %s — the lowest line ends at %dpx, inside the screen" % [tag, int(low)])
	# BATCH GS — kept for the per-class census printed after the deals.
	if low > float((_lowest.get(key, [0.0, ""]) as Array)[0]):
		_lowest[key] = [low, str(deal)]
	for rid5 in deal:
		var b5: Button = Gate.bound_button(scene, "_choose", [seat, String(rid5)])
		if b5 != null:
			ok(Rect2(Vector2.ZERO, SCREEN).encloses(b5.get_global_rect()),
				"§4: %s — %s's button is wholly on screen" % [tag, rid5])

	# ── §6 — THE WORDS THIS SCREEN WRITES ──
	var pron := RegEx.new()
	pron.compile("(?i)\\b(he|his|him|she|her|you|your|party|beast)\\b")
	var eng := RegEx.new()
	eng.compile("(?i)\\b(%s)" % "|".join(PackedStringArray(ENGINE_STEMS)))
	for t in authored:
		ok(pron.search(t) == null, "§6: %s — no pronoun and no retired word in \"%s\"" % [tag, t])
		ok(eng.search(t) == null, "§6: %s — no internal engine name in \"%s\"" % [tag, t])
	return {"kit": "\n".join(PackedStringArray(got_cols)), "note": notes.size(),
		"owed": 1 if not movers.is_empty() else 0, "raised_no_note": 1 if raised > 0 and movers.is_empty() else 0}


# ── §5 — A SPINE IN THE DEAL, PRESSED THROUGH THE REAL BUTTONS ──────────────
# Every hero is dealt a rune with no lineage beside two that carry one. The
# Warrior takes a lineage (the Warden, whose note stands on his screen) and the
# other three the rune with none, so both kinds of card are pressed; the screen
# must move hero by hero and land on the map, each hero holding what he took.
func _s5_a_spine_pressed() -> void:
	print("--- GQ §5: a deal holding a spine, pressed into the map ---")
	_scratch_files()
	Profile.set_flag("run_framing_seen")
	_run.sim_run = false
	_run.new_run(SEATS, [], "wanderer")
	_run.specs_chosen = false
	_run.active = true
	var deals := {
		"warrior": ["engine_momentum", "engine_warden", "engine_berserker"],
		"mage": ["engine_channel", "engine_pyromancer", "engine_cryomancer"],
		"cleric": ["engine_sanctity", "engine_holy", "engine_occultist"],
		"hunter": ["engine_field_kit", "engine_beastmaster", "engine_sharpshooter"],
	}
	var takes := {"warrior": "engine_warden", "mage": "engine_channel",
		"cleric": "engine_sanctity", "hunter": "engine_field_kit"}
	for m in _run.party:
		m["engine_offer"] = (deals[String(m["key"])] as Array).duplicate()
	change_scene_to_file("res://scenes/spec_choice.tscn")
	await Gate.frames(self, 6)
	for i in _run.party.size():
		var ck := String(_run.party[i]["key"])
		ok(Gate.scene_name(self) == "SpecChoice" and Gate.has_text(current_scene, "The %s Awakens" % ck.capitalize()),
			"§5: the %s's screen is up (%s)" % [ck, Gate.scene_name(self)])
		var btn: Button = Gate.bound_button(current_scene, "_choose", [i, takes[ck]])
		ok(btn != null, "§5: the %s's card for %s has a button to press" % [ck, takes[ck]])
		if btn == null:
			return
		btn.emit_signal("pressed")
		await Gate.frames(self, 4)
	var guard := 0
	while Gate.scene_name(self) != "Map" and guard < 600:
		await Gate.frames(self, 1)
		guard += 1
	ok(Gate.scene_name(self) == "Map", "§5: the map follows class selection (%s)" % Gate.scene_name(self))
	for m2 in _run.party:
		var ck2 := String(m2["key"])
		var pid := String(Runes.config(String(takes[ck2])).get("engine", ""))
		ok(bool(m2.get("awakened", false)) and Runes.held_engines(m2) == [pid]
				and String(m2.get("spec", "?")) == Classes.engine_spec(pid),
			"§5: the %s holds %s and the lineage it carries (%s, \"%s\")" % [
				ck2, pid, str(Runes.held_engines(m2)), m2.get("spec", "?")])
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 4)
	_run.active = false


# ── §7 — THE PLAYER'S FILES ─────────────────────────────────────────────────
func _s7_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§7: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§7: %s is byte for byte what it was" % p)
