# BATCH CP §3 — THE MEASUREMENT CK WAS ASKED FOR AND NEVER REPORTED: does the
# computed block's added lines overflow the 258px draft card, and by how much?
#
# CK measured the COLUMN's height (313-389px -> 557-671px against a 388px
# viewport) and it measured `perfect_text`'s width (17 of 193 wrap to two
# rows). It did NOT measure the block's own lines against the card's WIDTH,
# which is the question §3 asks, and the two are different: the column scrolls,
# so height is a comfort cost; the card autowraps, so width is a LINE COUNT
# cost that lands back on the column's height.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_ck_width.gd
extends SceneTree

const CARD_PX := 258.0   # DRAFT_COL_W (296) - 38, the label's own width
const FONT_SIZE := 11    # the block label's font_size override


func _initialize() -> void:
	var font := ThemeDB.fallback_font
	var seen := {}
	# BATCH DY §3: `Classes.CLASS_POOLS` was the second entry in this list and
	# is DELETED. Every name it held is in one of the other three, so the
	# population this gate measures does not shrink.
	for src in [Classes.SPEC_POOLS, Classes.SPEC_DRAFT_POOLS,
			Classes.CLASS_DRAFT_POOLS]:
		for k in src:
			for nm in src[k]:
				seen[nm] = true
	var abilities := 0
	var lines_total := 0
	var over := 0
	var widest := {"px": 0.0, "line": "", "who": ""}
	var over_by: Array = []
	var per_card_lines: Array = []
	for nm in seen:
		var ab := Classes.pool_ability(nm)
		if ab == null:
			continue
		var res := "Rage"
		var block: String = Classes.computed_block(ab, 0, res)
		if block == "":
			continue
		abilities += 1
		var ls := block.split("\n")
		per_card_lines.append(ls.size())
		for line in ls:
			if line.strip_edges() == "":
				continue
			lines_total += 1
			var w: float = font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT,
				-1, FONT_SIZE).x
			if w > widest["px"]:
				widest = {"px": w, "line": line, "who": nm}
			if w > CARD_PX:
				over += 1
				over_by.append("%s | %+.0fpx | %s" % [nm, w - CARD_PX, line])
	var sum := 0
	for n in per_card_lines:
		sum += n
	print("=== CP §3 / CK's MISSING MEASUREMENT: THE COMPUTED BLOCK vs THE 258px CARD ===")
	print("abilities carrying a computed block : %d" % abilities)
	print("block lines measured               : %d" % lines_total)
	print("mean block lines per card          : %.2f" % (float(sum) / maxf(per_card_lines.size(), 1)))
	print("LINES WIDER THAN THE 258px CARD    : %d  (%.1f%%)"
		% [over, 100.0 * over / maxf(lines_total, 1)])
	print("widest line                        : %.0fpx (%+.0f) — %s: %s"
		% [widest["px"], widest["px"] - CARD_PX, widest["who"], widest["line"]])
	if over > 0:
		print("\nEVERY OVERFLOWING LINE, AND BY HOW MUCH:")
		over_by.sort()
		for o in over_by:
			print("   %s" % o)
	else:
		print("\nNOTHING OVERFLOWS: every block line fits the card on one row,")
		print("so the block costs the column its LINE COUNT and no wrapping.")
	quit()
