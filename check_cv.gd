# BATCH CV — THE AUDIT CORRECTIONS' INSTRUMENT. Read-only, like CU's: it
# asserts nothing, because the corrections are TEXT and the only question a
# script can settle is what the code actually does.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_cv.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR"
#
# THREE PASSES:
#
#   1. ORPHANED PERFECTS, over EVERY ability the game defines rather than the
#      37 CU named. §3 asks for "any other ability carrying a `perfect_text`
#      with no bar" and that is not a question a NAMED list can answer — the
#      list is the thing under suspicion. The 220 names below are every
#      `display_name` in classes.gd and talents.gd.
#
#   2. THE DURATION CONVENTION (§1). Every node whose text states a fixed
#      number of turns, printed beside the value its read site applies, so
#      "stated as applied" is checkable rather than asserted.
#
#   3. THE NODE DUMP, as CU's — through `Talents.desc_for`, the tooltip's own
#      function, so what is read here is what the player reads.
extends SceneTree

# Every ability defined anywhere in the game.
const NAMES := [
	"Aegis Reversal", "Aegis Wall", "Aimed Shot",
	"Aimed Volley", "Alms", "Anointing",
	"Answering Steel", "Anvil", "Arcane Arrows",
	"Arcane Barrage", "Arcane Bolt", "Arcane Cannon",
	"Arcane Echo", "Arcane Explosion", "Arcane Surge",
	"Ashes of Al'ar", "Backdraft", "Battle Poise",
	"Battle Shout", "Battle Trance", "Berserk",
	"Bestial Wrath", "Bewitch", "Blessing of Zeal",
	"Blessing of the Faithful", "Blight the Well", "Blink",
	"Blizzard", "Blood Debt", "Blood Offering",
	"Blood Price", "Bloodbond", "Bloodlust",
	"Boil Over", "Bola", "Breaking Darkness",
	"Bulwark of Fortitude", "Calibrating Shot", "Call of the Wild",
	"Call the Wilds", "Called Shot", "Called Volley",
	"Camouflage", "Charge", "Chastise",
	"Choking Smoke", "Cinderfall", "Cleave",
	"Cold Iron", "Consecrated Ground", "Consecration",
	"Coup de Grâce", "Covenant of Ash", "Covering Guard",
	"Crossfire", "Crushing Blow", "Cryoclasm",
	"Cull", "Dark Pact", "Dawnbreak",
	"Deadfall", "Death Ray", "Deep Winter",
	"Detonation", "Discipline", "Dispel",
	"Divine Plea", "Divine Presence", "Divine Shield",
	"Divine Wrath", "Downwind", "Drumfire",
	"Elevation", "Ember Debt", "Emberkeep",
	"Execute", "Exhortation", "Explosive Shot",
	"Eye of the Storm", "Fault Line", "Feigned Guard",
	"Feint", "Field Dressing", "Fireball",
	"Firedraw", "Firestorm", "Flamewave",
	"Flash Freeze", "Formless", "Fortified Spirit",
	"Frostbind", "Frostbolt", "Funeral Pyre",
	"Ghostpack", "Glacial Prison", "Guard Change",
	"Gut Rip", "Hack and Slash", "Hamstring",
	"Harvest", "Heal", "Hex of Ruin",
	"Hoarfrost Armor", "Hold Breath", "Hold the Line",
	"Hunt", "Hunter's Instinct", "Hunter's Mark",
	"Hymn of Hope", "Ice Lance", "Immolate",
	"Inner Arcane", "Intercession", "Interpose",
	"Ironclad", "Kill Command", "Killing Frost",
	"Kindled Mind", "Last Howl", "Loaded Shot",
	"Lunge", "Magi's Wrath", "Magic Barrier",
	"Magic Bolt", "Magic Missiles", "Mana Shield",
	"Mana Well", "Mantle", "Mark of the Hunt",
	"Mass Hysteria", "Mind Flay", "Ministration",
	"Mirror Image", "Mocking Blow", "Null Field",
	"Ordination", "Overcharge", "Overpower",
	"Penance", "Phoenix Rebirth", "Pinning Shot",
	"Pommel Strike", "Powershot", "Precision Strike",
	"Preparation", "Primal Surge", "Pyre Wake",
	"Pyroblast", "Quarry's Mark", "Quick Draw",
	"Quick Shot", "Rally", "Rallying Shout",
	"Rampage", "Razor Ice", "Reacquire",
	"Reality Fracture", "Recant", "Reckless Abandon",
	"Recompense", "Reliquary", "Renewal",
	"Reprisal", "Requiem", "Resonant Field",
	"Resurrection", "Retaliation", "Rime",
	"Rimebinding", "Rite of Return", "Sacred Resolve",
	"Sanctuary", "Savage Sweep", "Second Wind",
	"Sever", "Shadowrend", "Shared Grief",
	"Shatter", "Shatterpoint", "Shield Slam",
	"Shieldwall", "Shrapnel Charge", "Slow Burn",
	"Smite", "Snare Line", "Snare Trap",
	"Spirit Bond", "Spite", "Stabilize",
	"Stalking Horse", "Stoke", "Strike",
	"Succession", "Suffering", "Summon Aguila",
	"Summon Canis", "Summon Ursus", "Sweeping Strikes",
	"Threshold", "Transference", "Triple Shot",
	"Tripwire", "Trophy Shot", "Turn the Blade",
	"Twin Hunt", "Umbral Sigil", "Unburden",
	"Undying Vigil", "Unleash", "Unmaking",
	"Unslaked", "Vendetta", "Venom Coating",
	"Vespers", "Vow of Suffering", "War Stomp",
	"Warcry", "Wildfire", "Wildstrikes",
	"Winter's Toll",]


