# BATCH EK — THE ARCHETYPE TAGS, AND THE PROOF THAT THEY DO NOTHING YET.
#
#   §1  COVERAGE — every draft card, every protected core, every rune carries a
#       tag, and the populations are DERIVED from the pools rather than listed
#   §2  THE VOCABULARY — every tag used is one of the six, at most two a card,
#       the first is the primary, and no card carries the same tag twice
#   §3  INERTNESS — no read site consults a tag for anything but display
#   §4  THE NAME SWEEP (BR §1) — no tag word is an ability, a talent node, a
#       status LABEL or a rune name, asserted LIVE so a future card trips it
#   §5  ONE BUILDER — `card_tag_line` is the only place a tag line is composed
#
# **WHY THIS GATE EXISTS AT ALL, GIVEN THE BATCH RULES NOTHING.** A gate
# encodes a ruling, and EK carries two. The first is that the vocabulary is
# SIX MECHANICS rather than six status names — the measurement is in
# `docs/reports/EK.md` §1 and `Classes.CARD_TAGS`'s header, and §2 here pins
# the set so a seventh word cannot arrive without somebody saying so. The
# second is §4's ruling: the tags are MECHANICALLY INERT in this batch by
# decision, not by accident, and **inertness is the one property that decays
# silently** — the day a clause reads a tag count, nothing else in the tree
# would notice.
#
# **§3 IS THE LOAD-BEARING ONE AND IT IS A POPULATION ASSERTION, NOT A GREP
# FOR A SHAPE.** It sweeps every `.gd` in the repo, comment-stripped, for any
# mention of the tag surface, and requires the set of files that name it to be
# EXACTLY the authored set: the two definitions, the one display surface, and
# the two targets that check it. A rule that only forbade `if tag ==` would be
# blind to every other way of reading one.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ek.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	_s1_coverage()
	_s2_vocabulary()
	_s3_inertness()
	_s4_name_sweep()
	_s5_one_builder()
	_g.report(self)


# ── §1 — COVERAGE ───────────────────────────────────────────────────────────
# **THE POPULATION IS `Classes.ability_corpus()` AND NOTHING ELSE, WHICH IS DA
# §3's RULE APPLIED RATHER THAN EXEMPTED.** The first draft of this gate read
# `spec_draft_pool` and `class_draft_pool` to say "every DRAFT card carries a
# tag" — and `check_da` §3 called it, correctly: that fingerprint is the two
# pool accessors, and a gate carrying both is re-deriving the corpus. **The
# exemption was not taken.** The corpus is a SUPERSET of the draft, the boss
# pools and the cores, so a corpus-wide coverage assertion answers the draft
# question and three more besides — `check_do`, `check_dp` and `check_dr` all
# record that needing no exemption is better than having one, and this is the
# fourth time that has been the cheaper answer.
#
# The cores are read through `protected_names`, which is not a pool accessor
# and is the only thing that knows what a spec opens holding.
func _s1_coverage() -> void:
	print("--- EK §1: coverage ---")
	var corpus: Array = Classes.ability_corpus()
	var corpus_missing: Array = []
	for ab in corpus:
		if Classes.card_tags(ab.display_name).is_empty():
			corpus_missing.append(ab.display_name)
	ok(corpus_missing.is_empty(),
		"every ability in the corpus carries a tag (%d without: %s)" % [
			corpus_missing.size(), ", ".join(corpus_missing)])
	print("    the corpus is %d abilities and %d carry a tag" % [
		corpus.size(), corpus.size() - corpus_missing.size()])

	var cores := {}
	for spec in Classes.SPEC_INFO:
		for nm in Classes.protected_names(String(spec)):
			cores[String(nm)] = true
	var core_missing: Array = []
	for nm2 in cores:
		if Classes.card_tags(String(nm2)).is_empty():
			core_missing.append(nm2)
	ok(core_missing.is_empty(),
		"every protected core carries a tag (%d without: %s)" % [
			core_missing.size(), ", ".join(core_missing)])
	print("    the protected cores are %d distinct names" % cores.size())

	# **AND THE TABLE MUST NOT OUTRUN THE CORPUS EITHER.** A row for a name
	# nothing resolves is a tag on a card that does not exist — the shape
	# `CLASS_POOLS` spent eighteen batches in.
	var live := {}
	for ab2 in corpus:
		live[ab2.display_name] = true
	var orphan: Array = []
	for key in Classes.CARD_TAGS:
		if not live.has(String(key)):
			orphan.append(key)
	ok(orphan.is_empty(), "no CARD_TAGS row names an ability outside the corpus (%s)"
		% ", ".join(orphan))
	ok(Classes.CARD_TAGS.size() == corpus.size(),
		"the table and the corpus are the same size (%d / %d)" % [
			Classes.CARD_TAGS.size(), corpus.size()])

	var rune_missing: Array = []
	for rid in Runes.ids():
		if Runes.rune_tags(String(rid)).is_empty():
			rune_missing.append(rid)
	ok(rune_missing.is_empty(), "every authored rune carries a tag (%d without: %s)"
		% [rune_missing.size(), ", ".join(rune_missing)])
	print("    the rune layer is %d authored runes" % Runes.ids().size())
	var rune_orphan: Array = []
	for rk in Runes.RUNE_TAGS:
		if not Runes.ids().has(String(rk)):
			rune_orphan.append(rk)
	ok(rune_orphan.is_empty(), "no RUNE_TAGS row names a rune that is not authored (%s)"
		% ", ".join(rune_orphan))


