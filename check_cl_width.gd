# BATCH CL — the width report §1 asks for. Measures RENDERED lines (tokens
# expanded) against the standard's measured 44-character ceiling, for the real
# heroes rather than a made-up unit, and reports the count and the widest line.
# Ship it, then measure what overflows, then fix only those.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cl_width.gd
extends SceneTree

const CEILING := 44


func _initialize() -> void:
	# The four class bases, so a percentage resolves against a real maximum
	# health rather than a round number that flatters the count.
	var ctxs: Array = []
	for key in ["warrior", "mage", "cleric", "hunter"]:
		var cfg := Classes.hero_config(key)
		var ctx := Classes.value_ctx_from_config(cfg, {"hp": int(cfg["max_hp"] * 0.7)})
		ctxs.append(ctx)

	var worst := {"n": 0, "line": "", "who": ""}
	var over := {}          # field -> overflowing RENDERED lines
	var over_authored := {}  # field -> overflowing lines BEFORE resolution
	var total := {}
	# Lines the parenthetical alone pushed over: the number §1 actually asks for.
	var caused: Array = []
	for entry in _corpus():
		var who: String = entry[0]
		var field: String = entry[1]
		var raw: String = entry[2]
		if raw == "":
			continue
		# Authored width is ctx-independent, so it is counted once.
		var bare: String = Classes.resolve_values(raw, {})
		if field == "perfect_text":
			bare = "Perfect: " + bare
		for line in bare.split("\n"):
			if line.length() > CEILING:
				over_authored[field] = int(over_authored.get(field, 0)) + 1
		for ctx in ctxs:
			var rendered: String = Classes.resolve_values(raw, ctx)
			# `perfect_text` is rendered behind a "Perfect: " label every
			# surface supplies itself, so it is measured wearing it.
			if field == "perfect_text":
				rendered = "Perfect: " + rendered
			var rl: PackedStringArray = rendered.split("\n")
			var bl: PackedStringArray = bare.split("\n")
			for i in rl.size():
				total[field] = int(total.get(field, 0)) + 1
				if rl[i].length() > CEILING:
					over[field] = int(over.get(field, 0)) + 1
					if rl[i].length() > int(worst["n"]):
						worst = {"n": rl[i].length(), "line": rl[i], "who": who}
					# Over only AFTER resolution: the parenthetical caused it.
					if i < bl.size() and bl[i].length() <= CEILING \
							and not caused.has(who):
						caused.append(who)

	print("BATCH CL — RENDERED WIDTH AGAINST THE %d-CHARACTER CEILING" % CEILING)
	for field in total:
		print("  %-14s %4d rendered lines · %d over rendered · %d over ALREADY (authored)" % [
			field, int(total[field]), int(over.get(field, 0)),
			int(over_authored.get(field, 0)) * ctxs.size()])
	print("  WIDEST: %d chars — %s" % [int(worst["n"]), worst["who"]])
	print("          %s" % worst["line"])
	print("  PUSHED OVER BY THE PARENTHETICAL ALONE: %d abilities%s" % [
		caused.size(), "" if caused.is_empty() else " — " + ", ".join(caused)])
	# passive_desc is measured separately: it does not render on the 258px draft
	# card at all, so the 44 ceiling is not its budget. Reported for the record.
	var pd_worst := 0
	for spec in Classes.SPEC_INFO:
		var pd := Classes.resolve_values(
			String(Classes.SPEC_INFO[spec]["passive_desc"]), ctxs[0])
		for line in pd.split("\n"):
			pd_worst = maxi(pd_worst, line.length())
	print("  passive_desc widest authored line: %d chars (not draft-card text;" % pd_worst)
	print("          soft-wrapped on the sheet, hand-wrapped for the chip tooltip)")
	quit(0)


# EVERY ability, not the ones that happen to be in a kit. The kits and spec
# cores are a minority of the corpus — most of the 204 live in the draft POOLS,
# and a width report that measured only the kits would be measuring a fifth of
# the game and reporting it as all of it.
func _corpus() -> Array:
	var out: Array = []
	var seen := {}
	var add := func(ab):
		if ab == null or seen.has(ab.display_name):
			return
		seen[ab.display_name] = true
		out.append([ab.display_name, "description", ab.description])
		out.append([ab.display_name, "perfect_text", ab.perfect_text])
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
