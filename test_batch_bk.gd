# test_batch_bk.gd — THE BRANCHING MAP. Generation invariants over 1000 maps,
# reachability, the blacksmith, the three event kinds, and the four negative
# controls §9 names. Run:
#   /Applications/Godot.app/Contents/MacOS/Godot --headless \
#       --path /Users/zipples/Documents/DoD/game --script test_batch_bk.gd
#
# NO SCENE IS LOADED and no battle is spawned, so the whole suite lives in
# _initialize. The Run autoload is not available to a `--script` SceneTree, so
# run_state.gd is INSTANTIATED directly and parented to root — the same trick
# test_batch_an used, and the reason `sim_run` is set first is that a probe
# must never touch the player's save file.
#
# THE NEGATIVE CONTROLS ARE THE POINT OF §9 (marked NEGATIVE below). Four of
# this batch's invariants would fail SILENTLY — a crossing edge still resolves,
# a guaranteed blacksmith still plays, a post-fight merchant roll still fires,
# and a blacksmith purchase that consumed a mini-boss slot still hands over an
# upgrade. Each one is asserted by BUILDING the broken state and checking the
# checker rejects it, never by trusting that the generator does not produce it.
extends SceneTree

const MAPS := 1000

var checks := 0
var fails := 0
var sections := 0   # bumped at the LAST line of each section
var run: Node = null


func ok(cond: bool, msg: String) -> void:
	checks += 1
	if not cond:
		fails += 1
		print("FAIL: " + msg)


func _initialize() -> void:
	var rsrc := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	var ssrc := FileAccess.get_file_as_string("res://scripts/run_sim.gd")
	var bsrc := FileAccess.get_file_as_string("res://scripts/battle.gd")
	var msrc := FileAccess.get_file_as_string("res://scripts/map_screen.gd")

	run = load("res://scripts/run_state.gd").new()
	run.sim_run = true
	run.name = "RunProbe"
	root.add_child(run)
	run.new_run()

	_section_shape(rsrc)
	# ONE generation pass feeds every map-level audit. A zone map costs ~200ms
	# to build (26 warbands pre-rolled for hover-scouting), so generating a
	# fresh thousand for each section would put the suite over ten minutes and
	# buy nothing — the invariants are all properties of the same map.
	_section_generation()
	_section_tier_scaling()
	_section_blacksmith(rsrc)
	_section_events()
	_section_removals(rsrc, ssrc, bsrc, msrc)
	_section_save()
	_section_negative_controls()

	# A GDScript error mid-function aborts that function and the suite still
	# prints "0 failures" — the aborted body simply stops calling ok(). Every
	# section bumps this on its last line, so a section that died is a failure
	# rather than a quieter pass.
	ok(sections == 8,
		"suite: all 8 sections ran to their last line (%d did)" % sections)
	print("\ntest_batch_bk: %d checks, %d failures" % [checks, fails])
	quit(1 if fails > 0 else 0)


# ---------- §1: the shape ----------

func _section_shape(rsrc: String) -> void:
	ok(run.SLOTS_PER_ZONE == 16, "§1: 16 slots per zone")
	ok(run.ROWS == 3, "§1: three rows")
	ok(run.MINI_SLOT == 7, "§1: the mini-boss is slot 8 (index 7)")
	ok(run.BOSS_SLOT == 15, "§1: the boss is slot 16 (index 15)")
	ok(run.BRANCH_COLUMNS == 14, "§1: 14 branching columns")
	ok(run.SLOT_COUNT * run.SLOTS_PER_ZONE == 48,
		"§1: 3 zones x 16 = 48 encounters (the brief says 49; 3 x 16 is 48, and its own 'was 36' was 3 x 12)")
	ok(int(run.NODE_COPIES["elite"]) == 6 and int(run.NODE_COPIES["blacksmith"]) == 6
		and int(run.NODE_COPIES["merchant"]) == 5 and int(run.NODE_COPIES["event"]) == 5,
		"§1: node copies 6 elite / 6 blacksmith / 5 merchant / 5 event (fights are the remainder)")
	ok(not rsrc.contains("const ZONE_SHAPE"),
		"§1: ZONE_SHAPE (Batch AN's authored 12-slot line) is DELETED, not left unreachable")
	# The mini-boss's column position: slot 7 is column 7's successor, and
	# column 8 sits on slot 8. This mapping is what makes "no two elites in
	# adjacent columns" span the mini-boss.
	ok(run.column_slot(1) == 0 and run.column_slot(7) == 6
		and run.column_slot(8) == 8 and run.column_slot(14) == 14,
		"§1: columns 1-14 map onto slots 0-6 and 8-14, the mini-boss between 7 and 8")
	sections += 1


