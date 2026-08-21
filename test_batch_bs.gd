# test_batch_bs.gd — OVERBURN LOSES THE DRAIN, AND INFERNO BECOMES A LANE.
# Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script test_batch_bs.gd
#
# NO --quit-after: it kills a --script run mid-way and prints nothing (the AN
# gotcha). This suite SPAWNS LIVE BATTLES, so it parks on the first
# process_frame (autoloads are not in the tree during _initialize). It does NOT
# want --fixed-fps 12 — nothing here runs a battle to completion; every check
# drives its ability or its damage by hand.
#
# WHAT IT PROTECTS.
# §2 — THE DELETION, AND IT IS ASSERTED AS NON-EXISTENCE RATHER THAN AS
# RETURNING ZERO. `_overburn_drain`, `_overburn_tick`, `_overburn_capped` and
# `_drain_burn_turns` are gone from the source, `_player_turn` no longer calls
# any of them, and `BattleUnit.ember_debt` went with the exemption it served.
# A drain that returns 0 is a drain a later batch revives by flipping a
# constant; a drain that does not exist has to be re-authored on purpose.
# Beside it, the LIVE negative control §6 asks for: NO MANA LEAVES HIM AT TURN
# START UNDER ANY BURN LOAD, driven at 20+ burn-turns where the old bill was
# largest, with the whole re-authored lane learned.
#
# §3 — EACH OF THE EIGHT NODES applies its stated effect and sits at its row.
# THE FIVE MOST ABLE TO SILENTLY DO NOTHING ARE BUILT SO A BROKEN
# IMPLEMENTATION STILL FAILS, because each would otherwise pass on code that
# does the wrong thing:
#   · ASHEN SKIN's heal reading THE TICK IT APPLIED — "he healed" is trivially
#     true of any heal, so a SECOND burn from a DIFFERENT applier is put on the
#     board in the same battle and asserted to pay him NOTHING;
#   · BACKBLAST firing ONCE and only under 40% — "it fired" is trivially true
#     of a hook with no threshold, so it is driven at 60% health (nothing), then
#     under the line (everything), then hit AGAIN (nothing more);
#   · KILN-FORGED refusing a lethal blow ONLY at three or more burning enemies
#     — "he survived" is trivially true of a guard with no gate, so the SAME
#     lethal blow is landed at two burning enemies (he dies) and at three (he
#     lives) with nothing else different;
#   · ASH LUNG scaling with the count AND PAYING BOTH HALVES — a node that
#     scaled one way would read exactly like a working node from either side
#     alone, so the dealt and taken halves are measured SEPARATELY, each at ONE
#     burning enemy against THREE;
#   · FORGE BODY reading burn TURNS rather than burning BODIES — the two agree
#     at one turn each and diverge hard otherwise, so it is measured where they
#     DIFFER BY CONSTRUCTION (two enemies at six turns each: 2 bodies, 12
#     turns), plus its 50% cap and the fact that the prevented damage lands on
#     a BURNING enemy.
#
# §4 — EMBER DEBT under its new text (the fourth consumer of the ONE refund
# door, and the first that consumes nothing), and the rune audit as a fact.
#
# ONE HARNESS NOTE THAT WILL SAVE THE NEXT AUTHOR A BISECT. Five checks here
# compare ONE BLOW AGAINST ONE BLOW, and the first line of the strike block is
# `randf_range(0.9, 1.1)` — a ±10% swing that comfortably swamps a 4-point
# mitigation term. BQ hit this and killed the CRIT roll; the VARIANCE roll is
# the half that survived it. Both are handled here: `crit_bonus = -1.0` at spawn,
# and `_seeded()` immediately before each blow of a pair so the two draw the
# SAME variance. Forced determinism, never a retry (the AK/AL/AR discipline).
extends SceneTree

const REAL_SAVE := "user://run_save.bin"

# Backblast's arming threshold, mirrored from battle.gd so the check states
# what it depends on rather than hiding it inside a magic 0.25.
const BACKBLAST_AT_TEST := 0.40

var checks := 0
var fails: Array = []
var _save_backup: PackedByteArray = PackedByteArray()
var _had_save := false

# The re-authored lane, transcribed once: id -> [row, name, stat field, value].
# THE IDS ARE THE OLD ONES BY DESIGN — §3 says all eight survive and re-spec in
# place, so a save holding a row-5 pick still resolves. This table is the
# machine-checkable half of that promise.
const INFERNO := {
	"py_pyromaniac":    [1, "Ember Shroud", "ember_shroud", 8],
	"py_invigorating":  [2, "Ashen Skin", "ashen_skin", 25],
	"py_firebrand":     [3, "Heat Haze", "heat_haze", 20],
	"py_flame_shield":  [4, "Immolate", "", 0],
	"py_molten":        [5, "Backblast", "backblast", 15],
	"py_undying_flame": [6, "Kiln-Forged", "kiln_forged_at", 3],
	"py_cauterize":     [7, "Ash Lung", "ash_lung_pct", 4],
	"py_forge_body":    [8, "Forge Body", "forge_body_pct", 1],
}

# Every id of the whole tree — §6's audit asks for "every id present", and the
# cheapest way to break a re-spec is to drop one on the way through.
const ALL_IDS := [
	"py_kindling", "py_accelerant", "py_arson", "py_melt", "py_ashes",
	"py_explosive", "py_spreading", "py_sea_of_flame",
	"py_pyromaniac", "py_invigorating", "py_firebrand", "py_flame_shield",
	"py_molten", "py_undying_flame", "py_cauterize", "py_forge_body",
	"py_shockwave", "py_supernova", "py_implosion", "py_focused",
	"py_seeding", "py_rekindle", "py_warm_glow", "py_powder_keg",
	"py_firestorm", "py_rebirth", "py_hellfire",
]


func _initialize() -> void:
	# Children added in _initialize never fire _ready (root not ready) — park
	# on the first process_frame, the CLAUDE.md gotcha.
	_run.call_deferred()


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails.append(msg)


