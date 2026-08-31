# BATCH ED — THE SOURCE-PIN MANIFEST, ENFORCED.
#
#   §0  THE POPULATION, ASSERTED BEFORE ANYTHING IS CONCLUDED FROM IT. A sweep
#       that matches nothing reports "no violations" in the same words a clean
#       tree does (EA §1's rule). The manifest must parse, must agree with its
#       own recorded counts, and must carry no residency this gate cannot read —
#       a class added by a later generator and silently skipped here would be a
#       whole population going unwatched with nothing to say so.
#   §1  EVERY MANIFEST ENTRY STILL RESOLVES THE WAY IT IS RECORDED. This is the
#       half the batch exists for. A code-anchored needle must survive
#       comment-stripping, a comment-resident one must be present in the raw file
#       and ABSENT from the stripped one, a negative one must stay absent, and an
#       ALTERNATION is answered by its group rather than by each member.
#   §2  A PIN ADDED WITHOUT A MANIFEST ENTRY IS CAUGHT. Every literal written
#       into a locator call on a holder bound to a `res://` file must have an
#       entry. What this CANNOT see is written down at §2 itself and in the
#       report, because a fingerprint is only as wide as the population it
#       sweeps (DW §1) and the honest half of such a rule is the half that names
#       its holes.
#   §3  THE COMMENT-RESIDENT PINS ARE COUNTED AND NAMED. A literal that resolves
#       ONLY inside a comment is the one a rewording breaks — the population
#       EB's break came out of — and one comment convention holds up six suites.
#   §4  THE DISCRIMINATION, PROVED ON SYNTHETIC INPUT EVERY RUN. §1 is only worth
#       anything if it can tell the states APART, so it is run against hand-built
#       text whose answer is known, in both directions.
#
# WHY THE MANIFEST IS DERIVED ELSEWHERE. `build_pin_manifest.py` works out WHICH
# file each literal is pinned into, and that needs holder propagation through
# function parameters — `test_batch_bl` reads `battle.gd` in `_run()` and asserts
# on it 536 lines later inside a helper it passed the holder to. This gate needs
# none of that to do its job: it re-reads the named haystack and asks whether the
# recorded claim still holds. ONE analysis, in one place, and an enforcement that
# cannot drift from it because it re-derives nothing.
#
# THIS FILE EXCLUDES ITSELF FROM ITS OWN SWEEP, the way `check_de` does. A gate
# that enumerates pins is a file full of pin-shaped literals, and leaving it in
# would have the instrument grow the population it measures on every run.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ed.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SELF := "check_ed.gd"
const MANIFEST := "res://pin-manifest.json"

# THE LOCATOR NAMES ARE JOINED AT RUNTIME RATHER THAN WRITTEN AS ONE STRING.
# `check_da` §3 learned this the hard way: a gate whose source contains its own
# fingerprint accuses itself on the first run and gets suppressed on the second.
const CALL_PARTS := ["contains", "containsn", "begins_with", "ends_with",
	"count", "find", "rfind", "findn"]

var _g := Gate.new()
var _raw := {}
var _stripped := {}


func ok(cond: bool, msg: String) -> void:
	_g.ok(cond, msg)


func _load(path: String) -> void:
	if _raw.has(path):
		return
	var txt := FileAccess.get_file_as_string("res://" + path)
	_raw[path] = txt
	_stripped[path] = _strip_comments(txt) if path.ends_with(".gd") else txt


# A `#` INSIDE A STRING IS NOT A COMMENT. Treating it as one strips live code and
# reports a code-anchored pin as comment-resident — the exact misreading this
# gate exists to prevent, made by the gate itself. §4 proves it every run.
func _strip_comments(src: String) -> String:
	var out := PackedStringArray()
	for line in src.split("\n"):
		var res := ""
		var i := 0
		var q := ""
		while i < line.length():
			var c := line[i]
			if q != "":
				res += c
				if c == "\\" and i + 1 < line.length():
					res += line[i + 1]
					i += 1
				elif c == q:
					q = ""
			else:
				if c == "#":
					break
				res += c
				if c == "\"" or c == "'":
					q = c
			i += 1
		out.append(res)
	return "\n".join(out)


