# BATCH JV — THE COMPOSER DRAWS A WARBAND WITHOUT LISTING THEM, AND DRAWS THE ONE THE LIST WOULD HAVE.
#
#   §0   THE POPULATION IS LIVE: the themes, the rosters the zones name, the budgets the game rolls
#   §1   THE DRAW IS THE LIST: every roster, theme, budget and zone boss's escort — the count is the list's size,
#        and the i-th warband found without listing is the list's i-th
#   §2   ONE DIE, THE SAME DIE: the game's three callers draw what the list and `pick_random` drew, seed for seed,
#        and leave the same die behind; a theme that cannot spend its budget spends none
#   §3   NO GAME PATH LISTS: no script calls the list but its own file's definition, and the callers draw
#   §4   THE COST: six kinds more in one roster multiply the list and not the draw's work
#   §5   THE RECORD: the two rulings blocks the batch answered stand archived, not owed; the Lane B floor's recon clause and the
#        record's two habits stand where they landed
#
# ── WHY THIS GATE EXISTS ────────────────────────────────────────────────────
# `Run._theme_combos` lists every warband a theme can field at a budget, and
# every kind a roster holds multiplied that list, so a roster's kind count set
# what a map cost to build (`docs/reports/JU.md` §1). The designer's decision
# (`docs/reports/JV.md`): it stops doing so. `Run._theme_pick` counts the list
# without building it and walks to the warband the die names; `pick_random()`
# is `arr[randi() % arr.size()]` and spends one die, so the draw takes
# `randi() % count` and the same seed draws the same warband. **That is a claim
# about two pieces of code that must stay one answer**, and the list stays in
# the tree — two gates derive over every warband through it — so the draw is
# held to it here: count, order and die.
#
# ── WHAT IT CANNOT DO, SAID FIRST ───────────────────────────────────────────
# §1 holds the draw to the list on the rosters and themes the tree holds and on
# the budgets the game rolls and two past them; a theme or roster added later
# is read by doing nothing, a budget past those is not. §4 counts the draw's
# work in memo states, which is deterministic, and prints milliseconds it does
# not assert: a wall clock on a loaded machine is not a figure (`check_map`'s
# bound is untouched). The six kinds §4 adds are copies of kinds the roster
# holds, put into the loaded data and taken out again; nothing is written.
extends SceneTree

const Gate = preload("res://gate_fixture.gd")

var _g := Gate.new()
var _run: Node = null
var _cache := {}

const RUN_STATE := "scripts/run_state.gd"
# The game's callers of the composer, each drawing through the draw's door.
const CALLERS := ["compose", "compose_test", "compose_budget"]
# §4's six stand-ins, one of each role in this order, copied from the roster's own kinds.
const STANDIN_ROLES := ["skirmisher", "sniper", "bulwark", "mender", "hexer", "brute"]
const SEEDS := 40
# §5's needles, each read in its file with its line breaks flattened.
const STATE := "res://docs/state.md"
const ARCHIVE := "res://DoD-archive/state-archive.md"
const RULES := "res://docs/instrument-rules.md"
const WOW := "res://docs/ways-of-working.md"
const OWED_LIVE := ["\n### JU's RULINGS OWED", "\n### JT's RULINGS OWED"]
const OWED_STRUCK := ["\n### ~~JU's RULINGS OWED~~", "\n### ~~JT's RULINGS OWED~~"]
const LANE_B := "**LANE B, CONTENT"
const LANE_C := "**LANE C, RECORD"
const RECON_CLAUSE := "A RECON WHEN ITS CONTENT REACHES A GATE's `ADDED_SINCE` OR THE COMPOSER"
const HABITS := ["is named as a report names it, or it is an open question", "is pasted, not paraphrased",
	"say what population each was read on"]


func ok(cond: bool, what: String) -> void:
	_g.ok(cond, what)


func _initialize() -> void:
	await process_frame
	print("BATCH JV — THE COMPOSER DRAWS A WARBAND WITHOUT LISTING THEM, AND DRAWS THE ONE THE LIST WOULD HAVE")
	_run = root.get_node("/root/Run")
	var pop := _s0_the_population()
	# A tree without the draw (HEAD's, under a control) reds here and reads nothing past it, rather than throwing.
	var has_draw: bool = _run.has_method("_theme_pick") and _run.has_method("_draw_frame") and _run.has_method("_theme_count")
	ok(has_draw, "§0: Run holds no draw (_theme_pick, _draw_frame, _theme_count) — the composer lists again")
	if has_draw:
		_s1_the_draw_is_the_list(pop)
		_s2_one_die(pop)
		_s3_no_game_path_lists()
		_s4_the_cost()
	_s5_the_record()
	_g.report(self)