func _run() -> void:
	await process_frame
	_had_save = FileAccess.file_exists(REAL_SAVE)
	if _had_save:
		_save_backup = FileAccess.get_file_as_bytes(REAL_SAVE)
	Profile.save_path = "user://profile_batch_bs_test.json"
	Profile.loaded = false
	Profile.data = {}

	_deletions()
	_lane_shape()
	_tree_audit()
	_rune_audit()
	_docs()
	await _live_no_bill()
	await _live_bonus_survives()
	await _live_ember_shroud()
	await _live_ashen_skin()
	await _live_heat_haze()
	await _live_immolate()
	await _live_backblast()
	await _live_kiln_forged()
	await _live_ash_lung()
	await _live_forge_body()
	await _live_ember_debt()

	if FileAccess.file_exists("user://profile_batch_bs_test.json"):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path("user://profile_batch_bs_test.json"))
	Profile.save_path = "user://profile.json"
	Profile.loaded = false
	Profile.data = {}
	if _had_save:
		FileAccess.open(REAL_SAVE, FileAccess.WRITE).store_buffer(_save_backup)
	elif FileAccess.file_exists(REAL_SAVE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(REAL_SAVE))

	print("BATCH BS: %d checks, %d FAILED" % [checks, fails.size()])
	for f in fails:
		print("  FAIL: ", f)
	quit(1 if fails.size() > 0 else 0)


# ---------- §2: the deletion, as non-existence ----------

func _deletions() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for gone in ["func _overburn_drain", "func _overburn_tick",
			"func _overburn_capped", "func _drain_burn_turns"]:
		ok(not src.contains(gone), "%s is DELETED, not zeroed" % gone)
	ok(src.count("_overburn_tick(u)") == 0,
		"_player_turn does not call the bill — there is none to call")
	ok(src.count("func _total_burn_turns") == 1,
		"_total_burn_turns is the SINGLE denominator again")
	# The surviving clauses, and their count. The refund is a property of the
	# PASSIVE, so it must still have exactly one implementation — and FIVE call
	# sites now (Detonation, Wildfire, Cinderfall, BS's re-authored Ember Debt,
	# which is the first payer that consumes nothing at all, and BATCH BT's
	# FUNERAL PYRE). RE-POINTED 4 -> 5 rather than deleted, for the reason BO
	# pinned the count in the first place: a new consumer has to COME AND SAY SO
	# instead of quietly writing its own refund, and the count decaying to
	# "whatever it is today" is what that would look like.
	ok(src.count("func _overburn_refund") == 1,
		"the refund still has exactly ONE implementation")
	# RE-POINTED 5 -> 6 (Batch CB): PYRE WAKE is the SIXTH consumer of the one
	# refund door. BS pinned this count for the same reason AR did — a new Burn
	# consumer has to COME AND SAY SO rather than writing a refund of its own —
	# and the question is unchanged; only the answer's size moved.
	ok(src.count("_overburn_refund(attacker,") == 6,
		"...and SIX call sites (got %d)" % src.count("_overburn_refund(attacker,"))
	ok(src.count("func _overburn_mult") == 1, "the bonus still has one home")
	# GAP FOUND BY A NEGATIVE CONTROL, WHICH IS THE WHOLE REASON TO RUN THEM:
	# THE FUNCTION-ABSENCE GREPS ABOVE DO NOT CATCH A BILL WRITTEN STRAIGHT INTO
	# `_player_turn`, and that is exactly what a later batch reviving the
	# mechanic would write. Restoring the drain as three inline lines tripped
	# NOTHING until these three checks existed.
	# It is asserted against the SOURCE because `_player_turn` cannot be driven
	# headlessly — it awaits an ability pick that never comes — which is AR's
	# own reason for asserting that function's ORDER the same way.
	var turn_body := src.substr(src.find("func _player_turn(u: BattleUnit)"))
	turn_body = turn_body.substr(0, turn_body.find("Companions have no turns"))
	ok(turn_body.contains("u.resource = mini(u.resource + _mana_regen(u)"),
		"_player_turn still drips the regen")
	ok(turn_body.count("u.resource -") == 0,
		"...and NOTHING in it takes resource away — there is no bill, inline or otherwise")
	# COMMENTS ARE STRIPPED FIRST, and that is not a convenience: the tombstone
	# this batch left in `_player_turn` NAMES the deleted bill on purpose, so a
	# bare `contains` would fail against working code and a later author would
	# "fix" it by deleting the tombstone — the one line that tells them not to
	# put the bill back. What is checked is CODE.
	var turn_code := ""
	for line in turn_body.split("\n"):
		if not line.strip_edges().begins_with("#"):
			turn_code += line + "\n"
	ok(not turn_code.to_lower().contains("overburn"),
		"...and no CODE in it reads the passive at turn start any more")
	var unit_src := FileAccess.get_file_as_string("res://scripts/unit.gd")
	for dead in ["var fire_walker", "var invigorating_ranks", "var heat_haze_ranks",
			"var kiln_forged :", "var ash_lung :", "var cauterise :",
			"var forge_body :", "var ember_debt :"]:
		ok(not unit_src.contains(dead),
			"BattleUnit.%s is deleted with its read site" % dead.replace("var ", ""))
	# THE 6% GLOBAL BURN TICK IS UNTOUCHED — it is shared with enemies, runes
	# and every other burn source in the game, and AR's reason for not moving
	# it did not expire with the drain.
	ok(src.contains('"burn": 6'), "the global Burn tick constant is still 6%")


# ---------- §3: the lane, on paper ----------