# A file's text split into function regions, plus whatever precedes the first
# `func` (constants and class-scope holders live there).
func _functions(body: String) -> Array:
	var lines := body.split("\n")
	var starts := []
	for i in lines.size():
		if lines[i].begins_with("func "):
			starts.append(i)
	var out := []
	if starts.is_empty():
		out.append(body)
		return out
	if starts[0] > 0:
		out.append("\n".join(Array(lines).slice(0, starts[0])))
	for n in starts.size():
		var hi: int = starts[n + 1] if n + 1 < starts.size() else lines.size()
		out.append("\n".join(Array(lines).slice(starts[n], hi)))
	return out


func _unescape(quoted: String) -> String:
	var s := quoted.substr(1, quoted.length() - 2)
	var out := ""
	var i := 0
	while i < s.length():
		if s[i] == "\\" and i + 1 < s.length():
			var c := s[i + 1]
			if c == "n":
				out += "\n"
			elif c == "t":
				out += "\t"
			elif c == "r":
				out += "\r"
			elif c == "\\":
				out += "\\"
			elif c == "\"":
				out += "\""
			elif c == "'":
				out += "'"
			else:
				out += "\\" + c
			i += 2
		else:
			out += s[i]
			i += 1
	return out


# ── §0 ──────────────────────────────────────────────────────────────────────
func _s0_population(man: Dictionary) -> Array:
	print("\n§0 — THE POPULATION")
	var pins: Array = man.get("pins", [])
	ok(pins.size() > 0, "the manifest parses and holds %d pins" % pins.size())

	var counts: Dictionary = man.get("counts", {})
	var recorded := int(counts.get("total", -1))
	ok(recorded == pins.size(),
		"...and its recorded total (%d) is the number it actually holds (%d)"
			% [recorded, pins.size()])

	var src := []
	for p in pins:
		if String(p.get("h", "")).ends_with(".gd"):
			src.append(p)
	# A FLOOR, NOT AN EQUALITY (DX §1). This population grows with every batch
	# that authors a suite; an equality fails on the next batch doing its job and
	# the failure reads as a regression.
	ok(src.size() >= 900,
		"%d assertions pin a literal into `.gd` source (floor 900)" % src.size())

	var known := ["code", "comment", "absent", "narrow", "runtime", "alt-sibling",
		"present-but-negated", "unresolved", "missing-file"]
	var unknown := {}
	for p in src:
		var r := String(p.get("r", ""))
		if not known.has(r):
			unknown[r] = true
	ok(unknown.is_empty(),
		"every residency the manifest uses is one this gate reads (%s)"
			% ("none unknown" if unknown.is_empty() else str(unknown.keys())))

	var files := {}
	for p in src:
		files[p.get("h", "")] = true
	ok(files.size() >= 15,
		"...spread over %d source files (floor 15)" % files.size())
	return src


# ── §1 ──────────────────────────────────────────────────────────────────────
func _s1_still_resolves(src: Array) -> void:
	print("\n§1 — EVERY ENTRY STILL RESOLVES AS RECORDED")
	var bad_code := []
	var bad_comment := []
	var bad_absent := []
	var groups := {}
	var unverified := 0

	for p in src:
		var h := String(p.get("h", ""))
		var n = p.get("n", null)
		var r := String(p.get("r", ""))
		var gid := String(p.get("g", ""))
		if r == "runtime" or r == "narrow" or r == "present-but-negated" or n == null:
			unverified += 1
			continue
		_load(h)
		var raw := String(_raw.get(h, ""))
		var strip := String(_stripped.get(h, ""))
		var lit := String(n)
		var where := "%s -> %s: %s" % [p.get("s", ""), h, lit.substr(0, 48)]
		if r == "code":
			if not strip.contains(lit):
				bad_code.append(where)
		elif r == "comment":
			# BOTH HALVES. Present in the raw file AND absent from the stripped
			# one — a pin that migrated OUT of a comment into code is still true
			# and is no longer fragile, and the manifest should stop calling it
			# fragile. Only asking the first half would never notice.
			if not raw.contains(lit) or strip.contains(lit):
				bad_comment.append(where)
		elif r == "absent":
			if raw.contains(lit):
				bad_absent.append(where)
		# AN ALTERNATION IS SATISFIED BY A MEMBER WHOSE OWN CLAIM HOLDS, AND THE
		# CLAIM DEPENDS ON POLARITY. `test_batch_bj` writes
		# `ok(not src.contains(A) or not src.contains(B), ...)` — a group of two
		# NEGATIVES, satisfied when a member is ABSENT. Testing every member for
		# presence reds that check while it is working perfectly.
		if bool(p.get("alt", false)) and gid != "":
			if not groups.has(gid):
				groups[gid] = false
			var holds := (not raw.contains(lit)) if String(p.get("p", "+")) == "-" \
				else raw.contains(lit)
			if holds:
				groups[gid] = true

	ok(bad_code.is_empty(),
		"all code-anchored pins resolve in the comment-stripped source%s"
			% ("" if bad_code.is_empty() else " — BROKEN: " + str(bad_code)))
	ok(bad_comment.is_empty(),
		"all comment-resident pins resolve in a comment and nowhere else%s"
			% ("" if bad_comment.is_empty() else " — MOVED: " + str(bad_comment)))
	ok(bad_absent.is_empty(),
		"all negative pins are still absent%s"
			% ("" if bad_absent.is_empty() else " — NOW PRESENT: " + str(bad_absent)))

	var dead := []
	for gid in groups:
		if not groups[gid]:
			dead.append(gid)
	ok(dead.is_empty(),
		"every alternation has a member that resolves (%d groups)%s"
			% [groups.size(), "" if dead.is_empty() else " — EMPTY: " + str(dead)])

	# NO SILENT CAP. What this section does NOT verify is printed, because a
	# coverage figure nobody states reads as full coverage.
	print("    verified %d of %d source pins; %d carry no static needle "
		% [src.size() - unverified, src.size(), unverified]
		+ "(composed at runtime, or asserted against a slice this gate cannot see)")


