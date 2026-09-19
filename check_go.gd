# BATCH GO — THE NINE MISSING ENGINES.
#
#   §0  THE NINE, READ — six engine runes a class; each of the nine a rule with
#       no lineage, no enabler and no payload; the engine names on no surface a
#       player reads, the rune nouns on every one; the rule text to the standard
#   §1  THE DEAL — three of six for every class, all six reachable, never a
#       rune of another class; and class selection on the real screen, a rule
#       engine taken by every hero, into the first battle on the class kit alone
#   §2  SAVAGE ASSAULT  §3 REDOUBT  §4 ECHO  §5 SIPHON  §6 COVENANT
#   §7  JUDGMENT  §8 QUARRY  §9 OPENING  §10 FIELD KIT
#       — each DRIVEN twice: held ALONE by a hero with no lineage, and held
#       BESIDE another engine of its class, on a hero of a lineage
#   §11 THE BOT — the Bastion spends a large bank on his basic attack
#   §12 LIVE — two autoplay stretches with the enemies striking, all nine held
#   §13 THE PLAYER'S FILES — as this gate found them
#
# ── WHY IT DRIVES ────────────────────────────────────────────────────────────
# **A RULE THAT FIRES ALONE AND NOT BESIDE ANOTHER ENGINE WOULD PASS EVERY STATIC
# CHECK**, which is the brief's sentence and the reason every engine is driven on
# two boards. And every one of the nine hangs off a shared door — the damage
# door, the death door, the status funnel, the strike loop — so a static read
# would find each line and prove nothing about the board it lands on.
#
# **EVERY NEGATIVE ANCHOR HAS ITS POSITIVE ARM BESIDE IT**: an ally's kill books
# nothing beside the Reaver's own kill booking; a miss banks nothing beside a
# blow that banks; a counter spends nothing beside the basic that spends; a
# non-judged enemy heals nobody beside the judged one healing everybody; an
# ally's debuff mends nobody beside the Hunter's; no engine NAME on a surface
# beside the rune NOUN on the same surface.
#
# ── THE BOARDS ───────────────────────────────────────────────────────────────
# `gate_fixture.spawn` with its deterministic rolls — no miss, no parry, no
# block, no crit unless an arm arranges one — and the engines seated through the
# party dict before the scene is built, which is what class selection and the
# pouch hand a real hero. Measured pairs are seeded. `Run` writes its harness
# save under `--script` (FI); `Profile` and `Relics` are pointed at scratch files
# of this gate's own before class selection writes the profile (§1), and §13
# reads the player's three files byte for byte.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . \
#       --script check_go.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const CLASS_SEATS := ["warrior", "mage", "cleric", "hunter"]
const NO_LINEAGE := ["", "", "", ""]
const GO_SEED := 20260918
const SCRATCH_PROFILE := "user://go_profile.json"
const SCRATCH_RELICS := "user://go_relics.json"
const FRAME_CAP := 6000
# THE NINE, BY CLASS — and the internal names, which no player-facing surface
# may carry. Split so this file's own source never spells the pairs a sweep of
# the game's text looks for beside each other.
const NINE := {
	"savage_assault": "warrior", "redoubt": "warrior",
	"cast_echo": "mage", "siphon": "mage",
	"covenant_oath": "cleric", "judgment": "cleric",
	"quarry_hunt": "hunter", "opening_strike": "hunter", "field_kit": "hunter",
}
const NOUNS := {
	"savage_assault": "Reaver", "redoubt": "Bastion", "cast_echo": "Weaver",
	"siphon": "Leech", "covenant_oath": "Oathkeeper", "judgment": "Arbiter",
	"quarry_hunt": "Tracker", "opening_strike": "Skirmisher", "field_kit": "Medic",
}
const ENGINE_NAMES := ["Savage" + " Assault", "Redo" + "ubt", "Ec" + "ho",
	"Sip" + "hon", "Cove" + "nant", "Judg" + "ment", "Quar" + "ry",
	"Open" + "ing", "Field" + " Kit"]

var _g := Gate.new()
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH GO — THE NINE MISSING ENGINES")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	ok(String(_run.save_path) != String(_run.SAVE_PATH),
		"§0: this process would write the PLAYER's run save — stopping before a step is taken")
	if String(_run.save_path) == String(_run.SAVE_PATH):
		_g.report(self)
		return
	_s0_the_nine()
	await _s1_the_deal()
	await _s2_savage_assault()
	await _s3_redoubt()
	await _s4_echo()
	await _s5_siphon()
	await _s6_covenant()
	await _s7_judgment()
	await _s8_quarry()
	await _s9_opening()
	await _s10_field_kit()
	await _s11_the_bot()
	await _s12_live()
	_s13_the_players_files()
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────────
func _names(abilities: Array) -> Array:
	return abilities.map(func(a): return a.display_name)


func _find(u: BattleUnit, n: String) -> Ability:
	if u == null:
		return null
	for ab in u.abilities:
		if ab.display_name == n:
			return ab
	return null


func _pouch(pids: Array) -> Array:
	var out: Array = []
	for pid in pids:
		var r := Runes.build(Runes.engine_rune_id(String(pid)))
		r["equipped"] = true
		out.append(r)
	return out


# A deterministic board with each seat holding exactly the engines named.
func _board(specs: Array, engines: Array, drafted: Dictionary = {}) -> Node:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": _pouch(engines[seat])}
		# BATCH GS — a card a seat must hold that no lineage opens with any more
		# is seated the way a player now gets it: drafted.
		if drafted.has(seat):
			over[seat]["bm_abilities"] = drafted[seat]
	return await Gate.spawn(self, specs, {"deterministic": true, "party": over})


func _clear(s: Node) -> void:
	if is_instance_valid(s):
		s.queue_free()
	for _i in 5:
		await process_frame


func _hero(s: Node, key: String) -> BattleUnit:
	for h in s.get("heroes"):
		if not h.is_companion and h.hero_key == key:
			return h
	return null


func _foes(s: Node) -> Array:
	return s.get("enemies").filter(func(e): return not e.dead)


# The warband's first two raiders — one kind, one armor, so a pair of blows on
# them differs only by what is under test.
func _raiders(s: Node) -> Array:
	return _foes(s).filter(func(e): return not e.is_ranged)


func _reset_foe(e: BattleUnit) -> void:
	e.max_hp = 100000
	e.hp = e.max_hp
	e.pressure = 0
	e.broken = false
	e.broken_pending = false
	for st in e.statuses.duplicate():
		e.remove_status(String(st.id))


func _ready_to_cast(u: BattleUnit) -> void:
	u.resource = u.max_resource
	u.cooldowns.clear()


func _deep(u: BattleUnit) -> void:
	u.max_hp = 100000
	u.hp = u.max_hp
	u.pressure = 0
	u.broken = false


# One seeded cast by `u` on `target`, the target made deep and clean first; the
# damage it took is returned. `pre_draws` spends that many dice after the seed:
# **A SEEDED PAIR IS ONLY A PAIR IF BOTH CASTS SPEND THE SAME STREAM BEFORE THE
# ROLL**, and a float's place on screen is one `randf_range` (`unit.float_text`) —
# so a cast that floats a word above its damage roll is paired with a control
# that makes the same call. The same call, not any draw: a `randf_range` spends
# more of the stream than a `randf` does, measured when a `randf` control missed.
func _cast(s: Node, u: BattleUnit, ab: Ability, target: BattleUnit, sd: int,
		counter := false, pre_draws := 0) -> int:
	_reset_foe(target)
	_ready_to_cast(u)
	seed(sd)
	for _d in pre_draws:
		var _spent_die := randf_range(-34.0, -6.0)
	var before := target.hp
	await s._resolve(u, ab, target, "good", counter)
	return before - target.hp


# One seeded enemy blow on a hero; the health it removed is returned. The foe is
# made strong enough that armor and floors do not blur the reading.
func _blow(s: Node, foe: BattleUnit, victim: BattleUnit, sd: int) -> int:
	var atk_was := foe.attack
	foe.attack = maxi(atk_was, 400)
	foe.cooldowns.clear()
	seed(sd)
	var before := victim.hp
	await s._resolve(foe, foe.abilities[0], victim, "good")
	foe.attack = atk_was
	return before - victim.hp


# The log's text, from `from` on.
func _log_since(s: Node, from: int) -> String:
	var t: String = (s.get("history") as RichTextLabel).get_parsed_text()
	return t.substr(from)


func _log_len(s: Node) -> int:
	return (s.get("history") as RichTextLabel).get_parsed_text().length()


func _has_name(text: String, needle: String) -> bool:
	# Word-bounded, case-blind and INFLECTED: an engine name written as a plain
	# word ("the opening returns") or as a verb ("every third cast echoes") is the
	# name reaching the player all the same, and a name ending in -y inflects
	# through -ies ("quarries"). A bounded match still keeps a longer word
	# ("openness") from reading as the name.
	var stem := needle
	var tail := "(?:s|es|ed|ing)?"
	if needle.ends_with("y"):
		stem = needle.substr(0, needle.length() - 1)
		tail = "(?:y|ys|ies|ied|ying)"
	var rx := RegEx.new()
	rx.compile("(?i)\\b%s%s\\b" % [stem, tail])
	return rx.search(text) != null


# THE WORDS OTHER CONTENT ALREADY OWNS. Three live cards carry an engine name in
# their own — Arcane Echo, Covenant of Ash and Quarry's Mark — so a line naming one
# of them is stripped of the owned name before the sweep. Every ability name and
# every status label is stripped but one that IS an engine name: Quarry's Mark's
# chip reads "Quarry", and stripping it would blind the sweep to that name.
func _strip_owned(text: String) -> String:
	var out := text
	var owned: Array = []
	for ab in Classes.ability_corpus():
		owned.append(String(ab.display_name))
	var consts: Dictionary = (load("res://scripts/battle.gd") as GDScript).get_script_constant_map()
	for sid in consts.get("STATUS_INFO", {}):
		owned.append(String(consts["STATUS_INFO"][sid][0]))
	owned.sort_custom(func(a, b): return a.length() > b.length())
	# A word that IS an engine name is never stripped — the Quarry chip's label
	# would otherwise blind the sweep to that engine's own name.
	var bare_names: Array = ENGINE_NAMES.map(func(n): return String(n).to_lower())
	for w in owned:
		if w != "" and not bare_names.has(String(w).to_lower()):
			out = out.replace(w, " ")
	return out


