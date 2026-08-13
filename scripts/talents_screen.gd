# THE BUILD SCREEN (Batch BM §4) — the meta talent tree's home, and it lives
# OUTSIDE a run because that is when talents are chosen. Reachable from the
# main menu and from the draft; it reads and writes `Profile` and never
# touches `Run`, so it works with no run in flight and refuses to work with
# one (see `_locked`).
#
# THE ONE THING THIS SCREEN EXISTS TO MAKE LEGIBLE: BUYING A CELL UNLOCKS AN
# OPTION, IT DOES NOT EQUIP IT. Two clicks, two states, two colours, and the
# legend says so in words — because the whole design collapses into "a tree
# you fill in" the moment a player believes one click does both.
#   dark      not unlocked (and the tooltip says what it costs, or which
#             difficulty opens its row)
#   bronze    UNLOCKED — an option this row now argues over
#   green     EQUIPPED — the one node in its row that a run will wear
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const BACK_POS := Vector2(300, 96)
const BACK_SIZE := Vector2(956, 592)
const LANE_COL_X := [520.0, 776.0, 1032.0]
const ROW_Y := [150.0, 198.0, 246.0, 294.0, 342.0, 390.0, 438.0, 486.0]
const CAP_Y := 552.0
const NODE := 40.0

const C_LOCKED := Color(0.24, 0.24, 0.27)
const C_OWNED := Color(0.72, 0.55, 0.28)
const C_EQUIPPED := Color(0.36, 0.72, 0.40)
const C_TIER_SHUT := Color(0.35, 0.16, 0.16)

var spec := ""
var _tip: PanelContainer
var _tip_name: Label
var _tip_desc: Label
var _tip_state: Label


func _ready() -> void:
	Music.play("menu")
	var ids: Array = Classes.all_specs()
	spec = String(ids[0]) if not ids.is_empty() else ""
	_draw_screen()