# ── §2 ──────────────────────────────────────────────────────────────────────
# WHAT THIS CANNOT SEE, WRITTEN DOWN RATHER THAN DISCOVERED LATER (DW §1):
#   · a holder that reaches its assertion as a FUNCTION PARAMETER — the generator
#     propagates those, this scan is scoped to the function that binds the name;
#   · a needle held in a `for x in [...]` list rather than written at the call;
#   · a needle composed at runtime, where there is no literal to demand.
# It sees the shape a new pin is overwhelmingly written in, and everything it
# sees must be in the manifest. `build_pin_manifest.py --check` is the exact
# authority for the rest and is run before the battery.
func _s2_completeness(man: Dictionary) -> void:
	print("\n§2 — A PIN ADDED WITHOUT AN ENTRY IS CAUGHT")
	var known := {}
	for p in man.get("pins", []):
		var n = p.get("n", null)
		if n != null:
			known["%s %s" % [p.get("s", ""), String(n)]] = true

	var calls := "|".join(CALL_PARTS)
	var lit := "\"(?:[^\"\\\\]|\\\\.)*\"|'(?:[^'\\\\]|\\\\.)*'"
	var re_hold := RegEx.create_from_string("var\\s+(\\w+)\\s*:?=\\s*[^\\n]*\"res://[^\"]*\"")
	var re_inline := RegEx.create_from_string(
		"(?:get_file_as_string|_src|_read)\\s*\\(\\s*\"res://[^\"]*\"\\s*\\)"
		+ "(?:\\s*\\.\\s*\\w+\\s*\\([^()]*\\))*\\s*\\.\\s*(?:" + calls + ")\\s*\\(\\s*(" + lit + ")")

	var names := []
	var dir := DirAccess.open("res://")
	for f in dir.get_files():
		if not f.ends_with(".gd") or f == SELF:
			continue
		if f.begins_with("check_") or f.begins_with("test_"):
			names.append(f)
	names.sort()

	var seen := 0
	var missing := []
	for f in names:
		var body := _strip_comments(FileAccess.get_file_as_string("res://" + f))
		# HOLDERS ARE SCOPED PER FUNCTION, THE WAY THE GENERATOR SCOPES THEM. A
		# file-scoped sweep binds `src` in one function and then reads every
		# `src.contains(...)` in the file as a pin into THAT file — `src` is
		# bound to four different documents across `test_batch_bx` alone — so it
		# demands entries for pins that do not exist and reds on a clean tree.
		for region in _functions(body):
			var holders := {}
			for hm in re_hold.search_all(region):
				holders[hm.get_string(1)] = true
			for hname in holders:
				var re_use := RegEx.create_from_string(
					"\\b" + hname + "\\b(?:\\s*\\.\\s*\\w+\\s*\\([^()]*\\))*\\s*\\.\\s*(?:"
					+ calls + ")\\s*\\(\\s*(" + lit + ")")
				for um in re_use.search_all(region):
					seen += 1
					var needle := _unescape(um.get_string(1))
					if not known.has("%s %s" % [f, needle]):
						missing.append("%s: %s" % [f, needle.substr(0, 40)])
			for im in re_inline.search_all(region):
				seen += 1
				var needle2 := _unescape(im.get_string(1))
				if not known.has("%s %s" % [f, needle2]):
					missing.append("%s: %s" % [f, needle2.substr(0, 40)])

	# THE SWEEP'S OWN POPULATION FIRST. A scan that matched nothing would report
	# zero violations in exactly the words a clean tree does.
	ok(seen >= 800, "the completeness scan reached %d literal pins (floor 800)" % seen)
	ok(missing.is_empty(),
		"every pin the scan can see has a manifest entry%s"
			% ("" if missing.is_empty() else " — UNRECORDED: " + str(missing.slice(0, 8))))


