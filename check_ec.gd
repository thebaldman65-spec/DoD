# BATCH EC — THE GROUP BOUNDARY THE SWEEP LOST.
#
#   §0  THE POPULATION, ASSERTED BEFORE ANYTHING IS CONCLUDED FROM IT. A sweep
#       that matches nothing reports "no violations" in the same words a clean
#       tree does (EA §1's rule, earned from a probe that read a Dictionary as
#       an Array).
#   §1  NO ASSERTION MIXES `and` AND `or` AT THE BOOLEAN DEPTH. §2's model is
#       two-shaped — a conjunction or an alternation — and that simplification
#       is CHECKED here rather than assumed, so a statement that outgrows it
#       says so instead of being guessed at.
#   §2  EVERY MEMBER OF A CONJUNCTION IS PRESENT, AND EVERY ALTERNATION HAS ONE.
#       This is the boundary itself. The instrument that swept these literals
#       through EA and EB bucketed a whole statement together and satisfied the
#       bucket when ANY member hit — so `contains(A) and contains(B)` passed on
#       A alone, and a check was passing for a reason other than the one it
#       states. A LITERAL CENSUS CANNOT SEE THIS: the same 125 members are read
#       either way, which is why every previous measurement came back clean.
#   §3  THE DISCRIMINATION, PROVED ON SYNTHETIC INPUT. Getting the repair
#       BACKWARDS is worse than the hole: treating every group as a conjunction
#       reds six live alternations on this tree, and a false alarm is how an
#       instrument gets switched off. So the gate proves on hand-built input
#       that it judges the two shapes DIFFERENTLY, in both directions.
#
# WHY THE DEPTH MATTERS, WHICH IS THE WHOLE DEFECT. The operator that joins a
# group sits at the depth of the BOOLEAN EXPRESSION, and every assertion in
# this tree is wrapped in `ok(...)` — so a scan for a top-level `or` finds none
# in any of the 82 files, and the splitter that was meant to model alternation
# had never once fired. It was not mis-tuned; it was unreachable.
#
# §3 CARRIES NO DOCUMENT HOLDER ON PURPOSE. Holders are scoped per FUNCTION, so
# a section that builds synthetic assertion TEXT must not also bind a document
# to a name — this file is swept by its own §2, and the synthetic needles would
# be extracted as if a suite had written them.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ec.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

# The tracked documents, as a `const` rather than a `var`: `check_ea` §3
# sweeps every identifier ASSIGNED from `res://CLAUDE.md`, and a `var` here
# would hand it a holder that reads a Dictionary key rather than a document.
# FIVE SINCE BATCH EF §2. `docs/instrument-rules.md` is the instrument half of
# CLAUDE.md and joined the moment it existed: an instrument's territory is a
# CLAIM (EC §2), and a rules file the suites assert against, left outside the
# sweep, is a population this gate would report clean without ever reading.
const DOCS := {
	"res://CLAUDE.md": "CLAUDE.md",
	"res://docs/instrument-rules.md": "docs/instrument-rules.md",
	"res://docs/master.html": "docs/master.html",
	"res://docs/changelog.html": "docs/changelog.html",
	"res://docs/design-notes.md": "docs/design-notes.md",
}

const ASSERTS := "(?:contains|containsn|begins_with|ends_with|count)"

var _g := Gate.new()
var _docs := {}
var _re_str: RegEx
var _re_fmt: RegEx
var _re_not: RegEx
var _re_op: RegEx
var _re_func: RegEx


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	print("BATCH EC — THE GROUP BOUNDARY")
	for res in DOCS:
		_docs[DOCS[res]] = FileAccess.get_file_as_string(res)
	_re_str = RegEx.create_from_string("\"(?:[^\"\\\\]|\\\\.)*\"|'(?:[^'\\\\]|\\\\.)*'")
	_re_fmt = RegEx.create_from_string("%[-0-9.]*[dsfxv%]")
	_re_not = RegEx.create_from_string("\\bnot\\s+[\\w.\\s]*$")
	_re_op = RegEx.create_from_string("\\b(and|or)\\b")
	_re_func = RegEx.create_from_string("(?m)^func\\s")

	var rows := _sweep()
	_s0_population(rows)
	_s1_shapes(rows)
	_s2_satisfaction(rows)
	_s3_discrimination()
	_g.report(self)


# ── THE EXTRACTOR ───────────────────────────────────────────────────────────

# Blank every string literal, KEEPING ITS LENGTH, before any bracket is
# counted. A `"("` inside a failure message otherwise leaves the depth open and
# glues every statement after it into one, and the literal word ` or ` inside a
# message counts as an alternative that splits an assertion in half.
func _mask(s: String) -> String:
	var out := ""
	var last := 0
	for m in _re_str.search_all(s):
		out += s.substr(last, m.get_start() - last)
		out += " ".repeat(m.get_end() - m.get_start())
		last = m.get_end()
	out += s.substr(last)
	return out


