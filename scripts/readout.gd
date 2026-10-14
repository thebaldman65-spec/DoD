# ══ BATCH IF §1 — THE READOUT: ONE PLAYTHROUGH, FIVE ANSWERS ══════════════════
#
# **A FILE THAT CROSSES BETWEEN THE DESIGNER AND THE BATCH.** He plays; the game
# appends one line a fight to `user://readout/run-<date>.jsonl`, beside the save
# and never inside it; he hands the file over. Five rulings wait on figures no
# census can produce — Boil Over's rate, Rupture's number, the vow's worth,
# Sanctity's threshold and the Cleric's Mana — and every one of them was measured
# against the sim's bot, which is the wrong instrument for all five (IE §3a).
#
# **JSON LINES, NOT ONE DOCUMENT.** A fight is appended as one line and nothing
# already written is ever read back or rewritten: a quit, a crash or a forfeit
# leaves every finished fight whole, and a line is readable in any editor. A
# single document would be re-read and re-written at every fight's end, which is
# the read-modify-write that truncates when it fails half way.
#
# **IT MAY NOT MOVE A FIGURE OR SPEND A DIE (IF §1d), AND THAT IS WHY IT IS SHAPED
# THIS WAY.** Every hook `battle.gd` calls is a read: no status, no float, no log
# line, no `randf`, no field written on a unit or on the run. It is a `RefCounted`
# held by the battle — no node, so no tree it could reorder — and it names no
# autoload (CT's rule): the run node is handed in. `check_if` §1 drives a seeded
# fight with it on and off and reads the two byte for byte, and sweeps this file
# for anything that spends a die or writes the game.
#
# **IT IS ON FOR THE DESIGNER'S OWN GAME AND OFF IN EVERY OTHER PROCESS.** The
# decision is `Run.readout_wanted`, FI's split: the player's process is the one
# whose save path is the player's (`Run._init`), so a gate, a sim, a probe or a
# scene target never writes here. `DOD_READOUT=0` turns it off; `=1` turns it on
# in a harness, which then writes `user://readout_harness/` and never the
# player's folder.
extends RefCounted

const VERSION := 1
const DIR := "user://readout"
const HARNESS_DIR := "user://readout_harness"
const POINTER := "latest.txt"
# THE FILE'S BOUND. A zone's play writes a few tens of KiB (`docs/reports/IF.md`
# §1); past this the file stops growing and its last line says so, so a run
# nobody ends cannot write a file nobody can open.
const MAX_BYTES := 2097152
# And each list a fight carries is bounded the same way, for the same reason.
const MAX_ROWS := 60

var _run: Node = null
var _battle: Node = null
var _dir := DIR
var _seats: Array = []          # the party's heroes, seat order (companions out)
var _res := {}                  # seat -> the resource tally
var _open := {}                 # seat -> the turn in progress
var _dealt := {}                # seat -> damage dealt this fight
var _best := {}                 # seat -> his best turn without a Boil Over
var _boil: Array = []           # every pour: its seat, the Rage, what it dealt
var _conj: Array = []
var _vow := {}                  # seat -> {heal_added, refused, blows}
var _fell: Array = []
var _turns := 0                 # every unit's turn
var _hero_turns := 0
var _frame := {}
var _done := false


# ── THE DECISION, SPLIT SO BOTH DIRECTIONS CAN BE ASSERTED (FI's shape) ───────
#
# `env` is DOD_READOUT; `player` says the process is the player's own (its save
# path is the player's). Off in every harness unless asked; on in the player's
# game unless he asks it off.
static func wanted(env: String, active: bool, player: bool) -> bool:
	if env == "0" or not active:
		return false
	return env == "1" or player


# ── THE HOOKS `battle.gd` CALLS, EVERY ONE A READ ─────────────────────────────

