# BATCH IQ — THE THREE DOCUMENTS, AND ONE CRASH.
#
#   §0   The rulings recorded, each pinned in the file it binds: a tie that survives its second block, the cuts that move
#        with the deck, the save's guard, and the two instrument rules.
#   §1   `docs/state.md`'s closed blocks stand in the archive and not in the live file, the archive's newest cut on top.
#   §2   `docs/master.html`'s figures that have a door, read on both sides: every card's price in the draft catalogue and in
#        the class sections' statlines against the card's own fields, the bargain deck against `Run.MODIFIERS`, the rewards
#        against `Run.REWARDS` and the ladder against `Run.DIFFICULTIES`.
#   §4   A REMOVAL OWES THE SAVE A GUARD, NOT A RE-ASK (the designer's). A bargain's offer is rolled once for its
#        encounter and saved with it (GF), so a save frozen on the offer screen carries modifier ids the deck may no
#        longer hold. DRIVEN through the real save, the real load door and the real offer screen: an option naming an id
#        the deck does not hold is DROPPED at the load and the screen draws one card fewer; an offer left with none is
#        dropped whole and the screen deals a fresh one (the one re-ask); a clean offer loads untouched; and the load
#        spends no die. **AND THE GUARD SWALLOWS NOTHING THE CODE CHOSE**: an offer this session rolled is never filtered,
#        and the offer screen reads the deck straight, so an id the code chose that the deck does not hold still fails
#        where it is read. The save-keyed reads the census found to crash are held in §4b.
#   §7   THE LANE DRIVER REFUSES A SCRATCH COPY THAT RUNS AS THE LIVE PROJECT. `lane.sh` is DRIVEN (it is a shell script,
#        so the gate runs it): a copy named as the live project is refused, renamed it runs, the repository is refused as
#        a lane, and a copy with no name is refused.
#   §9   The player's files are as this gate found them.
#
# **WHAT THIS GATE CANNOT SEE, SAID FIRST.** That a lane a batch launched by hand went through the driver: the rule makes
# the driver the one way a lane runs, and this gate holds the driver's refusal, not the batch's habits.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_iq.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}

# §4 — ids a save can carry that the deck no longer holds: the three the deck has removed (IO §1a, IP §1a), named as a
# save written before each removal names them.
const STALE := ["hungering_dark", "famine", "cruel_order"]
const SEATS := ["warrior", "mage", "cleric", "hunter"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IQ — THE THREE DOCUMENTS, AND ONE CRASH")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s0_the_rulings()
	_s1_the_cut()
	_s2_master_figures()
	await _s4_the_stale_offer()
	_s4_swallows_nothing_chosen()
	_s4b_the_other_keys()
	_s7_the_lane_driver()
	_s9_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


func _body(path: String, fn: String) -> String:
	var src := _src(path)
	var at := src.find("\nfunc " + fn + "(")
	if at < 0:
		return ""
	var end := src.find("\nfunc ", at + 6)
	var end2 := src.find("\nstatic func ", at + 6)
	if end2 >= 0 and (end < 0 or end2 < end):
		end = end2
	return src.substr(at, (end if end >= 0 else src.length()) - at)


func _new_run() -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], "standard")
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true


func _ids(offer: Variant) -> Array:
	var out: Array = []
	if offer is Array:
		for o in offer:
			out.append(String((o as Dictionary).get("modifier", "")))
	return out


# The offer screen as the player meets it: opened on the run in memory, its cards counted by the tag every part of a
# card carries (`bargain_card`, IH §6). Returns [the offer the screen holds, the cards it drew].
func _open_offer_screen() -> Array:
	change_scene_to_file("res://scenes/offer.tscn")
	await Gate.frames(self, 6)
	var scene := current_scene
	var cards := {}
	if scene != null:
		for c in scene.get_children():
			if c.has_meta("bargain_card"):
				cards[int(c.get_meta("bargain_card"))] = true
	var held: Array = _ids(scene.get("offer") if scene != null else null)
	return [held, cards.size()]


# ── §4 — THE STALE OFFER ────────────────────────────────────────────────────

