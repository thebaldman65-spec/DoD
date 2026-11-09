# THE GATE FOR THE RECORD PUT RIGHT, AND THREE CARRIERS MADE MEETABLE.
#
#   §0   JQ's SEVEN RULINGS answered and archived; the batch's own choices each owed as a ruling with its reversal (H02).
#   §1   THE THREE RARE CARRIERS: the Orc Hexer, the Grave Totem and the Rot Behemoth are fielded materially more often than they
#        were, DERIVED OFF THE DATA through the composer's own door (`Run._theme_combos`) for every roster and every budget a fight
#        node rolls (C01); every hex is still laid by the one kind that laid it, and no move moved (C02); no kind fielded by a rule
#        rather than a draw — a boss, an elite — is drawn by a fight, and none of the three is one (C03); and nothing in the
#        warband's data moved but the three appearance tags JR set (C15).
#   §2   A CITATION IS THE TEXT: no `file:NNN` citation, in any of its four spellings, stands in a document this gate holds (C04);
#        none was replaced by another spelling of a line number (C05); the rule stands in `docs/ways-of-working.md` (C06); every
#        kind of record that keeps a line is excluded HERE, by name and with its reason, and every excluded record is held at its
#        count so none grows (C07); and the state's replacements quote lines that stand in the functions they name.
#   §3   THE INDEX AND THREE STALE CLAIMS: every trigger a close-read owed is in its row (C08), within `check_is` §5's 400 bytes (C09,
#        C10); the two rows that took a dial name one (C11); no row names a block that does not exist (C12); the Malice ledger's
#        comment, `relics.gd`'s header and the strays' count say what the code does (C13).
#   §4   THE TWO READINGS: both files read at the open and the close, and the room projected for the next batch (C14).
#   §5   WHAT IS DELIBERATELY NOT DONE: no dial pulled and no figure of JQ's moved (C15); the deck closed at twenty-five (C16).
#   §6   the player's files, as this gate found them.
#   Every needle is the rule's own words, never the batch code beside them — but for the blocks' headings §0 and §3 read, which are
#   named for their batches; §4's projection is read by its shape (`PROJECTED FOR` and any batch's code). A block a later batch
#   archives is read where it went or skipped with a notice, so this gate does not red the batch that closes what it holds. Every
#   member is asked for before it is read, so HEAD's tree reds here (H01, H02) rather than throwing.
#
#   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script check_jr.gd
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

const DECK_CLOSED_AT := 25
# ── §1's FIGURES ──────────────────────────────────────────────────────────────
# THE THREE CARRIERS AND THE TAG EACH WAS GIVEN (JR §1): a roster tag where the kind sat out of a roster, a second role where it
# sat in all three. Before JR: the Grave Totem in rosters 1 and 3, the Rot Behemoth in 2 and 3, the Orc Hexer a hexer alone.
const CARRIERS := ["hexer", "grave_totem", "behemoth"]
const AS_HEAD := {"grave_totem": {"zones": [1.0, 3.0]}, "behemoth": {"zones": [2.0, 3.0]}, "hexer": {"roles": ["hexer"]}}
const AS_JR := {"grave_totem": {"zones": [1.0, 2.0, 3.0]}, "behemoth": {"zones": [1.0, 2.0, 3.0]}, "hexer": {"roles": ["hexer", "sniper"]}}
# HOW OFTEN A FIGHT FIELDS EACH, DERIVED: the mean over the three rosters, each over tiers 1–15 with the budget uniform in its band.
# HEAD's figure is this gate's derivation on HEAD's data (H01 reads it); JR's is the derivation on the data that lands.
# HEAD's figure is RE-DERIVED here too, with `AS_HEAD`'s tags put into the loaded data, and must read the record's.
const RATE_AT_HEAD := {"hexer": 0.1023, "grave_totem": 0.1254, "behemoth": 0.0532}
const RATE_AT_JR := {"hexer": 0.1745, "grave_totem": 0.1963, "behemoth": 0.0775}
# "MATERIALLY MORE OFTEN" AS A BAR: JR's judgment, set after the derivation read ×1.46 for the Rot Behemoth, the least of the three.
const MATERIALLY := 1.4
# WHO LAYS EACH HEX (JL §2, each riding a blow since JO §2): one carrier a hex, and no hex moved (C02).
const HEX_CARRIER := {"gall": "archer", "sap": "hexer", "mire": "grave_totem", "fester": "behemoth"}
# THE KINDS FIELDED BY A RULE, NOT A DRAW: a zone's named boss and the end boss (`ZONE_DEFS`, `boss_kind`, the end slot), and the
# chief, who appears only through the elite themes. A fight node never draws one (C03).
const RULE_ROLES := ["boss", "elite"]
const RULE_FIELDED := ["chief", "withered_warden", "ash_tyrant", "hollow_crown"]
# THE WARBAND's DATA AS JQ LANDED IT — `check_jq` §5's digest. With the three tags put back as they were, the tree's data must
# read it: nothing else in a kind moved (C15).
const WARBAND_AT_HEAD_MD5 := "f261e6345f22f42bc41a7f81276e066b"
# ── §2's POPULATION ───────────────────────────────────────────────────────────
# THE RULE's OWN WORDS, where `docs/ways-of-working.md` states it (C06).
const CITE_RULE := "a record cites a file, a function and a quoted line, never a line number"
# HELD AT ZERO: every document the state, the rules and the reports are written in. The reports are listed at run time.
const HELD := ["res://docs/state.md", "res://CLAUDE.md", "res://docs/master.html", "res://docs/instrument-rules.md",
	"res://docs/ways-of-working.md", "res://docs/combat-rules.md", "res://docs/text-standard.html", "res://docs/design-notes.md",
	"res://docs/changelog.html", "res://README.md"]
