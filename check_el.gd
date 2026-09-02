# BATCH EL — THE VOCABULARY GETS ITS REAL NAMES, AND MARK IS THE SEVENTH.
#
#   §1  MARK IS DERIVED FROM THE MARKS THE GAME ITSELF NAMES — not from a list
#       written here, and not from the word "mark" appearing in a card's text
#   §2  THE DOCUMENT'S TAG TABLE IS THE CODE'S — `master.html` §6c parsed and
#       required to equal `TAG_ORDER` and `TAG_INFO`, row for row
#   §3  THE WIDEST TAG LINE IS MEASURED HERE AND THE STANDARD QUOTES IT
#
# **WHY THIS GATE EXISTS, GIVEN `check_ek` ALREADY GUARDS THE TAGS.** A gate
# encodes a ruling, and EL carries three that EK's cannot see.
#
# **THE FIRST IS MARK'S POPULATION.** EK named MARK as the strongest seventh
# candidate and sized it at six cards, by reading the six card texts that say
# *"one mark at a time"*. **The game had already written down what its marks
# are, in `battle.DISPEL_NEVER`** — *"the five MARKS the party applies —
# covenant, quarry, snare_line, feinted, hunt_mark"*, with `blood_debt`,
# `vendetta` and `reacquire` named the same way further down — and off that
# list the population is TEN, not six: Covenant of Ash, Snare Line and Feint
# lay marks and say so nowhere in their own text. **The day an eleventh mark
# is authored, nothing else in the tree would notice its card going untagged**,
# and §1 derives the cards LIVE out of `battle.gd`'s apply sites so it does.
#
# **THE SECOND IS THAT `master.html` §6c IS ASSERTED BY NOTHING.** EH proved
# that with a two-armed control: putting a false sentence back into that
# document leaves all five of its readers green. The tag table is the one part
# of §6c that is machine-comparable against the code, and EL renamed every row
# in it — so §2 makes the document's copy a DERIVED one rather than a
# transcribed one.
#
# **THE THIRD IS DJ §3's RULE**: a number quoted from one document into another
# stops being a measurement. `text-standard.html` §4.8a states the widest tag
# line the table can produce, and that number moved when the words did.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_el.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	_s1_mark_population()
	_s2_document_table()
	_s3_widest_line()
	_g.report(self)


# ── §1 — MARK, DERIVED ──────────────────────────────────────────────────────
# **THE STATUS SIDE IS PINNED FROM OUTSIDE; THE CARD SIDE IS DERIVED.** The
# small stable half is the list of mark STATUSES, and it is asserted against
# `battle.DISPEL_NEVER` as a set identity, so a batch adding an eleventh mark
# has to move a line in this file and say why (DW's idiom). The large drifting
# half is WHICH CARD lays which mark, and that is read out of `battle.gd` every
# run rather than written down.
#
# **THE THREE `DISPEL_NEVER` ENTRIES THAT ARE NOT MARKS ARE NAMED BY THE
# COMMENT THAT PUT THEM THERE**, so this is not a second judgement: `ruin_primed`
# is *"the primer rather than the mark"*, `charging` is *"a declared blow, not a
# boon"*, and `spec_passive` is a hero's own passive.
const NOT_A_MARK := ["ruin_primed", "charging", "spec_passive"]

# The two marks that are in NEITHER list, because they are neither dispellable
# buffs nor debuffs — the card clears its own predecessor instead ("one mark at
# a time"), so `Dispel` never had a reason to be told about them.
const MARKS_OUTSIDE_DISPEL_NEVER := ["party_mark", "arcane_echo"]