func _s4_the_stale_offer() -> void:
	print("\n§4 — a stored offer naming a modifier the deck no longer holds: dropped at the load, never re-rolled")
	var path := String(_run.save_path)
	ok(path != String(_run.SAVE_PATH), "§4: the gate is on the player's save path (%s)" % path)
	if path == String(_run.SAVE_PATH):
		return
	var had_file := FileAccess.file_exists(path)
	var had := FileAccess.get_file_as_bytes(path) if had_file else PackedByteArray()
	for id in STALE:
		ok(not (_run.MODIFIERS as Dictionary).has(String(id)), "§4: `%s` is in the deck — it is not a removed id" % id)
	# Three arms: one option stale, every option stale, none. The offer is the code's own roll, then the save's ids are
	# written over it as a save from before a removal would carry them.
	for arm in ["one", "all", "none"]:
		_new_run()
		_run.encounter = {"type": "elite", "enemies": ["orc_raider"], "theme": "Warband"}
		var offer: Array = _run.encounter_offer()
		ok(offer.size() == 3, "§4 %s: the roll dealt %d options, not three" % [arm, offer.size()])
		if offer.size() != 3:
			continue
		var want: Array = _ids(offer)
		if arm == "one":
			offer[1]["modifier"] = STALE[0]
			want.remove_at(1)
		elif arm == "all":
			for k in 3:
				offer[k]["modifier"] = STALE[k]
			want = []
		_run.encounter["offer"] = offer
		var written: Array = (offer as Array).duplicate(true)
		_run.save_run()
		# NO DIE IS SPENT BY THE LOAD: the same seed reads the same next number on either side of it.
		seed(2026101901)
		var before := randi()
		seed(2026101901)
		var loaded: bool = _run.load_run()
		var after := randi()
		ok(loaded, "§4 %s: the save did not load" % arm)
		ok(before == after, "§4 %s: loading the save spent a die" % arm)
		var stored: Variant = _run.encounter.get("offer")
		if arm == "all":
			ok(stored == null, "§4 all: an offer whose every option names a removed id was not dropped whole — the load kept %s" % str(_ids(stored)))
		elif arm == "one":
			ok(_ids(stored) == want, "§4 one: the load kept %s, not the two the deck holds %s, in their order" % [str(_ids(stored)), str(want)])
		else:
			ok(stored is Array and (stored as Array) == written, "§4 none: a clean offer did not load as it was saved — %s" % str(_ids(stored)))
		var seen: Array = await _open_offer_screen()
		var held: Array = seen[0]
		var drawn: int = seen[1]
		var stale_left := held.filter(func(i): return STALE.has(i))
		ok(stale_left.is_empty(), "§4 %s: the offer screen holds a removed id %s" % [arm, str(stale_left)])
		ok(drawn == held.size() and drawn == (2 if arm == "one" else 3),
			"§4 %s: the offer screen drew %d cards for an offer of %d (%s)" % [arm, drawn, held.size(), str(held)])
		if arm == "one":
			ok(held == want, "§4 one: the screen showed %s, not the two the save kept %s — it was re-rolled" % [str(held), str(want)])
		elif arm == "none":
			ok(held == _ids(written), "§4 none: the screen showed %s, not the offer saved %s" % [str(held), str(_ids(written))])
		print("    %s stale: saved %s -> shown %s, %d cards" % [arm, str(_ids(written)), str(held), drawn])
	_run.active = false
	# Put the harness file back as this gate found it.
	if had_file:
		var fr := FileAccess.open(path, FileAccess.WRITE)
		fr.store_buffer(had)
		fr.close()
	elif FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 3)


