# BATCH IQ — THE THREE DOCUMENTS, AND ONE CRASH.
#
#   §0   The rulings recorded, each pinned in the file it binds: a tie that survives its second block, the cuts that move
#        with the deck, the save's guard, and the two instrument rules.
#   §1   `docs/state.md`'s closed blocks stand in the archive and not in the live file, the archive's newest cut on top.
#   §2   `docs/master.html`'s figures that have a door, read on both sides: every card's price in the draft catalogue and in
#        the class sections' statlines against the card's own fields, the bargain deck against `Run.MODIFIERS`, the rewards
#        against `Run.REWARDS` and the ladder against `Run.DIFFICULTIES` — and since IT §2f every figure the catalogue's
#        "What it does" cells state, against the field or the constant that decides it; a figure stated there with no door
#        reds.
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
	# A saved rune's ability payload adding to a property a card does not have: the field does not reach the spawn.
	# RE-POINTED AT IS §2b: IQ's guard dropped the field and kept the rest as built; IS's derived door rebuilds a payload
	# naming a field today's definition does not name, whole, from today's definition — which names no property gone. The
	# fixture is a real ability rune (Warrior's Edge) as built, plus the property a later build lost; it loads as today's.
	_new_run()
	var r := Runes.build("warriors_edge")
	(r["payload"]["add"] as Dictionary)["iq_gone_field"] = 3
	r["equipped"] = true
	(_run.party[0]["runes"] as Array).append(r)
	ok(_roundtrip(), "§4b payload: the save did not load")
	var lp: Dictionary = ((_run.party[0]["runes"] as Array).back() as Dictionary)["payload"]
	var today: Dictionary = (Runes.config("warriors_edge") as Dictionary).get("payload", {})
	ok(not (lp.get("add", {}) as Dictionary).has("iq_gone_field") and (lp.get("add", {}) as Dictionary).size() == (today.get("add", {}) as Dictionary).size()
			and String(lp.get("ability", "")) == String(today.get("ability", "")),
		"§4b payload: the load kept a field a card does not have on '%s', or lost the rest — add %s, today's %s"
		% [String(((_run.party[0]["runes"] as Array).back() as Dictionary).get("id", "")), str(lp.get("add")), str(today.get("add"))])
	# EVERY FILTER RUNS WHERE THE SAVE IS READ, AND ONLY THERE: a key the code chose never meets one.
	var rs := _src("scripts/run_state.gd")
	var lr := _body("scripts/run_state.gd", "load_run")
	for fn in ["_drop_stale_save_keys", "_rebuild_stale_payloads"]:  # the second IQ's `_drop_stale_payload_fields` until IS §2b
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
	# §2f — the catalogue's own figures, every one through its door (IT §2).
	var cat: Array = _s2f_catalogue_figures(doc, cards, wrong)
	for w in wrong:
		print("    " + String(w))
	ok(wrong.is_empty(), "§2: %d of master.html's figures disagree with their doors — %s" % [wrong.size(), "; ".join(PackedStringArray(wrong.slice(0, 3)))])
	print("    CHECKED: the catalogue %d figures over %d rows, the prose %d figures over %d statlines, the deck's %d rows, %d rewards, three rungs"
		% [figs_a, priced, figs_b, lines, listed.size(), paid])
	# IQ's count was 695: the price column, the statlines, the deck both ways and its size, the rewards and the ladder. IT §2
	# adds the catalogue's "What it does" figures and words read through a door.
	var iq_held := figs_a + figs_b + 2 * listed.size() + 1 + paid + 9
	print("    CHECKED: the catalogue's own %d stated figures — %d through a door, %d a worked example's input (named) — and %d words; §2 holds %d figures (IQ's %d + IT's %d)"
		% [int(cat[3]), int(cat[0]), int(cat[2]), int(cat[1]), iq_held + int(cat[0]) + int(cat[1]), iq_held, int(cat[0]) + int(cat[1])])


# ── §2f — THE CATALOGUE's OWN FIGURES (BATCH IT §2) ─────────────────────────
#
# The catalogue is `docs/master.html`'s two card tables — §5.2's class kit and §6b's draft — one row a card. §2a reads
# each row's price cell; this reads its "What it does" cell, every figure in it, against the door that decides it: the
# card's own field (`ab.`), a named constant (`Battle.`, `Unit.`, `Classes.`, `Ability.`), another card's field
# (`cards[...]`), the class's own config (`warrior[...]`), or arithmetic over those where the cell states a product (a
# Perfect's grade multiplier, a bar's worth). Each door is a GDScript `Expression` over the scripts' constant maps,
# evaluated live, so a re-tune moves the figure the door reads and the cell reds until it is moved too. **IT named the
# 157 handler literals this needed first** (`battle.gd`'s IT §2 block); before IT, 173 of the catalogue's 398 figures
# had no door (IT's report, §2b).
# **AND A FIGURE WITH NO DOOR REDS**: every number the cells state is held by a row here — through its door, or as a
# worked example's input the text chooses, NAMED with why — so a cell that states a new figure reds until the figure
# is given its row. Words are held where a constant or a field decides them; a word that only counts the card's own
# structure (*one mark at a time*, *a second enemy*) has no figure to read and is not held.
const CATALOGUE_HEADS := ["<tr><th>Class</th><th>Class kit</th><th>Cost, initiative, cooldown, target</th><th>What it does</th></tr>",
	"<tr><th>Ability</th><th>Cost / init / cd</th><th>What it does</th><th>Axis</th></tr>"]
const CATALOGUE_ENTITIES := {"&mdash;": "—", "&ndash;": "–", "&sect;": "§", "&amp;": "&", "&times;": "×", "&minus;": "−",
	"&nbsp;": " ", "&rarr;": "→", "&lt;": "<", "&gt;": ">", "&hellip;": "…", "&rsquo;": "’", "&#x27;": "'", "&#39;": "'"}