# ── §0 — THE NINE, READ ─────────────────────────────────────────────────────
func _s0_the_nine() -> void:
	print("--- GO §0: the nine, read ---")
	var engine_runes: Array = []
	for id in Runes.ids():
		if Runes.is_engine_rune(String(id)):
			engine_runes.append(String(id))
	ok(engine_runes.size() >= 24, "§0: the rune file holds at least 24 engine runes (%d)" % engine_runes.size())
	for ck in CLASS_SEATS:
		var pids: Array = Classes.class_engines(ck)
		var rule_n := pids.filter(func(p): return Classes.is_rule_engine(String(p))).size()
		ok(pids.size() == 6 and rule_n == (3 if ck == "hunter" else 2),
			"§0: the %s holds six engines, %d of them rules (%s)" % [ck, rule_n, str(pids)])
		for pid in pids:
			var rid := Runes.engine_rune_id(String(pid))
			ok(rid != "" and String(Runes.config(rid).get("scope", "")) == "class:" + ck
					and not Runes.is_retired(rid),
				"§0: %s is a live %s engine rune (%s)" % [pid, ck, rid])
	for pid in NINE:
		var ck2: String = NINE[pid]
		var rid2 := Runes.engine_rune_id(String(pid))
		var cfg: Dictionary = Runes.config(rid2)
		var built: Dictionary = Runes.build(rid2)
		ok(Classes.is_rule_engine(String(pid)) and Classes.engine_class(String(pid)) == ck2,
			"§0: %s is a %s rule engine" % [pid, ck2])
		# A RULE: no lineage, no enabler, no payload, the flat price.
		ok(Classes.engine_spec(String(pid)) == "" and Classes.engine_enablers(String(pid)).is_empty()
				and (cfg.get("payload", {}) as Dictionary).is_empty() and int(cfg.get("price", 0)) == 100,
			"§0: %s brings no lineage, no enabler and no payload, at the flat 100" % pid)
		ok(String(cfg.get("name", "")) == "Rune of the %s" % NOUNS[pid],
			"§0: %s's rune is the Rune of the %s (%s)" % [pid, NOUNS[pid], cfg.get("name", "")])
		# The kit a holder with no lineage opens with is his basic and his class kit.
		var kit: Array = _names(Classes.opening_kit(ck2, "", [pid]))
		ok(kit == [Classes.kit(ck2)[0].display_name] + Classes.class_kit_names(ck2),
			"§0: a %s holding only %s opens with his basic and his kit (%s)" % [ck2, pid, str(kit)])
		# THE ENGINE NAME REACHES NO SURFACE A PLAYER READS — beside the rune
		# noun reaching each of them (the positive arm).
		var surfaces := {
			"the chip title": Classes.engine_title(String(pid)),
			"the rule text": Classes.engine_desc(String(pid)),
			"the rune's text": String(built.get("desc", "")),
			"the rune's name": String(built.get("name", "")),
		}
		for where in surfaces:
			var text: String = surfaces[where]
			var leaked: Array = ENGINE_NAMES.filter(func(n): return _has_name(text, String(n)))
			ok(leaked.is_empty() and text.contains(String(NOUNS[pid])),
				"§0: %s — %s names %s and no engine name (%s)" % [pid, where, NOUNS[pid], str(leaked)])
		# THE TEXT STANDARD: no line past 44 characters, no pronoun, no digit in
		# parentheses.
		var desc := Classes.engine_desc(String(pid))
		var long: Array = []
		for ln in desc.split("\n"):
			if ln.length() > 44:
				long.append(ln)
		ok(long.is_empty(), "§0: %s's rule text keeps every line within 44 characters (%s)" % [pid, str(long)])
		var rx := RegEx.new()
		rx.compile("(?i)\\b(he|his|him|she|her|you|your)\\b|\\([^)]*[0-9][^)]*\\)")
		ok(rx.search(desc) == null, "§0: %s's rule text carries no pronoun and no authored parenthetical" % pid)
		# No engine rune carries a tag (GK's ruling); the nine are no exception.
		ok(Runes.rune_tags(rid2).is_empty(), "§0: %s's rune carries no tag" % pid)
	# THE NUMBERS IN THE TEXT ARE THE CONSTANTS' — a moved constant moves the text.
	ok(Classes.engine_desc("savage_assault").contains("+%d%%" % Classes.REAVER_KILL_PCT)
			and Classes.engine_desc("siphon").contains("%d%%" % Classes.SIPHON_RETURN_PCT)
			and Classes.engine_desc("judgment").contains("%d%%" % Classes.JUDGMENT_HEAL_PCT)
			and Classes.engine_desc("quarry_hunt").contains("%d%%" % Classes.QUARRY_PCT)
			and Classes.engine_desc("opening_strike").contains("%d%%" % Classes.OPENING_BONUS_PCT)
			and Classes.engine_desc("field_kit").contains("%d%%" % Classes.FIELD_KIT_HEAL_PCT)
			and Classes.engine_desc("cast_echo").contains("%d%%" % int(round(Classes.ECHO_SHARE * 100.0))),
		"§0: every rule text states its engine's own constants")
	# Names are unique across the whole rune file, retired entries included.
	var names := {}
	var dup: Array = []
	for id2 in Runes.ids():
		var nm := String(Runes.config(String(id2)).get("name", ""))
		if names.has(nm):
			dup.append(nm)
		names[nm] = true
	ok(dup.is_empty(), "§0: no two runes share a name (%s)" % str(dup))
	# The three statuses the nine lay are the heroes' work and no affliction. The
	# two MARKS sit on an enemy, so Dispel is told to leave them; the bond's chip
	# sits on a HERO, where Dispel never reads, so it is in neither list (CH's
	# convention for a hero-side status). Read off the battle script's constants
	# at RUNTIME, the way a scene is loaded, never by a compile-time preload.
	var consts: Dictionary = (load("res://scripts/battle.gd") as GDScript).get_script_constant_map()
	var info: Dictionary = consts.get("STATUS_INFO", {})
	var never: Array = consts.get("DISPEL_NEVER", [])
	ok(not info.is_empty() and not never.is_empty(), "§0: the battle script's status tables are readable")
	for sid in ["tracked", "judged"]:
		ok(info.has(sid) and never.has(sid) and not BattleUnit.DEBUFF_IDS.has(sid),
			"§0: %s has a chip, is kept from Dispel and is not an affliction" % sid)
	ok(info.has("oathbound") and not never.has("oathbound")
			and not BattleUnit.DEBUFF_IDS.has("oathbound"),
		"§0: oathbound has a chip and, sitting on a hero, is in neither list")
	ok((consts.get("ENGINE_MARKS", {}) as Dictionary) == {"quarry_hunt": "tracked", "judgment": "judged"},
		"§0: the two marking engines and their marks are the Tracker's and the Arbiter's")
	# The three chips' own words carry no engine name either — beside the chip's
	# label, which each carries (the positive arm).
	for sid2 in ["tracked", "judged", "oathbound"]:
		var row: Array = info.get(sid2, [])
		var chip_text := " ".join(row.slice(0, 2)) + " " + (String(row[3]) if row.size() > 3 else "")
		var leaked2: Array = ENGINE_NAMES.filter(func(n): return _has_name(chip_text, String(n)))
		ok(row.size() > 3 and leaked2.is_empty() and chip_text.contains(sid2.capitalize()),
			"§0: the %s chip reads its label and no engine name (%s)" % [sid2, str(leaked2)])
	_float_sweep()


# EVERY WORD THE BATTLE FLOATS OVER A BODY, READ OUT OF THE SOURCE. A float is
# on screen for half a second and no log keeps it, so it is swept where it is
# written. One float is another card's own word and is named, not skipped — and
# the name must still be found, so the exemption cannot outlive its float.
const FLOAT_EXEMPT := {"%d Echo": "Arcane Echo's repeat: the card's own word"}


func _float_sweep() -> void:
	var floats: Array = []
	var rx := RegEx.new()
	rx.compile('float_text\\("((?:[^"\\\\]|\\\\.)*)"')
	for path in ["res://scripts/battle.gd", "res://scripts/unit.gd"]:
		for line in FileAccess.get_file_as_string(path).split("\n"):
			if line.strip_edges().begins_with("#"):
				continue
			for m in rx.search_all(line):
				floats.append(m.get_string(1))
	var leaked: Array = []
	var exempt_seen := {}
	for f in floats:
		if FLOAT_EXEMPT.has(f):
			exempt_seen[f] = true
			continue
		for n in ENGINE_NAMES:
			if _has_name(String(f), String(n)):
				leaked.append(f)
	ok(floats.size() > 100 and floats.has("SKIRMISHER") and floats.has("OATHBOUND"),
		"§0: the float sweep reads the battle's floats, the nine's among them (%d)" % floats.size())
	ok(leaked.is_empty(), "§0: no float names an engine (%s)" % str(leaked))
	ok(exempt_seen.size() == FLOAT_EXEMPT.size(),
		"§0: every exempt float still exists (%s of %s)" % [str(exempt_seen.keys()), str(FLOAT_EXEMPT.keys())])


# ── §1 — THE DEAL, AND CLASS SELECTION ──────────────────────────────────────
func _s1_the_deal() -> void:
	print("--- GO §1: the deal of three, from six ---")
	# THE DEAL, DRAWN THROUGH THE ONE DOOR THE SCREEN AND THE SIM SHARE.
	seed(GO_SEED)
	for ck in CLASS_SEATS:
		var six: Array = []
		for pid in Classes.class_engines(ck):
			six.append(Runes.engine_rune_id(String(pid)))
		var seen := {}
		var bad := 0
		var n := 600
		for _i in n:
			var m := {"key": ck, "spec": "", "engines": []}
			var dealt: Array = _run.deal_engines(m)
			var distinct := {}
			for rid in dealt:
				distinct[rid] = true
				seen[rid] = int(seen.get(rid, 0)) + 1
			if dealt.size() != 3 or distinct.size() != 3 \
					or not dealt.all(func(r): return six.has(r)) \
					or m.get("engine_offer", []) != dealt:
				bad += 1
		ok(bad == 0, "§1: every %s deal is three different engines of his six, frozen on the member (%d bad of %d)"
			% [ck, bad, n])
		ok(seen.size() == 6, "§1: all six %s engines are dealt (%d seen)" % [ck, seen.size()])
		var rare: Array = []
		for rid2 in six:
			# Three of six is one deal in two; 600 deals put a fair draw within a
			# few points of 50%, so 35% is a floor only a broken deal falls under.
			if float(seen.get(rid2, 0)) / n < 0.35:
				rare.append("%s %d" % [rid2, int(seen.get(rid2, 0))])
		ok(rare.is_empty(), "§1: no %s engine is dealt in fewer than 35%% of deals (%s)" % [ck, str(rare)])
		print("    %-8s %s" % [ck, str(six.map(func(r): return "%s %d%%" % [
			Runes.config(String(r))["name"].trim_prefix("Rune of the "),
			int(round(100.0 * int(seen.get(r, 0)) / n))]))])
	# A second call re-deals nothing: the frozen three come back.
	var mz := {"key": "hunter", "spec": "", "engines": []}
	var first: Array = _run.deal_engines(mz)
	ok(_run.deal_engines(mz) == first and first.size() == 3,
		"§1: a member already dealt is dealt the same three again")
	await _screen_pass(false)
	await _screen_pass(true)