# A RUN IN FLIGHT MAKES THIS SCREEN READ-ONLY, and that is the rule rather
# than an affordance: points are freely reassignable between runs and NEVER
# during one. The screen is still reachable (a player mid-run wants to see
# what they are wearing) — it simply cannot spend.
func _locked() -> bool:
	return Run.active


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.07, 0.06, 0.09)
	add_child(bg)

	var back := Button.new()
	back.text = "< Back"
	back.custom_minimum_size = Vector2(110, 42)
	back.position = Vector2(20, 16)
	back.pressed.connect(Music.click)
	back.pressed.connect(_on_back)
	add_child(back)

	var title := Label.new()
	title.text = "TALENTS"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 20)
	title.size = Vector2(1280, 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	_draw_spec_list()
	if spec == "" or not Talents.has_tree(spec):
		return
	_draw_header()
	_draw_tree()
	_build_tip()


func _on_back() -> void:
	# Back to wherever makes sense: the map when a run is in flight, the menu
	# otherwise. One button, no dead end.
	if Run.active:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


# ---------- the twelve specs down the left edge ----------

func _draw_spec_list() -> void:
	var y := 96.0
	for id in Classes.all_specs():
		var sid := String(id)
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(250, 44)
		btn.position = Vector2(24, y)
		btn.add_theme_font_size_override("font_size", 13)
		var avail := Profile.talent_points_available(sid)
		btn.text = "%s%s" % [String(Classes.SPEC_INFO[sid]["name"]),
			"" if avail < 1 else "   (%d)" % avail]
		btn.disabled = sid == spec
		if avail > 0 and sid != spec:
			btn.modulate = Color(1.0, 0.9, 0.45)
		btn.pressed.connect(Music.click)
		btn.pressed.connect(_select_spec.bind(sid))
		add_child(btn)
		y += 48.0


func _select_spec(id: String) -> void:
	spec = id
	_draw_screen()


# ---------- the header: the purse, the tier, and the rules in one line ----------

func _draw_header() -> void:
	var tier := Profile.talent_tier()
	var earned := Profile.talent_points_earned(spec)
	var avail := Profile.talent_points_available(spec)
	var hdr := Label.new()
	hdr.text = "%s — %d point%s available of %d banked   ·   rows 1-%d unlocked   ·   a full tree is %d" % [
		String(Classes.SPEC_INFO[spec]["name"]), avail, "" if avail == 1 else "s",
		earned, Talents.rows_unlocked(tier), Talents.full_spec_cost()]
	hdr.add_theme_font_size_override("font_size", 14)
	hdr.add_theme_color_override("font_color", Color(0.88, 0.8, 0.62))
	hdr.position = Vector2(BACK_POS.x, 66)
	hdr.size = Vector2(BACK_SIZE.x, 18)
	add_child(hdr)

	var legend := Label.new()
	legend.text = "CLICK to unlock a cell  ·  CLICK AN UNLOCKED CELL to equip it for your next run  " \
		+ "·  unlocking is not equipping: you still take ONE node per row"
	legend.add_theme_font_size_override("font_size", 11)
	legend.add_theme_color_override("font_color", Color(0.6, 0.56, 0.5))
	legend.position = Vector2(BACK_POS.x, 86)
	legend.size = Vector2(BACK_SIZE.x, 14)
	add_child(legend)

	if _locked():
		var lock := Label.new()
		lock.text = "A RUN IS IN FLIGHT — talents are locked until it ends."
		lock.add_theme_font_size_override("font_size", 13)
		lock.add_theme_color_override("font_color", Color(0.95, 0.5, 0.45))
		lock.position = Vector2(BACK_POS.x, 694)
		lock.size = Vector2(BACK_SIZE.x, 16)
		add_child(lock)
		return

	var respec := Button.new()
	respec.text = "Respec %s" % String(Classes.SPEC_INFO[spec]["name"])
	respec.tooltip_text = "Every point back, every cell and every equip cleared. Costs nothing, ever."
	respec.custom_minimum_size = Vector2(220, 38)
	respec.position = Vector2(BACK_POS.x, 690)
	respec.add_theme_font_size_override("font_size", 13)
	respec.pressed.connect(Music.click)
	respec.pressed.connect(_on_respec)
	add_child(respec)


func _on_respec() -> void:
	if _locked():
		return
	Profile.respec(spec)
	_draw_screen()


# ---------- the grid ----------

func _row_y(row: int) -> float:
	if row >= Talents.CAPSTONE_ROW:
		return CAP_Y
	return ROW_Y[clampi(row - 1, 0, ROW_Y.size() - 1)]


func _lane_order(tree: Array) -> Array:
	var lanes: Array = []
	for t in tree:
		var lane := str(t.get("lane", ""))
		if lane != "" and not lanes.has(lane):
			lanes.append(lane)
	return lanes.slice(0, 3)


func _draw_tree() -> void:
	var tree: Array = Talents.generate_tree(spec, "")
	var cells := Profile.talent_cells(spec)
	var equipped := Profile.talent_equipped(spec)
	var tier := Profile.talent_tier()
	var lanes := _lane_order(tree)

	var back := ColorRect.new()
	back.position = BACK_POS
	back.size = BACK_SIZE
	back.color = Color(0.05, 0.05, 0.06)
	add_child(back)

	for ci in mini(LANE_COL_X.size(), lanes.size()):
		var hdr := Label.new()
		hdr.text = str(Talents.LANE_NAMES.get(lanes[ci], lanes[ci])).to_upper()
		hdr.add_theme_font_size_override("font_size", 13)
		hdr.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
		hdr.position = Vector2(LANE_COL_X[ci] - 110, BACK_POS.y + 4)
		hdr.size = Vector2(220, 16)
		hdr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(hdr)

	# One label per row saying what the row costs and whether it is open at
	# all. A locked TIER reads differently from an unaffordable cell — those
	# are different problems and a player fixes them differently.
	for row in range(1, Talents.CAPSTONE_ROW + 1):
		var open_row := Talents.row_unlocked(row, tier)
		var lbl := Label.new()
		lbl.text = "row %d  ·  %dp" % [row, Talents.cell_cost(row)] if open_row \
			else "row %d  ·  diff %d" % [row, Talents.tier_of_row(row)]
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color",
			Color(0.62, 0.55, 0.38) if open_row else C_TIER_SHUT)
		lbl.position = Vector2(BACK_POS.x + 8, _row_y(row) - 7)
		lbl.size = Vector2(LANE_COL_X[0] - BACK_POS.x - 60, 14)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		add_child(lbl)

	var cap := Label.new()
	cap.text = "— CAPSTONE SHELF · ONE PER HERO, EVER · any lane —"
	cap.add_theme_font_size_override("font_size", 11)
	cap.add_theme_color_override("font_color", Color(0.7, 0.6, 0.75))
	cap.position = Vector2(BACK_POS.x, CAP_Y - 30)
	cap.size = Vector2(BACK_SIZE.x, 13)
	cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(cap)

	for t in tree:
		var col := maxi(lanes.find(str(t.get("lane", ""))), 0)
		var row2 := int(t.get("row", 1))
		_make_node(t, cells, equipped, tier,
			Vector2(LANE_COL_X[col], _row_y(row2)))