# ── §0 — THE POPULATION ─────────────────────────────────────────────────────
func _s0_the_population() -> Dictionary:
	print("\n§0 — the themes, the rosters the zones name and the budgets the game rolls")
	var rosters: Array = []
	var bosses: Array = [""]
	for z in (_run.ZONE_DEFS as Dictionary):
		for slot in (_run.ZONE_DEFS[z]["rosters"] as Dictionary):
			var r := int(_run.ZONE_DEFS[z]["rosters"][slot])
			if not rosters.has(r):
				rosters.append(r)
		bosses.append(String(_run.ZONE_DEFS[z]["boss"]))
	rosters.sort()
	# The budgets: every one the game rolls (the boss node's band is the top), and two past them.
	seed(20261112)
	var top := 0
	for i in 400:
		top = maxi(top, int(_run.battle_budget(int(_run.SLOTS_PER_ZONE))))
	var budgets: Array = []
	for b in range(1, top + 3):
		budgets.append(b)
	print("    %d themes; rosters %s; zone bosses %s; budgets 1 to %d (the game's top %d, and two past)" % [
		(_run.THEMES as Dictionary).size(), str(rosters), str(bosses.slice(1)), budgets[-1], top])
	ok((_run.THEMES as Dictionary).size() >= 10, "§0: Run.THEMES holds %d themes — the population has stopped reading it" % (_run.THEMES as Dictionary).size())
	ok(rosters.size() >= 3 and bosses.size() >= 4, "§0: the zones name %d rosters and %d bosses — ZONE_DEFS has stopped being read" % [rosters.size(), bosses.size() - 1])
	ok(top >= 10, "§0: the boss node's band tops out at %d — battle_budget has stopped being read" % top)
	return {"rosters": rosters, "bosses": bosses, "budgets": budgets}


# ── §1 — THE DRAW IS THE LIST ──────────────────────────────────────────────
func _s1_the_draw_is_the_list(pop: Dictionary) -> void:
	print("\n§1 — every roster, theme, budget and escort: the count is the list's size, and the i-th found is the list's i-th")
	var lists := 0
	var warbands := 0
	var checked := 0
	var t0 := Time.get_ticks_msec()
	for roster in pop["rosters"]:
		for theme in (_run.THEMES as Dictionary):
			var spec: Dictionary = _run.THEMES[theme]
			for boss in (pop["bosses"] if (spec["pool"] as Dictionary).has("boss") else [""]):
				var bad: Array = []
				for b in pop["budgets"]:
					var lst: Array = _run._theme_combos(spec, b, roster, boss)
					var dw: Dictionary = _run._draw_frame(spec, b, roster, boss)
					var n: int = _run._draw_total(dw)
					lists += 1
					warbands += lst.size()
					if n != lst.size():
						bad.append("budget %d: count %d, list %d" % [b, n, lst.size()])
						continue
					for i in n:
						checked += 1
						if _run._draw_unrank(dw, i) != lst[i]:
							bad.append("budget %d: the %d-th found is %s, the list's %s" % [b, i, str(_run._draw_unrank(dw, i)), str(lst[i])])
							break
					var past: Array = _run._theme_at(spec, b, n, roster, boss)
					if not past.is_empty():
						bad.append("budget %d: the index past the count found %s" % [b, str(past)])
				ok(bad.is_empty(), "§1: roster %d, %s%s — the draw is not the list: %s" % [
					roster, theme, (" (%s)" % boss) if boss != "" else "", "; ".join(PackedStringArray(bad.slice(0, 3)))])
	print("    CHECKED %d lists, %d warbands, every one found without listing and compared: %d (%d ms)" % [
		lists, warbands, checked, Time.get_ticks_msec() - t0])
	ok(warbands > 10000 and checked == warbands, "§1: %d of %d warbands compared — a list disagreed, or the comparison stopped walking the lists" % [checked, warbands])


# The draw HEAD made, as HEAD's code made it: the list, then `pick_random`.
func _old_pick(spec: Dictionary, b: int, roster: int, boss: String) -> Array:
	var c: Array = _run._theme_combos(spec, b, roster, boss)
	return [] if c.is_empty() else (c.pick_random() as Array).duplicate()