# [card, needle in its cell, the figure as written, its door]
const CATALOGUE_FIGURES := [
	["Crushing Blow", "43% of", "43%", "ab.damage"],
	["Crushing Blow", "20 Break", "20", "ab.pressure"],
	["Crushing Blow", "(−35% armor)", "−35%", "Unit.SUNDER_STEP*100"],
	["Crushing Blow", "3 turns.", "3", "ab.applies_status[\"turns\"]"],
	["Crushing Blow", "10 Rage", "10", "ab.resource_gain"],
	["Crushing Blow", "+5 bonus", "+5", "Battle.CRUSHING_BLOW_PERFECT_BD"],
	["Pommel Strike", "25% of", "25%", "ab.damage"],
	["Pommel Strike", "30 Break", "30", "ab.pressure"],
	["Pommel Strike", "25% crit", "25%", "Battle.POMMEL_STRIKE_CRIT*100"],
	["Pommel Strike", "1 turn,", "1", "ab.applies_status[\"turns\"]"],
	["Pommel Strike", "10 Rage", "10", "ab.resource_gain"],
	["Mocking Blow", "27% of", "27%", "ab.damage"],
	["Mocking Blow", "15 Break", "15", "ab.pressure"],
	["Mocking Blow", "4 turns.", "4", "Battle.MOCKING_BLOW_TURNS"],
	["Mocking Blow", "10 Rage", "10", "ab.resource_gain"],
	["Mocking Blow", "5 turns).", "5", "Battle.MOCKING_BLOW_PERFECT_TURNS"],
	["Magic Burst", "40% of", "40%", "ab.damage"],
	["Magic Burst", "15 Break", "15", "ab.pressure"],
	["Magic Burst", "3 turns:", "3", "Battle.ELEM_WEAK_TURNS"],
	["Magic Burst", "15% lower", "15%", "Battle.ELEM_WEAK_PCT"],
	["Magic Burst", "the 3 turns", "3", "Battle.ELEM_WEAK_TURNS"],
	["Nexus Ward", "20% of", "20%", "Battle.NEXUS_WARD_PCT*100"],
	["Nexus Ward", "3 turns.", "3", "Battle.NEXUS_WARD_TURNS"],
	["Magic Missiles", "12% of", "12%", "ab.damage"],
	["Magic Missiles", "3 BD", "3", "ab.pressure"],
	["Ministration", "20% of", "20%", "Battle.MINISTRATION_PCT*100"],
	["Ministration", "26%).", "26%", "Battle.MINISTRATION_PERFECT_PCT*100"],
	["Unburden", "20% less", "20%", "Battle.UNBURDEN_CUT*100"],
	["Unburden", "3 turns.", "3", "Battle.UNBURDEN_TURNS"],
	["Consecration", "4 turns", "4", "Battle.CONSECRATION_TURNS"],
	["Consecration", "5% of", "5%", "Battle.CONSECRATION_PCT*100"],
	["Powershot", "20% of", "20%", "ab.damage"],
	["Powershot", "20 Break", "20", "ab.pressure"],
	["Powershot", "+2% damage", "+2%", "Battle.POWERSHOT_PCT_PER_POINT"],
	["Snare Trap", "1 turn", "1", "Battle.TRAP_STUN_TURNS"],
	["Snare Trap", "4. A", "4", "Battle.SNARE_TRAP_POISON_TURNS"],
	["Summon Companion", "3-turn", "3", "Battle.SWAP_COOLDOWN"],
	["Blood Offering", "20% of", "20%", "Battle.BLOOD_OFFERING_PCT*100"],
	["Blood Offering", "60 Rage.", "60", "Battle.BLOOD_OFFERING_RAGE"],
	["Blood Offering", "1 —", "1", "Battle.BLOOD_OFFERING_HP_FLOOR"],
	["Gut Rip", "6% of", "6%", "ab.damage"],
	["Gut Rip", "10 points", "10", "Battle.GUT_RIP_STEP"],
	["Gut Rip", "9%).", "9%", "Battle.GUT_RIP_PERFECT_PCT"],
	["Reckless Abandon", "3 turns", "3", "Battle.RECKLESS_TURNS"],
	["Reckless Abandon", "+2% damage", "+2%", "Battle.RECKLESS_PCT_PER_10"],
	["Reckless Abandon", "10 points", "10", "Battle.RECKLESS_STEP"],
	["Reckless Abandon", "3%).", "3%", "Battle.RECKLESS_PERFECT_PER_10"],
	["Reckless Abandon", "10 Rage", "10", "Battle.RECKLESS_STEP"],
	["Berserk", "30% more", "30%", "Battle.BERSERK_RISK_PCT"],
	["Berserk", "3 turns.Two", "3", "Battle.BERSERK_RISK_TURNS"],
	["Berserk", "30% is", "30%", "Battle.BERSERK_RISK_PCT"],
	["Berserk", "3-turn", "3", "Battle.BERSERK_RISK_TURNS"],
	["Blood Debt", "30% of", "30%", "ab.damage"],
	["Blood Debt", "25% of", "25%", "Battle.BLOOD_DEBT_HEAL*100"],
	["Blood Debt", "35%).The", "35%", "Battle.BLOOD_DEBT_PERFECT_HEAL*100"],
	["Unslaked", "4 turns,", "4", "Battle.UNSLAKED_TURNS"],
	["Spite", "6 turns,", "6", "Battle.SPITE_TURNS"],
	["Spite", "1% less", "1%", "Battle.SPITE_PER_5_MISSING"],
	["Spite", "5% of", "5%", "Battle.SPITE_STEP_PCT"],
	["Spite", "40%. It", "40%", "Battle.SPITE_PERFECT_CAP"],
	["Boil Over", "0.8% of", "0.8%", "Classes.BOIL_OVER_PCT_PER_RAGE"],
	["Boil Over", "40% of", "40%", "Classes.BOIL_OVER_MIN_BAR*100"],
	["Precision Strike", "20% of", "20%", "Battle.PRECISION_AGGRO_PCT"],
	["Precision Strike", "(6 BD", "6", "Battle.PRECISION_AGGRO_BD"],
	["Precision Strike", "+25% parry", "+25%", "Battle.PRECISION_PARRY_PCT"],
	["Precision Strike", "15% of", "15%", "Battle.PRECISION_DEF_PCT"],
	["Precision Strike", "15 BD,", "15", "Battle.PRECISION_DEF_BD"],
	["Feint", "35% of", "35%", "Battle.FEINT_STRIKE_PCT"],
	["Feint", "(12 BD),", "12", "Battle.FEINT_BD"],
	["Feint", "45%).From", "45%", "Battle.FEINT_PERFECT_PCT"],
	["Feint", "2 charges", "2", "Battle.FEINT_GUARDS"],
	["Sever", "40% of", "40%", "ab.damage"],
	["Sever", "−35% armor", "−35%", "Unit.SUNDER_STEP*100"],
	["Sever", "3 turns,", "3", "Unit.SUNDER_TURNS"],
	["Battle Poise", "4 turns,", "4", "Battle.BATTLE_POISE_TURNS"],
	["Feigned Guard", "3 turns", "3", "Battle.FEIGNED_GUARD_TURNS"],
	["Discipline", "7 turns,", "7", "Battle.DISCIPLINE_TURNS"],
	["Discipline", "4%, to", "4%", "Battle.DISCIPLINE_PERFECT_STEP"],
	["Discipline", "15%. A", "15%", "Battle.DISCIPLINE_CAP"],
	["Answering Steel", "6 turns,", "6", "Battle.ANSWERING_TURNS"],
	["Answering Steel", "+20%, and", "+20%", "Battle.ANSWERING_PERFECT_PARRY"],
	["Answering Steel", "15 Rage", "15", "Battle.ANSWERING_RAGE"],
	["Formless", "4 turns", "4", "Battle.FORMLESS_TURNS"],
	["Formless", "2 turns", "2", "Battle.FORMLESS_RECOIL_TURNS"],
	["Wheeling Cut", "20% of", "20%", "ab.damage"],
	["Wheeling Cut", "20% less", "20%", "Battle.WHEELING_GUARD_PCT"],
	["Wheeling Cut", "for 3 turns. FROM", "3", "Battle.WHEELING_GRANT_TURNS"],
	["Wheeling Cut", "+20% damage", "+20%", "Battle.WHEELING_EDGE_PCT"],
	["Wheeling Cut", "for 3 turns. Either", "3", "Battle.WHEELING_GRANT_TURNS"],
	["Covering Guard", "4 turns,", "4", "Battle.COVERING_GUARD_TURNS"],
	["Eye of the Storm", "3 turns,", "3", "Battle.EYE_STORM_TURNS"],
	["Eye of the Storm", "8% less", "8%", "Battle.EYE_STORM_CUT_PCT"],
	["Shield Slam", "15% of", "15%", "Battle.SHIELD_SLAM_PCT*100"],
	["Shield Slam", "20%),", "20%", "Battle.SHIELD_SLAM_PERFECT_PCT*100"],
	["Vendetta", "30% less", "30%", "Battle.VENDETTA_PERFECT_CUT*100"],
	["Aegis Wall", "4 turns,", "4", "Battle.AEGIS_WALL_TURNS"],
	["Aegis Wall", "8% of", "8%", "Battle.AEGIS_WALL_PCT*100"],
	["Anvil", "4 turns,", "4", "Battle.ANVIL_TURNS"],
	["Recompense", "6 turns,", "6", "Battle.RECOMPENSE_TURNS"],
	["Turn the Blade", "4 turns,", "4", "Battle.TURN_THE_BLADE_TURNS"],
	["Cinderfall", "20% of", "20%", "ab.damage"],
	["Cinderfall", "tears 2 turns", "2", "Battle.CINDERFALL_TAKE"],
	["Cinderfall", "3 turns);", "3", "Battle.CINDERFALL_PERFECT_TAKE"],
	["Cinderfall", "2 turns.", "2", "Battle.CINDERFALL_LIGHT_TURNS"],
	["Ember Debt", "12 turns", "12", "Battle.EMBER_DEBT_TURNS"],
	["Stoke", "25% of", "25%", "ab.damage"],
	["Stoke", "3 turns.", "3", "Battle.STOKE_LIGHT_TURNS"],
	["Funeral Pyre", "200% of", "200%", "Battle.PYRE_SHARE_PERFECT*100"],
	["Funeral Pyre", "3 turns.", "3", "Battle.PYRE_SHIELD_TURNS"],
	["Firedraw", "6 turns", "6", "Battle.FIREDRAW_TAKE_PERFECT"],
	["Firedraw", "6, whichever", "6", "Battle.FIREDRAW_TAKE_PERFECT"],
	["Pyre Wake", "1 turn", "1", "Battle.PYRE_WAKE_TURNS"],
	["Pyre Wake", "8% of", "8%", "ab.damage"],
	["Pyre Wake", "12%).", "12%", "Battle.PYRE_WAKE_PERFECT_PCT"],
	["Smoulder", "10% of", "10%", "ab.damage"],
	["Smoulder", "for 4 turns", "4", "ab.applies_status[\"turns\"]"],
	["Smoulder", "its 4 turns", "4", "ab.applies_status[\"turns\"]"],
	["Winter's Toll", "8% of", "8%", "ab.damage"],
	["Winter's Toll", "12%).", "12%", "Battle.WINTERS_TOLL_PERFECT_PCT"],
	["Killing Frost", "20% of", "20%", "ab.damage"],
	["Killing Frost", "2 more", "2", "Battle.KILLING_FROST_STACKS"],
	["Killing Frost", "3).", "3", "Battle.KILLING_FROST_STACKS_PERFECT"],
	["Hoarfrost Armor", "25% less", "25%", "Battle.HOARFROST_CUT*100"],
	["Hoarfrost Armor", "2 stacks", "2", "Battle.HOARFROST_STACKS"],
	["Cold Iron", "25% of", "25%", "ab.damage"],
	["Frostbind", "40%. The", "40%", "Battle.FROSTBIND_SHARE*100"],
	["Null Field", "4 turns,", "4", "Battle.NULL_FIELD_TURNS"],
	["Null Field", "5% per", "5%", "Battle.NULL_FIELD_PCT_PER_STACK*100"],
	["Kindled Mind", "15% of", "15%", "ab.damage"],
	["Kindled Mind", "1 (Perfect:", "1", "Battle.RESONANCE_PER_CAST"],
	["Arcane Bolt", "15% of", "15%", "ab.damage"],
	["Arcane Bolt", "20%),", "20%", "Battle.ARCANE_BOLT_PERFECT_PCT*100"],
	["Arcane Echo", "20% of", "20%", "ab.damage"],
	["Arcane Echo", "3 turns", "3", "Battle.ARCANE_ECHO_TURNS"],
	["Arcane Echo", "30% against", "30%", "Battle.ARCANE_ECHO_SHARE*100"],
	["Threshold", "15 immediately,", "15", "Battle.THRESHOLD_STACKS"],
	["Threshold", "2 turns.", "2", "Battle.THRESHOLD_LOCK_TURNS_PERFECT"],
	["Threshold", "15 it", "15", "Battle.THRESHOLD_STACKS"],
	["Unmaking", "10% of", "10%", "ab.damage"],
	["Unmaking", "3 turns", "3", "Battle.UNMAKING_LOCK_TURNS"],
	["Unmaking", "1 Resonance.", "1", "Battle.UNMAKING_MIN_STACKS"],
	["Second Wind", "40% of", "40%", "Battle.SECOND_WIND_CAP_PCT*100"],
	["Second Wind", "55%).", "55%", "Battle.SECOND_WIND_PERFECT_CAP_PCT*100"],
	["Rite of Return", "4 turns,", "4", "Battle.RITE_OF_RETURN_TURNS"],
	["Rite of Return", "50% health", "50%", "Battle.RITE_OF_RETURN_RESTORE_PCT*100"],
	["Rite of Return", "30% of", "30%", "Battle.RITE_OF_RETURN_TOLL_PCT*100"],
	["Recant", "40% of", "40%", "Battle.RECANT_PCT*100"],
	["Shared Grief", "25% of", "25%", "Battle.SHARED_GRIEF_COST_PCT*100"],
	["Shared Grief", "4 Mercy.", "4", "Battle.SHARED_GRIEF_MERCY"],
	["Shared Grief", "below 1.", "1", "Battle.SHARED_GRIEF_HP_FLOOR"],
	["Reprisal", "50% of", "50%", "Battle.REPRISAL_SHARE*100"],
	["Reprisal", "75%).", "75%", "Battle.REPRISAL_PERFECT_SHARE*100"],
	["Divine Presence", "4 turns", "4", "Battle.DIVINE_PRESENCE_TURNS"],
	["Divine Presence", "2 Mercy", "2", "Battle.DIVINE_PRESENCE_MERCY"],
	["Divine Presence", "4 Mercy.", "4", "2 * Battle.DIVINE_PRESENCE_MERCY"],
	["Alms", "4 turns,", "4", "Battle.ALMS_TURNS"],
	["Alms", "12% of", "12%", "Battle.ALMS_WARD_PCT"],
	["Vespers", "4 turns,", "4", "Battle.VESPERS_TURNS"],
	["Vespers", "20% of", "20%", "Battle.VESPERS_PCT*100"],
	["Vow of Suffering", "4 turns,", "4", "Battle.VOW_OF_SUFFERING_TURNS"],
	["Vow of Suffering", "1 Faith.", "1", "Battle.VOW_OF_SUFFERING_FAITH"],
	["Ordination", "4 Faith", "4", "Battle.ORDINATION_FAITH"],
	["Reliquary", "2.5% of", "2.5%", "Battle.RELIQUARY_PCT*100"],
	["Reliquary", "3.5%).", "3.5%", "Battle.RELIQUARY_PERFECT_PCT*100"],
	["Elevation", "2 stacks", "2", "Battle.ELEVATION_STACKS"],
	["Elevation", "15% of", "15%", "Battle.FAITH_RELEASE_HEAL*100"],
	["Elevation", "3% of", "3%", "Battle.FAITH_RELEASE_MANA*100"],
	["Blessing of the Faithful", "6% of", "6%", "Battle.BLESSING_OF_THE_FAITHFUL_PCT*100"],
	["Blessing of the Faithful", "3% of", "3%", "Battle.BLESSING_OF_THE_FAITHFUL_MANA_PCT*100"],
	["Blessing of the Faithful", "8%).", "8%", "Battle.BLESSING_OF_THE_FAITHFUL_PERFECT_PCT*100"],
	["Blessing of the Faithful", "3 held.", "3", "Battle.JUBILEE_MIN_FAITH"],
	["Mantle", "25% of", "25%", "Battle.MANTLE_PCT*100"],
	["Blight the Well", "6 turns,", "6", "Battle.BLIGHT_THE_WELL_TURNS"],
	["Suffering", "20% of", "20%", "ab.damage"],
	["Suffering", "4 turns", "4", "Battle.SUFFERING_TURNS"],
	["Suffering", "2 Ruin", "2", "Battle.SUFFERING_RUIN"],
	["Suffering", "3) —", "3", "Battle.SUFFERING_PERFECT_RUIN"],
	["Transference", "2 more", "2", "Battle.TRANSFERENCE_BONUS"],
	["Anointing", "4 turns,", "4", "Battle.ANOINTING_TURNS"],
	["Anointing", "1 Ruin.", "1", "Battle.ANOINTING_RUIN"],
	["Breaking Darkness", "3 turns", "3", "Battle.BREAKING_DARKNESS_TURNS"],
	["Breaking Darkness", "25% harder.", "25%", "Battle.BREAKING_DARKNESS_BD_PCT"],
	["Requiem", "8% of", "8%", "Battle.REQUIEM_PER_STACK*100"],
	["Requiem", "10%),", "10%", "Battle.REQUIEM_PERFECT_PER_STACK*100"],
	["Requiem", "2% of", "2%", "Battle.REQUIEM_HEAL_PCT*100"],
	["Penance", "4 turns", "4", "Battle.PENANCE_TURNS"],
	["Penance", "50% of", "50%", "Battle.PENANCE_MIRROR*100"],
	["Twin Hunt", "40% of", "40%", "ab.damage"],
	["Twin Hunt", "55%).", "55%", "Battle.TWIN_HUNT_COMPANION_PERFECT_PCT*100"],
	["Savage Sweep", "3 Loyalty", "3", "Battle.SAVAGE_SWEEP_LOYALTY"],
	["Savage Sweep", "5).", "5", "Battle.SAVAGE_SWEEP_PERFECT_LOYALTY"],
	["Ghostpack", "4 turns,", "4", "Battle.GHOSTPACK_TURNS"],
	["Ghostpack", "40% —", "40%", "Battle.GHOSTPACK_SHARE*100"],
	["Last Howl", "+3% strike", "+3%", "Battle.LAST_HOWL_PCT_PER_STACK"],
	["Succession", "6 turns", "6", "Battle.SUCCESSION_TURNS"],
	["Unleash", "20% of", "20%", "Battle.UNLEASH_PCT_PER_STACK*100"],
	["Unleash", "25%),", "25%", "Battle.UNLEASH_PERFECT_PCT_PER_STACK*100"],
	["Bring It Down", "4 turns", "4", "Battle.BRING_IT_DOWN_TURNS"],
	["Bring It Down", "2% more", "2%", "Battle.BRING_IT_DOWN_PER"],
	["Bring It Down", "+20%. The", "+20%", "Battle.BRING_IT_DOWN_CAP"],
	["Called Volley", "20% of", "20%", "ab.damage"],
	["Crossfire", "30% of", "30%", "ab.damage"],
	["Crossfire", "3 turns", "3", "Battle.CROSSFIRE_TURNS"],
	["Crossfire", "4) every", "4", "Battle.CROSSFIRE_PERFECT_TURNS"],
	["Crossfire", "2 other", "2", "Battle.CROSSFIRE_SPLASH_TARGETS"],
	["Crossfire", "40% of", "40%", "Battle.CROSSFIRE_SHARE*100"],
	["Calibrating Shot", "20% of", "20%", "ab.damage"],
	["Calibrating Shot", "10% of", "10%", "Battle.CALIBRATING_SHOT_PCT*100"],
	["Calibrating Shot", "15%),", "15%", "Battle.CALIBRATING_SHOT_PERFECT_PCT*100"],
	["Trophy Shot", "35% of", "35%", "ab.damage"],
	["Fault Line", "6 turns,", "6", "Battle.FAULT_LINE_TURNS"],
	["Fault Line", "20 Break", "20", "Battle.FAULT_LINE_BD"],
	["Fault Line", "fixed 100.", "100", "Unit.FOCUS_CONVERT"],
	["Drumfire", "14% of", "14%", "ab.damage"],
	["Dug In", "4 turns", "4", "Battle.DUG_IN_TURNS"],
	["Dug In", "25%. Read", "25%", "Battle.DUG_IN_CAP"],
	["Heads Down", "20% of", "20%", "ab.damage"],
	["Heads Down", "3 turns", "3", "Battle.HEADS_DOWN_TURNS"],
	["Heads Down", "4) that", "4", "Battle.HEADS_DOWN_PERFECT_TURNS"],
	["Choking Smoke", "3 turns", "3", "Battle.CHOKING_SMOKE_TURNS"],
	["Loaded Shot", "20% of", "20%", "ab.cost"],
	["Loaded Shot", "2 turns", "2", "Battle.LOADED_SHOT_PERFECT_POISON_TURNS"],
	["Hunt", "15% of", "15%", "ab.damage"],
	["Preparation", "15 Mana.", "15", "Battle.PREPARATION_MANA"],
	["Stalking Horse", "4 turns", "4", "Battle.STALKING_HORSE_TURNS"],
	["Downwind", "4 turns", "4", "Battle.DOWNWIND_TURNS"],
	["Cull", "10% of", "10%", "Battle.CULL_PCT*100"],
	["Cull", "12%).", "12%", "Battle.CULL_PERFECT_PCT*100"],
	["Thick Hide", "4 turns", "4", "Battle.THICK_HIDE_TURNS"],
	["Thick Hide", "6% less", "6%", "Battle.THICK_HIDE_PER"],
	["Thick Hide", "to 30%.", "30%", "Battle.THICK_HIDE_CAP"],
	["Salve", "3 turns", "3", "Battle.SALVE_TURNS"],
	["Salve", "4) he", "4", "Battle.SALVE_PERFECT_TURNS"],
	["Salve", "2% of", "2%", "Battle.SALVE_PER"],
	["Salve", "10%. Counted", "10%", "Battle.SALVE_CAP"],
	["Mana Well", "4 turns", "4", "Battle.MANA_WELL_TURNS"],
	["Chastise", "25% of", "25%", "ab.damage"],
	["Chastise", "20 Break", "20", "ab.pressure"],
	["Exhortation", "35% more", "35%", "Battle.EXHORTATION_PCT"],
	["Undying Vigil", "4 turns,", "4", "Battle.UNDYING_VIGIL_TURNS"],
	["Field Dressing", "18% of", "18%", "Battle.FIELD_DRESSING_PCT*100"],
	["Field Dressing", "24%) and", "24%", "Battle.FIELD_DRESSING_PERFECT_PCT*100"],
	["Camouflage", "3 turns", "3", "Battle.CAMOUFLAGE_TURNS"],
	["Camouflage", "70% less", "70%", "Battle.CAMOUFLAGE_PCT"],
	["Aimed Volley", "12% of", "12%", "ab.damage"],
	["Aimed Volley", "8 Break", "8", "ab.pressure"],
	["Bola", "4 turns.", "4", "Battle.BOLA_TURNS"],
	["Hunter's Mark", "6 turns", "6", "Battle.HUNTERS_MARK_TURNS"],
	["Hunter's Mark", "15% more", "15%", "Battle.PARTY_MARK_PCT"],
	["Battle Trance", "4 turns,", "4", "Battle.BATTLE_TRANCE_TURNS"],
	["Battle Trance", "3% of", "3%", "Battle.BATTLE_TRANCE_FLOOR*100"],
	["Rally", "15% of", "15%", "Battle.RALLY_RESOURCE_PCT*100"],
	["Charge", "25% of", "25%", "ab.damage"],
	["Charge", "20 Break", "20", "ab.pressure"],
	["Charge", "2 turns", "2", "ab.applies_status[\"turns\"]"],
	["Charge", "30 Rage,", "30", "ab.resource_gain"],
	["Cleave", "15% of", "15%", "ab.damage"],
	["Cleave", "15 Break", "15", "ab.damage"],
	["Warcry", "20% more", "20%", "Battle.WARCRY_PCT"],
	["Warcry", "4 turns.", "4", "Battle.WARCRY_TURNS"],
	["Ironclad", "4 turns", "4", "Battle.IRONCLAD_TURNS"],
	["Ironclad", "15% less", "15%", "Battle.IRONCLAD_CUT_PCT"],
	["Magic Burst", "46% of", "46%", "ab.damage * Ability.GRADE_DMG_MULT[\"perfect\"]"],
	["Summon Companion", "10 Mana,", "10", "Battle.SUMMON_SWAP_COST"],
	["Summon Companion", "1.0 initiative,", "1.0", "Battle.SUMMON_SWAP_DELAY"],
	["Reckless Abandon", "100-Rage", "100", "warrior[\"max_resource\"]"],
	["Reckless Abandon", "+20%; a", "+20%", "warrior[\"max_resource\"] / Battle.RECKLESS_STEP * Battle.RECKLESS_PCT_PER_10"],
	["Berserk", "4 STRIKES", "4", "Battle.BERSERK_STRIKES"],
	["Boil Over", "100 is", "100", "warrior[\"max_resource\"]"],
	["Boil Over", "80%. It", "80%", "Classes.BOIL_OVER_PCT_PER_RAGE * warrior[\"max_resource\"]"],
	["Precision Strike", "chance for 4 turns —", "4", "Battle.PRECISION_GRANT_TURNS"],
	["Precision Strike", "armor for 4 turns —", "4", "Battle.PRECISION_GRANT_TURNS"],
	["Precision Strike", "5 turns.", "5", "Battle.PRECISION_PERFECT_GRANT_TURNS"],
	["Feint", "3),", "3", "Battle.FEINT_GUARDS + 1"],
	["Battle Poise", "1-turn", "1", "cards[\"Guard Change\"].cooldown"],
	["Formless", "+30% damage", "+30%", "(Battle.FORMLESS_DEALT - 1.0) * 100"],
	["Formless", "15% less", "15%", "(1.0 - Battle.FORMLESS_TAKEN) * 100"],
	["Formless", "(+10% damage", "+10%", "(Battle.FORMLESS_RECOIL_TAKEN - 1.0) * 100"],
	["Formless", "−10% dealt).", "−10%", "(1.0 - Battle.FORMLESS_RECOIL_DEALT) * 100"],
	["Wheeling Cut", "12 Break,", "12", "ab.pressure"],
	["Shield Slam", "40 Break", "40", "ab.pressure"],
	["Slow Burn", "4 turns,", "4", "Battle.SLOW_BURN_TURNS"],
	["Firedraw", "2, not", "2", "mini(2, Battle.FIREDRAW_TAKE)"],
	["Emberkeep", "4 turns,", "4", "Battle.EMBERKEEP_TURNS"],
	["Smoulder", "11.5% of", "11.5%", "ab.damage * Ability.GRADE_DMG_MULT[\"perfect\"]"],
	["Hoarfrost Armor", "4 turns", "4", "Battle.HOARFROST_TURNS"],
	["Cold Iron", "28.75%).", "28.75%", "ab.damage * Ability.GRADE_DMG_MULT[\"perfect\"]"],
	["Frostbind", "4 turns", "4", "Battle.FROSTBIND_TURNS"],
	["Kindled Mind", "3 Resonance", "3", "Battle.RESONANCE_PER_CAST + Battle.KINDLED_MIND_RESONANCE"],
	["Kindled Mind", "4).", "4", "Battle.RESONANCE_PER_CAST + Battle.KINDLED_MIND_PERFECT_RESONANCE"],
	["Arcane Bolt", "90% of", "90%", "6 * ab.damage"],
	["Arcane Bolt", "240% and", "240%", "16 * ab.damage"],
	["Arcane Bolt", "8. Dark", "8", "16 * Battle.ARCANE_BOLT_KEEP"],
	["Arcane Echo", "4) every", "4", "Battle.ARCANE_ECHO_PERFECT_TURNS"],
	["Resonant Field", "4 turns,", "4", "Battle.RESONANT_FIELD_TURNS"],
	["Unmaking", "4).", "4", "Battle.UNMAKING_LOCK_PERFECT_TURNS"],
	["Fortified Spirit", "30% of", "30%", "Battle.FORTIFIED_SPIRIT_STEPS * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100"],
	["Fortified Spirit", "40%).", "40%", "Battle.FORTIFIED_SPIRIT_PERFECT_STEPS * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100"],
	["Fortified Spirit", "30 →", "30", "Battle.FORTIFIED_SPIRIT_STEPS * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100"],
	["Fortified Spirit", "20 →", "20", "(Battle.FORTIFIED_SPIRIT_STEPS - 1) * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100"],
	["Fortified Spirit", "10 →", "10", "(Battle.FORTIFIED_SPIRIT_STEPS - 2) * Battle.FORTIFIED_SPIRIT_STEP_PCT * 100"],
	["Breaking Darkness", "20 Break", "20", "ab.pressure"],
	["Breaking Darkness", "4) every", "4", "Battle.BREAKING_DARKNESS_PERFECT_TURNS"],
	["Called Volley", "23%),", "23%", "ab.damage * Ability.GRADE_DMG_MULT[\"perfect\"]"],
	["Trophy Shot", "40.25%).", "40.25%", "ab.damage * Ability.GRADE_DMG_MULT[\"perfect\"]"],
	["Choking Smoke", "+50% miss.", "+50%", "Battle.BLIND_MISS_PCT * 100"],
	["Hunt", "23%) —", "23%", "Battle.HUNT_PERFECT_PCT * Ability.GRADE_DMG_MULT[\"perfect\"] * 100"],
	["Hunt", "60% at", "60%", "ab.damage * 4"],
	["Hunt", "90% at", "90%", "ab.damage * 6"],
	["Chastise", "25 BD).", "25", "ab.pressure * Ability.GRADE_BD_MULT[\"perfect\"]"],
	["Aimed Volley", "24 across", "24", "ab.pressure * ab.multi_hits"],
	["Arcane Arrows", "6 charges:", "6", "Battle.ARCANE_ARROW_CHARGES"],
	["Charge", "3).", "3", "ab.applies_status[\"turns\"] + 1"],
	["Charge", "net-generates 10.", "10", "ab.resource_gain - ab.cost"],
	["Cleave", "17.25%) and", "17.25%", "ab.damage * Ability.GRADE_DMG_MULT[\"perfect\"]"],
	["Ironclad", "99 and", "99", "warrior[\"stability\"] - 1"],
]
# [card, needle, the figure, why it is no door's] — a worked example's input, which the text picks
const CATALOGUE_EXAMPLES := [
	["Recompense", "+32% pays", "+32%", "a worked example's input: any plating figure a reset could lose"],
	["Recompense", "32 Rage.", "32", "a worked example's output: 1 Rage a point lost, the rule's unit (no rate to name)"],
	["Firedraw", "2 gives", "2", "a worked example's input: any enemy's Burn below the take"],
	["Arcane Bolt", "6 stacks", "6", "a worked example's input: a stack count the text picks"],
	["Arcane Bolt", "16 it", "16", "a worked example's input: a stack count the text picks"],
]
# [card, needle, the word, its door]
const CATALOGUE_WORDS := [
	["Mocking Blow", "one other", "one", "Battle.MOCKING_BLOW_EXTRA_TAUNTS"],
	["Magic Missiles", "Three bolts", "three", "ab.multi_hits"],
	["Magic Missiles", "fourth bolt).", "fourth", "ab.multi_hits + Battle.PERFECT_EXTRA_HITS"],
	["Berserk", "three-hit ability", "three", "cards[\"Hack and Slash\"].multi_hits"],
	["Unslaked", "FULL bonus", "full", "Unit.UNSLAKED_KEEP"],
	["Unslaked", "than half of", "half", "Unit.FRENZY_FLOOR_KEEP"],
	["Precision Strike", "twice for", "twice", "Battle.PRECISION_AGGRO_HITS"],
	["Precision Strike", "once for", "once", "Battle.PRECISION_DEF_HITS"],
	["Battle Poise", "a turn", "a turn", "Battle.BATTLE_POISE_TICK"],
	["Answering Steel", "a turn", "a turn", "Battle.ANSWERING_TICK"],
	["Turn the Blade", "half the", "half", "Battle.TURN_THE_BLADE_SHARE"],
	["Cinderfall", "again to", "again", "Battle.CINDERFALL_SKIM_MULT"],
	["Stoke", "DOUBLED (Perfect:", "doubled", "Battle.STOKE_MULT"],
	["Stoke", "tripled). An", "tripled", "Battle.STOKE_MULT_PERFECT"],
	["Emberkeep", "DOUBLE duration.", "double", "Battle.EMBERKEEP_MULT"],
	["Rimebinding", "plus one.", "one", "Battle.RIMEBINDING_BONUS_STACKS"],
	["Killing Frost", "four stacks", "four", "Unit.CHILLED_FREEZE_STACKS"],
	["Deep Winter", "HALF the", "half", "1.0 / Battle.DEEP_WINTER_DIVISOR"],
	["Cold Iron", "DOUBLE and", "double", "Battle.COLD_IRON_FROZEN_MULT"],
	["Arcane Bolt", "halved. At", "halved", "Battle.ARCANE_BOLT_KEEP"],
	["Arcane Bolt", "zero stacks.", "zero", "Battle.ARCANE_BOLT_MIN_STACKS - 1"],
	["Inner Arcane", "doubled while", "doubled", "Battle.INNER_ARCANE_LOW_MULT"],
	["Inner Arcane", "half health,", "half", "1.0 / Battle.INNER_ARCANE_LOW_AT"],
	["Inner Arcane", "plus one.", "one", "Battle.INNER_ARCANE_BONUS"],
	["Resonant Field", "HALF his", "half", "Battle.RESONANT_FIELD_SHARE"],
	["Second Wind", "two turns", "two", "Unit.SECOND_WIND_WINDOW_TURNS"],
	["Reprisal", "two turns", "two", "Unit.REPRISAL_WINDOW_TURNS"],
	["Divine Presence", "SECOND turn", "second", "Battle.DIVINE_PRESENCE_EVERY"],
	["Vespers", "half health", "half", "Unit.MERCY_WINDOW_AT"],
	["Vow of Suffering", "half the", "half", "1.0 / Unit.VOW_OF_SUFFERING_SHARE"],
	["Aegis Reversal", "half again", "half again", "Battle.AEGIS_REVERSAL_MULT"],
	["Fortified Spirit", "a tenth", "a tenth", "Battle.FORTIFIED_SPIRIT_STEP_PCT"],
	["Bloodbond", "a QUARTER", "a quarter", "Battle.BLOODBOND_PCT / 100.0"],
	["Savage Sweep", "three lowest-health", "three", "Battle.SAVAGE_SWEEP_TARGETS"],
	["Ghostpack", "all three", "three", "Classes.COMPANION_KINDS.size()"],
	["Ghostpack", "three ghosts", "three", "Classes.COMPANION_KINDS.size()"],
	["Succession", "half the", "half", "Battle.SUCCESSION_SHARE / 100.0"],
	["Bear the Brunt", "all of it", "all of it", "Battle.BRUNT_SHARE / 100.0"],
	["Quarry's Mark", "doubled. One", "doubled", "Battle.QUARRYS_MARK_FOCUS_MULT"],
	["Drumfire", "Three arrows", "three", "ab.multi_hits"],
	["Dug In", "a QUARTER", "a quarter", "1.0 / Battle.DUG_IN_DIVISOR"],
	["Snare Line", "two turns", "two", "Battle.SNARE_LINE_TURNS"],
	["Preparation", "NEXT turn", "next", "Battle.PREPARATION_DELAY - 1"],
	["Mirror Image", "four single-target", "four", "Battle.MIRROR_IMAGE_IMAGES"],
	["Mana Well", "doubled —", "doubled", "Battle.MANA_WELL_REGEN_MULT"],
	["Dispel", "three harmful", "three", "Battle.DISPEL_COUNT"],
	["Dispel", "three beneficial", "three", "Battle.DISPEL_COUNT"],
	["Blink", "two turns", "two", "Battle.BLINK_TURNS"],
	["Undying Vigil", "half as", "half", "Battle.VIGIL_SHARE"],
	["Aimed Volley", "Three shots", "three", "ab.multi_hits"],
	["Arcane Arrows", "six hits", "six", "Battle.ARCANE_ARROW_CHARGES"],
	["Arcane Arrows", "half that", "half", "Battle.ARCANE_ARROW_SPLASH"],
	["Battle Trance", "half of", "half", "Battle.BATTLE_TRANCE_SHARE"],
	["Downwind", "the turn it costs", "the turn", "Battle.ORDINARY_FREEZE_TURNS"],
]
const CATALOGUE_WORD_VALUE := {"zero": 0, "one": 1, "once": 1, "a turn": 1, "the turn": 1, "next": 1, "full": 1, "all of it": 1, "two": 2, "twice": 2, "second": 2, "double": 2, "doubled": 2, "again": 2, "three": 3, "tripled": 3, "four": 4, "fourth": 4, "six": 6, "half": 0.5, "halved": 0.5, "a quarter": 0.25, "a tenth": 0.1, "half again": 1.5}


