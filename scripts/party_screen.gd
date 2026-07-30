# Party overview: pick a hero from the list, then one compact page shows
# their stats, class explanation, abilities, and their spec's talent tree.
# Specs are permanent once chosen (after the first victory).
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var selected := -1  # party index; -1 = list view


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	Music.play("map")
	_draw_screen()


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var back := Button.new()
	back.text = "< Back"
	back.custom_minimum_size = Vector2(110, 42)
	back.position = Vector2(20, 16)
	back.pressed.connect(_on_back)
	add_child(back)

	if selected < 0:
		_draw_list()
	else:
		_draw_detail()


func _on_back() -> void:
	if selected < 0:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	else:
		selected = -1
		_draw_screen()


func _title(text: String, y: float, size: int = 40) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_override("font", NAME_FONT)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	label.position = Vector2(0, y)
	label.size = Vector2(1280, size + 10)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)


func _draw_list() -> void:
	_title("The Untouched", 30)
	for i in Run.party.size():
		var member: Dictionary = Run.party[i]
		var key: String = member["key"]
		var spec: String = member.get("spec", "")
		# Awakened heroes go by their spec name; the class only shows pre-spec.
		var display: String = Classes.SPEC_INFO[spec]["name"] if spec != "" \
			else "%s — Unawakened" % key.capitalize()
		var btn := Button.new()
		var line := "%s\nHP %d/%d" % [display, member["hp"], member["max_hp"]]
		if key != "warrior":
			line += "    Mana %d/%d" % [member["mana"], member["max_mana"]]
		var pts: int = member.get("talent_points", 0)
		if pts > 0:
			line += "    ● %d POINTS TO SPEND" % pts
			btn.modulate = Color(1.0, 0.92, 0.55)
		btn.text = line
		btn.custom_minimum_size = Vector2(460, 88)
		btn.position = Vector2(410, 120 + i * 112)
		btn.add_theme_font_size_override("font_size", 18)
		btn.tooltip_text = Classes.CLASS_BLURBS[key]
		# Icon beside the name: the spec's portrait (original colors) when it
		# has one, else the class sprite crop tinted to match battle.
		btn.icon = Classes.class_icon(key, spec)
		if not Classes.SPEC_PORTRAITS.has(spec):
			var tint: Color = Classes.HERO_TINTS[i % Classes.HERO_TINTS.size()]
			for state in ["icon_normal_color", "icon_hover_color", "icon_pressed_color",
					"icon_focus_color"]:
				btn.add_theme_color_override(state, tint)
		btn.pressed.connect(_select_hero.bind(i))
		add_child(btn)


func _select_hero(idx: int) -> void:
	selected = idx
	_draw_screen()


# Spec passive text with talent-modified numbers baked in, so the sheet
# reflects Aggressive/Defensive Stance and Unstoppable ranks.
func _passive_desc_live(cfg: Dictionary, spec: String) -> String:
	var desc: String = Classes.SPEC_INFO[spec]["passive_desc"]
	match Classes.SPEC_INFO[spec]["passive"]:
		"seasoned":
			desc = "Seasoned Fighter: fights in one of two stances.\nAGGRESSIVE — +%d%% damage dealt, +10%% damage taken.\nDEFENSIVE — %d%% less damage taken, -10%% damage dealt.\nStarts each battle Aggressive; Guard Change swaps." % [
				int(round((0.15 + float(cfg.get("seasoned_off_bonus", 0.0))) * 100)),
				int(round((0.15 + float(cfg.get("seasoned_def_bonus", 0.0))) * 100))]
		"bloodrage":
			desc = "Blood Frenzy: +%s%% damage for every 5%% of health missing.\nHalf the highest bonus reached each battle is kept as a\nfloor — his fury never fully cools." % \
				String.num(2.0 + float(cfg.get("bloodrage_step_bonus", 0.0)), 1)
	return desc