func _make_node(t: Dictionary, cells: Dictionary, equipped: Dictionary,
		tier: int, center: Vector2) -> void:
	var id := String(t["id"])
	var row := int(t.get("row", 1))
	var owned := bool(cells.get(id, false))
	var is_eq := String(equipped.get(str(row), "")) == id
	var open_row := Talents.row_unlocked(row, tier)

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(NODE, NODE)
	btn.position = center - Vector2(NODE / 2.0, NODE / 2.0)
	btn.focus_mode = Control.FOCUS_NONE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.10, 0.12)
	sb.border_color = C_EQUIPPED if is_eq else (C_OWNED if owned \
		else (C_LOCKED if open_row else C_TIER_SHUT))
	sb.set_border_width_all(3 if is_eq else 2)
	sb.set_corner_radius_all(6)
	var hover: StyleBoxFlat = sb.duplicate()
	hover.border_color = Color(0.91, 0.78, 0.35)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", hover)
	btn.text = "♛" if t.get("capstone", false) else ("⚔" if owned else "⊘")
	btn.add_theme_font_size_override("font_size", 17)
	btn.add_theme_color_override("font_color",
		Color(0.75, 0.75, 0.8) if owned else Color(0.30, 0.30, 0.34))
	if not owned:
		btn.modulate = Color(0.7, 0.7, 0.7)
	btn.pressed.connect(_on_node.bind(id))
	btn.mouse_entered.connect(_show_tip.bind(t, center))
	btn.mouse_exited.connect(_hide_tip)
	add_child(btn)


# ONE CLICK, TWO MEANINGS, AND THE ORDER IS THE DESIGN: an unowned cell is
# BOUGHT; an owned one is EQUIPPED. A player never has to learn a modifier
# key, and the second click is the one that teaches them the distinction.
func _on_node(id: String) -> void:
	if _locked():
		return
	Music.click()
	if Profile.owns_cell(spec, id):
		var tree: Array = Talents.generate_tree(spec, "")
		var row := int(Talents.node_in_tree(tree, id).get("row", 1))
		if String(Profile.talent_equipped(spec).get(str(row), "")) == id:
			Profile.unequip_row(spec, row)
		else:
			Profile.equip_cell(spec, id)
	else:
		Profile.buy_cell(spec, id)
	_draw_screen()


# ---------- the tooltip ----------

func _build_tip() -> void:
	_tip = PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.94)
	style.set_corner_radius_all(4)
	style.content_margin_left = 12.0
	style.content_margin_right = 12.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	_tip.add_theme_stylebox_override("panel", style)
	_tip.visible = false
	_tip.z_index = 20
	_tip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tip.add_child(box)
	_tip_name = Label.new()
	var bold := FontVariation.new()
	bold.base_font = ThemeDB.fallback_font
	bold.variation_embolden = 0.9
	_tip_name.add_theme_font_override("font", bold)
	_tip_name.add_theme_font_size_override("font_size", 15)
	_tip_name.add_theme_color_override("font_color", Color.WHITE)
	box.add_child(_tip_name)
	_tip_desc = Label.new()
	_tip_desc.add_theme_font_size_override("font_size", 12)
	_tip_desc.add_theme_color_override("font_color", Color(0.95, 0.82, 0.25))
	_tip_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tip_desc.custom_minimum_size = Vector2(320, 0)
	box.add_child(_tip_desc)
	_tip_state = Label.new()
	_tip_state.add_theme_font_size_override("font_size", 11)
	_tip_state.add_theme_color_override("font_color", Color(0.65, 0.65, 0.65))
	_tip_state.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tip_state.custom_minimum_size = Vector2(320, 0)
	box.add_child(_tip_state)
	add_child(_tip)


func _show_tip(t: Dictionary, center: Vector2) -> void:
	var id := String(t["id"])
	var row := int(t.get("row", 1))
	var tree: Array = Talents.generate_tree(spec, "")
	var cells := Profile.talent_cells(spec)
	var equipped := Profile.talent_equipped(spec)
	_tip_name.text = String(t["name"])
	_tip_desc.text = Talents.desc_for(t, 1)
	var state := "Capstone shelf" if row >= Talents.CAPSTONE_ROW \
		else "Row %d of %d" % [row, Talents.ROWS]
	state += "  ·  %d point%s" % [Talents.cell_cost(row),
		"" if Talents.cell_cost(row) == 1 else "s"]
	if bool(cells.get(id, false)):
		if String(equipped.get(str(row), "")) == id:
			state += "\nEQUIPPED — click to take it off."
		else:
			state += "\nUNLOCKED but not equipped. Click to equip it; it will replace"
			state += " whatever else holds this row."
			var held := String(equipped.get(str(row), ""))
			if held != "":
				state += "\nThis row currently holds %s." % \
					Talents.node_in_tree(tree, held).get("name", held)
	else:
		var check := Talents.can_buy(tree, id, cells,
			Profile.talent_points_available(spec), Profile.talent_tier())
		state += "\n%s" % ("Click to unlock this cell." if check["ok"] else String(check["why"]))
		state += "\nUnlocking makes it an OPTION for this row — it does not equip it."
	if _locked():
		state += "\nA run is in flight; nothing here can change until it ends."
	_tip_state.text = state
	_tip.visible = true
	_tip.reset_size()
	var pos := center + Vector2(-NODE / 2.0 - _tip.size.x - 10, -24)
	pos.x = maxf(pos.x, 12.0)
	pos.y = clampf(pos.y, 12.0, 720.0 - _tip.size.y - 12.0)
	_tip.position = pos


func _hide_tip() -> void:
	if _tip != null:
		_tip.visible = false