func _s4_swallows_nothing_chosen() -> void:
	print("\n§4 — the guard swallows nothing the code chose")
	# An offer THIS SESSION holds never passes the load door, so an id in it the deck does not hold — a code defect, not a
	# save's — is handed to the screen as it stands, and the screen's straight read fails on it.
	_new_run()
	_run.encounter = {"type": "elite", "enemies": ["orc_raider"], "theme": "Warband",
		"offer": [{"modifier": "iq_not_in_the_deck", "reward": {"kind": "gold", "amount": 1}}]}
	ok(_ids(_run.encounter_offer()) == ["iq_not_in_the_deck"],
		"§4: an offer this session holds was filtered before the screen — %s" % str(_ids(_run.encounter_offer())))
	var rs := _src("scripts/run_state.gd")
	var calls := rs.count("_drop_stale_offer_options()") - rs.count("func _drop_stale_offer_options()")
	ok(calls == 1 and _body("scripts/run_state.gd", "load_run").contains("_drop_stale_offer_options()"),
		"§4: the stale-offer filter is called somewhere other than the load door, or not once")
	ok(not _body("scripts/run_state.gd", "encounter_offer").contains("MODIFIERS"),
		"§4: `encounter_offer` asks the deck — the filter has reached the session's own offers")
	ok(_body("scripts/offer_screen.gd", "_draw_option_parts").contains("var cfg: Dictionary = Run.MODIFIERS[mod_id]"),
		"§4: the offer screen no longer reads the deck straight — a defect in the code's own ids would pass silently")
	_run.encounter = {}
	_run.active = false


# ── §4b — EVERY OTHER KEY THE CENSUS FOUND READ STRAIGHT ────────────────────
#
# IQ's census of every read of save data through a data table (IQ's report, §4) found, beside the offer, nine more reads
# that a save naming something gone would take down: the map's swap offer (`ITEM_INFO`), four zone reads (`ZONE_DEFS`),
# eight lineage reads (`SPEC_INFO`), three class reads (`CLASS_PASSIVES`, `CLASS_BLURBS`) and a rune payload's `add` —
# and one that strands the run, the event screen. None is reachable by a save that exists: the guards are for the next
# removal. Each is DRIVEN here through the real save and the real load door, one stale key at a time.

func _roundtrip() -> bool:
	_run.save_run()
	return _run.load_run()


