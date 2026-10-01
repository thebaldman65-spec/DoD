# BATCH HP — THE CONDITION AS A FIGHT RUNS, AND THE THREE RUNES IT MAKES REAL.
#
#   §0  THE GROUND — this process writes the harness save, and scratch meta files
#   §1  THE LIVE DOOR — the keys read as the fight runs (all five since HQ §1); the
#       fields a live payload may write, DERIVED over HN §3a's twenty-eight and held
#       here as the partition; the refusal, loud at the table and at every
#       application, and the roll call's tail for it in a player's words (HQ §1); the
#       two doors a hero's standing changes through; a full CYCLE on a base where a
#       subtraction would drift, returning the figure bit for bit; a fight quit after
#       a fall and resumed; `heroes_hold_core` read as the fight runs, driven round
#       its own cycle (HQ §1); the hero sheet
#   §2  THE THREE RUNES — the entries at their RULED figures (HQ §1) and their shape,
#       STAT and CONDITIONAL (HQ §2), offered and taken through a real drop and
#       worn in the crest through the bag's own door, then each through a real
#       fight in which its hero falls and is revived; what a blow pays; the words
#       say WHILE; the BR §1 sweep of the three names
#   §3  FELLOWSHIP IS RETIRED — kept and said to be kept, offered by no door, a
#       save wearing it loads and it still resolves; its read site kept
#   §4  TITHE'S WORDS AND THE TALENT'S — the ruled sentence at the entry's own
#       figure, broken under the ceiling; *Breaking Heals a Hero*'s narrowed to the
#       same read site (HQ §1); the read site they describe, not widened
#   §5  THE RULINGS' RECORDS — FN's reconciliation, the §3 finding and HQ's three
#       records where a future session reads them
#   §6  THE SMALL THINGS — the run summary names the crest, a core rune and the bag;
#       the sim's counter stocks no core rune; the counter's dead re-roll is gone;
#       the comments that spoke Faith's threshold as a figure
#   §7  THE PLAYER'S FILES, as this gate found them
#
# **EVERY FIXTURE IS PUT INTO THE LOADED TABLE AND TAKEN OUT AGAIN, AND NONE IS
# WRITTEN TO THE FILE** (HL §6's shape). The three crest runes this batch authors
# are read off the file and driven as the file holds them. **EVERY FIELD A DRIVE
# MEASURES ARRIVES THROUGH A REAL DOOR** — the spawn, the live door, a death through
# the damage door, a revive through the battle's own item door — and this gate
# assigns none of the measured fields by hand (GW §2). **EVERY NEGATIVE ANCHOR HAS
# ITS POSITIVE ARM**, and a population prints how many it checked.
#
# **NO MAGNITUDE IS COPIED HERE BUT THE THREE THE DESIGNER RULED**: each rune's figure
# is read off its entry and the base a cycle runs on off the relic that sets it; the
# three crest figures were PROPOSED at HP and are RULED since HQ §1 (Dirge 45%, Empty
# Pulpit 50%, Dead Air 75%), so §2a holds the entries to the ruling — `check_cn`'s
# shape: moving a ruled figure is two edits, and the second one is this gate's line.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_hp.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const SEATS := ["warrior", "mage", "cleric", "hunter"]
const ENG4 := ["bloodrage", "overburn", "mercy", "pack"]
const SCRATCH_PROFILE := "user://hp_profile.json"
const SCRATCH_RELICS := "user://hp_relics.json"
const FOE := {"type": "fight", "theme": "Warband", "enemies": ["raider", "raider", "archer"]}
const FRAME_CAP := 60000
const CREST_FX := "hp_fixture_crest"
# The relic whose hook sets every hero's `dmg_bonus` at the spawn: the base a cycle
# runs on, so a subtraction would have something to drift from.
const BASE_RELIC := "dragonbone"

# §1b — HN §3a's twenty-eight every-hero fields, as its table lists them: the
# population the derivation was run over. The four `rune_` twins are the fields a
# rune writes for a node's counter (EM's charter), each summed in the one
# expression that reads its node's field.
const HN_28 := ["max_hp", "max_hp_pct", "attack", "armor", "crit_bonus", "speed", "parry_bonus",
	"max_resource", "dmg_bonus", "dmg_taken_bonus", "broken_will_ranks", "blood_communion",
	"follow_through", "bonecracker_ranks", "field_medic", "iron_will_ranks", "pierce_bonus",
	"deflection", "whetstone", "undying_rage", "no_cover", "sundering_shot", "no_quarter_ranks",
	"rapid_fire", "snap_shot", "constitution", "stability", "block_chance"]
const TWINS := {"rune_broken_will_ranks": "broken_will_ranks", "rune_blood_communion": "blood_communion",
	"rune_bonecracker_ranks": "bonecracker_ranks", "rune_field_medic": "field_medic"}
# HN §3a's third group: the stamps the battle takes the best holder's figure of, once.
const STAMPS := ["devoutness_ranks", "rune_devoutness_ranks", "last_hope_pct", "rune_last_hope_pct", "guardian_step"]
# The fields `_do_summon` hands a companion as it is called (the body's cfg, and the
# hunter's terms after it): a live figure on one would stay on the beast.
const SUMMON_COPIED := ["attack", "armor", "speed", "stability", "constitution", "crit_bonus"]

# §2 — the three, by id: the condition key each is ruled to read, the hero whose fall
# makes it hold (by seat), the field it writes, its words with the figure left out,
# and the figure the designer RULED at HQ §1 (Dirge and Empty Pulpit confirmed as HP
# proposed them; Dead Air moved 0.50 -> 0.75).
const THREE := {
	"empty_pulpit": {"name": "Empty Pulpit", "key": ["heroes_lack_class", "cleric"], "falls": 2,
		"field": "dmg_taken_bonus", "sign": -1, "ruled": -0.50,
		"words": "While no Cleric stands, every hero takes\n%d%% less damage."},
	"dead_air": {"name": "Dead Air", "key": ["heroes_lack_class", "mage"], "falls": 1,
		"field": "dmg_bonus", "sign": 1, "ruled": 0.75,
		"words": "While no Mage stands, every hero deals\n%d%% more damage."},
	"dirge": {"name": "Dirge", "key": ["heroes_all_standing", false], "falls": 0,
		"field": "dmg_bonus", "sign": 1, "ruled": 0.45,
		"words": "While a hero lies fallen, the rest deal\n%d%% more damage."},
}
# §2e — BR §1: the shared-word near-misses each name is known to have, compared as an
# EQUALITY (EK's `CLASH_EXEMPT` shape), so a new one reds.
const NEAR_MISSES := {
	"Empty Pulpit": [],
	# A live Hunter card, and a word of the name inside its own: it SHIPS and is
	# NAMED (BR §1's rule for a label collision; nothing resolves a rune by name).
	"Dead Air": ["ability:Deadfall"],
	"Dirge": [],
}

# §4 — Tithe's words as the designer ruled them (HP §4), the figure left out.
const TITHE_WORDS := "A hero's attack that lands Break heals\nwhoever among the four is lowest,\nfor %d%% of it."
# §4 — and the talent's over the same read site, narrowed the way Tithe's were (HQ §1;
# the wording PROPOSED), the figure left out, and the words it carried until HQ.
const TALENT_WORDS := "An attack that lands Break heals the lowest-health hero for %d%% of it."
const TALENT_WAS := "Every point of Break damage dealt"
# §1c — words a roll-call tail must not speak to a player (HQ §1): the developer's.
const DEV_WORDS := ["payload", "refus", "consumed", "field", "live door"]

# §6 — the comments that spoke Faith's threshold as a figure, by the phrase each
# carried (HO's census of five, and the seven more this batch's sweep found). The
# file and the phrase, never a line number.
const FAITH_STALE := [
	["scripts/unit.gd", "Faith (0-5). Allies release at 5"],
	["scripts/unit.gd", "releases still fire at five"],
	["scripts/battle.gd", "Faith\n# releases at 5, Pack Bond"],
	["scripts/battle.gd", "five of them RELEASE"],
	["scripts/battle.gd", "a peak that ratchets to five"],
	["scripts/battle.gd", "At 5 stacks the\n# ally is healed"],
	["scripts/battle.gd", "a release now always consumes all five"],
	["scripts/battle.gd", "`faith_stacks` is capped at 5 above"],
	["scripts/battle.gd", "THE DEVOUT'S OWN FAITH HOLDS AT FIVE"],
	["scripts/battle.gd", "`FAITH_RELEASE` is still 3"],
	["scripts/battle.gd", "The threshold at 3 is the honest half and it stays alone."],
	["scripts/battle.gd", "#   Faith          5 stacks — the release threshold."],
	["scripts/classes.gd", "`faith_stacks` caps\n\t\t# at five"],
]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("BATCH HP — THE CONDITION AS A FIGHT RUNS, AND THE THREE RUNES IT MAKES REAL")
	Engine.max_fps = 0
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_fresh_meta()
	_s1a_the_keys_and_the_doors()
	_s1b_the_fields()
	await _s1c_the_refusal()
	await _s1d_the_cycle()
	await _s1e_a_quit_fight_resumed()
	await _s1f_hold_core_is_read_as_the_fight_runs()
	_s1g_the_sheet()
	_s2a_the_entries()
	await _s2b_the_route()
	await _s2c_each_through_a_fall_and_a_revive()
	await _s2d_what_a_blow_pays()
	_s2e_the_words_say_while()
	_s2f_the_names()
	await _s3_fellowship()
	_s4_tithe()
	_s5_the_records()
	await _s6_the_small_things()
	Runes._load().erase(CREST_FX)
	ok(not Runes.ids().has(CREST_FX) and Runes.ids().has("dirge"),
		"§7: the fixture was left in the loaded table, or took a real entry with it")
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	_s7_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
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
	Profile.set_flag("skill_check_taught")
	Profile.set_flag("defensive_check_taught")
	Relics.save_path = SCRATCH_RELICS
	var f := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	f.store_string("[]")
	f.close()
	Relics.loaded = false
	Relics.unlocked = []
	Relics.load_data()