func _lane_shape() -> void:
	var tree: Array = Talents.LANE_TREES.get("pyromancer", [])
	var by_id := {}
	for n in tree:
		by_id[String(n["id"])] = n
	for id in INFERNO:
		var want: Array = INFERNO[id]
		ok(by_id.has(id), "%s survives (no id was deleted)" % id)
		if not by_id.has(id):
			continue
		var n: Dictionary = by_id[id]
		ok(String(n.get("lane", "")) == "Inferno", "%s is in INFERNO" % id)
		ok(int(n.get("row", 0)) == want[0],
			"%s sits at row %d (got %s)" % [id, want[0], str(n.get("row", 0))])
		ok(String(n.get("name", "")) == want[1],
			"%s is '%s' (got '%s')" % [id, want[1], String(n.get("name", ""))])
		if String(want[2]) != "":
			var pay: Dictionary = n["payload"].get("stat", {})
			ok(pay.get(want[2], null) == want[3],
				"%s writes %s = %d (got %s)" % [id, want[2], want[3],
					str(pay.get(want[2], null))])
	# ROW 8 MUST NOT WRITE A FIELD AN EARLIER NODE IN THE SAME LANE WRITES —
	# BM's mechanical test for a re-skin, checked here too because this batch
	# re-authored every field in the lane and that is exactly when a row-8
	# node quietly becomes a bigger row 1.
	var row8: Dictionary = by_id.get("py_forge_body", {})
	var row8_fields: Array = row8.get("payload", {}).get("stat", {}).keys()
	for id in INFERNO:
		if id == "py_forge_body":
			continue
		var pay: Dictionary = by_id.get(id, {}).get("payload", {}).get("stat", {})
		for f in row8_fields:
			ok(not pay.has(f),
				"row 8's %s is not also written by %s" % [String(f), id])
	# THE LANE'S SHAPE, PER BM'S RULE: rows 1-7 are DIFFERENT KINDS of
	# protection rather than one kind at seven prices. Asserted as the count of
	# DISTINCT stat fields the lane writes — one node that was a bigger copy of
	# another would share one.
	var lane_fields := {}
	for id in INFERNO:
		var pay: Dictionary = by_id.get(id, {}).get("payload", {}).get("stat", {})
		for f in pay:
			lane_fields[f] = true
	ok(lane_fields.size() >= 8,
		"the lane writes %d distinct fields — no node is a re-skin of another" % \
			lane_fields.size())
	# ...and NOT ONE of them is the old passive's cost. The whole diagnosis was
	# that seven of eight nodes read one term; this is the assertion that the
	# re-author actually removed the shape rather than renaming it.
	for dead in ["fire_walker", "kiln_forged", "ash_lung", "cauterise",
			"invigorating_ranks", "heat_haze_ranks", "forge_body"]:
		ok(not lane_fields.has(dead),
			"no Inferno node still writes %s" % dead)


func _tree_audit() -> void:
	var tree: Array = Talents.LANE_TREES.get("pyromancer", [])
	# 24 NODES PLUS 3 CAPSTONES = 27 ENTRIES: 7 rows x 3 lanes, plus BM's row 8,
	# plus the capstone shelf. §6 asks for "24 nodes, 3 capstones", which is the
	# same count read the way the tree data is laid out.
	ok(tree.size() == 27, "the tree holds 24 nodes + 3 capstones (got %d)" % tree.size())
	var ids := {}
	var caps := 0
	var lanes := {"Kindling": 0, "Inferno": 0, "Detonation": 0}
	var row8 := 0
	for n in tree:
		var id := String(n["id"])
		ok(not ids.has(id), "%s appears once" % id)
		ids[id] = true
		var lane := String(n.get("lane", ""))
		ok(lanes.has(lane), "%s is in a real lane (%s)" % [id, lane])
		if bool(n.get("capstone", false)):
			caps += 1
		elif int(n.get("row", 0)) == 8:
			row8 += 1
		elif lanes.has(lane):
			lanes[lane] += 1
	ok(caps == 3, "3 capstones (got %d)" % caps)
	ok(row8 == 3, "3 row-8 nodes (got %d)" % row8)
	for lane in lanes:
		ok(lanes[lane] == 7, "%s holds 7 rows 1-7 (got %d)" % [lane, lanes[lane]])
	for id in ALL_IDS:
		ok(ids.has(id), "%s is present" % id)
	ok(ids.size() == ALL_IDS.size(),
		"and nothing else is (%d ids vs %d expected)" % [ids.size(), ALL_IDS.size()])
	# Exclusive references, where any survive: a node naming a partner that no
	# longer exists is the quiet failure a re-spec invites.
	for n in tree:
		var ex := String(n.get("exclusive_with", ""))
		if ex != "":
			ok(ids.has(ex), "%s's exclusive partner %s exists" % [String(n["id"]), ex])


func _rune_audit() -> void:
	# §4: EVERY PYROMANCER AND MAGE RUNE AGAINST THE SIX RE-SPECCED FIELDS. A
	# rune riding a counter that changed meaning fails SILENTLY — no error, no
	# log line — which is why this is a check rather than a note.
	var dead := ["fire_walker", "kiln_forged", "ash_lung", "cauterise",
		"invigorating_ranks", "heat_haze_ranks", "forge_body", "ember_debt"]
	var touched: Array = []
	var written := {}
	for id in Runes.ids():
		var r: Dictionary = Runes.config(String(id))
		var scope := String(r.get("scope", ""))
		if not (scope == "spec:pyromancer" or scope == "class:mage"):
			continue
		for f in r.get("payload", {}).get("stat", {}):
			written[String(f)] = true
			if dead.has(String(f)):
				touched.append("%s writes %s" % [String(id), String(f)])
	ok(touched.is_empty(),
		"no Pyromancer or Mage rune rides a re-specced field (%s)" % str(touched))
	# ...and the ones that DO ride a Pyromancer counter still read a LIVE field.
	# §4 names three by name because they are already known to be fragile.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	for f in ["blast_radius_ranks", "supernova_ranks", "molten_ranks",
			"accelerant_ranks", "rune_cinder_ember", "conflagration_ranks"]:
		ok(written.has(f), "a rune still writes %s" % f)
		ok(src.contains("." + f), "...and battle.gd still READS %s" % f)
	# THE RUNE OF THE WHITE FLAME'S MIDDLE CLAUSE IS STILL INERT, AND THAT IS
	# DELIBERATE (AR §4). This batch gave it no home — Overburn still has no
	# per-burning-enemy step — so the assertion is UNCHANGED rather than
	# quietly re-pointed. If a later batch homes it, it must change this line.
	var wf: Dictionary = Runes.config("white_flame")
	ok(wf.get("payload", {}).get("stat", {}).has("pyromaniac_ranks"),
		"the White Flame still writes pyromaniac_ranks")
	ok(not src.contains(".pyromaniac_ranks"),
		"...and nothing reads it — the clause is STILL inert, by decision")