# ---------- §2/§9: 1000 maps, every generation invariant ----------

var _bad_degree := 0
var _bad_adjacency := 0
var _bad_crossing := 0
var _orphans := 0
var _empty_columns := 0
var _width_hist := {}
var _copy_totals := {}
var _narrow_columns := 0


func _section_generation() -> void:
	for i in MAPS:
		run.zone_idx = i % run.SLOT_COUNT
		run._generate_map()
		_audit_graph()
		_audit_types()
		_audit_reachability()
		var duck_smith := _avoiding_walk("blacksmith")
		if duck_smith == 0:
			_zero_smith_routes += 1
		else:
			_forced_smith_routes += 1
		if _avoiding_walk("elite") == 0:
			_zero_elite_routes += 1
	ok(_bad_degree == 0, "§2: every node has 1-3 edges in and 1-3 out (%d violations)" % _bad_degree)
	ok(_bad_adjacency == 0, "§2: every edge lands on the same row or an adjacent one (%d violations)" % _bad_adjacency)
	ok(_bad_crossing == 0, "§2: no two edges cross (%d violations)" % _bad_crossing)
	ok(_orphans == 0, "§2: no node survives with nothing in or nothing out (%d orphans)" % _orphans)
	ok(_empty_columns == 0, "§2: no column is emptied by pruning (%d)" % _empty_columns)
	ok(int(_width_hist.get(1, 0)) == 0,
		"§2: MIN_COLUMN holds — no column is pruned to a single node (%d were)" % int(_width_hist.get(1, 0)))
	ok(_narrow_columns > 0,
		"§2: ...but pruning is REAL — %d columns of %d came out narrower than 3" % [
			_narrow_columns, MAPS * run.BRANCH_COLUMNS])
	for ty in ["elite", "blacksmith", "merchant", "event"]:
		var want := int(run.NODE_COPIES[ty])
		ok(int(_copy_totals.get(ty, 0)) == want * MAPS,
			"§2: exactly %d %s a zone, every zone (%d over %d maps)" % [
				want, ty, int(_copy_totals.get(ty, 0)), MAPS])
	ok(int(_copy_totals.get("miniboss", 0)) == MAPS
		and int(_copy_totals.get("boss", 0)) == MAPS,
		"§2: one mini-boss and one boss a zone")
	_report_types()
	_report_reachability()
	sections += 1


func _audit_graph() -> void:
	for s in run.SLOTS_PER_ZONE:
		var nodes: Array = run.map[s]
		if nodes.is_empty():
			_empty_columns += 1
			continue
		if s != run.MINI_SLOT and s != run.BOSS_SLOT:
			_width_hist[nodes.size()] = int(_width_hist.get(nodes.size(), 0)) + 1
			if nodes.size() < run.ROWS:
				_narrow_columns += 1
		var last_hi := -1
		for j in nodes.size():
			var node: Dictionary = nodes[j]
			_copy_totals[String(node["type"])] = \
				int(_copy_totals.get(String(node["type"]), 0)) + 1
			var out: Array = node["next"]
			# Out-degree: 1-3 for everything the boss is not.
			if s == run.BOSS_SLOT:
				if not out.is_empty():
					_bad_degree += 1
			elif out.size() < 1 or out.size() > 3:
				_bad_degree += 1
			# In-degree, counted from the previous slot. Slot 0 is the zone
			# entry and slot 8 is fed whole by the mini-boss; both are entries
			# by construction and have no previous column to count.
			if s > 0 and s != run.MINI_SLOT + 1:
				var ins := 0
				for prev in run.map[s - 1]:
					if prev["next"].has(j):
						ins += 1
				if ins < 1 or ins > 3:
					_bad_degree += 1
					_orphans += 1
			# Adjacency and non-crossing only bind INSIDE a half — the two
			# converge slots and the mini-boss fan-out are the map's three
			# deliberate exceptions.
			if s == run.MINI_SLOT or s == run.MINI_SLOT - 1 or s == run.BOSS_SLOT - 1 \
					or s == run.BOSS_SLOT:
				continue
			var lo := 99
			var hi := -1
			for t in out:
				var target_row := int(run.map[s + 1][int(t)]["row"])
				if absi(target_row - int(node["row"])) > 1:
					_bad_adjacency += 1
				lo = mini(lo, target_row)
				hi = maxi(hi, target_row)
			# NON-CROSSING, stated exactly as §2 states it: everything row i+1
			# reaches is at or below everything row i reaches.
			if last_hi >= 0 and lo < last_hi:
				_bad_crossing += 1
			last_hi = hi