# A fresh run of `keys`, each awakened on the engine rune `engines` names for his
# seat, carrying `relics`.
func _new_run(keys: Array, engines: Array, relics: Array = []) -> void:
	_run.sim_run = false
	_run.new_run(keys, relics, "standard")
	for i in _run.party.size():
		if String(engines[i]) != "":
			_run.awaken(i, Runes.engine_rune_id(String(engines[i])))
		else:
			_run.party[i]["awakened"] = true
	_run.specs_chosen = true
	_run.active = true
	_run.rune_bag = []
	_run.pending_rune_drops = []
	_run.party_runes = []
	_run.items = {}


# The crest worn through the run's own door — the bag, then the function the bag
# panel's Equip button is bound to.
func _wear_crest(id: String) -> bool:
	_run.bag_rune(Runes.build(id))
	var rows: Array = _run.party_rune_rows()
	for i in rows.size():
		if String(rows[i]["src"]) == "bag" and String((rows[i]["rune"] as Dictionary).get("id", "")) == id:
			return bool(_run.toggle_party_rune(i))
	return false


# THE ONE DOOR EVERY DRIVE ENTERS BY: a party of the four on ENG4, `relics` carried;
# the fixture crest worn with `payload` when it is not empty; the authored crest rune
# `real` worn instead when it names one; hero `fallen` at 0 health; a Revive Potion in
# the pouch when `potion`. The real battle scene for the run in hand.
func _battle(payload: Dictionary, real := "", fallen := -1, relics: Array = [], potion := false) -> Node:
	var table: Dictionary = Runes._load()
	table[CREST_FX] = {"name": "HP Fixture Crest", "scope": "party", "price": 150,
		"desc": "A fixture of check_hp, never in the file.", "payload": payload}
	_new_run(SEATS, ENG4, relics)
	if not payload.is_empty():
		_wear_crest(CREST_FX)
	if real != "":
		_wear_crest(real)
	if fallen >= 0:
		_run.party[fallen]["hp"] = 0
	if potion:
		_run.items = {"revive": 1}
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene



# A constant of the battle script, read off the script's own map.
func _c(s: Node, name: String) -> String:
	return String((s.get_script() as Script).get_script_constant_map().get(name, "<no %s>" % name))

func _heroes(s: Node) -> Array:
	var out: Array = []
	for u in s.get("heroes"):
		if not (u as BattleUnit).is_companion:
			out.append(u)
	return out


func _foe(s: Node) -> BattleUnit:
	for e in s.get("enemies"):
		if not (e as BattleUnit).dead:
			return e
	return null


func _log_text(s: Node) -> String:
	var h: Variant = s.get("history")
	return String((h as RichTextLabel).get_parsed_text()) if h is RichTextLabel else ""


func _field_row(s: Node, field: String) -> Array:
	var out: Array = []
	for h in _heroes(s):
		out.append((h as BattleUnit).get(field))
	return out


# A hero falls THROUGH THE DAMAGE DOOR, as any blow fells him.
func _fell(s: Node, seat: int) -> BattleUnit:
	var u: BattleUnit = _heroes(s)[seat]
	u.take_hit(999999, 0)
	await process_frame
	return u


# A fallen hero rises THROUGH THE BATTLE'S OWN ITEM DOOR: the Revive Potion, used
# with him the one hero down, so no picker is asked.
func _revived(s: Node) -> void:
	s.set("item_used", false)
	s._use_item("revive")
	await process_frame


func _to(scene_path: String) -> Node:
	change_scene_to_file(scene_path)
	await Gate.frames(self, 6)
	return current_scene


func _is_battle(s: Node) -> bool:
	return s != null and s.get("battle_over") is bool


func _run_out(s: Node) -> Node:
	var guard := 0
	while _is_battle(s) and not bool(s.get("battle_over")) and guard < FRAME_CAP:
		Engine.time_scale = 100.0
		await process_frame
		guard += 1
	Engine.time_scale = 1.0
	await Gate.frames(self, 6)
	OS.set_environment("DOD_AUTOPLAY", "")
	return current_scene


func _figure(id: String) -> float:
	var st: Dictionary = (Runes.config(id).get("payload", {}) as Dictionary).get("stat", {})
	return float(st.get(String(THREE[id]["field"]), 0.0))


func _stale_line(text: String, needle: String) -> bool:
	return text.contains(needle)


# ── §1a — THE KEYS AND THE DOORS ────────────────────────────────────────────

func _s1a_the_keys_and_the_doors() -> void:
	print("\n§1a — the five keys read as the fight runs, and the two doors a hero's standing changes through")
	# THE RULING, AS THE TABLE: HP's four, and `heroes_hold_core` since HQ §1 (ruled) —
	# read once it went on paying after its only holder fell, stale for the reason the
	# other four were.
	var live: Array = Talents.LIVE_KEYS.duplicate()
	live.sort()
	ok(live == ["heroes_all_standing", "heroes_class_count", "heroes_hold_core", "heroes_include_class", "heroes_lack_class"],
		"§1a: the keys read as the fight runs are %s" % [live])
	ok(Talents.HERO_KEYS.has("heroes_hold_core") and Talents.LIVE_KEYS.has("heroes_hold_core"),
		"§1a: `heroes_hold_core` is read once, as the fight opens, or is no longer a key — HQ §1 ruled it live")
	# AND SO NO CONDITION ON WHO STANDS IS READ ONCE ANY MORE: every key the party is
	# asked by is a live key, and the spawn's half is a node or a card alone.
	var stale: Array = Talents.HERO_KEYS.filter(func(k): return not Talents.LIVE_KEYS.has(k))
	ok(not Talents.HERO_KEYS.is_empty() and stale.is_empty(),
		"§1a: %s asks who stands and is read once — a key that turns with a fall and is not re-read" % [stale])
	ok(Talents.is_live({"condition": {"heroes_lack_class": "mage"}, "stat": {"dmg_bonus": 0.1}})
			and Talents.is_live({"condition": {"heroes_hold_core": "pack"}, "stat": {"dmg_bonus": 0.1}})
			and not Talents.is_live({"condition": {"has_node": "tn_damage"}, "stat": {"max_hp": 9}})
			and not Talents.is_live({"stat": {"dmg_bonus": 0.1}}),
		"§1a: a payload is live, or not, on the wrong keys")
	ok(Talents.spawn_half({"heroes_hold_core": "pack", "has_node": "tn_damage"}) == {"has_node": "tn_damage"},
		"§1a: the spawn still weighs `heroes_hold_core` — its half is %s" % [
			Talents.spawn_half({"heroes_hold_core": "pack", "has_node": "tn_damage"})])
	# THE DOORS: `dead` is written in `_die()` and `revive()` and nowhere else in the
	# game's scripts, so the pair is every door a hero's standing changes through.
	var writers: Array = []
	var rx := RegEx.new()
	rx.compile("(?m)(^|[^A-Za-z0-9_])dead\\s*=[^=]")
	for f in DirAccess.get_files_at("res://scripts"):
		if not String(f).ends_with(".gd"):
			continue
		var code := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/" + String(f)))
		for m in rx.search_all(code):
			var line_at := code.rfind("\n", m.get_start()) + 1
			writers.append("%s: %s" % [f, code.substr(line_at, code.find("\n", m.get_start()) - line_at).strip_edges()])
	writers.sort()
	print("    CHECKED every script: `dead` is written at %s" % [writers])
	ok(writers == ["unit.gd: dead = false", "unit.gd: dead = true"],
		"§1a: `dead` is written somewhere but `_die()` and `revive()`: %s — a door the live read does not hear" % [writers])
	var us := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var die_at := us.find("func _die() -> void:")
	var rev_at := us.find("func revive(pct: float) -> void:")
	var die_body := us.substr(die_at, us.find("\nfunc ", die_at + 5) - die_at) if die_at >= 0 else ""
	var rev_body := us.substr(rev_at, us.find("\nfunc ", rev_at + 5) - rev_at) if rev_at >= 0 else ""
	ok(die_body.contains("died_cb.call(self)") and rev_body.contains("revived_cb.call(self)"),
		"§1a: `_die()` or `revive()` no longer calls the battle's door")
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bs.contains("u.died_cb = _on_unit_died") and bs.contains("u.revived_cb = _on_unit_revived"),
		"§1a: a spawned unit is not wired to both doors")
	var od_at := bs.find("func _on_unit_died(u: BattleUnit) -> void:")
	var od := bs.substr(od_at, bs.find("\nfunc ", od_at + 5) - od_at) if od_at >= 0 else ""
	var orv_at := bs.find("func _on_unit_revived(u: BattleUnit) -> void:")
	var orv := bs.substr(orv_at, bs.find("\nfunc ", orv_at + 5) - orv_at) if orv_at >= 0 else ""
	ok(od.contains("_reread_live(true)") and orv.contains("_reread_live(true)"),
		"§1a: a death or a revive does not re-read the live conditions")
	# A RESUMED FIGHT'S FALLEN ARE LAID DOWN THROUGH `_die()`, AND THE OPENING READ COMES
	# AFTER THEM: the lay-down is the opening, never a switch.
	var ld_at := bs.find("func _lay_down_the_fallen() -> void:")
	var ld := bs.substr(ld_at, bs.find("\nfunc ", ld_at + 5) - ld_at) if ld_at >= 0 else ""
	ok(ld.contains("u._die()"), "§1a: a resumed fight's fallen are no longer laid down through `_die()`")
	var open_at := bs.find("\t_lay_down_the_fallen()\n")
	ok(open_at >= 0 and bs.find("\t_open_live_payloads()\n", open_at) > open_at
			and bs.find("\t_open_live_payloads()\n", open_at) - open_at < 400,
		"§1a: the live payloads are not read right after the fallen are laid down")
	# THE SPAWN LEAVES A LIVE PAYLOAD TO THE DOOR, AND THE HERO SHEET DOES NOT.
	ok(bs.contains("\"party\": Run.party, Talents.LIVE_DOOR: true}"),
		"§1a: the battle spawn does not hand `LIVE_DOOR`, so it would stamp a live payload")
	# THE RE-READ HANDS EACH HERO'S SLOTTED ENGINES (HQ §1), off the unit's own `engines` —
	# the list the spawn built off `Runes.held_engines` of his member — or `heroes_hold_core`
	# reads no engine on anybody at every door. §1f drives what this reads.
	var lp_at := bs.find("func _live_party() -> Array:")
	var lp := bs.substr(lp_at, bs.find("\nfunc ", lp_at + 5) - lp_at) if lp_at >= 0 else ""
	ok(lp_at >= 0 and lp.contains("for pid in h.engines:") and lp.contains("\"engines\": held"),
		"§1a: the live re-read hands the heroes' standing without their engines")
	ok(bs.contains("engines = Runes.held_engines(Run.party[i])\n"),
		"§1a: a hero's `engines` are no longer `Runes.held_engines` of his member — the re-read and the spawn may disagree")
	ok(not Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/party_screen.gd")).contains("LIVE_DOOR"),
		"§1a: the hero sheet hands `LIVE_DOOR`, so it would show a live rune paying nothing at the opening")