func _find(n: String):
	# CU's resolver, unchanged: a talent's ability can come from the
	# pending-talent table, the vault, a spec pool, a draft pool or a class
	# kit, and asking only one of them reports "not found" for an ability
	# that is very much in the game.
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
	print("=== PASS 1: EVERY ABILITY, BAR AND PERFECT TEXT ===")
	var orphans := []
	var missing := []
	var live := 0
	for n in NAMES:
		var ab = _find(n)
		if ab == null:
			missing.append(n)
			continue
		live += 1
		if ab.perfect_text != "" and not ab.runs_skill_check():
			orphans.append("%s — \"%s\"" % [n, ab.perfect_text])
	print("  resolved %d of %d names (%d unresolved)" % [live, NAMES.size(),
		missing.size()])
	print("  ORPHANED PERFECTS (perfect_text set, no bar): %d" % orphans.size())
	for o in orphans:
		print("    · ", o)
	print("  UNRESOLVED (defined but not reachable from any pool — enemy-side\n"
		+ "  or vaulted defs; not a defect, printed so the count is honest):")
	for m in missing:
		print("    · ", m)

	print("\n=== PASS 2: NODES STATING A FIXED TURN COUNT ===")
	var turn_re := RegEx.new()
	turn_re.compile("(?i)([0-9]+) turns?")
	var stated := 0
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			var rendered: String = Talents.desc_for(n, 1)
			var ms := turn_re.search_all(rendered)
			if ms.is_empty():
				continue
			stated += 1
			var counts := []
			for m in ms:
				counts.append(m.get_string(1))
			print("  %-22s %s   %s" % [n.get("id", ""), str(counts),
				rendered.substr(0, 78)])
	print("  %d nodes state a fixed turn count." % stated)

	print("\n=== PASS 3: THE NODE DUMP ===")
	var out := []
	for spec in Talents.LANE_TREES:
		for n in Talents.LANE_TREES[spec]:
			out.append({
				"spec": spec, "id": n.get("id", ""), "name": n.get("name", ""),
				"lane": n.get("lane", ""), "row": n.get("row", 0),
				"desc_raw": n.get("desc", ""),
				"desc_rendered": Talents.desc_for(n, 1),
				"scale": n.get("scale", {}), "payload": n.get("payload", {}),
			})
	print("  NODES: %d (expected %d)" % [out.size(), 12 * Talents.CELLS_PER_SPEC])
	var dump := OS.get_environment("DOD_DUMP")
	if dump != "":
		var f := FileAccess.open(dump, FileAccess.WRITE)
		if f != null:
			f.store_string(JSON.stringify(out, "  "))
			f.close()
			print("  DUMPED to ", dump)
	quit()