func _draw_detail() -> void:
	var member: Dictionary = Run.party[selected]
	var key: String = member["key"]
	var cfg := Classes.hero_config(key)
	var base_hp: int = cfg["max_hp"]  # node scaling works off the base
	var spec: String = member.get("spec", "")
	if spec != "":
		cfg["abilities"] = cfg["abilities"] + Classes.spec_abilities(spec)
		Classes.apply_kit_overrides(cfg, spec)
		Classes.apply_passive(cfg, spec)
		# Specced heroes use their spec's stat block — the SAME helper the
		# battle spawn calls, so sheet and nameplate can never drift.
		Classes.apply_spec_stats(cfg, spec)
		# Spec blocks may override max_hp (Berserker 175): re-read the
		# scaling baseline after the block, mirroring the battle spawn.
		base_hp = cfg["max_hp"]
		Talents.apply_from_tree(cfg, member.get("tree", []), member.get("talents", {}))
	for rune in member.get("runes", []):
		if rune.get("equipped", false):
			Talents.apply_payload(cfg, rune["payload"], 1)
	cfg["max_hp"] = int(round(cfg["max_hp"] * (1.0 + cfg.get("max_hp_pct", 0.0))))
	# Toughness (Warden talent): Constitution grows with bulk — same order as
	# battle spawn (after every max-HP bonus has landed).
	if cfg.get("toughness_ranks", 0) > 0:
		cfg["constitution"] = int(cfg.get("constitution", 100)
			+ 0.05 * cfg["toughness_ranks"] * cfg["max_hp"])
	# Node scaling (mirrors battle spawn): +2% of base Attack & HP per win.
	var base_attack: int = cfg.get("attack", 100)
	if Run.combat_wins > 0:
		cfg["attack"] = int(round(base_attack * (1.0 + 0.02 * Run.combat_wins)))
		cfg["max_hp"] = int(cfg["max_hp"]) \
			+ int(round(base_hp * 0.02 * Run.combat_wins))
	var spec_label: String = Classes.SPEC_INFO[spec]["name"] if spec != "" else "Unawakened"
	# Awakened heroes are titled by spec; the class name only shows pre-spec.
	_title(spec_label if spec != "" else "%s — Unawakened" % cfg["unit_name"], 20, 34)

	# Left column: class blurb, stats, abilities (compact chips, hover detail).
	var blurb := Label.new()
	blurb.text = Classes.CLASS_BLURBS[key]
	blurb.add_theme_font_size_override("font_size", 13)
	blurb.add_theme_color_override("font_color", Color(0.65, 0.6, 0.55))
	blurb.position = Vector2(60, 80)
	blurb.size = Vector2(400, 44)
	blurb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(blurb)

	# Each stat is its own label so hovering explains just that stat.
	var crit_pct := int(round((0.10 + cfg.get("crit_bonus", 0.0)) * 100))
	var resource_tips := {
		"Mana": "Mana — spent on abilities; +12 at the start of each turn.",
		"Rage": "Rage — spent on abilities; +5 at turn start, +10 when hit,\nand attacks build more.",
	}
	# Resistances: armor's cousins, one per element (0% until specs get
	# their blocks). Weaknesses would show as negatives.
	var resist_lines := PackedStringArray()
	for res_type in ["fire", "frost", "nature", "holy", "shadow", "arcane"]:
		resist_lines.append("%s: %d%%" % [res_type.capitalize(),
			int(round(float(cfg.get("resists", {}).get(res_type, 0.0)) * 100))])
	var stat_rows: Array = [
		[["HP: %d / %d" % [member["hp"], cfg["max_hp"]],
			"Health — the hero falls at 0.\nValues include talents, equipped runes, and\nnode scaling (+2% of base per combat won)."],
		["Attack: %d" % cfg.get("attack", 100),
			"Attack — every ability hits for its listed %% of\nthis. Base %d for the spec's role; +2%% of base\nper combat node won (%d so far this run)." % [
				base_attack, Run.combat_wins]]],
		[["%s: %s" % [cfg["resource_name"],
			("%d / %d" % [member["mana"], cfg["max_resource"]]) if cfg["resource_name"] == "Mana"
			else "builds in combat"],
			resource_tips.get(cfg["resource_name"], "")]],
		[["Armor: %d%%" % int(round(cfg["armor"] * 100)),
			"Armor — % of incoming physical damage blocked."],
		["Resistances", "Resistances — like armor, but for each element:\n%s\n%s" % [
			" / ".join(resist_lines.slice(0, 3)), " / ".join(resist_lines.slice(3, 6))]],
		["Speed: %d" % int(cfg["speed"]),
			"Speed — how quickly turns arrive (100 = average)."],
		["Constitution: %d" % cfg.get("constitution", 100),
			"Constitution — Break resistance: incoming Break damage is\nscaled by 100/Constitution (100 = neutral, higher = tougher\nto Break)."]],
		[["Crit Chance: %d%%" % crit_pct,
			"Crit Chance — chance to strike for 50% extra damage\n(base 10% plus bonuses)."],
		["Parry: %d%%" % int(round((float(cfg.get("parry_chance", 0.05))
				+ float(cfg.get("parry_bonus", 0.0))) * 100)),
			"Parry — a parried MELEE hit deals 75%% less damage\nand Break damage (base %d%% for this hero plus\nbonuses; ranged attacks can't be parried)." % \
			int(round(float(cfg.get("parry_chance", 0.05)) * 100))]],
	]
	# Only pure tanks carry a Block stat (the Warden, for now).
	if cfg.get("block_chance", 0.0) > 0.0:
		stat_rows[3].append(["Block: %d%%" % int(round(cfg["block_chance"] * 100)),
			"Block — chance to fully negate an incoming attack:\nno damage, no Break damage, no effects.\nHeavy Plating adds another +15% in battle, and every\nunblocked hit adds +8% more (cap +40%) until a\nBlock lands and resets the climb."])
	for r in stat_rows.size():
		var row := HBoxContainer.new()
		row.position = Vector2(60, 132 + r * 22)
		row.add_theme_constant_override("separation", 24)
		add_child(row)
		for seg in stat_rows[r]:
			var stat_label := Label.new()
			stat_label.text = seg[0]
			stat_label.add_theme_font_size_override("font_size", 15)
			stat_label.add_theme_color_override("font_color", Color(0.88, 0.85, 0.78))
			stat_label.mouse_filter = Control.MOUSE_FILTER_STOP
			stat_label.tooltip_text = seg[1]
			row.add_child(stat_label)
	var class_p: Dictionary = Classes.CLASS_PASSIVES[key]
	var passive_lines := PackedStringArray(
		["Class: %s — %s" % [class_p["name"], class_p["desc"]]])
	if spec != "":
		passive_lines.append("Passive: %s" % _passive_desc_live(cfg, spec))
	var passive_label := Label.new()
	passive_label.text = "\n".join(passive_lines)
	passive_label.add_theme_font_size_override("font_size", 13)
	passive_label.add_theme_color_override("font_color", Color(0.88, 0.85, 0.78))
	passive_label.position = Vector2(60, 132 + stat_rows.size() * 22)
	passive_label.size = Vector2(400, 80)
	passive_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(passive_label)

	var ability_header := Label.new()
	ability_header.text = "ABILITIES  (hover for details)"
	ability_header.add_theme_font_size_override("font_size", 15)
	ability_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	ability_header.position = Vector2(60, 296)
	add_child(ability_header)

	var abilities: Array = cfg["abilities"]
	for i in abilities.size():
		var ab: Ability = abilities[i]
		var chip := PanelContainer.new()
		chip.position = Vector2(60 + (i % 2) * 205, 324 + (i / 2) * 46)
		chip.custom_minimum_size = Vector2(195, 38)
		var chip_label := Label.new()
		var cost_note := ""
		if ab.cost > 0:
			cost_note = "  (%d)" % ab.cost
		elif ab.faith_cost > 0:
			cost_note = "  (%dF)" % ab.faith_cost
		chip_label.text = "%s%s" % [ab.display_name, cost_note]
		chip_label.add_theme_font_size_override("font_size", 13)
		chip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		chip.add_child(chip_label)
		var tip := ab.description
		if ab.damage > 0:
			# Real numbers from the hero's current Attack, plus the scaling
			# behind them.
			var hit := ab.damage * 0.01 * float(cfg.get("attack", 100))
			tip += "\nDamage: %d–%d (%s)   BD: %d" % [int(hit * 0.9),
				int(round(hit * 1.1)), ab.dmg_type.capitalize(), ab.pressure]
			tip += "\nScaling: %d%% of Attack" % ab.damage
		if ab.heal > 0:
			tip += "\nHeals: %d" % ab.heal
		if ab.perfect_text != "":
			tip += "\nPerfect: %s" % ab.perfect_text
		chip.tooltip_text = tip
		add_child(chip)

	# Runes: equip up to 2 (run-scoped, bought at shops).
	var runes: Array = member.get("runes", [])
	var rune_header := Label.new()
	var equipped_count := 0
	for rune in runes:
		if rune.get("equipped", false):
			equipped_count += 1
	rune_header.text = "RUNES  (%d/2 equipped)" % equipped_count
	rune_header.add_theme_font_size_override("font_size", 15)
	rune_header.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	rune_header.position = Vector2(60, 520)
	add_child(rune_header)
	if runes.is_empty():
		var none := Label.new()
		none.text = "None yet — the Peddler sells them."
		none.add_theme_font_size_override("font_size", 12)
		none.add_theme_color_override("font_color", Color(0.55, 0.52, 0.5))
		none.position = Vector2(60, 548)
		add_child(none)
	for i in mini(runes.size(), 4):
		var rune: Dictionary = runes[i]
		var toggle := Button.new()
		var is_on: bool = rune.get("equipped", false)
		toggle.text = "Unequip" if is_on else "Equip"
		toggle.custom_minimum_size = Vector2(80, 26)
		toggle.position = Vector2(60, 546 + i * 34)
		toggle.add_theme_font_size_override("font_size", 11)
		toggle.disabled = not is_on and equipped_count >= 2
		toggle.pressed.connect(_toggle_rune.bind(i))
		add_child(toggle)
		var rune_label := Label.new()
		var equip_tag := "✦ " if rune.get("equipped", false) else ""
		rune_label.text = "%s%s — %s" % [equip_tag, rune["name"], rune["desc"]]
		rune_label.add_theme_font_size_override("font_size", 12)
		rune_label.add_theme_color_override("font_color",
			Color(0.45, 0.9, 0.5) if rune.get("equipped", false)
			else rune.get("rarity_color", Color(0.8, 0.8, 0.8)))
		rune_label.position = Vector2(150, 550 + i * 34)
		rune_label.size = Vector2(330, 20)
		add_child(rune_label)

	# Right side: the chosen spec's talent tree lives on this same page.
	var tree_header := Label.new()
	tree_header.add_theme_font_size_override("font_size", 15)
	tree_header.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	tree_header.position = Vector2(520, 80)
	tree_header.size = Vector2(700, 22)
	add_child(tree_header)

	if spec == "":
		tree_header.text = "TALENTS — the %s awakens after your first victory." % key.capitalize()
		return
	# Only designed (fixed) trees exist; the rest are on the way.
	if not Talents.has_tree(spec):
		tree_header.text = "TALENTS — %s tree" % Classes.SPEC_INFO[spec]["name"]
		var soon := Label.new()
		soon.text = "Coming soon."
		soon.add_theme_font_override("font", NAME_FONT)
		soon.add_theme_font_size_override("font_size", 30)
		soon.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
		soon.position = Vector2(500, 300)
		soon.size = Vector2(744, 40)
		soon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(soon)
		return
	if Talents.is_lane_tree(member.get("tree", [])):
		tree_header.text = "TALENTS — %s lanes    (Points: %d · next node costs %d)" % [
			Classes.SPEC_INFO[spec]["name"], member.get("talent_points", 0),
			Talents.next_node_cost(member.get("talents", {}))]
		_draw_lane_tree(member)
	else:
		tree_header.text = "TALENTS — %s tree    (Points: %d)" % [
			Classes.SPEC_INFO[spec]["name"], member.get("talent_points", 0)]
		_draw_fixed_tree(member.get("tree", []), member.get("talents", {}),
			member.get("talent_points", 0))
	# Beastmaster boss trophies wait on the Party screen until chosen.
	if not Classes.spec_pool(spec).is_empty() \
			and int(member.get("bm_picks_owed", 0)) > 0:
		_draw_bm_pick(member)