# ---------- §9: reachability ----------

var _entry_no_elite := 0
var _entry_no_trade := 0
var _contiguity_failures := 0
var _narrowing_failures := 0
var _zero_smith_routes := 0
var _forced_smith_routes := 0
var _zero_elite_routes := 0


func _audit_reachability() -> void:
	if true:
		for j in run.map[0].size():
			var reach: Dictionary = run.reachable_from(0, j)
			var saw := {}
			for key in reach:
				var bits: PackedStringArray = key.split(",")
				saw[String(run.map[int(bits[0])][int(bits[1])]["type"])] = true
			if not saw.has("elite"):
				_entry_no_elite += 1
			if not saw.has("blacksmith") and not saw.has("merchant"):
				_entry_no_trade += 1
		# From ONE node, the reachable set at each later column of its half is
		# a CONTIGUOUS block of whatever survived there, and it never shrinks
		# below one. Contiguity is what non-crossing plus adjacency buys, and
		# PRUNING is the thing that could break it.
		for half in [[0, run.MINI_SLOT - 1], [run.MINI_SLOT + 1, run.BOSS_SLOT - 1]]:
			var first := int(half[0])
			var last := int(half[1])
			for j2 in run.map[first].size():
				var cur: Array = [j2]
				for c in range(first, last):
					var nxt: Array = []
					for r in cur:
						for t in run.map[c][int(r)]["next"]:
							if not nxt.has(int(t)):
								nxt.append(int(t))
					nxt.sort()
					if nxt.is_empty():
						_narrowing_failures += 1
						break
					if int(nxt[nxt.size() - 1]) - int(nxt[0]) != nxt.size() - 1:
						_contiguity_failures += 1
					cur = nxt


func _report_reachability() -> void:
	ok(_entry_no_elite == 0,
		"§2: every entry node reaches at least one elite (%d did not)" % _entry_no_elite)
	ok(_entry_no_trade == 0,
		"§2: every entry node reaches at least one trade node (%d did not)" % _entry_no_trade)
	ok(_contiguity_failures == 0,
		"§9: the reachable set at column N is contiguous among the surviving nodes (%d gaps)" % _contiguity_failures)
	ok(_narrowing_failures == 0,
		"§9: ...and never narrows to nothing (%d dead ends)" % _narrowing_failures)
	# The mini-boss converges and then fans out to the WHOLE of column 8: that
	# is why the entry guarantee above holds at all, and it is the property
	# that would break silently if the halves ever stopped converging.
	run.zone_idx = 0
	run._generate_map()
	var from_mini: Array = run.map[run.MINI_SLOT][0]["next"]
	ok(from_mini.size() == run.map[run.MINI_SLOT + 1].size(),
		"§1: the mini-boss opens every node of column 8")
	for node in run.map[run.MINI_SLOT - 1]:
		ok(node["next"] == [0], "§1: column 7 converges on the mini-boss alone")
	for node2 in run.map[run.BOSS_SLOT - 1]:
		ok(node2["next"] == [0], "§1: column 14 converges on the boss alone")