# ── §1b — THE FIELDS A LIVE PAYLOAD MAY WRITE ───────────────────────────────

func _s1b_the_fields() -> void:
	print("\n§1b — the fields a live payload may write, derived over HN §3a's twenty-eight")
	var fresh: Array = []
	var twins: Array = []
	for f in Talents.LIVE_FIELDS:
		if TWINS.has(String(f)):
			twins.append(String(f))
		else:
			fresh.append(String(f))
	# The consumed list carries HN's party-wide stamps beside the eleven (its third group,
	# outside the twenty-eight); the partition is asked of the twenty-eight.
	var consumed: Array = []
	var stamps: Array = []
	for cf in Talents.CONSUMED_FIELDS:
		if STAMPS.has(String(cf)):
			stamps.append(String(cf))
		else:
			consumed.append(String(cf))
	var union: Array = fresh + consumed
	union.sort()
	var want: Array = HN_28.duplicate()
	want.sort()
	print("    read fresh (%d): %s" % [fresh.size(), fresh])
	print("    consumed (%d): %s" % [consumed.size(), consumed])
	print("    the rune twins summed with a fresh field (%d): %s" % [twins.size(), twins])
	print("    the party-wide stamps, refused beside them (%d): %s" % [stamps.size(), stamps])
	ok(stamps.size() == STAMPS.size(), "§1b: a party-wide stamp is not refused (%s of %s)" % [stamps, STAMPS])
	# THE PARTITION: every one of the twenty-eight is on exactly one list.
	ok(union == want and fresh.size() + consumed.size() == HN_28.size(),
		"§1b: the two lists are not a partition of HN's twenty-eight (%d + %d; %s)" % [fresh.size(), consumed.size(), union])
	for t in twins:
		ok(fresh.has(String(TWINS[t])), "§1b: `%s` is live but its node's `%s` is not" % [t, TWINS[t]])
	# EVERY FIELD ON EITHER LIST IS A FIELD THE UNIT DECLARES (a key the unit does not
	# declare is dropped in silence, HN §3a) — but `max_hp_pct`, which the spawn
	# consumes before the unit exists.
	var probe := BattleUnit.new()
	var declared := {}
	for p in probe.get_property_list():
		if int(p["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			declared[String(p["name"])] = true
	probe.free()
	var undeclared: Array = []
	for f2 in Talents.LIVE_FIELDS + consumed:
		if not declared.has(String(f2)) and String(f2) != "max_hp_pct":
			undeclared.append(String(f2))
	ok(undeclared.is_empty(), "§1b: %s is not declared on the unit" % [undeclared])
	# A LIVE FIELD IS WRITTEN BY NOTHING AFTER THE SPAWN. Swept over the battle and the
	# unit, comments stripped: an assignment to `.field` is a writer, and the spawn's
	# own hand-over from the config is the one allowed.
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	var us := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/unit.gd"))
	var written: Array = []
	for f3 in Talents.LIVE_FIELDS:
		var rx := RegEx.new()
		rx.compile("\\.%s\\s*(=[^=]|\\+=|-=|\\*=)" % String(f3))
		for src_pair in [["battle.gd", bs], ["unit.gd", us]]:
			for m in rx.search_all(String(src_pair[1])):
				var code: String = src_pair[1]
				var ls := code.rfind("\n", m.get_start()) + 1
				var line := code.substr(ls, code.find("\n", m.get_start()) - ls).strip_edges()
				if line == "u.%s = cfg.get(\"%s\", 0.0)" % [f3, f3]:
					continue
				written.append("%s: %s" % [src_pair[0], line])
	print("    CHECKED %d live fields for a writer after the spawn: %s" % [Talents.LIVE_FIELDS.size(), written])
	ok(written.is_empty(), "§1b: a field a live payload may write is written mid-fight: %s" % [written])
	# THE CONSUMED FIELDS' OWN REASONS, AT THE LINES THAT MAKE THEM: the summon copies,
	# the spawn scaling Attack after the payloads, Whetstone writing it, the Iron Will chip.
	var summon_at := bs.find("func _do_summon(")
	var summon := bs.substr(summon_at, bs.find("\nfunc ", summon_at + 5) - summon_at) if summon_at >= 0 else ""
	var not_copied: Array = []
	for f4 in SUMMON_COPIED:
		if not (summon.contains("\"%s\": hunter.%s" % [f4, f4]) or summon.contains("comp.%s = hunter.%s" % [f4, f4])):
			not_copied.append(String(f4))
		ok(consumed.has(String(f4)), "§1b: `%s` is copied into a companion and is not refused" % f4)
	ok(summon != "" and not_copied.is_empty(),
		"§1b: %s is no longer copied into a companion at the summon — its reason moved, re-derive it" % [not_copied])
	ok(bs.contains("attacker.attack += attacker.whetstone") and consumed.has("whetstone") and consumed.has("attack"),
		"§1b: Whetstone no longer writes Attack, or one of the two is live")
	ok(bs.contains("if u.iron_will_ranks > 0:\n\t\t\tu.add_status(\"iron_will\"") and consumed.has("iron_will_ranks"),
		"§1b: the Iron Will chip is no longer laid at the spawn, or the field is live")
	ok(bs.contains("cfg[\"attack\"] = int(round(int(cfg.get(\"attack\", 100))") and bs.contains("u.crit_bonus = maxf(u.crit_bonus - 0.05, -CRIT_CHANCE)"),
		"§1b: the spawn no longer scales Attack after the payloads, or the modifier no longer floors crit")


# ── §1c — THE REFUSAL ───────────────────────────────────────────────────────

func _s1c_the_refusal() -> void:
	print("\n§1c — a live payload on a consumed field is refused, loudly, wherever it would be paid")
	var refused := 0
	var consumed: Array = Talents.CONSUMED_FIELDS.keys()
	for f in consumed:
		var why := Talents.live_refusal({"stat": {String(f): 1}, "condition": {"heroes_lack_class": "mage"}})
		if why.contains(String(f)) and why.contains(String(Talents.CONSUMED_FIELDS[f]).substr(0, 12)):
			refused += 1
		else:
			print("      not refused, or not for its reason: %s -> '%s'" % [f, why])
	print("    CHECKED %d consumed fields: %d refused, each naming where it is consumed" % [consumed.size(), refused])
	ok(consumed.size() == 11 + STAMPS.size() and refused == consumed.size(),
		"§1c: %d of the %d consumed fields are refused for their reason" % [refused, consumed.size()])
	# THE OTHER SHAPES NO DOOR CAN TAKE BACK, AND AN UNKNOWN FIELD.
	var shapes := {
		"a card": {"condition": {"heroes_lack_class": "mage"}, "new_ability": {"display_name": "X"}},
		"an ability's figures": {"condition": {"heroes_lack_class": "mage"}, "ability": "Smite", "add": {"damage": 5}},
		"a nested also": {"stat": {"dmg_bonus": 0.1}, "also": [{"condition": {"heroes_lack_class": "mage"}, "stat": {"dmg_bonus": 0.1}}]},
		"an unread field": {"condition": {"heroes_lack_class": "mage"}, "stat": {"hp_no_such_field": 1}},
		"no stat": {"condition": {"heroes_lack_class": "mage"}},
	}
	for label in shapes:
		ok(Talents.live_refusal(shapes[label]) != "", "§1c: a live payload carrying %s is not refused" % label)
	# THE POSITIVE ARMS: every live field is accepted, and so is a spawn-only condition
	# on a consumed field (it is stamped once, as HL built it).
	var accepted := 0
	for f2 in Talents.LIVE_FIELDS:
		if Talents.live_refusal({"stat": {String(f2): 1}, "condition": {"heroes_all_standing": false}}) == "":
			accepted += 1
	ok(accepted == Talents.LIVE_FIELDS.size(), "§1c: %d of the %d live fields are accepted" % [accepted, Talents.LIVE_FIELDS.size()])
	# HQ §1 — `heroes_hold_core` IS LIVE, SO A PAYLOAD CARRYING IT REFUSES A CONSUMED FIELD,
	# as every live key's does; a condition read once (a node, a card) still takes one.
	ok(Talents.live_refusal({"stat": {"max_hp": 9}, "condition": {"heroes_hold_core": "pack"}}).contains("max_hp"),
		"§1c: a payload carrying `heroes_hold_core` on a consumed field is accepted — the key is read as the fight runs")
	ok(Talents.live_refusal({"stat": {"max_hp": 9}, "condition": {"has_node": "tn_damage"}}) == "",
		"§1c: a spawn-only condition on a consumed field is refused — it is stamped once and needs no door")
	# APPLY REFUSES, AND ADDS NOTHING (the hero sheet's route: no `LIVE_DOOR`).
	var cfg := {"abilities": [], "max_hp": 100}
	Talents.apply_payload(cfg, {"stat": {"max_hp": 9}, "condition": {"heroes_all_standing": true}}, 1,
		{"party": [{"key": "warrior", "hp": 10}]})
	ok(int(cfg["max_hp"]) == 100, "§1c: a refused payload was applied: maximum health %d" % int(cfg["max_hp"]))
	var cfg2 := {"abilities": [], "dmg_bonus": 0.0}
	Talents.apply_payload(cfg2, {"stat": {"dmg_bonus": 0.2}, "condition": {"heroes_all_standing": true}}, 1,
		{"party": [{"key": "warrior", "hp": 10}]})
	ok(is_equal_approx(float(cfg2["dmg_bonus"]), 0.2), "§1c: a live payload on a live field is not stamped where no door waits for it")
	var cfg3 := {"abilities": [], "dmg_bonus": 0.0}
	Talents.apply_payload(cfg3, {"stat": {"dmg_bonus": 0.2}, "condition": {"heroes_all_standing": true}}, 1,
		{"party": [{"key": "warrior", "hp": 10}], Talents.LIVE_DOOR: true})
	ok(is_equal_approx(float(cfg3["dmg_bonus"]), 0.0), "§1c: with `LIVE_DOOR` handed, the spawn still stamps a live payload")
	# AT A REAL SPAWN: the refused fixture pays nothing and the roll call says so.
	# (Each battle is read before the next is entered: entering one frees the last.)
	var s: Node = await _battle({"stat": {"max_hp": 9}, "condition": {"heroes_all_standing": false}}, "", 1)
	var with_hp: Array = _field_row(s, "max_hp")
	var roll: Array = (s.get("_rune_roll_call") as Array).duplicate()
	var refused_tail := _c(s, "LIVE_REFUSED_TAIL")
	var bare: Node = await _battle({}, "", 1)
	var bare_hp: Array = _field_row(bare, "max_hp")
	var paid := 0
	for i in mini(with_hp.size(), bare_hp.size()):
		if int(with_hp[i]) != int(bare_hp[i]):
			paid += 1
	var said := false
	for line in roll:
		if String(line).begins_with("the crest: HP Fixture Crest") and String(line).contains(refused_tail):
			said = true
	ok(with_hp.size() == 4 and paid == 0 and said,
		"§1c: a refused live payload paid on %d heroes at a real spawn, and the roll call %s" % [paid, "said so" if said else "did not say so"])
	# HQ §1 — AND WHAT THE ROLL CALL SAYS IS A PLAYER'S SENTENCE. The tail reaches the
	# combat log the player reads, so it carries none of the developer's words and keeps
	# the roll call's own close; why the entry is refused goes to `push_error`.
	var dev_said: Array = DEV_WORDS.filter(func(w): return refused_tail.to_lower().contains(String(w)))
	ok(refused_tail.ends_with("so it pays nothing this fight") and dev_said.is_empty(),
		"§1c: the refused tail reads '%s' — %s are not a player's words" % [refused_tail, dev_said])
	# THE ROUTE THAT MAKES IT ONE — the fact the rewording rests on, asserted so the day it
	# stops holding the reason is seen to go: a refused entry stays in the loaded table
	# (`Runes._load` reports it and keeps it) and a roll offers it like any other.
	var refused_fx := "hp_fixture_refused"
	Runes._load()[refused_fx] = {"name": "HP Fixture Refused", "scope": "party", "price": 150,
		"desc": "A fixture of check_hp, never in the file.",
		"payload": {"stat": {"max_hp": 9}, "condition": {"heroes_all_standing": false}}}
	_new_run(SEATS, ENG4)
	var rolled: bool = Runes.eligible_ids(_run.party[0], []).has(refused_fx)
	Runes._load().erase(refused_fx)
	ok(rolled and not Runes.ids().has(refused_fx),
		"§1c: a refused entry is not offered by the roll (%s) — the route the player's tail answers is gone, re-read HQ §1" % rolled)
	# THE FILE HOLDS NONE, AND THE TABLE ASKS THE ONE DOOR AS IT LOADS.
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var bad: Array = []
	var live_n := 0
	for id in data:
		var pay: Dictionary = (data[id] as Dictionary).get("payload", {})
		if Talents.live_refusal(pay) != "":
			bad.append(String(id))
		if Talents.is_live(pay):
			live_n += 1
	print("    CHECKED %d entries: %d carry a live condition, %d refused" % [data.size(), live_n, bad.size()])
	ok(data.size() > 100 and live_n >= 3 and bad.is_empty(), "§1c: the file holds refused payloads: %s" % [bad])
	var rs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/runes.gd"))
	var load_at := rs.find("static func _load() -> Dictionary:")
	var load_body := rs.substr(load_at, rs.find("\nstatic func ", load_at + 5) - load_at) if load_at >= 0 else ""
	ok(load_body.contains("Talents.live_refusal(") and load_body.contains("push_error("),
		"§1c: the table no longer refuses a payload as it loads")


# ── §1d — THE CYCLE ─────────────────────────────────────────────────────────

func _s1d_the_cycle() -> void:
	print("\n§1d — a full cycle: pays, a hero falls, stops, he is revived, pays again — on a base a subtraction would drift from")
	var add := 0.25
	var pay := {"stat": {"dmg_bonus": add}, "condition": {"heroes_all_standing": false}}
	var s: Node = await _battle(pay, "", -1, [BASE_RELIC], true)
	var hs: Array = _heroes(s)
	var base: Array = _field_row(s, "dmg_bonus")
	var relic_base := float(Relics.POOL[BASE_RELIC]["hooks"]["hero_attack_mult"])
	# THE BASE IS THE RELIC'S, SO A SUBTRACTION HAS SOMETHING TO DRIFT FROM.
	ok(hs.size() == 4 and base.all(func(v): return is_equal_approx(float(v), relic_base)) and relic_base > 0.0,
		"§1d: the heroes open at dmg_bonus %s, not the relic's %.2f" % [base, relic_base])
	var roll: Array = s.get("_rune_roll_call")
	var opened_off := false
	for line in roll:
		if String(line).begins_with("the crest: HP Fixture Crest") and String(line).ends_with(_c(s, "CONDITION_UNMET_LIVE_TAIL")):
			opened_off = true
	ok(opened_off, "§1d: the roll call does not say the live crest pays nothing until its condition holds (%s)" % [roll])
	# A HERO FALLS THROUGH THE DAMAGE DOOR: IT PAYS, ON ALL FOUR.
	var mage := await _fell(s, 1)
	var on: Array = _field_row(s, "dmg_bonus")
	var paid := 0
	for i in on.size():
		if is_equal_approx(float(on[i]), float(base[i]) + add):
			paid += 1
	var log1 := _log_text(s)
	ok(mage.dead and paid == 4, "§1d: with the Mage down it paid on %d of the four (%s)" % [paid, on])
	ok(log1.count("Rune: the crest: HP Fixture Crest — %s" % _c(s, "LIVE_ON_TAIL")) == 1,
		"§1d: the switch ON is not in the log once")
	# HE RISES THROUGH THE REVIVE POTION: IT STOPS, AND THE FIGURE IS THE BASE BIT FOR BIT.
	await _revived(s)
	var off: Array = _field_row(s, "dmg_bonus")
	var exact := off.size() == base.size()
	for i2 in off.size():
		if float(off[i2]) != float(base[i2]):
			exact = false
	var naive := relic_base + add - add
	print("    open %s; the Mage down %s; revived %s — a subtraction would have left %s" % [
		base, on, off, var_to_str(naive)])
	ok(not mage.dead and exact, "§1d: revived, the heroes read %s — not the base %s exactly" % [off, base])
	ok(_log_text(s).count("Rune: the crest: HP Fixture Crest — %s" % _c(s, "LIVE_OFF_TAIL")) == 1,
		"§1d: the switch OFF is not in the log once")
	# THE CONTROL THAT MAKES "EXACTLY" MEAN SOMETHING: on this base a subtraction drifts.
	ok(naive != relic_base, "§1d: on this base a subtraction returns the base exactly — the arm above proves nothing")
	# AND IT PAYS AGAIN, THE SAME BITS.
	await _fell(s, 1)
	var again: Array = _field_row(s, "dmg_bonus")
	var same := again.size() == on.size()
	for i3 in again.size():
		if float(again[i3]) != float(on[i3]):
			same = false
	ok(same, "§1d: the second fall paid %s, not the first fall's %s" % [again, on])
	ok(_log_text(s).count("Rune: the crest: HP Fixture Crest — %s" % _c(s, "LIVE_ON_TAIL")) == 2,
		"§1d: the second switch ON is not in the log")


# ── §1e — A FIGHT QUIT AFTER A FALL, AND RESUMED ────────────────────────────

func _s1e_a_quit_fight_resumed() -> void:
	print("\n§1e — a fight quit after a hero fell and resumed: the live read agrees with the opening")
	var add := 0.25
	var pay := {"stat": {"dmg_bonus": add}, "condition": {"heroes_all_standing": false}}
	var s: Node = await _battle(pay)
	await _fell(s, 1)
	ok(int(_run.party[1]["hp"]) == 0, "§1e: the Mage's fall did not reach the run")
	ok(_run.load_run(), "§1e: the save the fall wrote did not load")
	var back := String(_run.resume_scene())
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	var s2 := await _to(back)
	await Gate.frames(self, 8)
	ok(_is_battle(s2), "§1e: the resume opened %s, not the fight" % back)
	if not _is_battle(s2):
		return
	var down := 0
	var paid := 0
	for u in _heroes(s2):
		if (u as BattleUnit).dead:
			down += 1
		if is_equal_approx(float((u as BattleUnit).dmg_bonus), add):
			paid += 1
	var roll: Array = s2.get("_rune_roll_call")
	var tailed := false
	for line in roll:
		if String(line).begins_with("the crest: HP Fixture Crest") and String(line).contains(" — "):
			tailed = true
	var text := _log_text(s2)
	print("    resumed: %d down, the live crest paid on %d; the roll call %s" % [down, paid, roll])
	ok(down == 1 and paid == 4, "§1e: the resumed fight opened with %d down and paid on %d" % [down, paid])
	ok(not tailed, "§1e: the roll call says the crest pays nothing at the opening of a fight it pays from")
	ok(not text.contains(_c(s2, "LIVE_ON_TAIL")), "§1e: the lay-down of the fallen was logged as a switch")


# ── §1f — `heroes_hold_core` IS READ AS THE FIGHT RUNS (HQ §1) ──────────────
#
# **HP RULED IT READ ONCE AND PRINTED WHAT THAT LEFT OUT; HQ RULED IT LIVE, AND THE
# PRINT IS AN ASSERTION NOW.** Nothing in the battle writes an engine's slot (GM §2 —
# still swept below), but the key counts the heroes who STAND, so read once it went on
# paying after its only holder fell. Driven as a cycle on the relic's base, through
# the real doors: the Hunter — the one Pack Bond holder in `ENG4` — falls through the
# damage door and the key turns; he rises through the battle's own Revive Potion and
# it turns back; the figure returns to the base bit for bit (`==`), as §1d's does.

func _s1f_hold_core_is_read_as_the_fight_runs() -> void:
	print("\n§1f — `heroes_hold_core` is read as the fight runs: its holder falls, it turns; he rises, it turns back")
	# THE KEY ITSELF, BOTH WAYS — the line HP printed, and its positive arm.
	var holder := {"key": "hunter", "hp": 10,
		"engines": [{"id": Runes.engine_rune_id("pack"), "engine": "pack", "equipped": true}]}
	var down: Dictionary = holder.duplicate(true)
	down["hp"] = 0
	var warrior := {"key": "warrior", "hp": 10, "engines": []}
	var up_reads := Talents.party_condition_met({"heroes_hold_core": "pack"}, [warrior, holder])
	var down_reads := Talents.party_condition_met({"heroes_hold_core": "pack"}, [warrior, down])
	print("    the key, asked of a party whose only Pack Bond holder stands: %s; is down: %s" % [up_reads, down_reads])
	ok(up_reads and not down_reads,
		"§1f: the key reads %s with its only holder standing and %s with him down" % [up_reads, down_reads])
	# THE CYCLE. The bare battle first, for the base each hero opens at.
	var add := 0.25
	var pay := {"stat": {"dmg_bonus": add}, "condition": {"heroes_hold_core": "pack"}}
	var bare: Node = await _battle({}, "", -1, [BASE_RELIC])
	var base: Array = _field_row(bare, "dmg_bonus")
	var s: Node = await _battle(pay, "", -1, [BASE_RELIC], true)
	var hunter: BattleUnit = _heroes(s)[3]
	ok(hunter.has_engine("pack") and not (_heroes(s)[0] as BattleUnit).has_engine("pack"),
		"§1f: the Hunter is not the one Pack Bond holder this drive is built on")
	var open: Array = _field_row(s, "dmg_bonus")
	var opened_on := 0
	for i in open.size():
		if i < base.size() and is_equal_approx(float(open[i]), float(base[i]) + add):
			opened_on += 1
	var roll: Array = s.get("_rune_roll_call")
	var untailed := false
	for line in roll:
		if String(line) == "the crest: HP Fixture Crest":
			untailed = true
	ok(base.size() == 4 and opened_on == 4 and untailed,
		"§1f: with its holder standing the crest opened paying on %d of the four (%s against %s), the roll call %s" % [
			opened_on, open, base, roll])
	# THE HOLDER FALLS: IT STOPS ON ALL FOUR, AND THE FIGURE IS THE BASE BIT FOR BIT.
	await _fell(s, 3)
	var off: Array = _field_row(s, "dmg_bonus")
	var exact := off.size() == base.size()
	for i2 in off.size():
		if i2 >= base.size() or float(off[i2]) != float(base[i2]):
			exact = false
	var naive := float(base[0]) + add - add if not base.is_empty() else 0.0
	print("    open %s; the Hunter down %s (base %s — a subtraction would have left %s)" % [
		open, off, base, var_to_str(naive)])
	ok(hunter.dead and exact, "§1f: with Pack Bond's only holder down the heroes read %s — not the base %s exactly" % [off, base])
	ok(_log_text(s).count("Rune: the crest: HP Fixture Crest — %s" % _c(s, "LIVE_OFF_TAIL")) == 1,
		"§1f: the switch OFF is not in the log once")
	# HE RISES: IT PAYS AGAIN, THE SAME BITS IT OPENED WITH.
	await _revived(s)
	var again: Array = _field_row(s, "dmg_bonus")
	var same := again.size() == open.size()
	for i3 in again.size():
		if float(again[i3]) != float(open[i3]):
			same = false
	ok(not hunter.dead and same, "§1f: the Hunter raised, the heroes read %s, not the %s they opened with" % [again, open])
	ok(_log_text(s).count("Rune: the crest: HP Fixture Crest — %s" % _c(s, "LIVE_ON_TAIL")) == 1,
		"§1f: the switch ON is not in the log once")
	# A FALL THAT IS NOT THE HOLDER'S SWITCHES NOTHING — its own fight, so the pouch's one
	# potion above is never asked to choose between two fallen.
	var s3: Node = await _battle(pay, "", -1, [BASE_RELIC])
	var paid3: Array = _field_row(s3, "dmg_bonus")
	await _fell(s3, 1)
	ok(_field_row(s3, "dmg_bonus") == paid3 and not _log_text(s3).contains(_c(s3, "LIVE_OFF_TAIL")),
		"§1f: the Mage fell and the crest stopped paying — he holds no Pack Bond")
	# THE NEGATIVE OPENING: a party whose Hunter holds no Pack Bond opens with it not paying,
	# against the same party bare, and the roll call says it waits.
	var no_pack := ["bloodrage", "overburn", "mercy", "lethal_aim"]
	var bare2: Node = await _battle_on({}, no_pack)
	var bare2_row: Array = _field_row(bare2, "dmg_bonus")
	var s2: Node = await _battle_on(pay, no_pack)
	var unpaid: Array = _field_row(s2, "dmg_bonus")
	var told := false
	for line2 in s2.get("_rune_roll_call"):
		if String(line2) == "the crest: HP Fixture Crest — %s" % _c(s2, "CONDITION_UNMET_LIVE_TAIL"):
			told = true
	ok(bare2_row.size() == 4 and unpaid == bare2_row and told,
		"§1f: with no Pack Bond held the crest opened paying %s against %s bare, or the roll call did not say it waits" % [
			unpaid, bare2_row])
	# NOTHING IN THE BATTLE WRITES AN ENGINE'S SLOT (GM §2) — the premise both rulings rest on.
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(not bs.contains("[\"equipped\"] = ") and not bs.contains("toggle_engine("),
		"§1f: the battle writes an engine's slot — `heroes_hold_core` can change inside a fight")


# `_battle`'s door with the four seated on `engines` rather than `ENG4`, no relic; the
# fixture crest worn only when `payload` is not empty.
func _battle_on(payload: Dictionary, engines: Array) -> Node:
	var table: Dictionary = Runes._load()
	table[CREST_FX] = {"name": "HP Fixture Crest", "scope": "party", "price": 150,
		"desc": "A fixture of check_hp, never in the file.", "payload": payload}
	_new_run(SEATS, engines)
	if not payload.is_empty():
		_wear_crest(CREST_FX)
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	return current_scene


# ── §1g — THE HERO SHEET SHOWS WHAT THE OPENING PAYS ─────────────────────────

func _s1g_the_sheet() -> void:
	print("\n§1g — the hero sheet stamps a live payload as the opening would")
	var ps := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/party_screen.gd"))
	ok(ps.contains("var pay_ctx := {\"learned\": member.get(\"talents\", {}), \"member\": member, \"party\": Run.party}")
			and ps.contains("Talents.apply_payload(cfg, (pr as Dictionary).get(\"payload\", {}), 1, pay_ctx)"),
		"§1g: the hero sheet no longer stamps the crest with the four in its ctx")
	# THE SAME DOOR, BOTH WAYS: with all four standing Dirge's condition does not hold,
	# and with the Mage down it does.
	var pay: Dictionary = Runes.config("dirge").get("payload", {})
	var standing := [{"key": "warrior", "hp": 10}, {"key": "mage", "hp": 10}, {"key": "cleric", "hp": 10}, {"key": "hunter", "hp": 10}]
	var down := standing.duplicate(true)
	down[1]["hp"] = 0
	var c1 := {"abilities": [], "dmg_bonus": 0.0}
	var c2 := {"abilities": [], "dmg_bonus": 0.0}
	Talents.apply_payload(c1, pay, 1, {"party": standing})
	Talents.apply_payload(c2, pay, 1, {"party": down})
	ok(float(c1["dmg_bonus"]) == 0.0 and float(c2["dmg_bonus"]) > 0.0,
		"§1g: the sheet's door reads Dirge %s standing and %s with the Mage down" % [c1["dmg_bonus"], c2["dmg_bonus"]])


# ── §2a — THE THREE ENTRIES ─────────────────────────────────────────────────

func _s2a_the_entries() -> void:
	print("\n§2a — the three crest runes, as the file holds them")
	for id in THREE:
		var row: Dictionary = THREE[id]
		var cfg: Dictionary = Runes.config(id)
		var pay: Dictionary = cfg.get("payload", {})
		var cond: Dictionary = pay.get("condition", {})
		var fig := _figure(id)
		var pct := int(round(absf(fig) * 100.0))
		print("    %s: %s %s%d%% while %s" % [cfg.get("name", ""), row["field"], "-" if fig < 0 else "+", pct, cond])
		ok(String(cfg.get("name", "")) == String(row["name"]) and String(cfg.get("scope", "")) == "party"
				and int(cfg.get("price", 0)) == 150 and not cfg.has("retired") and not cfg.has("written_for"),
			"§2a: `%s` is not the bare-named crest rune at the flat price (%s)" % [id, cfg])
		ok(cond.size() == 1 and cond.has(String(row["key"][0])) and cond[String(row["key"][0])] == row["key"][1],
			"§2a: `%s` carries %s, not the ruled condition" % [id, cond])
		ok(pay.size() == 2 and (pay.get("stat", {}) as Dictionary).size() == 1 and fig * float(row["sign"]) > 0.0,
			"§2a: `%s` writes %s" % [id, pay.get("stat", {})])
		# THE FIGURE THE DESIGNER RULED (HQ §1) — exact, because the entry is the ruling.
		ok(fig == float(row["ruled"]),
			"§2a: `%s` writes %s %s — the designer ruled %s" % [id, row["field"], str(fig), str(row["ruled"])])
		ok(Talents.is_live(pay) and Talents.live_refusal(pay) == "", "§2a: `%s` is not a live payload the door accepts" % id)
		# THE WORDS ARE THE RULED SENTENCE AT THE ENTRY'S OWN FIGURE, broken under 44.
		ok(String(cfg.get("desc", "")) == String(row["words"]) % pct, "§2a: `%s` reads '%s'" % [id, cfg.get("desc", "")])
		var longest := 0
		for ln in String(cfg.get("desc", "")).split("\n"):
			longest = maxi(longest, String(ln).length())
		ok(longest <= 44, "§2a: a line of `%s`'s words is %d characters" % [id, longest])
		# HQ §2 — A STAT, AND CONDITIONAL NAMES ITS GATE.
		ok(not Runes.rune_tags(id).is_empty() and Runes.rune_shape(id) == ["STAT", "CONDITIONAL"],
			"§2a: `%s` has no tag row, or its shape is %s, not [STAT, CONDITIONAL]" % [id, Runes.rune_shape(id)])


# ── §2b — OFFERED, TAKEN, WORN: THE REAL ROUTE ──────────────────────────────

func _offerable_now() -> Array:
	var out: Array = []
	var held: Array = _run.party_rune_names()
	for m in _run.party:
		for id in Runes.eligible_ids(m, Runes.owned_names(m, held)):
			if not out.has(String(id)):
				out.append(String(id))
	return out


func _s2b_the_route() -> void:
	print("\n§2b — each offered through every roll, dropped after a real fight, and worn through the bag's door")
	_new_run(SEATS, ENG4)
	# THE SCOPE AT EVERY ROLL: each is in every hero's pool.
	var missing: Array = []
	for m in _run.party:
		var pool: Array = Runes.eligible_ids(m, [])
		for id in THREE:
			if not pool.has(String(id)):
				missing.append("%s for a %s" % [id, (m as Dictionary)["key"]])
	ok(missing.is_empty(), "§2b: the roll does not offer %s" % [missing])
	for id2 in THREE:
		# THE DROP AFTER A REAL NORMAL FIGHT, with the pool parked to this one rune.
		_new_run(SEATS, ENG4)
		for oid in _offerable_now():
			if String(oid) != String(id2):
				_run.pending_rune_drops.append(Runes.build(String(oid)))
		OS.set_environment("DOD_AUTOPLAY", "1")
		OS.set_environment("DOD_ENEMIES_OFF", "1")
		_run.encounter = {"type": "fight", "enemies": _run.compose("fight")}
		Gate.enter_battle(self, _run.encounter)
		await Gate.frames(self, 4)
		var s: Node = await _run_out(current_scene)
		var bagged := false
		for r in _run.rune_bag:
			if String((r as Dictionary).get("id", "")) == String(id2):
				bagged = true
		_run.pending_rune_drops = []
		ok(_is_battle(s) and bool(s.get("battle_over")) and bagged,
			"§2b: a won normal fight did not drop `%s` into the bag" % id2)
		# WORN THROUGH THE BAG'S OWN DOOR: its row, and the function its Equip calls.
		var rows: Array = _run.party_rune_rows()
		var at := -1
		for i in rows.size():
			if String(rows[i]["src"]) == "bag" and String((rows[i]["rune"] as Dictionary).get("id", "")) == String(id2):
				at = i
		ok(at >= 0 and bool(_run.toggle_party_rune(at)), "§2b: `%s` could not be worn in the crest from the bag" % id2)
		var worn := ""
		for pr in _run.party_runes:
			if bool((pr as Dictionary).get("equipped", false)):
				worn = String((pr as Dictionary).get("id", ""))
		ok(worn == String(id2), "§2b: the crest holds `%s`, not `%s`" % [worn, id2])


# ── §2c — EACH THROUGH A REAL FIGHT: ITS HERO FALLS, AND IS REVIVED ─────────

func _s2c_each_through_a_fall_and_a_revive() -> void:
	print("\n§2c — each rune through a real fight in which its hero falls and is revived")
	for id in THREE:
		var row: Dictionary = THREE[id]
		var field := String(row["field"])
		var fig := _figure(id)
		var s: Node = await _battle({}, String(id), -1, [BASE_RELIC], true)
		var base: Array = _field_row(s, field)
		var roll: Array = s.get("_rune_roll_call")
		var told := false
		for line in roll:
			if String(line) == "the crest: %s — %s" % [row["name"], _c(s, "CONDITION_UNMET_LIVE_TAIL")]:
				told = true
		await _fell(s, int(row["falls"]))
		var on: Array = _field_row(s, field)
		var paid := 0
		for i in on.size():
			if is_equal_approx(float(on[i]), float(base[i]) + fig):
				paid += 1
		await _revived(s)
		var off: Array = _field_row(s, field)
		var text := _log_text(s)
		print("    %s: open %s, its hero down %s, revived %s" % [row["name"], base, on, off])
		ok(told, "§2c: %s's roll call does not say it pays nothing until its condition holds" % row["name"])
		ok(paid == 4, "§2c: with its hero down %s paid on %d of the four" % [row["name"], paid])
		ok(off == base, "§2c: revived, %s left %s where the heroes opened at %s" % [row["name"], off, base])
		ok(text.contains("Rune: the crest: %s — %s" % [row["name"], _c(s, "LIVE_ON_TAIL")])
				and text.contains("Rune: the crest: %s — %s" % [row["name"], _c(s, "LIVE_OFF_TAIL")]),
			"§2c: %s's switch is not in the log both ways" % row["name"])
		# THE NEGATIVE ARM: a fall that is not its condition's switches nothing (Dirge
		# answers every fall, so it is the one without one).
		if String(row["key"][0]) == "heroes_lack_class":
			var s2: Node = await _battle({}, String(id), -1, [BASE_RELIC], true)
			var b2: Array = _field_row(s2, field)
			var other := 0 if int(row["falls"]) != 0 else 3
			await _fell(s2, other)
			ok(_field_row(s2, field) == b2 and not _log_text(s2).contains(_c(s2, "LIVE_ON_TAIL")),
				"§2c: %s paid when the %s fell" % [row["name"], SEATS[other]])


# ── §2d — WHAT A BLOW PAYS ──────────────────────────────────────────────────

# One seeded basic of `atk` on foe `fi` — a fresh one for each blow, so nothing the
# first blow laid is read by the second; returns the health it took.
func _blow_dealt(s: Node, atk: BattleUnit, sd: int, fi: int) -> int:
	var foe: BattleUnit = s.get("enemies")[fi]
	foe.hp = foe.max_hp
	foe.pressure = 0
	foe.broken = false
	atk.cooldowns.clear()
	atk.no_cover = 1
	var was := foe.hp
	seed(sd)
	await s._resolve(atk, atk.abilities[0], foe, "good")
	return was - foe.hp


# One seeded basic of the first foe on `tgt`; returns the health it took.
func _blow_taken(s: Node, tgt: BattleUnit, sd: int) -> int:
	var foe := _foe(s)
	tgt.hp = tgt.max_hp
	tgt.block_chance = -10.0
	var was := tgt.hp
	seed(sd)
	await s._resolve(foe, foe.abilities[0], tgt, "good")
	return was - tgt.hp


func _s2d_what_a_blow_pays() -> void:
	print("\n§2d — what a blow pays while each holds")
	# DIRGE: the Warrior's seeded basic, the Hunter up and then down.
	var s: Node = await _battle({}, "dirge")
	var war: BattleUnit = _heroes(s)[0]
	var before := await _blow_dealt(s, war, 7101, 0)
	await _fell(s, 3)
	var after := await _blow_dealt(s, war, 7101, 1)
	var want := float(before) * (1.0 + _figure("dirge"))
	print("    Dirge: the Warrior's basic took %d with all standing and %d with the Hunter down (want about %.1f)" % [before, after, want])
	ok(before > 0 and absf(float(after) - want) <= 2.0, "§2d: Dirge's blow took %d, not about %.1f" % [after, want])
	# EMPTY PULPIT: a foe's seeded blow on the Warrior, the Cleric up and then down.
	var p: Node = await _battle({}, "empty_pulpit")
	var w2: BattleUnit = _heroes(p)[0]
	var t_before := await _blow_taken(p, w2, 7102)
	await _fell(p, 2)
	var t_after := await _blow_taken(p, w2, 7102)
	var t_want := float(t_before) * (1.0 + _figure("empty_pulpit"))
	print("    Empty Pulpit: a foe's blow on the Warrior took %d with the Cleric up and %d with him down (want about %.1f)" % [t_before, t_after, t_want])
	ok(t_before > 0 and absf(float(t_after) - t_want) <= 2.0, "§2d: Empty Pulpit's blow took %d, not about %.1f" % [t_after, t_want])


# ── §2e — THE WORDS SAY WHILE ───────────────────────────────────────────────

func _s2e_the_words_say_while() -> void:
	print("\n§2e — a rune that reads who stands says when it reads it")
	# HO §2's rule, re-pointed by the continuous read: a condition read as the fight
	# runs says WHILE; one read at the opening says so. **SINCE HQ §1 EVERY KEY ON WHO
	# STANDS IS READ AS THE FIGHT RUNS** (§1a asserts no hero key is left out of
	# `LIVE_KEYS`), so the second half has no population: the arm that asked a
	# `heroes_hold_core` rune for *as the fight opens* is gone with the key's read-once,
	# and such a rune now owes *while* like the rest.
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var live_n := 0
	var unsaid: Array = []
	for id in data:
		var e: Dictionary = data[id]
		var pay: Dictionary = e.get("payload", {})
		var words := String(e.get("desc", "")).to_lower()
		if Talents.is_live(pay):
			live_n += 1
			if not words.begins_with("while "):
				unsaid.append(String(id))
	print("    CHECKED %d runes read as the fight runs" % live_n)
	ok(live_n >= 3 and unsaid.is_empty(), "§2e: %s read who stands and do not say when" % [unsaid])


# ── §2f — BR §1: THE THREE NAMES ────────────────────────────────────────────

func _s2f_the_names() -> void:
	print("\n§2f — the three names, swept against every name the game holds")
	var pop: Array = []
	for id in Runes.ids():
		if String(id) == CREST_FX:
			continue
		pop.append(["rune", Runes.display_name(Runes.config(String(id)))])
		var lane := String(Runes.config(String(id)).get("lane", ""))
		if lane != "" and not pop.has(["lane", lane]):
			pop.append(["lane", lane])
	for t in Runes.TEMPLATES:
		pop.append(["template", "Rune of %s" % String(t["noun"])])
	for ab in Classes.ability_corpus():
		pop.append(["ability", (ab as Ability).display_name])
	for n in Talents.tree():
		pop.append(["node", String((n as Dictionary).get("name", ""))])
	var foes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/enemies.json"))
	for kind in foes:
		pop.append(["enemy", String((foes[kind] as Dictionary).get("unit_name", ""))])
		for fa in (foes[kind] as Dictionary).get("abilities", []):
			var fan := String((fa as Dictionary).get("display_name", ""))
			if not pop.has(["enemy ability", fan]):
				pop.append(["enemy ability", fan])
	for ge in JSON.parse_string(FileAccess.get_file_as_string("res://data/glossary.json")):
		pop.append(["glossary", String((ge as Dictionary).get("term", ""))])
	for item_id in _run.ITEM_INFO:
		pop.append(["item", String((_run.ITEM_INFO[item_id] as Array)[0])])
	for relic_id in Relics.POOL:
		pop.append(["relic", String((Relics.POOL[relic_id] as Dictionary).get("name", ""))])
		pop.append(["relic id", String(relic_id)])
	var statuses: Dictionary = (load("res://scripts/battle.gd") as Script).get_script_constant_map().get("STATUS_INFO", {})
	for sid in statuses:
		pop.append(["status", String((statuses[sid] as Array)[0])])
		pop.append(["status id", String(sid)])
	for tag in Classes.TAG_ORDER:
		pop.append(["tag", String(tag)])
	var kinds := {}
	for row0 in pop:
		kinds[String(row0[0])] = int(kinds.get(String(row0[0]), 0)) + 1
	print("    CHECKED %d names in %d populations: %s" % [pop.size(), kinds.size(), kinds])
	ok(pop.size() > 900 and kinds.size() == 14 and kinds.values().all(func(c): return int(c) > 0),
		"§2f: the sweep read %d names in %d populations (%s) — not the game's" % [pop.size(), kinds.size(), kinds])
	for want in NEAR_MISSES:
		var low := String(want).to_lower()
		var exact: Array = []
		var near: Array = []
		for row in pop:
			var nm := String(row[1])
			var nl := nm.to_lower()
			var is_id := String(row[0]).ends_with(" id")
			var tag_row := "%s:%s" % [row[0], nm]
			if nl == low and not is_id:
				exact.append(tag_row)
			elif nl == low or _near_name(low, nl.replace("_", " ")):
				if not near.has(tag_row):
					near.append(tag_row)
		near.sort()
		print("    %s: exact %s; near %s" % [want, exact, near])
		ok(exact == ["rune:%s" % want], "§2f: '%s' is the name of %s" % [want, exact])
		var known: Array = (NEAR_MISSES[want] as Array).duplicate()
		known.sort()
		ok(near == known, "§2f: '%s' near-misses %s — the named set is %s" % [want, near, known])


# A NEAR-MISS, WORD BY WORD — `check_ho` §5e's reading (BR §1): two names are near
# when a word of four letters or more in one is a word of the other, sits inside it,
# or shares its stem.
func _near_name(a: String, b: String) -> bool:
	for wa in _words(a):
		for wb in _words(b):
			if wa == wb or wa.contains(wb) or wb.contains(wa):
				return true
			var n := 0
			while n < mini(wa.length(), wb.length()) and wa[n] == wb[n]:
				n += 1
			if n >= maxi(4, mini(wa.length(), wb.length()) - 1) or n >= 5:
				return true
	return false


func _words(text: String) -> Array:
	var out: Array = []
	var cur := ""
	for ch in text + " ":
		if (ch >= "a" and ch <= "z") or (ch >= "0" and ch <= "9"):
			cur += ch
		else:
			if cur.length() >= 4:
				out.append(cur)
			cur = ""
	return out


# ── §3 — FELLOWSHIP IS RETIRED ──────────────────────────────────────────────

func _s3_fellowship() -> void:
	print("\n§3 — Fellowship is retired: kept, said to be kept, offered by nobody")
	var cfg: Dictionary = Runes.config("fellowship")
	var why := String(cfg.get("retired", ""))
	ok(why.contains("BATCH HP") and why.contains("LOST:") and why.contains("rune_field_medic"),
		"§3: Fellowship's retirement string names no batch, no loss, or not the read site it keeps: '%s'" % why)
	ok(String(cfg.get("scope", "")) == "party" and Runes.rune_shape("fellowship") == ["PASSIVE"]
			and ((cfg.get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).has("rune_field_medic"),
		"§3: the retired entry lost its scope, its shape row or its payload (ET: kept)")
	# OFFERED BY NO DOOR — and Tithe, beside it, still is.
	_new_run(SEATS, ENG4)
	var offered := 0
	var tithe := 0
	for m in _run.party:
		var pool: Array = Runes.eligible_ids(m, [])
		if pool.has("fellowship"):
			offered += 1
		if pool.has("tithe"):
			tithe += 1
	ok(offered == 0 and tithe == 4, "§3: Fellowship is offered to %d heroes (Tithe to %d)" % [offered, tithe])
	# A SAVE WEARING IT LOADS, AND IT IS STILL WORN AND STILL RESOLVES (ET's contract).
	_new_run(SEATS, ENG4)
	var rune: Dictionary = Runes.build("fellowship")
	rune["equipped"] = true
	_run.party_runes = [rune]
	_run.save_run()
	_run.party_runes = []
	ok(_run.load_run(), "§3: a save wearing Fellowship did not load")
	var worn := ""
	for pr in _run.party_runes:
		if bool((pr as Dictionary).get("equipped", false)):
			worn = String((pr as Dictionary).get("id", ""))
	ok(worn == "fellowship", "§3: a save wearing Fellowship loaded with the crest holding '%s'" % worn)
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	Gate.enter_battle(self, FOE.duplicate(true))
	await Gate.frames(self, 8)
	var on := 0
	for h in _heroes(current_scene):
		if int((h as BattleUnit).rune_field_medic) == 1:
			on += 1
	ok(on == 4, "§3: a saved Fellowship reached %d of the four heroes at the spawn" % on)
	# ITS FIELD HAS ONE WRITER — THE RETIRED ENTRY — AND ITS READ SITE AND ITS LOG NAME STAND.
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/runes.json"))
	var writers: Array = []
	for id in data:
		if (((data[id] as Dictionary).get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).has("rune_field_medic"):
			writers.append(String(id))
	ok(writers == ["fellowship"], "§3: `rune_field_medic` is written by %s" % [writers])
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bs.contains("u.rune_field_medic + u.field_medic > 0") and bs.contains("_crest_name_for(\"rune_field_medic\")"),
		"§3: the retired rune's read site or its log name was deleted")


# ── §4 — TITHE'S WORDS ──────────────────────────────────────────────────────

func _s4_tithe() -> void:
	print("\n§4 — Tithe's words and the talent's, narrowed to the read site they share")
	var cfg: Dictionary = Runes.config("tithe")
	var share := int(((cfg.get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).get("rune_blood_communion", 0))
	ok(share > 0 and String(cfg.get("desc", "")) == TITHE_WORDS % share, "§4: Tithe reads '%s'" % cfg.get("desc", ""))
	var longest := 0
	for ln in String(cfg.get("desc", "")).split("\n"):
		longest = maxi(longest, String(ln).length())
	ok(longest <= 44, "§4: a line of Tithe's words is %d characters" % longest)
	# THE READ SITE THE WORDS DESCRIBE, AND IT IS NOT WIDENED: one sum, on the Break the
	# blow applied, inside the strike loop's hero-on-enemy branch.
	var bs := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/battle.gd"))
	ok(bs.count("attacker.blood_communion + attacker.rune_blood_communion") == 1
			and bs.contains("result.get(\"bd\", pr) * bc_pct / 100.0"),
		"§4: Tithe's read site moved, or reads something but the Break the blow applied")
	# HQ §1 — THE TALENT OVER THE SAME SITE SAYS WHAT IT READS. *Breaking Heals a Hero*
	# said *every point of Break damage dealt*; the site reads the Break an attack lands,
	# so its words are narrowed as Tithe's were, at the node's own figure.
	var node_pct := 0
	var node_desc := ""
	for n in Talents.tree():
		if String((n as Dictionary).get("id", "")) == "tn_break_heal":
			node_pct = int((((n as Dictionary).get("payload", {}) as Dictionary).get("stat", {}) as Dictionary).get("blood_communion", 0))
			node_desc = String((n as Dictionary).get("desc", ""))
	print("    Breaking Heals a Hero (%d%%): '%s'" % [node_pct, node_desc])
	ok(node_pct > 0 and node_desc == TALENT_WORDS % node_pct,
		"§4: Breaking Heals a Hero reads '%s', not the read site's words" % node_desc)
	var ts := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/talents.gd"))
	var master := FileAccess.get_file_as_string("res://docs/master.html")
	ok(ts.contains("tn_break_heal") and not ts.contains(TALENT_WAS),
		"§4: '%s' still stands in the talent's own source" % TALENT_WAS)
	ok(master.length() > 100000 and master.contains("Breaking Heals a Hero") and not master.contains(TALENT_WAS),
		"§4: '%s' still stands in master.html's copy of the talent" % TALENT_WAS)


# ── §5 — THE RULINGS' RECORDS ───────────────────────────────────────────────

func _s5_the_records() -> void:
	print("\n§5 — the rulings recorded where a future session reads them")
	var cm := FileAccess.get_file_as_string("res://CLAUDE.md")
	ok(cm.length() > 100000 and cm.contains("A CONDITIONED RUNE PAYS MORE THAN THE BARE EQUIVALENT"),
		"§5: CLAUDE.md does not carry FN's reconciliation")
	ok(cm.contains("HERO-SIDE DEBUFF SUPPLY IS 0.296 A ROUND"), "§5: CLAUDE.md does not carry the cleanse finding")
	ok(cm.contains("A CARD STATING ITS OWN COST AND PAYOUT IS WHAT A CARD IS"),
		"§5: the magnitudes rule does not record the distinction ruled at HP §0")
	# HQ §1-§2's records, where a future session reads them: why the three ruled figures
	# stand (so Dirge is not capped as a death-farm, nor Dead Air tuned to its worth over a
	# fight), the word the taxonomy gained, the brief's line that was the error, and why the
	# fifth key is live.
	ok(cm.contains("A RUNE PAID WHILE A HERO IS MISSING IS PRICED BY WHAT IT REPLACES")
			and cm.contains("so Dirge farms nothing"),
		"§5: CLAUDE.md does not carry why the three crest figures stand")
	ok(cm.contains("AND IT CARRIES THE SECONDARY *CONDITIONAL*"),
		"§5: CLAUDE.md does not carry the CONDITIONAL rule beside the relation it binds")
	ok(cm.contains("AND THE BRIEF WAS THE ERROR") and cm.contains("four live keys beside one stale one is a trap"),
		"§5: CLAUDE.md does not record a brief's line as the error, or why the fifth key is live")
	var st := FileAccess.get_file_as_string("res://docs/state.md")
	ok(st.contains("RULED, NOT BUILT") and st.contains("Skirmisher") and st.contains("Tracker"),
		"§5: docs/state.md does not record the Skirmisher and Tracker ruling as ruled and unbuilt")


# ── §6 — THE SMALL THINGS ───────────────────────────────────────────────────

func _s6_the_small_things() -> void:
	print("\n§6 — the run summary, the sim's counter, the dead re-roll, and the Faith comments")
	# THE RUN SUMMARY NAMES THE CREST, A CORE RUNE AND THE BAG.
	var s: Node = await _battle({}, "tithe")
	_run.bag_rune(Runes.build("dirge"))
	var lines: Array = s._summary_lines(s._run_snapshot("wiped", ""))
	var text := ""
	for l in lines:
		text += String((l as Array)[1]) + "\n"
	var core_name := Runes.display_name(Runes.config(Runes.engine_rune_id("bloodrage")))
	ok(text.contains("The crest: Tithe") and text.contains("The bag: Dirge") and text.contains(core_name),
		"§6: the run summary does not name the crest, the bag or a core rune:\n%s" % text)
	# THE POSITIVE ARM: an empty crest and an empty bag are said, not left out.
	_run.party_runes = []
	_run.rune_bag = []
	var lines2: Array = s._summary_lines(s._run_snapshot("wiped", ""))
	var text2 := ""
	for l2 in lines2:
		text2 += String((l2 as Array)[1]) + "\n"
	ok(text2.contains("The crest: empty") and text2.contains("The bag: empty"),
		"§6: an empty crest or bag is left out of the summary")
	# THE SIM'S COUNTER STOCKS NO CORE RUNE — and still one rune a hero.
	var cores := 0
	var stocked := 0
	for trial in 60:
		_new_run(SEATS, ["", "", "", ""])
		for o in RunSim._roll_rune_offers(_run):
			stocked += 1
			if Runes.is_engine_rune(String(((o as Dictionary)["rune"] as Dictionary).get("id", ""))):
				cores += 1
	print("    the sim's counter over 60 counters: %d runes stocked, %d core" % [stocked, cores])
	ok(stocked >= 200 and cores == 0, "§6: the sim's counter stocked %d core runes of %d" % [cores, stocked])
	var sim := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/run_sim.gd"))
	var shop := Gate.strip_comments(FileAccess.get_file_as_string("res://scripts/shop_screen.gd"))
	ok(sim.contains("run.peddler_rune(member, on_counter)") and not sim.contains("run.generate_rune(member, on_counter)"),
		"§6: the sim's counter does not roll through the Peddler's door")
	ok(not shop.contains("for attempt in 4:") and not sim.contains("for attempt in 4:")
			and shop.contains("Run.peddler_rune(member, on_counter)"),
		"§6: a counter still re-rolls for a rune the roll can never draw")
	# THE COMMENTS THAT SPOKE FAITH'S THRESHOLD AS A FIGURE — READ WITH THE COMMENTS,
	# because the comments are what this arm is about.
	var stale: Array = []
	var files := {}
	for pair in FAITH_STALE:
		var f := String(pair[0])
		if not files.has(f):
			files[f] = FileAccess.get_file_as_string("res://" + f)
		if String(files[f]).contains(String(pair[1])):
			stale.append("%s: %s" % [f, pair[1]])
	print("    CHECKED %d phrases in %d files" % [FAITH_STALE.size(), files.size()])
	ok(files.size() == 3 and String(files["scripts/battle.gd"]).length() > 100000 and stale.is_empty(),
		"§6: a comment still speaks Faith's threshold as a figure: %s" % [stale])
	# THE POSITIVE ARM: the threshold is still spoken, as the rule names it.
	ok(String(files["scripts/unit.gd"]).contains("Faith, capped at `FAITH_RELEASE`")
			and String(files["scripts/battle.gd"]).contains("#   Faith          `FAITH_RELEASE` stacks — the release threshold."),
		"§6: the repaired comments no longer name the constant")


# ── §7 — THE PLAYER'S FILES ─────────────────────────────────────────────────

func _s7_the_players_files() -> void:
	print("\n§7 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§7: %s changed under this gate" % p)