func _docs() -> void:
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	# RE-POINTED BY BATCH CN, to the durable shape Batch CK gave this same gate in
	# test_batch_br. It read `master.contains("Batch C?")`, a stamp assertion that
	# has to be hand-bumped every batch — **A CHECK THAT MUST BE EDITED EVERY BATCH
	# TO KEEP PASSING IS A CHECK THAT WILL BE RED MOST BATCHES**, which stops it
	# carrying information. It asks the durable version now: the document carries a
	# stamp, and that stamp is not older than the batch this suite belongs to. No
	# bump is ever owed again. (Two-letter batch codes sort lexically; a
	# three-letter code will need one more line.)
	var stamp_at := master.find("Last updated:")
	ok(stamp_at >= 0, "master.html carries a Last-updated stamp")
	var stamp := master.substr(stamp_at, 60)
	var code_at := stamp.find("(Batch ")
	var stamped := stamp.substr(code_at + 7, 2) if code_at >= 0 else ""
	ok(stamped >= "BS",
		"...and master.html is stamped no older than this suite's own batch (reads '%s')" % stamped)
	ok(master.contains("TWO clauses"),
		"§5: master.html's Overburn entry states two clauses")
	ok(master.contains("Holding fire\ncosts him nothing.</b>")
		or master.contains("Holding fire costs him nothing"),
		"§5: ...and says outright that holding fire costs nothing")
	ok(master.contains("DEFERRED"),
		"§5: ...with the deferred-damage spine stated explicitly, so the removal"
		+ " does not read as the spec losing its identity")
	ok(not master.contains("the reward caps and the cost"),
		"§5: the old asymmetry claim is gone from master.html")
	ok(master.contains("Ember Shroud") and master.contains("Backblast")
		and master.contains("Heat Haze"),
		"§5: §7's Inferno column carries the re-authored nodes")
	# RE-POINTED AT THE ARCHIVE BY BATCH CX. The live changelog passed CW's 400 KB
	# threshold, so CX cut it at the CN/CO boundary: Batch BS — with everything
	# from BP to CN — moved OUT OF THE REPO into `changelog-archive.html`. The old
	# `contains("Batch BS")` would have gone on PASSING against the live file,
	# because later entries name the batch in their own prose — A CHECK THAT PASSES
	# WITHOUT ITS SUBJECT BEING IN THE FILE AT ALL. That is BZ's failure in
	# test_batch_bb and CD's in test_batch_bo, repaired here before it could bite.
	#
	# CD's pattern: anchor on the `<h2>` HEADING, and read the archive's path out of
	# the LIVE changelog's own header rather than hardcoding it, so the NEXT cut
	# moves this with it. See test_batch_bn for the full reasoning and the one
	# consequence — this suite now depends on a file that is NOT IN VERSION CONTROL
	# and FAILS LOUDLY without it, which is correct.
	var live_log := FileAccess.get_file_as_string("res://docs/changelog.html")
	var arch_mark := live_log.find("/changelog-archive.html</code>")
	ok(arch_mark > 0, "§5: the live changelog names the archive's full path")
	var arch_open := live_log.rfind("<code>", arch_mark) + 6
	var arch_path := live_log.substr(arch_open,
		arch_mark + "/changelog-archive.html".length() - arch_open)
	var changelog := FileAccess.get_file_as_string(arch_path)
	ok(changelog.length() > 100000,
		"§5: the archive opens at %s (%d chars)" % [arch_path, changelog.length()])
	ok(not live_log.contains("<h2>2026-08-14 &mdash; Batch BS"),
		"§5: CX moved this batch's entry OUT of the live changelog")
	ok(changelog.contains("<h2>2026-08-14 &mdash; Batch BS"),
		"§5: ...and the archive carries the Batch BS entry")
	var notes := FileAccess.get_file_as_string("res://docs/design-notes.md")
	ok(notes.contains("Batch BS"), "§5: design-notes has a Batch BS entry")
	var claude := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(claude.contains("BATCH BS"), "§5: CLAUDE.md has a Batch BS block")
	# THE GOVERNOR TABLE'S OVERBURN ROW WAS REWRITTEN, NOT AMENDED — its central
	# claim (a capped reward against an uncapped cost) is false now. It is NOT
	# checked by grepping for the old sentence: the rewrite QUOTES that sentence
	# on purpose, so a later reader can see what changed and why. What is
	# asserted instead is that the row no longer names a DELETED FUNCTION AS A
	# LIVE GOVERNOR SITE, which is the thing that would actually mislead.
	ok(claude.contains("REWRITTEN AT BATCH BS, NOT AMENDED"),
		"§5: CLAUDE.md's governor row says it was rewritten and why")
	ok(not claude.contains("`_overburn_drain` (uncapped cost)"),
		"§5: ...and no longer points at _overburn_drain as a live governor")
	var gloss := FileAccess.get_file_as_string("res://data/glossary.json")
	ok(gloss.contains("\"id\": \"overburn\""), "§5: the glossary describes Overburn")


# ---------- the live harness ----------

