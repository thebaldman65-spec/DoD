# BATCH CM — the invariant gate for §1. Walks the WHOLE ability corpus (the
# `check_cl_width` enumeration) and asserts the four things the batch promises
# about the gate, so a later batch extending the set cannot break one silently.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cm.gd
extends SceneTree

const EXPECTED := ["Death Ray", "Requiem", "Reckless Abandon", "Boil Over",
	"Unleash"]
const CEILING := 44


func _initialize() -> void:
	var bad := 0
	var corpus := _corpus()
	var gated: Array = []
	for ab in corpus:
		if ab.gated:
			gated.append(ab.display_name)
	gated.sort()
	var want := EXPECTED.duplicate()
	want.sort()

	print("BATCH CM — THE GATE, CHECKED AGAINST %d ABILITIES" % corpus.size())
	print("  gated: %s" % ", ".join(PackedStringArray(gated)))
	if gated != want:
		print("  FAIL: the gated set is not the five §1 names")
		bad += 1

	# §1's standing rule, and the reason it is a rule rather than a scoping
	# choice: losing a resurrection to a hand slip is the worst outcome the
	# system could produce. Checked over the corpus rather than over the five,
	# so a later batch that gates a sixth cannot gate a heal by accident.
	for ab in corpus:
		if ab.gated and (ab.heal > 0 or ab.special == "resurrection"):
			print("  FAIL: %s heals or revives and is GATED" % ab.display_name)
			bad += 1

	# The tell reaches the draft card, and only the gated cards carry it.
	for ab in corpus:
		var block: String = Classes.computed_block(ab, 0, "Mana")
		if ab.gated != block.contains("GATED"):
			print("  FAIL: %s — computed_block tell disagrees with the flag" %
				ab.display_name)
			bad += 1

	# The draft card's measured ceiling (text-standard §4.8) binds the tell too:
	# it renders in the same 258px column as everything else on the card.
	for line in Classes.GATED_TELL.split("\n"):
		if line.length() > CEILING:
			print("  FAIL: tell line %d chars > %d: %s" % [line.length(),
				CEILING, line])
			bad += 1

	print("check_cm: %d failures" % bad)
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