func begin(run: Node, battle: Node, heroes: Array, player: bool) -> void:
	_run = run
	_battle = battle
	_dir = DIR if player else HARNESS_DIR
	for h in heroes:
		if h != null and not h.is_companion:
			_seats.append(h)
	for i in _seats.size():
		var u = _seats[i]
		_res[i] = {"resource": String(u.resource_name), "max": int(u.max_resource),
			"turns": 0, "opened_full": 0, "hard_dry": 0, "soft_dry": 0,
			"costed_turns": 0, "low": _frac(u)}
		_dealt[i] = 0.0
		_best[i] = 0.0
		if float(u.get("rune_vow_of_silence")) > 0.0:
			_vow[i] = {"heal_added": 0.0, "refused": 0, "blows": 0}
	var enc: Dictionary = run.get("encounter") if run.get("encounter") is Dictionary else {}
	_frame = {"zone": String(run.get("zone_name")), "zone_n": int(run.get("zone_idx")) + 1,
		"slot": int(run.get("slot_idx")), "node": int(run.get("node_idx")),
		"encounter": String(enc.get("type", "fight")), "theme": String(enc.get("theme", "")),
		"enemies": (enc.get("enemies", []) as Array).duplicate(),
		"bargain": String(run.get("pending_modifier"))}


# Any unit is chosen to act. A conjunction's turns are the afflicted body's own.
func unit_turn(u) -> void:
	_turns += 1
	var iid: int = u.get_instance_id()
	for c in _conj:
		if int(c["iid"]) == iid and bool(c["open"]):
			if _standing(c):
				c["stood"] = int(c["stood"]) + 1
			else:
				c["open"] = false


# His turn opens, BEFORE the drip — IE's *opens full* is read here.
func turn_open(u) -> void:
	var i := _seats.find(u)
	if i < 0:
		return
	_hero_turns += 1
	var r: Dictionary = _res[i]
	r["turns"] = int(r["turns"]) + 1
	r["max"] = int(u.max_resource)
	if int(u.max_resource) > 0 and int(u.resource) >= int(u.max_resource):
		r["opened_full"] = int(r["opened_full"]) + 1
	r["low"] = minf(float(r["low"]), _frac(u))
	_open[i] = {"dealt": float(_dealt[i]), "boiled": false}


# He is about to choose: the drip has landed. Hard dry is every costed card in his
# bar unaffordable; soft dry is at least one (so a hard-dry turn is soft too).
func turn_choose(u) -> void:
	var i := _seats.find(u)
	if i < 0 or not _open.has(i):
		return
	var r: Dictionary = _res[i]
	r["low"] = minf(float(r["low"]), _frac(u))
	var costed := 0
	var short := 0
	for ab in u.abilities:
		if ab == null or int(ab.cost) <= 0:
			continue
		costed += 1
		if int(_battle.call("_eff_cost", u, ab)) > int(u.resource):
			short += 1
	if costed == 0:
		return
	r["costed_turns"] = int(r["costed_turns"]) + 1
	if short > 0:
		r["soft_dry"] = int(r["soft_dry"]) + 1
	if short == costed:
		r["hard_dry"] = int(r["hard_dry"]) + 1


# His turn is over.
func turn_close(u) -> void:
	var i := _seats.find(u)
	if i < 0 or not _open.has(i):
		return
	var t: Dictionary = _open[i]
	_open.erase(i)
	var r: Dictionary = _res[i]
	r["low"] = minf(float(r["low"]), _frac(u))
	var turn_dealt := float(_dealt[i]) - float(t["dealt"])
	for b in _boil:
		if int(b["seat"]) == i and bool(b["open"]):
			b["open"] = false
			b["turn_damage"] = turn_dealt
	if not bool(t["boiled"]):
		_best[i] = maxf(float(_best[i]), turn_dealt)


# `battle._stat`'s door: every hero's damage credit passes it, in real play as in the sim.
func credit(key: String, amount: float, label: String) -> void:
	if not key.begins_with("dmg_hero_"):
		return
	var i := _seat_named(key.trim_prefix("dmg_hero_"))
	if i < 0:
		return
	_dealt[i] = float(_dealt[i]) + amount
	if label == "Boil Over":
		for k in range(_boil.size() - 1, -1, -1):
			if int(_boil[k]["seat"]) == i and bool(_boil[k]["open"]):
				_boil[k]["damage"] = float(_boil[k]["damage"]) + amount
				break