# ---------- fixed talent tree (styled after the "Appearance example") ----------

const TREE_BACK_POS := Vector2(500, 96)
const TREE_BACK_SIZE := Vector2(744, 566)
const TREE_NODE_SIZE := 56.0
# 5 columns x 4 rows, straight from the generator layout (col/row per node).
const TREE_COL_X := [570.0, 720.0, 870.0, 1020.0, 1170.0]
const TREE_ROW_Y := [160.0, 295.0, 430.0, 565.0]

var _tree_tip: PanelContainer
var _tree_tip_name: Label
var _tree_tip_desc: Label
var _tree_tip_state: Label


func _draw_fixed_tree(tree: Array, learned: Dictionary, points: int) -> void:
	# Dark backdrop (placeholder until dedicated tree art lands).
	var back := ColorRect.new()
	back.position = TREE_BACK_POS
	back.size = TREE_BACK_SIZE
	back.color = Color(0.05, 0.05, 0.06)
	add_child(back)
	# Faint grid lines through the node rows/columns, like the reference.
	for cx in TREE_COL_X:
		var v := ColorRect.new()
		v.position = Vector2(cx, TREE_BACK_POS.y)
		v.size = Vector2(1, TREE_BACK_SIZE.y)
		v.color = Color(1, 1, 1, 0.05)
		add_child(v)
	for cy in TREE_ROW_Y:
		var h := ColorRect.new()
		h.position = Vector2(TREE_BACK_POS.x, cy)
		h.size = Vector2(TREE_BACK_SIZE.x, 1)
		h.color = Color(1, 1, 1, 0.05)
		add_child(h)

	# Prerequisite connectors first, so the lines sit under the nodes.
	for talent in tree:
		var req: String = talent.get("requires", "")
		if req == "":
			continue
		var req_node := Talents.node_in_tree(tree, req)
		if req_node.is_empty():
			continue
		var line := Line2D.new()
		line.add_point(_node_center(req_node))
		line.add_point(_node_center(talent))
		line.width = 2.0
		line.default_color = Color(0.45, 0.42, 0.5, 0.6)
		add_child(line)
	for talent in tree:
		_make_tree_node(talent, learned, points, _node_center(talent))
	_build_tree_tip()


