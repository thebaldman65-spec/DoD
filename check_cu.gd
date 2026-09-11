# BATCH CU — THE TALENT AUDIT'S INSTRUMENT. Read-only: it asserts nothing and
# changes nothing, because CU is a REPORT batch. It exists so the audit in
# `docs/talent-audit.html` can be RE-RUN rather than trusted.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cu.gd 2>&1 | grep -cE "Parse Error|SCRIPT ERROR"
#
# TWO PASSES, and the second is the one that found four of the six bucket-1
# items:
#
#   1. DUMP every node of the tree, from the LIVE `Talents.TREE` — the ONE tree
#      since BATCH FX; the twelve spec trees this used to dump are deleted —
#      and through `Talents.desc_for`, the same function the tooltip calls, so
#      the audit reads what the player reads rather than a hand-parse of
#      talents.gd. Set DOD_DUMP to a path to write the JSON.
#
#   2. ASK THE LIVE ABILITY OBJECTS whether they still run a skill-check bar.
#      Four nodes advertise a Perfect on an ability CN took the bar off, and
#      NO amount of reading talents.gd could have shown that: the claim is in
#      the node, the refutation is in `Ability.runs_skill_check()`. This is
#      the brief's "if a node cannot be audited without running it, run it".
#      Since FX the names are DERIVED from the one tree (`_named_by_tree`)
#      rather than typed, and under the designer's line it names none.
extends SceneTree

# BATCH FX — `NAMED`, the hand list of the thirty-seven abilities the 324 nodes
# of the twelve spec trees named, is DELETED: every node it was read off went
# with the trees. Pass 2 asks the ONE tree instead, and derives the names:
# every ability a node's payload names (an edit, a grant) plus every corpus
# name its rendered text carries on word boundaries.
func _named_by_tree() -> Array:
	var corpus: Array = []
	for ab in Classes.ability_corpus():
		corpus.append(String(ab.display_name))
	var named: Array = []
	for n in Talents.tree():
		var pay: Dictionary = n.get("payload", {})
		for key in ["ability", "grant_ability"]:
			if pay.has(key) and not named.has(String(pay[key])):
				named.append(String(pay[key]))
		var g := Talents.granted_name(pay)
		if g != "" and not named.has(g):
			named.append(g)
		var text := Talents.desc_for(n, 1)
		for nm in corpus:
			if String(nm).length() >= 4 and _bounded(text, String(nm)) \
					and not named.has(String(nm)):
				named.append(String(nm))
	return named


func _bounded(hay: String, needle: String) -> bool:
	var esc := ""
	for c in needle:
		esc += ("\\" + c) if "\\^$.|?*+()[]{}".contains(c) else c
	var re := RegEx.create_from_string("(?<![A-Za-z])" + esc + "(?![A-Za-z])")
	return re != null and re.search(hay) != null


func _find(n: String):
	# Every lookup Classes exposes, because a talent's ability can come from
	# the pending-talent table, the vault, a spec pool, a draft pool or a
	# class kit — and asking only one of them reports "not found" for an
	# ability that is very much in the game.
	for f in [Classes.pending_talent_ability, Classes.vault_ability,
			Classes.pool_ability, Classes.draft_ability,
			Classes.trimmed_kit_ability]:
		var ab = f.call(n)
		if ab != null:
			return ab
	for spec in Classes.SPEC_INFO:
		var ab = Classes.spec_pool_ability(spec, n)
		if ab != null:
			return ab
	for k in ["hunter", "warrior", "mage", "cleric"]:
		for ab in Classes.kit(k):
			if ab.display_name == n:
				return ab
	return null


func _initialize() -> void:
	var out := []
	# BATCH FX — the ONE tree. A node carries a TIER where it carried a spec, a
	# lane and a row, so those three keys left the dump with the twelve trees.
	for n in Talents.tree():
		out.append({
			"id": n.get("id", ""), "name": n.get("name", ""),
			"tier": n.get("tier", 0),
			"desc_raw": n.get("desc", ""),
			"desc_rendered": Talents.desc_for(n, 1),
			"scale": n.get("scale", {}), "payload": n.get("payload", {}),
			"granted": Talents.granted_name(n.get("payload", {})),
			"collision": Talents.collision_kind(n.get("payload", {})),
		})
	print("NODES: %d (expected %d = %d tiers x %d nodes)" % [out.size(),
		Talents.TIERS * Talents.NODES_PER_TIER, Talents.TIERS, Talents.NODES_PER_TIER])
	var dump := OS.get_environment("DOD_DUMP")
	if dump != "":
		var f := FileAccess.open(dump, FileAccess.WRITE)
		if f != null:
			f.store_string(JSON.stringify(out, "  "))
			f.close()
			print("DUMPED to ", dump)

	print("\nSKILL-CHECK BARS (bar=false means a node's \"Perfect:\" clause is dead):")
	var named := _named_by_tree()
	print("  the tree names %d abilities, in its payloads and its text" % named.size())
	for n in named:
		var ab = _find(n)
		if ab == null:
			print("  %-22s <not found>" % n)
			continue
		print("  %-22s bar=%-5s perfect_text=%s" % [n,
			str(ab.runs_skill_check()), '"%s"' % ab.perfect_text])
	quit()