func _s1_mark_population() -> void:
	print("--- EL §1: MARK is derived, not listed ---")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	# `battle.gd` is a Node2D with no `class_name`, so its consts are reached
	# through the loaded script (check_ct's idiom).
	var battle_gd := load("res://scripts/battle.gd")

	# --- the mark statuses, out of the game's own list ---
	var marks := {}
	for sid in battle_gd.DISPEL_NEVER:
		if not NOT_A_MARK.has(String(sid)):
			marks[String(sid)] = true
	for extra in MARKS_OUTSIDE_DISPEL_NEVER:
		marks[String(extra)] = true
	ok(battle_gd.DISPEL_NEVER.size() == 11,
		"DISPEL_NEVER still holds eleven ids — eight marks and three that are not (%d)"
			% battle_gd.DISPEL_NEVER.size())
	ok(marks.size() == 10, "the game names ten marks (%d: %s)" % [
		marks.size(), ", ".join(marks.keys())])
	var absent: Array = []
	for m in marks:
		if not bsrc.contains("_apply_status(") or not bsrc.contains('"%s"' % m):
			absent.append(m)
	ok(absent.is_empty(), "every mark status is still written somewhere (%s)"
		% ", ".join(absent))

	# --- the CARDS, derived out of the apply sites ---
	var owners := {}
	var unowned: Array = []
	for m2 in marks:
		var sites: Array = _apply_sites(bsrc, String(m2))
		if sites.is_empty():
			unowned.append(String(m2))
			continue
		for at in sites:
			var card := _owning_card(bsrc, int(at))
			if card == "":
				unowned.append("%s@%d" % [m2, at])
			else:
				owners[card] = true
	ok(unowned.is_empty(),
		"every mark's apply site resolves to a card (%s)" % ", ".join(unowned))
	print("    %d cards lay a mark: %s" % [owners.size(),
		", ".join(_sorted(owners.keys()))])
	# **THE SWEEP ASSERTS ITS OWN POPULATION** (EA §5): a back-walk that
	# resolved nothing would report a clean tree.
	ok(owners.size() >= 10, "the derivation reached a real population (%d cards)"
		% owners.size())

	# --- and the table must agree, in both directions ---
	var untagged: Array = []
	for c in owners:
		if not Classes.card_tags(String(c)).has("MARK"):
			untagged.append(String(c))
	ok(untagged.is_empty(),
		"every card that lays a mark carries MARK (%s)" % ", ".join(untagged))
	var stray: Array = []
	for key in Classes.CARD_TAGS:
		if (Classes.CARD_TAGS[key] as Array).has("MARK") and not owners.has(String(key)):
			stray.append(String(key))
	ok(stray.is_empty(),
		"no card carries MARK without laying one (%s)" % ", ".join(stray))

	# **EIGHT LEAD WITH IT AND TWO DO NOT, AND THAT IS THE RULING.** Snare Line
	# marks the whole FIELD rather than one enemy and Feint marks on one of its
	# two stance branches, so both keep the primary they were given — see
	# `docs/reports/EL.md` §2. Asserted as a PROPERTY of those two by name,
	# because "eight" is a count that moves the moment an eleventh mark lands.
	for pair in [["Snare Line", "DEBUFF"], ["Feint", "BREAK"]]:
		var t: Array = Classes.card_tags(String(pair[0]))
		ok(t.size() == 2 and String(t[0]) == String(pair[1]) and String(t[1]) == "MARK",
			"%s keeps its primary and carries MARK second (%s)" % [pair[0], str(t)])
	var lead := 0
	for c2 in owners:
		if Classes.card_tag_primary(String(c2)) == "MARK":
			lead += 1
	print("    %d of %d lead with MARK" % [lead, owners.size()])


# Every character offset at which `battle.gd` applies this status.
func _apply_sites(src: String, sid: String) -> Array:
	var out: Array = []
	var needle := '_apply_status('
	var i := src.find(needle)
	while i >= 0:
		var line_end := src.find("\n", i)
		if line_end < 0:
			line_end = src.length()
		if src.substr(i, line_end - i).contains('"%s"' % sid):
			out.append(i)
		i = src.find(needle, i + 1)
	return out


# **THE BACK-WALK, AND IT LOOKS FOR TWO ANCHORS BECAUSE THERE ARE TWO SHAPES.**
# A card resolves either through an arm of `_resolve_special` (`"quarrys_mark":`)
# or through a block keyed on its own name in the hero strike loop
# (`ab.display_name == "Blood Debt"`), and EK's own header records that the
# second shape is where Blood Debt's entire payload lives. The NEAREST of the
# two wins, because a display_name block sits inside a function that a special
# arm may also appear above.
func _owning_card(src: String, at: int) -> String:
	var name_re := RegEx.create_from_string('ab\\.display_name == "([^"]+)"')
	var arm_re := RegEx.create_from_string('\\n\\t\\t"([a-z0-9_]+)":\\n')
	var best := -1
	var card := ""
	for m in name_re.search_all(src.substr(0, at)):
		if m.get_start() > best:
			best = m.get_start()
			card = m.get_string(1)
	for m2 in arm_re.search_all(src.substr(0, at)):
		if m2.get_start() > best:
			best = m2.get_start()
			card = _card_for_special(m2.get_string(1))
	return card


# A `special` key back to the ability that carries it. DERIVED off the corpus,
# so a card re-homed to another pool still resolves.
func _card_for_special(special: String) -> String:
	for ab in Classes.ability_corpus():
		if String(ab.special) == special:
			return String(ab.display_name)
	return ""


func _sorted(a: Array) -> Array:
	var b: Array = a.duplicate()
	b.sort()
	return b