# ---------- lane talent tree (Batch 30 framework: Beastmaster pilot) ----------

const LANE_COL_X := [620.0, 872.0, 1124.0]
const LANE_ROW_Y := [150.0, 206.0, 262.0, 318.0, 374.0, 430.0, 486.0]
const LANE_CAP_Y := 566.0


# Lane order comes from the tree itself (first appearance), so converted
# classic trees and the Beastmaster pilot both lay out correctly.
func _tree_lanes(tree: Array) -> Array:
	var lanes: Array = []
	for t in tree:
		var lane := str(t.get("lane", ""))
		if lane != "" and not lanes.has(lane):
			lanes.append(lane)
	return lanes.slice(0, 3)


func _draw_lane_tree(member: Dictionary) -> void:
	var tree: Array = member.get("tree", [])
	var learned: Dictionary = member.get("talents", {})
	var order: Array = member.get("talent_order", [])
	var points: int = member.get("talent_points", 0)
	var lane_order := _tree_lanes(tree)
	var back := ColorRect.new()
	back.position = TREE_BACK_POS
	back.size = TREE_BACK_SIZE
	back.color = Color(0.05, 0.05, 0.06)
	add_child(back)
	# Lane spines + headers with live lane-point counts.
	for ci in mini(LANE_COL_X.size(), lane_order.size()):
		var v := ColorRect.new()
		v.position = Vector2(LANE_COL_X[ci], TREE_BACK_POS.y + 18)
		v.size = Vector2(1, TREE_BACK_SIZE.y - 30)
		v.color = Color(1, 1, 1, 0.05)
		add_child(v)
		var lane: String = lane_order[ci]
		var hdr := Label.new()
		hdr.text = "%s — %d pts" % [str(Talents.LANE_NAMES.get(lane, lane)).to_upper(),
			Talents.lane_points(tree, learned, order, lane)]
		hdr.add_theme_font_size_override("font_size", 13)
		hdr.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
		hdr.position = Vector2(LANE_COL_X[ci] - 110, TREE_BACK_POS.y + 6)
		hdr.size = Vector2(220, 16)
		hdr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(hdr)
	# Capstone shelf: one of three, forever.
	var cap_lbl := Label.new()
	cap_lbl.text = "— CAPSTONES · take ONE (%s in its lane) —" % \
		("6 nodes" if Talents.is_node_gated(tree) else "8 pts")
	cap_lbl.add_theme_font_size_override("font_size", 12)
	cap_lbl.add_theme_color_override("font_color", Color(0.7, 0.6, 0.75))
	cap_lbl.position = Vector2(TREE_BACK_POS.x, LANE_CAP_Y - 52)
	cap_lbl.size = Vector2(TREE_BACK_SIZE.x, 14)
	cap_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(cap_lbl)
	# Nodes: lanes fill top-down sorted by tier (converted classic trees mix
	# existing nodes with fillers, so definition order alone won't do);
	# capstones sit on the shelf.
	var lane_counts := {}
	var sorted_tree: Array = []
	for ti in tree.size():
		sorted_tree.append([int(tree[ti].get("tier", 0)) * 100 + ti, tree[ti]])
	sorted_tree.sort_custom(func(a, b): return a[0] < b[0])
	for pair in sorted_tree:
		var talent: Dictionary = pair[1]
		var lane: String = str(talent.get("lane", ""))
		var col := maxi(lane_order.find(lane), 0)
		var center: Vector2
		if talent.get("capstone", false):
			center = Vector2(LANE_COL_X[col], LANE_CAP_Y)
		else:
			var row: int = clampi(int(lane_counts.get(lane, 0)), 0, LANE_ROW_Y.size() - 1)
			center = Vector2(LANE_COL_X[col], LANE_ROW_Y[row])
			lane_counts[lane] = int(lane_counts.get(lane, 0)) + 1
		_make_tree_node(talent, learned, points, center, 44.0)
	_build_tree_tip()


