# Shop node: spend gold on consumables and class runes (run-long ability
# and stat modifiers, one copy each).
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

# BATCH CT: the prices and the sell fraction moved to `Run`, beside ITEM_INFO
# and the stack caps — §6's "single place these numbers are written" covers a
# price as much as a heal. `run_sim.gd` kept a hand-copied mirror of the table
# that would have crashed the moment §4 added three ids; both read the one
# table now, at runtime, through the run node each already holds.

# Rune generation lives in Run (shared with elite drops); runes are run-scoped
# and only offered for classes present in the current party.
var offers: Array = []  # [{member_idx, rune}]
# BATCH FM §2 — WHICH HEROES THE PEDDLER HAD NOTHING FOR, kept beside the
# offers rather than derived at draw time from `Run.party.size() - offers.size()`
# — a hero can also be absent because the roll came back a duplicate, and the
# two are different sentences.
var _spent: Array = []  # member indices whose authored pool is exhausted
# BATCH CT §2: which Sell button is armed, if any. Session state on the screen
# rather than on the run — leaving the shop with a button armed and coming back
# must not find it still armed.
var _sell_pending := ""


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	Music.play("map")
	_roll_offers()
	_draw_screen()


# ══ BATCH FM §2 — AN EMPTY COLUMN IS RECORDED, NOT JUST SKIPPED ═════════════
#
# `Run.generate_rune` returning `{}` used to mean one thing — runes are off —
# and `continue` was the whole handling. FM §1 gives it a second meaning that a
# real run reaches: **the hero has seen every rune written for his spec.** Five
# a hero, spec-scoped, nothing universal left to fall back on. Skipping that
# silently leaves the merchant's rune column holding a header and white space,
# which is FE's finding wearing a different coat — a correct refusal that leaves
# the screen lying.
#
# So the indices are KEPT and `_draw_screen` says the sentence.
func _roll_offers() -> void:
	offers = []
	_spent = []
	for i in Run.party.size():
		var member: Dictionary = Run.party[i]
		# The member dict (Batch X): eligibility reads spec, trophies, and
		# the owned pouch. Empty = runes off (DOD_SIM_RUNES), or — since FM §1
		# — the hero's authored pool is spent.
		var rune: Dictionary = Run.generate_rune(member)
		if rune.is_empty():
			_spent.append(i)
			continue
		var owned_names: Array = []
		for owned in member.get("runes", []):
			owned_names.append(owned["name"])
		for attempt in 4:
			if not owned_names.has(rune["name"]):
				break
			rune = Run.generate_rune(member)
			# **AND THE RE-ROLL CAN COME BACK EMPTY NOW.** It could not before
			# FM §1 — the family always had one more stick — and reading
			# `rune["name"]` off `{}` on the next pass is a hard error, not a
			# missing offer. Unreachable today (the pouch cannot change inside
			# this loop, so a non-empty first draw means a non-empty pool), and
			# guarded anyway: "cannot happen" is not "is not guarded".
			if rune.is_empty():
				_spent.append(i)
				break
		if not rune.is_empty() and not owned_names.has(rune["name"]):
			offers.append({"member_idx": i, "rune": rune})


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var title := Label.new()
	title.text = "The Wandering Peddler"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 22)
	title.size = Vector2(1280, 52)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var gold_label := Label.new()
	gold_label.text = "Gold: %d" % Run.gold
	gold_label.add_theme_font_size_override("font_size", 20)
	gold_label.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	gold_label.position = Vector2(0, 80)
	gold_label.size = Vector2(1280, 24)
	gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(gold_label)

	# Consumables column.
	#
	# BATCH CT: EIGHT ITEM TYPES, NOT FIVE, AND THE OLD PITCH DOES NOT HOLD THEM.
	# At 56 apart and 46 tall, row 6 lands at y=442 and row 8 ends at y=600 —
	# straight through the DRAFT header at 452 and its four buttons below it.
	# Nothing in the brief flagged this (its only layout note is about the map
	# pouch), so it is measured rather than assumed: 8 rows at a 36 pitch and 32
	# tall run 162..446, which clears 452 with six pixels to spare and moves
	# nothing else on the screen.
	#
	# **BATCH FD §1 — THE THING IT WAS CLEARING IS GONE AND THE PITCH STAYS.**
	# The draft column below y=452 is removed, so nothing now bounds this column
	# from underneath. **THE 36 PITCH IS NOT WIDENED BACK**: the ninth item type
	# is the next thing to arrive here and it lands at 450 under this pitch and
	# at 610 under the old one, so the measured layout is the one that survives
	# growth. **The left column is empty from 452 to the Leave button at 640
	# now** — a cosmetic consequence of the ruling, reported and not redesigned.
	#
	# EVERY TYPE IS LISTED, HELD OR NOT. The shop is where a type you do not own
	# is acquired, so a slot-less pouch greys the button and says which wall it
	# hit — a missing row would read as "the merchant is out", which is a
	# different and untrue statement.
	var items_header := Label.new()
	items_header.text = "SUPPLIES  (pouch: %d/%d slots)" % [
		Run.slots_used(), Run.item_slots()]
	items_header.add_theme_font_size_override("font_size", 17)
	items_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	items_header.position = Vector2(140, 130)
	add_child(items_header)
	var row := 0
	for id in Run.ITEM_IDS:
		var price := _price(Run.ITEM_PRICES[id])
		var have := int(Run.items.get(id, 0))
		var cap: int = Run.item_stack_cap(id)
		var full: bool = Run.item_full(id)
		# §3's distinction, at the shop door: NO SLOT is a wall here rather than
		# an offer — a purchase is a thing the player initiates, so the honest
		# answer is "not until you free a slot", and the Sell button beside it is
		# how they do that. The swap OFFER exists for grants the player did not
		# ask for and cannot otherwise take.
		var no_slot: bool = Run.needs_slot(id)
		var btn := Button.new()
		btn.text = "%s — %dg   (have %d/%d)%s" % [Run.ITEM_INFO[id][0], price,
			have, cap, "  FULL" if full else ("  NO SLOT" if no_slot else "")]
		btn.custom_minimum_size = Vector2(360, 32)
		btn.position = Vector2(140, 162 + row * 36)
		btn.add_theme_font_size_override("font_size", 13)
		# Batch AN §6: a full stack greys the button rather than taking the
		# gold. Refusing at the door is the honest half of the cap — refusing
		# after payment would be theft with a message attached.
		var why := ""
		if full:
			why = "\n\nThe heroes can carry %d of these, and already do." % cap
		elif no_slot:
			why = "\n\nThe pouch is full at %d kinds. Sell or discard\na stack to make room." % \
				Run.item_slots()
		btn.tooltip_text = Run.ITEM_INFO[id][1] + why
		btn.disabled = Run.gold < price or full or no_slot
		btn.pressed.connect(_buy_item.bind(id))
		add_child(btn)
		# §2: sell back, for a fraction. Only for a type actually held — the slot
		# is what is being sold as much as the stack, and both go together.
		if Run.items.has(id):
			var sell := Button.new()
			var value := _sell_value(id)
			# TWO PRESSES, NOT ONE. This button sits inches from the BUY button and
			# destroys a whole stack — losing six Health Potions to a misclick
			# mid-run is not a mistake the 12 gold back makes up for. The map's
			# Discard asks first for the same reason; here the ask fits inside the
			# button rather than needing an overlay the shop has none of.
			var armed: bool = _sell_pending == id
			sell.text = "Sure? +%dg" % value if armed else "Sell +%dg" % value
			sell.custom_minimum_size = Vector2(96, 32)
			sell.position = Vector2(508, 162 + row * 36)
			sell.add_theme_font_size_override("font_size", 12)
			if armed:
				sell.add_theme_color_override("font_color", Color(0.95, 0.75, 0.4))
			sell.tooltip_text = "Sell the whole stack (%d %s) and free the slot.\nWorth %dg of the %dg they cost — a sale is a loss.\n%s" % [
				have, Run.ITEM_INFO[id][0], value, price,
				"Press again to confirm." if armed else "Press twice to sell."]
			sell.pressed.connect(_sell_item.bind(id))
			add_child(sell)
		row += 1

	# ── BATCH FD §1 — THE MERCHANT NO LONGER SELLS A DRAFT PICK ──────────────
	#
	# **RULED BY THE DESIGNER. IT WAS NOT A BUG AND THE RECORD SAYS SO** —
	# BATCH BO §3 built this deliberately, as the third of four draft sources:
	# *"an elite always gives one, an event may trade one, and this is the one
	# you can simply BUY."* It asked the same door every other source asks
	# (`Run.draft_pool_left` for what is left, `Run.award_draft_pick` to roll
	# the offer onto the hero's card), so it shares NO cause with FD §1's rune
	# hole; the two arrived on one screen and were reported as one symptom.
	#
	# **WHAT GOES WITH IT, STATED RATHER THAN DISCOVERED LATER.** The other
	# three sources stand untouched, so a draft pick is now earned and never
	# bought. `Run.draft_price()` keeps its 120g-per-zone ladder and is KEPT
	# with no game-side caller — the Melted Armor contract this project already
	# uses for a retired rune, so a later batch that wants a paid draft back
	# does not have to re-derive the price. **`run_sim` never bought one**
	# (its shop policy buys items and runes only), so no measured figure in the
	# economy report moves.

	# Rune offers column.
	var rune_header := Label.new()
	rune_header.text = "RUNES  (one of each, permanent for this run)"
	rune_header.add_theme_font_size_override("font_size", 17)
	rune_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	rune_header.position = Vector2(620, 130)
	add_child(rune_header)
	for i in offers.size():
		var offer: Dictionary = offers[i]
		var member: Dictionary = Run.party[offer["member_idx"]]
		var rune: Dictionary = offer["rune"]
		var panel := PanelContainer.new()
		panel.position = Vector2(620, 162 + i * 130)
		panel.custom_minimum_size = Vector2(520, 118)
		add_child(panel)
		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 6)
		panel.add_child(vbox)
		var label := Label.new()
		label.text = "%s  [%s]  (for %s %d)\n%s — equip it from that hero's sheet" % [rune["name"],
			rune["scope_label"], member["key"].capitalize(), offer["member_idx"] + 1, rune["desc"]]
		label.add_theme_font_size_override("font_size", 14)
		label.add_theme_color_override("font_color", rune["scope_color"])
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(label)
		var buy := Button.new()
		buy.text = "Buy — %dg" % _price(rune["price"])
		buy.custom_minimum_size = Vector2(140, 34)
		buy.disabled = Run.gold < _price(rune["price"])
		buy.pressed.connect(_buy_rune.bind(i))
		vbox.add_child(buy)

	# ── BATCH FM §2 — THE COLUMN SAYS WHY IT IS SHORT ────────────────────────
	#
	# **A HEADER OVER WHITE SPACE READS AS A BUG AND THE DESIGNER WILL HIT
	# THIS.** With the generated stat family out of the offer (FM §1) the pool
	# is authored-only and spec-scoped — **four to six a hero, of which three to
	# six are reachable at spawn** (FM §2's census; the brief's "five per hero"
	# is right about the shape and wrong about the number in both directions) —
	# so a hero draws nothing inside an ordinary run with no fault anywhere.
	# CO §3's rule is that a refusal with no reason reads as a bug, and this is
	# that rule applied to an offer that is simply absent rather than darkened.
	#
	# **RUNES-OFF IS NOT THIS SENTENCE.** Under `DOD_SIM_RUNES=off` the rune
	# layer does not exist and there is nothing to explain, so `_spent` is
	# announced only in `full` and `stats` — CO §3's own "two genuinely
	# different causes get two sentences", where the second sentence is
	# deliberately silence.
	# **ONE LINE PER HERO, NOT ONE LINE FOR THE COLUMN**, because the reason is
	# per-hero: a Warden who has bought all five and a Pyromancer whose last two
	# wait on Funeral Pyre and Firedraw are in different positions, and only one
	# of them can do anything about it.
	if Run.runes_mode() != "off":
		for si in _spent.size():
			var mi: int = int(_spent[si])
			var spent_label := Label.new()
			spent_label.text = "The Peddler has nothing for %s — %s." % [
				_hero_label(mi), Runes.empty_offer_reason(Run.party[mi])]
			spent_label.add_theme_font_size_override("font_size", 14)
			spent_label.add_theme_color_override("font_color", Color(0.58, 0.55, 0.62))
			spent_label.position = Vector2(620, 168 + offers.size() * 130 + si * 44)
			spent_label.size = Vector2(520, 42)
			spent_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			add_child(spent_label)

	var leave := Button.new()
	leave.text = "Leave the Shop"
	leave.custom_minimum_size = Vector2(220, 48)
	leave.position = Vector2(530, 640)
	leave.pressed.connect(func():
		# Batch BK: the merchant is a map node now, so leaving is nearly always
		# the map — but the bargain's bought merchant can still be pending, so
		# the run is still asked rather than assumed.
		var next := Run.next_after_scene()
		Run.save_run()
		get_tree().change_scene_to_file(next))
	add_child(leave)


