# THE BUILD SCREEN (Batch BM §4) — the meta talent tree's home, and it lives
# OUTSIDE a run because that is when talents are chosen. Reachable from the
# main menu and from the draft; it reads and writes `Profile` and never
# touches `Run`, so it works with no run in flight and refuses to work with
# one (see `_locked`).
#
# BATCH FX — ONE TREE, KEYED TO THE CLASS, AND A CELL BOUGHT IS A CELL WORN.
# The screen lists the four CLASSES, not the twelve specs: a Berserker, a
# Warden and a Swordmaster all spend the Warrior's purse in the same
# twenty-seven cells. The tree is three tiers of nine with no lanes and no
# rows, and nothing in it is exclusive, so there is nothing to equip — ONE
# click buys a cell and the cell is on every hero of that class from the next
# run on. What the screen exists to make legible now is the pair of TIER
# GATES, because a tier can be shut for two different reasons and a player
# fixes them differently:
#   dark        not owned, and buyable (the tooltip names the price)
#   green       OWNED — worn by every hero of this class, every run
#   dark red    the tier is shut: by difficulty (beat an end boss) or by
#               spend (own more cells in the tier below) — the tier's own
#               label says which
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const BACK_POS := Vector2(300, 96)
const BACK_SIZE := Vector2(956, 592)
# Nine cells across each tier band, and three bands down the board.
const COL_X0 := 452.0
const COL_STEP := 98.0
const TIER_Y := [168.0, 358.0, 548.0]
const NODE := 42.0
const LABEL_W := 94.0

const C_OPEN := Color(0.24, 0.24, 0.27)
const C_OWNED := Color(0.36, 0.72, 0.40)
const C_TIER_SHUT := Color(0.35, 0.16, 0.16)

var class_key := ""
var _tip: PanelContainer
var _tip_name: Label
var _tip_desc: Label
var _tip_state: Label


func _ready() -> void:
	Music.play("menu")
	var keys: Array = Classes.SPEC_IDS.keys()
	class_key = String(keys[0]) if not keys.is_empty() else ""
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

	_draw_class_list()
	if class_key == "":
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


# ---------- the four classes down the left edge ----------

func _class_name(key: String) -> String:
	return key.capitalize()


# Which specs spend this class's purse — said on the button, because the
# merge is the thing a returning player most needs told.
func _class_specs_line(key: String) -> String:
	var names := PackedStringArray()
	for spec in Classes.SPEC_IDS.get(key, []):
		names.append(String(Classes.SPEC_INFO[String(spec)]["name"]))
	return ", ".join(names)


func _draw_class_list() -> void:
	var y := 96.0
	for key in Classes.SPEC_IDS:
		var ck := String(key)
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(250, 58)
		btn.position = Vector2(24, y)
		btn.add_theme_font_size_override("font_size", 13)
		var avail := Profile.talent_points_available(ck)
		btn.text = "%s%s\n%s" % [_class_name(ck),
			"" if avail < 1 else "   (%d)" % avail, _class_specs_line(ck)]
		btn.disabled = ck == class_key
		if avail > 0 and ck != class_key:
			btn.modulate = Color(1.0, 0.9, 0.45)
		btn.pressed.connect(Music.click)
		btn.pressed.connect(_select_class.bind(ck))
		add_child(btn)
		y += 64.0


func _select_class(key: String) -> void:
	class_key = key
	_draw_screen()


# ---------- the header: the purse, the tiers, and the rules in one line ----------

func _draw_header() -> void:
	var tier := Profile.talent_tier()
	var earned := Profile.talent_points_earned(class_key)
	var avail := Profile.talent_points_available(class_key)
	var open_n := Talents.tiers_open(tier)
	var hdr := Label.new()
	hdr.text = "%s — %d point%s available of %d banked   ·   %s   ·   the whole tree is %d" % [
		_class_name(class_key), avail, "" if avail == 1 else "s", earned,
		"no tier open yet" if open_n < 1 else "tiers 1-%d open by difficulty" % open_n,
		Talents.full_tree_cost()]
	hdr.add_theme_font_size_override("font_size", 14)
	hdr.add_theme_color_override("font_color", Color(0.88, 0.8, 0.62))
	hdr.position = Vector2(BACK_POS.x, 66)
	hdr.size = Vector2(BACK_SIZE.x, 18)
	add_child(hdr)

	var legend := Label.new()
	legend.text = "CLICK a cell to buy it — every hero of this class wears it, every run  " \
		+ "·  a tier opens when its end boss falls AND %d cells of the tier below are owned" \
		% Talents.TIER_SPEND_MIN
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
	respec.text = "Respec %s" % _class_name(class_key)
	respec.tooltip_text = "Every point back and every cell cleared. Costs nothing, ever."
	respec.custom_minimum_size = Vector2(220, 30)
	respec.position = Vector2(BACK_POS.x, 690)
	respec.add_theme_font_size_override("font_size", 13)
	respec.pressed.connect(Music.click)
	respec.pressed.connect(_on_respec)
	add_child(respec)


func _on_respec() -> void:
	if _locked():
		return
	Profile.respec(class_key)
	_draw_screen()


# ---------- the board: three tiers of nine ----------

# Why a tier is shut, in the player's words, or "" when it is open. The two
# gates are different problems: one is fixed by winning, the other by buying.
func _tier_shut_reason(tier: int, tree: Array, cells: Dictionary, diff_tier: int) -> String:
	if not Talents.tier_open(tier, diff_tier):
		return "beat the end boss on difficulty %d" % Talents.difficulty_for_tier(tier)
	if not Talents.spend_gate_met(tree, cells, tier):
		return "own %d more in tier %d" % [
			Talents.TIER_SPEND_MIN - Talents.bought_in_tier(tree, cells, tier - 1), tier - 1]
	return ""