# ---------- §2: type-assignment constraints ----------

var _elite_in_col1 := 0
var _adjacent_elites := 0
var _dupe_in_column := 0


func _audit_types() -> void:
	if true:
		var elite_cols: Array = []
		for c in range(1, run.BRANCH_COLUMNS + 1):
			var seen := {}
			for node in run.map[run.column_slot(c)]:
				var ty := String(node["type"])
				if ty == "fight":
					continue
				if seen.has(ty):
					_dupe_in_column += 1
				seen[ty] = true
				if ty == "elite":
					elite_cols.append(c)
					if c == 1:
						_elite_in_col1 += 1
		elite_cols.sort()
		for k in range(elite_cols.size() - 1):
			if int(elite_cols[k + 1]) - int(elite_cols[k]) < 2:
				_adjacent_elites += 1


func _report_types() -> void:
	ok(_elite_in_col1 == 0, "§2: no elite in column 1 (%d)" % _elite_in_col1)
	ok(_adjacent_elites == 0, "§2: no two elites in adjacent columns (%d)" % _adjacent_elites)
	ok(_dupe_in_column == 0,
		"§2: at most one of each non-fight type per column (%d)" % _dupe_in_column)


# ---------- §5: the tier ramp across 16 slots ----------

func _section_tier_scaling() -> void:
	# BOTH ENDS ARE HELD WHERE BATCH AN LEFT THEM: slot 1 opens at 3-5 and the
	# last slot before the boss tops out at 8-10. A rescale that moved either
	# end would be difficulty tuning, and §7 forbids it in this batch.
	var lows := []
	for tier in range(1, run.SLOTS_PER_ZONE + 1):
		var lo := 99
		for trial in 200:
			lo = mini(lo, run.battle_budget(tier))
		lows.append(lo)
	ok(int(lows[0]) == 3, "§5: slot 1 still opens at budget 3 (was 3 on the line)")
	ok(int(lows[14]) == 8, "§5: slot 15 still tops out at 8 (the line's slot 11)")
	ok(int(lows[15]) == 10, "§5: the boss band is untouched at 10-12")
	ok(int(lows[7]) == 5, "§5: the mini-boss slot reads 5 (before compose's floor of 6)")
	for k in range(1, lows.size()):
		ok(int(lows[k]) >= int(lows[k - 1]), "§5: the ramp never steps backwards at slot %d" % (k + 1))
	sections += 1


# ---------- §3: the blacksmith ----------