# `battle._stat_heal`'s door: every heal that names its healer, in real play as in the
# sim (`heal_hero_` is booked in the sim alone). THE VOW'S SHARE OF A HEAL IS ITS TERM
# OVER THE WHOLE MULTIPLIER: the vow is summed into `_healing_done_mult` with the other
# healer terms, so of what a heal through that multiplier landed, `vow / mult` is the vow's.
func healed(owner, amount: float) -> void:
	if amount <= 0.0:
		return
	var j := _seats.find(owner) if owner is Object else _seat_named(String(owner))
	if j < 0 or not _vow.has(j):
		return
	var u = _seats[j]
	var v := float(u.get("rune_vow_of_silence"))
	var m := float(_battle.call("_healing_done_mult", u))
	if m > 0.0:
		_vow[j]["heal_added"] = float(_vow[j]["heal_added"]) + amount * v / m


# Boil Over pours the bar out (`battle.gd`, beside the price line). What the cast
# deals is credited to it under its own frame until his turn closes.
func boil_over(u, spent: int) -> void:
	var i := _seats.find(u)
	if i < 0 or _boil.size() >= MAX_ROWS:
		return
	_boil.append({"seat": i, "hero": String(u.unit_name), "rage": spent, "damage": 0.0,
		"turn_damage": -1.0, "core_on": bool(u.has_engine("bloodrage")), "open": true})
	if _open.has(i):
		_open[i]["boiled"] = true


# A blow (or a tick) the vow refused, and the figure it would have landed.
func vow_refused(src, amount: int) -> void:
	var i := _seats.find(src)
	if i < 0 or not _vow.has(i) or amount <= 0:
		return
	_vow[i]["refused"] = int(_vow[i]["refused"]) + amount
	_vow[i]["blows"] = int(_vow[i]["blows"]) + 1


# The door's refusal (`battle._deal_gate`): the dealer is the frame's, the one
# `battle._vow_silences` reads.
func vow_refused_at_door(amount: int) -> void:
	var src = _battle.get("_dmg_src")
	if not is_instance_valid(src):
		src = _battle.call("_hero_named", String(_battle.get("_dmg_src_name")))
	vow_refused(src, amount)


# A conjunction forms on a body (`battle._conjoin`).
func conj_formed(body, made: Dictionary, label: String, a: String, b: String, by: String) -> void:
	if _conj.size() >= MAX_ROWS:
		return
	_conj.append({"iid": body.get_instance_id(), "open": true, "id": String(made.get("id", "")),
		"name": label, "degree": BattleUnit.tier_ordinal(BattleUnit.tier_of(made)),
		"ingredients": [a, b], "on": String(body.unit_name), "by": by,
		"formed_turn": _turns, "stood": 0, "ticks": 0, "break": 0, "broke": false})


# Its tick: the Break it ground out (0 on a Broken body).
func conj_tick(body, comp_id: String, bd: int, broke: bool) -> void:
	var iid: int = body.get_instance_id()
	for c in _conj:
		if int(c["iid"]) == iid and String(c["id"]) == comp_id and bool(c["open"]):
			c["ticks"] = int(c["ticks"]) + 1
			c["break"] = int(c["break"]) + bd
			if broke:
				c["broke"] = true
			return


func hero_fell(u) -> void:
	if _seats.has(u) and _fell.size() < MAX_ROWS:
		_fell.append(String(u.unit_name))


# The fight is over (`battle._check_end`, or a forfeit, which never reaches it).
# Writes its line, and the header first if the run has none.
func finish(victory: bool, stalemate: bool, forfeit := "") -> void:
	if _done or _run == null:
		return
	_done = true
	var state: Dictionary = _run.get("readout")
	var path := String(state.get("path", ""))
	if path == "":
		path = _claim_file(state)
		if path == "":
			return
	var n := int(state.get("fights", 0)) + 1
	state["fights"] = n
	_append(path, _fight_line(n, victory, stalemate, forfeit))


# ── THE RECORDS ───────────────────────────────────────────────────────────────