func _build_tree_tip() -> void:
	# Shared hover tooltip: black panel, white bold name, yellow description.
	_tree_tip = PanelContainer.new()
	var tip_style := StyleBoxFlat.new()
	tip_style.bg_color = Color(0, 0, 0, 0.94)
	tip_style.set_corner_radius_all(4)
	tip_style.content_margin_left = 12.0
	tip_style.content_margin_right = 12.0
	tip_style.content_margin_top = 8.0
	tip_style.content_margin_bottom = 8.0
	_tree_tip.add_theme_stylebox_override("panel", tip_style)
	_tree_tip.visible = false
	_tree_tip.z_index = 20
	_tree_tip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tip_box := VBoxContainer.new()
	tip_box.add_theme_constant_override("separation", 4)
	tip_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tree_tip.add_child(tip_box)
	_tree_tip_name = Label.new()
	var bold := FontVariation.new()
	bold.base_font = ThemeDB.fallback_font
	bold.variation_embolden = 0.9
	_tree_tip_name.add_theme_font_override("font", bold)
	_tree_tip_name.add_theme_font_size_override("font_size", 15)
	_tree_tip_name.add_theme_color_override("font_color", Color.WHITE)
	tip_box.add_child(_tree_tip_name)
	_tree_tip_desc = Label.new()
	_tree_tip_desc.add_theme_font_size_override("font_size", 12)
	_tree_tip_desc.add_theme_color_override("font_color", Color(0.95, 0.82, 0.25))
	_tree_tip_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tree_tip_desc.custom_minimum_size = Vector2(300, 0)
	tip_box.add_child(_tree_tip_desc)
	_tree_tip_state = Label.new()
	_tree_tip_state.add_theme_font_size_override("font_size", 11)
	_tree_tip_state.add_theme_color_override("font_color", Color(0.65, 0.65, 0.65))
	tip_box.add_child(_tree_tip_state)
	add_child(_tree_tip)


