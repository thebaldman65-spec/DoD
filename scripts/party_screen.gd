# The HERO SHEET: one compact page showing what a hero IS — his live stats,
# his class passive and his lineage's engine, and his class's talent tree.
#
# BATCH IH §3 — WHAT HE WEARS IS ON THE PANELS (the designer's): his cards on the
# map's Kit panel, his runes on its Runes panel. The ABILITIES chips, the CARRIED
# BY TAG census and the RUNES block left this page; the chips' hover moved to the
# Kit panel's rows (`Run.ability_hover`, IH §5), and the prologue that builds his
# numbers moved with it (`Run.hero_live_config`), so the two read one builder.
#
# BATCH AN DELETED THE LIST VIEW. The map screen carries all four hero cards
# now, so it IS the party list — this page is only ever entered for a
# specific hero (Run.hero_screen_idx, set by the card that was clicked) and
# Back returns to the map. The rune-EQUIP and pick flows moved onto the card
# too; runes are shown here as a read-only summary of what the hero is
# wearing, because the sheet is where their numbers are already explained.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
# BATCH II §0.6 — the stats, one size up from IH's 15, a row a line (24 px at 17, measured).
const STAT_FONT := 17
const STAT_PITCH := 24
const STAT_TOP := 132

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
	# BATCH IB §1 — a return from the sheet is not an arrival: the picks the map opened
	# when the party arrived are not opened again (`Run.map_reentry`).
	Run.map_reentry = true
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
#
# BATCH CL §7 — AND IT IS FLATTENED HERE, NOT IN THE FIELD. The brief and the
# standard both describe `passive_desc` as rendering only in this autowrapping
# 400px label, and it has a THIRD surface neither of them names:
# `battle.gd:1086` hands the same field to `add_status`, and `unit.gd:2291`
# makes that a Godot default tooltip — which does NOT autowrap and grows to fit
# its longest line. So the authored breaks STAY in the field and come out at the
# two surfaces that soft-wrap: this label and the spec-choice column. Deleting
# them from the field would tidy the ragged block here and render the
# Arcanist's block as one ~2000px line in the middle of a fight, which is the
# exact failure §4.7 records for ability descriptions.
func _passive_desc_live(cfg: Dictionary, pid: String) -> String:
	# BATCH GK — keyed on the ENGINE, which a hero holds, not the spec he is.
	var desc: String = Classes.engine_desc(pid)
	match pid:
		"seasoned":
			# BATCH IH §3 — the upside is the fight's own constant (0.30 by ruling since HL §3; this
			# line read 0.15 until IH), and Guard Change travels with the Stances (HL §1).
			desc = "Seasoned Fighter: fights in one of two stances.\nAGGRESSIVE — +%d%% damage dealt, +10%% damage taken.\nDEFENSIVE — %d%% less damage taken, -10%% damage dealt.\nStarts each battle Aggressive; Guard Change swaps." % [
				int(round((BattleUnit.SEASONED_AGG_DEALT + float(cfg.get("seasoned_off_bonus", 0.0))
					+ float(cfg.get("rune_seasoned_off_bonus", 0.0))) * 100)),
				int(round((0.15 + float(cfg.get("seasoned_def_bonus", 0.0))
					+ float(cfg.get("rune_seasoned_def_bonus", 0.0))) * 100))]
		"bloodrage":
			# BATCH CV §6 — THE FLOOR IS INTERPOLATED, NOT HARDCODED AT HALF.
			# Scar Tissue holds 85% of the peak and 100% with Unstoppable, and
			# the in-battle chip has read the SAME `[50, 85, 100]` table off the
			# same counter since AL — so two surfaces disagreed in front of the
			# player, on a number the sheet is the one place to compare builds
			# by. `scar_tissue_ranks` is on `cfg` by the time this runs:
			# `apply_from_tree` writes every payload stat into it above, and
			# this function is called after that.
			var br_keep: int = [50, 85, 100][clampi(
				int(cfg.get("scar_tissue_ranks", 0)), 0, 2)]
			# BATCH IJ §2 — AND BOTH TERMS AND THE CAP, as the battle chip states them: the
			# steps of health missing and of Rage spent (doubled under the Open Vein) share
			# one band, clamped at `FRENZY_MAX_STEPS` (`unit.frenzy_bonus`).
			var br_step: float = 2.0 + float(cfg.get("bloodrage_step_bonus", 0.0)) \
				+ float(cfg.get("rune_bloodrage_step_bonus", 0.0))
			var br_rage: float = float(BattleUnit.FRENZY_RAGE_PER_STEP) \
				/ (2.0 if int(cfg.get("rune_open_vein", 0)) > 0 else 1.0)
			desc = "Blood Frenzy: +%s%% damage for every 5%% of health\nmissing and every %s Rage spent, to at most +%s%%.\n%d%% of the highest bonus reached in a\nbattle is kept as a floor for the rest of it." % [
				String.num(br_step, 1), Classes.figure_text(br_rage),
				String.num(br_step * BattleUnit.FRENZY_MAX_STEPS, 1), br_keep]
	return Classes.resolve_values(desc,
		Classes.value_ctx_from_config(cfg)).replace("\n", " ")