func _fight_line(n: int, victory: bool, stalemate: bool, forfeit: String) -> Dictionary:
	var heroes: Array = []
	for i in _seats.size():
		var u = _seats[i]
		var r: Dictionary = _res[i]
		var h := {"seat": i, "name": String(u.unit_name), "class": String(u.hero_key),
			"resource": r["resource"], "max": int(r["max"]), "turns": int(r["turns"]),
			"opened_full": int(r["opened_full"]), "costed_turns": int(r["costed_turns"]),
			"hard_dry": int(r["hard_dry"]), "soft_dry": int(r["soft_dry"]),
			"low_water": snappedf(float(r["low"]), 0.001),
			"dealt": int(round(float(_dealt[i]))), "best_ordinary_turn": int(round(float(_best[i]))),
			"cards": _bar(u), "fell": _fell.has(String(u.unit_name)), "standing": not bool(u.dead)}
		if _vow.has(i):
			h["vow"] = {"heal_added": int(round(float(_vow[i]["heal_added"]))),
				"damage_refused": int(_vow[i]["refused"]), "blows_refused": int(_vow[i]["blows"])}
		if bool(u.get("sanctity_active")):
			h["sanctity"] = {"events": int(BattleUnit.sanctity_events),
				"steps": int(u.call("sanctity_steps"))}
		heroes.append(h)
	var boil: Array = []
	for b in _boil:
		boil.append({"hero": b["hero"], "rage": b["rage"], "damage": int(round(float(b["damage"]))),
			"turn_damage": int(round(float(b["turn_damage"]))), "core_on": b["core_on"],
			"best_ordinary_turn": int(round(float(_best[int(b["seat"])])))})
	var conj: Array = []
	for c in _conj:
		conj.append({"name": c["name"], "degree": c["degree"], "ingredients": c["ingredients"],
			"on": c["on"], "by": c["by"], "formed_turn": c["formed_turn"],
			"stood": c["stood"], "ticks": c["ticks"], "break": c["break"], "broke": c["broke"],
			"standing_at_end": bool(c["open"]) and _standing(c)})
	var outcome := "stalemate" if stalemate else ("victory" if victory else "defeat")
	if forfeit != "":
		outcome = "forfeit: " + forfeit
	var line := {"kind": "fight", "n": n, "outcome": outcome,
		"turns": _turns, "hero_turns": _hero_turns,
		"rounds": snappedf(float(_hero_turns) / maxf(float(_seats.size()), 1.0), 0.1),
		"fell": _fell, "heroes": heroes, "conjunctions": conj, "boil_over": boil}
	# The frame's keys are its own (`encounter` is the node's kind — fight, elite, boss —
	# since `kind` names the line), so nothing here is dropped by the merge.
	line.merge(_frame)
	line["loadout"] = _loadout(false)
	return line


func _header(resumed: bool) -> Dictionary:
	var relics: Array = []
	for rid in _run.get("active_relics"):
		var def: Dictionary = Relics.POOL.get(String(rid), {})
		relics.append({"id": String(rid), "name": String(def.get("name", rid))})
	var crest: Array = []
	for r in _run.get("party_runes"):
		crest.append(_rune_name(r))
	return {"kind": "run", "readout": VERSION,
		"written": Time.get_datetime_string_from_system(), "resumed": resumed,
		"rung": int(_run.call("difficulty_rung")), "difficulty": String(_run.get("difficulty")),
		"relics": relics, "crest": crest, "party": _loadout(true),
		"legend": {
			"opened_full": "turns he opened at a full bar, read before the turn's drip",
			"hard_dry": "turns on which every costed card in his bar cost more than he held",
			"soft_dry": "turns on which at least one did (a hard-dry turn is soft too)",
			"costed_turns": "turns on which his bar held a costed card at all",
			"low_water": "his lowest bar this fight, as a fraction of its maximum",
			"best_ordinary_turn": "his most damage in one turn without a Boil Over",
			"vow": "Vow of Silence: the healing its term added, and what it refused",
			"conjunctions": "stood = the afflicted body's own turns it stood; break = what its ticks ground out"}}