func _section_blacksmith(rsrc: String) -> void:
	run.new_run()
	for m in run.party:
		m["spec"] = ""
	# Give one hero a real kit to price against. `owned_ability_names` reads
	# the spec pool, so the probe awakens the party the way the spec screen
	# does rather than inventing a kit.
	var specs: Array = ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i in run.party.size():
		run.party[i]["spec"] = String(specs[i])

	run.zone_idx = 0
	ok(run.blacksmith_price() == 150, "§3: zone 1 price 150")
	run.zone_idx = 1
	ok(run.blacksmith_price() == 225, "§3: zone 2 price 225")
	run.zone_idx = 2
	ok(run.blacksmith_price() == 300, "§3: zone 3 price 300 — the price scales with the zone")
	run.zone_idx = 0

	var offer: Array = run.roll_blacksmith_offer()
	ok(offer.size() == 3, "§3: three pairings offered (got %d)" % offer.size())
	var members := {}
	for p in offer:
		members[int(p["member_idx"])] = true
	ok(members.size() == offer.size(), "§3: at most one pairing per hero")

	# AP §3's eligibility filter is REUSED, not re-written: every pairing must
	# be one the upgrade can actually change.
	var ineligible := 0
	for trial in 60:
		for p2 in run.roll_blacksmith_offer():
			var ab: Ability = Classes.pool_ability(String(p2["ability"]))
			if ab == null or not run.upgrade_fits(String(p2["id"]), ab):
				ineligible += 1
	ok(ineligible == 0, "§3: an ineligible pairing is never offered (%d were)" % ineligible)

	# The purchase: gold out, upgrade onto the member's own list, and the
	# ◆ badge the map card reads comes off that same list.
	run.gold = 500
	var buyer: Dictionary = run.party[int(offer[0]["member_idx"])]
	var before: int = buyer.get("upgrades", []).size()
	ok(run.buy_blacksmith(offer[0]), "§3: the purchase clears at 500 gold")
	ok(run.gold == 350, "§3: 150 gold deducted (%d left)" % run.gold)
	ok(buyer.get("upgrades", []).size() == before + 1,
		"§3: the upgrade lands on the hero's own `upgrades` list — the same one the mini-boss pick writes")
	var landed: Dictionary = buyer["upgrades"][before]
	ok(String(landed["id"]) == String(offer[0]["id"])
		and String(landed["ability"]) == String(offer[0]["ability"]),
		"§3: ...and it is the pairing that was bought")

	# AP'S ONCE-PER-RUN RULE IS NOT CONSULTED. That rule governs the MINI-BOSS
	# PICK POOL; a blacksmith is not that pool. Buying Honed here must leave
	# Honed available to a later blacksmith on a DIFFERENT ability.
	var bought_id := String(landed["id"])
	var still_offered := false
	for trial2 in 200:
		for p3 in run.roll_blacksmith_offer():
			if String(p3["id"]) == bought_id \
					and String(p3["ability"]) != String(landed["ability"]):
				still_offered = true
	ok(still_offered,
		"§3: the same upgrade type is still offered on a DIFFERENT ability — AP's once-per-run rule does not reach the blacksmith")
	# ...but NEVER TWICE ON ONE ABILITY.
	var repeat := 0
	for trial3 in 300:
		for p4 in run.roll_blacksmith_offer():
			if String(p4["id"]) == bought_id \
					and String(p4["ability"]) == String(landed["ability"]):
				repeat += 1
	ok(repeat == 0,
		"§3: the same upgrade is never re-offered on the ability that already carries it (%d times)" % repeat)

	# THE SUBTLER HALF OF §9's LAST NEGATIVE CONTROL. The blacksmith writes
	# into the same `upgrades` list the mini-boss pick writes, and
	# `roll_upgrade_offer` filters that list through `has_upgrade` — so without
	# the `bought` flag, buying Honed here would silently delete Honed from
	# this hero's mini-boss offers for the rest of the run. They share a LIST,
	# not a POOL, and this is the check that says which.
	ok(not run.has_upgrade(buyer, bought_id),
		"§3: has_upgrade SKIPS a bought upgrade — AP's once-per-run pool is untouched by a purchase")
	var mini_can_still_offer := false
	for trial4 in 200:
		for cand in run.roll_upgrade_offer(buyer):
			if String(cand["id"]) == bought_id:
				mini_can_still_offer = true
	ok(mini_can_still_offer,
		"§3: ...and the mini-boss can still award the upgrade the party bought")
	var landed_names := PackedStringArray()
	for up in buyer["upgrades"]:
		landed_names.append(Run_upgrade_key(up))
	ok(landed_names.size() == before + 1,
		"§3: one list, one entry — a bought upgrade is not filed somewhere else")

	ok(rsrc.contains("func roll_blacksmith_offer") and rsrc.contains("func buy_blacksmith"),
		"§3: the blacksmith lives in run_state beside the system it sells")
	ok(FileAccess.file_exists("res://scenes/blacksmith.tscn")
		and FileAccess.file_exists("res://scripts/blacksmith_screen.gd"),
		"§3: the blacksmith screen exists")
	var bs := FileAccess.get_file_as_string("res://scripts/blacksmith_screen.gd")
	ok(bs.contains("_leave()") and not bs.contains("_draw_screen()\n\n\nfunc _leave"),
		"§3: buying ENDS the visit — not a shop you clear")
	ok(not bs.contains("damage_pct") and not bs.contains("max_hp"),
		"§3: GOLD ONLY — no HP cost, no second currency")
	sections += 1


# ---------- §4: the three event kinds ----------