# `compose` as HEAD wrote it, the list in the draw's place: the budget, the elite floor, the themes shuffled, the first
# that can spend it, its warband shuffled; the plain-mob fallback is not reached on the tree's data (§2 says if it is).
func _old_compose(node_type: String, tier: int) -> Array:
	var budget: int = _run.battle_budget(tier)
	if node_type in ["elite", "miniboss"]:
		budget = maxi(budget, 6)
	var theme_key := "elite" if node_type == "miniboss" else node_type
	var named_boss: String = _run.boss_kind() if node_type == "boss" else ""
	var candidates: Array = []
	for t in (_run.THEMES as Dictionary):
		if (_run.THEMES[t]["nodes"] as Array).has(theme_key):
			candidates.append(t)
	candidates.shuffle()
	for t in candidates:
		var w := _old_pick(_run.THEMES[t], budget, -1, named_boss)
		if w.is_empty():
			continue
		w.shuffle()
		return [t, w]
	return ["FALLBACK", []]


# ── §2 — ONE DIE, THE SAME DIE ─────────────────────────────────────────────
func _s2_one_die(pop: Dictionary) -> void:
	print("\n§2 — the game's callers draw what the list and pick_random drew, seed for seed, and leave the same die")
	# The run's zones are drawn on the first read of the zone (`current_zone_id`), which spends dice once: read it before
	# any seed, or the side that reads it first spends what the other does not.
	_run.current_zone_id()
	var nodes := [["fight", 1], ["fight", 6], ["fight", 11], ["fight", 15], ["elite", 4], ["miniboss", 8], ["boss", 16]]
	for nd in nodes:
		var differ: Array = []
		var fell := 0
		for s in SEEDS:
			seed(7001 + s)
			var want := _old_compose(String(nd[0]), int(nd[1]))
			var die_want := randi()
			seed(7001 + s)
			var got: Array = _run.compose(String(nd[0]), int(nd[1]))
			var theme_got: String = _run.last_theme
			var die_got := randi()
			if String(want[0]) == "FALLBACK":
				fell += 1
				continue
			if got != want[1] or theme_got != String(want[0]) or die_got != die_want:
				differ.append("seed %d: %s %s, die %d — the list drew %s %s, die %d" % [7001 + s, theme_got, str(got), die_got, want[0], str(want[1]), die_want])
		ok(differ.is_empty() and fell == 0, "§2: compose(\"%s\", %d) — %d of %d seeds differ from the list's draw (%s), %d fell back" % [
			nd[0], nd[1], differ.size(), SEEDS, "; ".join(PackedStringArray(differ.slice(0, 2))), fell])
	# compose_test and compose_budget, every roster.
	var differ_t: Array = []
	var differ_b: Array = []
	var drawn_t := 0
	var drawn_b := 0
	for roster in pop["rosters"]:
		for s in SEEDS:
			var b := 3 + (s % 10)
			for theme in (_run.THEMES as Dictionary):
				seed(9001 + s)
				var want := _old_pick(_run.THEMES[theme], b, roster, "")
				want.shuffle()
				var die_want := randi()
				seed(9001 + s)
				var got: Array = _run.compose_test(theme, b, roster)
				if not got.is_empty():
					drawn_t += 1
				if got != want or randi() != die_want:
					differ_t.append("%s roster %d budget %d seed %d" % [theme, roster, b, 9001 + s])
			seed(9501 + s)
			var fights: Array = []
			for t in (_run.THEMES as Dictionary):
				if (_run.THEMES[t]["nodes"] as Array).has("fight"):
					fights.append(t)
			fights.shuffle()
			var wb: Array = []
			for t in fights:
				wb = _old_pick(_run.THEMES[t], b, roster, "")
				if not wb.is_empty():
					wb.shuffle()
					break
			var die_b := randi()
			seed(9501 + s)
			var got_b: Array = _run.compose_budget(b, roster)
			if not got_b.is_empty():
				drawn_b += 1
			if got_b != wb or randi() != die_b:
				differ_b.append("roster %d budget %d seed %d" % [roster, b, 9501 + s])
	print("    compose_test: %d warbands drawn and compared; compose_budget: %d" % [drawn_t, drawn_b])
	ok(drawn_t > 1000 and drawn_b > 100, "§2: compose_test drew %d warbands and compose_budget %d — the comparison has stopped drawing" % [drawn_t, drawn_b])
	ok(differ_t.is_empty(), "§2: compose_test — %d draws differ from the list's: %s" % [differ_t.size(), ", ".join(PackedStringArray(differ_t.slice(0, 3)))])
	ok(differ_b.is_empty(), "§2: compose_budget — %d draws differ from the list's: %s" % [differ_b.size(), ", ".join(PackedStringArray(differ_b.slice(0, 3)))])
	# A theme that cannot spend its budget spends no die, as an empty list spent none.
	var spent := 0
	var empties := 0
	for roster in pop["rosters"]:
		for theme in (_run.THEMES as Dictionary):
			for b in [1, 2]:
				if _run._theme_count(_run.THEMES[theme], b, roster) != 0:
					continue
				empties += 1
				seed(4242)
				var d0 := randi()
				seed(4242)
				var w: Array = _run._theme_pick(_run.THEMES[theme], b, roster)
				if not w.is_empty() or randi() != d0:
					spent += 1
	print("    %d themes and budgets that cannot be spent drawn; %d spent a die or found a warband" % [empties, spent])
	ok(empties > 0 and spent == 0, "§2: of %d draws that can find nothing, %d spent a die or found a warband" % [empties, spent])


