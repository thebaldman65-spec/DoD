# Scratch harness: generate N zone maps off the live Run autoload and report
# the §2 distributions. Not part of the suite — test_batch_bk owns the
# assertions; this is the thing that answers "what did the generator do".
#   /Applications/Godot.app/Contents/MacOS/Godot --headless \
#       --path /Users/zipples/Documents/DoD/game --script check_map.gd
extends SceneTree

const N := 1500
const POLICIES := {
	"random": [],
	"greedy": ["elite", "blacksmith", "merchant", "event", "fight"],
	"balanced": ["blacksmith", "merchant", "elite", "event", "fight"],
	"cautious": ["blacksmith", "merchant", "event", "fight", "elite"],
}


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	var run: Node = load("res://scripts/run_state.gd").new()
	run.sim_run = true
	run.name = "RunProbe"
	root.add_child(run)
	run.new_run()

	var widths := {}
	var nodes: Array = []
	var outdeg := {}
	var copies := {}
	var foreclosed: Array = []
	var walked := {}
	var dec_total := 0
	var choice_total := 0
	var zero_smith := {}
	var elite_hist := {}
	var entry_no_elite := 0
	var entry_no_trade := 0
	var contig_bad := 0
	for p in POLICIES:
		walked[p] = {}
		zero_smith[p] = 0
		elite_hist[p] = {}

	for i in N:
		run.zone_idx = 0
		run._generate_map()
		var total := 0
		for c in range(1, run.BRANCH_COLUMNS + 1):
			var s: int = run.column_slot(c)
			var w: int = run.map[s].size()
			widths[w] = int(widths.get(w, 0)) + 1
			total += w
		nodes.append(total)
		for s in run.SLOTS_PER_ZONE:
			for j in run.map[s].size():
				var node: Dictionary = run.map[s][j]
				copies[String(node["type"])] = int(copies.get(String(node["type"]), 0)) + 1
				if s == run.MINI_SLOT or s == run.BOSS_SLOT or s == run.MINI_SLOT - 1 \
						or s == run.BOSS_SLOT - 1:
					continue
				var d: int = node["next"].size()
				outdeg[d] = int(outdeg.get(d, 0)) + 1
		# Entry guarantee + foreclosure depth + reach contiguity.
		for j in run.map[0].size():
			var reach: Dictionary = run.reachable_from(0, j)
			var saw_elite := false
			var saw_trade := false
			for key in reach:
				var bits: PackedStringArray = key.split(",")
				var ty := String(run.map[int(bits[0])][int(bits[1])]["type"])
				if ty == "elite":
					saw_elite = true
				if ty in ["blacksmith", "merchant"]:
					saw_trade = true
			if not saw_elite:
				entry_no_elite += 1
			if not saw_trade:
				entry_no_trade += 1
		if i < 400:
			foreclosed.append_array(_foreclosure(run))
			contig_bad += _contiguity_failures(run)
		for p in POLICIES:
			var res := _walk(run, p)
			for ty in res["counts"]:
				walked[p][ty] = float(walked[p].get(ty, 0.0)) + int(res["counts"][ty])
			if int(res["counts"].get("blacksmith", 0)) == 0:
				zero_smith[p] += 1
			var e: int = int(res["counts"].get("elite", 0))
			elite_hist[p][e] = int(elite_hist[p].get(e, 0)) + 1
			if p == "random":
				dec_total += int(res["decisions"])
				choice_total += int(res["choices"])

	print("=== BATCH BK map generation, %d zones (%.1fs) ===" % [N,
		(Time.get_ticks_msec() - t0) / 1000.0])
	print("nodes per zone: mean %.2f (42 positions before pruning)" % _mean(nodes))
	print("column widths: %s" % _pct(widths))
	print("out-degree (interior columns): %s" % _pct(outdeg))
	var per := {}
	for ty in copies:
		per[ty] = float(copies[ty]) / N
	print("copies per zone: %s" % _fmt(per))
	print("foreclosure: mean %.2f columns a node cannot reach in its half" % _mean(foreclosed))
	print("entry nodes reaching NO elite: %d   NO trade node: %d (of %d)" % [
		entry_no_elite, entry_no_trade, N * 3])
	print("reach-contiguity failures: %d" % contig_bad)
	print("decisions/zone (random walk): %.2f   real choices/zone: %.2f" % [
		float(dec_total) / N, float(choice_total) / N])
	for p in POLICIES:
		var w := {}
		for ty in walked[p]:
			w[ty] = float(walked[p][ty]) / N
		print("  %-9s walked/zone %s | zero-blacksmith routes %.1f%% | elites %s" % [
			p, _fmt(w), 100.0 * zero_smith[p] / N, _pct(elite_hist[p])])
	quit(0)