# THE KINDS EXCLUDED, BY NAME AND WITH THE REASON — the gate's own list, never a hand-skip (C07).
const EXCLUDED_KINDS := {
	".tsv": "a census or count table a tool or gate reads by its rows; a line column there is the census's own key, read on the commit that landed it",
	".json": "data a tool or gate reads (a kept kit, `baselines.json`, `pin-manifest.json`); the manifest records a needle's place by design",
	".gd": "a gate's or suite's own source; a reference inside it is the gate's own, read with the code beside it (the game's own scripts are held below)",
}
# HELD AT THEIR COUNT, NOT SWEPT: closed records the brief did not name, each pinned where JR found it so none grows. A count that
# falls is a notice; one that rises is a citation written into a closed record.
const CEILINGS := {
	"res://DoD-archive/state-archive.md": 738, "res://DoD-archive/changelog-archive.html": 25, "res://docs/kit-recon.html": 169,
	"res://docs/spec-recon.html": 147, "res://docs/systems-recon.html": 112, "res://docs/talent-audit.html": 60,
	"res://docs/rune-audit.html": 37, "res://docs/text-audit.html": 16, "res://docs/merge-recon.html": 3, "res://docs/draft-audit.html": 0,
	"res://DoD-archive/addendum.html": 0,
}
# ANOTHER SPELLING OF A LINE NUMBER (C05): `line 135`, `lines 104, 106`, and `L433`. None in a living document; the reports hold
# the ones written before JR at their count, each spelling its own.
const LINE_WORD_REPORTS := 65
const LINE_L_REPORTS := 34
# AND THREE RARER SPELLINGS THE REPORTS HOLD (the new text's reader's H3), each at its count, none in a living document: a section's
# mark, a colon and digits (`§0` then `:242`); a bare colon and digits closed by another colon; a script's name, `#` and digits. A
# file's name, a space and a number cannot be told from a size by any pattern, so it is no arm here (FOUND AT JR names it).
const RARE_SPELLINGS := {"§N:N": ["§\\d+[a-z]?:\\d{2,}", 38], ":N:": ["(?<=[\\s(\\[/,;]):\\d{2,}(?:[-–]\\d+)?:", 7], "file#N": ["\\.(?:gd|py|sh|md|html)#\\d+", 2]}
# A FENCED BLOCK IN A REPORT IS QUOTED OUTPUT (a grep's listing), kept as the tool printed it: the scan reads around it.
# THE STATE's REPLACEMENTS, EACH A FILE, A FUNCTION (`` for a file-scope line) AND THE LINE IT QUOTES: each must stand there.
# `Gate.fn_body` STRIPS COMMENTS, so a comment quoted inside a function is read at file scope ("" as its function).
const STATE_QUOTES := [
	["check_ct_map.gd", "_process", "ok(lowest <= draft_top,", "ok(lowest <= draft_top,"],
	["check_gp.gd", "", "because `hold_rune` slots an", "func _unslot_engines()"],
	["check_gm.gd", "_s2_bound_cards", "ok(run.ability_slots_used(m_held) == run.ability_slots_used(m_drop) - freed", "ok(run.ability_slots_used(m_held) == run.ability_slots_used(m_drop) - freed"],
	["check_gn.gd", "_s0_the_kit", "Classes.opening_kit(", "Classes.opening_kit"],
	["check_gx.gd", "_s3_the_three_surfaces", "_label_with(ov, \"%s — %s\" % [rname, GT_HEAD])", "_s3_the_three_surfaces"],
	["check_gx.gd", "_s4b_the_panels_worst_case", "_label_with(ov, \"%s — %s\" % [String(nm), GT_HEAD])", "_s4b_the_panels_worst_case"],
	["test_batch_as.gd", "_live_boss", "if slot.get_child(0).tooltip_text.begins_with(boss.unit_name):", "if slot.get_child(0).tooltip_text.begins_with(boss.unit_name):"],
	["check_ct_map.gd", "_process", "if n is Label and String(n.text).begins_with(\"THE DRAFT\"):", "if n is Label and String(n.text).begins_with(\"THE DRAFT\"):"],
	["scripts/battle.gd", "_resolve", "if attacker.is_hero and attacker.has_engine(\"trapper\") \\", "if attacker.is_hero and attacker.has_engine(\"trapper\") \\"],
	["scripts/battle.gd", "_resolve", "if ab.display_name == \"Pinning Shot\" and not target.dead:", "if ab.display_name == \"Pinning Shot\" and not target.dead:"],
	["scripts/battle.gd", "_resolve_special", "if attacker.rune_bare_altar > 0:", "if attacker.rune_bare_altar > 0:"],
	["scripts/battle.gd", "_resolve_special", "ds_pct *= 0.5", "ds_pct *= 0.5"],
	["scripts/battle.gd", "_recast_writes", "base = int(round(u.max_hp * (0.35 + 0.01 * u.stalwart_step)))", "base = int(round(u.max_hp * (0.35 + 0.01 * u.stalwart_step)))"],
	["scripts/battle.gd", "_resolve", "if attacker.has_status(\"warcry\"):", "if attacker.has_status(\"warcry\"):"],
	["scripts/battle.gd", "_resolve", "if attacker.status_power(\"exhorted\") > 0 and ab.damage > 0 \\", "if attacker.status_power(\"exhorted\") > 0 and ab.damage > 0 \\"],
	["scripts/battle.gd", "_resolve", "if attacker.has_status(\"zeal\"):", "if attacker.has_status(\"zeal\"):"],
	["scripts/battle.gd", "_resolve", "raw *= _party_mark_mult(strike_target)", "raw *= _party_mark_mult(strike_target)"],
	["scripts/battle.gd", "", "# DOD_SIM_TALENTS=\"bz_bloodcraze:3,wd_toughness:2\" force-learns", "the `DOD_SIM_TALENTS` example in `battle.gd`'s `_spawn_units`"],
	["scripts/battle.gd", "_resolve", "→ Talent: Richocet — the block staggers", "→ Talent: Richocet — the block staggers"],
	["scripts/battle.gd", "_dot_pass", "if dot_died:", "if dot_died:"],
	["scripts/battle.gd", "_dot_pass", "_log(\"† %s dies\" % u.unit_name, \"#e05050\")", "_log(\"† %s dies\" % u.unit_name, \"#e05050\")"],
	["scripts/unit.gd", "", "var ricochet_ranks", "var ricochet_ranks"],
	["scripts/unit.gd", "", "var block_chance := 0.0", "var block_chance := 0.0"],
	["scripts/battle.gd", "", "every one of the five fields is read from it", "every one of the five fields is read from it"],
	["scripts/battle.gd", "", "so what is graded and what is DRAWN are the same", "the same / five numbers"],
	["scripts/battle.gd", "", "a member rather than a changed return type because the function has three", "the function has three / call sites"],
	["scripts/events.gd", "", "EVENTS ARE RESOURCE CONVERSIONS NOW", "EVENTS ARE RESOURCE CONVERSIONS NOW"],
]
# ── §3's ROWS ─────────────────────────────────────────────────────────────────
# EVERY TRIGGER THREE CLOSE-READS OWED, BY ITS ROW (C08): JQ's eight rows, JP's two, JO's two. A row carries the trigger, or one the
# owed phrase contains — which routes every brief naming it.
const OWED := {
	"### FOUND AT JJ AND NOT FIXED": ["credit nobody", "kill term"],
	"### Carried, with measurements attached": ["re-tune", "every text that states it"],
	"### THE SHARE CENSUS": ["Encumbered", "warband cooldowns"],
	"### THE TALENT LAYER IS BUILT (FX); FIVE THINGS IN IT, AND SEVEN OF FW'S EDGES, ARE THE DESIGNER'S": ["Cleanse Debuffs Each Turn"],
	"### THE DRAFT AUDIT": ["ability corpus", "PER_CLASS_DEPTH"],
	"### THE BOSS-PICK POOLS": ["class-wide draft pool"],
	"### THE THREE PRICING QUESTIONS": ["new draft card price", "kit card baseline"],
	"### Carried from the code, reported and deliberately not fixed": ["RECAST_GATED", "new draft card"],
	"### FOUND AT HN AND NOT FIXED": ["condition on", "condition_met"],
	"### Small, and still owed": ["fixed boards", "attacks off"],
	"### FOUND AT GP AND NOT FIXED": ["can be blocked"],
	"### **AND FP's `block_chance` FINDING TRAVELS WITH IT": ["can be blocked"],
}
const ROW_CEILING := 400
const DIAL_ROWS := ["### THE WARBAND's COOLDOWNS", "### WHAT THE RAISE DID, AND THE GAME WITH TALENTS"]
const LEDGER_SAYS := "three warband heals' log lines"
const LEDGER_STALE := "nothing in the game reads it"
const RELICS_STALE := "one per zone-boss kill"
const RELICS_SAYS := "the end boss"
const STRAYS_ITEM := "### FOUND AT JD AND NOT FIXED"
const COUNT_WORDS := {8: "eight", 9: "nine", 10: "ten", 11: "eleven", 12: "twelve"}
# ── §0 and §5 ─────────────────────────────────────────────────────────────────
const ANSWERED := "all accepted as taken"
const OWED_HEAD := "### JQ's RULINGS OWED"
const STRUCK_HEAD := "### ~~JQ's RULINGS OWED~~"
const NEW_OWED_HEAD := "### JR's RULINGS OWED"
const REVERSAL := "**Reversing it**"
const CLERIC_CUT := 0.5
const JQ_FIGURES := {"FORSAKE_TURNS": 3, "READ_THE_TELL_PCT": 20}
const DECK_MD5 := "1d1f37491e4611bb78f94577074ede99"
const READINGS := ["`CLAUDE.md`", "`docs/state.md`"]
const PROJECTED := "\\*\\*PROJECTED FOR [A-Z]{2}\\*\\*"
const NEW_STRUCK_HEAD := "### ~~JR's RULINGS OWED~~"

