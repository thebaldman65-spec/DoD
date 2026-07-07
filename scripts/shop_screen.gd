# Shop node: spend gold on consumables and class runes (run-long ability
# and stat modifiers, one copy each).
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const ITEM_PRICES := {"health": 30, "mana": 30, "bomb": 45, "revive": 80, "defense": 40}

# Rune generation lives in Run (shared with elite drops); runes are run-scoped
# and only offered for classes present in the current party.
var offers: Array = []  # [{member_idx, rune}]


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
		var rune: Dictionary = Run.generate_rune(member["key"])
		var owned_names: Array = []
		for owned in member.get("runes", []):
			owned_names.append(owned["name"])
		for attempt in 4:
			if not owned_names.has(rune["name"]):
				break
			rune = Run.generate_rune(member["key"])
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
	var items_header := Label.new()
	items_header.text = "SUPPLIES"
	items_header.add_theme_font_size_override("font_size", 17)
	items_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	items_header.position = Vector2(140, 130)
	add_child(items_header)
	var row := 0
	for id in Run.ITEM_IDS:
		var price: int = ITEM_PRICES[id]
		var btn := Button.new()
		btn.text = "%s — %dg   (have %d)" % [Run.ITEM_INFO[id][0], price, Run.items.get(id, 0)]
		btn.custom_minimum_size = Vector2(360, 46)
		btn.position = Vector2(140, 162 + row * 56)
		btn.tooltip_text = Run.ITEM_INFO[id][1]
		btn.disabled = Run.gold < price
		btn.pressed.connect(_buy_item.bind(id))
		add_child(btn)
		row += 1

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
		buy.text = "Buy — %dg" % rune["price"]
		buy.custom_minimum_size = Vector2(140, 34)
		buy.disabled = Run.gold < rune["price"]
		buy.pressed.connect(_buy_rune.bind(i))
		vbox.add_child(buy)

	var leave := Button.new()
	leave.text = "Leave the Shop"
	leave.custom_minimum_size = Vector2(220, 48)
	leave.position = Vector2(530, 640)
	leave.pressed.connect(func():
		Run.save_run()
		get_tree().change_scene_to_file("res://scenes/map.tscn"))
	add_child(leave)


func _buy_item(id: String) -> void:
	var price: int = ITEM_PRICES[id]
	if Run.gold < price:
		return
	Run.gold -= price
	Run.items[id] = Run.items.get(id, 0) + 1
	_draw_screen()


func _buy_rune(offer_idx: int) -> void:
	var offer: Dictionary = offers[offer_idx]
	var rune: Dictionary = offer["rune"]
	if Run.gold < rune["price"]:
		return
	Run.gold -= rune["price"]
	var member: Dictionary = Run.party[offer["member_idx"]]
	var runes: Array = member.get("runes", [])
	runes.append(rune)
	member["runes"] = runes
	offers.remove_at(offer_idx)
	_draw_screen()