func _walk(run: Node, policy: String) -> Dictionary:
	var order: Array = POLICIES[policy]
	var slot := -1
	var node := 0
	var counts := {}
	var decisions := 0
	var choices := 0
	while slot < run.BOSS_SLOT:
		var opts: Array = []
		if slot < 0:
			for j in run.map[0].size():
				opts.append(j)
		else:
			opts = Array(run.map[slot][node]["next"])
		if opts.is_empty():
			break
		var kinds := {}
		for j in opts:
			kinds[String(run.map[slot + 1][int(j)]["type"])] = true
		if opts.size() >= 2:
			decisions += 1
			if kinds.size() > 1:
				choices += 1
		var pick := int(opts[randi() % opts.size()])
		if not order.is_empty():
			var best := 99
			for j in opts:
				var rank: int = order.find(String(run.map[slot + 1][int(j)]["type"]))
				if rank < 0:
					rank = order.size()
				if rank < best:
					best = rank
					pick = int(j)
		slot += 1
		node = pick
		var ty := String(run.map[slot][node]["type"])
		counts[ty] = int(counts.get(ty, 0)) + 1
	return {"counts": counts, "decisions": decisions, "choices": choices}


# For every node in a half, how many later columns of that half hold a node
# it cannot reach.
func _foreclosure(run: Node) -> Array:
	var out: Array = []
	for half in [[0, run.MINI_SLOT - 1], [run.MINI_SLOT + 1, run.BOSS_SLOT - 1]]:
		var first: int = int(half[0])
		var last: int = int(half[1])
		for s in range(first, last):
			for j in run.map[s].size():
				var cur := {}
				cur[j] = true
				var blocked := 0
				for c in range(s, last):
					var nxt := {}
					for r in cur:
						for t in run.map[c][int(r)]["next"]:
							nxt[int(t)] = true
					cur = nxt
					if cur.size() < run.map[c + 1].size():
						blocked += 1
				out.append(blocked)
	return out


# The rows reachable from one node must form a CONTIGUOUS block of whatever
# survived in that column — non-crossing plus adjacency guarantees it, and
# pruning is the thing that could break it.
func _contiguity_failures(run: Node) -> int:
	var bad := 0
	for half in [[0, run.MINI_SLOT - 1], [run.MINI_SLOT + 1, run.BOSS_SLOT - 1]]:
		var first: int = int(half[0])
		var last: int = int(half[1])
		for j in run.map[first].size():
			var cur := {}
			cur[j] = true
			for c in range(first, last):
				var nxt: Array = []
				for r in cur:
					for t in run.map[c][int(r)]["next"]:
						if not nxt.has(int(t)):
							nxt.append(int(t))
				nxt.sort()
				if not nxt.is_empty() and int(nxt[nxt.size() - 1]) - int(nxt[0]) \
						!= nxt.size() - 1:
					bad += 1
				cur = {}
				for t in nxt:
					cur[int(t)] = true
	return bad


func _mean(xs: Array) -> float:
	if xs.is_empty():
		return 0.0
	var total := 0.0
	for x in xs:
		total += float(x)
	return total / xs.size()


func _pct(d: Dictionary) -> String:
	var total := 0
	for k in d:
		total += int(d[k])
	var keys: Array = d.keys()
	keys.sort()
	var parts := PackedStringArray()
	for k in keys:
		parts.append("%s:%.1f%%" % [k, 100.0 * int(d[k]) / maxi(total, 1)])
	return "  ".join(parts)


func _fmt(d: Dictionary) -> String:
	var keys: Array = d.keys()
	keys.sort()
	var parts := PackedStringArray()
	for k in keys:
		parts.append("%s %.2f" % [k, float(d[k])])
	return "  ".join(parts)
