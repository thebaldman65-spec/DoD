# The HERO SHEET: one compact page showing a hero's stats, class
# explanation, abilities, runes and their spec's talent tree.
#
# BATCH AN DELETED THE LIST VIEW. The map screen carries all four hero cards
# now, so it IS the party list — this page is only ever entered for a
# specific hero (Run.hero_screen_idx, set by the card that was clicked) and
# Back returns to the map. The rune-EQUIP and pick flows moved onto the card
# too; runes are shown here as a read-only summary of what the hero is
# wearing, because the sheet is where their numbers are already explained.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var selected := 0  # party index; always a real hero now


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	selected = clampi(Run.hero_screen_idx, 0, maxi(Run.party.size() - 1, 0))
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

	# Batch Z: the glossary panel — reachable everywhere a build decision
	# gets made, and talents are the biggest one.
	var glossary_btn := Button.new()
	glossary_btn.text = "Glossary"
	glossary_btn.custom_minimum_size = Vector2(110, 42)
	glossary_btn.position = Vector2(140, 16)
	glossary_btn.pressed.connect(func(): GlossaryPanel.open(self))
	add_child(glossary_btn)

	_draw_hero_switcher()
	_draw_detail()


func _on_back() -> void:
	Run.save_run()
	get_tree().change_scene_to_file("res://scenes/map.tscn")


# The list view is gone, but flipping between four heroes without going back
# to the map is worth one row of buttons — comparing two trees is a normal
# thing to want to do.
func _draw_hero_switcher() -> void:
	for i in Run.party.size():
		var member: Dictionary = Run.party[i]
		var spec := String(member.get("spec", ""))
		var btn := Button.new()
		btn.text = Classes.SPEC_INFO[spec]["name"] if spec != "" \
			else String(member["key"]).capitalize()
		btn.custom_minimum_size = Vector2(150, 28)
		# Under the title, not beside it: a centred title and a centred row of
		# four buttons collide in the middle of the screen.
		btn.position = Vector2(324 + i * 158, 46)
		btn.add_theme_font_size_override("font_size", 12)
		btn.disabled = i == selected
		var pts: int = int(member.get("talent_points", 0)) \
			+ int(member.get("talent_flex", 0))
		if pts > 0 and i != selected:
			btn.modulate = Color(1.0, 0.9, 0.45)
		btn.pressed.connect(Music.click)
		btn.pressed.connect(_select_hero.bind(i))
		add_child(btn)


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


func _select_hero(idx: int) -> void:
	selected = idx
	_draw_screen()