func _s4b_the_other_keys() -> void:
	print("\n§4b — the other keys a save brings in: each dropped where the save is read, or the save refused")
	var path := String(_run.save_path)
	if path == String(_run.SAVE_PATH):
		return
	var had_file := FileAccess.file_exists(path)
	var had := FileAccess.get_file_as_bytes(path) if had_file else PackedByteArray()
	# The pouch: a held type and a waiting swap offer the item table no longer holds.
	_new_run()
	_run.items["iq_gone_item"] = 2
	_run.pending_item_offers = ["iq_gone_item", "health"]
	ok(_roundtrip(), "§4b items: the save did not load")
	ok(not (_run.items as Dictionary).has("iq_gone_item") and _run.pending_item_offers == ["health"],
		"§4b items: the load kept a type the item table does not hold — pouch %s, offers %s" % [str(_run.items.keys()), str(_run.pending_item_offers)])
	# The zone draw: a zone the table does not hold takes its slot's first candidate, and the name follows.
	_new_run()
	_run.zone_draw = ["forest", "iq_gone_zone", "forest"]
	_run.zone_idx = 1
	_run.zone_name = "iq nowhere"
	ok(_roundtrip(), "§4b zone: the save did not load")
	var slot1 := String((_run.SLOT_POOLS[1] as Array)[0])
	ok(String(_run.zone_draw[1]) == slot1 and String(_run.zone_name) == String(_run.ZONE_DEFS[slot1]["name"]),
		"§4b zone: the load kept %s / '%s' — not slot 1's first candidate %s" % [str(_run.zone_draw), _run.zone_name, slot1])
	ok(String(_run.boss_kind()) == String(_run.ZONE_DEFS[slot1]["boss"]), "§4b zone: the map's boss read '%s'" % _run.boss_kind())
	# The event in flight: an id the event table does not hold is cleared, and the resume walks to the map.
	_new_run()
	_run.pending_event = "iq_gone_event"
	ok(_roundtrip(), "§4b event: the save did not load")
	ok(String(_run.pending_event) == "" and String(_run.resume_scene()).ends_with("map.tscn"),
		"§4b event: the load kept '%s' and resumes to %s" % [_run.pending_event, _run.resume_scene()])
	# A lineage the table does not hold is read again off the engines the hero holds.
	_new_run()
	var lineage := String(_run.party[0].get("spec", ""))
	# The seat takes the class's first engine (`_new_run`), so the arm names the engine it picked with the lineage it read.
	var picked := String(Classes.class_engines("warrior")[0])
	ok(lineage != "" and Classes.SPEC_INFO.has(lineage),
		"§4b spec: the Warrior seated on '%s' has no lineage to stale ('%s')" % [picked, lineage])
	_run.party[0]["spec"] = "iq_gone_spec"
	ok(_roundtrip(), "§4b spec: the save did not load")
	ok(String(_run.party[0].get("spec", "")) == lineage,
		"§4b spec: the load kept '%s', not the lineage his engine '%s' reads (%s)" % [String(_run.party[0].get("spec", "")), picked, lineage])
	# A hero of a class this build does not have: a party it cannot field, refused down the floor's path.
	_new_run()
	_run.party[1]["key"] = "iq_gone_class"
	ok(not _roundtrip() and not FileAccess.file_exists(path),
		"§4b class: a save holding a class this build does not have was loaded, or kept")
	# A saved rune's ability payload adding to a property a card does not have: the field is dropped, the rest pays.
	_new_run()
	var r := Runes.build(String(Runes.ids()[0]))
	r["payload"] = {"ability": "Strike", "add": {"iq_gone_field": 3, "cost": -1},
		"also": [{"ability": "Strike", "add": {"iq_gone_two": 1}}]}
	r["equipped"] = true
	(_run.party[0]["runes"] as Array).append(r)
	ok(_roundtrip(), "§4b payload: the save did not load")
	var lp: Dictionary = ((_run.party[0]["runes"] as Array).back() as Dictionary)["payload"]
	ok(lp.get("add") == {"cost": -1} and ((lp.get("also") as Array)[0] as Dictionary).get("add") == {},
		"§4b payload: the load kept a field a card does not have on '%s' — add %s, also %s"
		% [String(((_run.party[0]["runes"] as Array).back() as Dictionary).get("id", "")), str(lp.get("add")), str(lp.get("also"))])
	# EVERY FILTER RUNS WHERE THE SAVE IS READ, AND ONLY THERE: a key the code chose never meets one.
	var rs := _src("scripts/run_state.gd")
	var lr := _body("scripts/run_state.gd", "load_run")
	for fn in ["_drop_stale_save_keys", "_drop_stale_payload_fields"]:
		var n := rs.count(fn + "()") - rs.count("func " + fn + "()")
		ok(n == 1 and lr.contains(fn + "()"), "§4b: `%s` is called %d times, or not from the load door" % [fn, n])
	_run.active = false
	if had_file:
		var fr := FileAccess.open(path, FileAccess.WRITE)
		fr.store_buffer(had)
		fr.close()
	elif FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("    items, zone, event, lineage, class and payload: each driven through the save and the load door")


# ── §0 — THE RULINGS RECORDED ───────────────────────────────────────────────
#
# Each rule is pinned against the file it lives in (the index hazard: a heading row in `CLAUDE.md` can satisfy a pin while
# the rule it names is gone), once, and the tie rule's two halves where the tie rule stands.

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings recorded, each in the file it binds")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	ok(ir.count("A TIE THAT SURVIVES ITS SECOND BLOCK IS A MEASUREMENT THAT SUCCEEDED") == 1,
		"§0.2: `docs/instrument-rules.md` does not state once that a tie surviving its second block is a measurement that succeeded")
	ok(ir.contains("Two modifiers that cost the same belong in the same grade"),
		"§0.2: `docs/instrument-rules.md` does not carry the designer's words on two modifiers that cost the same")
	ok(ir.contains("the cuts move when the deck does"), "§0.3: `docs/instrument-rules.md` does not say the cuts move when the deck does")
	# The tie rule and its two qualifications stand together: the second block's rule follows the tie rule's heading.
	var tie := ir.find("A CUT INSIDE TWO STANDARD ERRORS IS NOT A MEASUREMENT, IT IS A TIE")
	var after := ir.find("A TIE THAT SURVIVES ITS SECOND BLOCK", maxi(tie, 0))
	var next_rule := ir.find("\n## ", maxi(tie, 0) + 4)
	ok(tie >= 0 and after > tie and (next_rule < 0 or after < next_rule),
		"§0.2: the second block's rule does not stand inside the tie rule's block")
	ok(cm.count("A REMOVAL OWES THE SAVE A GUARD, NOT A RE-ASK") == 1,
		"§0.6: `CLAUDE.md` does not state once that a removal owes the save a guard")
	ok(ir.count("A GUARD ON A KEY A SAVE BRINGS IN IS PROVED BY TWO ARMS") == 1,
		"§4: `docs/instrument-rules.md` does not head the guard's two-arm rule once")
	ok(ir.count("A SCRATCH COPY ASSERTS ITS OWN PROJECT NAME BEFORE IT LAUNCHES ANYTHING") == 1,
		"§7: `docs/instrument-rules.md` does not head the lane's name rule once")


