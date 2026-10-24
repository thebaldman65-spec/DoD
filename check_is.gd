# BATCH IS — THE LOAD DOOR's FIVE ANSWERS, THE FLOOR CENSUS's REMAINDER, THE THREE WORDS, THE INDEX PILOT AND THE HISTORY STRIP.
#
#   §0   The rulings recorded, each pinned in the file it binds.
#   §2   THE LOAD DOOR's FIVE ANSWERS, AS ONE POPULATION (the designer's). Every kind of thing a save carries is sorted —
#        the save's own keys and every key a member carries, each with the door or the guard that answers it — so a sixth
#        kind reds until it is sorted; the five answers are the door's and each is reached. DRIVEN through the real save
#        and the real load: a save holding a removed card loads with the card gone, its slot freed and the drop said on the
#        map's arrival; a save holding Deepening Hex's stale payload loads with the rune paying today's figure in a real
#        fight; a stale field on any rune is found by today's definition, never a list; a rune the game defines nowhere is
#        dropped; a rename still translates and a name in neither map is still kept; a clean save loads untouched; and no
#        die is spent in any of it.
#   §3a  A SPLIT DISTRIBUTES WHAT IT IS GIVEN AND NEVER MULTIPLIES IT: the shares sum to the amount for every amount (0 and
#        1 among them) and every count of bound bodies; every split in the game is the one function; and each of the
#        three Unity sites DRIVEN — a 1-damage blow, a recoil and a bleedout — bills the bound party exactly what was split.
#        IR's parried blow is kept as a named regression. No die is spent.
#   §3b  THE FLOOR CENSUS's THREE UNCERTAIN ROWS, DRIVEN TO VERDICTS: Shatter's and Winter's Toll's floor (GUARDED by turn
#        order — and the one same-turn route, the Cryomancer's turn-start upkeep, has no writer; the day it gets one this
#        reds); Cull's and Harvest's yield against the count they pay, over bodies carrying sticky and non-sticky
#        afflictions and a conjunction; Returned Burden's re-lay of a 0-turn effect, driven, and every source of a harmful
#        effect on a hero laying a positive duration.
#   §4   THE THREE WORDS (Mantle's Faith clause, the glossary's Faith, Split Shield) to the word the code reaches, and THE
#        PICK POPULATION WIDENED FROM CARDS TO PICKS: every pick that offers a body on the hero side, its words against the
#        pool it offers with a companion standing, and every function that builds a hero-side pool sorted — so a new pick
#        reds until it is. The bot's pools are not widened (the ladder's constant bias).
#   §5   THE INDEX PILOT, ON `docs/state.md` ALONE: reversible by construction, every block a row and every row its
#        triggers, the core every block seven of the nine batches needed, and the report's three lists.
#   §6   `master.html`'s HISTORY CLAUSES ARE GONE: no batch named outside the stamp, no *was / now* or *since* note — and the
#        reasoning they carried stands in `design-notes.md`.
#   §9   The player's files are as this gate found them.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_is.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SCRATCH_PROFILE := "user://is_profile.json"
const SCRATCH_RELICS := "user://is_relics.json"
const SEATS := ["warrior", "mage", "cleric", "hunter"]

# §2 — THE FIVE, AND THE TWO ROWS THE DERIVATION FOUND (every `display_name` gone from `classes.gd` since BM's floor, less
# the five renames; IS's report §2a reads each at the commit that removed it).
const FIVE := ["drop", "keep", "rebuild", "take", "translate"]
const REMOVALS := {"Flash Freeze": "DR §2", "Observance": "CG §1"}
const NEVER_A_CARD := "IS Never A Card"
const GONE_RUNE := "is_never_a_rune"

# §2 — EVERY KEY A RUN SAVE CARRIES, SORTED. A key is answered by the door (CARDS, RUNES) or by the guard named, or names
# nothing a later build can lose. A key the save writes that is not here is a sixth kind of thing — it reds until sorted.
const SAVE_KEYS := {
	"version": "the floor and the ceiling (BK, HL §5)",
	"party": "the members — every key of one sorted in MEMBER_KEYS",
	"items": "IQ §4: an item the table does not hold is dropped",
	"gold": "a number", "zone_bosses_cleared": "a number", "zone_idx": "a number", "slot_idx": "a number",
	"node_idx": "a number", "combat_wins": "a number", "debug_used": "a flag", "pending_shop": "a flag",
	"specs_chosen": "a flag",
	"rune_bag": "RUNES", "crest": "RUNES", "pending_rune_drops": "RUNES",
	"encounter": "IQ §4: an offer option the deck does not hold is dropped",
	"pending_modifier": "read at its door: `battle._active_modifier` asks the deck",
	"pending_reward": "a reward KIND (gold, potion, rune, shop) — names no card and no rune",
	"pending_event": "IQ §4: an event the table does not hold is cleared",
	"pending_item_offers": "IQ §4: an item the table does not hold is dropped",
	"tally": "the run's ledger — a name in it is history, read by the summary alone",
	"difficulty": "`difficulty_id`: an id the ladder does not hold reads the first rung",
	"zone_name": "a label the zone draw sets",
	"zone_draw": "IQ §4: a zone the table does not hold takes its slot's first",
	"seen_events": "a history list — an id in it names nothing anything reads",
	"active_relics": "read at its door: `Relics.POOL.get` adds nothing for an id it lacks",
	"map": "the board — the floor (BK)",
}
const MEMBER_KEYS := {
	"key": "IQ §4: a class this build lacks refuses the save",
	"spec": "IQ §4: a lineage this build lacks is read again off the engines",
	"talents": "FX: `_migrate_trees` swaps in the live tree", "tree": "FX: `_migrate_trees` swaps in the live tree",
	"hp": "a number", "max_hp": "a number", "mana": "a number", "max_mana": "a number", "awakened": "a flag",
	"bm_picks_owed": "a number", "draft_picks_owed": "a number", "rune_picks_owed": "a number", "up_picks_owed": "a number",
	"pick_serials": "bookkeeping keyed by pick kind", "pick_sources": "bookkeeping keyed by serial",
	"fk_mercy_carry": "a number", "fk_resonance_carry": "a number", "event_attack_pct": "a number",
	"companions_standing": "read at its door: a kind `COMPANION_STATS` lacks is not returned (GH)",
	"bm_abilities": "CARDS", "bm_equipped": "CARDS", "draft_refused": "CARDS", "draft_candidates": "CARDS",
	"bm_candidates": "CARDS", "upgrades": "CARDS", "up_candidates": "CARDS",
	"runes": "RUNES", "engines": "RUNES", "rune_candidates": "RUNES", "engine_offer": "RUNES",
}