func _section_events() -> void:
	var kinds := {}
	for id in Events.ids():
		var k := Events.kind(String(id))
		kinds[k] = int(kinds.get(k, 0)) + 1
	ok(int(kinds.get("tradeoff", 0)) >= 8, "§4: at least 8 tradeoffs (%d)" % int(kinds.get("tradeoff", 0)))
	ok(int(kinds.get("boon", 0)) >= 4, "§4: at least 4 boons (%d)" % int(kinds.get("boon", 0)))
	ok(int(kinds.get("bane", 0)) >= 4, "§4: at least 4 banes (%d)" % int(kinds.get("bane", 0)))
	ok(kinds.size() == 3, "§4: three kinds and no fourth")
	ok(int(Events.KIND_WEIGHTS["tradeoff"]) == 60
		and int(Events.KIND_WEIGHTS["boon"]) == 25
		and int(Events.KIND_WEIGHTS["bane"]) == 15,
		"§4: 60 / 25 / 15")

	# EVERY TRADEOFF IS DECLINABLE, and every tradeoff offers at least two
	# conversions to decline between.
	for id2 in Events.ids():
		var cfg := Events.config(String(id2))
		if Events.kind(String(id2)) != "tradeoff":
			continue
		var conversions := 0
		var decline := false
		for choice in cfg.get("choices", []):
			if choice.get("effects", []).is_empty():
				# A free option with no requirement: that is the decline.
				decline = decline or not choice.has("requires")
			else:
				conversions += 1
		ok(conversions >= 2, "§4: %s offers 2-3 conversions (%d)" % [id2, conversions])
		ok(decline, "§4: %s can always be declined" % id2)

	# ONE ICON. The map screen must never branch on kind — the whole design of
	# the untelegraphed node is that a bane looks like a boon on the board.
	var msrc := FileAccess.get_file_as_string("res://scripts/map_screen.gd")
	ok(not msrc.contains("Events.kind") and not msrc.contains("\"bane\""),
		"§4: the map screen cannot see an event's kind — one icon, untelegraphed")
	ok(msrc.contains("\"event\": \"???\""), "§4: ...and it draws as ???")

	# NO BANE MAY TAKE A HERO BELOW 1 HP — driven, at 1 HP, against every
	# effect of every bane. This is the negative control §9 calls the one that
	# matters, so it is run against the REAL apply path, not against a reading
	# of the JSON.
	var killed := 0
	run.new_run()
	for id3 in Events.ids():
		if Events.kind(String(id3)) != "bane":
			continue
		for choice2 in Events.config(String(id3)).get("choices", []):
			for m in run.party:
				m["hp"] = 1
				m["max_hp"] = 200
			run.gold = 10
			run.items = {}
			for fx in choice2.get("effects", []):
				Events.apply(run, fx)
			for m2 in run.party:
				if int(m2["hp"]) < 1:
					killed += 1
	ok(killed == 0,
		"§4 NEGATIVE: no bane can reduce a hero below 1 HP, driven at 1 HP (%d did)" % killed)

	# The kind draw actually respects 60/25/15 rather than the pool's shape.
	# The seen filter is reset directly rather than through new_run: a fresh
	# run regenerates a zone map, and 3000 of those is four minutes of warband
	# rolling for a question about a weighted draw.
	var drawn := {}
	run.new_run()
	run.gold = 400
	for i in 3000:
		run.seen_events = []
		var id4 := Events.pick(run)
		if id4 == "":
			continue
		drawn[Events.kind(id4)] = int(drawn.get(Events.kind(id4), 0)) + 1
	var total := 0
	for k2 in drawn:
		total += int(drawn[k2])
	var trade_pct := 100.0 * int(drawn.get("tradeoff", 0)) / maxf(total, 1)
	var bane_pct := 100.0 * int(drawn.get("bane", 0)) / maxf(total, 1)
	ok(absf(trade_pct - 60.0) < 4.0,
		"§4: tradeoffs come up ~60%% of the time (%.1f%%)" % trade_pct)
	ok(absf(bane_pct - 15.0) < 4.0,
		"§4: banes come up ~15%% of the time (%.1f%%)" % bane_pct)

	# §4's own worked example needs a verb that can hand over a rune.
	ok(Events.VERBS.has("rune_grant"), "§4: rune_grant is in the vocabulary")
	run.new_run()
	run.party[0]["spec"] = "berserker"
	var worn_before: int = run.party[0].get("runes", []).size()
	Events.apply(run, {"effect": "rune_grant", "amount": 1})
	var got := 0
	for m3 in run.party:
		got += m3.get("runes", []).size()
	ok(got > worn_before, "§4: rune_grant delivers a rune to the party")
	sections += 1