# ── §2 — THE VOCABULARY ─────────────────────────────────────────────────────
func _s2_vocabulary() -> void:
	print("--- EK §2: the vocabulary ---")
	# BATCH EL §2 — SEVEN. MARK joined and six of the six were renamed; the
	# EQUALITY is what makes an eighth a decision somebody made, which is why
	# it is BUMPED rather than loosened to a `>=` (CV's idiom). **Seven is the
	# stated ceiling** — `Classes.TAG_ORDER`'s header carries the argument.
	ok(Classes.TAG_ORDER.size() == 7, "the vocabulary is seven words (%d)"
		% Classes.TAG_ORDER.size())
	ok(Classes.TAG_INFO.size() == Classes.TAG_ORDER.size(),
		"TAG_INFO and TAG_ORDER hold the same number of words (%d / %d)" % [
			Classes.TAG_INFO.size(), Classes.TAG_ORDER.size()])
	var no_meaning: Array = []
	for t in Classes.TAG_ORDER:
		if Classes.tag_meaning(String(t)) == "":
			no_meaning.append(t)
	ok(no_meaning.is_empty(), "every tag states what it means (%s)" % ", ".join(no_meaning))

	var bad_word: Array = []
	var too_many: Array = []
	var repeated: Array = []
	for key in Classes.CARD_TAGS:
		var t2: Array = Classes.CARD_TAGS[key]
		if t2.size() < 1 or t2.size() > 2:
			too_many.append("%s(%d)" % [key, t2.size()])
		var seen := {}
		for x in t2:
			if not Classes.TAG_ORDER.has(String(x)):
				bad_word.append("%s:%s" % [key, x])
			if seen.has(String(x)):
				repeated.append(key)
			seen[String(x)] = true
	ok(bad_word.is_empty(), "every ability tag is one of the six (%s)" % ", ".join(bad_word))
	ok(too_many.is_empty(), "every ability carries one or two tags (%s)" % ", ".join(too_many))
	ok(repeated.is_empty(), "no ability carries the same tag twice (%s)" % ", ".join(repeated))

	var r_bad: Array = []
	var r_many: Array = []
	var r_rep: Array = []
	for rk in Runes.RUNE_TAGS:
		var rt: Array = Runes.RUNE_TAGS[rk]
		if rt.size() < 1 or rt.size() > 2:
			r_many.append("%s(%d)" % [rk, rt.size()])
		var rseen := {}
		for y in rt:
			if not Classes.TAG_ORDER.has(String(y)):
				r_bad.append("%s:%s" % [rk, y])
			if rseen.has(String(y)):
				r_rep.append(rk)
			rseen[String(y)] = true
	ok(r_bad.is_empty(), "every rune tag is one of the six (%s)" % ", ".join(r_bad))
	ok(r_many.is_empty(), "every rune carries one or two tags (%s)" % ", ".join(r_many))
	ok(r_rep.is_empty(), "no rune carries the same tag twice (%s)" % ", ".join(r_rep))

	# THE PRIMARY IS THE FIRST ELEMENT AND NOTHING ELSE DECIDES IT.
	var wrong_primary: Array = []
	for key2 in Classes.CARD_TAGS:
		var t3: Array = Classes.CARD_TAGS[key2]
		if Classes.card_tag_primary(String(key2)) != String(t3[0]):
			wrong_primary.append(key2)
	ok(wrong_primary.is_empty(), "the primary is the first element on every row (%s)"
		% ", ".join(wrong_primary))

	# **A COUNT IS PRINTED AND NOT ASSERTED.** The spread is a fact about
	# today's corpus and it moves whenever a pool does; the PROPERTY above is
	# what is worth pinning (DX §1).
	var spread := {}
	for t4 in Classes.TAG_ORDER:
		spread[t4] = 0
	for key3 in Classes.CARD_TAGS:
		var p := Classes.card_tag_primary(String(key3))
		spread[p] = int(spread.get(p, 0)) + 1
	var line := ""
	for t5 in Classes.TAG_ORDER:
		line += "%s %d   " % [t5, int(spread[t5])]
	print("    primary spread over %d abilities: %s" % [Classes.CARD_TAGS.size(), line])