# A catalogue cell flat: tags out, the entities the tables use decoded, spaces collapsed.
func _catalogue_flat(s: String) -> String:
	s = RegEx.create_from_string("<[^>]+>").sub(s.replace("\n", " "), "", true)
	for k in CATALOGUE_ENTITIES:
		s = s.replace(k, CATALOGUE_ENTITIES[k])
	return RegEx.create_from_string(" {2,}").sub(s, " ", true).strip_edges()


func _catalogue_cells(doc: String) -> Dictionary:
	var out := {}
	for h in CATALOGUE_HEADS:
		var t0 := doc.find(h)
		var t1 := doc.find("</table>", t0)
		ok(t0 >= 0 and doc.count(h) == 1 and t1 > t0, "§2f: the catalogue table headed %s is not in the document once" % h.substr(0, 40))
		if t0 < 0 or t1 < 0:
			continue
		for line in doc.substr(t0 + h.length(), t1 - t0 - h.length()).split("<tr>").slice(1):
			var a := line.find("<td><b>")
			var b := line.find("</b></td><td>", a)
			if a < 0 or b < 0:
				continue
			var p0 := b + "</b></td><td>".length()
			var p1 := line.find("</td><td>", p0)
			var d1 := line.find("</td>", p1 + 9)
			out[line.substr(a + 7, b - a - 7)] = _catalogue_flat(line.substr(p1 + 9, d1 - p1 - 9))
	return out


