# BATCH CN — the invariant gate. Walks the WHOLE ability corpus (the Batch CL
# enumeration, as check_cm.gd does) and asserts what CN promises: the profile
# is today's numbers, the criterion agrees with what the game actually
# resolves, and no card advertises a Perfect it can no longer run.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cn.gd
extends SceneTree

const CEILING := 44

# §1's default IS today's bar. If a later batch edits these it changes every
# check in the game at once, which is the point of asserting them here rather
# than trusting the dictionary to be read.
const WANT_PROFILE := {
	"perfect_half": 0.045, "good_half": 0.16, "centre": 0.5,
	"sweep_time": 0.72, "presses": 1,
}


func _initialize() -> void:
	var bad := 0
	var corpus := _corpus()
	var battle := load("res://scripts/battle.gd")
	var prof: Dictionary = battle.SC_PROFILE_DEFAULT

	print("BATCH CN — %d ABILITIES" % corpus.size())

	# §1 — the default profile carries today's five numbers and no others.
	for k in WANT_PROFILE:
		if not prof.has(k) or not is_equal_approx(float(prof[k]), float(WANT_PROFILE[k])):
			print("  FAIL: default profile %s = %s, want %s" % [
				k, prof.get(k, "<missing>"), WANT_PROFILE[k]])
			bad += 1
	if prof.size() != WANT_PROFILE.size():
		print("  FAIL: default profile has %d fields, want %d" % [
			prof.size(), WANT_PROFILE.size()])
		bad += 1

	# §1'S CENTRAL PROMISE, ASSERTED RATHER THAN ARGUED: the default profile
	# draws the bar the game drew before CN, to the pixel. The right-hand side
	# is the PRE-CN formula copied verbatim out of `_build_skill_check_ui`
	# (`8 + (0.5 - HALF) * SC_TRACK_W`, `HALF * 2 * SC_TRACK_W`); the left is
	# what `_apply_sc_profile` computes from `centre` and the half-widths. They
	# are different expressions on purpose — matching them is the check.
	var track: float = battle.SC_TRACK_W
	for pair in [["good_half", float(prof["good_half"])],
			["perfect_half", float(prof["perfect_half"])]]:
		var half: float = pair[1]
		var lo: float = clampf(float(prof["centre"]) - half, 0.0, 1.0)
		var hi: float = clampf(float(prof["centre"]) + half, 0.0, 1.0)
		var got_x := 8.0 + lo * track
		var got_w := (hi - lo) * track
		var want_x: float = 8.0 + (0.5 - half) * track
		var want_w: float = half * 2.0 * track
		if not is_equal_approx(got_x, want_x) or not is_equal_approx(got_w, want_w):
			print("  FAIL: %s zone is (%.3f w %.3f), pre-CN drew (%.3f w %.3f)" % [
				pair[0], got_x, got_w, want_x, want_w])
			bad += 1

	# And the grader: the same three numbers, so a marker landing at a given
	# position earns the grade it earned before the profile existed.
	for pos in [0.5, 0.5 + 0.045, 0.5 - 0.045, 0.5 + 0.046, 0.5 + 0.16,
			0.5 + 0.161, 0.0, 1.0]:
		var dist: float = absf(pos - float(prof["centre"]))
		var got := "fail"
		if dist <= float(prof["perfect_half"]):
			got = "perfect"
		elif dist <= float(prof["good_half"]):
			got = "good"
		var want := "fail"
		var d0: float = absf(pos - 0.5)
		if d0 <= 0.045:
			want = "perfect"
		elif d0 <= 0.16:
			want = "good"
		if got != want:
			print("  FAIL: marker at %.3f grades %s, pre-CN graded %s" % [
				pos, got, want])
			bad += 1

	# §3 — THE ORPHAN GATE, and it is the one that matters on screen. CK taught
	# the draft card to render Perfect, so a `perfect_text` on an ability that
	# runs no check advertises a bonus that can never fire.
	var no_check: Array = []
	for ab in corpus:
		if ab.runs_skill_check():
			continue
		no_check.append(ab.display_name)
		if ab.perfect_text != "" or ab.perfect_id != "":
			print("  FAIL: %s runs no check and still carries a Perfect" %
				ab.display_name)
			bad += 1

	# §2 — the criterion's own claim: nothing that resolves damage or Break
	# damage may lose its bar. Read off the ability's own fields, which is the
	# half of the criterion that needs no table.
	for ab in corpus:
		if ab.runs_skill_check():
			continue
		if ab.damage > 0 or ab.pressure > 0 or ab.heal > 0:
			print("  FAIL: %s has damage/BD/heal and lost its check" %
				ab.display_name)
			bad += 1

	# §2's gate clause. A Sloppy on a gated ability loses the cast, so a gated
	# ability that runs no check would have a flag nothing can ever read.
	for ab in corpus:
		if ab.gated and not ab.runs_skill_check():
			print("  FAIL: %s is GATED and runs no check" % ab.display_name)
			bad += 1

	# The tables name handlers, and a handler that stops existing would leave a
	# name behind that quietly re-grants a bar. Checked against the specials the
	# corpus actually uses.
	var used := {}
	for ab in corpus:
		if ab.special != "":
			used[ab.special] = true
	for sp in Ability.DAMAGE_SPECIALS + Ability.HEAL_SPECIALS:
		if not used.has(sp):
			print("  WARN: table names `%s`, which no drafted ability uses" % sp)

	# text-standard §4.8: the measured draft-card ceiling still binds every
	# description §3 rewrote.
	for ab in corpus:
		for line in ab.description.split("\n"):
			if line.length() > CEILING:
				print("  FAIL: %s — description line %d > %d: %s" % [
					ab.display_name, line.length(), CEILING, line])
				bad += 1

	no_check.sort()
	print("  runs no check: %d of %d" % [no_check.size(), corpus.size()])
	print("  " + ", ".join(PackedStringArray(no_check)))
	print("check_cn: %d failures" % bad)
	quit(1 if bad > 0 else 0)


# The Batch CL enumeration, returning the Ability objects themselves.
func _corpus() -> Array:
	var out: Array = []
	var seen := {}
	var add := func(ab):
		if ab == null or seen.has(ab.display_name):
			return
		seen[ab.display_name] = true
		out.append(ab)
	for key in ["warrior", "mage", "cleric", "hunter"]:
		for ab in Classes.kit(key):
			add.call(ab)
		for nm in Classes.class_pool(key):
			add.call(Classes.pool_ability(String(nm)))
		for nm in Classes.class_draft_pool(key):
			add.call(Classes.pool_ability(String(nm)))
	for spec in Classes.SPEC_INFO:
		for ab in Classes.spec_abilities(spec):
			add.call(ab)
		for nm in Classes.spec_pool(spec):
			add.call(Classes.spec_pool_ability(spec, String(nm)))
		for nm in Classes.spec_draft_pool(spec):
			add.call(Classes.spec_pool_ability(spec, String(nm)))
	return out