# ── §3 — INERTNESS ──────────────────────────────────────────────────────────
# **THE ONE PROPERTY THAT DECAYS SILENTLY.** Every `.gd` in the repo is swept,
# comment-stripped, for any mention of the tag surface, and the set of files
# that name it must be EXACTLY this list. A batch that keys a clause off a tag
# has to move a line here and say why.
const TAG_SURFACE := ["CARD_TAGS", "card_tags", "card_tag_primary",
	"card_tag_line", "TAG_INFO", "TAG_ORDER", "tag_meaning",
	"RUNE_TAGS", "rune_tags", "rune_tag_line"]

# The authored readers, SPLIT IN TWO AT BATCH EL §3 BECAUSE THEY ARE TWO
# DIFFERENT CLAIMS AND ONLY ONE OF THEM IS ABOUT THE GAME.
#
# **EL's BRIEF RULED THAT THIS POPULATION MUST NOT MOVE, AND IT MOVED — BY ONE
# GATE.** `check_el.gd` reads `CARD_TAGS` to derive MARK's population out of
# `battle.DISPEL_NEVER`, so it names the tag surface and lands in the sweep.
# **That is a sixth CHECKER, not a sixth reader**, and rolling the two counts
# into one number is what made the brief's rule impossible to obey without
# either weakening the gate or refusing to write one.
#
# **THE HALF THAT IS A CLAIM ABOUT THE GAME IS PINNED AT THREE AND HAS NOT
# MOVED**: two files DEFINE the tables and one DISPLAYS them. A fourth arriving
# here is a fourth place in the shipped game that knows what a tag is, and that
# is the assertion EK wrote this section for.
const TAG_DEFINERS := ["scripts/classes.gd", "scripts/runes.gd",
	"scripts/map_screen.gd"]

# The half that is a claim about the INSTRUMENTS. A gate reading a tag cannot
# change how the game behaves, so this list grows with the tree — but it is
# still AUTHORED rather than derived from a `check_*.gd` glob, because a
# derived list would bless a gate that started doing something else.
const TAG_CHECKERS := ["check_ek.gd", "check_el.gd", "check_map_screen.gd"]

# The files a MECHANIC would have to live in. Asserted at ZERO separately from
# the set above, because "the set is exactly these five" and "battle.gd holds
# none" fail in different ways and the second is the one that matters.
const NO_TAG_FILES := ["scripts/battle.gd", "scripts/unit.gd",
	"scripts/talents.gd", "scripts/run_state.gd", "scripts/run_sim.gd",
	"scripts/ability.gd"]