# One walk through the real class-selection screen. `controlled` hands every hero
# an offer led by one of his class's rule engines and takes it, then walks into
# the first battle; otherwise the screen deals as a player's would, the deal is
# read off the screen, and each hero takes the first card.
func _screen_pass(controlled: bool) -> void:
	Profile.save_path = SCRATCH_PROFILE
	if FileAccess.file_exists(SCRATCH_PROFILE):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_PROFILE))
	Profile.loaded = false
	Profile.set_flag("run_framing_seen")
	Relics.save_path = SCRATCH_RELICS
	var rf := FileAccess.open(SCRATCH_RELICS, FileAccess.WRITE)
	rf.store_string("[]")
	rf.close()
	Relics.loaded = false
	OS.set_environment("DOD_AUTOPLAY", "")
	OS.set_environment("DOD_ENEMIES_OFF", "1")
	_run.sim_run = false
	_run.new_run(["warrior", "mage", "cleric", "hunter"], [], "wanderer")
	_run.specs_chosen = false
	_run.active = true
	var takes := {"warrior": "engine_savage_assault", "mage": "engine_siphon",
		"cleric": "engine_judgment", "hunter": "engine_opening_strike"}
	var tag := "controlled" if controlled else "as dealt"
	if controlled:
		for i in _run.party.size():
			var m: Dictionary = _run.party[i]
			var ck := String(m["key"])
			var offer: Array = [takes[ck]]
			for pid in Classes.class_engines(ck):
				var rid := Runes.engine_rune_id(String(pid))
				if offer.size() < 3 and not offer.has(rid):
					offer.append(rid)
			m["engine_offer"] = offer
	seed(GO_SEED + (1 if controlled else 2))
	change_scene_to_file("res://scenes/spec_choice.tscn")
	await Gate.frames(self, 6)
	var taken := {}
	for i in _run.party.size():
		ok(Gate.scene_name(self) == "SpecChoice",
			"§1 (%s): class selection is on screen for hero %d (%s)" % [tag, i, Gate.scene_name(self)])
		var m2: Dictionary = _run.party[i]
		var ck2 := String(m2["key"])
		var offer2: Array = m2.get("engine_offer", [])
		var six: Array = Classes.class_engines(ck2).map(
			func(p): return Runes.engine_rune_id(String(p)))
		var pressable := 0
		for rid2 in offer2:
			if Gate.bound_button(current_scene, "_choose", [i, rid2]) != null:
				pressable += 1
		ok(offer2.size() == 3 and pressable == 3 and offer2.all(func(r): return six.has(r)),
			"§1 (%s): the %s is shown three cards of his six, each with its button (%s)"
				% [tag, ck2, str(offer2)])
		var pick: String = takes[ck2] if controlled else String(offer2[0])
		taken[i] = pick
		var btn: Button = Gate.bound_button(current_scene, "_choose", [i, pick])
		if btn == null:
			ok(false, "§1 (%s): hero %d's card for %s has a button to press" % [tag, i, pick])
			return
		btn.emit_signal("pressed")
		await Gate.frames(self, 4)
	var guard := 0
	while Gate.scene_name(self) != "Map" and guard < 600:
		await Gate.frames(self, 1)
		guard += 1
	ok(Gate.scene_name(self) == "Map", "§1 (%s): the map follows class selection (%s)"
		% [tag, Gate.scene_name(self)])
	for i2 in _run.party.size():
		var m3: Dictionary = _run.party[i2]
		var held: Array = Runes.held_engines(m3)
		var want_pid := String(Runes.config(String(taken[i2])).get("engine", ""))
		ok(held == [want_pid] and bool(m3.get("awakened", false)),
			"§1 (%s): the %s holds what he took, and only it (%s)" % [tag, m3["key"], str(held)])
		if controlled:
			ok(String(m3.get("spec", "?")) == "", "§1: the %s who took a rule engine has no lineage" % m3["key"])
	if not controlled:
		OS.set_environment("DOD_ENEMIES_OFF", "")
		change_scene_to_file("res://scenes/main_menu.tscn")
		await Gate.frames(self, 4)
		_run.active = false
		return
	# The first step onto a fight, through the node's own button.
	var entered := false
	for _step in 12:
		if Gate.scene_name(self) == "Battle":
			entered = true
			break
		if Gate.scene_name(self) != "Map":
			Gate.press(current_scene, ["Leave the Shop", "Leave the forge", "Walk on",
				"Leave", "Onward", "Continue", "Depart"])
			await Gate.frames(self, 10)
			continue
		var open: Array = Gate.open_nodes(current_scene)
		var nxt: int = int(_run.slot_idx) + 1
		var fight_j := -1
		for j in open:
			if nxt < _run.map.size() and String(_run.map[nxt][j].get("type", "")) == "fight":
				fight_j = int(j)
				break
		if fight_j < 0 and not open.is_empty():
			fight_j = int(open[0])
		if fight_j < 0:
			break
		var nb: Button = Gate.bound_button(current_scene, "_on_node_pressed", [fight_j])
		if nb == null:
			break
		nb.emit_signal("pressed")
		await Gate.frames(self, 10)
	ok(entered, "§1: a fight is entered from the map (%s)" % Gate.scene_name(self))
	if entered:
		await Gate.frames(self, 30)
		var bs: Node = current_scene
		for h in bs.get("heroes"):
			if h.is_companion:
				continue
			var ck3: String = h.hero_key
			var pid3 := String(Runes.config(String(takes[ck3])).get("engine", ""))
			var want: Array = [Classes.kit(ck3)[0].display_name] + Classes.class_kit_names(ck3)
			var chip: Dictionary = h.get_status(h.engine_chip_id(pid3))
			ok(h.engines == [pid3] and _names(h.abilities) == want
					and String(chip.get("label", "")) == String(NOUNS[pid3]),
				"§1: the %s who took the Rune of the %s fights his first battle on his basic and his kit, the chip named %s (%s)"
					% [ck3, NOUNS[pid3], String(chip.get("label", "")), str(_names(h.abilities))])
			print("    first battle: the %s (%s) holds %s" % [ck3, NOUNS[pid3], str(_names(h.abilities))])
	OS.set_environment("DOD_ENEMIES_OFF", "")
	Engine.time_scale = 1.0
	change_scene_to_file("res://scenes/main_menu.tscn")
	await Gate.frames(self, 4)
	_run.active = false


# ── §2 — SAVAGE ASSAULT: THE RUNE OF THE REAVER ─────────────────────────────
func _s2_savage_assault() -> void:
	print("--- GO §2: the Rune of the Reaver ---")
	var s: Node = await _board(NO_LINEAGE, [["savage_assault"], [], [], []])
	await _reaver_arm(s, "alone")
	await _clear(s)
	s = await _board(["berserker", "", "", ""], [["bloodrage", "savage_assault"], [], [], []])
	await _reaver_arm(s, "beside Blood Frenzy")
	await _clear(s)


# An enemy felled on the spot: brought back if it was down, left on 1 health.
func _fragile(e: BattleUnit) -> void:
	if e.dead:
		e.revive(1.0)
	_reset_foe(e)
	e.hp = 1


