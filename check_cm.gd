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


# BATCH CZ §0 — THE ENUMERATION IS `Classes.ability_corpus()` NOW, AND THIS
# GATE NO LONGER CARRIES A COPY OF IT. The copy it used to carry was the Batch
# CL walk, which reaches the kits, the class pools and the spec pools and MISSES
# the five abilities a talent node grants into no pool at all (Backdraft,
# Pyroblast, Glacial Prison, Cryoclasm, Intercession). Four gates held four
# copies of the same hole; there is one enumeration now and it reaches 216.
func _corpus() -> Array:
	return Classes.ability_corpus()