# ---------- deleted, not left unreachable ----------

func _section_removals(rsrc: String, ssrc: String, bsrc: String, msrc: String) -> void:
	for fname in ["func roll_merchant", "func roll_event", "const MERCHANT_CHANCE",
			"const MERCHANT_FLOOR", "const EVENT_CHANCE", "var slots_since_merchant",
			"var pending_after"]:
		ok(not rsrc.contains(fname),
			"§3/§5: run_state's %s is DELETED — the merchant and the event are map nodes now" % fname)
	ok(not bsrc.contains("Run.roll_merchant") and not bsrc.contains("Run.roll_event"),
		"§3 NEGATIVE: battle.gd's victory branch no longer rolls a merchant or an event behind a fight")
	ok(not ssrc.contains("run.roll_merchant") and not ssrc.contains("run.roll_event"),
		"§3 NEGATIVE: ...and neither does RunSim")
	# The ONE survivor, and it is bought rather than rolled.
	ok(rsrc.contains("var pending_shop") and rsrc.contains("pending_shop = true"),
		"§3 KEEP: the bargain's severity-4 'a merchant follows the fight' reward still works — it is bought, not rolled")
	ok(not msrc.contains("func _on_slot_pressed") and msrc.contains("func _on_node_pressed"),
		"§5: the map screen steps onto a NODE now, not a slot")
	ok(not msrc.contains("SLOT_X_START") and not msrc.contains("SLOT_X_STEP"),
		"§5: AO's two line constants are gone with the line")
	ok(msrc.contains("clip_contents = true") and msrc.contains("HScrollBar"),
		"§5: the lattice scrolls horizontally inside a clipped viewport")
	ok(msrc.contains("const CARD_X := 8.0"), "§5: the hero cards sit on the left edge")
	ok(msrc.contains("res://scenes/party.tscn"),
		"§5: clicking a hero card opens their sheet")
	ok(ssrc.contains("const ROUTE_ORDER") and ssrc.contains("\"greedy\"")
		and ssrc.contains("\"balanced\"") and ssrc.contains("\"cautious\""),
		"§5: RunSim has three route policies with something to choose between")
	sections += 1


# ---------- §6: the save ----------

func _section_save() -> void:
	var src := FileAccess.get_file_as_string("res://scripts/run_state.gd")
	ok(src.contains("\"version\": 8"), "§6: SAVE v8")
	ok(src.contains("if save_version < 8:"), "§6: a pre-v8 save is REFUSED and cleared")
	ok(src.contains("\"node_idx\": node_idx"),
		"§6: the position is the PAIR (slot_idx, node_idx) — which is exactly why a v7 line save has no honest place on a lattice")
	sections += 1


# ---------- §9: the four silent failures ----------