# GDScript continues a statement on a trailing backslash and inside an open
# bracket. A needle broken by a line wrap is invisible to reading and fatal to
# a `contains`, so statements are joined before anything is matched in them.
func _statements(src: String) -> Array:
	var out: Array = []
	var buf := ""
	var depth := 0
	for line in src.split("\n"):
		var s := (line as String)
		while s.ends_with(" ") or s.ends_with("\t"):
			s = s.substr(0, s.length() - 1)
		var cont := s.ends_with("\\")
		if cont:
			s = s.substr(0, s.length() - 1)
		buf += s + " "
		var m := _mask(s)
		depth += m.count("(") + m.count("[") + m.count("{")
		depth -= m.count(")") + m.count("]") + m.count("}")
		if depth < 0:
			depth = 0
		if cont or depth > 0:
			continue
		if buf.strip_edges() != "":
			out.append(buf)
		buf = ""
		depth = 0
	if buf.strip_edges() != "":
		out.append(buf)
	return out


# One region per function body, plus the class-level region before the first
# `func`. GDScript scopes `var` to the function, and `test_batch_bx` rebinds the
# name `master` three times — twice to a STRIPPED copy and once to the raw
# document — so a file-scoped holder map attributes a stripped copy's
# `not contains(...)` to the raw one and reports a violation that is not there.
func _scopes(src: String) -> Array:
	var lines := src.split("\n")
	var starts: Array = []
	for i in lines.size():
		if (lines[i] as String).begins_with("func "):
			starts.append(i)
	if starts.is_empty():
		return [src]
	var out: Array = []
	if starts[0] > 0:
		out.append("\n".join(PackedStringArray(lines.slice(0, starts[0]))))
	for n in starts.size():
		var a: int = starts[n]
		var b: int = starts[n + 1] if n + 1 < starts.size() else lines.size()
		out.append("\n".join(PackedStringArray(lines.slice(a, b))))
	return out


func _holders(scope: String) -> Dictionary:
	var h := {}
	for res in DOCS:
		var re := RegEx.create_from_string(
			"var\\s+([A-Za-z_][A-Za-z0-9_]*)\\s*:?=([^\n]*" +
			(res as String).replace(".", "\\.").replace("/", "/") + "[^\n]*)")
		for m in re.search_all(scope):
			var tail := m.get_string(2)
			# A TRANSFORMED haystack is not this instrument's: `test_batch_bx`
			# reads a stripped copy, and the retired-word sweep owns those.
			if tail.contains(".replace(") or tail.contains("_strip") or tail.contains("substr("):
				continue
			h[m.get_string(1)] = DOCS[res]
	return h


func _unescape(l: String) -> String:
	# ONE LEFT-TO-RIGHT PASS. A chain of `replace` calls that runs `\n` before
	# `\\` turns an ESCAPED BACKSLASH followed by `n` into a real newline, and a
	# suite pinning the two raw characters a source file holds then matches
	# nothing at all.
	var out := ""
	var i := 0
	while i < l.length():
		if l[i] == "\\" and i + 1 < l.length():
			var c := l[i + 1]
			if c == "n":
				out += "\n"
			elif c == "t":
				out += "\t"
			elif c == "r":
				out += "\r"
			elif c == "\\" or c == "\"" or c == "'":
				out += c
			else:
				out += "\\" + c
			i += 2
		else:
			out += l[i]
			i += 1
	return out


# Every call on a holder in one statement, with its offset, its polarity and
# whether the haystack was lowered on the way in.
func _atoms(stmt: String, holders: Dictionary) -> Array:
	var out: Array = []
	for name in holders:
		var re := RegEx.create_from_string(
			"\\b" + (name as String) + "\\b((?:\\s*\\.\\s*\\w+\\s*\\([^()]*\\))*)" +
			"\\s*\\.\\s*" + ASSERTS + "\\s*\\(\\s*\"((?:[^\"\\\\]|\\\\.)*)\"")
		for m in re.search_all(stmt):
			var lit := _unescape(m.get_string(2))
			if _re_fmt.search(lit) != null:
				continue        # a format template, not a literal
			# `not` may sit behind a RECEIVER, not just behind whitespace.
			var pre := stmt.substr(0, m.get_start())
			out.append({
				"pos": m.get_start(),
				"path": holders[name],
				"lit": lit,
				"positive": _re_not.search(pre) == null,
				"lowered": m.get_string(1).contains(".to_lower()"),
			})
	out.sort_custom(func(a, b): return a["pos"] < b["pos"])
	return out


