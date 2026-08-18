# The Blacksmith (Batch BK §3): the run's gold sink. Three ability upgrades
# on the counter, one price, gold only — no HP cost and no second currency,
# because the economy needs a PURE sink and a sink with a side-cost is a
# bargain wearing an anvil.
#
# IT SELLS THE SYSTEM BATCH AP ALREADY BUILT. The offer comes out of
# Run.roll_blacksmith_offer, which reuses AP §3's eligibility filter (never
# Honed on a Heal, never Effortless on a free ability) and writes into the
# SAME `member["upgrades"]` list the mini-boss pick writes — so a bought
# upgrade lands, wears the ◆ on the card and hovers exactly like an awarded
# one. Nothing here is a parallel implementation of anything.
#
# ONE PURCHASE ENDS THE VISIT. This is not a shop you clear: the choice is
# WHICH of the three, not whether to buy all of them, and a blacksmith you
# could empty would turn the gold curve into a checklist.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var offer: Array = []


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	Music.play("map")
	offer = Run.roll_blacksmith_offer()
	_draw_screen()


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.09, 0.06, 0.05)
	add_child(bg)

	var title := Label.new()
	title.text = "The Blacksmith"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(0.9, 0.74, 0.42))
	title.position = Vector2(0, 22)
	title.size = Vector2(1280, 52)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	var price := Run.blacksmith_price()
	var sub := Label.new()
	sub.text = "Gold: %d          One commission, %d gold.          Zone %d of %d." % [
		Run.gold, price, Run.zone_idx + 1, Run.SLOT_COUNT]
	sub.add_theme_font_size_override("font_size", 18)
	sub.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	sub.position = Vector2(0, 80)
	sub.size = Vector2(1280, 24)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)

	var flavor := Label.new()
	flavor.text = ("He works one piece at a time and will not be hurried.\n" +
		"Choose what he sharpens; the rest goes back on the rack.")
	flavor.add_theme_font_size_override("font_size", 14)
	flavor.add_theme_color_override("font_color", Color(0.68, 0.62, 0.56))
	flavor.position = Vector2(0, 112)
	flavor.size = Vector2(1280, 44)
	flavor.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(flavor)

	if offer.is_empty():
		# An honest dead end, said out loud. It happens when every hero's kit
		# already carries every upgrade that fits it — rare, and not an error.
		var none := Label.new()
		none.text = ("Nothing on the rack fits anything you carry.\n" +
			"Every upgrade the party's abilities can take, they already have.")
		none.add_theme_font_size_override("font_size", 17)
		none.add_theme_color_override("font_color", Color(0.72, 0.68, 0.62))
		none.position = Vector2(0, 300)
		none.size = Vector2(1280, 60)
		none.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(none)
	for i in offer.size():
		_draw_pairing(i, price)

	var leave := Button.new()
	leave.text = "Leave the forge" if not offer.is_empty() else "Walk on"
	leave.custom_minimum_size = Vector2(240, 48)
	leave.position = Vector2(520, 630)
	leave.pressed.connect(Music.click)
	leave.pressed.connect(_leave)
	add_child(leave)


func _draw_pairing(i: int, price: int) -> void:
	var pairing: Dictionary = offer[i]
	var member: Dictionary = Run.party[int(pairing["member_idx"])]
	var spec := String(member.get("spec", ""))
	var who: String = String(Classes.SPEC_INFO.get(spec, {}).get("name",
		String(member["key"]).capitalize()))

	var panel := PanelContainer.new()
	panel.position = Vector2(70 + i * 385, 190)
	panel.custom_minimum_size = Vector2(365, 400)
	add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var hero := Label.new()
	hero.text = who
	hero.add_theme_font_size_override("font_size", 18)
	hero.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	hero.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(hero)

	var upgrade := Label.new()
	upgrade.text = "◆ %s" % Run.upgrade_name(String(pairing["id"]))
	upgrade.add_theme_font_override("font", NAME_FONT)
	upgrade.add_theme_font_size_override("font_size", 28)
	upgrade.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
	upgrade.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(upgrade)

	var on_what := Label.new()
	on_what.text = "on %s" % String(pairing["ability"])
	on_what.add_theme_font_size_override("font_size", 16)
	on_what.add_theme_color_override("font_color", Color(0.8, 0.76, 0.7))
	on_what.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(on_what)

	var desc := Label.new()
	desc.text = Run.upgrade_desc(String(pairing["id"]))
	desc.add_theme_font_size_override("font_size", 14)
	desc.add_theme_color_override("font_color", Color(0.68, 0.65, 0.62))
	desc.custom_minimum_size = Vector2(335, 60)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(desc)

	var ab: Ability = Classes.pool_ability(String(pairing["ability"]))
	if ab != null:
		var about := Label.new()
		about.text = Classes.resolve_values(ab.description)
		about.add_theme_font_size_override("font_size", 12)
		about.add_theme_color_override("font_color", Color(0.55, 0.53, 0.5))
		about.custom_minimum_size = Vector2(335, 90)
		about.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		about.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(about)

	var buy := Button.new()
	buy.text = "Commission — %dg" % price
	buy.custom_minimum_size = Vector2(335, 44)
	buy.disabled = Run.gold < price
	if buy.disabled:
		buy.tooltip_text = "The party carries %d gold; he wants %d." % [
			Run.gold, price]
	buy.pressed.connect(Music.click)
	buy.pressed.connect(_buy.bind(i))
	vbox.add_child(buy)


func _buy(i: int) -> void:
	if i < 0 or i >= offer.size():
		return
	var pairing: Dictionary = offer[i]
	if not Run.buy_blacksmith(pairing):
		return
	Run.save_run()
	# One purchase ends the visit — the leave is immediate rather than a
	# redraw with two dead panels and a button that now says nothing.
	_leave()


func _leave() -> void:
	Run.save_run()
	get_tree().change_scene_to_file(Run.next_after_scene())