# §4 — THE PICKS THAT ARE NOT A CARD's, each with the words that name it and the pool it reads (IR's ally census, Table B,
# and the Split Shield the census found beside the family), and every function in `battle.gd` that builds a pool on the hero
# side, sorted. A new one reds until sorted here.
const NONCARD_PICKS := {
	"Split Shield": ["HERO", "for the hero he sets it in front of", "_split_shield_allies"],
	"Dispel": ["ALLY", "an ALLY", "_hero_side"],
	"Cleanse Debuffs Each Turn": ["ALLY", "random allies", "_hero_side"],
}
const HERO_SIDE_FUNCS := {
	"_ally_pick_pool": "PICK — the player's ally picker, the recast door and two buttons (IR §1b's cards)",
	"_split_shield_allies": "PICK — Split Shield's hero (§4)",
	"_player_turn": "PICK — Dispel's ally half: the hero side and the living enemies (§4)",
	"_run_battle": "PICK — the cleanse talent's random allies (§4)",
	"_resolve": "WALK — an enemy's area blow and its random shards; the dormant Rally",
	"_resolve_special": "WALK — Rallying Shout, Sanctuary, Hold the Line",
	"_rule_engines_on_damage": "WALK — Judgment heals every ally",
	"_defensive_brace": "WALK — an area blow's defensive check",
	"_declare_intent": "ENEMY — a silenced move's fallback target",
	"_revalidate_intent": "ENEMY — the declared target died",
	"_enemy_turn": "ENEMY — a wind-up's stored blow",
	"_choose_enemy_action": "ENEMY — an enemy's target",
	"_psychotic_support": "ENEMY — a maddened support's pick",
}

# §5 — THE PILOT's MARKERS, AND THE NINE BATCHES' NEEDS (IJ–IR) BY BLOCK: how many of the nine needed each block, off IQ's
# re-measure (IJ–IP) and IS's own reading of IQ and IR, one method (HV §3b's). The core is every block seven or more needed.
const INDEX_BEGIN := "<!-- INDEX:BEGIN (IS §5) -->"
const INDEX_END := "<!-- INDEX:END -->"
const NINE_COUNTS := {
	"## WHERE THE PROJECT IS": 9, "## THE OPEN QUEUE": 9, "### IS's RULINGS OWED": 9, "### THE CLERIC's MANA RATE": 9,
	"### SANCTITY's STEP": 9, "### BOIL OVER'S RATE": 9, "### THE CREST POOL": 9, "### FOUND AT IA AND NOT FIXED": 9,
	"### RULED AND NOT BUILT": 9, "### FOUND AT HX AND NOT FIXED": 9, "### THE PLAYTEST'S OTHER FINDINGS": 9,
	"### THE FOUR OTHER CONJUNCTIONS": 9, "### THE SKIRMISHER AND THE TRACKER": 9, "### THE SHAPE RECON ON `CLAUDE.md`": 8,
	"### TO WATCH IN PLAY": 9, "### FOUND AT HP AND NOT FIXED": 6,
}

# §6 — A BATCH NAMED AS ONE, AND WHAT THE GAME WAS.
var BATCH_NAME := RegEx.create_from_string("(Batch\\s+([A-I][A-Z])\\b|\\b([A-I][A-Z])\\s*(?:&sect;|§)|\\b(?:since|until|at|from|before|after|by|of|in)\\s+([A-I][A-Z])(?:\\b(?![\\w-])))")
var WAS_NOW := RegEx.create_from_string("(?i)\\bwas\\s+[^.;<]{0,25}?\\bnow\\b")
const NOT_A_BATCH := ["HP", "BD"]   # health points and Break damage, after *of* or *from*: game terms, not batches
const MOVED_HEADING := "### Moved from master.html"
const MOVED_FLOOR := 50