# THE BOUNDARY. The operator that joins a group is the one at the depth of the
# BOOLEAN EXPRESSION — which is one bracket inside the `ok(` every assertion in
# this tree is wrapped in, never at the depth of the statement.
func _shape(stmt: String, atoms: Array) -> String:
	if atoms.size() < 2:
		return "single"
	var masked := _mask(stmt)
	var depth: PackedInt32Array = PackedInt32Array()
	depth.resize(masked.length())
	var d := 0
	for i in masked.length():
		var c := masked[i]
		if c == ")" or c == "]" or c == "}":
			d -= 1
		depth[i] = d
		if c == "(" or c == "[" or c == "{":
			d += 1
	var want := 1 << 30
	for a in atoms:
		var p: int = a["pos"]
		if p < depth.size() and depth[p] < want:
			want = depth[p]
	var saw_and := false
	var saw_or := false
	for m in _re_op.search_all(masked):
		var s: int = m.get_start()
		if s >= depth.size() or depth[s] != want:
			continue
		if m.get_string(1) == "or":
			saw_or = true
		else:
			saw_and = true
	if saw_and and saw_or:
		return "mixed"
	if saw_or:
		return "or"
	if saw_and:
		return "and"
	return "adjacent"


func _present(path: String, lit: String, lowered: bool) -> bool:
	var body: String = _docs.get(path, "")
	if lowered:
		return body.to_lower().contains(lit.to_lower())
	return body.contains(lit)


func _satisfied(a: Dictionary) -> bool:
	return _present(a["path"], a["lit"], a["lowered"]) == bool(a["positive"])


func _sweep() -> Array:
	var dir := DirAccess.open("res://")
	var files: Array = []
	if dir != null:
		for f in dir.get_files():
			if f.ends_with(".gd") and (f.begins_with("check_") or f.begins_with("test_")):
				files.append(f)
	files.sort()
	var rows: Array = []
	for f in files:
		var raw := FileAccess.get_file_as_string("res://" + (f as String))
		var reads := false
		for res in DOCS:
			if raw.contains(res as String):
				reads = true
		if not reads:
			continue
		var src := Gate.strip_comments(raw)
		for scope in _scopes(src):
			var holders := _holders(scope)
			if holders.is_empty():
				continue
			for st in _statements(scope):
				var atoms := _atoms(st, holders)
				if atoms.is_empty():
					continue
				rows.append({"file": f, "stmt": st, "atoms": atoms,
					"shape": _shape(st, atoms)})
	_files_read = files.size()
	return rows


var _files_read := 0


# ── §0 — THE POPULATION ─────────────────────────────────────────────────────
func _s0_population(rows: Array) -> void:
	print("\n§0 — the population this gate reasons over")
	var members := 0
	var readers := {}
	for r in rows:
		members += (r["atoms"] as Array).size()
		readers[r["file"]] = true
	for p in _docs:
		ok((_docs[p] as String).length() > 1000,
			"§0: `%s` read back %d bytes — the gate is testing presence against nothing" % [
				p, (_docs[p] as String).length()])
	ok(_files_read > 60,
		"§0: the sweep read %d suites and gates — the population has moved" % _files_read)
	ok(rows.size() >= 80,
		"§0: only %d asserting statements were found — the extractor has stopped matching" % rows.size())
	ok(members >= 100,
		"§0: only %d asserted members were found — the call regex has stopped matching" % members)
	ok(readers.size() >= 20,
		"§0: only %d files were found asserting against a tracked document" % readers.size())
	print("  %d statements, %d members, %d readers, %d files swept" % [
		rows.size(), members, readers.size(), _files_read])


# ── §1 — THE MODEL IS TWO-SHAPED, AND THAT IS CHECKED ───────────────────────
func _s1_shapes(rows: Array) -> void:
	print("\n§1 — no assertion mixes `and` and `or` at the boolean depth")
	var mixed: Array = []
	var adjacent: Array = []
	for r in rows:
		if r["shape"] == "mixed":
			mixed.append(r)
		elif r["shape"] == "adjacent":
			adjacent.append(r)
	for r in mixed:
		ok(false, "§1: %s joins its literals with BOTH `and` and `or` — §2's two-shaped model cannot judge it: %s" % [
			r["file"], (r["stmt"] as String).substr(0, 140)])
	ok(mixed.is_empty(),
		"§1: every multi-literal assertion is a pure conjunction or a pure alternation")
	for r in adjacent:
		ok(false, "§1: %s holds two literals with no operator between them at the boolean depth: %s" % [
			r["file"], (r["stmt"] as String).substr(0, 140)])
	ok(adjacent.is_empty(),
		"§1: no assertion holds two literals joined by nothing")