# ── §3 — NO GAME PATH LISTS ────────────────────────────────────────────────
func _s3_no_game_path_lists() -> void:
	print("\n§3 — no game script calls the list but its definition, and the game's callers draw")
	var calls: Array = []
	var files := 0
	var defs := 0
	var dir := "res://scripts"
	for f in DirAccess.get_files_at(dir):
		if not f.ends_with(".gd"):
			continue
		files += 1
		var src := Gate.strip_comments(FileAccess.get_file_as_string("%s/%s" % [dir, f]))
		var at := src.find("_theme_combos(")
		while at >= 0:
			var line_start := src.rfind("\n", at) + 1
			var line := src.substr(line_start, src.find("\n", at) - line_start)
			if line.strip_edges().begins_with("func _theme_combos("):
				defs += 1
			else:
				calls.append("%s: %s" % [f, line.strip_edges().left(70)])
			at = src.find("_theme_combos(", at + 1)
	print("    %d scripts read; the list's definition met %d time(s); calls to it: %d" % [files, defs, calls.size()])
	ok(files >= 20 and defs == 1, "§3: %d scripts read and the list's definition met %d times — the sweep has stopped reading scripts/" % [files, defs])
	ok(calls.is_empty(), "§3: a game script calls the list again — %s" % ", ".join(PackedStringArray(calls)))
	for fn in CALLERS:
		var body := Gate.fn_body(RUN_STATE, String(fn), _cache)
		# `compose`'s plain-mob fallback picks a kind with `pick_random`, which is not the list: the list is `_theme_combos`.
		ok(body.contains("_theme_pick(") and not body.contains("_theme_combos("),
			"§3: Run.%s does not draw through _theme_pick, or lists through _theme_combos (%d chars read)" % [fn, body.length()])


# ── §4 — THE COST ──────────────────────────────────────────────────────────
# The draw's work on a roster: the memo states a fight's and an elite's themes reach at every budget 3 to 12, summed; and
# beside it the warbands the list holds there — read off the count, which §1 holds to the list's size, so the list is not
# built twice.
func _work(roster: int) -> Array:
	var states := 0
	var listed := 0
	for t in (_run.THEMES as Dictionary):
		var nodes: Array = _run.THEMES[t]["nodes"]
		if not (nodes.has("fight") or nodes.has("elite")):
			continue
		for b in range(3, 13):
			var dw: Dictionary = _run._draw_frame(_run.THEMES[t], b, roster, "")
			listed += int(_run._draw_total(dw))
			states += (dw["memo"] as Dictionary).size()
	return [states, listed]


func _map_ms(roster: int) -> int:
	seed(11)
	var t0 := Time.get_ticks_msec()
	for tier in range(1, 16):
		for k in 4:
			_run.compose_budget(_run.battle_budget(tier), roster)
	return Time.get_ticks_msec() - t0