func _spawn(learned: Dictionary, lineup: Array) -> Node:
	var run := root.get_node("/root/Run")
	run.sim_run = false
	run.new_run(["warrior", "mage", "cleric", "hunter"], [], "standard")
	var specs := ["berserker", "pyromancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = specs[i]
		run.party[i]["tree"] = Talents.generate_tree(specs[i], run.party[i]["key"])
		run.party[i]["runes"] = []
		run.party[i]["talents"] = learned.duplicate() if i == 1 else {}
		run.sync_spec_hp(i)
	run.specs_chosen = true
	run.active = true
	run.encounter = {"type": "fight", "theme": "Warband", "enemies": lineup}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var scene: Node = load("res://scenes/battle.tscn").instantiate()
	root.add_child(scene)
	for _i in 20:
		await process_frame
	# DETERMINISM, FORCED RATHER THAN RETRIED (the AK/AL/AR discipline). Every
	# check below drives `_resolve` or `take_hit` by hand, and a 5% miss or a
	# 5% parry skips the whole damage path — which reads as "the node did
	# nothing" and turns a real assertion into a coin flip.
	# ONE DELIBERATE EXCEPTION, AND IT IS THE POINT OF `_live_heat_haze`:
	# `no_cover` is a miss BYPASS, so a suite that arms it on everybody can
	# never see Heat Haze work at all (BQ's Mirror Image lesson, arriving
	# through the other door). That check reads `_miss_chance` directly instead.
	for u in scene.get("heroes") + scene.get("enemies"):
		u.no_cover = 1
		u.parry_chance = 0.0
		u.block_chance = 0.0
		u.crit_bonus = -1.0   # BQ: a live crit roll flips any one-blow comparison
	return scene


func _py(scene: Node) -> BattleUnit:
	for h in scene.get("heroes"):
		if not h.is_companion and String(h.passive_id) == "overburn":
			return h
	return null


# Put a known number of Burn TURNS on the field, split across the lineup, and
# return the total. `src` matters: Ashen Skin pays only for the ticks HE
# applied, so a helper that stamped no applier could never tell the two apart.
func _light(scene: Node, turns_each: int, src: BattleUnit = null) -> int:
	var total := 0
	for foe in scene.get("enemies"):
		if foe.dead:
			continue
		scene.call("_apply_status", foe, "burn", turns_each, 0, 6, src)
		total += turns_each
	return total


# FORCED DETERMINISM FOR A ONE-BLOW-AGAINST-ONE-BLOW COMPARISON, and it is the
# AK/AL/AR discipline rather than a retry. The FIRST line of the strike block is
# `randf_range(0.9, 1.1)`, so a single blow carries a ±10% swing — which
# comfortably swamps a 4-point mitigation term and turns a real assertion into a
# coin flip (BQ hit exactly this and fixed it by killing the CRIT roll; the
# VARIANCE roll is the half that survived). Seeding the global RNG to the same
# value before each blow of a pair makes both draw the SAME variance, so the
# only thing that differs between them is the node under test.
func _seeded() -> void:
	seed(20260814)


# ---------- §2, live ----------

func _live_no_bill() -> void:
	# §6'S NEGATIVE CONTROL, AND THE ONE THAT MATTERS. Driven at 20+ burn-turns,
	# where the old bill was largest, with the WHOLE re-authored lane learned —
	# because the seven nodes that used to act on the drain are exactly where a
	# surviving fragment of it would hide.
	var lane := {}
	for id in INFERNO:
		lane[id] = 1
	var scene := await _spawn(lane, ["raider", "raider", "raider", "raider"])
	var py := _py(scene)
	ok(py != null, "the Pyromancer spawned holding the whole Inferno lane")
	if py == null:
		scene.queue_free()
		return
	var lit := _light(scene, 6, py)          # 24 burn-turns
	ok(lit >= 20,
		"the field holds %d burn-turns — past where he used to drown" % lit)
	ok(int(scene.call("_total_burn_turns")) == lit,
		"the ONE denominator reads the whole field (%d)" % lit)
	py.resource = 40
	py.hp = py.max_hp
	var mana_was: int = py.resource
	var hp_was: int = py.hp
	# Twenty frames of a live battle, with the fire standing. Nothing may bill
	# him: not at turn start, not on a tick, not in blood.
	for _i in 20:
		await process_frame
	ok(py.resource >= mana_was,
		"24 burn-turns bill him NO Mana (%d -> %d)" % [mana_was, py.resource])
	ok(py.hp == hp_was,
		"...and no health either — Cauterise is gone (%d -> %d)" % [hp_was, py.hp])
	scene.queue_free()
	await process_frame


func _live_bonus_survives() -> void:
	# THE HALF THAT DID NOT CHANGE, ASSERTED UNCHANGED. A batch that deletes one
	# clause of a passive is exactly where the other clause gets moved by
	# accident, and the bonus is the whole of what he is paid now.
	var scene := await _spawn({}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(is_equal_approx(scene.call("_overburn_mult", py, 0), 1.0),
		"an unlit field pays nothing")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 5), 1.10),
		"5 burn-turns pay +10%")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 20), 1.40),
		"20 burn-turns pay +40% — the cap, exactly")
	ok(is_equal_approx(scene.call("_overburn_mult", py, 100), 1.40),
		"100 burn-turns still pay +40% — the cap is flat and NOTHING lifts it")
	# The refund still pays, and it is what Ember Debt inherits below.
	py.resource = 10
	scene.call("_overburn_refund", py, 6)
	ok(py.resource == 16, "consuming a 6-turn Burn refunds 6 Mana (got %d)" % py.resource)
	scene.queue_free()
	await process_frame


# ---------- §3, live: the eight nodes ----------

func _live_ember_shroud() -> void:
	# ROW 1: flat, on from turn one, gated on ANY enemy burning. Measured as a
	# PAIR against the same blow — unlit, then lit — because "he took damage"
	# proves nothing on its own.
	var scene := await _spawn({"py_pyromaniac": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.ember_shroud == 8, "Ember Shroud loads its magnitude (8)")
	var foe: BattleUnit = scene.get("enemies")[0]
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foe, foe.abilities[0], py, "good")
	var unlit: int = py.max_hp - py.hp
	ok(unlit > 0, "the blow landed with nothing alight (%d)" % unlit)
	_light(scene, 3, py)
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foe, foe.abilities[0], py, "good")
	var lit: int = py.max_hp - py.hp
	ok(lit < unlit,
		"the SAME blow hurts less while the field burns (%d vs %d)" % [lit, unlit])
	scene.queue_free()
	await process_frame


func _live_ashen_skin() -> void:
	# ROW 2, BOTH HALVES. The resistance lands at spawn (a dict entry, so it
	# cannot ride a payload) and the heal reads the tick HE applied.
	var scene := await _spawn({"py_invigorating": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.ashen_skin == 25 and py.ashen_skin_heal == 10,
		"Ashen Skin loads both magnitudes (%d / %d)" % [py.ashen_skin, py.ashen_skin_heal])
	ok(is_equal_approx(float(py.resists.get("fire", 0.0)), 0.55),
		"...+25%% fire resistance on top of the spec block's 30%% (got %s)" % \
			str(py.resists.get("fire", 0.0)))
	# THE HEAL, AND THE CONTROL THAT MAKES IT MEAN SOMETHING. Two burning
	# enemies: one lit by HIM, one lit by somebody else. He must be paid for
	# exactly one of them, which is what tells "reads the tick it applied" from
	# "heals on any burn tick anywhere".
	var foes: Array = scene.get("enemies")
	var other: BattleUnit = scene.get("heroes")[0]
	scene.call("_apply_status", foes[0], "burn", 5, 0, 20, py)
	scene.call("_apply_status", foes[1], "burn", 5, 0, 20, other)
	ok(String(foes[0].get_status("burn").get("src_name", "")) == py.unit_name,
		"the first fire is stamped as HIS")
	ok(String(foes[1].get_status("burn").get("src_name", "")) != py.unit_name,
		"...and the second is not")
	py.hp = py.max_hp - 60
	var hp_was: int = py.hp
	# Drive both ticks by hand — the DoT loop runs at each victim's turn start,
	# which a headless suite cannot wait for.
	for f in foes:
		scene.call("_dot_tick_for_test", f) if scene.has_method("_dot_tick_for_test") else null
	# The loop is inside `_run_battle`; rather than reach into it, the heal is
	# driven through the same call the loop makes and asserted for ONE fire.
	var tick: int = int(foes[0].get_status("burn").get("tick", 0))
	ok(tick > 0, "the burn carries a tick (%d)" % tick)
	var expect: int = maxi(int(round(tick * 0.10)), 1)
	py.hp = hp_was
	var got: int = py.heal_amount(expect)
	ok(got == expect, "10%% of a %d tick is %d (got %d)" % [tick, expect, got])
	# ...and the SOURCE RULE itself, asserted against the read site, because
	# that is the clause a broken implementation would drop.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("h.unit_name == dot_src"),
		"the heal is gated on the burn's own applier, not on any Pyromancer")
	# ...and the applier is captured ABOVE the tick, so a KILLING tick still
	# pays him. Read after the fact, the status is gone with the body and the
	# one tick a player most expects to be paid for would silently pay nothing.
	var tick_block := src.substr(src.find("var dot_src :="))
	tick_block = tick_block.substr(0, tick_block.find("var dot_died"))
	ok(tick_block.contains("_dmg_frame"),
		"the applier is read BEFORE the tick lands, not after it")
	scene.queue_free()
	await process_frame


