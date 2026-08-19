# test_batch_bj.gd — THE FULL AUDIT: dead code deleted (not left unreachable),
# the victory sync deduplicated, the signature-payoff instrument, and the
# tooltip corrections. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bj.gd
#
# THE BA PATTERN THROUGHOUT §1: a deleted field is asserted to NOT EXIST —
# never to be empty — so a later batch cannot quietly write one back. The
# deliberate keeps are asserted PRESENT for the same reason in reverse: this
# batch decided them, and a later "cleanup" that deletes one should trip a
# test and read the decision first.
#
# Source checks only need file reads; the one runtime section (the shared
# victory sync) drives BattleUnit math directly and never spawns a scene, so
# the whole suite is safe in _initialize (no autoload is touched — the AN
# gotcha does not apply).
extends SceneTree

var checks := 0
var fails := 0


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails += 1
		print("FAIL: " + msg)


func _initialize() -> void:
	var usrc := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var rsrc := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	var ssrc := FileAccess.get_file_as_string("res://scripts/run_sim.gd")
	var nsrc := FileAccess.get_file_as_string("res://scripts/runes.gd")
	var csrc := FileAccess.get_file_as_string("res://scripts/classes.gd")

	# ---------- §1: the five dead fields DO NOT EXIST ----------
	ok(not usrc.contains("var below_half_last"),
		"§1: below_half_last (no writer, no reader) is deleted")
	ok(not usrc.contains("var was_frozen"),
		"§1: was_frozen (written, never read since AS) is deleted")
	ok(not bsrc.contains("was_frozen = true"),
		"§1: ...and its one write site went with it")
	ok(not usrc.contains("var companion_hp_bonus"),
		"§1: companion_hp_bonus (read, no writer since AY) is deleted")
	ok(not bsrc.contains("companion_hp_bonus\n") or not bsrc.contains("+ hunter.companion_hp_bonus"),
		"§1: ...and its +0 arithmetic went with it")
	ok(not usrc.contains("var infusion_ranks"),
		"§1: infusion_ranks (Dark Infusion died in the AX re-author) is deleted")
	ok(not bsrc.contains("attacker.infusion_ranks"),
		"§1: ...and its dead branch went with it")
	ok(not usrc.contains("var chain_reaction_ranks"),
		"§1: chain_reaction_ranks (vault family member whose read site was already gone) is deleted")

	# ---------- §1: the six uncalled functions DO NOT EXIST ----------
	for fname in ["func relic_active", "func slot_type", "func owed_rune_picks",
			"func modifier_name", "func owed_upgrade_picks"]:
		ok(not rsrc.contains(fname),
			"§1: run_state.gd's %s (zero callers) is deleted" % fname)
	ok(not nsrc.contains("func generate_spec"),
		"§1: Runes.generate_spec (stranded by AN's spec-opening retirement) is deleted")

	# ---------- §1: the never-applied status row and the rests survivors ----------
	var battle_script: GDScript = load("res://scripts/battle.gd")
	ok(not battle_script.STATUS_INFO.has("bleed"),
		"§1: STATUS_INFO has no 'bleed' row (never applied; the chip is synthesized from bleed_buildup)")
	ok(not rsrc.contains("\"rests\": 0"),
		"§1: the run tally template has no 'rests' key (no writer existed)")
	ok(not bsrc.contains("Rests taken: %d"),
		"§1: the run summary no longer prints a rests line that could only read 0 (the comment naming the deletion is the record and stays)")
	ok(not ssrc.contains("\"miniboss\", \"rest\","),
		"§1: the report's taken-vs-offered loop no longer iterates a type the line cannot deal")

	# ---------- §1: the deliberate keeps are PRESENT (decisions, not oversights) ----------
	ok(bsrc.contains("const CONVICTION_NO_CONSUME_SHARE := 0.5"),
		"§1 KEEP: the AY §9 half-growth rule stands (test_batch_ay drives it; revived by any future partial-consume release)")
	ok(csrc.contains("const CLASS_POOLS"),
		"§1 KEEP: CLASS_POOLS stands ready for the day the class draw reopens (AN §4)")
	for vname in ["Rallying Shout", "Mana Shield", "Arcane Surge", "Reality Fracture",
			"Dawnbreak", "Sanctuary", "Divine Wrath"]:
		ok(csrc.contains("\"%s\":" % vname),
			"§1 KEEP: vault entry %s stands (design inventory; reachable only through the dead class draw)" % vname)
	ok(usrc.contains("var icy_veins_charge"),
		"§1 KEEP: the AS vault-pattern cryo family stands (documented keeps)")
	ok(usrc.contains("var pyromaniac_ranks"),
		"§1 KEEP: pyromaniac_ranks stands (the White Flame's inert clause, pinned by test_batch_ar)")

	# ---------- §1: the victory sync is ONE implementation ----------
	ok(usrc.contains("func sync_victory_state"),
		"§1: BattleUnit.sync_victory_state exists")
	ok(bsrc.contains("heroes[i].sync_victory_state(Run.party[i])"),
		"§1: battle.gd's victory branch calls it")
	ok(ssrc.contains("battle.heroes[i].sync_victory_state(run.party[i])"),
		"§1: RunSim's victory path calls the same one")
	ok(not bsrc.contains("- heroes[i].conviction_hp_gained")
		and not ssrc.contains("- h.conviction_hp_gained"),
		"§1: neither old copy of the three-field arithmetic survives")

	# The sync's math, driven directly (the three signs, the 20% return floor,
	# the clamp, the Mana write) — deliberately different magnitudes so a sign
	# error cannot hide in a cancellation (test_batch_bb's rule).
	# A BARE `BattleUnit.new()` HAS NO NAMEPLATE, AND THAT IS WHERE BJ'S THREE
	# SCRIPT ERRORS CAME FROM (repaired by Batch CD). `sync_victory_state`
	# opens with `expire_fortified_spirit`, which calls `remove_status`
	# UNCONDITIONALLY — idempotence is what makes the unconditional call safe —
	# and `remove_status` refreshes the chip row, whose `_chips_root` only
	# exists once a plate is built. Three drives, three throws.
	#
	# THEY ABORTED ONLY `_refresh_chips`, not this function, so bj's own count
	# never moved and all three were harmless stderr noise (BX reproduced them
	# on unmodified HEAD and recorded exactly that). THEY ARE STILL REPAIRED,
	# because a suite that spews throws is a suite nobody reads the stderr of —
	# and the seventh throw in this battery is the one that WAS eating checks.
	#
	# THE FIX IS BX'S OWN LESSON, WHICH IS THAT UNIT-SIDE CODE WANTS A REAL
	# UNIT: build the plate. It costs one detached Node2D and needs no scene,
	# no autoload and no battle, so this suite stays safe in `_initialize`.
	var plate := Node2D.new()
	var u := BattleUnit.new()
	u.build_plate(plate)
	u.max_hp = 300
	u.hp = 0
	u.tenacity_hp_gained = 45
	u.conviction_hp_gained = 30
	u.rot_hp_lost = 100
	u.resource_name = "Mana"
	u.resource = 61
	var member := {}
	u.sync_victory_state(member)
	ok(int(member["max_hp"]) == 325,
		"§1: save_max = 300 - 45 - 30 + 100 = 325 (got %s)" % str(member.get("max_hp")))
	ok(int(member["hp"]) == 65,
		"§1: a fallen hero returns at 20%% of the restored max (got %s)" % str(member.get("hp")))
	ok(int(member["mana"]) == 61,
		"§1: the Mana pool follows the hero out of the fight")
	u.hp = 9999
	u.sync_victory_state(member)
	ok(int(member["hp"]) == 325,
		"§1: hp is clamped under the restored maximum in the same step")
	var plate2 := Node2D.new()
	var u2 := BattleUnit.new()
	u2.build_plate(plate2)
	u2.max_hp = 200
	u2.hp = 150
	u2.resource_name = "Rage"
	u2.resource = 40
	var member2 := {}
	u2.sync_victory_state(member2)
	ok(not member2.has("mana"),
		"§1: a Rage hero writes no mana key")
	# The plates are siblings, not children (battle.gd's rule), so they are
	# freed alongside rather than with the units.
	u.free()
	u2.free()
	plate.free()
	plate2.free()

	# ---------- §3a: the signature instrument ----------
	ok(battle_script.signature_report_block({}) == "",
		"§3a: signature_report_block is \"\" when nothing was banked (the report-line rule)")
	var one := {"sigb_conviction_trash": 10.0, "sig_conviction_trash": 7.0}
	var blk: String = battle_script.signature_report_block(one)
	ok(blk.contains("Devout releases/battle: trash 0.70"),
		"§3a: a banked row renders its trash rate (got: %s)" % blk)
	ok(blk.contains("boss 0.00 (n=0)"),
		"§3a: an unmet boss half reads n=0 rather than pretending a rate was measured")
	ok(not blk.contains("Cryomancer"),
		"§3a: specs that never stood print no row")
	var two := {"sigb_permafrost_boss": 4.0, "sig_permafrost_boss": 8.0,
		"sig2_permafrost_boss": 2.0}
	var blk2: String = battle_script.signature_report_block(two)
	ok(blk2.contains("freezes/battle: trash 0.00 (n=0) | boss 2.00 (n=4)")
		and blk2.contains("holds >=3 turns: trash 0.00 | boss 0.50"),
		"§3a: the second moment renders beside the first (got: %s)" % blk2)
	ok(battle_script.SIG_LABELS.size() == 12,
		"§3a: all twelve specs carry a signature label")
	ok(bsrc.contains("func _sig(") and bsrc.contains("if sim:\n\t\t_b_sig["),
		"§3a: the slice helper exists and books only under sim")
	ok(ssrc.contains("signature_report_block"),
		"§3a: RunSim's report prints the table (a run is the standard source — only a run meets a boss)")

	# ---------- §2: the tooltip corrections hold ----------
	# Unbroken Watch: desc, scale and payload all say 1 now, matching the
	# gate-only read site. IF A LATER BATCH IMPLEMENTS THE MAGNITUDE (passing
	# the field as the _gain_loyalty amount), it must flip these knowingly.
	var bm_tree: Array = Talents.LANE_TREES["beastmaster"]
	var unbroken: Dictionary = {}
	for n in bm_tree:
		if n["id"] == "bm_unbroken":
			unbroken = n
	ok(int(unbroken["payload"]["stat"]["unbroken_watch"]) == 1
		and int(unbroken["scale"]["step"]) == 1,
		"§2: Unbroken Watch pays the +1 its read site actually grants (the tooltip lied at +2)")
	ok(bsrc.contains("if u.unbroken_watch > 0 and not tick_b.damaged_since_turn:"),
		"§2: ...and the read site is still the gate-only shape the desc now describes")
	var wd_tree: Array = Talents.LANE_TREES["warden"]
	var rico_name := ""
	for n in wd_tree:
		if n["id"] == "wd_ricochet":
			rico_name = String(n["name"])
	ok(rico_name == "Ricochet",
		"§2: the Warden row-1 node is spelled Ricochet (was Richocet)")
	# RE-POINTED IN PLACE BY BATCH BS §3. BJ's tooltip audit found that Cauterise
	# promised something its read site qualified — Kiln-Forged's floor took
	# precedence and the desc did not say so — and pinned the correction here.
	# BOTH NODES CHANGED WHAT THEY DO: `py_cauterize` is Ash Lung now and
	# `py_undying_flame` is Kiln-Forged, and neither reads a drain, so the
	# precedence has nothing left to state. THE QUESTION BJ WAS REALLY ASKING —
	# does the tooltip state the qualification its read site enforces? — is kept
	# and pointed at the surviving one: Kiln-Forged's guard is GATED ON THE
	# BOARD, and a card that did not say so would be the same failure.
	var py_tree: Array = Talents.LANE_TREES["pyromancer"]
	for n in py_tree:
		if n["id"] == "py_undying_flame":
			ok(String(n["desc"]).contains("or more enemies are Burning"),
				"§2: Kiln-Forged states the board gate its read site enforces")
	# Reality Fracture's perfect is INERT and pinned as such (the White Flame
	# pattern): implementing it is a design decision a later batch must make
	# against this check, not a drive-by.
	ok(csrc.contains("\"perfect_id\": \"\", \"perfect_text\": \"An Arcanist also banks 1 Resonance\""),
		"§2 PINNED: Reality Fracture's perfect text stands as authored...")
	ok(not bsrc.contains("Reality Fracture"),
		"§2 PINNED: ...and battle.gd still has NO handler for it — the clause is inert (reported, not implemented)")
	# The ability descs corrected toward the code.
	ok(csrc.contains("kindled 1 Faith"),
		"§2: Consecrated Ground's tooltip states its Faith drip")
	# BATCH CQ §3 — CL's LIVE VALUES, NOT A FOLD. Explosive Shot still runs a
	# check and still states a perfect; CL replaced the authored "12% of
	# Attack" with the `{atk:12}` token that `Classes.resolve_values` expands
	# at render time, so the unit is stated by the RESOLVER now. The card is
	# not one of CN's 105 — its perfect survives.
	ok(csrc.contains("\"perfect_text\": \"Deals {atk:12}\""),
		"§2: Explosive Shot's perfect states its unit through CL's token")
	ok(csrc.contains("20% of Attack as nature"),
		"§2: Shrapnel Charge states its unit")
	# RE-POINTED AT BATCH BX §4 (prose only — "beasts" became "companions").
	# BJ's question survives whole: the desc must not go back to claiming 15%
	# for the ones that are STANDING, which is the doc drift BJ found.
	ok(csrc.contains("your living\\ncompanions make their own strikes"),
		"§2: Call of the Wild no longer claims 15% for present companions")
	# The rune descs corrected toward their payloads.
	var runes_json := FileAccess.get_file_as_string("res://data/runes.json")
	ok(runes_json.contains("leaves Poison AND Cripple behind"),
		"§2: the Weeping Wound states its Cripple carrier")
	ok(runes_json.contains("swells his maximum Mana 10%"),
		"§2: the Wide Current states its Mana clause")
	ok(runes_json.contains("marks the newly maddened with 1 Ruin"),
		"§2: the Whispering Dark states the Ruin mark AX said it must")
	ok(runes_json.contains("drinks 6% more per stack"),
		"§2: the Hollow Chalice states its true per-stack rate")
	ok(runes_json.contains("her instant heals can CRIT"),
		"§2: the Open Hand states the heal-crit gate it unlocks")
	# The glossary corrected toward the code.
	var glossary := FileAccess.get_file_as_string("res://data/glossary.json")
	# BATCH BM RE-POINTED THESE TWO. BJ's question — does the glossary describe
	# the LIVE economy rather than a dead one — is exactly the right question
	# and is unchanged; BM replaced the economy underneath it, so the strings
	# move with it. A cell costs by TIER now, and nothing in a run pays a point.
	ok(glossary.contains("rows 1-3 cost 1 point"),
		"§2: talent_cost describes the TIER pricing")
	ok(not glossary.contains("ceil(N/3)"),
		"§2: ...and the AI-era curve is gone from it")
	ok(glossary.contains("NOTHING IN A RUN AWARDS ONE"),
		"§2: talent_points describes the META schedule")
	ok(glossary.contains("three slots per hero"),
		"§2: the runes entry describes the flat 3 slots")
	ok(not glossary.contains("restored by rests"),
		"§2: res_mana no longer promises rests")
	ok(glossary.contains("EVERY hero claim a trophy"),
		"§2: boss_trophies covers all twelve pools")

	print("test_batch_bj: %d checks, %d failures" % [checks, fails])
	quit(1 if fails > 0 else 0)