# BATCH FM §2 — the hero as the player reads them on the map: the awakening's
# own name where the spec is chosen, the class otherwise, and always the party
# slot, because two Hunters in one party is an ordinary opening.
func _hero_label(idx: int) -> String:
	var member: Dictionary = Run.party[idx]
	var spec := String(member.get("spec", ""))
	var shown: String = String(Classes.SPEC_INFO.get(spec, {}).get(
		"name", String(member["key"]).capitalize()))
	return "%s %d" % [shown, idx + 1]


# Peddler's Lodestone and kin: every listed price honors the discount.
func _price(base: int) -> int:
	return maxi(int(round(base * (1.0 - Run.relic_add("shop_discount")))), 1)


func _buy_item(id: String) -> void:
	var price := _price(Run.ITEM_PRICES[id])
	# BOTH caps are checked BEFORE the gold moves, so a purchase that cannot
	# land never costs anything (the button is greyed too — this is the
	# second gate, for the hotkey and the test that fires it directly).
	if Run.gold < price or Run.item_full(id) or Run.needs_slot(id):
		return
	if Run.add_item(id) < 1:
		return
	Run.gold -= price
	Run.tally_add("gold_spent", price)
	# Buying is the opposite intent to selling: an armed Sell is stale now.
	_sell_pending = ""
	_draw_screen()