func _node_center(talent: Dictionary) -> Vector2:
	return Vector2(TREE_COL_X[clampi(int(talent.get("col", 2)), 0, 4)],
		TREE_ROW_Y[clampi(int(talent.get("row", 0)), 0, 3)])


func _make_tree_node(talent: Dictionary, learned: Dictionary, points: int,
		center: Vector2, node_size: float = TREE_NODE_SIZE) -> void:
	var ranks_have := int(learned.get(talent["id"], 0))
	var check: Dictionary = Talents.can_learn(
		Run.party[selected].get("tree", []), talent["id"], learned,
		Run.party[selected].get("talent_order", []))
	var locked: bool = not check["ok"] and (check["why"].begins_with("Locked")
		or check["why"].begins_with("Barred") or check["why"].begins_with("Coming"))
	var maxed: bool = ranks_have >= int(talent["ranks"])

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(node_size, node_size)
	btn.position = center - Vector2(node_size / 2.0, node_size / 2.0)
	btn.focus_mode = Control.FOCUS_NONE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.10, 0.12)
	sb.border_color = Color(0.32, 0.62, 0.34) if maxed else Color(0.24, 0.24, 0.27)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	var sb_hover: StyleBoxFlat = sb.duplicate()
	sb_hover.border_color = Color(0.91, 0.78, 0.35)
	sb_hover.set_border_width_all(3)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", sb_hover)
	btn.add_theme_stylebox_override("pressed", sb_hover)
	# Placeholder emblem until node art lands (capstones wear a crown).
	btn.text = "♛" if talent.get("capstone", false) else "⚔"
	btn.add_theme_font_size_override("font_size", 24 if node_size >= 50.0 else 19)
	btn.add_theme_color_override("font_color",
		Color(0.30, 0.30, 0.34) if locked else Color(0.58, 0.58, 0.64))
	btn.add_theme_color_override("font_hover_color", Color(0.75, 0.75, 0.8))
	if locked:
		btn.modulate = Color(0.62, 0.62, 0.62)
	btn.pressed.connect(_on_tree_node_pressed.bind(talent["id"]))
	btn.mouse_entered.connect(_show_tree_tip.bind(talent, ranks_have, check, points, center))
	btn.mouse_exited.connect(_hide_tree_tip)
	add_child(btn)

	var pts_label := Label.new()
	pts_label.text = "%d/%d" % [ranks_have, int(talent["ranks"])]
	pts_label.add_theme_font_size_override("font_size", 12 if node_size >= 50.0 else 10)
	var pts_color := Color(0.78, 0.75, 0.7)
	if maxed:
		pts_color = Color(0.5, 0.9, 0.55)
	elif ranks_have > 0:
		pts_color = Color(0.95, 0.85, 0.4)
	pts_label.add_theme_color_override("font_color", pts_color)
	pts_label.position = center + Vector2(-node_size / 2.0, node_size / 2.0 + 1)
	pts_label.size = Vector2(node_size, 14)
	pts_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(pts_label)