# A door: an `Expression` over the card, the cards, the Warrior's config and the four scripts' constant maps.
var _warrior_cfg := {}


func _catalogue_door(expr: String, ab: Variant, cards: Dictionary, maps: Array) -> Variant:
	if _warrior_cfg.is_empty():
		_warrior_cfg = Classes.hero_config("warrior")
	return Gate.eval_door(expr, ["ab", "cards", "warrior", "Battle", "Unit", "Classes", "Ability"], [ab, cards, _warrior_cfg] + maps)


func _s2f_catalogue_figures(doc: String, cards: Dictionary, wrong: Array) -> Array:
	var cells := _catalogue_cells(doc)
	ok(cells.size() >= 135, "§2f: the catalogue's tables read %d cards — the parse lost rows" % cells.size())
	var maps: Array = []
	for p in ["res://scripts/battle.gd", "res://scripts/unit.gd", "res://scripts/classes.gd", "res://scripts/ability.gd"]:
		maps.append((load(p) as Script).get_script_constant_map())
	var tok := RegEx.create_from_string("(?<![A-Za-z0-9_.§])[x×+−-]?\\d+(?:\\.\\d+)?%?")
	var digits := RegEx.create_from_string("\\d+(?:\\.\\d+)?")
	var held := {}
	var read := 0
	for tab in [CATALOGUE_FIGURES, CATALOGUE_EXAMPLES]:
		for r in tab:
			var card := String(r[0])
			var cell := String(cells.get(card, ""))
			var nd := String(r[1])
			if cell.count(nd) != 1:
				wrong.append("§2f: %s's cell holds '%s' %d times — the row has no subject" % [card, nd, cell.count(nd)])
				continue
			var at := -1
			for m in tok.search_all(nd):
				if m.get_string() == String(r[2]):
					at = cell.find(nd) + m.get_start()
					break
			if at < 0:
				wrong.append("§2f: %s's needle '%s' does not state %s" % [card, nd, r[2]])
				continue
			held[card + "@" + str(at)] = true
			if tab == CATALOGUE_EXAMPLES:
				continue
			read += 1
			var v = _catalogue_door(String(r[3]), cards.get(card), cards, maps)
			var dm := digits.search(String(r[2]))
			var dec := dm.get_string().split(".")[1].length() if dm.get_string().contains(".") else 0
			var scale := pow(10.0, dec)
			if v == null:
				wrong.append("§2f: %s's door `%s` reads nothing" % [card, r[3]])
			elif roundf(absf(float(v)) * scale + 0.000001) != roundf(float(dm.get_string()) * scale):
				wrong.append("§2f: %s's cell says %s ('%s'), its door `%s` reads %s" % [card, r[2], nd, r[3], str(v)])
	var unheld: Array = []
	var stated := 0
	for card in cells:
		for m in tok.search_all(String(cells[card])):
			stated += 1
			if not held.has(card + "@" + str(m.get_start())):
				unheld.append("%s '%s'" % [card, m.get_string()])
	for u in unheld:
		wrong.append("§2f: the catalogue states a figure with no door: %s" % u)
	var words := 0
	for r in CATALOGUE_WORDS:
		var card := String(r[0])
		var cell := String(cells.get(card, ""))
		if cell.count(String(r[1])) != 1 or not String(r[1]).to_lower().contains(String(r[2])):
			wrong.append("§2f: %s's cell does not hold '%s' once, naming '%s'" % [card, r[1], r[2]])
			continue
		words += 1
		var v = _catalogue_door(String(r[3]), cards.get(card), cards, maps)
		if v == null or absf(float(v) - float(CATALOGUE_WORD_VALUE[String(r[2])])) > 0.000001:
			wrong.append("§2f: %s's '%s' says %s, its door `%s` reads %s" % [card, r[1], CATALOGUE_WORD_VALUE[String(r[2])], r[3], str(v)])
	ok(stated == CATALOGUE_FIGURES.size() + CATALOGUE_EXAMPLES.size() and unheld.is_empty(),
		"§2f: the catalogue states %d figures and %d are held — %d have no door" % [stated, held.size(), unheld.size()])
	ok(read >= 316 and words >= 54, "§2f: only %d figures and %d words read through a door — the table lost rows" % [read, words])
	return [read, words, CATALOGUE_EXAMPLES.size(), stated]


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