# BATCH CT §2 — what a stack sells for. Read off the SAME `_price` the buy
# button shows, so a Peddler's Lodestone discount cuts the sale as well as the
# purchase and the two can never be arbitraged against each other. Always at
# least 1g, and always strictly less than the purchase price: SELL_FRACTION is
# 0.4, and 0.4 of the cheapest item in the table (30g) is 12g, so the floor
# never collides with the price.
func _sell_value(id: String) -> int:
	return maxi(int(round(_price(Run.ITEM_PRICES[id]) * Run.SELL_FRACTION)), 1)


# The whole stack and the slot together — §2 is explicit that a partial stack
# cannot be split across slots, so there is no "sell three of six".
#
# A SALE PAYS EVEN ON AN EMPTY SLOT, and it pays the same. The slot is the
# thing with the value here: it is what the cap rations, and a player who
# drank their last Bomb should not have to DISCARD the empty slot for nothing
# when a merchant is standing right there. `have` is reported in the toastless
# redraw below rather than gating the sale.
func _sell_item(id: String) -> void:
	if not Run.items.has(id):
		_sell_pending = ""
		return
	# First press ARMS, second press sells. Arming a different row disarms the
	# one before it, so only ever one button is hot.
	if _sell_pending != id:
		_sell_pending = id
		_draw_screen()
		return
	_sell_pending = ""
	var value := _sell_value(id)
	if not Run.discard_item(id):
		return
	Run.gold += value
	Run.tally_add("gold_earned", value)
	_draw_screen()


func _buy_rune(offer_idx: int) -> void:
	var offer: Dictionary = offers[offer_idx]
	var rune: Dictionary = offer["rune"]
	if Run.gold < _price(rune["price"]):
		return
	Run.gold -= _price(rune["price"])
	Run.tally_add("gold_spent", _price(rune["price"]))
	var member: Dictionary = Run.party[offer["member_idx"]]
	var runes: Array = member.get("runes", [])
	runes.append(rune)
	member["runes"] = runes
	offers.remove_at(offer_idx)
	_draw_screen()