# ── §1 — THE STATE FILE's CUT ───────────────────────────────────────────────
#
# IQ's census of `docs/state.md` moved nine closed blocks to the archive word for word (IQ's report, §1). Six are held by
# their headings — in the archive, and not in the live file — with the archive's newest cut at its top (IO §7).

const MOVED := ["### THE LOYALTY CURVE", "### THE FOUR RUNE ITEMS", "### THE FLAKES", "### **AND NO SWEEP OF THE SOURCE CAN CERTIFY",
	"### A QUIT FIGHT RESTARTS AGAINST A RESET WARBAND", "### Last measurements"]


func _s1_the_cut() -> void:
	print("\n§1 — the closed blocks stand in the archive, and not in the live file")
	var live := FileAccess.get_file_as_string("res://docs/state.md")
	var arch := FileAccess.get_file_as_string("res://DoD-archive/state-archive.md")
	ok(live.length() > 100000 and arch.length() > 100000, "§1: the live file or the archive did not read")
	for h in MOVED:
		ok(arch.contains("\n" + String(h)), "§1: the archive does not hold '%s'" % h)
		ok(not live.contains("\n" + String(h)), "§1: the live file still holds '%s'" % h)
	var codes: Array = []
	var rx := RegEx.create_from_string("(?m)^## ARCHIVED AT ([A-Z]{2})")
	for m in rx.search_all(arch):
		codes.append(m.get_string(1))
	ok(not codes.is_empty() and String(codes[0]) >= "IQ",
		"§1: the archive's first cut is %s — IQ's own or a later batch's goes at the top" % (str(codes[0]) if not codes.is_empty() else "none"))
	ok(codes.size() >= 2 and String(codes[0]) > String(codes[1]), "§1: the archive's cuts are not newest first — %s" % str(codes.slice(0, 3)))
	print("    %d moved headings held; cuts, newest first: %s" % [MOVED.size(), " ".join(PackedStringArray(codes.slice(0, 4)))])


# ── §2 — master.html's FIGURES THAT HAVE A DOOR, READ ON BOTH SIDES ─────────
#
# IQ's census of `docs/master.html` (IQ's report, §2) read every fact in it against the code; the figures a script can
# read on both sides are held here, so the next drift reds where the census found the last ones only by reading. A card's
# figures are its own fields (`Classes.ability_corpus`, the one enumeration); a modifier's, a reward's and a rung's are
# `Run`'s tables. A figure a handler holds as a literal has no door, and is the census's alone.

func _corpus_by_name() -> Dictionary:
	var out := {}
	for ab in Classes.ability_corpus():
		out[String(ab.display_name)] = ab
	return out


func _card_cost(ab: Ability, res: String) -> int:
	return int(ab.faith_cost) if res == "Mercy" else int(ab.cost)


func _fig(x: float) -> String:
	return str(int(x)) if x == floorf(x) else str(x)


# One price on a card: what the document says against the card's field. Returns 1 for a figure read, 0 for none.
func _price(wrong: Array, where: String, name: String, what: String, said: float, field: float) -> int:
	if absf(said - field) > 0.0001:
		wrong.append("%s: %s's %s reads %s, the card's is %s" % [where, name, what, _fig(said), _fig(field)])
	return 1