func _s3_inertness() -> void:
	print("--- EK §3: inertness ---")
	var found := {}
	var walked := 0
	for path in _all_gd():
		var src := Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
		if src == "":
			continue
		walked += 1
		for word in TAG_SURFACE:
			if src.contains(String(word)):
				found[path] = true
				break
	# **THE SWEEP ASSERTS ITS OWN POPULATION** (EA §5): a walk that read nothing
	# would report a clean tree.
	ok(walked >= 80, "the inertness sweep read a real population (%d .gd files)" % walked)
	var names: Array = found.keys()
	names.sort()
	# THE TWO HALVES FAIL SEPARATELY. A fourth file in the shipped game naming
	# a tag is a different fault from a fourth gate checking one, and reporting
	# them as one number is what stopped this section from being obeyable.
	var in_game: Array = []
	var in_gates: Array = []
	for n in names:
		if String(n).begins_with("check_") or String(n).begins_with("test_"):
			in_gates.append(n)
		else:
			in_game.append(n)
	var def_expected: Array = TAG_DEFINERS.duplicate()
	def_expected.sort()
	var chk_expected: Array = TAG_CHECKERS.duplicate()
	chk_expected.sort()
	ok(in_game == def_expected,
		"exactly three files in the GAME name a tag — found [%s], expected [%s]"
			% [", ".join(in_game), ", ".join(def_expected)])
	ok(in_gates == chk_expected,
		"exactly the authored TARGETS check a tag — found [%s], expected [%s]"
			% [", ".join(in_gates), ", ".join(chk_expected)])
	print("    %d of %d .gd files name the tag surface (%d in the game, %d in the targets)"
		% [names.size(), walked, in_game.size(), in_gates.size()])

	for f in NO_TAG_FILES:
		var body := Gate.strip_comments(FileAccess.get_file_as_string("res://" + f))
		var hits: Array = []
		for w2 in TAG_SURFACE:
			if body.contains(String(w2)):
				hits.append(w2)
		ok(hits.is_empty(), "%s reads no tag (%s)" % [f, ", ".join(hits)])

	# **AND THE DISPLAY SURFACE ONLY DISPLAYS.** `map_screen.gd` may name the
	# builder; it may not branch on a tag or count one.
	var ms := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/map_screen.gd"))
	var reads: int = ms.count("card_tag_line")
	ok(reads == 1, "map_screen builds the line once and reads nothing else (%d)" % reads)
	for w3 in ["CARD_TAGS", "card_tags(", "TAG_INFO", "card_tag_primary"]:
		ok(not ms.contains(String(w3)),
			"map_screen does not reach past the builder for %s" % w3)


func _all_gd() -> Array:
	var out: Array = []
	var stack: Array = ["res://"]
	while not stack.is_empty():
		var dir_path := String(stack.pop_back())
		var d := DirAccess.open(dir_path)
		if d == null:
			continue
		for sub in d.get_directories():
			if sub.begins_with(".") or sub == "assets":
				continue
			stack.append(dir_path + sub + "/")
		for f in d.get_files():
			if f.ends_with(".gd"):
				out.append((dir_path + f).replace("res://", ""))
	out.sort()
	return out


# ── §4 — THE NAME SWEEP (BR §1) ─────────────────────────────────────────────
# **ASSERTED LIVE, NOT RECORDED.** EK renamed two of its six because they
# collided — WARD with the `Ward` chip, TEMPO with the `Tempo` chip and three
# talent nodes — and **EL took TEMPO back by moving the chip, the nodes and the
# LANE instead** (§1). The whole point of either rename is that the collision
# must not come back. A card, node, lane, item, status or rune authored later
# with one of these seven words trips here.
# **BATCH EL §3 — THE POPULATION GREW AND ONE TAG CARRIES NAMED EXEMPTIONS.**
#
# TWO SURFACES WERE ADDED, BOTH BECAUSE EK'S OWN SWEEP MISSED THEM. `_node_names`
# collects `"name"` keys, so a talent LANE — which lives under `"lane"` — was
# invisible: `Tempo` was the Sharpshooter's third lane as well as a chip and
# three nodes, and EL had to free nine more strings than its brief listed. ITEM
# names were absent too, and the pouch button on the map screen renders
# `Defense` — the same screen the draft card's tag line is drawn on.
#
# **AND `MARK` SHIPS WITH FOUR NAMED COLLISIONS, WHICH IS NOT WHAT HAPPENED TO
# WARD AND TEMPO.** Those two named DIFFERENT things wearing one word. Hunter's
# Mark, Quarry's Mark and Mark of the Hunt ARE marks and all three CARRY the
# tag, and the `party_mark` chip reads "Hunter's Mark" for the same reason. The
# exemption is a LIST rather than a skip, so a fifth collision — a new card, a
# node, a rune — still turns this section red.
const CLASH_EXEMPT := {
	"MARK": ["ability:Hunter's Mark", "ability:Mark of the Hunt",
		"ability:Quarry's Mark", "status label:Hunter's Mark"],
	# **DEFENSE MEETS THE DEFENSE POTION, AND THE POUCH BUTTON RENDERS IT ON
	# THE SAME SCREEN.** `map_screen._draw_footer` prints
	# `ITEM_INFO[id][0].replace(" Potion", "")`, so the button reads "Defense"
	# — and `_draw_hero_cards`, twelve hundred lines up in the same file, draws
	# the tag line. **They are never in one visible frame**: the draft is an
	# overlay dimming the map at 0.86 alpha and the pouch is behind it. That is
	# a NARROWER exposure than `Ward` had (a chip and a tag both inside the
	# battle) and a WIDER one than a talent node's, and EL ships it rather than
	# renaming a fourth thing. **An item carries no tag**, so nothing can ever
	# render `DEFENSE` and `Defense` as two labels on one row.
	"DEFENSE": ["item:Defense Potion", "item:defense"],
}