# ── §2 — THE DOCUMENT'S TABLE IS THE CODE'S ─────────────────────────────────
# **`master.html` §6c IS THE ONE PLACE THE PLAYER-FACING VOCABULARY IS WRITTEN
# OUT IN FULL, AND EH PROVED THAT DOCUMENT IS ASSERTED BY NOTHING.** The table
# is machine-comparable, so it is compared: same words, same order, same
# meanings. A row that drifts here is the exact fault EH found sitting for
# nineteen batches.
func _s2_document_table() -> void:
	print("--- EL §2: master.html §6c is the code's table ---")
	var doc := FileAccess.get_file_as_string("res://docs/master.html")
	var start := doc.find("6c. ARCHETYPE TAGS")
	ok(start > 0, "master.html still carries a §6c ARCHETYPE TAGS section")
	if start <= 0:
		return
	var t0 := doc.find("<tr><th>Tag</th><th>What it means</th></tr>", start)
	ok(t0 > 0, "§6c still carries the tag table")
	if t0 <= 0:
		return
	var t1 := doc.find("</table>", t0)
	var body := doc.substr(t0, t1 - t0)
	var re := RegEx.create_from_string("<tr><td><b>([A-Z]+)</b></td><td>([^<]+)</td></tr>")
	var words: Array = []
	var means := {}
	for m in re.search_all(body):
		words.append(m.get_string(1))
		means[m.get_string(1)] = m.get_string(2)
	ok(words.size() == Classes.TAG_ORDER.size(),
		"the document lists as many tags as the code (%d / %d)" % [
			words.size(), Classes.TAG_ORDER.size()])
	ok(words == Classes.TAG_ORDER,
		"the document's tags are the code's, in order — doc [%s], code [%s]" % [
			", ".join(words), ", ".join(Classes.TAG_ORDER)])
	var wrong: Array = []
	for w in Classes.TAG_ORDER:
		var doc_line := String(means.get(String(w), ""))
		if doc_line != Classes.tag_meaning(String(w)):
			wrong.append("%s: doc '%s' vs code '%s'" % [
				w, doc_line, Classes.tag_meaning(String(w))])
	ok(wrong.is_empty(), "every meaning is the code's, word for word (%s)"
		% "; ".join(wrong))

	# **AND THE FIVE RETIRED WORDS ARE GONE FROM THE SECTION.** `master.html`
	# shows only what is currently in the game (the standing user rule), so a
	# retired tag word surviving in §6c is that rule broken. The scope is §6c
	# alone and the words are matched in the CAPITALISED form the table uses —
	# a sweep of the whole document would fire on ordinary prose, and one over
	# `docs/changelog.html` would fire on the entry recording the rename, which
	# is the entry doing its job.
	var s6c := doc.substr(start, doc.find("<h3>6.1", start) - start)
	for retired in ["AFFLICTION", "SHELTER", "METER", "AMP", "CLOCK"]:
		ok(not s6c.contains(String(retired)),
			"§6c no longer names the retired tag %s" % retired)


# ── §3 — THE WIDEST LINE IS MEASURED HERE ───────────────────────────────────
# **DJ §3: A NUMBER QUOTED FROM ONE DOCUMENT INTO ANOTHER STOPS BEING A
# MEASUREMENT.** `text-standard.html` §4.8a rules that the 44-character ceiling
# does not bind a tag line, and supports it with the arithmetic — which moved
# when the words did. The measurement is taken here and the document is
# required to state it.
func _s3_widest_line() -> void:
	print("--- EL §3: the widest tag line ---")
	var longest := ""
	for t in Classes.TAG_ORDER:
		if String(t).length() > longest.length():
			longest = String(t)
	# The widest the TABLE COULD produce: the two longest distinct words.
	var lens: Array = []
	for t2 in Classes.TAG_ORDER:
		lens.append(String(t2).length())
	lens.sort()
	lens.reverse()
	var possible: int = int(lens[0]) + 3 + int(lens[1])
	# The widest it ACTUALLY produces, over the live table.
	var widest := ""
	for key in Classes.CARD_TAGS:
		var line := Classes.card_tag_line(String(key))
		if line.length() > widest.length():
			widest = line
	print("    longest word '%s' (%d); widest possible %d; widest produced '%s' (%d)" % [
		longest, longest.length(), possible, widest, widest.length()])
	ok(widest.length() <= possible,
		"the widest produced line is inside the widest possible (%d / %d)" % [
			widest.length(), possible])
	ok(possible < 44,
		"the widest possible tag line is under the 44-character ceiling (%d)" % possible)

	var std := FileAccess.get_file_as_string("res://docs/text-standard.html")
	ok(std.contains("<code>%s</code> at %d characters" % [longest, longest.length()]),
		"§4.8a states the live longest word (%s at %d)" % [longest, longest.length()])
	# ONE ARM, NOT TWO. A second `or` arm is a second way to pass, and the one
	# that never fires is invisible — EL's own §3 is a report about exactly
	# that shape (`instrument branch that never fires`).
	ok(std.contains("can produce is %d characters</b>" % possible),
		"§4.8a states the live widest possible line (%d)" % possible)