func _draw_detail() -> void:
	var member: Dictionary = Run.party[selected]
	var key: String = member["key"]
	# BATCH IH §5 — THE PROLOGUE IS `Run.hero_live_config`, moved there unchanged so the Kit
	# panel's ability hover reads the numbers this page shows: kit, passive, spec stats, earned
	# cards, tree, runes, the crest's rune, upgrades, Ashen Skin, max health, Toughness and node
	# scaling, in the battle spawn's order.
	var live: Dictionary = Run.hero_live_config(member)
	var cfg: Dictionary = live["cfg"]
	var spec: String = live["spec"]
	var awake: bool = live["awake"]
	var engines: Array = live["engines"]
	var base_attack: int = live["base_attack"]
	var spec_label: String = Classes.SPEC_INFO[spec]["name"] if spec != "" \
		else (String(cfg["unit_name"]) if awake else "Unawakened")
	# Awakened heroes are titled by spec; the class name only shows pre-spec —
	# and, since GK, on a hero whose engine carried no spec.
	_title(spec_label if awake else "%s — Unawakened" % cfg["unit_name"], 6, 30)

	# Left column: class blurb, stats, the passive block (IH §3: nothing he wears).
	var blurb := Label.new()
	blurb.add_theme_font_size_override("font_size", 13)
	blurb.add_theme_color_override("font_color", Color(0.65, 0.6, 0.55))
	# BATCH IH §6 — WRAP, PARENT, SIZE, AND ONLY THEN THE TEXT: sized before it is parented, a label takes
	# the default font's line; given its words before its width, a wrapping label breaks them at every
	# word and keeps that height. Its text, set last, is broken at the width it already has.
	blurb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(blurb)
	blurb.position = Vector2(60, 80)
	blurb.size = Vector2(400, 44)
	blurb.text = Classes.CLASS_BLURBS[key]

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
			"Armor — % of incoming damage blocked, of any type."],
		["Resistances", "Resistances — like armor, but per damage type:\n%s\n%s" % [
			" / ".join(resist_lines.slice(0, 4)), " / ".join(resist_lines.slice(4, 7))]]],
		[["Speed: %d" % int(cfg["speed"]),
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
		stat_rows[stat_rows.size() - 1].append(["Block: %d%%" % int(round(cfg["block_chance"] * 100)),
			"Block — chance to fully negate an incoming attack:\nno damage, no Break damage, no effects.\nHeavy Plating adds another +15% in battle, and every\nunblocked hit adds +8% more (cap +40%) until a\nBlock lands and resets the climb."])
	# BATCH II §0.6 — THE STATS ONE SIZE LARGER (the designer's): the sheet is a stats sheet since IH §3, so
	# the stats are the biggest thing on it and they take the column the removed blocks freed. At STAT_FONT
	# the four-stat row ran 484 px from x 60, past the talent board at x 500 (measured), so Armor and
	# Resistances stand on one row and Speed and Constitution on the next; the widest row is the Warden's
	# Crit / Parry / Block, 372 px.
	for r in stat_rows.size():
		var row := HBoxContainer.new()
		row.position = Vector2(60, STAT_TOP + r * STAT_PITCH)
		row.add_theme_constant_override("separation", 24)
		add_child(row)
		for seg in stat_rows[r]:
			var stat_label := Label.new()
			stat_label.text = seg[0]
			stat_label.add_theme_font_size_override("font_size", STAT_FONT)
			stat_label.add_theme_color_override("font_color", Color(0.88, 0.85, 0.78))
			stat_label.mouse_filter = Control.MOUSE_FILTER_STOP
			stat_label.tooltip_text = seg[1]
			row.add_child(stat_label)
	var class_p: Dictionary = Classes.CLASS_PASSIVES[key]
	var passive_lines := PackedStringArray(
		["Class: %s — %s" % [class_p["name"], class_p["desc"]]])
	# BATCH IH §3 — WHAT HE IS: the class passive, and his LINEAGE's own engine while its core
	# rune is slotted — the one `Run.awaken` set his lineage from. Any other core rune he wears
	# (another lineage's engine, the class's spine, a rule engine) is something he wears, so its
	# rule is on the Runes panel's CORE row (`Runes.shown_desc`, GS §3's one door) and not here;
	# and "none held" is that panel's to say. A hero awakened on the spine has no lineage, and
	# his block is his class passive alone.
	var own_pid := Classes.engine_of_spec(spec) if spec != "" else ""
	if own_pid != "" and engines.has(own_pid):
		passive_lines.append(_passive_desc_live(cfg, own_pid))
	var passive_label := Label.new()
	# AUTOWRAP, PARENT, SIZE, THEN TEXT: a label that cannot wrap takes its one-line width the moment a
	# size is set, one sized before it is in the tree takes the default font's, and one given its words
	# before its width keeps the height of every word on its own line (IA's trap, and IH §6's three).
	# No scroller since IH §3 — the three blocks that left freed the column, and a scroller around a
	# few lines hid its own last one.
	passive_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	passive_label.add_theme_font_size_override("font_size", 13)
	passive_label.add_theme_color_override("font_color", Color(0.88, 0.85, 0.78))
	passive_label.set_meta("passive_block", true)
	add_child(passive_label)
	passive_label.position = Vector2(60, STAT_TOP + 6 + stat_rows.size() * STAT_PITCH)
	passive_label.size = Vector2(400, 0)
	passive_label.text = "\n".join(passive_lines)  # last — the blurb's reason, above

	# Right side: the chosen spec's talent tree lives on this same page.
	var tree_header := Label.new()
	tree_header.add_theme_font_size_override("font_size", 15)
	tree_header.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	tree_header.position = Vector2(520, 80)
	tree_header.size = Vector2(700, 22)
	add_child(tree_header)

	if not awake:
		tree_header.text = "TALENTS — the %s awakens on taking a core rune." % key.capitalize()
		return
	# BATCH BM: the in-run tree is READ-ONLY and says so. Talents are bought
	# between runs on the build screen and lock the moment a spec is
	# confirmed; nothing on this page can change them.
	# BATCH FX: the tree is the CLASS's — one tree every class buys into — so
	# the heading names the class whose purse it is, not the spec.
	tree_header.text = "TALENTS — the %s tree    (LOCKED FOR THIS RUN)" % key.capitalize()
	_draw_class_tree(member)
	# Batch AN: owed ability, upgrade and rune picks resolve on the MAP CARD,
	# not here. This page is the sheet — what the hero is, and what their
	# points can buy.


# ---------- the talent tree: three tiers of nine (BATCH FX) ----------
#
# BATCH BM MADE THIS PAGE READ-ONLY. Talents are bought BETWEEN runs on the
# build screen (talents.tscn) and lock the instant a spec is confirmed, so the
# sheet's job is to say what the hero is wearing and to make plain it cannot
# change in a run.
# BATCH FX RE-CUT IT FOR THE ONE CLASS TREE. There are no lanes, no rows and no
# capstone shelf, and nothing is exclusive, so there are no closed doors left
# to show — a cell is WORN or it is not, and the tiers are the only structure.

const TREE_BACK_POS := Vector2(500, 96)
const TREE_BACK_SIZE := Vector2(744, 566)

var _tree_tip: PanelContainer
var _tree_tip_name: Label
var _tree_tip_desc: Label
var _tree_tip_state: Label

# Nine cells across each tier band, three bands down the board.
const TREE_COL_X0 := 540.0
const TREE_COL_STEP := 83.0
const TREE_TIER_Y := [170.0, 352.0, 534.0]
const TREE_NODE_SIZE := 34.0
const TREE_LABEL_W := 80.0
const LOCK_GLYPH := "\u2298"


func _draw_class_tree(member: Dictionary) -> void:
	var tree: Array = member.get("tree", [])
	var learned: Dictionary = member.get("talents", {})
	var back := ColorRect.new()
	back.position = TREE_BACK_POS
	back.size = TREE_BACK_SIZE
	back.color = Color(0.05, 0.05, 0.06)
	add_child(back)
	for tier in range(1, Talents.TIERS + 1):
		var y: float = TREE_TIER_Y[tier - 1]
		var worn_n := 0
		for t in Talents.tier_nodes(tree, tier):
			if int(learned.get(t["id"], 0)) > 0:
				worn_n += 1
		var band := ColorRect.new()
		band.position = Vector2(TREE_BACK_POS.x + 6, y - 40)
		band.size = Vector2(TREE_BACK_SIZE.x - 12, 160)
		band.color = Color(1, 1, 1, 0.035)
		add_child(band)
		var band_lbl := Label.new()
		band_lbl.text = "TIER %d  ·  %d of %d worn" % [tier, worn_n, Talents.NODES_PER_TIER]
		band_lbl.add_theme_font_size_override("font_size", 11)
		band_lbl.add_theme_color_override("font_color",
			Color(0.62, 0.55, 0.38) if worn_n > 0 else Color(0.4, 0.4, 0.45))
		band_lbl.position = Vector2(TREE_BACK_POS.x + 12, y - 36)
		band_lbl.size = Vector2(TREE_BACK_SIZE.x - 24, 13)
		add_child(band_lbl)
		var col := 0
		for t in Talents.tier_nodes(tree, tier):
			_make_tree_node(t, learned,
				Vector2(TREE_COL_X0 + TREE_COL_STEP * col, y))
			col += 1
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
	_tree_tip_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tree_tip_name.custom_minimum_size = Vector2(300, 0)
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


# A node on the SHEET is one of exactly two things — worn, or not — and
# neither is clickable. `Button` survives only because it is the cheapest
# hover surface; `disabled` stays false or the tooltip stops firing.
func _make_tree_node(talent: Dictionary, learned: Dictionary,
		center: Vector2) -> void:
	var worn := int(learned.get(talent["id"], 0)) > 0
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(TREE_NODE_SIZE, TREE_NODE_SIZE)
	btn.position = center - Vector2(TREE_NODE_SIZE / 2.0, TREE_NODE_SIZE / 2.0)
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_ARROW
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.10, 0.12)
	sb.border_color = Color(0.32, 0.62, 0.34) if worn else Color(0.22, 0.22, 0.25)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", sb)
	btn.add_theme_stylebox_override("pressed", sb)
	btn.text = "\u2694" if worn else LOCK_GLYPH
	btn.add_theme_font_size_override("font_size", 15)
	btn.add_theme_color_override("font_color",
		Color(0.58, 0.58, 0.64) if worn else Color(0.30, 0.30, 0.34))
	btn.add_theme_color_override("font_hover_color", Color(0.75, 0.75, 0.8))
	if not worn:
		btn.modulate = Color(0.55, 0.55, 0.55)
	btn.mouse_entered.connect(_show_tree_tip.bind(talent, worn, center))
	btn.mouse_exited.connect(_hide_tree_tip)
	add_child(btn)
	var name_lbl := Label.new()
	name_lbl.text = String(talent["name"])
	name_lbl.add_theme_font_size_override("font_size", 9)
	name_lbl.add_theme_color_override("font_color",
		Color(0.78, 0.84, 0.76) if worn else Color(0.45, 0.44, 0.42))
	name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.position = Vector2(center.x - TREE_LABEL_W / 2.0,
		center.y + TREE_NODE_SIZE / 2.0 + 3)
	name_lbl.size = Vector2(TREE_LABEL_W, 56)
	name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(name_lbl)


func _show_tree_tip(talent: Dictionary, worn: bool, center: Vector2) -> void:
	_tree_tip_name.text = talent["name"]
	_tree_tip_desc.text = Talents.desc_for(talent, 1)
	var state := "Tier %d of %d" % [Talents.tier_of(talent), Talents.TIERS]
	state += "  \u2014  WORN" if worn else "  \u2014  not bought"
	state += "\nTalents are bought between runs and locked for this one."
	_tree_tip_state.text = state
	_tree_tip.visible = true
	_tree_tip.reset_size()
	var pos := center + Vector2(-TREE_NODE_SIZE / 2.0 - _tree_tip.size.x - 10, -24)
	pos.x = maxf(pos.x, 12.0)
	pos.y = clampf(pos.y, 12.0, 720.0 - _tree_tip.size.y - 12.0)
	_tree_tip.position = pos


func _hide_tree_tip() -> void:
	if _tree_tip != null:
		_tree_tip.visible = false