# ── §3 ──────────────────────────────────────────────────────────────────────
func _s3_comment_resident(src: Array) -> void:
	print("\n§3 — THE COMMENT-RESIDENT PINS")
	var res := []
	for p in src:
		if String(p.get("r", "")) == "comment":
			res.append(p)
	var byfile := {}
	for p in res:
		var h := String(p.get("h", ""))
		byfile[h] = int(byfile.get(h, 0)) + 1
	print("    %d pins resolve ONLY inside a comment: %s" % [res.size(), str(byfile)])

	ok(res.size() >= 30,
		"%d source pins are comment-resident and named in the manifest (floor 30)" % res.size())

	# THE CONVENTION THAT HOLDS UP SIX SUITES AT ONCE — worth knowing before
	# anybody tidies those headers.
	var conv := {}
	for p in res:
		var n := String(p.get("n", ""))
		if n.contains("AXIS") or n.contains("SYNERGY"):
			conv[p.get("s", "")] = true
	ok(conv.size() >= 5,
		"the AXIS/SYNERGY comment convention is pinned by %d different suites, "
			% conv.size() + "so one rewording reds them all: %s" % str(conv.keys()))
	ok(byfile.size() >= 3,
		"...and comment-residency spans %d source files" % byfile.size())


# ── §4 ──────────────────────────────────────────────────────────────────────
# THE REPAIR IS DANGEROUS IN THE OPPOSITE DIRECTION TOO. A §1 that cannot tell a
# code-anchored literal from a comment-resident one would either miss the fragile
# pins or red every one of them, and a false alarm is how an instrument gets
# switched off. So the discrimination is proved on input whose answer is known.
func _s4_discrimination() -> void:
	print("\n§4 — THE DISCRIMINATION, ON SYNTHETIC INPUT")
	var synth := "func live() -> void:\n\tvar x := \"IN_CODE\"\n"
	synth += "# a comment saying IN_COMMENT\n\tprint(\"#not a comment\")\n"
	var stripped := _strip_comments(synth)

	ok(stripped.contains("IN_CODE"),
		"a code-anchored literal survives comment-stripping")
	ok(synth.contains("IN_COMMENT") and not stripped.contains("IN_COMMENT"),
		"a comment-resident literal is present raw and gone once stripped")
	ok(not synth.contains("NEVER_WRITTEN") and not stripped.contains("NEVER_WRITTEN"),
		"an absent literal is absent in both")
	# THE HASH INSIDE A STRING IS THE ONE THAT WOULD BREAK IT: read as a comment
	# marker it strips live code and reports a code pin as comment-resident.
	ok(stripped.contains("#not a comment"),
		"a `#` inside a string literal is not read as a comment")


func _initialize() -> void:
	print("check_ed — THE SOURCE-PIN MANIFEST, ENFORCED")
	var man = JSON.parse_string(FileAccess.get_file_as_string(MANIFEST))
	if typeof(man) != TYPE_DICTIONARY:
		printerr("check_ed: pin-manifest.json did not parse")
		quit(1)
		return
	var src := _s0_population(man)
	_s1_still_resolves(src)
	_s2_completeness(man)
	_s3_comment_resident(src)
	_s4_discrimination()
	_g.report(self)