func _show_tree_tip(talent: Dictionary, ranks_have: int, check: Dictionary,
		points: int, center: Vector2) -> void:
	_tree_tip_name.text = talent["name"]
	# Values reflect the invested points (rank-1 preview when unlearned).
	_tree_tip_desc.text = Talents.desc_for(talent, ranks_have)
	var state := "Rank %d/%d" % [ranks_have, int(talent["ranks"])]
	var cost := Talents.node_cost(Run.party[selected].get("tree", []),
		Run.party[selected].get("talents", {}), talent["id"])
	if ranks_have >= int(talent["ranks"]):
		state += "  —  MAXED"
	elif not check["ok"]:
		state += "  —  %s" % check["why"]
	elif points < cost:
		state += "  —  costs %d point%s (have %d)" % [cost,
			"" if cost == 1 else "s", points]
	else:
		state += "  —  click to spend %d point%s" % [cost,
			"" if cost == 1 else "s"]
	if talent.get("exclusive_with", "") != "":
		var sib := Talents.node_in_tree(Run.party[selected].get("tree", []),
			talent["exclusive_with"])
		state += "\nExclusive with %s" % sib.get("name", "its sibling")
	_tree_tip_state.text = state
	_tree_tip.visible = true
	# Sits to the left of the hovered node, like the reference image.
	_tree_tip.reset_size()
	var pos := center + Vector2(-TREE_NODE_SIZE / 2.0 - _tree_tip.size.x - 10, -24)
	pos.x = maxf(pos.x, 12.0)
	_tree_tip.position = pos


