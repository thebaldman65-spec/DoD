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
#   1. DUMP every node in every tree, from the LIVE `Talents.LANE_TREES` and
#      through `Talents.desc_for` — the same function the tooltip calls — so
#      the audit reads what the player reads rather than a hand-parse of
#      talents.gd. Set DOD_DUMP to a path to write the JSON.
#
#   2. ASK THE LIVE ABILITY OBJECTS whether they still run a skill-check bar.
#      Four nodes advertise a Perfect on an ability CN took the bar off, and
#      NO amount of reading talents.gd could have shown that: the claim is in
#      the node, the refutation is in `Ability.runs_skill_check()`. This is
#      the brief's "if a node cannot be audited without running it, run it".
extends SceneTree

# Every ability a talent node names, whether it grants it or modifies it.
const NAMED := ["Guard Change", "Shieldwall", "Execute", "Immolate",
	"Phoenix Rebirth", "Rime", "Divine Shield", "Pyroblast", "Shatter",
	"Magi's Wrath", "Overcharge", "Rampage", "Battle Shout", "Lunge",
	"Sacred Resolve", "Bulwark of Fortitude", "Mass Hysteria", "Mind Flay",
	"Divine Plea", "Intercession", "Hack and Slash", "Overpower",
	"Pommel Strike", "Resurrection", "Detonation", "Arcane Cannon",
	"Powershot", "Hex of Ruin", "Dark Pact", "Consecrated Ground",
	"Mocking Blow", "Crushing Blow", "War Stomp", "Interpose", "Shatterpoint",
	"Wildstrikes", "Quick Shot"]


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
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			out.append({
				"spec": spec, "id": n.get("id", ""), "name": n.get("name", ""),
				"lane": n.get("lane", ""), "row": n.get("row", 0),
				"desc_raw": n.get("desc", ""),
				"desc_rendered": Talents.desc_for(n, 1),
				"scale": n.get("scale", {}), "payload": n.get("payload", {}),
				"granted": Talents.granted_name(n.get("payload", {})),
				"collision": Talents.collision_kind(n.get("payload", {})),
			})
	print("NODES: %d (expected %d = 12 specs x %d cells)" % [out.size(),
		12 * Talents.CELLS_PER_SPEC, Talents.CELLS_PER_SPEC])
	var dump := OS.get_environment("DOD_DUMP")
	if dump != "":
		var f := FileAccess.open(dump, FileAccess.WRITE)
		if f != null:
			f.store_string(JSON.stringify(out, "  "))
			f.close()
			print("DUMPED to ", dump)

	print("\nSKILL-CHECK BARS (bar=false means a node's \"Perfect:\" clause is dead):")
	for n in NAMED:
		var ab = _find(n)
		if ab == null:
			print("  %-22s <not found>" % n)
			continue
		print("  %-22s bar=%-5s perfect_text=%s" % [n,
			str(ab.runs_skill_check()), '"%s"' % ab.perfect_text])
	quit()