func _s4_the_cost() -> void:
	print("\n§4 — six kinds more in one roster: the list multiplies, the draw's work does not")
	var data: Dictionary = Enemies._load()
	var roster := 1
	var kinds_before := Enemies.kinds_for_roster(roster).size()
	var before := _work(roster)
	var ms_before := _map_ms(roster)
	var added: Array = []
	for role in STANDIN_ROLES:
		for k in Enemies.kinds_for_roster(roster):
			var roles: Array = Enemies.roles(k)
			if roles.has(role) and not roles.has("boss") and not added.has("standin_" + String(k)):
				var copy: Dictionary = (data[k] as Dictionary).duplicate(true)
				copy["zones"] = [roster]
				data["standin_" + String(k)] = copy
				added.append("standin_" + String(k))
				break
	var kinds_after := Enemies.kinds_for_roster(roster).size()
	var after := _work(roster)
	var ms_after := _map_ms(roster)
	for k in added:
		data.erase(k)
	var restored := Enemies.kinds_for_roster(roster).size()
	var kr := float(kinds_after) / float(maxi(kinds_before, 1))
	var sr := float(after[0]) / float(maxi(int(before[0]), 1))
	var lr := float(after[1]) / float(maxi(int(before[1]), 1))
	print("    roster %d: %d kinds -> %d (x%.2f); the list %d -> %d warbands (x%.2f); the draw's work %d -> %d states (x%.2f)" % [
		roster, kinds_before, kinds_after, kr, before[1], after[1], lr, before[0], after[0], sr])
	print("    a map's worth of fight draws on it: %d ms -> %d ms (printed, not asserted)" % [ms_before, ms_after])
	ok(added.size() == STANDIN_ROLES.size() and restored == kinds_before,
		"§4: %d stand-ins added of %d (a role the roster lacks), or the roster reads %d kinds after them, %d before (the data not put back)" % [
			added.size(), STANDIN_ROLES.size(), restored, kinds_before])
	# The comparison's other half: the stand-ins reached the list, which multiplied — or §4's bound below proves nothing.
	ok(kinds_after == kinds_before + STANDIN_ROLES.size() and lr > sr * 2.0,
		"§4: the list grew x%.2f against the draw's x%.2f (kinds %d -> %d) — the stand-ins reached nothing the list holds, or the draw grew with the list" % [lr, sr, kinds_before, kinds_after])
	# The decision's own terms: a roster's kind count stops setting the cost. The draw's work may grow with the kinds
	# themselves — each is a branch — and no faster than half again of that.
	ok(sr <= kr * 1.5, "§4: six kinds more multiplied the draw's work x%.2f against the kinds' x%.2f — it grows with the list again" % [sr, kr])


# ── §5 — THE RECORD ────────────────────────────────────────────────────────
func _flat(text: String) -> String:
	var rx := RegEx.new()
	rx.compile("\\s+")
	return rx.sub(text, " ", true)


func _s5_the_record() -> void:
	print("\n§5 — the rulings answered stand archived; the recon clause and the two habits stand where they landed")
	var state := FileAccess.get_file_as_string(STATE)
	var arch := FileAccess.get_file_as_string(ARCHIVE)
	var live: Array = OWED_LIVE.filter(func(h): return state.contains(String(h)))
	var struck: Array = OWED_STRUCK.filter(func(h): return arch.contains(String(h)))
	print("    rulings blocks still owed: %d; struck in the archive: %d of %d" % [live.size(), struck.size(), OWED_STRUCK.size()])
	ok(state.length() > 1000 and live.is_empty(), "§5: an answered rulings block is still in the open queue: %s" % str(live))
	ok(arch.length() > 1000 and struck.size() == OWED_STRUCK.size(), "§5: the archive does not hold both answered rulings blocks struck (%d)" % struck.size())
	var rules := FileAccess.get_file_as_string(RULES)
	var b := rules.find(LANE_B)
	var c := rules.find(LANE_C, b)
	var floor_b := _flat(rules.substr(b, c - b)) if b >= 0 and c > b else ""
	print("    the Lane B floor: %d chars read; the recon clause in it: %s" % [floor_b.length(), str(floor_b.contains(RECON_CLAUSE))])
	ok(floor_b.contains(RECON_CLAUSE), "§5: docs/instrument-rules.md's Lane B floor no longer owes a recon when content reaches a gate's ADDED_SINCE or the composer")
	var wow := _flat(FileAccess.get_file_as_string(WOW))
	var missing: Array = HABITS.filter(func(h): return not wow.contains(String(h)))
	print("    the record's habits in docs/ways-of-working.md: %d of %d" % [HABITS.size() - missing.size(), HABITS.size()])
	ok(wow.length() > 1000 and missing.is_empty(), "§5: docs/ways-of-working.md no longer holds the record's habits: %s" % str(missing))