func _hide_tree_tip() -> void:
	if _tree_tip != null:
		_tree_tip.visible = false


func _on_tree_node_pressed(talent_id: String) -> void:
	_learn_talent(talent_id)


func _toggle_rune(rune_idx: int) -> void:
	var member: Dictionary = Run.party[selected]
	var runes: Array = member.get("runes", [])
	var rune: Dictionary = runes[rune_idx]
	if rune.get("equipped", false):
		rune["equipped"] = false
	else:
		var equipped_count := 0
		for r in runes:
			if r.get("equipped", false):
				equipped_count += 1
		if equipped_count >= 2:
			return
		rune["equipped"] = true
	_draw_screen()


func _learn_talent(talent_id: String) -> void:
	var member: Dictionary = Run.party[selected]
	var learned: Dictionary = member.get("talents", {})
	var tree: Array = member.get("tree", [])
	var cost := Talents.node_cost(tree, learned, talent_id)
	if member.get("talent_points", 0) < cost \
			or not Talents.can_learn(tree, talent_id, learned,
			member.get("talent_order", []))["ok"]:
		return
	var first_rank := int(learned.get(talent_id, 0)) < 1
	learned[talent_id] = int(learned.get(talent_id, 0)) + 1
	member["talents"] = learned
	member["talent_points"] = int(member.get("talent_points", 0)) - cost
	# Lane trees price nodes by purchase order — record it.
	if first_rank and Talents.is_lane_tree(tree):
		member["talent_order"] = member.get("talent_order", []) + [talent_id]
	_draw_screen()


# ---------- Beastmaster boss trophy: pick 1 of the remaining pool ----------

func _draw_bm_pick(member: Dictionary) -> void:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.04, 0.05, 0.97)
	style.border_color = Color(0.85, 0.7, 0.35)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 18.0
	style.content_margin_right = 18.0
	style.content_margin_top = 12.0
	style.content_margin_bottom = 14.0
	panel.add_theme_stylebox_override("panel", style)
	panel.position = Vector2(690, 170)
	panel.z_index = 18
	add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	title.text = "BOSS TROPHY — choose one ability (%d owed)" % \
		int(member.get("bm_picks_owed", 0))
	title.add_theme_font_size_override("font_size", 15)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	box.add_child(title)
	var pick_spec: String = member.get("spec", "")
	for pool_name in Classes.spec_pool(pick_spec):
		if pool_name in member.get("bm_abilities", []):
			continue
		var ab: Ability = Classes.spec_pool_ability(pick_spec, pool_name)
		var b := Button.new()
		b.text = pool_name
		b.custom_minimum_size = Vector2(300, 34)
		b.add_theme_font_size_override("font_size", 14)
		if ab != null:
			b.tooltip_text = "%s\n\n%s" % [pool_name, ab.description]
		b.pressed.connect(_pick_bm_ability.bind(pool_name))
		box.add_child(b)


func _pick_bm_ability(pool_name: String) -> void:
	var member: Dictionary = Run.party[selected]
	if int(member.get("bm_picks_owed", 0)) < 1 \
			or pool_name in member.get("bm_abilities", []):
		return
	member["bm_abilities"] = member.get("bm_abilities", []) + [pool_name]
	member["bm_picks_owed"] = int(member.get("bm_picks_owed", 0)) - 1
	Run.save_run()
	_draw_screen()