func _s2_master_figures() -> void:
	print("\n§2 — master.html's figures that have a door, read on both sides")
	var doc := FileAccess.get_file_as_string("res://docs/master.html")
	var cards := _corpus_by_name()
	ok(cards.size() > 200, "§2: the ability corpus read %d cards" % cards.size())
	var wrong: Array = []
	# §2a — the draft's catalogue: every table row whose first cell names a card, its price cell's figures.
	var row := RegEx.create_from_string("<tr><td><b>([^<]+)</b></td><td>([^<]*?)</td>")
	var cell := RegEx.create_from_string("^(\\d+|free)(?: (Rage|Mana|Mercy))?, (\\d+(?:\\.\\d+)?), (\\d+)cd(.*)$")
	var bd_cell := RegEx.create_from_string("\\((\\d+) BD\\)")
	var rows := 0
	var priced := 0
	var figs_a := 0
	var prose_cells: Array = []
	for m in row.search_all(doc):
		var name := m.get_string(1).strip_edges()
		if not cards.has(name):
			continue
		rows += 1
		var c := m.get_string(2).strip_edges().replace("\n", " ")
		var mm := cell.search(c)
		if mm == null:
			prose_cells.append(name)
			continue
		priced += 1
		var ab: Ability = cards[name]
		var cost := 0 if mm.get_string(1) == "free" else int(mm.get_string(1))
		figs_a += _price(wrong, "§2a", name, "cost", cost, _card_cost(ab, mm.get_string(2)))
		figs_a += _price(wrong, "§2a", name, "initiative", float(mm.get_string(3)), float(ab.delay))
		figs_a += _price(wrong, "§2a", name, "cooldown", int(mm.get_string(4)), int(ab.cooldown))
		var bd := bd_cell.search(mm.get_string(5))
		if bd != null:
			figs_a += _price(wrong, "§2a", name, "Break damage", int(bd.get_string(1)), int(ab.pressure))
	# A price cell written as prose is a NAMED set: Boil Over's price is the whole bar, which no figure states.
	ok(prose_cells == ["Boil Over"], "§2a: the catalogue's price cells in prose are %s, not Boil Over's alone" % str(prose_cells))
	ok(priced >= 124 and rows == priced + prose_cells.size(),
		"§2a: the catalogue priced %d of %d card rows — the parse found too few to hold the column" % [priced, rows])
	# §2b — a card's statline in prose: `Name — 25 Rage, 26 dmg / 18 BD / 3.0, 2cd`, anchored on a card's own name, read
	# on the unwrapped text (a statline breaks across a line in the source).
	var flat := doc.replace("\n", " ").replace("&mdash;", "—")
	var stat := RegEx.create_from_string("^ — (\\d+|free)(?: (Rage|Mana|Mercy))?, (.{0,90}?)(\\d+(?:\\.\\d+)?), (\\d+cd|no cd)")
	var lead_dmg := RegEx.create_from_string("^(\\d+) dmg")
	var tail_bd := RegEx.create_from_string("(\\d+) BD / $")
	var stop := RegEx.create_from_string("[;<]|\\d+cd")
	var names: Array = cards.keys()
	names.sort_custom(func(a, b): return String(a).length() > String(b).length())
	var taken: Array = []
	var lines := 0
	var figs_b := 0
	for n in names:
		var from := 0
		while true:
			var at := flat.find(String(n) + " — ", from)
			if at < 0:
				break
			from = at + 1
			var inside := false
			for span in taken:
				if at >= int(span[0]) and at < int(span[1]):
					inside = true
			if inside:
				continue
			var tail := flat.substr(at + String(n).length(), 160)
			var mm := stat.search(tail)
			if mm == null or stop.search(mm.get_string(3)) != null:
				continue
			taken.append([at, at + String(n).length() + mm.get_end()])
			lines += 1
			var ab: Ability = cards[n]
			var mid := mm.get_string(3)
			var cost := 0 if mm.get_string(1) == "free" else int(mm.get_string(1))
			var cd := 0 if mm.get_string(5) == "no cd" else int(mm.get_string(5).trim_suffix("cd"))
			figs_b += _price(wrong, "§2b", n, "cost", cost, _card_cost(ab, mm.get_string(2)))
			figs_b += _price(wrong, "§2b", n, "initiative", float(mm.get_string(4)), float(ab.delay))
			figs_b += _price(wrong, "§2b", n, "cooldown", cd, int(ab.cooldown))
			if not mid.contains("×"):
				var dm := lead_dmg.search(mid)
				if dm != null:
					figs_b += _price(wrong, "§2b", n, "damage", int(dm.get_string(1)), int(ab.damage))
				var tb := tail_bd.search(mid)
				if tb != null:
					figs_b += _price(wrong, "§2b", n, "Break damage", int(tb.get_string(1)), int(ab.pressure))
	ok(lines >= 78, "§2b: the statline parse found %d statlines — too few to hold the prose's figures" % lines)
	# §2c — the bargain deck: every row of the modifier table against `Run.MODIFIERS`, both directions, and the pool's count.
	var deck := {}
	for id in _run.MODIFIERS:
		deck[String(_run.MODIFIERS[id]["name"])] = int(_run.MODIFIERS[id]["severity"])
	var t0 := doc.find("<tr><th>Modifier</th><th>Severity</th>")
	var t1 := doc.find("</table>", t0)
	ok(t0 >= 0 and t1 > t0, "§2c: the modifier table is not in the document")
	var mod_row := RegEx.create_from_string("<tr><td>([^<]+)</td><td>(\\d)</td>")
	var listed := {}
	for m in mod_row.search_all(doc.substr(t0, t1 - t0)):
		var name := m.get_string(1).strip_edges()
		listed[name] = true
		if not deck.has(name):
			wrong.append("§2c: the modifier table lists '%s', which the deck does not hold" % name)
		elif deck[name] != int(m.get_string(2)):
			wrong.append("§2c: '%s' is listed at severity %s, the deck's is %d" % [name, m.get_string(2), deck[name]])
	for name in deck:
		if not listed.has(name):
			wrong.append("§2c: the deck holds '%s', which the modifier table does not list" % name)
	ok(doc.contains("The pool is %d" % deck.size()), "§2c: the document does not say the pool is %d" % deck.size())
	# §2d — the reward table's gold, severity by severity, against `Run.REWARDS`.
	var paid := 0
	for sev in _run.REWARDS:
		for r in _run.REWARDS[sev]:
			if String((r as Dictionary).get("kind", "")) == "gold":
				paid += 1
				var said := "<tr><td>%d</td><td>%d gold" % [int(sev), int(r["amount"])]
				if not doc.contains(said):
					wrong.append("§2d: the reward table does not pay severity %d %d gold" % [int(sev), int(r["amount"])])
	ok(paid == 5, "§2d: the reward table's gold figures read %d severities" % paid)
	# §2e — the ladder: each rung's multiplier, and the bands its twist names, against `Run.DIFFICULTIES`.
	var plain := flat.replace("&ndash;", "–")
	plain = RegEx.create_from_string("<[^>]+>").sub(plain, " ", true)
	plain = RegEx.create_from_string(" {2,}").sub(plain, " ", true)
	for id in _run.DIFFICULTY_ORDER:
		var d: Dictionary = _run.DIFFICULTIES[id]
		var mult := "%d — %s ×%.2f" % [int(d["rung"]), String(d["name"]), float(d["mult"])]
		if not plain.contains(mult):
			wrong.append("§2e: the ladder does not read '%s'" % mult)
	for id in ["warden", "ruin"]:
		var d: Dictionary = _run.DIFFICULTIES[id]
		var sb: Array = d["safe_band"]
		var said := "dealt from severity %d–%d and its gambles at severity %d" % [int(sb[0]), int(sb[1]), int((d["gamble_band"] as Array)[0])]
		if not plain.contains(said):
			wrong.append("§2e: the ladder's %s twist does not read '%s'" % [String(d["name"]), said])
	for w in wrong:
		print("    " + String(w))
	ok(wrong.is_empty(), "§2: %d of master.html's figures disagree with their doors — %s" % [wrong.size(), "; ".join(PackedStringArray(wrong.slice(0, 3)))])
	print("    CHECKED: the catalogue %d figures over %d rows, the prose %d figures over %d statlines, the deck's %d rows, %d rewards, three rungs"
		% [figs_a, priced, figs_b, lines, listed.size(), paid])