var _g := Gate.new()
var _docs := {}
var _cache := {}
var _run: Node = null
var _player := {}


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	var t0 := Time.get_ticks_msec()
	print("THE GATE FOR THE RECORD PUT RIGHT, AND THREE CARRIERS MADE MEETABLE")
	_run = root.get_node("/root/Run")
	for p in [String(_run.SAVE_PATH), String(Profile.save_path), String(Relics.SAVE_PATH)]:
		var had := FileAccess.file_exists(p)
		_player[p] = [had, FileAccess.get_file_as_bytes(p) if had else PackedByteArray()]
	_s0_the_record()
	_s1_the_carriers()
	_s2_the_citations()
	_s3_the_index()
	_s4_the_readings()
	_s5_not_done()
	_s6_the_players_files()
	print("\n    runtime %.1f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	_g.report(self)


# ── helpers ─────────────────────────────────────────────────────────────

# A FILE READ ONCE, BY ITS FULL `res://` PATH — written at the call, so `build_pin_manifest.py` binds the holder.
func _doc(path: String) -> String:
	if not _docs.has(path):
		_docs[path] = FileAccess.get_file_as_string(path)
	return _docs[path]


func _flat(s: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(s, " ", true).strip_edges()


# A `## ` or `### ` block by its heading, to the next heading of the same depth or shallower.
func _block(text: String, head: String) -> String:
	var at := text.find("\n" + head)
	if at < 0:
		return ""
	var depth := head.split(" ")[0].length()
	var next := text.find("\n#", at + 1)
	while next >= 0:
		var hashes := 0
		while text[next + 1 + hashes] == "#":
			hashes += 1
		if hashes <= depth and text[next + 1 + hashes] == " ":
			return text.substr(at, next - at)
		next = text.find("\n#", next + 1)
	return text.substr(at)


# THE INDEX's ROW FOR A HEADING: its whole line, or "" when the index holds none.
func _row(state: String, head: String) -> String:
	var a := state.find("<!-- INDEX:BEGIN")
	var b := state.find("<!-- INDEX:END")
	if a < 0 or b < a:
		return ""
	for raw in state.substr(a, b - a).split("\n"):
		var line := String(raw)
		if line.begins_with("- `` " + head + " `` "):
			return line
	return ""


func _triggers(row: String) -> Array:
	var at := row.find("*triggers:* ")
	if at < 0:
		return []
	var out: Array = []
	for t in row.substr(at + 12).split(","):
		out.append(String(t).strip_edges())
	return out


# ── §0 — THE RECORD ───────────────────────────────────────────────────────────

func _s0_the_record() -> void:
	print("\n§0 — JQ's seven rulings answered and archived; the batch's own choices owed with their reversals")
	var state := _doc("res://docs/state.md")
	ok(not state.contains("\n" + OWED_HEAD), "§0: %s is still in the open queue — it was answered" % OWED_HEAD)
	var struck := _flat(_block(_doc("res://DoD-archive/state-archive.md"), STRUCK_HEAD))
	var items := 0
	for n in range(1, 8):
		if struck.contains(" %d. **" % n):
			items += 1
	print("    the archive's struck block: %d of its seven rulings, answered: %s" % [items, str(struck.contains(ANSWERED))])
	ok(struck.contains(ANSWERED) and items == 7, "§0: the archive does not hold JQ's seven rulings struck and answered (%d items)" % items)
	var owed := _block(state, NEW_OWED_HEAD)
	if owed == "":
		owed = _block(_doc("res://DoD-archive/state-archive.md"), NEW_STRUCK_HEAD)
		print("    JR's rulings answered and archived: read struck in the archive")
	var n_owed := 0
	var bare: Array = []
	for raw in owed.split("\n"):
		var line := String(raw)
		if line.length() > 3 and line[0].is_valid_int() and line.substr(1, 2) == ". ":
			n_owed += 1
			if not line.contains(REVERSAL):
				bare.append(line.substr(0, 60))
	print("    the rulings owed: %d items" % n_owed)
	ok(n_owed >= 3 and bare.is_empty(), "§0: the batch's own choices are not each owed with a reversal (%d items; without one: %s)" % [n_owed, bare])


# ── §1 — THE THREE RARE CARRIERS ──────────────────────────────────────────────

func _fight_themes() -> Array:
	var out: Array = []
	for t in (_run.THEMES as Dictionary):
		if (_run.THEMES[t]["nodes"] as Array).has("fight"):
			out.append(t)
	return out


# THE DRAW A FIGHT NODE MAKES, AS `Run.compose` MAKES IT: a theme uniform among the fight themes that can spend the budget exactly,
# then one of that theme's exact-budget combos uniform. The share of fights that field each kind at one budget and roster.
func _draw(budget: int, roster: int, themes: Array) -> Dictionary:
	var key := "%d/%d" % [budget, roster]
	if _cache.has(key):
		return _cache[key]
	var feasible: Array = []
	for t in themes:
		var combos: Array = _run._theme_combos(_run.THEMES[t], budget, roster)
		if not combos.is_empty():
			feasible.append(combos)
	var share := {}
	for combos in feasible:
		var seen := {}
		for c in combos:
			for k in _kinds_in(c):
				seen[k] = int(seen.get(k, 0)) + 1
		for k in seen:
			share[k] = float(share.get(k, 0.0)) + float(seen[k]) / float((combos as Array).size()) / float(feasible.size())
	_cache[key] = share
	return share


func _kinds_in(combo: Array) -> Array:
	var d := {}
	for k in combo:
		d[String(k)] = true
	return d.keys()


# THE BUDGET BAND A TIER ROLLS (`Run.battle_budget`): read off the door, every tier drawn until both ends of its band are met.
func _bands() -> Dictionary:
	var out := {}
	seed(20261109)
	for tier in range(1, int(_run.SLOTS_PER_ZONE)):
		var lo := 1 << 20
		var hi := -1
		for i in 96:
			var b: int = _run.battle_budget(tier)
			lo = mini(lo, b)
			hi = maxi(hi, b)
		out[tier] = [lo, hi]
	return out


func _rates() -> Dictionary:
	var themes := _fight_themes()
	var bands := _bands()
	var per := {}
	for roster in [1, 2, 3]:
		var tot := {}
		var n := 0
		for tier in bands:
			for b in range(int(bands[tier][0]), int(bands[tier][1]) + 1):
				n += 1
				var sh := _draw(b, roster, themes)
				for k in sh:
					tot[k] = float(tot.get(k, 0.0)) + float(sh[k])
		for k in tot:
			tot[k] = float(tot[k]) / float(n)
		per[roster] = tot
	return per


func _s1_the_carriers() -> void:
	print("\n§1 — the three rare carriers fielded more often, derived off the data; every hex on its carrier; no rule-fielded kind drawn")
	var data: Dictionary = Enemies._load()
	# THE TAGS, AS JR SET THEM.
	for kind in AS_JR:
		var kd: Dictionary = data.get(kind, {})
		for field in AS_JR[kind]:
			ok(JSON.stringify(kd.get(field, [])) == JSON.stringify(AS_JR[kind][field]),
				"§1: %s's %s is %s, not the %s JR set" % [kind, field, str(kd.get(field, [])), str(AS_JR[kind][field])])
	# C01 — DERIVED OFF THE DATA, THROUGH THE COMPOSER's OWN DOOR: HEAD's tags put in, derived, and put back.
	var kept := {}
	for kind in AS_HEAD:
		if data.has(kind):
			for field in AS_HEAD[kind]:
				kept["%s/%s" % [kind, field]] = (data[kind] as Dictionary).get(field, []).duplicate()
				(data[kind] as Dictionary)[field] = (AS_HEAD[kind][field] as Array).duplicate()
	_cache.clear()
	var per_head := _rates()
	for key in kept:
		var bits := String(key).split("/")
		(data[bits[0]] as Dictionary)[bits[1]] = kept[key]
	_cache.clear()
	var per := _rates()
	for kind in CARRIERS:
		var mean := 0.0
		var cells: Array = []
		for roster in [1, 2, 3]:
			var r := float((per[roster] as Dictionary).get(kind, 0.0))
			mean += r / 3.0
			cells.append("%.4f" % r)
		var head_mean := 0.0
		for roster in [1, 2, 3]:
			head_mean += float((per_head[roster] as Dictionary).get(kind, 0.0)) / 3.0
		print("    %s: fielded in %.4f of fight draws (rosters %s); %.4f with HEAD's tags; %.4f and %.4f recorded" % [kind, mean, ", ".join(cells),
			head_mean, float(RATE_AT_HEAD[kind]), float(RATE_AT_JR[kind])])
		ok(absf(head_mean - float(RATE_AT_HEAD[kind])) < 0.0005, "§1: %s's rate with HEAD's tags derives %.4f, not the %.4f JR recorded" % [kind, head_mean, float(RATE_AT_HEAD[kind])])
		ok(mean >= float(RATE_AT_HEAD[kind]) * MATERIALLY,
			"§1: %s is fielded in %.4f of fight draws — not materially more than the %.4f it was (x%.1f wanted)" % [kind, mean, float(RATE_AT_HEAD[kind]), MATERIALLY])
		ok(absf(mean - float(RATE_AT_JR[kind])) < 0.0005, "§1: %s's derived rate %.4f is not the %.4f JR recorded" % [kind, mean, float(RATE_AT_JR[kind])])
		ok(not cells.has("0.0000"), "§1: %s is still absent from a roster's fights: %s" % [kind, str(cells)])
	# C02 — EVERY HEX ON ITS ONE CARRIER.
	var carriers := {}
	for kind in data:
		for a in (data[kind] as Dictionary).get("abilities", []):
			var st: Variant = (a as Dictionary).get("applies_status", null)
			if st is Dictionary and HEX_CARRIER.has(String(st.get("id", ""))):
				var h := String(st["id"])
				if not carriers.has(h):
					carriers[h] = []
				if not (carriers[h] as Array).has(kind):
					(carriers[h] as Array).append(kind)
	print("    the hexes' carriers: %s" % str(carriers))
	for h in HEX_CARRIER:
		ok(carriers.get(h, []) == [HEX_CARRIER[h]], "§1: %s is laid by %s, not by %s alone — a hex moved or a carrier was added" % [h, str(carriers.get(h, [])), HEX_CARRIER[h]])
	# C03 — A KIND FIELDED BY A RULE IS NEVER DRAWN BY A FIGHT, AND NONE OF THE THREE IS ONE.
	var ruled: Array = []
	for kind in data:
		for role in RULE_ROLES:
			if ((data[kind] as Dictionary).get("roles", []) as Array).has(role) and not ruled.has(kind):
				ruled.append(kind)
	ruled.sort()
	var want := RULE_FIELDED.duplicate()
	want.sort()
	print("    fielded by a rule: %s" % str(ruled))
	ok(ruled == want, "§1: the kinds fielded by a rule are %s, not %s — a boss or an elite was added or taken off its rule" % [str(ruled), str(want)])
	for kind in ruled:
		var drawn := 0.0
		for roster in [1, 2, 3]:
			drawn += float((per[roster] as Dictionary).get(kind, 0.0))
		ok(drawn == 0.0, "§1: %s, fielded by a rule, is drawn by a fight node (%.4f summed over the rosters)" % [kind, drawn])
	for kind in CARRIERS:
		ok(not ruled.has(kind), "§1: %s is fielded by a rule, and making it common is not what JR did" % kind)
	var named: Array = []
	for z in (_run.ZONE_DEFS as Dictionary):
		named.append(String(_run.ZONE_DEFS[z]["boss"]))
	for b in named:
		ok(ruled.has(b), "§1: the zone boss %s carries no boss role" % b)
	# C15 — NOTHING ELSE IN THE WARBAND's DATA MOVED.
	var as_head: Dictionary = data.duplicate(true)
	for kind in AS_HEAD:
		if as_head.has(kind):
			for field in AS_HEAD[kind]:
				(as_head[kind] as Dictionary)[field] = (AS_HEAD[kind][field] as Array).duplicate()
	var d := JSON.stringify(as_head, "", true).md5_text()
	print("    the warband's data with the three tags put back: %s" % d)
	ok(d == WARBAND_AT_HEAD_MD5, "§1: something in the warband's data moved besides the three tags — a move, a figure, a kind")


# ── §2 — A CITATION IS THE TEXT ───────────────────────────────────────────────

# EVERY NAME A CITATION CAN CARRY: a path, a basename, a stem of a code or document file, a two-letter suite or gate code, a
# `test_` stem, a batch's report by its code.
func _names() -> Dictionary:
	var out := {}
	var stack: Array = ["res://"]
	while not stack.is_empty():
		var dir := String(stack.pop_back())
		var da := DirAccess.open(dir)
		if da == null:
			continue
		for sub in da.get_directories():
			if not String(sub).begins_with(".") and sub != "lanes" and sub != "save-backups":
				stack.append(dir.path_join(sub))
		for f in da.get_files():
			var rel := dir.path_join(f).trim_prefix("res://")
			out[rel] = true
			out[String(f)] = true
			var ext := String(f).get_extension()
			if ext in ["gd", "py", "sh", "md", "html", "json", "tscn", "tsv"]:
				out[String(f).get_basename()] = true
				out[rel.get_basename()] = true
			var rx := RegEx.new()
			rx.compile("^(?:test_batch_|check_)([a-z]{2})\\.gd$")
			var m := rx.search(String(f))
			if m != null:
				out[m.get_string(1)] = true
			if String(f).begins_with("test_") and ext == "gd":
				out[String(f).get_basename().trim_prefix("test_")] = true
			if dir.ends_with("reports") and String(f).length() == 5 and ext == "md":
				out[String(f).get_basename()] = true
	return out


const NUMS := "\\d+(?:\\s*[-–]\\s*\\d+)?(?:\\s*[,/]\\s*\\d+(?:\\s*[-–]\\s*\\d+)?)*"
const EXT := "(?:\\.(?:gd|py|sh|json|md|html|tscn|tsv|cfg|godot))?"


func _rx(p: String) -> RegEx:
	var r := RegEx.new()
	r.compile(p)
	return r


# THE FOUR SPELLINGS: <name>:N, `<name>`:N, a backticked `:N`, and a bare :N after a space or a bracket. The first two count only
# where the name is a file of the tree (`{mhp:5}` is a stat's notation).
func _citations(text: String, names: Dictionary) -> Array:
	var out: Array = []
	var a := _rx("(?<![A-Za-z0-9_./-])((?:res://)?[A-Za-z_][A-Za-z0-9_./-]*?" + EXT + "):" + NUMS + "(?![A-Za-z0-9%])")
	var b := _rx("`((?:res://)?[A-Za-z_][A-Za-z0-9_./-]*?" + EXT + ")`:" + NUMS + "(?![A-Za-z0-9%])")
	var c := _rx("`:" + NUMS + "`")
	var d := _rx("(?<=[\\s(\\[/,;]):" + NUMS + "(?![A-Za-z0-9%:])")
	for r in [a, b]:
		for m in r.search_all(text):
			if names.has(m.get_string(1).trim_prefix("res://")):
				out.append(m.get_string())
	for r in [c, d]:
		for m in r.search_all(text):
			out.append(m.get_string())
	return out


# A REPORT's FENCED BLOCKS ARE QUOTED OUTPUT: the scan reads around them.
func _unfenced(text: String) -> String:
	var out: PackedStringArray = []
	var fence := false
	for raw in text.split("\n"):
		var line := String(raw)
		if line.strip_edges().begins_with("```"):
			fence = not fence
			continue
		if not fence:
			out.append(line)
	return "\n".join(out)


func _line_words(text: String) -> Array:
	var out: Array = []
	for m in _rx("(?i)\\blines? ~?\\d{2,}").search_all(text):
		out.append(m.get_string())
	return out


func _l_words(text: String) -> Array:
	var out: Array = []
	for m in _rx("\\bL\\d{3,}\\b").search_all(text):
		out.append(m.get_string())
	return out


func _s2_the_citations() -> void:
	print("\n§2 — no line-number citation in a document this gate holds; the rule stands; every excluded kind named here")
	var names := _names()
	# THE SCANNER SEES EACH SPELLING — a broken pattern reads as a clean tree.
	var planted := "`battle.gd:12`, check_gx:412, `unit.gd`:9, `:13`, and :14 — not {mhp:5} nor 13:42:22"
	var seen := _citations(planted, names)
	print("    the four spellings, planted: %s" % str(seen))
	ok(seen.size() == 5, "§2: the scanner does not see the four spellings it holds (%d of 5 planted: %s)" % [seen.size(), str(seen)])
	# THE POPULATION: the held documents and every report, each read here or excluded here.
	var held: Array = HELD.duplicate()
	var reports := DirAccess.open("res://docs/reports")
	var listed := 0
	var excluded := {}
	for f in reports.get_files():
		var ext := "." + String(f).get_extension()
		if EXCLUDED_KINDS.has(ext):
			excluded[ext] = int(excluded.get(ext, 0)) + 1
			continue
		listed += 1
		held.append("res://docs/reports/" + String(f))
	var md_count := 0
	for f in reports.get_files():
		if String(f).ends_with(".md"):
			md_count += 1
	var unnamed: Array = []
	for f in reports.get_files():
		var ext := "." + String(f).get_extension()
		if ext != ".md" and not EXCLUDED_KINDS.has(ext):
			unnamed.append(f)
	ok(unnamed.is_empty(), "§2: a kind of record in the reports is neither held nor excluded by name: %s" % str(unnamed))
	for k in EXCLUDED_KINDS:
		ok(String(EXCLUDED_KINDS[k]).length() > 40, "§2: the excluded kind %s carries no reason" % k)
	print("    excluded by kind: %s" % str(excluded))
	var found: Array = []
	var words: Array = []
	var report_words := 0
	var report_l := 0
	var checked := 0
	var rare := {}
	for k in RARE_SPELLINGS:
		rare[k] = 0
	for p in held:
		var t := _doc(String(p))
		if String(p).begins_with("res://docs/reports/"):
			t = _unfenced(t)
		for k in RARE_SPELLINGS:
			var hits := _rx(String(RARE_SPELLINGS[k][0])).search_all(t).size()
			if String(p).begins_with("res://docs/reports/"):
				rare[k] = int(rare[k]) + hits
			elif hits > 0:
				words.append("%s: %d of %s" % [String(p).trim_prefix("res://"), hits, k])
		if t == "":
			continue
		checked += 1
		for c in _citations(t, names):
			found.append("%s: %s" % [String(p).trim_prefix("res://"), c])
		var w := _line_words(t)
		var lw := _l_words(t)
		if String(p).begins_with("res://docs/reports/"):
			report_words += w.size()
			report_l += lw.size()
		else:
			for x in w + lw:
				words.append("%s: %s" % [String(p).trim_prefix("res://"), x])
	print("    CHECKED %d of %d documents held at zero (%d reports); %d citations" % [checked, held.size(), listed, found.size()])
	ok(checked == held.size() and listed == md_count and listed > 150,
		"§2: a held document was not read (%d of %d; %d of the %d reports)" % [checked, held.size(), listed, md_count])
	ok(found.is_empty(), "§2: a line-number citation stands in a held document: %s" % str(found.slice(0, 8)))
	ok(words.is_empty(), "§2: a living document spells a line number another way: %s" % str(words.slice(0, 8)))
	print("    the reports' other spellings: line N %d, held at %d; L N %d, held at %d" % [report_words, LINE_WORD_REPORTS, report_l, LINE_L_REPORTS])
	ok(report_words <= LINE_WORD_REPORTS, "§2: a report spells a line number another way — %d, above the %d held" % [report_words, LINE_WORD_REPORTS])
	ok(report_l <= LINE_L_REPORTS, "§2: a report spells a line number as L N — %d, above the %d held" % [report_l, LINE_L_REPORTS])
	for k in RARE_SPELLINGS:
		print("    the reports' %s: %d, held at %d" % [k, int(rare[k]), int(RARE_SPELLINGS[k][1])])
		ok(int(rare[k]) <= int(RARE_SPELLINGS[k][1]), "§2: a report spells a line number as %s — %d, above the %d held" % [k, int(rare[k]), int(RARE_SPELLINGS[k][1])])
	for p in CEILINGS:
		var n := _citations(_doc(String(p)), names).size()
		print("    held at its count: %s %d (ceiling %d)" % [String(p).trim_prefix("res://"), n, int(CEILINGS[p])])
		ok(n <= int(CEILINGS[p]), "§2: a line-number citation was written into %s (%d, above its %d)" % [p, n, int(CEILINGS[p])])
		if n < int(CEILINGS[p]):
			print("  [notice] §2: %s holds %d, under its ceiling %d — lower the ceiling" % [p, n, int(CEILINGS[p])])
	# THE GAME's OWN SCRIPTS, HELD AT ZERO IN THE TWO SPELLINGS THAT NAME A FILE (a comment is an asserted surface).
	var code_found: Array = []
	var scripts := DirAccess.open("res://scripts")
	var n_scripts := 0
	for f in scripts.get_files():
		if String(f).ends_with(".gd"):
			n_scripts += 1
			for c in _citations(FileAccess.get_file_as_string("res://scripts/" + String(f)), names):
				if not String(c).begins_with(":") and not String(c).begins_with("`:"):
					code_found.append("scripts/%s: %s" % [f, c])
	print("    CHECKED %d game scripts; %d citations" % [n_scripts, code_found.size()])
	ok(n_scripts > 20 and code_found.is_empty(), "§2: a line-number citation stands in the game's code: %s" % str(code_found.slice(0, 8)))
	# C06 — THE RULE.
	ok(_flat(_doc("res://docs/ways-of-working.md")).contains(CITE_RULE), "§2: the citation rule is not in docs/ways-of-working.md")
	# THE STATE's REPLACEMENTS QUOTE WHAT STANDS.
	var gone: Array = []
	var unsaid: Array = []
	var st_flat := _flat(_doc("res://docs/state.md"))
	for q in STATE_QUOTES:
		var path := "res://" + String(q[0])
		var body := FileAccess.get_file_as_string(path) if String(q[1]) == "" else Gate.fn_body(String(q[0]), String(q[1]), _cache)
		if not body.contains(String(q[2])):
			gone.append("%s %s: %s" % [q[0], q[1], q[2]])
		if String(q[3]) != "" and not st_flat.contains(_flat(String(q[3]))):
			unsaid.append("%s: %s" % [q[0], q[3]])
	print("    the state's words for them: %d of %d stand" % [STATE_QUOTES.size() - unsaid.size(), STATE_QUOTES.size()])
	ok(unsaid.is_empty(), "§2: the state no longer cites a quote this gate holds — re-point the pair: %s" % str(unsaid))
	print("    the state's quotes: %d of %d stand" % [STATE_QUOTES.size() - gone.size(), STATE_QUOTES.size()])
	ok(gone.is_empty(), "§2: a quote the state cites no longer stands where it says: %s" % str(gone))


# ── §3 — THE INDEX AND THREE STALE CLAIMS ─────────────────────────────────────

func _s3_the_index() -> void:
	print("\n§3 — every owed trigger in its row; the dials named; no row names nothing; three stale claims put right")
	var state := _doc("res://docs/state.md")
	var missing: Array = []
	var over: Array = []
	var archived_rows: Array = []
	for head in OWED:
		var row := _row(state, String(head))
		if row == "" and not state.contains("\n" + String(head)):
			archived_rows.append(head)
			continue
		var trig := _triggers(row)
		if row.to_utf8_buffer().size() > ROW_CEILING:
			over.append("%s (%d B)" % [head, row.to_utf8_buffer().size()])
		for want in OWED[head]:
			var met := false
			for t in trig:
				if String(t) == String(want) or (String(t).length() >= 4 and String(want).contains(String(t))):
					met = true
			if not met:
				missing.append("%s: %s" % [head, want])
	print("    owed triggers: %d rows, %d still owed; rows over %d B: %s; rows gone with their archived blocks: %s" % [OWED.size(), missing.size(), ROW_CEILING, str(over), str(archived_rows)])
	ok(missing.is_empty(), "§3: a trigger a close-read owed is still owed: %s" % str(missing))
	ok(over.is_empty(), "§3: a row passes %d bytes: %s" % [ROW_CEILING, str(over)])
	for head in DIAL_ROWS:
		var named := false
		for t in _triggers(_row(state, head)):
			if String(t).begins_with("dial"):
				named = true
		ok(named, "§3: %s took a dial and no trigger in its row names one" % head)
	# C12 — EVERY BLOCK A ROW NAMES EXISTS.
	var a := state.find("<!-- INDEX:BEGIN")
	var b := state.find("<!-- INDEX:END")
	var dead: Array = []
	for m in _rx("`` (#{2,3} [^`]+?) ``").search_all(state.substr(a, b - a)):
		var h := m.get_string(1)
		if not state.contains("\n" + h):
			dead.append(h)
	for m in _rx("holds others \\(([^)]*)\\)").search_all(state.substr(a, b - a)):
		for nm in m.get_string(1).split(", "):
			var name := String(nm).strip_edges()
			if name == "" or name.begins_with("the ") or name.begins_with("its "):
				continue
			if not state.contains("\n### " + name) and not state.contains("\n## " + name):
				dead.append(name)
	print("    blocks the index names that do not exist: %s" % str(dead))
	ok(dead.is_empty(), "§3: the index names a block that does not exist: %s" % str(dead))
	# C13 — THE LEDGER's COMMENT.
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var at := bsrc.find("\nvar malice_ledger")
	var above := bsrc.substr(maxi(at - 400, 0), 400)
	var reads := Gate.fn_body("scripts/battle.gd", "_resolve_special", _cache).count("int(malice_ledger[\"spent\"])")
	print("    the ledger's spent read by %d lines in the warband's heals (two a heal)" % reads)
	ok(not above.contains(LEDGER_STALE) and above.contains(LEDGER_SAYS) and reads == 6,
		"§3: the Malice ledger's comment does not say what reads it (%d reads in the heals)" % reads)
	# C13 — RELICS' HEADER.
	var rsrc := FileAccess.get_file_as_string("res://scripts/relics.gd")
	var head_txt := rsrc.substr(0, maxi(rsrc.find("class_name"), 0))
	var unlocks := Gate.fn_body("scripts/battle.gd", "_resolve_boss", _cache)
	ok(not head_txt.contains(RELICS_STALE) and head_txt.contains(RELICS_SAYS) and unlocks.find("Relics.unlock_random()") >= 0
		and unlocks.find("Relics.unlock_random()") < unlocks.find("if not is_end"),
		"§3: relics.gd's header does not say every boss kill hands a relic, the end boss's included")
	# C13 — THE STRAYS' COUNT.
	var strays: Variant = (load("res://check_iu.gd") as Script).get_script_constant_map().get("KNOWN_STRAYS", null)
	var n := (strays as Dictionary).size() if strays is Dictionary else -1
	var said := _rx("(\\w+) names in `check_iu`").search(state)
	print("    KNOWN_STRAYS holds %d; the state says %s" % [n, said.get_string(1) if said != null else "nothing (the item closed)"])
	ok(n > 0 and (said == null or (COUNT_WORDS.has(n) and said.get_string(1) == COUNT_WORDS[n])),
		"§3: the strays' count the state gives is not KNOWN_STRAYS' %d" % n)


# ── §4 — THE TWO READINGS ─────────────────────────────────────────────────────

func _s4_the_readings() -> void:
	print("\n§4 — both files read at the open and the close, and the room projected for the next batch")
	var where := _block(_doc("res://docs/state.md"), "## WHERE THE PROJECT IS")
	for f in READINGS:
		var hit := false
		for raw in where.split("\n"):
			var line := String(raw)
			if line.contains(String(f)) and line.contains("at the open") and line.contains("at the close"):
				hit = true
		ok(hit, "§4: the WHERE block does not read %s at the open and at the close" % f)
	ok(_rx(PROJECTED).search(where) != null, "§4: the WHERE block projects no room for the next batch (no PROJECTED FOR line)")


# ── §5 — WHAT IS DELIBERATELY NOT DONE ────────────────────────────────────────

func _s5_not_done() -> void:
	print("\n§5 — no dial pulled, no figure of JQ's moved, the deck at twenty-five")
	var cut: Variant = (load("res://scripts/unit.gd") as Script).get_script_constant_map().get("CLERIC_MANA_CUT")
	ok(cut != null and absf(float(cut) - CLERIC_CUT) < 0.0001, "§5: the Cleric's cut was pulled (%s)" % str(cut))
	var bc := (load("res://scripts/battle.gd") as Script).get_script_constant_map()
	for k in JQ_FIGURES:
		ok(bc.get(k) != null and int(bc[k]) == int(JQ_FIGURES[k]), "§5: %s moved (%s, JQ's %d)" % [k, str(bc.get(k)), int(JQ_FIGURES[k])])
	var deck: Array = (_run.MODIFIERS as Dictionary).keys()
	deck.sort()
	ok(deck.size() == DECK_CLOSED_AT and ("%d|" % deck.size() + "|".join(deck)).md5_text() == DECK_MD5,
		"§5: the deck holds %d, not the twenty-five it closed at, or a card was swapped in it" % deck.size())


# ── §6 — THE PLAYER's FILES ───────────────────────────────────────────────────

func _s6_the_players_files() -> void:
	print("\n§6 — the player's files, as this gate found them")
	for p in _player:
		var had: bool = _player[p][0]
		var now := FileAccess.file_exists(p)
		var same: bool = now == had and (not had or FileAccess.get_file_as_bytes(p) == _player[p][1])
		ok(same, "§6: %s changed under this gate" % p)