# The party as it stands: lineage and worn engines and runes — and, in the header
# alone, the nodes, which are locked for the run when the lineage is confirmed.
func _loadout(with_nodes: bool) -> Array:
	var out: Array = []
	var party: Array = _run.get("party")
	for i in party.size():
		var m: Dictionary = party[i]
		var engines: Array = []
		for e in m.get("engines", []):
			if e is Dictionary and bool(e.get("equipped", false)):
				engines.append(_rune_name(e))
		var runes: Array = []
		for r in m.get("runes", []):
			if r is Dictionary and bool(r.get("equipped", false)):
				runes.append(_rune_name(r))
		var row := {"seat": i, "class": String(m.get("key", "")), "lineage": String(m.get("spec", "")),
			"core": engines, "runes": runes}
		if with_nodes:
			var nodes: Array = []
			var talents: Dictionary = m.get("talents", {})
			for nd in Talents.tree():
				if talents.has(String(nd.get("id", ""))):
					nodes.append(String(nd.get("name", nd.get("id", ""))))
			row["nodes"] = nodes
		out.append(row)
	return out


func _bar(u) -> Array:
	var out: Array = []
	for ab in u.abilities:
		if ab != null:
			out.append(String(ab.display_name))
	return out


# ── THE FILE ──────────────────────────────────────────────────────────────────

# The run's file: a new one for a new run, the pointer's for a resumed one (and a
# new one, marked resumed, when a run predates the readout or its file is gone).
func _claim_file(state: Dictionary) -> String:
	DirAccess.make_dir_recursive_absolute(_dir)
	var pointer := _dir.path_join(POINTER)
	var path := ""
	var resumed := not bool(state.get("fresh", false))
	if resumed and FileAccess.file_exists(pointer):
		var pf := FileAccess.open(pointer, FileAccess.READ)
		if pf != null:
			path = pf.get_as_text().strip_edges()
		if path != "" and not FileAccess.file_exists(path):
			path = ""
	if path == "":
		var stamp := Time.get_datetime_string_from_system().replace(":", "").replace("-", "").replace("T", "-")
		path = _dir.path_join("run-%s.jsonl" % stamp)
		var k := 1
		while FileAccess.file_exists(path):
			k += 1
			path = _dir.path_join("run-%s-%d.jsonl" % [stamp, k])
		if not _append(path, _header(resumed)):
			return ""
		var pw := FileAccess.open(pointer, FileAccess.WRITE)
		if pw != null:
			pw.store_string(path)
	else:
		_append(path, {"kind": "resume", "written": Time.get_datetime_string_from_system()})
	state["path"] = path
	return path


func _append(path: String, rec: Dictionary) -> bool:
	var f: FileAccess = null
	if FileAccess.file_exists(path):
		f = FileAccess.open(path, FileAccess.READ_WRITE)
	else:
		f = FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return false
	var text := JSON.stringify(rec)
	var size := f.get_length()
	if size + text.length() + 1 > MAX_BYTES:
		# THE BOUND IS REACHED: the last line says so, once — a file that already ends
		# on that line takes nothing more.
		f.seek(maxi(size - 256, 0))
		if f.get_buffer(mini(size, 256)).get_string_from_utf8().contains("\"kind\":\"full\""):
			return false
		text = JSON.stringify({"kind": "full", "bytes": size,
			"note": "the readout stops here: this run's file reached its bound"})
	f.seek_end()
	f.store_line(text)
	return true


# ── SMALL READS ───────────────────────────────────────────────────────────────

func _frac(u) -> float:
	var mx := int(u.max_resource)
	return float(u.resource) / float(mx) if mx > 0 else 1.0


func _seat_named(name: String) -> int:
	for i in _seats.size():
		if String(_seats[i].unit_name) == name:
			return i
	return -1


func _standing(c: Dictionary) -> bool:
	var body = instance_from_id(int(c["iid"]))
	return body != null and is_instance_valid(body) and not bool(body.dead) \
		and not (body.call("get_status", String(c["id"])) as Dictionary).is_empty()


static func _rune_name(r) -> String:
	if r is Dictionary:
		return String((r as Dictionary).get("name", (r as Dictionary).get("id", "")))
	return String(r)