var _g := Gate.new()
var _run: Node = null
var _player := {}
var _strip := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH IS — THE LOAD DOOR's FIVE ANSWERS, THE FLOOR CENSUS's REMAINDER, THE WORDS, THE PILOT AND THE STRIP")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a fight is spawned")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	var had_harness := FileAccess.file_exists(String(_run.save_path))
	var harness := FileAccess.get_file_as_bytes(String(_run.save_path)) if had_harness else PackedByteArray()
	_fresh_meta()
	var marks := PackedStringArray()
	var ts := Time.get_ticks_msec()
	_s0_the_rulings()
	await _s2_the_load_door()
	marks.append("§2 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s3a_splits()
	marks.append("§3a %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s3b_the_three_rows()
	marks.append("§3b %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	ts = Time.get_ticks_msec()
	await _s4_words_and_picks()
	marks.append("§4 %.1f" % ((Time.get_ticks_msec() - ts) / 1000.0))
	_s5_the_index_pilot()
	_s6_the_history_strip()
	# The harness save back as this gate found it.
	if had_harness:
		var fr := FileAccess.open(String(_run.save_path), FileAccess.WRITE)
		fr.store_buffer(harness)
		fr.close()
	else:
		_remove(String(_run.save_path))
	_run.active = false
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 3)
	_s9_the_players_files()
	print("\n    runtime %.1f s (%s)" % [(Time.get_ticks_msec() - t0) / 1000.0, ", ".join(marks)])
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────

func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _fresh_meta() -> void:
	Profile.save_path = SCRATCH_PROFILE
	_remove(SCRATCH_PROFILE)
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


func _src(path: String) -> String:
	if not _strip.has(path):
		_strip[path] = Gate.strip_comments(FileAccess.get_file_as_string("res://" + path))
	return _strip[path]


func _body(path: String, fn: String) -> String:
	var src := _src(path)
	var at := src.find("\nfunc " + fn + "(")
	if at < 0:
		at = src.find("\nstatic func " + fn + "(")
	if at < 0:
		return ""
	var end := src.find("\nfunc ", at + 6)
	var end2 := src.find("\nstatic func ", at + 6)
	if end2 >= 0 and (end < 0 or end2 < end):
		end = end2
	return src.substr(at, (end if end >= 0 else src.length()) - at)


func _new_run(difficulty: String) -> void:
	_run.sim_run = false
	_run.new_run(SEATS, [], difficulty)
	for i in _run.party.size():
		var key := String(_run.party[i]["key"])
		_run.awaken(i, Runes.engine_rune_id(String(Classes.class_engines(key)[0])))
	_run.specs_chosen = true
	_run.active = true


# Today's definition of a rune, asked dynamically so a tree without the door (a HEAD control) reds rather than throws.
func _def(id: String) -> Dictionary:
	var rs: Variant = load("res://scripts/runes.gd")
	if rs != null and (rs as Script).has_method("definition"):
		return rs.call("definition", id)
	return {"defined": false, "payload": {"<no door>": true}}


func _roundtrip() -> bool:
	_run.save_run()
	return _run.load_run()


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return (s.get("enemies") as Array).filter(func(e): return not e.dead)


func _sturdy(s: Node) -> void:
	for e in s.get("enemies"):
		e.max_hp = 9999
		e.hp = 9999


func _clear(s: Node) -> void:
	Engine.time_scale = 1.0
	s.queue_free()
	for _i in 4:
		await process_frame


func _hp_of(s: Node) -> Dictionary:
	var out := {}
	for hh in (s.get("heroes") as Array) + (s.get("companions") as Array):
		out[hh] = hh.hp
	return out


func _billed(s: Node, before: Dictionary) -> int:
	var n := 0
	for hh in before:
		if is_instance_valid(hh):
			n += int(before[hh]) - int((hh as BattleUnit).hp)
	return n


# ── §0 — THE RULINGS, PINNED IN THE FILE EACH BINDS ─────────────────────────

func _s0_the_rulings() -> void:
	print("\n§0 — the rulings recorded, each in the file it binds")
	var cl := FileAccess.get_file_as_string("res://CLAUDE.md")
	var ir := FileAccess.get_file_as_string("res://docs/instrument-rules.md")
	var pins := [
		[cl, "CLAUDE.md", "A CARD REMOVED AFTER THE SAVE FLOOR ADDS A ROW TO THE LOAD DOOR's REMOVAL MAP, IN THE BATCH THAT REMOVES IT"],
		[cl, "CLAUDE.md", "A PAYLOAD TODAY's GAME CANNOT READ IS REBUILT FROM TODAY's DEFINITION"],
		[cl, "CLAUDE.md", "A SPLIT DISTRIBUTES WHAT IT IS GIVEN AND NEVER MULTIPLIES IT"],
		[cl, "CLAUDE.md", "THE BOT's ALLY POOLS ARE A KNOWN CONSTANT BIAS"],
		[cl, "CLAUDE.md", "A PICK IS OFFERED WHERE THE CAST PAYS"],
		[ir, "docs/instrument-rules.md", "A CENSUS's OWN LESS-THAN-FULL-CONFIDENCE ROWS ARE DRIVEN BY THE NEXT BATCH THAT TOUCHES THAT CENSUS"],
	]
	for p in pins:
		ok(String(p[0]).contains(String(p[2])), "§0: %s does not hold '%s'" % [p[1], p[2]])


# ── §2 — THE LOAD DOOR's FIVE ANSWERS ───────────────────────────────────────

func _written_member_keys() -> Dictionary:
	var out := {}
	var re := RegEx.new()
	re.compile("\\b(member|md|md2|mem|m|Run\\.party\\[[^\\]]+\\]|run\\.party\\[[^\\]]+\\]|party\\[[^\\]]+\\])\\[\"([a-z_0-9]+)\"\\]\\s*(=|\\+=|-=)(?!=)")
	for f in DirAccess.get_files_at("res://scripts"):
		if not String(f).ends_with(".gd"):
			continue
		for m in re.search_all(_src("scripts/" + String(f))):
			out[m.get_string(2)] = String(f)
	return out


func _s2_the_load_door() -> void:
	print("\n§2 — the load door's five answers, as one population")
	var consts: Dictionary = (_run.get_script() as Script).get_script_constant_map()
	var answers: Array = (consts.get("LOAD_DOOR_ANSWERS", {}) as Dictionary).keys()
	answers.sort()
	ok(answers == FIVE, "§2: the load door's answers are %s, not the five %s" % [str(answers), str(FIVE)])
	# THE REMOVAL MAP's ROWS, AND THEIR SHAPE.
	var removed: Dictionary = consts.get("REMOVED_CARDS", {})
	var renamed: Dictionary = consts.get("RENAMED_CARDS", {})
	var rkeys: Array = removed.keys()
	rkeys.sort()
	var want: Array = REMOVALS.keys()
	want.sort()
	ok(rkeys == want, "§2a: the load door's removal map holds %s — the derivation found %s" % [str(rkeys), str(want)])
	var corpus := {}
	for ab in Classes.ability_corpus():
		corpus[String(ab.display_name)] = true
	var bad := []
	for n in removed:
		if corpus.has(String(n)) or renamed.has(n) or renamed.values().has(n):
			bad.append("%s is a card today or a rename" % n)
		if not String(removed[n]).contains("§"):
			bad.append("%s names no batch (%s)" % [n, str(removed[n])])
	for rid in Runes.ids():
		var p := JSON.stringify((Runes.config(rid) as Dictionary).get("payload", {}))
		for n in removed:
			if p.contains("\"%s\"" % String(n)):
				bad.append("rune %s's definition names the removed %s" % [rid, n])
	ok(bad.is_empty(), "§2a: the removal map — %s" % str(bad))
	# THE SIXTH KIND: every key the save carries, and every key a member carries, sorted.
	_new_run("warden")
	_run.save_run()
	var f := FileAccess.open(String(_run.save_path), FileAccess.READ)
	var saved: Variant = f.get_var(true)
	f.close()
	var top: Array = (saved as Dictionary).keys() if saved is Dictionary else []
	var unsorted := []
	for k in top:
		if not SAVE_KEYS.has(String(k)):
			unsorted.append(String(k))
	var gone := []
	for k in SAVE_KEYS:
		if not top.has(k):
			gone.append(k)
	ok(top.size() > 20 and unsorted.is_empty(), "§2: the run save carries a key nobody sorted — %s (a sixth kind of thing)" % str(unsorted))
	ok(gone.is_empty(), "§2: a sorted save key the save no longer carries: %s" % str(gone))
	var mkeys := _written_member_keys()
	for m in (saved as Dictionary).get("party", []):
		for k in (m as Dictionary).keys():
			mkeys[String(k)] = "a saved member"
	mkeys["companions_standing"] = "battle.COMPANIONS_STANDING"
	var munsorted := []
	for k in mkeys:
		if not MEMBER_KEYS.has(String(k)):
			munsorted.append("%s (%s)" % [k, mkeys[k]])
	ok(mkeys.size() >= 20 and munsorted.is_empty(),
		"§2: a member carries a key nobody sorted — %s (a sixth kind of thing)" % str(munsorted))
	var cards: Array = []
	var runes: Array = []
	for k in MEMBER_KEYS:
		if String(MEMBER_KEYS[k]) == "CARDS":
			cards.append(k)
		elif String(MEMBER_KEYS[k]) == "RUNES":
			runes.append(k)
	var door_cards: Array = (consts.get("LOAD_DOOR_CARD_KEYS", []) as Array).duplicate()
	var door_runes: Array = (consts.get("LOAD_DOOR_RUNE_KEYS", []) as Array).duplicate()
	cards.sort()
	runes.sort()
	door_cards.sort()
	door_runes.sort()
	ok(cards == door_cards and runes == door_runes,
		"§2: the keys that carry a card or a rune are %s / %s; the door walks %s / %s" % [str(cards), str(runes), str(door_cards), str(door_runes)])
	var walk := _body("scripts/run_state.gd", "_rename_saved_cards") + _body("scripts/run_state.gd", "_rebuild_stale_payloads")
	var unwalked := []
	for k in cards + runes:
		if not walk.contains("\"%s\"" % k):
			unwalked.append(k)
	ok(unwalked.is_empty(), "§2: a key the door names is not walked at the load: %s" % str(unwalked))
	var lr := _body("scripts/run_state.gd", "load_run")
	ok(lr.contains("_rebuild_stale_payloads()") and lr.contains("_rename_saved_cards()")
			and lr.find("_rebuild_stale_payloads()") < lr.find("_rename_saved_cards()"),
		"§2: the load door does not rebuild the payloads before it reads the cards")
	# EACH ANSWER REACHED, BY THE DOOR's OWN SORTING.
	_run.call("_rename_saved_cards")
	var seen := {}
	var sorting := _run.has_method("_card_answer") and _run.has_method("_rune_answer")
	ok(sorting, "§2: the load door has no sorting — `_card_answer` and `_rune_answer` are not in the game")
	for n in ["Strike", "Iron Will", "Flash Freeze", NEVER_A_CARD]:
		if sorting:
			seen[String(_run.call("_card_answer", n))] = true
	var fresh := Runes.build("deepening_hex")
	var stale := Runes.build("deepening_hex")
	stale["payload"] = {"stat": {"rune_hex_threshold": 8}}
	var stray := Runes.build("tithe")
	stray["id"] = GONE_RUNE
	for r in [fresh, stale, stray]:
		if sorting:
			seen[String(_run.call("_rune_answer", r))] = true
	var reached: Array = seen.keys()
	reached.sort()
	ok(reached == FIVE, "§2: the door's sorting reached %s of the five %s" % [str(reached), str(FIVE)])
	# ── DRIVEN: A REMOVED CARD (the third answer) ──
	_new_run("warden")
	var mage: Dictionary = _run.party[1]
	mage["bm_abilities"] = ["Flash Freeze", "Glacial Prison"]
	mage["bm_equipped"] = ["Flash Freeze", "Glacial Prison"]
	mage["draft_candidates"] = [["Flash Freeze", "Rime", "Cryoclasm"]]
	mage["bm_candidates"] = [["Observance", "Shatter"]]
	mage["draft_refused"] = ["Observance", "Rimebinding"]
	mage["upgrades"] = [{"id": "up_speed", "ability": "Flash Freeze"}, {"id": "up_speed", "ability": "Glacial Prison"}]
	mage["up_candidates"] = [[{"id": "up_damage", "ability": "Flash Freeze"}, {"id": "up_damage", "ability": "Glacial Prison"}]]
	var used_before: int = _run.ability_slots_used(mage)
	seed(2026102201)
	var d0 := randi()
	seed(2026102201)
	ok(_roundtrip(), "§2a: the save holding a removed card did not load")
	ok(randi() == d0, "§2a: loading a save that names a removed card spent a die")
	var mg: Dictionary = _run.party[1]
	var left := []
	for k in ["bm_abilities", "bm_equipped", "draft_refused", "draft_candidates", "bm_candidates", "upgrades", "up_candidates"]:
		var t := JSON.stringify(mg.get(k, []))
		if t.contains("Flash Freeze") or t.contains("Observance"):
			left.append(k)
	ok(left.is_empty(), "§2a: a removed card is still on the save after the load, in %s" % str(left))
	ok(mg.get("bm_abilities") == ["Glacial Prison"] and mg.get("bm_equipped") == ["Glacial Prison"]
			and mg.get("draft_candidates") == [["Rime", "Cryoclasm"]] and mg.get("bm_candidates") == [["Shatter"]]
			and mg.get("draft_refused") == ["Rimebinding"],
		"§2a: the drop took more or less than the removed card — %s" % str([mg.get("bm_abilities"), mg.get("bm_equipped"), mg.get("draft_candidates"), mg.get("bm_candidates"), mg.get("draft_refused")]))
	ok((mg.get("upgrades", []) as Array).size() == 1 and (mg.get("up_candidates", [[]]) as Array)[0].size() == 1,
		"§2a: an upgrade on the removed card stayed — %s / %s" % [str(mg.get("upgrades")), str(mg.get("up_candidates"))])
	ok(_run.ability_slots_used(mg) == used_before - 1, "§2a: the drop freed no slot — %d used before, %d after" % [used_before, _run.ability_slots_used(mg)])
	var dropped: Array = _run.get("load_dropped_cards") if _run.get("load_dropped_cards") is Array else []
	var names := []
	for d in dropped:
		names.append(String((d as Dictionary).get("card", "")))
	names.sort()
	ok(names == ["Flash Freeze", "Observance"], "§2a: the load named the drops %s" % str(names))
	var notes: Array = (_run.get("load_notes") as Array).duplicate()
	var said := " · ".join(PackedStringArray(notes.map(func(x): return String(x))))
	ok(said.contains("Flash Freeze") and said.contains("slot is free") and said.contains("Observance"),
		"§2a: the drop is not said for the player — the load's notes read '%s'" % said)
	# THE SURFACE: the map's arrival says it, once.
	change_scene_to_file("res://scenes/map.tscn")
	Engine.time_scale = 1.0
	for _f in 3:
		await process_frame
	var toast := ""
	var clipped := []
	if current_scene != null:
		for n in current_scene.find_children("*", "Label", true, false):
			if (n as Node).has_meta("toast"):
				var tl: Label = n
				toast += String(tl.text)
				if tl.position.x < 0.0 or tl.position.x + tl.size.x > 1280.0 or tl.get_minimum_size().x > tl.size.x + 0.5:
					clipped.append("%.0f..%.0f px, text %.0f px" % [tl.position.x, tl.position.x + tl.size.x, tl.get_minimum_size().x])
	ok(toast.contains("Flash Freeze") and toast.contains("no longer in the game"),
		"§2a: the map's arrival does not say the drop — its toast read '%s'" % toast)
	ok(clipped.is_empty(), "§2a: the arrival toast runs past the screen — %s" % str(clipped))
	print("    a removed card loads gone: %s; the map says '%s'" % [str(mg.get("bm_abilities")), toast.left(110)])
	# ── DRIVEN: A NAME IN NEITHER MAP IS KEPT; A RENAME STILL TRANSLATES (the fourth and second answers) ──
	_new_run("warden")
	_run.party[2]["bm_abilities"] = [NEVER_A_CARD, "Matins"]
	ok(_roundtrip(), "§2 keep: the save did not load")
	var kept: Array = _run.party[2].get("bm_abilities", [])
	var loud: Array = _run.get("load_unknown_cards") if _run.get("load_unknown_cards") is Array else []
	ok(kept.has(NEVER_A_CARD) and loud == [NEVER_A_CARD], "§2 keep: a name in neither map was not kept and said — %s / %s" % [str(kept), str(loud)])
	ok(kept.has("Divine Presence") and not kept.has("Matins"), "§2 translate: a renamed card loaded as %s" % str(kept))
	# ── DRIVEN: DEEPENING HEX's STALE PAYLOAD PAYS TODAY's FIGURE (the fifth answer) ──
	_new_run("warden")
	var hex := Runes.build("deepening_hex")
	hex["payload"] = {"stat": {"rune_hex_threshold": 8}}
	hex["equipped"] = true
	(_run.party[2]["runes"] as Array).append(hex)
	var odd := Runes.build("tithe")
	odd["payload"] = {"stat": {"rune_blood_communion": 30, "is_gone_field": 4}}
	(_run.party[2]["runes"] as Array).append(odd)
	var stray2 := Runes.build("tithe")
	stray2["id"] = GONE_RUNE
	_run.rune_bag.append(stray2)
	_run.party[0]["engine_offer"] = [GONE_RUNE, String(Runes.engine_rune_id(String(Classes.class_engines("warrior")[0])))]
	seed(2026102202)
	var d1 := randi()
	seed(2026102202)
	ok(_roundtrip(), "§2b: the save holding a stale payload did not load")
	ok(randi() == d1, "§2b: loading a stale payload spent a die")
	var held: Array = _run.party[2].get("runes", [])
	var hex_now: Dictionary = {}
	var odd_now: Dictionary = {}
	for r in held:
		if String((r as Dictionary).get("id", "")) == "deepening_hex":
			hex_now = r
		elif String((r as Dictionary).get("id", "")) == "tithe":
			odd_now = r
	ok(hex_now.get("payload", {}) == _def("deepening_hex")["payload"],
		"§2b: Deepening Hex's stale payload loaded as %s, not today's definition" % str(hex_now.get("payload")))
	ok(odd_now.get("payload", {}) == _def("tithe")["payload"],
		"§2b: a stale field on Tithe was not found by today's definition — it loaded as %s" % str(odd_now.get("payload")))
	var rebuilt: Array = _run.get("load_rebuilt_runes") if _run.get("load_rebuilt_runes") is Array else []
	ok(rebuilt.size() == 2, "§2b: the load names %d rebuilds, not the two — %s" % [rebuilt.size(), str(rebuilt)])
	var notes2 := " · ".join(PackedStringArray((_run.get("load_notes") as Array).map(func(x): return String(x))))
	ok(notes2.contains("Deepening Hex") and notes2.contains("rebuilt"), "§2b: the rebuild is not said — '%s'" % notes2)
	# A RUNE TODAY's GAME DEFINES NOWHERE: dropped, from the bag and from a class-selection deal, and said.
	var strays := []
	for r in _run.rune_bag:
		if String((r as Dictionary).get("id", "")) == GONE_RUNE:
			strays.append(r)
	ok(strays.is_empty() and not (_run.party[0].get("engine_offer", []) as Array).has(GONE_RUNE)
			and (_run.party[0].get("engine_offer", []) as Array).size() == 1,
		"§2b: a rune the game defines nowhere was kept — bag %d, offer %s" % [strays.size(), str(_run.party[0].get("engine_offer"))])
	ok(notes2.contains("is no longer in the game"), "§2b: the dropped rune is not said — '%s'" % notes2)
	# DERIVED, NOT MAPPED: the test reads today's definition (C06's break is a list of fields).
	var sp := _body("scripts/run_state.gd", "_stale_paths")
	ok(sp.contains("Runes.definition") and sp.contains("payload_fields") and not sp.contains("rune_hex"),
		"§2b: the stale-field test does not read today's definition, or names a field by hand")
	# THE FIGHT: the rebuilt rune pays today's figure — Ruin detonates every 8th, not the 10th the stale field left.
	var occ_seat := {2: {"runes": [hex_now.duplicate(true)]}}
	var s: Node = await Gate.spawn(self, ["", "", "occultist", ""], {"deterministic": true, "party": occ_seat})
	var occ: BattleUnit = _hero(s, "cleric")
	ok(occ != null and occ.rune_hex_deepen == 2 and int(s.call("_ruin_threshold")) == 8,
		"§2b: the rebuilt Deepening Hex pays %s (threshold %d), not today's two (8)" % [
			str(occ.rune_hex_deepen) if occ != null else "nobody", int(s.call("_ruin_threshold"))])
	print("    Deepening Hex's stale payload rebuilt: Ruin every %dth" % int(s.call("_ruin_threshold")))
	await _clear(s)
	# A CLEAN SAVE LOADS UNTOUCHED: every live rune as built, today's cards, no note.
	_new_run("warden")
	var every := []
	for rid in Runes.ids():
		if not Runes.is_retired(String(rid)) and not Runes.is_engine_rune(String(rid)):
			every.append(Runes.build(String(rid)))
	_run.party[3]["runes"] = every
	_run.party[3]["bm_abilities"] = ["Heal", "Renewal"]
	_run.party[3]["draft_candidates"] = [["Divine Plea", "Dawnbreak", "Heal"]]
	var clean: Dictionary = (_run.party[3] as Dictionary).duplicate(true)
	seed(2026102203)
	var d2 := randi()
	seed(2026102203)
	ok(_roundtrip(), "§2 clean: the save did not load")
	ok(randi() == d2, "§2 clean: loading a clean save spent a die")
	var cl_notes: Array = _run.get("load_notes") if _run.get("load_notes") is Array else ["<none>"]
	var cl_rebuilt: Variant = _run.get("load_rebuilt_runes")
	ok(_run.party[3] == clean and cl_notes.is_empty() and cl_rebuilt is Array and (cl_rebuilt as Array).is_empty(),
		"§2 clean: a save holding %d live runes as built and today's cards loaded changed, or said %s" % [every.size(), str(cl_notes)])
	print("    clean: %d live runes and today's cards load untouched" % every.size())
	_run.active = false


# ── §3a — A SPLIT's SHARES SUM TO WHAT IS SPLIT ─────────────────────────────

func _s3a_splits() -> void:
	print("\n§3a — a split distributes what it is given and never multiplies it")
	var s: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	_sturdy(s)
	var hs: Array = (s.get("heroes") as Array).filter(func(h): return not h.is_companion)
	# THE INVARIANT, over every amount from 0 and every count of bound bodies.
	seed(2026102204)
	var d0 := randi()
	seed(2026102204)
	var broke := []
	var tried := 0
	ok(s.has_method("_split_shares"), "§3a: `_split_shares`, the one split, is not in the game")
	for n in (range(1, 5) if s.has_method("_split_shares") else []):
		var bodies: Array = hs.slice(0, n)
		for total in [0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 13, 31, 97]:
			var sh: Array = s.call("_split_shares", total, bodies, bodies[n - 1])
			var sum := 0
			var lo := 1 << 30
			var hi := -1
			for x in sh:
				sum += int(x[1])
				lo = mini(lo, int(x[1]))
				hi = maxi(hi, int(x[1]))
			tried += 1
			if sum != total or sh.size() != n or hi - lo > 1 or int(sh[0][1]) != hi or sh[0][0] != bodies[n - 1] \
					or sh != s.call("_split_shares", total, bodies, bodies[n - 1]):
				broke.append("%d over %d -> %s" % [total, n, str(sh.map(func(x): return int(x[1])))])
	ok(broke.is_empty(), "§3a: a split's shares do not sum to what was split — %s" % str(broke))
	ok(randi() == d0, "§3a: a split spent a die")
	print("    %d splits (0 to 97 over 1 to 4 bodies): every one sums to its amount" % tried)
	# EVERY SPLIT IN THE GAME IS THE ONE FUNCTION: the old shape is gone and the four sites call it.
	var re := RegEx.new()
	re.compile("maxi\\(int\\(round\\([^)]*/\\s*float\\([a-z_]+\\.size\\(\\)\\)\\)\\),\\s*1\\)")
	var olds := []
	for path in ["scripts/battle.gd", "scripts/unit.gd"]:
		for m in re.search_all(_src(path)):
			olds.append(m.get_string().left(70))
	ok(olds.is_empty(), "§3a: a split still rounds and floors each share — %s" % str(olds))
	var b := _src("scripts/battle.gd")
	var calls := b.count("_split_shares(") - b.count("func _split_shares(")
	ok(calls == 4, "§3a: `_split_shares` is called %d times, not at the four splits (the Unity blow, recoil and bleedout, and Blowback)" % calls)
	# DRIVEN AT EACH SITE: the bound party is billed what was split, exactly.
	var w: BattleUnit = _hero(s, "warrior")
	var m: BattleUnit = _hero(s, "mage")
	var foe: BattleUnit = _foes(s)[0]
	for hh in hs:
		hh.max_hp = 999
		hh.hp = 999
		s._apply_status(hh, "unity", 9)
	# 1. A 1-damage blow on four bound heroes.
	foe.attack = 1
	var before := _hp_of(s)
	var hist0 := String(s.get("history").get_parsed_text()).length()
	await s._resolve(foe, foe.abilities[0], w, "good")
	var blow := _billed(s, before)
	var line_re := RegEx.new()
	line_re.compile("Unity splits (\\d+) damage")
	var split_m := line_re.search(String(s.get("history").get_parsed_text()).substr(hist0))
	var split_n := int(split_m.get_string(1)) if split_m != null else -1
	ok(split_n >= 1 and split_n <= 2 and blow == split_n,
		"§3a: a %d-damage blow on four bound heroes billed %d in all — the split multiplied it" % [split_n, blow])
	# 2. A recoil of 1 (Mirrorbound's floor) on the Mage, four bound.
	for hh in hs:
		hh.hp = 999
	m.mod_recoil = 0.25
	m.attack = 1
	var foe2: BattleUnit = _foes(s)[1]
	before = _hp_of(s)
	var fhp: int = foe2.hp
	await s._resolve(m, m.abilities[0], foe2, "good")
	var dealt: int = fhp - foe2.hp
	var rc := _billed(s, before)
	var want_rc := maxi(int(round(dealt * 0.25)), 1)
	ok(rc == want_rc, "§3a: a recoil of %d on a bound Mage billed the party %d" % [want_rc, rc])
	m.mod_recoil = 0.0
	# 3. A bleedout on a bound hero.
	for hh in hs:
		hh.hp = 999
		hh.max_hp = 999
	before = _hp_of(s)
	var bl_total := maxi(int(w.max_hp * 0.20), 1)
	s._add_bleed_with_burst(w, 100)
	var bl := _billed(s, before)
	ok(bl == bl_total, "§3a: a bleedout of %d on a bound hero billed the party %d" % [bl_total, bl])
	print("    driven: a blow of %d billed %d, a recoil of %d billed %d, a bleedout of %d billed %d" % [split_n, blow, want_rc, rc, bl_total, bl])
	await _clear(s)
	# IR's PARRIED BLOW, KEPT AS A NAMED REGRESSION: a blow parried outright bills nobody.
	var su: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	var tank: BattleUnit = _hero(su, "warrior")
	var raider: BattleUnit = _foes(su)[0]
	for hh in su.get("heroes"):
		hh.hp = hh.max_hp
	tank.untouchable = 1
	tank.stance = "defensive"
	tank.parry_chance = 10.0
	su._apply_status(tank, "unity", 3)
	var hp0 := _hp_of(su)
	await su._resolve(raider, raider.abilities[0], tank, "good")
	ok(_billed(su, hp0) == 0, "§3a (IR §1d): a blow parried outright billed the bound heroes %d" % _billed(su, hp0))
	await _clear(su)


# ── §3b — THE FLOOR CENSUS's THREE UNCERTAIN ROWS, DRIVEN ───────────────────

func _s3b_the_three_rows() -> void:
	print("\n§3b — the floor census's three uncertain rows, each driven to a verdict")
	# 1. SHATTER AND WINTER's TOLL — GUARDED BY TURN ORDER. Every turn of the loop trues the holds up first, and an extra
	# turn re-enters the loop; the one route that lays a hold inside a turn before its owner acts is the Cryomancer's
	# turn-start upkeep (Eternal Winter, Winter's Grasp), and nothing writes either field. The day one is written, this reds.
	var b := _src("scripts/battle.gd")
	var rb := _body("scripts/battle.gd", "_run_battle")
	ok(b.count("_hold_sync()") - b.count("func _hold_sync()") == 1 and rb.contains("_hold_sync()"),
		"§3b-1: the holds are not trued up once a turn, at the top of the loop")
	for fn in ["_preparation_tick", "_grant_free_action"]:
		var body := _body("scripts/battle.gd", fn)
		ok(body.contains("next_time") and not body.contains("_resolve("), "§3b-1: `%s` acts inside the turn instead of re-entering the loop" % fn)
	var writers := []
	var data := FileAccess.get_file_as_string("res://data/runes.json") + FileAccess.get_file_as_string("res://scripts/talents.gd")
	for fld in ["eternal_winter", "grasp_ranks", "rune_eternal_winter", "rune_grasp_ranks"]:
		if data.contains("\"%s\"" % fld):
			writers.append(fld)
	ok(writers.is_empty(),
		"§3b-1: the Cryomancer's turn-start upkeep has a writer (%s) — a hold can be laid and paid in one turn, so Shatter's and Winter's Toll's floor of 1 is DEFECT-SHAPE" % str(writers))
	# 2. CULL AND HARVEST — the yield the guard reads against the count the payout reads, over bodies built to differ.
	var s: Node = await Gate.spawn(self, ["", "", "", "mystic"], {"deterministic": true})
	_sturdy(s)
	var hunter: BattleUnit = _hero(s, "hunter")
	var mage: BattleUnit = _hero(s, "mage")
	var cf: BattleUnit = _foes(s)[0]
	var builds := ["two plain", "a conjunction beside a sticky poison", "sticky only, on a Broken body",
		"a sticky ingredient in a conjunction, beside a plain one"]
	var disagree := []
	var shown := []
	var ylds := []
	for k in builds:
		cf.statuses = []
		cf.broken = false
		match k:
			"two plain":
				s._apply_status(cf, "poison", 3, 1, 1, hunter)
				s._apply_status(cf, "slow", 2, 0, 0, hunter)
			"a conjunction beside a sticky poison":
				s._apply_status(cf, "burn", 3, 0, 2, mage)
				s._apply_status(cf, "chilled", 3, 0, 0, mage)
				s._apply_status(cf, "poison", 3, 1, 1, hunter)
				var p1: Dictionary = cf.get_status("poison")
				if not p1.is_empty():
					p1["sticky"] = true
			"sticky only, on a Broken body":
				s._apply_status(cf, "poison", 3, 1, 1, hunter)
				var p2: Dictionary = cf.get_status("poison")
				if not p2.is_empty():
					p2["sticky"] = true
				cf.broken = true
			"a sticky ingredient in a conjunction, beside a plain one":
				s._apply_status(cf, "burn", 3, 0, 2, mage)
				var b3: Dictionary = cf.get_status("burn")
				if not b3.is_empty():
					b3["sticky"] = true
				s._apply_status(cf, "chilled", 3, 0, 0, mage)
				s._apply_status(cf, "slow", 2, 0, 0, hunter)
		var yield_n: int = s.call("_harvest_yield", cf)
		var before_n: int = s.call("_status_count", cf)
		var copy: Array = cf.statuses.duplicate(true)
		cf.purge_debuffs()
		var paid: int = maxi(before_n - int(s.call("_status_count", cf)), 0)
		cf.statuses = copy
		ylds.append(yield_n)
		shown.append("%s: yield %d, paid %d" % [k, yield_n, paid])
		if yield_n != paid:
			disagree.append("%s (yield %d, paid %d)" % [k, yield_n, paid])
	ok(disagree.is_empty(), "§3b-2: Cull's and Harvest's guard and payout count a body two ways — %s" % str(disagree))
	ok(ylds == [2, 2, 0, 1], "§3b-2: the bodies built for the drive are not the four as built — %s" % str(shown))
	print("    %s" % "; ".join(PackedStringArray(shown)))
	await _clear(s)
	# 3. RETURNED BURDEN — an effect lifted at 0 turns is re-laid for 1 (driven); no source lays one at 0 on a hero.
	var s3: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	_sturdy(s3)
	var cleric: BattleUnit = _hero(s3, "cleric")
	var w: BattleUnit = _hero(s3, "warrior")
	var foe: BattleUnit = _foes(s3)[0]
	s3._apply_status(w, "slow", 2, 0, 0, foe)
	var st: Dictionary = w.get_status("slow")
	st["turns"] = 0
	var taken: Array = w.purge_debuffs_taken()
	s3.call("_return_burden", cleric, w, taken)
	var landed := -9
	for e in _foes(s3):
		if (e as BattleUnit).has_status("slow"):
			landed = int((e as BattleUnit).get_status("slow").get("turns", -9))
	ok(landed == 1, "§3b-3: an effect lifted at 0 turns was re-laid for %d (the guard reads 1)" % landed)
	# Every harmful effect an enemy lays on a hero carries a positive duration, the door floors a positive one at 1 under
	# Fleeting, and the clock removes a 0 the pass it reaches it — so a hero never carries a 0-turn effect to be lifted.
	var zero := []
	var enemies_json: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	var applies := []
	_collect_applies(enemies_json, applies)
	for a in applies:
		if int((a as Dictionary).get("turns", 0)) <= 0:
			zero.append(str(a))
	w.mod_status_turns = -1
	for a in applies:
		var sid := String((a as Dictionary).get("id", ""))
		if sid == "" or not BattleUnit.DEBUFF_IDS.has(sid):
			continue
		w.statuses = []
		s3._apply_status(w, sid, int((a as Dictionary).get("turns", 1)), 0, 0, foe)
		for _t in 8:
			for x in w.statuses:
				if int((x as Dictionary).get("turns", 1)) == 0:
					zero.append("%s stood at 0" % sid)
			w.tick_statuses()
	w.mod_status_turns = 0
	ok(applies.size() >= 10 and zero.is_empty(), "§3b-3: a harmful effect reaches a hero at 0 turns — %s (of %d sources)" % [str(zero), applies.size()])
	print("    Returned Burden: a 0-turn effect re-laid for %d; %d enemy sources each lay a positive duration, none stands at 0" % [landed, applies.size()])
	await _clear(s3)


func _collect_applies(x: Variant, out: Array) -> void:
	if x is Dictionary:
		if (x as Dictionary).get("applies_status") is Dictionary:
			out.append((x as Dictionary)["applies_status"])
		for v in (x as Dictionary).values():
			_collect_applies(v, out)
	elif x is Array:
		for v in x:
			_collect_applies(v, out)


# ── §4 — THE THREE WORDS, AND THE PICK POPULATION ───────────────────────────

# A pick's words, read off the population table by a lookup that cannot fail to parse: a row taken out of
# `NONCARD_PICKS` reds the words arm (the fallback is words no text holds) and §4's population arm, never
# the whole gate (IS §9's C14 found a constant index there turning a missing row into a Parse Error).
func _pick_words(pick: String) -> String:
	return String((NONCARD_PICKS.get(pick, ["", "<%s is not in the pick population>" % pick, ""]) as Array)[1])


func _s4_words_and_picks() -> void:
	print("\n§4 — the three words, and every pick that offers a body on the hero side")
	var mantle: Ability = Classes.pool_ability("Mantle")
	var md := mantle.description if mantle != null else ""
	ok(md.replace("\n", " ").contains("Every hero who holds it builds Faith") and not md.contains("like the first"),
		"§4: Mantle's Faith clause reads '%s'" % md.replace("\n", " "))
	var faith := String(Glossary.entry("res_faith").get("long", ""))
	ok(faith.contains("builds TWO stacks on a hero who bears it") and not faith.contains("on its bearer"),
		"§4: the glossary's Faith still builds on its bearer, whoever bears it")
	var ss := String(Runes.config("split_shield").get("desc", ""))
	ok(ss.contains(_pick_words("Split Shield")) and not ss.contains("the ally he sets"),
		"§4: Split Shield reads '%s'" % ss)
	# THE PICK POPULATION, CARDS FIRST: every ally-target card, its words against its pool with a companion standing.
	var s: Node = await Gate.spawn(self, ["", "", "", ""], {"deterministic": true})
	_sturdy(s)
	var hunter: BattleUnit = _hero(s, "hunter")
	var call: Ability = s._summon_choice(hunter, "canis")
	if call != null:
		await s._resolve(hunter, call, hunter, "good")
	var beasts: Array = s._beasts(hunter)
	var comp: BattleUnit = beasts[0] if beasts.size() == 1 else null
	ok(comp != null, "§4: no companion stands for the pick drive (%d)" % beasts.size())
	var hero_picks: Array = (load("res://scripts/battle.gd").get_script_constant_map().get("HERO_PICKS", []) as Array)
	var mismatch := []
	var n_cards := 0
	for ab in Classes.ability_corpus():
		if ab.target != Ability.Target.ALLY:
			continue
		n_cards += 1
		var pool: Array = s.call("_ally_pick_pool", _hero(s, "cleric"), ab)
		if comp != null and hero_picks.has(ab.special) == pool.has(comp):
			mismatch.append("%s (%s) offers the companion: %s" % [ab.display_name, "HERO" if hero_picks.has(ab.special) else "ALLY", pool.has(comp)])
	ok(n_cards >= 18 and mismatch.is_empty(), "§4: an ally-target card's pick disagrees with its sort — %s (%d cards)" % [str(mismatch), n_cards])
	# AND THE PICKS THAT ARE NOT A CARD's.
	var w: BattleUnit = _hero(s, "warrior")
	var ss_pool: Array = s.call("_split_shield_allies", w)
	ok(not ss_pool.is_empty() and (comp == null or not ss_pool.has(comp)) and not ss_pool.has(w),
		"§4: Split Shield's pick (HERO) offers %s" % str(ss_pool.map(func(x): return x.unit_name)))
	var side: Array = s.call("_hero_side")
	ok(comp != null and side.has(comp), "§4: the hero side (Dispel's ally half, the cleanse talent's pick — ALLY) offers no companion")
	var talent := FileAccess.get_file_as_string("res://scripts/talents.gd")
	var dispel: Ability = Classes.pool_ability("Dispel")
	var unbuilt := []
	for k in NONCARD_PICKS:
		var fn := String((NONCARD_PICKS[k] as Array)[2])
		if fn != "_hero_side" and not HERO_SIDE_FUNCS.has(fn):
			unbuilt.append("%s reads %s, which no sorted builder is" % [k, fn])
	ok(unbuilt.is_empty(), "§4: a pick the gate holds reads no sorted pool — %s" % str(unbuilt))
	ok(dispel != null and dispel.description.replace("\n", " ").contains(_pick_words("Dispel"))
			and talent.contains(_pick_words("Cleanse Debuffs Each Turn")),
		"§4: Dispel's or the cleanse talent's words no longer say ally")
	# EVERY FUNCTION THAT BUILDS A HERO-SIDE POOL IS SORTED.
	var b := _src("scripts/battle.gd")
	var found := {}
	var cur := ""
	for line in b.split("\n"):
		if line.begins_with("func "):
			cur = line.substr(5, line.find("(") - 5)
			if cur.ends_with("_allies"):
				found[cur] = true
		if line.contains("_hero_side()") and not line.begins_with("func "):
			found[cur] = true
	var unsorted := []
	for f in found:
		if not HERO_SIDE_FUNCS.has(String(f)):
			unsorted.append(f)
	ok(found.size() >= 8 and unsorted.is_empty(), "§4: a function builds a pool on the hero side that nobody sorted — %s" % str(unsorted))
	ok(found.has("_split_shield_allies") and NONCARD_PICKS.has("Split Shield"),
		"§4: Split Shield's pick is not in the population")
	# THE BOT IS NOT WIDENED: its ally pools stay heroes-only, a constant bias every grade was measured through.
	for fn in ["_bot_class_kit_pick", "_bot_drafted_pick"]:
		ok(_body("scripts/battle.gd", fn).contains("is_companion"), "§4: the bot's `%s` no longer keeps its pool to the heroes — the ladder was measured through it" % fn)
	print("    %d ally-target cards and %d other picks, each word against its pool; %d hero-side builders sorted" % [n_cards, NONCARD_PICKS.size(), found.size()])
	await _clear(s)


# ── §5 — THE INDEX PILOT ────────────────────────────────────────────────────

func _s5_the_index_pilot() -> void:
	print("\n§5 — the index pilot, on docs/state.md alone")
	var st := FileAccess.get_file_as_string("res://docs/state.md")
	var a := st.find(INDEX_BEGIN)
	var b := st.find(INDEX_END)
	ok(a > 0 and b > a and st.count(INDEX_BEGIN) == 1 and st.count(INDEX_END) == 1,
		"§5: docs/state.md holds no single delimited index (%d, %d)" % [st.count(INDEX_BEGIN), st.count(INDEX_END)])
	if a < 0 or b < a:
		return
	var index := st.substr(a, b - a)
	# REVERSIBLE BY CONSTRUCTION: the index is a section; every block stands outside it, in full.
	var outside := st.substr(0, a) + st.substr(b)
	var blocks := []
	for line in outside.split("\n"):
		if line.begins_with("## ") or line.begins_with("### "):
			blocks.append(_block_key(line))
	var inside_heads := 0
	for line in index.split("\n"):
		if (line.begins_with("## ") or line.begins_with("### ")) and not line.contains("THE INDEX"):
			inside_heads += 1
	ok(inside_heads == 0 and blocks.size() >= 100, "§5: a block stands inside the index (%d), or the file holds %d blocks" % [inside_heads, blocks.size()])
	ok(st.find("\n## WHERE THE PROJECT IS") > b, "§5: the index does not stand above the WHERE block, where a batch meets it first")
	for phrase in ["THE PILOT ASKS WHETHER A BOUNDED READ IS A SUFFICIENT READ", "delete this section", "opened", "needed"]:
		ok(index.contains(phrase), "§5: the routing does not say '%s'" % phrase)
	# EVERY BLOCK HAS EXACTLY ONE ENTRY — the core, or a row — and every row carries its triggers.
	var core := {}
	var rows := {}
	var bad_rows := []
	for line in index.split("\n"):
		var k := _entry_key(line)
		if k == "":
			continue
		if line.begins_with("- **CORE**"):
			core[k] = true
		elif line.begins_with("- "):
			rows[k] = true
			var trig := line.substr(line.find("triggers:") + 9) if line.contains("triggers:") else ""
			if trig.split(",", false).size() < 3 or line.to_utf8_buffer().size() > 400:
				bad_rows.append(k.left(50))
	ok(bad_rows.is_empty(), "§5: an index row carries no triggers, or runs long: %s" % str(bad_rows))
	var missing := []
	var twice := []
	for k in blocks:
		var n := (1 if core.has(k) else 0) + (1 if rows.has(k) else 0)
		if n == 0:
			missing.append(String(k).left(60))
		elif n > 1:
			twice.append(String(k).left(60))
	var phantom := []
	for k in core.keys() + rows.keys():
		if not blocks.has(k):
			phantom.append(String(k).left(60))
	ok(missing.is_empty() and twice.is_empty() and phantom.is_empty(),
		"§5: the index is not the file's blocks — unrouted %s, twice %s, naming nothing %s" % [str(missing), str(twice), str(phantom)])
	# THE CORE KEEPS EVERY BLOCK SEVEN OF THE NINE BATCHES NEEDED — derived (IS's report §5), never chosen.
	var want := {}
	for k in NINE_COUNTS:
		if int(NINE_COUNTS[k]) >= 7:
			want[k] = true
	# BATCH IT — THE NEWEST RULINGS OWED IS THE CORE's BY ROLE (the routing's own words): the derivation counted IS's, and when
	# a later batch's stands in its place the role passes to it — the first RULINGS OWED the file holds, newest first.
	var newest := ""
	for k in blocks:
		if String(k).begins_with("### ") and String(k).ends_with("'s RULINGS OWED"):
			newest = String(k)
			break
	ok(newest != "", "§5: the file holds no RULINGS OWED for the core's role")
	if want.has("### IS's RULINGS OWED") and newest != "":
		want.erase("### IS's RULINGS OWED")
		want[newest] = true
	var core_keys := core.keys()
	core_keys.sort()
	var want_keys := want.keys()
	want_keys.sort()
	ok(core_keys == want_keys, "§5: the core is %s — the nine batches' needs make it %s" % [str(core_keys), str(want_keys)])
	print("    %d blocks: %d in the core (seven of nine), %d rows, each with its triggers" % [blocks.size(), core.size(), rows.size()])


# A block's key: its heading up to the first " — " (or whole), the level marks kept.
func _block_key(line: String) -> String:
	var h := line.strip_edges()
	var at := h.find(" — ")
	return (h.left(at) if at > 0 else h).strip_edges()


# An index entry names its block first, in a double-backtick span (a heading may hold a backtick):
# `- **CORE** `` ### SANCTITY's STEP ``` or `- `` ### FOUND AT HX AND NOT FIXED `` — label … *triggers:* …`.
func _entry_key(line: String) -> String:
	return Gate.index_entry_key(line)   # BATCH IT: the reader lives in `gate_fixture.gd`, shared with `check_it` §5


# ── §6 — THE HISTORY STRIP ──────────────────────────────────────────────────

func _s6_the_history_strip() -> void:
	print("\n§6 — master.html says what the game is")
	var html := FileAccess.get_file_as_string("res://docs/master.html")
	var stamp_end := html.find("</p>", html.find("Last updated"))
	ok(stamp_end > 0 and html.substr(0, stamp_end).contains("(Batch "), "§6: the stamp — the one batch the file names — is gone")
	var body := html.substr(stamp_end) if stamp_end > 0 else html
	var names := []
	for m in BATCH_NAME.search_all(body):
		var code := ""
		for g in range(2, m.get_group_count() + 1):
			if m.get_string(g) != "":
				code = m.get_string(g)
				break
		if code != "" and not NOT_A_BATCH.has(code):
			names.append(body.substr(maxi(m.get_start() - 30, 0), 70).replace("\n", " "))
	ok(names.is_empty(), "§6: master.html names a batch outside its stamp (%d): %s" % [names.size(), str(names.slice(0, 6))])
	var wasnow := []
	for m in WAS_NOW.search_all(body):
		wasnow.append(body.substr(maxi(m.get_start() - 20, 0), 80).replace("\n", " "))
	ok(wasnow.is_empty(), "§6: master.html says what the game WAS: %s" % str(wasnow.slice(0, 6)))
	# THE POSITIVE ARM: the reasoning the strip moved stands in the design notes, under its subjects.
	var dn := FileAccess.get_file_as_string("res://docs/design-notes.md")
	var moved_at := dn.find(MOVED_HEADING)
	var moved := dn.substr(moved_at, dn.find("\n## ", moved_at + 10) - moved_at) if moved_at >= 0 else ""
	ok(moved_at >= 0 and moved.count("\n**") >= MOVED_FLOOR,
		"§6: the design notes do not hold the reasoning the strip moved (%d subjects, %d wanted)" % [moved.count("\n**"), MOVED_FLOOR])
	ok(html.contains("Mantle") and html.contains("Sacred Resolve"), "§6: master.html lost the game it describes")
	print("    master.html names no batch outside its stamp; %d moved subjects stand in the design notes" % moved.count("\n**"))


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
	_remove(SCRATCH_PROFILE)
	_remove(SCRATCH_RELICS)