func _reaver_arm(s: Node, tag: String) -> void:
	var W := _hero(s, "warrior")
	var M := _hero(s, "mage")
	var rd := _raiders(s)
	if W == null or M == null or rd.size() < 2:
		ok(false, "§2 (%s): the board seats a Warrior, a Mage and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	var e1: BattleUnit = rd[1]
	var strike: Ability = W.abilities[0]
	W.attack = 1000
	ok(W.reaver_kills == 0 and is_zero_approx(W.reaver_bonus()),
		"§2 (%s): the Reaver opens with no kills and no bonus" % tag)
	var frenzy_was: float = W.frenzy_bonus() if W.has_engine("bloodrage") else 0.0
	var base := await _cast(s, W, strike, e0, GO_SEED + 21)
	# HIS OWN KILL BOOKS, AND AN ALLY'S DOES NOT — side by side.
	_fragile(e1)
	var ally_kill_ab: Ability = M.abilities[0]
	_ready_to_cast(M)
	await s._resolve(M, ally_kill_ab, e1, "good")
	ok(e1.dead and W.reaver_kills == 0,
		"§2 (%s): an enemy the Mage fells adds nothing to the Reaver (%d)" % [tag, W.reaver_kills])
	_fragile(e1)
	_ready_to_cast(W)
	await s._resolve(W, strike, e1, "good")
	ok(e1.dead and W.reaver_kills == 1
			and is_equal_approx(W.reaver_bonus(), 0.01 * Classes.REAVER_KILL_PCT),
		"§2 (%s): an enemy his own Strike fells makes the Reaver %d%% stronger (%d kill)"
			% [tag, Classes.REAVER_KILL_PCT, W.reaver_kills])
	var after := await _cast(s, W, strike, e0, GO_SEED + 21)
	var want: float = (1.0 + W.dmg_bonus + 0.01 * Classes.REAVER_KILL_PCT) / (1.0 + W.dmg_bonus)
	ok(base > 0 and absf(float(after) / float(base) - want) <= 0.01,
		"§2 (%s): ...and the same seeded Strike lands x%.3f (want x%.3f; %d against %d)"
			% [tag, float(after) / maxf(float(base), 1.0), want, after, base])
	print("    %s: Strike %d, then %d after one kill (x%.3f)" % [tag, base, after,
		float(after) / maxf(float(base), 1.0)])
	# A TICK HE LAID NAMES HIM, AND ONE ANOTHER LAID DOES NOT.
	_fragile(e1)
	e1.hp = 30
	s._dmg_frame(null, "Bleed", M.unit_name)
	e1.take_tick_damage(40, "-40", Color.RED)
	ok(e1.dead and W.reaver_kills == 1,
		"§2 (%s): a tick an ally laid fells the enemy and books nothing (%d)" % [tag, W.reaver_kills])
	_fragile(e1)
	e1.hp = 30
	s._dmg_frame(null, "Bleed", W.unit_name)
	e1.take_tick_damage(40, "-40", Color.RED)
	ok(e1.dead and W.reaver_kills == 2,
		"§2 (%s): a tick the Reaver laid fells the enemy and books his kill (%d)" % [tag, W.reaver_kills])
	# AN ENEMY'S OWN BLOW ON ITS FELLOW IS NOBODY'S KILL.
	_fragile(e1)
	s._dmg_frame(e0, "Strike")
	e1.take_hit(50, 0)
	ok(e1.dead and W.reaver_kills == 2,
		"§2 (%s): an enemy felled by an enemy books nothing (%d)" % [tag, W.reaver_kills])
	s._dmg_frame(W, "Strike")
	# UNCAPPED, BY RULING.
	W.reaver_kills = 30
	ok(is_equal_approx(W.reaver_bonus(), 0.30 * Classes.REAVER_KILL_PCT),
		"§2 (%s): thirty kills are thirty steps — no cap (%.2f)" % [tag, W.reaver_bonus()])
	W.refresh_bars()
	var chip: Dictionary = W.get_status(W.engine_chip_id("savage_assault"))
	ok(String(chip.get("label", "")) == "Reaver"
			and String(chip.get("short", "")) == "+%d%%" % (30 * Classes.REAVER_KILL_PCT),
		"§2 (%s): the chip is named Reaver and reads the live bonus (%s)" % [tag, chip.get("short", "")])
	W.reaver_kills = 2
	# BESIDE BLOOD FRENZY: the frenzy term is untouched by a kill, and both read.
	if W.has_engine("bloodrage"):
		ok(is_equal_approx(W.frenzy_bonus(), frenzy_was),
			"§2 (%s): Blood Frenzy reads the same with the Reaver's kills (%.3f)" % [tag, W.frenzy_bonus()])
		W.hp = int(W.max_hp * 0.5)
		var both := await _cast(s, W, strike, e0, GO_SEED + 21)
		W.hp = W.max_hp
		ok(both > after, "§2 (%s): with half his health gone as well, the Strike lands harder still (%d against %d)"
			% [tag, both, after])
	W.attack = 100


# ── §3 — REDOUBT: THE RUNE OF THE BASTION ───────────────────────────────────
func _s3_redoubt() -> void:
	print("--- GO §3: the Rune of the Bastion ---")
	var s: Node = await _board(NO_LINEAGE, [["redoubt"], [], [], []])
	await _bastion_arm(s, "alone")
	await _clear(s)
	s = await _board(["warden", "", "", ""], [["heavy_plating", "redoubt"], [], [], []])
	await _bastion_arm(s, "beside Heavy Plating")
	await _clear(s)


# A blow on the Warrior with every roll arranged off: returns [lost, banked].
func _bank_blow(s: Node, foe: BattleUnit, W: BattleUnit, sd: int) -> Array:
	var bank_was: float = W.redoubt_bank
	var lost := await _blow(s, foe, W, sd)
	return [lost, W.redoubt_bank - bank_was]


func _blind(att: BattleUnit, dfn: BattleUnit, on: bool) -> void:
	# A certain miss: 5% base, Dazed 20, Blind 50, the defender Elusive 25 — and
	# a Heat Haze of 50 against a burning attacker, so the sum clears 1.0 twice.
	if on:
		att.no_cover = 0
		att.add_status("blind", "Blind", "Bd", Color.GRAY, 3)
		att.add_status("dazed", "Dazed", "Dz", Color.GRAY, 3)
		att.add_status("burn", "Burn", "F", Color.ORANGE, 3, "", 0, 0)
		dfn.add_status("elusive", "Elusiveness", "El", Color.GRAY, 3)
		dfn.heat_haze = 50
	else:
		att.no_cover = 1
		for sid in ["blind", "dazed", "burn"]:
			att.remove_status(sid)
		dfn.remove_status("elusive")
		dfn.heat_haze = 0


func _bastion_arm(s: Node, tag: String) -> void:
	var W := _hero(s, "warrior")
	var rd := _raiders(s)
	if W == null or rd.size() < 2:
		ok(false, "§3 (%s): the board seats a Warrior and two raiders" % tag)
		return
	var foe: BattleUnit = rd[0]
	var tgt: BattleUnit = rd[1]
	_reset_foe(foe)
	_reset_foe(tgt)
	_deep(W)
	ok(is_zero_approx(W.redoubt_bank), "§3 (%s): the bank opens empty" % tag)
	# THE CONTROL: the same blow on a Warrior with no armor keeps nothing off him,
	# so what it removes is the whole blow.
	var armor_was: float = W.armor
	W.armor = 0.0
	var bare: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	W.armor = armor_was
	_deep(W)
	ok(bare[0] > 0 and absf(float(bare[1])) < 0.5,
		"§3 (%s): a blow nothing turns banks nothing (%d landed, %.2f banked)" % [tag, bare[0], bare[1]])
	# ARMOR: what was kept off, plus what landed, is the blow.
	var plating_was: float = W.plating_bonus
	var armored: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	ok(armored[1] > 0.0 and absf(float(armored[0]) + armored[1] - float(bare[0])) <= 1.5,
		"§3 (%s): armor banks what it cut — %d landed + %.1f banked = the %d blow"
			% [tag, armored[0], armored[1], bare[0]])
	if W.has_engine("heavy_plating"):
		ok(W.plating_bonus > plating_was,
			"§3 (%s): ...and the same unblocked blow climbs the plating (%.2f -> %.2f)"
				% [tag, plating_was, W.plating_bonus])
	# A MISS BANKS NOTHING — beside the blow above that banked.
	_deep(W)
	_blind(foe, W, true)
	var missed: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	_blind(foe, W, false)
	ok(missed[0] == 0 and absf(float(missed[1])) < 0.001,
		"§3 (%s): a blow that misses banks nothing (%d landed, %.2f banked)" % [tag, missed[0], missed[1]])
	# A BLOCK KEEPS THE WHOLE BLOW OFF, AND BANKS IT WHOLE.
	_deep(W)
	s._apply_status(W, "shield_charges", -1, 1)
	W.plating_bonus = 0.16
	var nominal: float = foe.abilities[0].damage * 0.01 * 400
	var blocked: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	ok(blocked[0] == 0 and absf(float(blocked[1]) - nominal) < 0.01,
		"§3 (%s): a blocked blow banks the whole nominal blow (%.1f of %.1f)" % [tag, blocked[1], nominal])
	if W.has_engine("heavy_plating"):
		ok(is_zero_approx(W.plating_bonus),
			"§3 (%s): ...and the block resets the plating as it always did (%.2f)" % [tag, W.plating_bonus])
	# A PARRY BANKS THE CUT. A banked Guard is spent BEFORE the parry roll, so a
	# parried blow draws one die fewer than the blows above and rolls another
	# variance: its control is the same parry on no armor, where the parry's three
	# quarters are all that is kept off.
	_deep(W)
	W.armor = 0.0
	W.banked_guards = 1
	var parried_bare: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	W.armor = armor_was
	var p_whole := float(parried_bare[0]) + float(parried_bare[1])
	ok(parried_bare[0] > 0 and absf(float(parried_bare[1]) - 3.0 * float(parried_bare[0])) <= 2.5,
		"§3 (%s): a parry on no armor banks the three quarters it turned (%d landed, %.1f banked)"
			% [tag, parried_bare[0], parried_bare[1]])
	_deep(W)
	W.banked_guards = 1
	var parried: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	ok(parried[0] > 0 and parried[0] < parried_bare[0]
			and absf(float(parried[0]) + float(parried[1]) - p_whole) <= 1.5,
		"§3 (%s): a parry banks what it turned and armor what it cut — %d landed + %.1f banked = the %.0f blow"
			% [tag, parried[0], parried[1], p_whole])
	# A BARRIER BANKS WHAT IT ATE.
	_deep(W)
	s._apply_status(W, "barrier", 3, 30)
	var shielded: Array = await _bank_blow(s, foe, W, GO_SEED + 31)
	W.remove_status("barrier")
	ok(absf(float(shielded[0]) + shielded[1] - float(bare[0])) <= 1.5
			and shielded[0] < armored[0],
		"§3 (%s): a barrier banks what it absorbed — %d landed + %.1f banked = the %d blow"
			% [tag, shielded[0], shielded[1], bare[0]])
	print("    %s: blow %d; armor banks %.1f, a block %.1f, a parry %.1f, a barrier %.1f; a miss %.1f" % [
		tag, bare[0], armored[1], blocked[1], parried[1], shielded[1], missed[1]])
	# THE SPEND: THE BASIC ATTACK ADDS THE WHOLE BANK, AND ONLY THE BASIC.
	W.attack = 1000
	var strike: Ability = W.abilities[0]
	W.redoubt_bank = 0.0
	var plain := await _cast(s, W, strike, tgt, GO_SEED + 33)
	W.redoubt_bank = 57.0
	var spent := await _cast(s, W, strike, tgt, GO_SEED + 33)
	ok(plain > 0 and spent == plain + 57 and is_zero_approx(W.redoubt_bank),
		"§3 (%s): the basic attack lands the whole bank of 57 and spends it (%d against %d)"
			% [tag, spent, plain])
	var crush := _find(W, "Crushing Blow")
	W.redoubt_bank = 40.0
	if crush != null:
		await _cast(s, W, crush, tgt, GO_SEED + 34)
		ok(is_equal_approx(W.redoubt_bank, 40.0),
			"§3 (%s): Crushing Blow, a card and not the basic, spends none of it (%.1f)" % [tag, W.redoubt_bank])
	else:
		ok(false, "§3 (%s): the Warrior holds Crushing Blow" % tag)
	# A COUNTER draws no parry die, so its control is the same counter on an empty
	# bank rather than the plain swing above.
	W.redoubt_bank = 0.0
	var counter_plain := await _cast(s, W, strike, tgt, GO_SEED + 33, true)
	W.redoubt_bank = 40.0
	var countered := await _cast(s, W, strike, tgt, GO_SEED + 33, true)
	ok(counter_plain > 0 and countered == counter_plain and is_equal_approx(W.redoubt_bank, 40.0),
		"§3 (%s): the basic swung as a counter spends none of it (%.1f left; %d against %d)"
			% [tag, W.redoubt_bank, countered, counter_plain])
	_blind(W, tgt, true)
	var whiff := await _cast(s, W, strike, tgt, GO_SEED + 33)
	_blind(W, tgt, false)
	ok(whiff == 0 and is_equal_approx(W.redoubt_bank, 40.0),
		"§3 (%s): a basic attack that misses keeps the bank (%.1f)" % [tag, W.redoubt_bank])
	W.redoubt_bank = 12.4
	W.refresh_bars()
	var chip: Dictionary = W.get_status(W.engine_chip_id("redoubt"))
	ok(String(chip.get("label", "")) == "Bastion" and String(chip.get("short", "")) == "Bank 12",
		"§3 (%s): the chip is named Bastion and shows the bank (%s)" % [tag, chip.get("short", "")])
	W.redoubt_bank = 0.0
	W.attack = 100


# ── §4 — ECHO: THE RUNE OF THE WEAVER ───────────────────────────────────────
func _s4_echo() -> void:
	print("--- GO §4: the Rune of the Weaver ---")
	var s: Node = await _board(NO_LINEAGE, [[], ["cast_echo"], [], []])
	await _weaver_arm(s, "alone")
	await _clear(s)
	# BATCH GS §1 — THE PYROMANCER NO LONGER OPENS WITH DETONATION (the engine
	# brings Flamewave and nothing else, the designer's ruling). This arm asks
	# whether a CONSUMING card repeats its damage and not its consumption, which
	# is a question about that card, so it seats it drafted; left unseated, the
	# two checks below skipped themselves in silence.
	s = await _board(["", "pyromancer", "", ""], [[], ["overburn", "cast_echo"], [], []],
		{1: ["Detonation"]})
	await _weaver_arm(s, "beside Overburn")
	await _clear(s)


func _all_clean(s: Node) -> void:
	for e in _foes(s):
		_reset_foe(e)


func _weaver_arm(s: Node, tag: String) -> void:
	var M := _hero(s, "mage")
	var rd := _raiders(s)
	if M == null or rd.size() < 2:
		ok(false, "§4 (%s): the board seats a Mage and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	M.attack = 1000
	var basic: Ability = M.abilities[0]
	ok(M.echo_casts == 0, "§4 (%s): no cast counted yet" % tag)
	_all_clean(s)
	var one := await _cast(s, M, basic, e0, GO_SEED + 41)
	var p_one: int = e0.pressure
	ok(M.echo_casts == 1 and one > 0, "§4 (%s): the first cast counts one (%d)" % [tag, M.echo_casts])
	# A COUNTER IS NOT A CAST.
	_all_clean(s)
	await _cast(s, M, basic, e0, GO_SEED + 41, true)
	ok(M.echo_casts == 1, "§4 (%s): a counter is not a cast (%d)" % [tag, M.echo_casts])
	_all_clean(s)
	var two := await _cast(s, M, basic, e0, GO_SEED + 41)
	ok(M.echo_casts == 2 and two == one,
		"§4 (%s): the second cast counts two and does not repeat (%d against %d)" % [tag, two, one])
	# THE THIRD CAST REPEATS: HALF OF WHAT THE ENEMY TOOK, AND NO BREAK.
	_all_clean(s)
	var three := await _cast(s, M, basic, e0, GO_SEED + 41)
	var want := one + int(round(one * Classes.ECHO_SHARE))
	ok(M.echo_casts == 3 and three == want,
		"§4 (%s): the third cast repeats at half strength (%d against %d + %d)"
			% [tag, three, one, int(round(one * Classes.ECHO_SHARE))])
	ok(e0.pressure == p_one,
		"§4 (%s): ...and the repeat lays no Break damage (%d against %d)" % [tag, e0.pressure, p_one])
	print("    %s: %s %d; the third %d" % [tag, basic.display_name, one, three])
	# A CAST THAT DEALS NOTHING COUNTS, AND REPEATS NOTHING.
	M.echo_casts = 2
	_all_clean(s)
	var ward := _find(M, "Nexus Ward")
	if ward != null:
		_ready_to_cast(M)
		var at := _log_len(s)
		await s._resolve(M, ward, M, "good")
		var hurt := _foes(s).filter(func(e): return e.hp < e.max_hp)
		ok(M.echo_casts == 3 and hurt.is_empty()
				and _log_since(s, at).contains("Rune of the Weaver"),
			"§4 (%s): Nexus Ward as the third cast counts, repeats nothing and says so" % tag)
	else:
		ok(false, "§4 (%s): the Mage holds Nexus Ward" % tag)
	# EVERY ENEMY IT HIT IS HIT AGAIN FOR HALF OF WHAT THAT ENEMY TOOK.
	var missiles := _find(M, "Magic Missiles")
	if missiles != null:
		M.echo_casts = 0
		_all_clean(s)
		var m1 := await _cast(s, M, missiles, e0, GO_SEED + 42)
		M.echo_casts = 2
		_all_clean(s)
		var m3 := await _cast(s, M, missiles, e0, GO_SEED + 42)
		ok(m1 > 0 and m3 == m1 + int(round(m1 * Classes.ECHO_SHARE)),
			"§4 (%s): three bolts repeat once, as half of their sum (%d against %d)" % [tag, m3, m1])
	# A CONSUMING CARD REPEATS ITS DAMAGE, NOT ITS CONSUMPTION.
	var det := _find(M, "Detonation")
	if det != null:
		M.echo_casts = 0
		_all_clean(s)
		s._apply_status(e0, "burn", 4, 0, 20, M)
		M.cooldowns.clear()
		M.resource = M.max_resource
		seed(GO_SEED + 43)
		var hb := e0.hp
		await s._resolve(M, det, e0, "good")
		var d1 := hb - e0.hp
		ok(not e0.has_status("burn"), "§4 (%s): Detonation consumes the Burn" % tag)
		M.echo_casts = 2
		_all_clean(s)
		s._apply_status(e0, "burn", 4, 0, 20, M)
		M.cooldowns.clear()
		M.resource = M.max_resource
		seed(GO_SEED + 43)
		hb = e0.hp
		await s._resolve(M, det, e0, "good")
		var d3 := hb - e0.hp
		ok(d1 > 0 and d3 == d1 + int(round(d1 * Classes.ECHO_SHARE)) and not e0.has_status("burn"),
			"§4 (%s): Detonation as the third cast repeats half its damage, the Burn consumed once (%d against %d)"
				% [tag, d3, d1])
	elif tag == "beside Overburn":
		ok(false, "§4 (%s): the Mage holds Detonation" % tag)
	M.refresh_bars()
	var chip: Dictionary = M.get_status(M.engine_chip_id("cast_echo"))
	ok(String(chip.get("label", "")) == "Weaver",
		"§4 (%s): the chip is named Weaver (%s)" % [tag, chip.get("label", "")])
	M.attack = 100


# ── §5 — SIPHON: THE RUNE OF THE LEECH ──────────────────────────────────────
func _s5_siphon() -> void:
	print("--- GO §5: the Rune of the Leech ---")
	var s: Node = await _board(NO_LINEAGE, [[], ["siphon"], [], []])
	await _leech_arm(s, "alone")
	await _clear(s)
	s = await _board(["", "arcanist", "", ""], [[], ["resonance", "siphon"], [], []])
	await _leech_arm(s, "beside Runaway Resonance")
	await _clear(s)


func _leech_arm(s: Node, tag: String) -> void:
	var M := _hero(s, "mage")
	var rd := _raiders(s)
	if M == null or rd.size() < 2:
		ok(false, "§5 (%s): the board seats a Mage and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	var foe: BattleUnit = rd[1]
	var held: Array = M.engines.duplicate()
	var without: Array = held.filter(func(p): return p != "siphon")
	M.attack = 1000
	var burst := _find(M, "Magic Burst")
	if burst == null:
		ok(false, "§5 (%s): the Mage holds Magic Burst" % tag)
		return
	# DAMAGE DEALT RETURNS AS MANA — beside the same cast returning nothing
	# with the engine taken off.
	var dealt := {}
	var mana := {}
	for arm in ["with", "without"]:
		M.engines = held if arm == "with" else without
		_reset_foe(e0)
		M.cooldowns.clear()
		# The Arcanist's own meter grows with every cast; both arms start level.
		M.second_resource = 0
		M.resource = burst.cost
		seed(GO_SEED + 51)
		var hb := e0.hp
		await s._resolve(M, burst, e0, "good")
		dealt[arm] = hb - e0.hp
		mana[arm] = M.resource
	M.engines = held
	var back := int(round(int(dealt["with"]) * 0.01 * Classes.SIPHON_RETURN_PCT))
	ok(int(dealt["with"]) > 0 and int(mana["with"]) == mini(back, M.max_resource),
		"§5 (%s): %d damage dealt returns %d Mana (%d%%)" % [tag, dealt["with"], mana["with"],
			Classes.SIPHON_RETURN_PCT])
	ok(int(mana["without"]) == 0 and dealt["without"] == dealt["with"],
		"§5 (%s): ...and the same cast returns none without the rune (%d)" % [tag, mana["without"]])
	# DAMAGE TAKEN IS PAID FROM MANA FIRST.
	_deep(M)
	M.engines = without
	M.resource = 50
	var whole := await _blow(s, foe, M, GO_SEED + 52)
	ok(whole > 0 and M.resource == 50,
		"§5 (%s): without the rune a %d blow reaches health and leaves the Mana (%d)" % [tag, whole, M.resource])
	M.engines = held
	_deep(M)
	var spent_was: int = M.mana_spent
	# A tank deep enough to cover the whole blow, so the arm reads the rule and
	# not the size of the bar.
	var max_was: int = M.max_resource
	M.max_resource = 5000
	M.resource = M.max_resource
	var paid := await _blow(s, foe, M, GO_SEED + 52)
	ok(paid == 0 and M.resource == M.max_resource - whole and M.mana_spent == spent_was,
		"§5 (%s): with it the same blow is paid in Mana — none reaches health (%d Mana left of %d), and none of it books as Mana spent"
			% [tag, M.resource, M.max_resource])
	M.max_resource = max_was
	_deep(M)
	M.resource = 5
	var partial := await _blow(s, foe, M, GO_SEED + 52)
	ok(M.resource == 0 and partial == whole - 5,
		"§5 (%s): 5 Mana covers 5 of it and the rest reaches health (%d of %d)" % [tag, partial, whole])
	_deep(M)
	M.resource = 0
	var dry := await _blow(s, foe, M, GO_SEED + 52)
	ok(M.resource == 0 and dry == whole,
		"§5 (%s): at no Mana the whole blow falls through to health — it is not refused (%d of %d)"
			% [tag, dry, whole])
	_deep(M)
	M.resource = 50
	var hp_was: int = M.hp
	M.take_tick_damage(20, "-20", Color.RED)
	ok(M.resource == 30 and M.hp == hp_was,
		"§5 (%s): a tick is paid the same way (%d Mana, %d health lost)" % [tag, M.resource, hp_was - M.hp])
	M.refresh_bars()
	var chip: Dictionary = M.get_status(M.engine_chip_id("siphon"))
	ok(String(chip.get("label", "")) == "Leech", "§5 (%s): the chip is named Leech" % tag)
	print("    %s: %d dealt returned %d Mana; a %d blow paid in Mana, 5 Mana covered 5, none covered none" % [
		tag, dealt["with"], mana["with"], whole])
	M.attack = 100


# ── §6 — COVENANT: THE RUNE OF THE OATHKEEPER ───────────────────────────────
func _s6_covenant() -> void:
	print("--- GO §6: the Rune of the Oathkeeper ---")
	var s: Node = await _board(NO_LINEAGE, [[], [], ["covenant_oath"], []])
	await _oath_arm(s, "alone")
	await _clear(s)
	s = await _board(["", "", "holy", ""], [[], [], ["mercy", "covenant_oath"], []])
	await _oath_arm(s, "beside Mercy")
	await _clear(s)


# The same blow on `victim`, bound and not: [lost bound, other lost bound, lost unbound].
func _oath_blow(s: Node, foe: BattleUnit, victim: BattleUnit, other: BattleUnit,
		sd: int) -> Array:
	var v_link = victim.covenant_with
	var o_link = other.covenant_with
	victim.covenant_with = null
	other.covenant_with = null
	var hb := victim.hp
	var ob := other.hp
	var alone := await _blow(s, foe, victim, sd)
	victim.hp = hb
	other.hp = ob
	victim.covenant_with = v_link
	other.covenant_with = o_link
	var bound := await _blow(s, foe, victim, sd)
	return [bound, ob - other.hp, alone]


func _oath_arm(s: Node, tag: String) -> void:
	var W := _hero(s, "warrior")
	var M := _hero(s, "mage")
	var C := _hero(s, "cleric")
	var H := _hero(s, "hunter")
	var foe: BattleUnit = null
	for e in _raiders(s):
		foe = e
	if [W, M, C, H].any(func(h): return h == null) or foe == null:
		ok(false, "§6 (%s): the board seats four heroes and a raider" % tag)
		return
	_reset_foe(foe)
	# THE FIRST BOND: the other hero with the lowest maximum health, chosen by the
	# game and not the player.
	var lowest: BattleUnit = null
	for h in [W, M, H]:
		if lowest == null or h.max_hp < lowest.max_hp:
			lowest = h
	ok(C.covenant_partner() == lowest and lowest.covenant_partner() == C
			and lowest.has_status("oathbound"),
		"§6 (%s): the Cleric opens bound to the %s, the hero with the lowest maximum health (%d)"
			% [tag, lowest.unit_name, lowest.max_hp])
	C.refresh_bars()
	var chip: Dictionary = C.get_status(C.engine_chip_id("covenant_oath"))
	ok(String(chip.get("label", "")) == "Oathkeeper" and String(chip.get("desc", "")).contains(lowest.unit_name),
		"§6 (%s): the chip is named Oathkeeper and names the bound hero" % tag)
	ok(M == lowest, "§6 (%s): on this board that is the Mage" % tag)
	# A BLOW ON EITHER BODY IS SPLIT BETWEEN THEM.
	# Each blow below is taken on a deepened body, its own maximum put back after —
	# a blow that fells the hero it measures would move the bond this arm reads.
	var h_max := H.max_hp
	_deep(H)
	var h_alone := await _blow(s, foe, H, GO_SEED + 60)
	H.max_hp = h_max
	H.hp = h_max
	ok(not H.dead, "§6 (%s): the Hunter stands after the blow the arm measures" % tag)
	_deep(M)
	_deep(C)
	var on_m: Array = await _oath_blow(s, foe, M, C, GO_SEED + 61)
	var half_m := int(int(on_m[2]) * Classes.COVENANT_SHARE)
	ok(int(on_m[2]) > 0 and on_m[0] == int(on_m[2]) - half_m and on_m[1] == half_m,
		"§6 (%s): a %d blow on the Mage lands %d on him and %d on the Cleric" % [tag, on_m[2], on_m[0], on_m[1]])
	_deep(M)
	_deep(C)
	var on_c: Array = await _oath_blow(s, foe, C, M, GO_SEED + 62)
	var half_c := int(int(on_c[2]) * Classes.COVENANT_SHARE)
	ok(int(on_c[2]) > 0 and on_c[0] == int(on_c[2]) - half_c and on_c[1] == half_c,
		"§6 (%s): a %d blow on the Cleric lands %d on him and %d on the Mage" % [tag, on_c[2], on_c[0], on_c[1]])
	# AN UNBOUND HERO'S BLOW IS HIS ALONE.
	_deep(C)
	var c_before := C.hp
	var w_max := W.max_hp
	_deep(W)
	var w_lost := await _blow(s, foe, W, GO_SEED + 63)
	ok(w_lost > 0 and C.hp == c_before, "§6 (%s): a blow on the unbound Warrior touches nobody else" % tag)
	W.max_hp = w_max
	W.hp = w_max
	# A HERO'S OWN PRICE IS NOT A WOUND AND IS NOT SHARED.
	_deep(M)
	_deep(C)
	c_before = C.hp
	s._dmg_frame(M, "a price")
	M.take_hit(40, 0)
	ok(M.max_hp - M.hp == 40 and C.hp == c_before,
		"§6 (%s): damage the Mage deals himself stays his (%d; the Cleric %d)" % [tag, M.max_hp - M.hp, c_before - C.hp])
	s._dmg_frame(foe, "Strike")
	# HEALING EITHER RECEIVES IS SPLIT TOO, EACH HALF THROUGH ITS OWN BODY.
	_deep(M)
	_deep(C)
	M.hp -= 5000
	C.hp -= 5000
	var mh := M.hp
	var chh := C.hp
	M.heal_amount(200, true)
	ok(M.hp - mh == int(round(100 * M.healing_received_mult))
			and C.hp - chh == int(round(100 * C.healing_received_mult)),
		"§6 (%s): a 200 heal on the Mage heals him %d and the Cleric %d (the Cleric's own +15%%)"
			% [tag, M.hp - mh, C.hp - chh])
	var wh := W.hp
	W.hp = W.max_hp - 300
	wh = W.hp
	chh = C.hp
	W.heal_amount(200, true)
	ok(W.hp - wh == 200 and C.hp == chh, "§6 (%s): an unbound hero's heal is his alone" % tag)
	# A HEAL THE BOUND BODY REFUSES COMES BACK.
	C.hp = C.max_hp
	mh = M.hp
	var refused_by: bool = C.no_heals
	C.no_heals = true
	M.heal_amount(200, true)
	C.no_heals = refused_by
	ok(M.hp - mh == int(round(200 * M.healing_received_mult)),
		"§6 (%s): a half the Cleric cannot take stays with the Mage (%d)" % [tag, M.hp - mh])
	# THE BOND PASSES WHEN THE BOUND HERO FALLS.
	M.max_hp = 99
	M.hp = 1
	C.max_hp = 121
	C.hp = C.max_hp
	await _blow(s, foe, M, GO_SEED + 64)
	var next: BattleUnit = W if W.max_hp < H.max_hp else H
	ok(M.dead and M.covenant_with == null and C.covenant_partner() == next
			and next.has_status("oathbound"),
		"§6 (%s): the Mage falls and the bond passes to the %s" % [tag, next.unit_name])
	# ...AND ENDS WHEN THE CLERIC DOES.
	C.hp = 1
	await _blow(s, foe, C, GO_SEED + 65)
	ok(C.dead and next.covenant_with == null and not next.has_status("oathbound"),
		"§6 (%s): the Cleric falls and the bond ends — the %s is bound to nobody" % [tag, next.unit_name])
	var nx_max := next.max_hp
	_deep(next)
	var n_lost := await _blow(s, foe, next, GO_SEED + 60)
	next.max_hp = nx_max
	next.hp = nx_max
	ok(next != H or n_lost == h_alone,
		"§6 (%s): ...and a blow on the %s is his alone again (%d against %d)" % [tag, next.unit_name, n_lost, h_alone])
	# A REVIVED CLERIC BINDS AGAIN AT HIS TURN.
	C.revive(1.0)
	s._rule_engine_turn(C)
	ok(C.covenant_partner() != null and C.covenant_partner() != M,
		"§6 (%s): a revived Cleric binds again at his turn, to a living hero" % tag)


# ── §7 — JUDGMENT: THE RUNE OF THE ARBITER ──────────────────────────────────
func _s7_judgment() -> void:
	print("--- GO §7: the Rune of the Arbiter ---")
	var s: Node = await _board(NO_LINEAGE, [[], [], ["judgment"], []])
	await _arbiter_arm(s, "alone", false)
	await _clear(s)
	s = await _board(["", "", "occultist", "beastmaster"], [[], [], ["old_gods", "judgment"], ["pack"]])
	await _arbiter_arm(s, "beside Wrath of the Old Gods", true)
	await _clear(s)


func _arbiter_arm(s: Node, tag: String, with_beast: bool) -> void:
	var W := _hero(s, "warrior")
	var M := _hero(s, "mage")
	var C := _hero(s, "cleric")
	var H := _hero(s, "hunter")
	var rd := _raiders(s)
	if [W, M, C, H].any(func(h): return h == null) or rd.size() < 2:
		ok(false, "§7 (%s): the board seats four heroes and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	var e1: BattleUnit = rd[1]
	_all_clean(s)
	var bear: BattleUnit = null
	if with_beast:
		await s._do_summon(H, "ursus")
		for b in s._beasts(H):
			bear = b
		ok(bear != null, "§7 (%s): a bear stands beside the heroes" % tag)
	ok(_foes(s).all(func(e): return not e.has_status("judged")),
		"§7 (%s): no enemy is judged before the Cleric has struck" % tag)
	var allies: Array = [W, M, C, H]
	if bear != null:
		allies.append(bear)
	for a in allies:
		a.hp = int(a.max_hp * 0.5)
	# THE CLERIC'S FIRST BLOW JUDGES ITS TARGET — AND HEALS NOBODY.
	var before := {}
	for a in allies:
		before[a] = a.hp
	_ready_to_cast(C)
	await s._resolve(C, C.abilities[0], e0, "good")
	ok(e0.has_status("judged")
			and String(e0.get_status("judged").get("src_name", "")) == C.unit_name,
		"§7 (%s): the first enemy the Cleric damages is judged, in his name" % tag)
	ok(allies.all(func(a): return a.hp == int(before[a])),
		"§7 (%s): ...and the blow that judged it heals nobody" % tag)
	# AN ALLY'S DAMAGE TO THE JUDGED ENEMY HEALS EVERY ALLY — beside the same
	# ally's damage to an enemy nobody judged, which heals nobody.
	W.attack = 1000
	e1.hp = e1.max_hp
	for a in allies:
		before[a] = a.hp
	_ready_to_cast(W)
	seed(GO_SEED + 71)
	var e1b := e1.hp
	await s._resolve(W, W.abilities[0], e1, "good")
	ok(e1.hp < e1b and allies.all(func(a): return a.hp == int(before[a])),
		"§7 (%s): the Warrior's blow on an enemy nobody judged heals nobody" % tag)
	for a in allies:
		before[a] = a.hp
	_ready_to_cast(W)
	seed(GO_SEED + 71)
	var e0b := e0.hp
	await s._resolve(W, W.abilities[0], e0, "good")
	var dealt := e0b - e0.hp
	var amt := maxi(int(round(dealt * 0.01 * Classes.JUDGMENT_HEAL_PCT)), 1)
	var wrong: Array = []
	for a in allies:
		var gain: int = a.hp - int(before[a])
		var want: int = int(round(amt * a.healing_received_mult))
		# The Warrior may drink the Ruin leech too, beside the Occultist.
		if a == W and with_beast:
			if gain < want:
				wrong.append("%s %d<%d" % [a.unit_name, gain, want])
		elif gain != want:
			wrong.append("%s %d!=%d" % [a.unit_name, gain, want])
	ok(dealt > 0 and wrong.is_empty(),
		"§7 (%s): the Warrior's %d on the judged enemy heals every ally %d%s (%s)"
			% [tag, dealt, amt, ", the bear too" if bear != null else "", str(wrong)])
	print("    %s: %d dealt to the judged enemy healed %d allies %d each" % [tag, dealt, allies.size(), amt])
	# THE JUDGMENT PASSES TO THE HEALTHIEST ENEMY WHEN ITS TARGET FALLS.
	var foes := _foes(s)
	var healthiest: BattleUnit = null
	for e in foes:
		if e == e0:
			continue
		e.hp = e.max_hp - (0 if e == e1 else 10)
		if healthiest == null or e.hp > healthiest.hp:
			healthiest = e
	e0.hp = 1
	_ready_to_cast(W)
	await s._resolve(W, W.abilities[0], e0, "good")
	ok(e0.dead and healthiest != null and healthiest.has_status("judged")
			and String(healthiest.get_status("judged").get("src_name", "")) == C.unit_name,
		"§7 (%s): the judged enemy falls and the judgment passes to the healthiest (%s)"
			% [tag, healthiest.unit_name if healthiest != null else "?"])
	# A FALLEN ARBITER JUDGES NOTHING.
	C.hp = 0
	C._die()
	for a in allies:
		if not a.dead:
			before[a] = a.hp
	_ready_to_cast(W)
	await s._resolve(W, W.abilities[0], healthiest, "good")
	ok(allies.filter(func(a): return not a.dead).all(func(a): return a.hp <= int(before[a])),
		"§7 (%s): with the Cleric fallen, damage to the judged enemy heals nobody" % tag)
	W.attack = 100


# ── §8 — QUARRY: THE RUNE OF THE TRACKER ────────────────────────────────────
func _s8_quarry() -> void:
	print("--- GO §8: the Rune of the Tracker ---")
	var s: Node = await _board(NO_LINEAGE, [[], [], [], ["quarry_hunt"]])
	await _tracker_arm(s, "alone", false)
	await _clear(s)
	s = await _board(["", "", "", "beastmaster"], [[], [], [], ["pack", "quarry_hunt"]])
	await _tracker_arm(s, "beside Pack Bond", true)
	await _clear(s)


# One seeded Strike on a foe whose statuses are kept: the mark is the question.
func _marked_hit(s: Node, W: BattleUnit, e: BattleUnit, sd: int) -> int:
	e.hp = e.max_hp
	e.pressure = 0
	e.broken = false
	_ready_to_cast(W)
	seed(sd)
	var before := e.hp
	await s._resolve(W, W.abilities[0], e, "good")
	return before - e.hp


func _tracker_arm(s: Node, tag: String, with_beast: bool) -> void:
	var W := _hero(s, "warrior")
	var H := _hero(s, "hunter")
	var rd := _raiders(s)
	if W == null or H == null or rd.size() < 2:
		ok(false, "§8 (%s): the board seats a Warrior, a Hunter and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	var e1: BattleUnit = rd[1]
	_all_clean(s)
	ok(_foes(s).all(func(e): return not e.has_status("tracked")),
		"§8 (%s): no enemy is tracked before the Hunter has struck" % tag)
	_ready_to_cast(H)
	await s._resolve(H, H.abilities[0], e0, "good")
	ok(e0.has_status("tracked")
			and String(e0.get_status("tracked").get("src_name", "")) == H.unit_name,
		"§8 (%s): the first enemy the Hunter damages is tracked, in his name" % tag)
	ok(not e1.has_status("tracked"), "§8 (%s): ...and only that one" % tag)
	# HIS LATER BLOWS DO NOT MOVE IT: a commitment, not a re-aim.
	_ready_to_cast(H)
	await s._resolve(H, H.abilities[0], e1, "good")
	ok(e0.has_status("tracked") and not e1.has_status("tracked"),
		"§8 (%s): a blow on another enemy leaves the tracking where it was" % tag)
	# EVERY ALLY DEALS 25% MORE TO IT — beside the same blow on an untracked one.
	W.attack = 1000
	var on_tracked := await _marked_hit(s, W, e0, GO_SEED + 81)
	var on_other := await _marked_hit(s, W, e1, GO_SEED + 81)
	var want := 1.0 + 0.01 * Classes.QUARRY_PCT
	ok(on_other > 0 and absf(float(on_tracked) / float(on_other) - want) <= 0.01,
		"§8 (%s): the Warrior's Strike lands x%.3f on the tracked enemy (%d against %d)"
			% [tag, float(on_tracked) / maxf(float(on_other), 1.0), on_tracked, on_other])
	if with_beast:
		await s._do_summon(H, "canis")
		var wolf: BattleUnit = null
		for b in s._beasts(H):
			wolf = b
		ok(wolf != null, "§8 (%s): a wolf stands beside the Hunter" % tag)
		if wolf != null:
			var bites := {}
			for e in [e0, e1]:
				e.hp = e.max_hp
				seed(GO_SEED + 82)
				var hb: int = e.hp
				await s._companion_hit(wolf, e, 200.0, 0)
				bites[e] = hb - e.hp
			ok(int(bites[e1]) > 0 and absf(float(bites[e0]) / float(bites[e1]) - want) <= 0.03,
				"§8 (%s): ...and so does the wolf's bite (%d against %d)" % [tag, bites[e0], bites[e1]])
	print("    %s: Strike %d on the tracked enemy, %d on another" % [tag, on_tracked, on_other])
	# THE TRACKING PASSES TO THE HEALTHIEST ENEMY WHEN ITS TARGET FALLS.
	var healthiest: BattleUnit = null
	for e in _foes(s):
		if e == e0:
			continue
		e.hp = e.max_hp - (0 if e == e1 else 10)
		if healthiest == null or e.hp > healthiest.hp:
			healthiest = e
	e0.hp = 1
	_ready_to_cast(W)
	await s._resolve(W, W.abilities[0], e0, "good")
	ok(e0.dead and healthiest != null and healthiest.has_status("tracked")
			and String(healthiest.get_status("tracked").get("src_name", "")) == H.unit_name,
		"§8 (%s): the tracked enemy falls and the tracking passes to the healthiest (%s)"
			% [tag, healthiest.unit_name if healthiest != null else "?"])
	# A FALLEN TRACKER'S MARK PAYS NOTHING — the same enemy, the same seeded
	# Strike, the mark on and then off.
	H.hp = 0
	H._die()
	var dead_tracked := await _marked_hit(s, W, healthiest, GO_SEED + 83)
	var saved: Dictionary = healthiest.get_status("tracked").duplicate()
	healthiest.remove_status("tracked")
	var dead_plain := await _marked_hit(s, W, healthiest, GO_SEED + 83)
	ok(dead_plain > 0 and dead_tracked == dead_plain and not saved.is_empty(),
		"§8 (%s): with the Hunter fallen, the mark he left pays nothing (%d against %d)"
			% [tag, dead_tracked, dead_plain])
	W.attack = 100


# ── §9 — OPENING: THE RUNE OF THE SKIRMISHER ────────────────────────────────
func _s9_opening() -> void:
	print("--- GO §9: the Rune of the Skirmisher ---")
	var s: Node = await _board(NO_LINEAGE, [[], [], [], ["opening_strike"]])
	await _skirmisher_arm(s, "alone")
	await _clear(s)
	s = await _board(["", "", "", "sharpshooter"], [[], [], [], ["lethal_aim", "opening_strike"]])
	await _skirmisher_arm(s, "beside Lethal Aim")
	await _clear(s)


func _skirmisher_arm(s: Node, tag: String) -> void:
	var H := _hero(s, "hunter")
	var rd := _raiders(s)
	if H == null or rd.size() < 2:
		ok(false, "§9 (%s): the board seats a Hunter and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	var foe: BattleUnit = rd[1]
	var shot: Ability = H.abilities[0]
	H.attack = 1000
	ok(H.opening_armed, "§9 (%s): the Hunter opens the battle with the bonus ready" % tag)
	# A MISS KEEPS IT — beside the shot that spends it.
	_blind(H, e0, true)
	var whiff := await _cast(s, H, shot, e0, GO_SEED + 91)
	_blind(H, e0, false)
	ok(whiff == 0 and H.opening_armed, "§9 (%s): a shot that misses keeps it ready" % tag)
	var countered := await _cast(s, H, shot, e0, GO_SEED + 91, true)
	ok(countered > 0 and H.opening_armed, "§9 (%s): a shot swung as a counter keeps it ready" % tag)
	var wire := _find(H, "Tripwire")
	if wire != null:
		_ready_to_cast(H)
		await s._resolve(H, wire, H, "good")
		ok(H.opening_armed, "§9 (%s): Tripwire, which deals no damage, keeps it ready" % tag)
	else:
		ok(false, "§9 (%s): the Hunter holds Tripwire" % tag)
	var first := await _cast(s, H, shot, e0, GO_SEED + 92)
	ok(not H.opening_armed, "§9 (%s): the first attack that lands spends it" % tag)
	# The armed shot floats its word above the roll, so its control spends that die.
	var second := await _cast(s, H, shot, e0, GO_SEED + 92, false, 1)
	var want := 1.0 + 0.01 * Classes.OPENING_BONUS_PCT
	ok(second > 0 and absf(float(first) - want * float(second)) <= 0.5 + 0.5 * want,
		"§9 (%s): the first attack lands x%.3f (%d against %d)" % [tag, float(first) / maxf(float(second), 1.0),
			first, second])
	print("    %s: first shot %d, the next %d" % [tag, first, second])
	# IT RETURNS AFTER TWO OF HIS TURNS NO BLOW REACHES HIM.
	s._rule_engine_turn(H)
	ok(not H.opening_armed and H.opening_quiet == 1, "§9 (%s): one quiet turn is not enough" % tag)
	s._rule_engine_turn(H)
	ok(H.opening_armed, "§9 (%s): the second quiet turn brings it back" % tag)
	H.refresh_bars()
	var chip: Dictionary = H.get_status(H.engine_chip_id("opening_strike"))
	ok(String(chip.get("label", "")) == "Skirmisher" and String(chip.get("short", "")) == "READY",
		"§9 (%s): the chip is named Skirmisher and reads READY (%s)" % [tag, chip.get("short", "")])
	# A BLOW THAT REACHES HIM STARTS THE COUNT AGAIN — a blocked one too.
	await _cast(s, H, shot, e0, GO_SEED + 92)
	s._rule_engine_turn(H)
	_deep(H)
	s._apply_status(H, "shield_charges", -1, 1)
	var blocked := await _blow(s, foe, H, GO_SEED + 93)
	s._rule_engine_turn(H)
	ok(blocked == 0 and not H.opening_armed and H.opening_quiet == 0,
		"§9 (%s): a blow he blocks still struck him, and the quiet count starts over" % tag)
	s._rule_engine_turn(H)
	ok(not H.opening_armed, "§9 (%s): ...so one more quiet turn is not enough" % tag)
	# A BLOW THAT MISSES HIM DOES NOT.
	_blind(foe, H, true)
	var missed := await _blow(s, foe, H, GO_SEED + 93)
	_blind(foe, H, false)
	s._rule_engine_turn(H)
	ok(missed == 0 and H.opening_armed,
		"§9 (%s): a blow that misses him leaves the span quiet, and the bonus returns" % tag)
	H.attack = 100


# ── §10 — FIELD KIT: THE RUNE OF THE MEDIC ──────────────────────────────────
func _s10_field_kit() -> void:
	print("--- GO §10: the Rune of the Medic ---")
	var s: Node = await _board(NO_LINEAGE, [[], [], [], ["field_kit"]])
	await _medic_arm(s, "alone")
	await _clear(s)
	# BATCH GS §1 — THE SURVIVALIST NO LONGER OPENS WITH SHRAPNEL CHARGE (Trapper
	# reads no ability, so nothing travels with it and the card is on his shelf).
	# This arm's question — do a card's own afflictions mend again and again
	# beside Trapper — is about that card, so it seats it drafted; left unseated,
	# the arm below skipped itself in silence and the recon read one check fewer.
	s = await _board(["", "", "", "mystic"], [[], [], [], ["trapper", "field_kit"]],
		{3: ["Shrapnel Charge"]})
	await _medic_arm(s, "beside Trapper")
	await _clear(s)


func _wound(W: BattleUnit, others: Array) -> void:
	for o in others:
		o.hp = o.max_hp
	W.hp = int(W.max_hp * 0.2)


func _medic_arm(s: Node, tag: String) -> void:
	var W := _hero(s, "warrior")
	var M := _hero(s, "mage")
	var C := _hero(s, "cleric")
	var H := _hero(s, "hunter")
	var rd := _raiders(s)
	if [W, M, C, H].any(func(h): return h == null) or rd.size() < 2:
		ok(false, "§10 (%s): the board seats four heroes and two raiders" % tag)
		return
	var e0: BattleUnit = rd[0]
	var e1: BattleUnit = rd[1]
	_all_clean(s)
	var mend := maxi(int(round(W.max_hp * 0.01 * Classes.FIELD_KIT_HEAL_PCT)), 1)
	# THE HUNTER LAYS AN AFFLICTION: THE MOST WOUNDED HERO MENDS AND SHEDS ONE.
	_wound(W, [M, C, H])
	s._apply_status(W, "slow", 3, 0, 0, e1)
	var hb := W.hp
	s._apply_status(e0, "cripple", 3, 0, 0, H)
	ok(W.hp - hb == mend and not W.has_status("slow"),
		"§10 (%s): the Hunter Cripples an enemy — the Warrior, most wounded, heals %d (5%% of his %d) and sheds his Slow"
			% [tag, W.hp - hb, W.max_hp])
	# AN ALLY'S AFFLICTION MENDS NOBODY — beside the Hunter's, above.
	hb = W.hp
	s._apply_status(e1, "cripple", 3, 0, 0, M)
	ok(W.hp == hb, "§10 (%s): the Mage's Cripple mends nobody" % tag)
	# A MARK IS NOT AN AFFLICTION.
	hb = W.hp
	s._apply_status(e1, "party_mark", 6, 15, 0, H)
	ok(W.hp == hb, "§10 (%s): the Hunter's mark mends nobody — it is not an affliction" % tag)
	# A REFUSED AFFLICTION MENDS NOBODY.
	hb = W.hp
	var boss_was: bool = e1.is_boss
	e1.is_boss = true
	s._apply_status(e1, "stunned", 1, 0, 0, H)
	e1.is_boss = boss_was
	ok(W.hp == hb and not e1.has_status("stunned"),
		"§10 (%s): a Stun a boss refuses mends nobody" % tag)
	# THE MOST WOUNDED IS WHOEVER IS LOWEST NOW.
	_wound(M, [W, C, H])
	var mh := M.hp
	var wh := W.hp
	s._apply_status(e0, "slow", 3, 0, 0, H)
	ok(M.hp > mh and W.hp == wh, "§10 (%s): with the Mage lowest, the Mage is the one mended" % tag)
	# PLAYABLE ON THE CLASS KIT ALONE: Snare Trap's rig and its spring both mend.
	var snare := _find(H, "Snare Trap")
	if snare != null:
		_all_clean(s)
		_wound(W, [M, C, H])
		hb = W.hp
		_ready_to_cast(H)
		await s._resolve_special(H, snare, e1, "good", 1.0)
		var after_rig := W.hp
		s._spring_trap(H, e1, 0.0)
		ok(after_rig - hb == mend and W.hp - after_rig == mend,
			"§10 (%s): the kit's Snare Trap mends once as it is laid and once as it springs (%d, %d)"
				% [tag, after_rig - hb, W.hp - after_rig])
	else:
		ok(false, "§10 (%s): the Hunter holds Snare Trap" % tag)
	var shrapnel := _find(H, "Shrapnel Charge")
	if shrapnel != null:
		_all_clean(s)
		_wound(W, [M, C, H])
		hb = W.hp
		_ready_to_cast(H)
		await s._resolve(H, shrapnel, e0, "good")
		ok(W.hp - hb >= mend * 2,
			"§10 (%s): beside Trapper, Shrapnel Charge's afflictions mend again and again (%d)" % [tag, W.hp - hb])
	elif tag == "beside Trapper":
		ok(false, "§10 (%s): the Hunter holds Shrapnel Charge" % tag)
	H.refresh_bars()
	var chip: Dictionary = H.get_status(H.engine_chip_id("field_kit"))
	ok(String(chip.get("label", "")) == "Medic", "§10 (%s): the chip is named Medic" % tag)


# ── §11 — THE BOT ───────────────────────────────────────────────────────────
func _s11_the_bot() -> void:
	print("--- GO §11: the Bastion's one decision, taken by the bot ---")
	var s: Node = await _board(NO_LINEAGE, [["redoubt"], [], [], []])
	var W := _hero(s, "warrior")
	if W == null:
		ok(false, "§11: the board seats a Warrior")
		await _clear(s)
		return
	_all_clean(s)
	var basic: Ability = W.abilities[0]
	var nominal: float = basic.damage * 0.01 * W.attack
	W.redoubt_bank = 0.0
	ok(s._bot_redoubt_pick(W).is_empty(), "§11: an empty bank asks nothing of the bot")
	W.redoubt_bank = nominal - 1.0
	ok(s._bot_redoubt_pick(W).is_empty(), "§11: a bank smaller than the basic's blow is left to grow (%.1f)" % W.redoubt_bank)
	W.redoubt_bank = nominal + 1.0
	var pick: Array = s._bot_redoubt_pick(W)
	ok(pick.size() == 2 and pick[0] == basic and pick[1] != null and not (pick[1] as BattleUnit).is_hero,
		"§11: a bank at least as large as the basic's blow is spent on the basic, at an enemy")
	var full: Array = s._autoplay_pick(W)
	ok(full.size() == 2 and full[0] == basic, "§11: ...and the whole policy asks it first")
	var held: Array = W.engines.duplicate()
	W.engines = []
	ok(s._bot_redoubt_pick(W).is_empty(), "§11: a Warrior without the rune is never asked, whatever the field reads")
	W.engines = held
	await _clear(s)


# ── §12 — LIVE ──────────────────────────────────────────────────────────────
func _s12_live() -> void:
	print("--- GO §12: live, with the enemies striking ---")
	await _stretch("the nine, no lineage", NO_LINEAGE,
		[["savage_assault", "redoubt"], ["cast_echo", "siphon"],
		["covenant_oath", "judgment"], ["quarry_hunt", "opening_strike"]])
	await _stretch("beside lineage engines, one", ["berserker", "pyromancer", "holy", "mystic"],
		[["bloodrage", "savage_assault"], ["overburn", "cast_echo"],
		["mercy", "covenant_oath"], ["trapper", "field_kit"]])
	await _stretch("beside lineage engines, two", ["warden", "arcanist", "occultist", "sharpshooter"],
		[["heavy_plating", "redoubt"], ["resonance", "siphon"],
		["old_gods", "judgment"], ["lethal_aim", "opening_strike"]])
	await _stretch("beside Pack Bond", ["", "", "", "beastmaster"],
		[[], [], [], ["pack", "quarry_hunt"]])


const LIVE_NEEDLES := {
	"savage_assault": ["Rune of the Reaver:", "fells"],
	"redoubt": ["Rune of the Bastion:", "(spent)"],
	"cast_echo": ["Rune of the Weaver:", "repeats for"],
	"siphon": ["Rune of the Leech", "in Mana"],
	"covenant_oath": ["Rune of the Oathkeeper:", "wound"],
	"judgment": ["Rune of the Arbiter:", "mends"],
	"quarry_hunt": ["Rune of the Tracker:", "tracks"],
	"opening_strike": ["Rune of the Skirmisher:", "(spent)"],
	"field_kit": ["Rune of the Medic:", "mends"],
}


func _fired(text: String, pid: String) -> bool:
	var nd: Array = LIVE_NEEDLES[pid]
	for ln in text.split("\n"):
		if ln.contains(String(nd[0])) and ln.contains(String(nd[1])):
			return true
	return false


func _stretch(tag: String, specs: Array, engines: Array) -> void:
	var over := {}
	for seat in 4:
		over[seat] = {"engines": _pouch(engines[seat])}
	seed(GO_SEED + 120 + tag.length())
	var s: Node = await Gate.spawn(self, specs, {"party": over})
	var want: Array = []
	for row in engines:
		for pid in row:
			if Classes.is_rule_engine(String(pid)):
				want.append(String(pid))
	var heroes: Array = s.get("heroes").filter(func(h): return not h.is_companion)
	var foes: Array = _foes(s)
	# Two enemies deep and one fragile: the fragile one falls and is brought back,
	# so kills, a mark that moves and a bond that holds are all on the table.
	var fragile: BattleUnit = null
	for e in foes:
		e.max_hp = 100000
		e.hp = e.max_hp
		if fragile == null and not e.is_ranged:
			fragile = e
	s.set("debug_enemies_off", false)
	# The fixture parks the first hero's turn awaiting a pick, and it is answered
	# by hand BEFORE the bot takes over (GN §4's order). **A LETHAL AIM HOLDER'S
	# BASIC OPENS THE PRESS BAR**, which a hand-answered turn runs for real and
	# which waits for a press nobody makes — so he answers with Tripwire, a
	# self-cast that raises no bar and names no target.
	var parked: BattleUnit = s.get("current_hero")
	if parked != null:
		var answer: Ability = parked.abilities[0]
		if parked.has_engine("lethal_aim"):
			answer = _find(parked, "Tripwire")
		ok(answer != null, "§12 (%s): the parked %s has an answer that raises no bar" % [
			tag, parked.unit_name])
		if answer != null:
			parked.cooldowns.clear()
			parked.resource = parked.max_resource
			s.emit_signal("_ability_picked", answer)
			await process_frame
			if answer.special != "tripwire":
				s.emit_signal("_target_picked", _foes(s)[0])
	s.set("autoplay", true)
	var frames := 0
	var seen := {}
	var down_for := 0
	while frames < FRAME_CAP and seen.size() < want.size():
		Engine.time_scale = 100.0
		await process_frame
		frames += 1
		if not is_instance_valid(s) or bool(s.get("battle_over")):
			break
		for h in heroes:
			if not h.dead and h.hp < int(h.max_hp * 0.3):
				h.hp = int(h.max_hp * 0.6)
		if fragile != null:
			if fragile.dead:
				down_for += 1
				if down_for > 20:
					fragile.revive(1.0)
					fragile.max_hp = 60
					fragile.hp = 60
					down_for = 0
			elif fragile.max_hp > 60:
				fragile.max_hp = 60
				fragile.hp = 60
		for e in foes:
			if e != fragile and not e.dead and e.hp < 50000:
				e.hp = e.max_hp
		if frames % 20 == 0:
			var text := _log_since(s, 0)
			for pid in want:
				if not seen.has(pid) and _fired(text, String(pid)):
					seen[pid] = frames
	Engine.time_scale = 1.0
	if is_instance_valid(s):
		var text2 := _log_since(s, 0)
		for pid2 in want:
			if not seen.has(pid2) and _fired(text2, String(pid2)):
				seen[pid2] = frames
		s.set("autoplay", false)
	var missing: Array = want.filter(func(p): return not seen.has(p))
	ok(missing.is_empty(), "§12 (%s): every rule engine held fires in a live fight (%d frames; silent: %s)"
		% [tag, frames, str(missing)])
	# THE LOG AND THE CHIPS ARE SURFACES TOO: every line the nine wrote, and every
	# chip they hold at the end, names its rune and no engine.
	if is_instance_valid(s):
		var lines: Array = []
		for ln in _log_since(s, 0).split("\n"):
			for pid3 in NOUNS:
				if ln.contains("Rune of the %s" % NOUNS[pid3]):
					lines.append(ln)
					break
		var leaked3: Array = []
		for ln2 in lines:
			var bare := _strip_owned(String(ln2))
			for n in ENGINE_NAMES:
				if _has_name(bare, String(n)):
					leaked3.append(ln2)
					break
		ok(lines.size() >= seen.size() and leaked3.is_empty(),
			"§12 (%s): the %d log lines the nine wrote name no engine (%s)" % [tag, lines.size(), str(leaked3.slice(0, 3))])
		var chips := 0
		var held := 0
		var leaked4: Array = []
		for h in heroes:
			if h.dead:
				continue
			h.refresh_bars()
			for pid4 in h.engines:
				if not Classes.is_rule_engine(String(pid4)):
					continue
				held += 1
				var chip: Dictionary = h.get_status(h.engine_chip_id(String(pid4)))
				var ctext := "%s %s %s" % [chip.get("label", ""), chip.get("short", ""), chip.get("desc", "")]
				if not chip.is_empty():
					chips += 1
				if not ctext.contains(String(NOUNS[pid4])):
					leaked4.append("%s: no noun" % pid4)
				for n in ENGINE_NAMES:
					if _has_name(_strip_owned(ctext), String(n)):
						leaked4.append("%s: %s" % [pid4, n])
		ok(chips > 0 and chips == held and leaked4.is_empty(),
			"§12 (%s): the %d rule-engine chips, read live, name their rune and no engine (%s)" % [tag, chips, str(leaked4)])
	print("    %s: %s fired within %d frames" % [tag, str(seen), frames])
	OS.set_environment("DOD_ENEMIES_OFF", "")
	await _clear(s)


# ── §13 — THE PLAYER'S FILES ────────────────────────────────────────────────
func _s13_the_players_files() -> void:
	for p in _player:
		var was: Array = _player[p]
		var has := FileAccess.file_exists(p)
		ok(has == bool(was[0]), "§13: %s exists as it did before the gate (%s)" % [p, has])
		ok(not has or FileAccess.get_file_as_bytes(p) == was[1],
			"§13: %s is byte for byte what it was" % p)