func _section_negative_controls() -> void:
	run.zone_idx = 0
	run._generate_map()

	# (1) CROSSING EDGES PERMITTED. Break one map's edges into a crossing pair
	# and prove the auditor above catches it — an audit that only ever sees
	# clean maps is an audit nobody has tested.
	var before_cross := _bad_crossing
	var slot := -1
	for s in range(0, run.MINI_SLOT - 1):
		if run.map[s].size() == 3 and run.map[s + 1].size() == 3:
			slot = s
			break
	if slot >= 0:
		run.map[slot][0]["next"] = [2]
		run.map[slot][2]["next"] = [1]
		_audit_graph()
		ok(_bad_crossing > before_cross,
			"§9 NEGATIVE: a crossing pair of edges is DETECTED (the auditor is not vacuous)")
	else:
		ok(false, "§9 NEGATIVE: no three-wide adjacent column pair to break (regenerate)")

	# (2) A ROUTE GUARANTEED TO HIT A BLACKSMITH. §1 is explicit that no node
	# type is guaranteed — a player who routes past every blacksmith gets none.
	# The control is a walk that AVOIDS them, run over the whole thousand-map
	# pass above: if a zero-blacksmith route is impossible, the guarantee crept
	# back in and §1's central claim is false.
	ok(_zero_smith_routes > 0,
		"§9 NEGATIVE: a zero-blacksmith route EXISTS (%d of %d zones) — nothing is guaranteed on a route" % [
			_zero_smith_routes, MAPS])
	ok(_zero_elite_routes > 0,
		"§9: a zero-elite route exists too (%d of %d) — skipping every elite is an underpower strategy, not an impossible one" % [
			_zero_elite_routes, MAPS])
	# ...AND THE CHECK ABOVE IS NOT VACUOUS. A walker that always returned 0
	# would pass it forever, so the companion assertion is that ducking
	# SOMETIMES FAILS: the edges do force a blacksmith on a route often
	# enough that avoiding one is a property of the map rather than of the
	# walk. This pairing is what makes the control mean anything.
	ok(_forced_smith_routes > 0,
		"§9: ...and a route that tries to duck every blacksmith is sometimes FORCED onto one anyway (%d of %d) — the avoid-walk is doing real work" % [
			_forced_smith_routes, MAPS])

	# (3) THE MERCHANT STILL ROLLING POST-FIGHT. Asserting the function is
	# absent is the source check above; this is the behavioural one — the run
	# object must not answer a merchant roll at all.
	ok(not run.has_method("roll_merchant"),
		"§9 NEGATIVE: Run cannot answer roll_merchant — the post-fight roll is gone, not merely uncalled")
	ok(not run.has_method("roll_event"),
		"§9 NEGATIVE: ...and neither can it answer roll_event")

	# (4) A BLACKSMITH PURCHASE CONSUMING A MINI-BOSS UPGRADE SLOT. The
	# mini-boss award is `up_picks_owed` + `up_candidates`; a purchase must
	# touch neither. Buy, then prove the mini-boss still owes what it owed.
	run.new_run()
	var specs: Array = ["berserker", "cryomancer", "inquisitor", "beastmaster"]
	for i3 in run.party.size():
		run.party[i3]["spec"] = String(specs[i3])
	run.gold = 900
	run.zone_idx = 0
	for m in run.party:
		run.award_upgrade_pick(m)
	var owed_before: Array = []
	for m2 in run.party:
		owed_before.append(int(m2.get("up_picks_owed", 0)))
	var offer: Array = run.roll_blacksmith_offer()
	ok(not offer.is_empty(), "§9: (setup) the blacksmith has something to sell")
	run.buy_blacksmith(offer[0])
	var unchanged := true
	for i4 in run.party.size():
		if int(run.party[i4].get("up_picks_owed", 0)) != int(owed_before[i4]):
			unchanged = false
	ok(unchanged,
		"§9 NEGATIVE: a blacksmith purchase consumes NO mini-boss pick — up_picks_owed is untouched")
	var buyer: Dictionary = run.party[int(offer[0]["member_idx"])]
	ok(not buyer.get("up_candidates", []).is_empty(),
		"§9 NEGATIVE: ...and the mini-boss's own three candidates are still on the card")
	sections += 1


func Run_upgrade_key(up: Dictionary) -> String:
	return "%s|%s" % [String(up.get("ability", "")), String(up.get("id", ""))]


# How many nodes of `avoid` a route takes when it is trying not to take any.
func _avoiding_walk(avoid: String) -> int:
	var slot := -1
	var node := 0
	var hits := 0
	while slot < run.BOSS_SLOT:
		var opts: Array = []
		if slot < 0:
			for j in run.map[0].size():
				opts.append(j)
		else:
			opts = Array(run.map[slot][node]["next"])
		if opts.is_empty():
			break
		var pick := int(opts[0])
		for j2 in opts:
			if String(run.map[slot + 1][int(j2)]["type"]) != avoid:
				pick = int(j2)
				break
		slot += 1
		node = pick
		if String(run.map[slot][node]["type"]) == avoid:
			hits += 1
	return hits