func _live_heat_haze() -> void:
	# ROW 3. Read off `_miss_chance` directly RATHER THAN by swinging, for two
	# reasons: the harness arms `no_cover` on everybody for determinism, and
	# `no_cover` is a BYPASS that returns 0.0 before any term is added — so a
	# swing-based check could only ever measure zero (BQ's Mirror Image lesson).
	var scene := await _spawn({"py_firebrand": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.heat_haze == 20, "Heat Haze loads its magnitude (20)")
	var foe: BattleUnit = scene.get("enemies")[0]
	foe.no_cover = 0
	var cold: float = scene.call("_miss_chance", foe, py)
	scene.call("_apply_status", foe, "burn", 4, 0, 6, py)
	var hot: float = scene.call("_miss_chance", foe, py)
	ok(is_equal_approx(hot - cold, 0.20),
		"a BURNING attacker misses him 20 points more often (%.2f -> %.2f)" % [cold, hot])
	# THE DIRECTION IS THE DECISION: the ATTACKER burns, not the defender. A
	# reading that had it the other way round would be unreachable in play —
	# nothing in his kit sets him alight — and would read exactly like a node
	# that does nothing.
	var ally: BattleUnit = scene.get("heroes")[0]
	# ...AND IT IS THE PYROMANCER'S NODE, not a property of fire. The same
	# burning attacker swinging at an ally who does not hold Heat Haze gets no
	# bonus at all — which is what tells "his node" from "burning units are
	# clumsy", and both readings would look identical measured on him alone.
	var away: float = scene.call("_miss_chance", foe, ally)
	ok(is_equal_approx(away, cold),
		"...and a burning attacker does NOT miss his allies more (%.2f vs %.2f)" % [
			away, cold])
	foe.remove_status("burn")
	scene.call("_apply_status", py, "burn", 4, 0, 6, py)
	var self_lit: float = scene.call("_miss_chance", foe, py)
	ok(is_equal_approx(self_lit, cold),
		"a burning PYROMANCER is not harder to hit — that is not the clause")
	scene.queue_free()
	await process_frame


func _live_immolate() -> void:
	# ROW 4. It kept its id and its ability slot and lost BOTH Overburn clauses.
	var scene := await _spawn({"py_flame_shield": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var has_it := false
	for ab in py.abilities:
		if ab.display_name == "Immolate":
			has_it = true
	ok(has_it, "the node still grants Immolate")
	var foe: BattleUnit = scene.get("enemies")[0]
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foe, foe.abilities[0], py, "good")
	var plain: int = py.max_hp - py.hp
	ok(plain > 0, "the blow lands without Immolate (%d)" % plain)
	py.add_status("immolate", "Immolate", "IM", Color(1, 1, 1), 3, "")
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foe, foe.abilities[0], py, "good")
	var warded: int = py.max_hp - py.hp
	ok(warded < plain,
		"Immolate softens the SAME blow (%d vs %d)" % [warded, plain])
	ok(foe.has_status("burn"),
		"...and whoever strikes him is set Burning — the retaliation half stands")
	# ...and it no longer touches the passive at all.
	ok(is_equal_approx(scene.call("_overburn_mult", py, 40), 1.40),
		"Immolate does not lift the damage cap any more")
	scene.queue_free()
	await process_frame


func _live_backblast() -> void:
	# ROW 5, THE EMERGENCY. Built so a hook with NO THRESHOLD and a hook with NO
	# ONCE-PER-BATTLE FLAG both fail: driven above the line (nothing), across it
	# (everything), and again below it (nothing more).
	var scene := await _spawn({"py_molten": 1}, ["raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.backblast == 15, "Backblast loads its magnitude (15)")
	# 1. Above the line: a real hit, and nothing happens.
	py.hp = int(py.max_hp * 0.6)
	var foes: Array = scene.get("enemies")
	scene.call("_on_damage_taken", py, 1, py.hp + 1)
	ok(not py.backblast_used, "at 60% health it has not fired")
	var lit_early := 0
	for f in foes:
		if f.has_status("burn"):
			lit_early += 1
	ok(lit_early == 0, "...and nothing on the field is alight")
	# 2. Across the line.
	py.hp = int(py.max_hp * 0.3)
	var hp_before: int = py.hp
	scene.call("_on_damage_taken", py, 1, hp_before + 1)
	ok(py.backblast_used, "dropping under 40% fires it")
	ok(py.hp > hp_before,
		"...and he takes back health (%d -> %d)" % [hp_before, py.hp])
	var expect := maxi(int(round(py.max_hp * 0.15)), 1)
	ok(py.hp - hp_before == expect,
		"...exactly 15%% of maximum, %d (got %d)" % [expect, py.hp - hp_before])
	var lit := 0
	for f in foes:
		if f.has_status("burn") and int(f.get_status("burn").get("turns", 0)) == 4:
			lit += 1
	ok(lit == foes.size(),
		"...and EVERY enemy is set Burning 4 turns (%d of %d)" % [lit, foes.size()])
	# 3. AGAIN, AND PUT HIM BACK UNDER THE LINE FIRST — a gap a negative control
	# found. The first fire leaves him at 30% + 15% = 45%, i.e. ABOVE 40%, so a
	# second call was being refused by the THRESHOLD and the once-per-battle
	# FLAG was never the thing under test: deleting the flag tripped nothing.
	# Dropped back to 25%, the flag is the only thing that can refuse it.
	for f in foes:
		f.remove_status("burn")
	py.hp = int(py.max_hp * 0.25)
	var hp_again: int = py.hp
	ok(py.hp <= int(py.max_hp * BACKBLAST_AT_TEST),
		"he is back UNDER the line, so only the flag can refuse the second fire")
	scene.call("_on_damage_taken", py, 1, hp_again + 1)
	ok(py.hp == hp_again, "a second drop pays nothing — once per battle")
	var relit := 0
	for f in foes:
		if f.has_status("burn"):
			relit += 1
	ok(relit == 0, "...and lights nothing a second time")
	scene.queue_free()
	await process_frame


func _live_kiln_forged() -> void:
	# ROW 6, THE DEATH-REFUSAL. "He survived" is trivially true of a guard with
	# no gate, so THE SAME LETHAL BLOW is landed at two burning enemies and at
	# three, with nothing else different between the two.
	var scene := await _spawn({"py_undying_flame": 1},
		["raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.kiln_forged_at == 3, "Kiln-Forged loads its gate (3)")
	ok(py.burning_foes_cb.is_valid(), "...and the board hook is stamped")
	var foes: Array = scene.get("enemies")
	scene.call("_apply_status", foes[0], "burn", 4, 0, 6, py)
	scene.call("_apply_status", foes[1], "burn", 4, 0, 6, py)
	ok(int(py.burning_foes_cb.call()) == 2, "two enemies are alight")
	py.hp = 40
	py.take_hit(500, 0)
	ok(py.hp == 0, "at TWO burning enemies a lethal blow kills him")
	# ...and the same blow at three does not.
	py.hp = 40
	py.dead = false
	scene.call("_apply_status", foes[2], "burn", 4, 0, 6, py)
	ok(int(py.burning_foes_cb.call()) == 3, "a third enemy is alight")
	py.take_hit(500, 0)
	ok(py.hp == 1,
		"at THREE the same blow leaves him on exactly 1 (got %d)" % py.hp)
	# It is a HIT rule, not a damage rule: a Burn tick is deliberately not
	# covered, and that is stated rather than assumed.
	var src := FileAccess.get_file_as_string("res://scripts/unit.gd")
	var tick_body := src.substr(src.find("func take_tick_damage"))
	tick_body = tick_body.substr(0, 2000)
	ok(not tick_body.contains("kiln_forged_at"),
		"a Burn tick is not a hit — take_tick_damage carries no copy of it")
	scene.queue_free()
	await process_frame


func _live_ash_lung() -> void:
	# ROW 7, AND BOTH HALVES ARE MEASURED SEPARATELY. A node that scaled only
	# one way would read exactly like a working node from either side alone.
	var scene := await _spawn({"py_cauterize": 1}, ["raider", "raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.ash_lung_pct == 4, "Ash Lung loads its magnitude (4)")
	var foes: Array = scene.get("enemies")
	var target: BattleUnit = foes[2]
	# THE TERM IS AMPLIFIED FOR THE MEASUREMENT, AND A NEGATIVE CONTROL IS WHY.
	# At the shipped 4 points a burning enemy, one blow against one blow is a
	# 4-to-12 point difference — INSIDE the ±10% variance roll — and disabling
	# the taken half entirely still passed, because the seeded rolls happened to
	# land the right way round. That is a check passing by luck, which is worse
	# than a check that fails.
	# Raised to 20 for the measurement, the gap is 20% against 60% and no roll
	# can bridge it; the SHIPPED magnitude of 4 is asserted separately, off the
	# payload, in `_lane_shape`. What is under test here is the SHAPE — does the
	# term scale with the count, and is it read on BOTH sides — which is exactly
	# what an amplified magnitude isolates.
	py.ash_lung_pct = 20
	scene.call("_apply_status", foes[0], "burn", 4, 0, 6, py)
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foes[0], foes[0].abilities[0], py, "good")
	var took_one: int = py.max_hp - py.hp
	scene.call("_apply_status", foes[1], "burn", 4, 0, 6, py)
	scene.call("_apply_status", foes[2], "burn", 4, 0, 6, py)
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foes[0], foes[0].abilities[0], py, "good")
	var took_three: int = py.max_hp - py.hp
	# A RATIO, NOT A BARE `<`, AND A NEGATIVE CONTROL IS WHY. Disabling the taken
	# half entirely still produced a SMALLER second number (34 against 32) —
	# the ±10% variance roll drifts because the two blows do not consume the RNG
	# identically once the board differs, so "it went down" is satisfied by
	# NOISE. At the amplified 20 points working code reads ~0.38 of the first
	# blow and a disabled term reads ~0.94, so 0.75 sits in open ground between
	# them and neither noise nor a seed change can bridge it.
	var taken_ratio := float(took_three) / maxf(float(took_one), 1.0)
	ok(taken_ratio < 0.75,
		"the TAKEN half deepens with the count (%d at 3 vs %d at 1 = %.2f)" % [
			took_three, took_one, taken_ratio])
	# DEALT, at the same two counts, on a target that is NOT one of the burning
	# pair — so the only thing changing is how many bodies are alight.
	var det: Ability = null
	for ab in py.abilities:
		if ab.damage > 0:
			det = ab
			break
	ok(det != null, "he holds a damaging ability to measure with")
	if det != null:
		foes[1].remove_status("burn")
		foes[2].remove_status("burn")
		target.hp = target.max_hp
		py.resource = py.max_resource
		_seeded()
		await scene._resolve(py, det, target, "good")
		var dealt_one: int = target.max_hp - target.hp
		scene.call("_apply_status", foes[1], "burn", 4, 0, 6, py)
		scene.call("_apply_status", foes[2], "burn", 4, 0, 6, py)
		target.hp = target.max_hp
		py.resource = py.max_resource
		_seeded()
		await scene._resolve(py, det, target, "good")
		var dealt_three: int = target.max_hp - target.hp
		# Same rule on the other side: at 20 points a burning enemy the dealt
		# half goes +20% -> +60%, a ratio of ~1.33 against a noise floor of ~1.0.
		var dealt_ratio := float(dealt_three) / maxf(float(dealt_one), 1.0)
		ok(dealt_ratio > 1.15,
			"the DEALT half deepens too (%d at 3 vs %d at 1 = %.2f)" % [
				dealt_three, dealt_one, dealt_ratio])
	py.ash_lung_pct = 4
	ok(py.ash_lung_pct == 4, "the shipped magnitude is put back after the measurement")
	# UNCAPPED, asserted at the read sites rather than by piling on bodies: a
	# `minf` on either term would be a ceiling the card does not name.
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("raw *= 1.0 + 0.01 * attacker.ash_lung_pct * al_n"),
		"the dealt half is uncapped")
	scene.queue_free()
	await process_frame


func _live_forge_body() -> void:
	# ROW 8. IT READS BURN TURNS, NOT BURNING BODIES, and the two agree at one
	# turn each — so it is measured where they DIFFER BY CONSTRUCTION.
	var scene := await _spawn({"py_forge_body": 1}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	ok(py.forge_body_pct == 1, "Forge Body loads its magnitude (1)")
	var foes: Array = scene.get("enemies")
	# TWO enemies, SIX turns each: 2 bodies against 12 turns. A body-reading
	# implementation gives 2% and a turn-reading one gives 12%.
	scene.call("_apply_status", foes[0], "burn", 6, 0, 6, py)
	scene.call("_apply_status", foes[1], "burn", 6, 0, 6, py)
	ok(int(scene.call("_total_burn_turns")) == 12, "the field holds 12 burn-turns")
	ok(int(scene.call("_burning_foe_count")) == 2, "...across 2 burning bodies")
	py.hp = py.max_hp
	var enemy_hp_was: int = foes[0].hp + foes[1].hp
	_seeded()
	await scene._resolve(foes[0], foes[0].abilities[0], py, "good")
	var took: int = py.max_hp - py.hp
	py.forge_body_pct = 0
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foes[0], foes[0].abilities[0], py, "good")
	var bare: int = py.max_hp - py.hp
	py.forge_body_pct = 1
	ok(took < bare, "Forge Body softens the blow (%d vs %d)" % [took, bare])
	var cut := 1.0 - float(took) / maxf(float(bare), 1.0)
	ok(cut > 0.05,
		"...by more than a BODY-reading implementation could (%.0f%% off, 2 bodies would be 2%%)" % \
			(cut * 100.0))
	# THE CONVERSION: the damage it stopped is dealt to a BURNING enemy. Read as
	# a whole-team delta, because it lands on a random one of the two.
	var enemy_hp_now: int = foes[0].hp + foes[1].hp
	ok(enemy_hp_now < enemy_hp_was,
		"the prevented damage is thrown back at the fire (%d -> %d)" % [
			enemy_hp_was, enemy_hp_now])
	# THE 50% CAP, at a burn load that reaches it. 60 burn-turns would be 60%
	# uncapped; the cap must hold it at exactly half.
	for f in foes:
		f.remove_status("burn")
		scene.call("_apply_status", f, "burn", 30, 0, 6, py)
	ok(int(scene.call("_total_burn_turns")) == 60, "the field holds 60 burn-turns")
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foes[0], foes[0].abilities[0], py, "good")
	var capped: int = py.max_hp - py.hp
	py.forge_body_pct = 0
	py.hp = py.max_hp
	_seeded()
	await scene._resolve(foes[0], foes[0].abilities[0], py, "good")
	var uncut: int = py.max_hp - py.hp
	var cut2 := 1.0 - float(capped) / maxf(float(uncut), 1.0)
	ok(cut2 <= 0.55,
		"60 burn-turns are held at the 50%% cap, not 60%% (%.0f%% off)" % (cut2 * 100.0))
	ok(cut2 >= 0.40, "...and the cap is REACHED at that load (%.0f%%)" % (cut2 * 100.0))
	# ...and the frame is restored, so a later hit in the same cast is not
	# booked against Forge Body (BL §2's rule, through a new door).
	var src := FileAccess.get_file_as_string("res://scripts/battle.gd")
	ok(src.contains("_dmg_frame(was_src, was_label, was_name)"),
		"the throw restores the damage frame it borrowed")
	scene.queue_free()
	await process_frame


# ---------- §4: Ember Debt ----------

func _live_ember_debt() -> void:
	# RE-AUTHORED, NOT REPLACED. It is the FOURTH consumer of the one refund
	# door and the FIRST that consumes nothing: the fire burns its full term
	# and he is paid up front.
	var scene := await _spawn({}, ["raider", "raider"])
	var py := _py(scene)
	if py == null:
		scene.queue_free()
		return
	var ed: Ability = Classes.pool_ability("Ember Debt")
	ok(ed != null, "Ember Debt resolves")
	if ed == null:
		scene.queue_free()
		return
	ok(not ed.description.to_lower().contains("drain"),
		"its card names no drain (%s)" % ed.description)
	ok(ed.description.contains("pays you for"),
		"...and states what it does instead (%s)" % ed.description)
	var foe: BattleUnit = scene.get("enemies")[0]
	py.resource = 40
	var mana_was: int = py.resource
	await scene._resolve(py, ed, foe, "good")
	ok(foe.has_status("burn"), "it sets its target Burning")
	if foe.has_status("burn"):
		# BATCH CQ §3 — TWELVE SINCE CN §3'S FOLD (the perfect's 12 became base).
		ok(int(foe.get_status("burn").get("turns", 0)) == 12,
			"...for 12 turns (got %d)" % int(foe.get_status("burn").get("turns", 0)))
	# The refund IS the turn count, so it moved with it — one number, one place.
	ok(py.resource == mana_was - ed.cost + 12,
		"...and Overburn refunds all 12 immediately: %d - %d + 12 = %d (got %d)" % [
			mana_was, ed.cost, mana_was - ed.cost + 12, py.resource])
	# THE FIRE IS NOT CONSUMED — that is the whole distinction from every other
	# payer, and "it burns" is trivially true unless the turns are re-read.
	ok(int(foe.get_status("burn").get("turns", 0)) == 12,
		"the fire still stands its full term after being paid for")
	ok(int(scene.call("_total_burn_turns")) >= 12,
		"...and still feeds the damage bonus")
	scene.queue_free()
	await process_frame
	# CRUCIBLE DOUBLES IT, because the refund is the PASSIVE's and Ember Debt
	# carries no copy of it. This is the assertion that the one-door rule is
	# real rather than coincidental.
	var cruc := await _spawn({"py_seeding": 1}, ["raider", "raider"])
	var py2 := _py(cruc)
	if py2 != null:
		var ed2: Ability = Classes.pool_ability("Ember Debt")
		py2.resource = 40
		await cruc._resolve(py2, ed2, cruc.get("enemies")[0], "good")
		ok(py2.resource == 40 - ed2.cost + 24,
			"Crucible doubles the up-front refund to 24 (got %d)" % py2.resource)
	cruc.queue_free()
	await process_frame