# ── §2 — THE BOUNDARY ───────────────────────────────────────────────────────
func _s2_satisfaction(rows: Array) -> void:
	print("\n§2 — a conjunction needs every member; an alternation needs one")
	var conj := 0
	var disj := 0
	var bad: Array = []
	for r in rows:
		var atoms: Array = r["atoms"]
		var shape: String = r["shape"]
		if shape == "or":
			disj += 1
			var any := false
			for a in atoms:
				if _satisfied(a):
					any = true
			if not any:
				bad.append([r, "no member of this alternation holds"])
		else:
			if atoms.size() > 1:
				conj += 1
			for a in atoms:
				if not _satisfied(a):
					bad.append([r, "`%s` must be %s in `%s` and is not" % [
						(a["lit"] as String).substr(0, 90),
						"PRESENT" if a["positive"] else "ABSENT",
						a["path"]]])
	for b in bad:
		ok(false, "§2: %s — %s" % [(b[0] as Dictionary)["file"], b[1]])
	ok(bad.is_empty(), "§2: every asserted group holds the way its operator joins it")
	# THE TWO SHAPES ARE BOTH PRESENT, as floors rather than counts: a tree that
	# grows another alternation must not red this, and a sweep that stops
	# finding either shape has stopped working rather than found a clean tree.
	ok(conj >= 8, "§2: only %d multi-member conjunctions were found — the shape sweep has stopped matching" % conj)
	ok(disj >= 6, "§2: only %d alternations were found — the shape sweep has stopped matching" % disj)
	# RE-POINTED AT BATCH EF §2, WITH THE HAYSTACK AND NOT THE NEEDLE MOVED.
	# Both rules are about how an INSTRUMENT is built, so both went to
	# `docs/instrument-rules.md` when CLAUDE.md was split at the instrument
	# seam. The needles are unchanged word for word: what moved is the file
	# they are asserted against, which is CW's split discipline — every suite
	# whose pin moved is re-pointed in the SAME batch.
	var cm := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(cm.contains("A GROUP OF LITERALS IS EVALUATED AS THE OPERATOR JOINS IT"),
		"§2: docs/instrument-rules.md does not carry the rule this gate enforces")
	ok(cm.contains("AN INSTRUMENT'S TERRITORY IS A CLAIM"),
		"§2: docs/instrument-rules.md does not carry the rule the source-pin census earned")
	print("  %d conjunctions, %d alternations, %d unsatisfied" % [conj, disj, bad.size()])


# ── §3 — THE DISCRIMINATION, ON SYNTHETIC INPUT ─────────────────────────────
# A repair that treats every group as a conjunction reds six live alternations
# on this tree. So the two shapes are proved to be judged DIFFERENTLY, with one
# member deliberately absent, in both directions.
func _s3_discrimination() -> void:
	print("\n§3 — the two shapes are judged differently, proved on built input")
	# THE LIVE MEMBER IS TAKEN OUT OF THE DOCUMENT rather than written here, so
	# it cannot become a third copy of a fact §2 already asserts, and cannot rot
	# into a control armed on a phrase nobody kept. Quotes and backslashes are
	# dropped because the member is spliced back into GDScript SOURCE below.
	var head: String = (_docs["CLAUDE.md"] as String).substr(0, 120)
	head = head.split("\n")[0].replace("\"", "").replace("\\", "").strip_edges()
	var live := head
	var dead := "EC CONTROL " + "— A STRING NO TRACKED DOCUMENT HOLDS"
	var holders := {"doc": "CLAUDE.md"}
	ok(live.length() >= 20 and _present("CLAUDE.md", live, false),
		"§3: the control's LIVE member (%d chars) is not in CLAUDE.md — the control proves nothing" % live.length())
	ok(not _present("CLAUDE.md", dead, false),
		"§3: the control's DEAD member is in CLAUDE.md — the control proves nothing")
	var conj := "\tok(doc.contains(\"" + live + "\") and doc.contains(\"" + dead + "\"), \"m\") "
	var alt := "\tok(doc.contains(\"" + live + "\") or doc.contains(\"" + dead + "\"), \"m\") "
	var ca := _atoms(conj, holders)
	var aa := _atoms(alt, holders)
	ok(ca.size() == 2 and aa.size() == 2,
		"§3: the extractor read %d and %d members out of two two-member statements" % [
			ca.size(), aa.size()])
	ok(_shape(conj, ca) == "and",
		"§3: a conjunction inside `ok(` reads as `%s` — the depth is wrong again" % _shape(conj, ca))
	ok(_shape(alt, aa) == "or",
		"§3: an alternation inside `ok(` reads as `%s` — the depth is wrong again" % _shape(alt, aa))
	var conj_ok := true
	for a in ca:
		if not _satisfied(a):
			conj_ok = false
	var alt_ok := false
	for a in aa:
		if _satisfied(a):
			alt_ok = true
	ok(not conj_ok, "§3: a conjunction with an ABSENT member was judged satisfied — the boundary is open again")
	ok(alt_ok, "§3: an alternation with a PRESENT member was judged unsatisfied — the repair is inverted")
