# BATCH CT — THE POUCH RENDER GATE, run as a SCENE.
#
# The brief's floor includes "the pouch renders full and empty", and neither
# state can be checked from source: `_draw_screen` only executes against a
# live run, and a button that lands off the right-hand edge is a DRAW-time
# fact that no parse gate and no source read can see. That is exactly the
# failure this batch found in the brief — §1 asserts "six buttons fit the
# existing row" and at the pitch it names they do not, by 172 pixels.
#
# So this measures. Every pouch button is asked for its real rect and the
# rect is asserted inside the 1280-wide viewport, at 4, 5 and 6 slots.
#   /Applications/Godot.app/Contents/MacOS/Godot --headless \
#       --path . --quit-after 900 res://check_ct_map.tscn
extends Node

const VIEW_W_PX := 1280.0

var stage := 0
var frames := 0
var map_scene: Node = null
var _fails := 0
var _checks := 0


func ok(cond: bool, what: String) -> void:
	_checks += 1
	if not cond:
		_fails += 1
		print("  FAIL: %s" % what)


func _ready() -> void:
	Run.sim_run = true          # never touch the real save
	Run.new_run()
	for i in Run.party.size():
		Run.party[i]["spec"] = ["berserker", "cryomancer", "inquisitor",
			"beastmaster"][i]
	Run.specs_chosen = true
	Profile.set_flag("run_framing_seen")   # skip the orientation card
	print("BATCH CT — THE POUCH RENDERS")


func _process(_d: float) -> void:
	frames += 1
	if frames % 4 != 0:
		return
	match stage:
		0:
			# ZONE 1, FOUR SLOTS, ALL FOUR HELD — the opening, exactly as a
			# player meets it.
			ok(Run.item_slots() == 4, "zone 1 offers four slots")
			ok(Run.slots_used() == 4, "and the opening fills all four")
			_open("zone 1: 4/4 slots, pouch FULL ")
		1:
			_close()
			# EMPTY: a drained stack that still holds its slot, plus two free
			# slots beside it. Both halves of "full and empty" in one frame.
			Run.zone_idx = 2                    # six slots
			Run.items["bomb"] = 0               # held, empty
			Run.discard_item("revive")          # a genuinely free slot
			ok(Run.item_slots() == 6, "zone 3 offers six slots")
			ok(Run.slots_used() == 3, "three types held")
			ok(Run.items.has("bomb") and int(Run.items["bomb"]) == 0,
				"one of them is a HELD, EMPTY slot")
			_open("zone 3: 3/6 held, one drained")
		2:
			_close()
			# SIX SLOTS, ALL SIX HELD — the state §1 claimed already fits and
			# does not. This is the measurement that found the 172px overflow.
			for id in ["health", "mana", "bomb", "revive", "defense",
					"cleanse"]:
				Run.items[id] = 2
			ok(Run.slots_used() == 6, "all six slots held")
			_open("zone 3: 6/6 slots, pouch FULL")
		3:
			_close()
			# THE SHOP LISTS ALL EIGHT TYPES WHATEVER THE POUCH HOLDS, so its
			# supplies column grew from five rows to eight and the brief did not
			# mention it. At the old 56 pitch row 8 ended at y=600, straight through
			# the DRAFT header at 452. Measured here for the same reason the pouch
			# row is: a collision is a draw-time fact.
			Run.pending_shop = true
			var shop: Node = (load("res://scenes/shop.tscn") as PackedScene).instantiate()
			add_child(shop)
			var supply_rows: Array = []
			var draft_top := 1e9
			for n in shop.get_children():
				if n is Label and String(n.text).begins_with("THE DRAFT"):
					draft_top = minf(draft_top, n.position.y)
				if n is Button and n.position.x == 140.0 and n.position.y < 452.0:
					supply_rows.append(n)
			ok(supply_rows.size() == Run.ITEM_IDS.size(),
				"the shop lists all %d types (drew %d)" % [
					Run.ITEM_IDS.size(), supply_rows.size()])
			var lowest := 0.0
			for b in supply_rows:
				lowest = maxf(lowest, b.position.y + b.custom_minimum_size.y)
			ok(lowest <= draft_top,
				"supplies end at y=%.0f, above the draft header at y=%.0f" % [
					lowest, draft_top])
			# Sell buttons: one per HELD type, and clear of the rune column at 620.
			var sells := 0
			var sell_id := ""
			for n in shop.get_children():
				if n is Button and String(n.text).begins_with("Sell +"):
					sells += 1
					ok(n.position.x + n.custom_minimum_size.x <= 620.0,
						"a Sell button stays clear of the rune column")
			ok(sells == Run.slots_used(),
				"drew %d Sell buttons for %d held slots" % [sells, Run.slots_used()])
			# §2: SELLING TAKES TWO PRESSES. One press must NOT move gold or free a
			# slot — this button sits inches from BUY.
			sell_id = "health"
			var gold_before: int = Run.gold
			var slots_before: int = Run.slots_used()
			shop._sell_item(sell_id)
			ok(Run.gold == gold_before, "one press on Sell moves no gold")
			ok(Run.slots_used() == slots_before, "and frees no slot")
			ok(Run.items.has(sell_id), "and the stack is still there")
			shop._sell_item(sell_id)
			ok(Run.gold > gold_before, "the second press pays")
			ok(Run.gold - gold_before < 30, "and pays LESS than the 30g purchase price")
			ok(Run.slots_used() == slots_before - 1, "and the slot comes free")
			ok(not Run.items.has(sell_id), "and the stack is gone")
			print("shop: %d supply rows, %d sell buttons, lowest y=%.0f, draft at y=%.0f" % [
				supply_rows.size(), sells, lowest, draft_top])
			shop.free()
			print("check_ct_map: %d checks / %d failures" % [_checks, _fails])
			get_tree().quit(1 if _fails > 0 else 0)
	stage += 1


func _open(label: String) -> void:
	map_scene = (load("res://scenes/map.tscn") as PackedScene).instantiate()
	add_child(map_scene)
	# The pouch row is the buttons sitting on the footer lines (584 and 618).
	var pouch: Array = []
	for n in map_scene.get_children():
		if n is Button and (absf(n.position.y - 584.0) < 1.0
				or absf(n.position.y - 618.0) < 1.0):
			pouch.append(n)
	var held: int = Run.slots_used()
	# One USE button and one DISCARD button per held slot.
	ok(pouch.size() == held * 2,
		"%s | drew %d pouch buttons for %d held slots (want %d)" % [
			label, pouch.size(), held, held * 2])
	var worst := 0.0
	for b in pouch:
		var right: float = b.position.x + b.custom_minimum_size.x
		worst = maxf(worst, right)
		ok(right <= VIEW_W_PX,
			"a pouch button ends at x=%.0f, past the %d-wide screen" % [
				right, int(VIEW_W_PX)])
		ok(b.position.x >= 0.0, "and none starts off the left edge")
	# The empty-slot placeholders, so "renders empty" is a drawn thing.
	var empties := 0
	for n in map_scene.get_children():
		if n is Label and String(n.text).find("empty slot") >= 0:
			empties += 1
			ok(n.position.x + n.custom_minimum_size.x <= VIEW_W_PX,
				"an empty-slot label ends inside the screen")
	ok(empties == Run.item_slots() - held,
		"drew %d empty-slot labels for %d free slots" % [
			empties, Run.item_slots() - held])
	print("%s | %d buttons, %d empty labels, rightmost edge x=%.0f" % [
		label, pouch.size(), empties, worst])


func _close() -> void:
	if map_scene != null and is_instance_valid(map_scene):
		map_scene.free()
	map_scene = null