func _draw_tree() -> void:
	var tree: Array = Talents.tree()
	var cells := Profile.talent_cells(class_key)
	var diff_tier := Profile.talent_tier()

	var back := ColorRect.new()
	back.position = BACK_POS
	back.size = BACK_SIZE
	back.color = Color(0.05, 0.05, 0.06)
	add_child(back)

	for tier in range(1, Talents.TIERS + 1):
		var y: float = TIER_Y[tier - 1]
		var shut := _tier_shut_reason(tier, tree, cells, diff_tier)
		var band := ColorRect.new()
		band.position = Vector2(BACK_POS.x + 8, y - 44)
		band.size = Vector2(BACK_SIZE.x - 16, 170)
		band.color = Color(1, 1, 1, 0.03) if shut == "" else Color(0.35, 0.10, 0.10, 0.10)
		add_child(band)
		var lbl := Label.new()
		lbl.text = "TIER %d  ·  %dp a cell  ·  %d of %d owned%s" % [tier,
			Talents.cell_cost(tier), Talents.bought_in_tier(tree, cells, tier),
			Talents.NODES_PER_TIER, "" if shut == "" else "  ·  SHUT: %s" % shut]
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.add_theme_color_override("font_color",
			Color(0.62, 0.55, 0.38) if shut == "" else Color(0.85, 0.45, 0.40))
		lbl.position = Vector2(BACK_POS.x + 16, y - 40)
		lbl.size = Vector2(BACK_SIZE.x - 32, 14)
		add_child(lbl)
		var col := 0
		for t in Talents.tier_nodes(tree, tier):
			_make_node(t, cells, shut != "", Vector2(COL_X0 + COL_STEP * col - 118.0, y))
			col += 1


func _make_node(t: Dictionary, cells: Dictionary, tier_shut: bool, center: Vector2) -> void:
	var id := String(t["id"])
	var owned := bool(cells.get(id, false))

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(NODE, NODE)
	btn.position = center - Vector2(NODE / 2.0, NODE / 2.0)
	btn.focus_mode = Control.FOCUS_NONE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.10, 0.12)
	sb.border_color = C_OWNED if owned else (C_TIER_SHUT if tier_shut else C_OPEN)
	sb.set_border_width_all(3 if owned else 2)
	sb.set_corner_radius_all(6)
	var hover: StyleBoxFlat = sb.duplicate()
	hover.border_color = Color(0.91, 0.78, 0.35)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", hover)
	btn.text = "⚔" if owned else "⊘"
	btn.add_theme_font_size_override("font_size", 17)
	btn.add_theme_color_override("font_color",
		Color(0.75, 0.75, 0.8) if owned else Color(0.30, 0.30, 0.34))
	if not owned:
		btn.modulate = Color(0.7, 0.7, 0.7)
	btn.pressed.connect(_on_node.bind(id))
	btn.mouse_entered.connect(_show_tip.bind(t, center))
	btn.mouse_exited.connect(_hide_tip)
	add_child(btn)

	var name_lbl := Label.new()
	name_lbl.text = String(t["name"])
	name_lbl.add_theme_font_size_override("font_size", 10)
	name_lbl.add_theme_color_override("font_color",
		Color(0.80, 0.86, 0.78) if owned else Color(0.55, 0.53, 0.50))
	name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.position = Vector2(center.x - LABEL_W / 2.0, center.y + NODE / 2.0 + 4)
	name_lbl.size = Vector2(LABEL_W, 60)
	name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(name_lbl)


# ONE CLICK, ONE MEANING: an unowned cell is BOUGHT, and a bought cell is worn.
# Clicking an owned cell does nothing — pulling a point back is the respec,
# which cannot strand a tier the way a single refund can.
func _on_node(id: String) -> void:
	if _locked():
		return
	if Profile.owns_cell(class_key, id):
		return
	Music.click()
	Profile.buy_cell(class_key, id)
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
	_tip_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tip_name.custom_minimum_size = Vector2(320, 0)
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
	var tier := Talents.tier_of(t)
	var tree: Array = Talents.tree()
	var cells := Profile.talent_cells(class_key)
	_tip_name.text = String(t["name"])
	_tip_desc.text = Talents.desc_for(t, 1)
	var state := "Tier %d of %d  ·  %d point%s" % [tier, Talents.TIERS,
		Talents.cell_cost(tier), "" if Talents.cell_cost(tier) == 1 else "s"]
	if bool(cells.get(id, false)):
		state += "\nOWNED — every hero of this class wears it, every run."
	else:
		var check := Talents.can_buy(tree, id, cells,
			Profile.talent_points_available(class_key), Profile.talent_tier())
		state += "\n%s" % ("Click to buy it." if check["ok"] else String(check["why"]))
	if _locked():
		state += "\nA run is in flight; nothing here can change until it ends."
	_tip_state.text = state
	_tip.visible = true
	_tip.reset_size()
	var pos := center + Vector2(NODE / 2.0 + 10, -24)
	if pos.x + _tip.size.x > 1268.0:
		pos.x = center.x - NODE / 2.0 - _tip.size.x - 10
	pos.x = maxf(pos.x, 12.0)
	pos.y = clampf(pos.y, 12.0, 720.0 - _tip.size.y - 12.0)
	_tip.position = pos


func _hide_tip() -> void:
	if _tip != null:
		_tip.visible = false
