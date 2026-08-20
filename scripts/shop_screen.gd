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


func _roll_offers() -> void:
	offers = []
	for i in Run.party.size():
		var member: Dictionary = Run.party[i]
		# The member dict (Batch X): eligibility reads spec, trophies, and
		# the owned pouch. Empty = runes off (DOD_SIM_RUNES) — no offer.
		var rune: Dictionary = Run.generate_rune(member)
		if rune.is_empty():
			continue
		var owned_names: Array = []
		for owned in member.get("runes", []):
			owned_names.append(owned["name"])
		for attempt in 4:
			if not owned_names.has(rune["name"]):
				break
			rune = Run.generate_rune(member)
		if not owned_names.has(rune["name"]):
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
			why = "\n\nThe party can carry %d of these, and already does." % cap
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

	# BATCH BO §3 — THE MERCHANT SELLS A DRAFT PICK. The third of the four
	# sources: an elite always gives one, an event may trade one, and this is
	# the one you can simply BUY. It sells the OFFER, not a named ability —
	# three cards are drawn at purchase and wait on the hero's card, resolved
	# by the same overlay every other owed pick uses.
	var draft_header := Label.new()
	draft_header.text = "THE DRAFT  (%dg each — a choice of three, on the hero's card)" % \
		Run.draft_price()
	draft_header.add_theme_font_size_override("font_size", 15)
	draft_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	draft_header.position = Vector2(140, 452)
	add_child(draft_header)
	for i in Run.party.size():
		var member: Dictionary = Run.party[i]
		var pools: Dictionary = Run.draft_pool_left(member)
		var left: int = pools["spec"].size() + pools["class"].size()
		var price := Run.draft_price()
		var dbtn := Button.new()
		dbtn.text = "%s — %dg" % [_hero_label(member), price]
		dbtn.custom_minimum_size = Vector2(360, 40)
		dbtn.position = Vector2(140, 482 + i * 44)
		dbtn.add_theme_font_size_override("font_size", 13)
		if left < 1:
			# THE POOL IS THIN UNTIL TRANCHE 3 and a Warrior's is empty
			# outright, so "nothing to sell you" is a state a player will
			# meet — and it says so rather than taking the gold.
			dbtn.text = "%s — nothing left to offer" % _hero_label(member)
			dbtn.tooltip_text = "Every ability this run could offer %s has been\nlearned, declined or dropped." % \
				_hero_label(member)
			dbtn.disabled = true
		else:
			dbtn.tooltip_text = "Draw three abilities for %s (%d still in the pool).\nThe cards are drawn NOW and wait on their hero card.\nAbility slots %d of %d." % [
				_hero_label(member), left, Run.ability_slots_used(member),
				Run.ABILITY_SLOT_CAP]
			dbtn.disabled = Run.gold < price
			dbtn.pressed.connect(_buy_draft.bind(i))
		add_child(dbtn)

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
		label.text = "%s  [%s]  (for %s %d)\n%s — equip it from the Party tab" % [rune["name"],
			rune["rarity"], member["key"].capitalize(), offer["member_idx"] + 1, rune["desc"]]
		label.add_theme_font_size_override("font_size", 14)
		label.add_theme_color_override("font_color", rune["rarity_color"])
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(label)
		var buy := Button.new()
		buy.text = "Buy — %dg" % _price(rune["price"])
		buy.custom_minimum_size = Vector2(140, 34)
		buy.disabled = Run.gold < _price(rune["price"])
		buy.pressed.connect(_buy_rune.bind(i))
		vbox.add_child(buy)

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


func _hero_label(member: Dictionary) -> String:
	var spec := String(member.get("spec", ""))
	if Classes.SPEC_INFO.has(spec):
		return String(Classes.SPEC_INFO[spec]["name"])
	return String(member["key"]).capitalize()


func _buy_draft(member_idx: int) -> void:
	var member: Dictionary = Run.party[member_idx]
	var price := Run.draft_price()
	# The offer is rolled BEFORE the gold moves, so a purchase that cannot
	# land never costs anything — the item cap's rule, applied to the draft.
	if Run.gold < price:
		return
	if not Run.award_draft_pick(member):
		return
	Run.gold -= price
	Run.tally_add("gold_spent", price)
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