# Spec passive text with talent-modified numbers baked in, so the sheet
# reflects Aggressive/Defensive Stance and Unstoppable ranks.
func _passive_desc_live(cfg: Dictionary, spec: String) -> String:
	var desc: String = Classes.SPEC_INFO[spec]["passive_desc"]
	match Classes.SPEC_INFO[spec]["passive"]:
		"seasoned":
			desc = "Seasoned Fighter: fights in one of two stances.\nAGGRESSIVE — +%d%% damage dealt, +10%% damage taken.\nDEFENSIVE — %d%% less damage taken, -10%% damage dealt.\nStarts each battle Aggressive; the earnable\nGuard Change swaps." % [
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
		# Earned abilities (Batch AH) — BEFORE the tree, exactly as the
		# battle spawn orders them, so a talent that modifies a pool-bought
		# ability shows the same numbers here that it will in the fight.
		# Six of a full kit's ten come from here; the sheet has to show them.
		for bm_name in member.get("bm_abilities", []):
			var bm_ab := Classes.spec_pool_ability(spec, String(bm_name))
			if bm_ab != null and not cfg["abilities"].any(
					func(a): return a.display_name == bm_ab.display_name):
				cfg["abilities"] = cfg["abilities"] + [bm_ab]
		Talents.apply_from_tree(cfg, member.get("tree", []), member.get("talents", {}),
			member)
	for rune in member.get("runes", []):
		if rune.get("equipped", false):
			Talents.apply_payload(cfg, rune["payload"], 1,
				{"learned": member.get("talents", {}), "member": member})
	# Mini-boss ability upgrades (Batch AP), LAST — same order as the battle
	# spawn, and for the same reason: a talent that SETS a field would
	# otherwise overwrite the upgrade. The sheet has to show the numbers the
	# fight will use.
	# Batch AQ §5A: the RETURN is captured now instead of discarded — it names
	# what actually LANDED, so the sheet's ◆ carries the same guarantee the
	# battle tooltip has and can never advertise an upgrade that did not apply.
	var landed_upgrades: Dictionary = Run.apply_upgrades(member, cfg["abilities"])
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
	_title(spec_label if spec != "" else "%s — Unawakened" % cfg["unit_name"], 6, 30)

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
	# Resistances: armor's cousins, one per damage type — physical included,
	# since spec blocks can carry it (the Arcanist is soft to it) and the
	# battle plate's hover card lists it. Weaknesses show as negatives.
	var resist_lines := PackedStringArray()
	for res_type in ["physical", "fire", "frost", "nature", "holy", "shadow", "arcane"]:
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
		["Resistances", "Resistances — like armor, but per damage type:\n%s\n%s" % [
			" / ".join(resist_lines.slice(0, 4)), " / ".join(resist_lines.slice(4, 7))]],
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
		# Batch AQ §5A: the same ◆ mark and the same gold the battle action
		# button wears, off the same source of truth (what apply_upgrades said
		# landed). Twelve upgrades a run were invisible outside a fight.
		var ups: Array = landed_upgrades.get(ab.display_name, [])
		chip_label.text = "%s%s%s" % ["◆ " if not ups.is_empty() else "",
			ab.display_name, cost_note]
		chip_label.add_theme_font_size_override("font_size", 13)
		if not ups.is_empty():
			chip_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
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
		# Trailing line, names only — the same line and the same place the
		# battle button's tooltip puts it. The magnitudes are already in the
		# numbers above, which reflect the upgrade.
		if not ups.is_empty():
			tip += "\n%s" % " · ".join(PackedStringArray(ups))
		chip.tooltip_text = tip
		add_child(chip)

	# Runes: THREE SLOTS FLAT from run start (Batch AN §9 — the 2/3/4 growth
	# ladder is gone). READ-ONLY here: equipping happens on the map card, so
	# there is one place that writes `equipped` and this page can be what it
	# is good at — showing the numbers those runes are already producing in
	# the stat block above.
	var runes: Array = member.get("runes", [])
	var slot_cap := Run.rune_slots()
	var rune_header := Label.new()
	var equipped_count := 0
	for rune in runes:
		if rune.get("equipped", false):
			equipped_count += 1
	rune_header.text = "RUNES  (%d/%d equipped — swap them on the map)" % [
		equipped_count, slot_cap]
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
	# The pouch can outgrow the page (elite drops have no cap), so the rows
	# live in a scroller — every owned rune renders, never a silent cut.
	var rune_scroll := ScrollContainer.new()
	rune_scroll.position = Vector2(55, 544)
	rune_scroll.size = Vector2(450, 720 - 544 - 8)
	rune_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(rune_scroll)
	var rune_rows := VBoxContainer.new()
	rune_rows.add_theme_constant_override("separation", 6)
	rune_scroll.add_child(rune_rows)
	for rune_entry in runes:
		var rune: Dictionary = rune_entry
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		rune_rows.add_child(row)
		var state := Label.new()
		var is_on: bool = rune.get("equipped", false)
		state.text = "WORN" if is_on else "pouch"
		state.custom_minimum_size = Vector2(56, 20)
		state.add_theme_font_size_override("font_size", 11)
		state.add_theme_color_override("font_color",
			Color(0.45, 0.9, 0.5) if is_on else Color(0.5, 0.48, 0.5))
		row.add_child(state)
		var rune_label := Label.new()
		var equip_tag := "✦ " if is_on else ""
		rune_label.text = "%s%s — %s" % [equip_tag, rune["name"], rune["desc"]]
		rune_label.add_theme_font_size_override("font_size", 12)
		rune_label.add_theme_color_override("font_color",
			Color(0.45, 0.9, 0.5) if is_on
			else rune.get("rarity_color", Color(0.8, 0.8, 0.8)))
		rune_label.custom_minimum_size = Vector2(354, 20)
		rune_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(rune_label)

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
	var flex: int = member.get("talent_flex", 0)
	tree_header.text = "TALENTS — %s    (Points: %d%s)" % [
		Classes.SPEC_INFO[spec]["name"], member.get("talent_points", 0),
		"" if flex < 1 else " · Surplus: %d" % flex]
	_draw_lane_tree(member)
	# Batch AN: owed ability, upgrade and rune picks resolve on the MAP CARD,
	# not here. This page is the sheet — what the hero is, and what their
	# points can buy.


# ---------- the talent tree: 3 lanes x 7 rows + a capstone row ----------

const TREE_BACK_POS := Vector2(500, 96)
const TREE_BACK_SIZE := Vector2(744, 566)
const TREE_NODE_SIZE := 56.0

var _tree_tip: PanelContainer
var _tree_tip_name: Label
var _tree_tip_desc: Label
var _tree_tip_state: Label

const LANE_COL_X := [620.0, 872.0, 1124.0]
const LANE_ROW_Y := [150.0, 206.0, 262.0, 318.0, 374.0, 430.0, 486.0]
const LANE_CAP_Y := 566.0


# Lane order comes from the tree itself (first appearance) — the columns
# read left to right in the order the tree was authored.
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
	var points: int = member.get("talent_points", 0)
	var flex: int = member.get("talent_flex", 0)
	var lane_order := _tree_lanes(tree)
	var back := ColorRect.new()
	back.position = TREE_BACK_POS
	back.size = TREE_BACK_SIZE
	back.color = Color(0.05, 0.05, 0.06)
	add_child(back)
	# Lane spines + headers with the count of nodes taken in each lane. Lanes
	# no longer gate anything (rows do), so this is a read of the build the
	# player has assembled, not a requirement they are working toward.
	for ci in mini(LANE_COL_X.size(), lane_order.size()):
		var v := ColorRect.new()
		v.position = Vector2(LANE_COL_X[ci], TREE_BACK_POS.y + 18)
		v.size = Vector2(1, TREE_BACK_SIZE.y - 30)
		v.color = Color(1, 1, 1, 0.05)
		add_child(v)
		var lane: String = lane_order[ci]
		var taken := 0
		for t in tree:
			if str(t.get("lane", "")) == lane and int(learned.get(t["id"], 0)) > 0:
				taken += 1
		var hdr := Label.new()
		hdr.text = "%s — %d" % [
			str(Talents.LANE_NAMES.get(lane, lane)).to_upper(), taken]
		hdr.add_theme_font_size_override("font_size", 13)
		hdr.add_theme_color_override("font_color", Color(0.85, 0.75, 0.45))
		hdr.position = Vector2(LANE_COL_X[ci] - 110, TREE_BACK_POS.y + 6)
		hdr.size = Vector2(220, 16)
		hdr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(hdr)
	# Row 8: the capstone shelf. Any lane — the seven rows above are the
	# whole requirement.
	var cap_lbl := Label.new()
	cap_lbl.text = "— CAPSTONE · take ONE —"
	cap_lbl.add_theme_font_size_override("font_size", 12)
	cap_lbl.add_theme_color_override("font_color", Color(0.7, 0.6, 0.75))
	# Clear of row 7's own label, which sits just under its node.
	cap_lbl.position = Vector2(TREE_BACK_POS.x, LANE_CAP_Y - 36)
	cap_lbl.size = Vector2(TREE_BACK_SIZE.x, 14)
	cap_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(cap_lbl)
	# A node sits at [its lane's column, its row]. Rows 1-7 stack down the
	# lanes; row 8 is the shelf.
	for talent in tree:
		var lane: String = str(talent.get("lane", ""))
		var col := maxi(lane_order.find(lane), 0)
		var row := int(talent.get("row", 1))
		# (ternaries need the explicit type here — the CLAUDE.md gotcha)
		var y: float = LANE_CAP_Y if row >= Talents.CAPSTONE_ROW \
			else LANE_ROW_Y[clampi(row - 1, 0, LANE_ROW_Y.size() - 1)]
		var center := Vector2(LANE_COL_X[col], y)
		_make_tree_node(talent, learned, points, center, 44.0, flex)
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


func _make_tree_node(talent: Dictionary, learned: Dictionary, points: int,
		center: Vector2, node_size: float = TREE_NODE_SIZE, flex: int = 0) -> void:
	var ranks_have := int(learned.get(talent["id"], 0))
	var check: Dictionary = Talents.can_learn(
		Run.party[selected].get("tree", []), talent["id"], learned)
	var maxed: bool = ranks_have >= int(talent["ranks"])
	# Greyed = the player cannot take this right now. That covers rows they
	# have not reached, capstones before 7/7, doors a sibling shut for good,
	# AND a sibling only an elite point could force open while they hold
	# none — the door is still shut, the tooltip says with what key.
	# Greyed = the player cannot take this right now. That covers rows they
	# have not reached, capstones before 7/7, and doors a sibling shut for
	# good. A second-node pick is NOT greyed for want of a flex point any
	# more: Batch AN lets ordinary points cover it, so the only thing that
	# closes it is having no points at all — which purse_for answers.
	var locked: bool = (not check["ok"] and (check["why"].begins_with("Locked")
		or check["why"].begins_with("Closed") or check["why"].begins_with("Barred")
		or check["why"].begins_with("Coming"))) \
		or (check["ok"] and Talents.purse_for(Run.party[selected], check) == "")

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
	btn.mouse_entered.connect(_show_tree_tip.bind(talent, ranks_have, check, points,
		center, flex))
	btn.mouse_exited.connect(_hide_tree_tip)
	add_child(btn)

	# Row number under the node: the whole gate, stated where the eye is.
	var pts_label := Label.new()
	var row := int(talent.get("row", 1))
	pts_label.text = "TAKEN" if ranks_have > 0 \
		else ("CAP" if row >= Talents.CAPSTONE_ROW else "row %d" % row)
	pts_label.add_theme_font_size_override("font_size",
		11 if node_size >= 50.0 else 9)
	var pts_color := Color(0.45, 0.44, 0.42)
	if maxed:
		pts_color = Color(0.5, 0.9, 0.55)
	pts_label.add_theme_color_override("font_color", pts_color)
	pts_label.position = center + Vector2(-node_size / 2.0, node_size / 2.0 + 1)
	pts_label.size = Vector2(node_size, 14)
	pts_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(pts_label)


func _show_tree_tip(talent: Dictionary, ranks_have: int, check: Dictionary,
		points: int, center: Vector2, flex: int = 0) -> void:
	_tree_tip_name.text = talent["name"]
	_tree_tip_desc.text = Talents.desc_for(talent, ranks_have)
	var row := int(talent.get("row", 1))
	var state := "Capstone" if row >= Talents.CAPSTONE_ROW else "Row %d of %d" % [
		row, Talents.ROWS]
	if ranks_have > 0:
		state += "  —  TAKEN"
	elif not check["ok"]:
		state += "  —  %s" % check["why"]
	elif check["pool"] == "flex":
		# The second-node crack: say what it costs and out of which purse.
		state += "  —  %s" % check["why"]
		var purse := Talents.purse_for(Run.party[selected], check)
		if purse == "talent_flex":
			state += "\nClick to spend 1 SURPLUS point (have %d)" % flex
		elif purse == "talent_points":
			state += "\nClick to spend 1 point (have %d)" % points
		else:
			state += "\nNeeds 1 point (have 0)"
	elif points < 1:
		state += "  —  costs 1 point (have 0)"
	else:
		state += "  —  click to spend 1 point"
	if ranks_have < 1 and row < Talents.CAPSTONE_ROW and check["pool"] != "flex":
		# Name the doors this pick would shut, before it shuts them.
		var siblings := PackedStringArray()
		for sib in Talents.row_nodes(Run.party[selected].get("tree", []), row):
			if String(sib["id"]) != String(talent["id"]):
				siblings.append(String(sib["name"]))
		if not siblings.is_empty():
			state += "\nTaking it closes %s" % " and ".join(siblings)
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


# Every node costs exactly 1. `Talents.purse_for` decides which purse pays
# — flex first while it holds anything, normal points after (Batch AN: one
# purse of 12 against an 8-node tree, so the surplus buys second nodes on
# its own). Asking the helper rather than reading `pool` raw is what keeps
# the greying, the tooltip and the spend from ever disagreeing.
func _learn_talent(talent_id: String) -> void:
	var member: Dictionary = Run.party[selected]
	var learned: Dictionary = member.get("talents", {})
	var tree: Array = member.get("tree", [])
	var check := Talents.can_learn(tree, talent_id, learned)
	if not check["ok"]:
		return
	var purse := Talents.purse_for(member, check)
	if purse == "":
		return
	learned[talent_id] = 1
	member["talents"] = learned
	member[purse] = int(member.get(purse, 0)) - 1
	Run.save_run()
	_draw_screen()