func _s4_name_sweep() -> void:
	print("--- EK §4: the BR §1 name sweep ---")
	var battle_src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var labels: Array = _status_labels(battle_src)
	ok(labels.size() >= 150,
		"the status-label arm read a real population (%d labels)" % labels.size())
	var lanes_seen := {}
	for sp0 in Talents.LANE_TREES:
		for ln in _lane_names(String(sp0)):
			lanes_seen[ln] = true
	ok(lanes_seen.size() >= 30,
		"the lane arm read a real population (%d distinct lanes)" % lanes_seen.size())
	for tag in Classes.TAG_ORDER:
		var word := String(tag).to_lower()
		var clashes: Array = []
		for ab in Classes.ability_corpus():
			if _has_word(ab.display_name.to_lower(), word):
				clashes.append("ability:" + ab.display_name)
		for spec in Talents.LANE_TREES:
			for node_name in _node_names(String(spec)):
				if _has_word(node_name.to_lower(), word):
					clashes.append("node:" + node_name)
			# BATCH EL §3 — THE LANE, WHICH THIS SWEEP COULD NOT SEE.
			for lane_name in _lane_names(String(spec)):
				if _has_word(lane_name.to_lower(), word):
					clashes.append("lane:" + lane_name)
		# BATCH EL §3 — THE ITEMS. `defense` is an item id and the pouch button
		# renders "Defense" on the very screen the tag line is drawn on.
		for iid in Run.ITEM_IDS:
			if _has_word(String(iid).to_lower(), word):
				clashes.append("item:" + String(iid))
			var iname := String((Run.ITEM_INFO[iid] as Array)[0])
			if _has_word(iname.to_lower(), word):
				clashes.append("item:" + iname)
		for sid in BattleUnit.DEBUFF_IDS:
			if _has_word(String(sid).to_lower(), word):
				clashes.append("status:" + String(sid))
		for rid in Runes.ids():
			var cfg: Dictionary = Runes.config(String(rid))
			var rn := String(cfg.get("name", ""))
			if _has_word(rn.to_lower(), word):
				clashes.append("rune:" + rn)
			# BATCH EL §3 — A RUNE CARRIES A LANE TOO, and it is the same hole
			# the talent lane was: the sweep read the NAME and nothing else.
			if _has_word(String(cfg.get("lane", "")).to_lower(), word):
				clashes.append("rune lane:" + String(cfg["lane"]))
		# BATCH EL §3 — THE RELICS. Party-wide, named on their own screen, and
		# `Ironbark Ward` is exactly the shape that made WARD untenable.
		for relic_id in Relics.POOL:
			if _has_word(String(relic_id).to_lower(), word):
				clashes.append("relic:" + String(relic_id))
			var reln := String((Relics.POOL[relic_id] as Dictionary).get("name", ""))
			if _has_word(reln.to_lower(), word):
				clashes.append("relic:" + reln)
		# The STATUS LABEL is the surface a player reads, and it is the half
		# that made WARD and TEMPO untenable. It lives in a const dictionary in
		# `battle.gd`, so it is read out of the source rather than off a class.
		#
		# **BATCH EL §3 REPAIRED THIS ARM AND IT WAS THE WEAKEST ONE IN THE
		# GATE.** It used to ask whether `battle.gd` contained `["Ward",` — an
		# EXACT whole label equal to the capitalised tag. That catches `Ward`
		# and `Tempo`, whose labels ARE the word, and is blind to every label
		# that merely CONTAINS it. `party_mark`'s label is "Hunter's Mark", so
		# under the old arm the MARK sweep reported the status half clean while
		# a chip rendered the word. Every label is extracted now and matched on
		# a word boundary like every other population.
		for lbl in _status_labels(battle_src):
			if _has_word(String(lbl).to_lower(), word):
				clashes.append("status label:" + String(lbl))
		# THE EXEMPTIONS ARE COMPARED AS A SET, NOT SUBTRACTED. A skip would
		# hide a NEW collision behind an old one; an equality means the tag
		# collides with exactly what EL wrote down and nothing else.
		var allowed: Array = (CLASH_EXEMPT.get(String(tag), []) as Array).duplicate()
		allowed.sort()
		clashes.sort()
		ok(clashes == allowed, "the tag %s collides with exactly what EL recorded — found [%s], expected [%s]" % [
			tag, ", ".join(clashes), ", ".join(allowed)])