# ── §7 — THE LANE DRIVER ────────────────────────────────────────────────────

func _driver(args: Array) -> Array:
	var out: Array = []
	var code := OS.execute("/bin/zsh", PackedStringArray([ProjectSettings.globalize_path("res://lane.sh")] + args), out, true)
	return [code, "\n".join(PackedStringArray(out)).strip_edges()]


func _fake_tree(dir: String, name: String) -> void:
	DirAccess.make_dir_recursive_absolute(dir)
	var f := FileAccess.open(dir.path_join("project.godot"), FileAccess.WRITE)
	f.store_string("config_version=5\n\n[application]\n\n" + ("config/name=\"%s\"\n" % name if name != "" else ""))
	f.close()


func _s7_the_lane_driver() -> void:
	print("\n§7 — the lane driver refuses a scratch copy that runs as the live project")
	ok(FileAccess.file_exists("res://lane.sh"), "§7: `lane.sh` is not in the tree")
	if not FileAccess.file_exists("res://lane.sh"):
		return
	var live: Array = _driver(["live"])
	var live_name := String(live[1])
	ok(int(live[0]) == 0 and live_name != "", "§7: the driver reads no live project name (%s)" % str(live))
	var base := "/tmp/dod_iq_lane_probe_%d" % OS.get_process_id()
	var as_live := base + "/as_live"
	var as_own := base + "/as_own"
	var unnamed := base + "/unnamed"
	_fake_tree(as_live, live_name)
	_fake_tree(as_own, live_name + " IQ probe")
	_fake_tree(unnamed, "")
	var r_live: Array = _driver(["check", as_live])
	ok(int(r_live[0]) == 1 and String(r_live[1]).contains("the LIVE project"),
		"§7: a copy named '%s' was not refused as the live project: exit %d, '%s'" % [live_name, int(r_live[0]), r_live[1]])
	var r_own: Array = _driver(["check", as_own])
	ok(int(r_own[0]) == 0 and String(r_own[1]).begins_with("LANE OK"),
		"§7: a copy named as its own project was refused: exit %d, '%s'" % [int(r_own[0]), r_own[1]])
	var r_repo: Array = _driver(["check", ProjectSettings.globalize_path("res://")])
	ok(int(r_repo[0]) == 1 and String(r_repo[1]).contains("is the repository"),
		"§7: the driver's own tree was not refused as a lane: exit %d, '%s'" % [int(r_repo[0]), r_repo[1]])
	var r_none: Array = _driver(["check", unnamed])
	ok(int(r_none[0]) == 1 and String(r_none[1]).contains("names no project"),
		"§7: a copy that names no project was not refused: exit %d, '%s'" % [int(r_none[0]), r_none[1]])
	# THE LAUNCH DOOR ASKS THE SAME CHECK: `godot` refuses the live-named copy before Godot starts.
	var r_launch: Array = _driver(["godot", as_live, "--version"])
	ok(int(r_launch[0]) == 1 and String(r_launch[1]).contains("the LIVE project"),
		"§7: the driver launched Godot in a copy named as the live project: exit %d, '%s'" % [int(r_launch[0]), r_launch[1]])
	for d in [as_live, as_own, unnamed]:
		DirAccess.remove_absolute(d.path_join("project.godot"))
		DirAccess.remove_absolute(d)
	DirAccess.remove_absolute(base)
	print("    the live name '%s'; refused: as live, the repository, unnamed, the launch; ran: its own name" % live_name)


# ── §9 — THE PLAYER's FILES ─────────────────────────────────────────────────

func _s9_the_players_files() -> void:
	print("\n§9 — the player's files are as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var bytes: PackedByteArray = _player[p][1]
		if had:
			ok(FileAccess.file_exists(p) and FileAccess.get_file_as_bytes(p) == bytes, "§9: %s was rewritten" % p)
		else:
			ok(not FileAccess.file_exists(p), "§9: %s was created" % p)