# BATCH EL §3 — EVERY STATUS LABEL, out of `STATUS_INFO`'s own source block.
# BOUNDED TO THE BLOCK rather than swept over the file, because `battle.gd`
# holds other `"key": ["Label",` dictionaries and a clash reported out of one
# of those would be a clash with something no player reads. The population is
# asserted below (EA §5): a walk that read nothing reports a clean tree.
func _status_labels(src: String) -> Array:
	var out: Array = []
	var start := src.find("const STATUS_INFO := {")
	if start < 0:
		return out
	var body := src.substr(start, src.find("\n}", start) - start)
	var re := RegEx.create_from_string("\n\t\"[a-z0-9_]+\": \\[\"([^\"]+)\",")
	for m in re.search_all(body):
		out.append(m.get_string(1))
	return out


# BATCH EL §3 — LANE NAMES. They live under a `"lane"` key on every node, so
# `_collect_names`'s `"name"` walk never reached one, and `Tempo` sat in nine
# of them while EK's sweep reported the tag clean.
func _lane_names(spec: String) -> Array:
	var seen := {}
	var tree = Talents.LANE_TREES.get(spec, {})
	_collect_lanes(tree, seen)
	return seen.keys()


func _collect_lanes(o, seen: Dictionary) -> void:
	if o is Dictionary:
		for k in o:
			if String(k) == "lane" and o[k] is String:
				seen[String(o[k])] = true
			_collect_lanes(o[k], seen)
	elif o is Array:
		for x in o:
			_collect_lanes(x, seen)


func _node_names(spec: String) -> Array:
	var out: Array = []
	var tree = Talents.LANE_TREES.get(spec, {})
	_collect_names(tree, out)
	return out


func _collect_names(o, out: Array) -> void:
	if o is Dictionary:
		for k in o:
			if String(k) == "name" and o[k] is String:
				out.append(String(o[k]))
			_collect_names(o[k], out)
	elif o is Array:
		for x in o:
			_collect_names(x, out)


# Word-boundary matching, because "Ward" inside "Warden" is not a collision and
# a bare `contains` says it is. The memory this rule comes from is DoD's own:
# "Berserk" inside "Berserker".
func _has_word(hay: String, needle: String) -> bool:
	var i := hay.find(needle)
	while i >= 0:
		var before_ok := i == 0 or not _is_word_char(hay[i - 1])
		var end := i + needle.length()
		var after_ok := end >= hay.length() or not _is_word_char(hay[end])
		if before_ok and after_ok:
			return true
		i = hay.find(needle, i + 1)
	return false


func _is_word_char(c: String) -> bool:
	return c.is_valid_identifier() or c == "_" or (c >= "0" and c <= "9")


# ── §5 — ONE BUILDER ────────────────────────────────────────────────────────
# CK §1's rule, one layer down: a second surface taking tags on must not draw
# them a second way. The separator lives in exactly one function.
func _s5_one_builder() -> void:
	print("--- EK §5: one builder ---")
	ok(Classes.card_tag_line("Fireball") == " · ".join(Classes.card_tags("Fireball")),
		"card_tag_line composes exactly what the table holds")
	ok(Classes.card_tag_line("no such card") == "",
		"a name with no row builds an empty line, not a stray separator")
	var one_tag := ""
	for key in Classes.CARD_TAGS:
		if (Classes.CARD_TAGS[key] as Array).size() == 1:
			one_tag = String(key)
			break
	ok(one_tag != "" and not Classes.card_tag_line(one_tag).contains("·"),
		"a single-tag card carries no separator (%s -> '%s')" % [
			one_tag, Classes.card_tag_line(one_tag)])
	var cs := Gate.strip_comments(
		FileAccess.get_file_as_string("res://scripts/classes.gd"))
	ok(cs.count("\" · \"") == 1,
		"the separator is authored once in classes.gd (%d)" % cs.count("\" · \""))
