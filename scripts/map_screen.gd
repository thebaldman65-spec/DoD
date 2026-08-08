# The run map (Batch AN, flipped in AO): a FIXED LINE of 12 slots for the
# current zone, rendered LEFT TO RIGHT — slot 1 on the left edge, the boss on
# the right. There is no route to plan: the only forward move is the next
# dot, and the run's decisions live on the offer screen that precedes every
# elite and mini-boss.
#
# THIS SCREEN IS ALSO THE PARTY SCREEN NOW. All four hero stat cards live
# here rather than behind a Party button — HP, resource, three rune slots,
# unspent points — and the potion inventory is INTERACTIVE (§6). Clicking a
# card opens that hero's talent tree; clicking a rune slot opens the pouch.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const NODE_LABELS := {
	"fight": "Fight", "elite": "ELITE", "boss": "BOSS", "miniboss": "WARDEN",
}
const NODE_COLORS := {
	"fight": Color(0.75, 0.72, 0.65), "elite": Color(0.95, 0.55, 0.3),
	"boss": Color(0.9, 0.3, 0.35),
	# Between the elite's orange and the boss's red, because that is exactly
	# where the slot sits.
	"miniboss": Color(0.95, 0.42, 0.32),
}

# The line's geometry. Slot 0 sits at SLOT_X_START and each later slot steps
# RIGHT by SLOT_X_STEP — the whole left-to-right reading is these two
# numbers, and flipping the map is negating the step and moving the start.
const SLOT_X_START := 84.0
const SLOT_X_STEP := 98.0
const SLOT_Y := 250.0
const DOT_R := 15.0

# Debug-only-reachable slots (Batch AC) wear this outline — a colour no
# slot type and no slot state uses.
const DEBUG_OUTLINE := Color(1.0, 0.35, 0.85)
# Burger ids: 0-3 are the real entries, 10-16 the pre-AC debug block,
# 20-26 the summon block, and 100+ one per event in the picker.
const PICKER_ID_BASE := 100

# Which hero's pouch is open on the rune overlay, or -1.
var _rune_panel_for := -1


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	# Every summoned node that leaves the map comes back HERE, so this is
	# where the summon flag is put down.
	Run.debug_summon = false
	Music.play("map")
	_draw_screen()
	_maybe_show_framing()


# First-run orientation (Batch Z): a skippable framing card between the
# draft and the first map — what a run IS. Once ever (Profile flag, set on
# dismissal so quitting mid-card re-shows it). Sims never load this scene.
func _maybe_show_framing() -> bool:
	if Run.slot_idx >= 0 or Run.zone_idx > 0 or Run.sim_run \
			or Profile.flag("run_framing_seen"):
		return false
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.72)
	dim.z_index = 90
	add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(310, 150)
	panel.z_index = 91
	add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)
	var title := Label.new()
	title.text = "THE ROAD"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	var body := Label.new()
	body.text = ("A run is a road of 36 encounters — three zones of twelve, and\n" +
		"every zone has the same shape. The road reads LEFT TO RIGHT: you\n" +
		"start at the left edge and the zone's boss waits on the right.\n\n" +
		"Two ELITES, one MINI-BOSS and the BOSS stand in every zone, and\n" +
		"each of them pays a talent point. Ordinary fights pay none.\n\n" +
		"Before every elite and mini-boss you are offered THREE BARGAINS: a\n" +
		"condition that binds both sides of the battle, and what clearing\n" +
		"it under that condition pays. The harder the condition, the richer\n" +
		"the payment — and one of the three is always survivable.\n\n" +
		"Clearing any encounter heals the party 15%. There is no resting.\n\n" +
		"Death ends the run and takes everything — gold, talents, runes.\n" +
		"But every boss you fell leaves a RELIC behind, unlocked forever.\n\n" +
		"Hover any dot to scout it. Click a hero to open their talents.")
	body.add_theme_font_size_override("font_size", 15)
	body.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	vbox.add_child(body)
	var btn := Button.new()
	btn.text = "Take the road"
	btn.custom_minimum_size = Vector2(220, 44)
	btn.pressed.connect(Music.click)
	btn.pressed.connect(func():
		Profile.set_flag("run_framing_seen")
		dim.queue_free()
		panel.queue_free())
	vbox.add_child(btn)
	return true


func _slot_pos(slot: int) -> Vector2:
	return Vector2(SLOT_X_START + slot * SLOT_X_STEP, SLOT_Y)


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()
	_rune_panel_for = -1

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)
	var zone_backgrounds := {
		"Forest of Old": "res://assets/backgrounds/node_background_forest.png",
		"The Scarlands": "res://assets/backgrounds/node_background_scarlands.png",
	}
	var art_tex: Texture2D = load(zone_backgrounds.get(Run.zone_name,
		"res://assets/backgrounds/node_background_forest.png"))
	var art := TextureRect.new()
	art.texture = art_tex
	art.size = Vector2(1280, 720)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(art)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0.05, 0.04, 0.08, 0.62)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	_draw_header()
	_draw_line()
	_draw_hero_cards()
	_draw_footer()


func _draw_header() -> void:
	var title := Label.new()
	title.text = Run.zone_name
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 10)
	title.size = Vector2(1280, 46)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	# The readout says where the party is in the ZONE and in the RUN — the
	# line is 36 slots long and a player should never have to count dots.
	var boss_name: String = Enemies.unit_name(Run.boss_kind())
	var subtitle := Label.new()
	var here := Run.slot_idx + 1
	if here < 1:
		subtitle.text = "Zone %d of %d — 12 encounters to the %s" % [
			Run.zone_idx + 1, Run.SLOT_COUNT, boss_name]
	else:
		subtitle.text = "Zone %d of %d — encounter %d of %d (%d of 36) — the %s waits" % [
			Run.zone_idx + 1, Run.SLOT_COUNT, here, Run.SLOTS_PER_ZONE,
			Run.run_slot_number(), boss_name]
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.72, 0.64, 0.52))
	subtitle.position = Vector2(0, 56)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	var burger := MenuButton.new()
	burger.text = "☰"
	burger.custom_minimum_size = Vector2(52, 40)
	burger.position = Vector2(20, 14)
	burger.flat = false
	var bpop := burger.get_popup()
	bpop.add_item("Restart Run", 0)
	bpop.add_item("Glossary", 3)
	bpop.add_item("Quit to Main Menu", 1)
	bpop.add_item("Quit to Desktop", 2)
	if Run.debug_enabled():
		bpop.add_separator("DEBUG")
		bpop.add_item("+200 Gold", 10)
		bpop.add_item("+200 Talent Points (all)", 11)
		bpop.add_item("Full Heal Party", 12)
		bpop.add_item("Jump to Boss Slot", 13)
		bpop.add_item("Advance to Next Zone", 14)
		bpop.add_item("Reroll Specs", 15)
		bpop.add_check_item("All Spec Abilities Unlocked", 16)
		bpop.set_item_checked(bpop.get_item_index(16), Run.debug_grant_all)
		bpop.add_check_item("Free Travel", 20)
		bpop.set_item_checked(bpop.get_item_index(20), Run.debug_free_travel)
		var summon := PopupMenu.new()
		summon.name = "TestANode"
		summon.add_item("Shop", 21)
		summon.add_item("??? Event", 23)
		summon.add_item("Fight", 24)
		summon.add_item("Elite", 25)
		summon.add_item("Mini-boss", 26)
		# "Rest" is gone with the rest nodes (Batch AN §6) — there is no
		# longer a thing for it to summon.
		summon.id_pressed.connect(_on_burger)
		# The submenu PARENT needs an explicit id: left to auto-assign it
		# takes its item INDEX, which lands on a debug entry.
		bpop.add_submenu_node_item("Test a node", summon, 9)
	bpop.id_pressed.connect(_on_burger)
	add_child(burger)


# ---------- the line ----------

func _draw_line() -> void:
	# The road itself, drawn behind the dots. One straight run — the cleared
	# stretch is lit, the road ahead is dark.
	var road := Line2D.new()
	road.add_point(_slot_pos(0))
	road.add_point(_slot_pos(Run.SLOTS_PER_ZONE - 1))
	road.width = 3.0
	road.default_color = Color(0.32, 0.28, 0.38, 0.55)
	add_child(road)
	if Run.slot_idx >= 0:
		var walked := Line2D.new()
		walked.add_point(_slot_pos(0))
		walked.add_point(_slot_pos(Run.slot_idx))
		walked.width = 5.0
		walked.default_color = Color(0.85, 0.72, 0.35, 0.8)
		add_child(walked)

	var next_slot: int = Run.slot_idx + 1
	var free_travel: bool = Run.debug_enabled() and Run.debug_free_travel
	for s in Run.SLOTS_PER_ZONE:
		var slot: Dictionary = Run.map[s]
		var ty := String(slot["type"])
		var center := _slot_pos(s)
		var is_next: bool = s == next_slot
		var debug_only: bool = free_travel and not is_next and not slot["visited"]

		var btn := Button.new()
		btn.text = NODE_LABELS.get(ty, ty)
		var w: float = 86.0 if is_next else 74.0
		btn.custom_minimum_size = Vector2(w, 32.0)
		btn.position = center - Vector2(w / 2.0, 16.0)
		btn.disabled = not (is_next or debug_only)
		btn.add_theme_font_size_override("font_size", 14 if is_next else 11)
		if debug_only:
			_add_debug_outline(btn.position, Vector2(w, 32.0))
		# Three states, three clearly separate reads: cleared is history (dim
		# green), the next slot is THE option (full colour, bigger), the road
		# ahead recedes into the dark.
		if slot["visited"]:
			btn.modulate = Color(0.48, 0.66, 0.48)
		elif is_next:
			btn.modulate = NODE_COLORS.get(ty, Color.WHITE)
		elif debug_only:
			btn.modulate = _debug_tint(NODE_COLORS.get(ty, Color.WHITE))
		else:
			btn.modulate = Color(0.42, 0.40, 0.47)
		btn.pressed.connect(Music.click)
		btn.pressed.connect(_on_slot_pressed.bind(s))
		btn.tooltip_text = _slot_tooltip(slot, s)
		if debug_only:
			btn.tooltip_text = "[DEBUG] " + btn.tooltip_text
		add_child(btn)

		# The slot number under each dot: twelve near-identical dots want a
		# ruler, whichever way the road runs.
		var num := Label.new()
		num.text = str(s + 1)
		num.add_theme_font_size_override("font_size", 10)
		num.add_theme_color_override("font_color",
			Color(0.7, 0.66, 0.6) if is_next else Color(0.45, 0.43, 0.5))
		num.position = center + Vector2(-w / 2.0, 18.0)
		num.size = Vector2(w, 12)
		num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(num)

	if free_travel:
		var marker := Label.new()
		marker.text = "DEBUG: FREE TRAVEL"
		marker.add_theme_font_size_override("font_size", 13)
		marker.add_theme_color_override("font_color", DEBUG_OUTLINE)
		marker.add_theme_constant_override("outline_size", 3)
		marker.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		marker.position = Vector2(20, 60)
		marker.z_index = 40
		add_child(marker)


# What a dot says on hover. Combat slots reveal their warband and what it
# resists / crumples to — mini-bosses and the boss show their TYPE but not
# their identity, because learning which pair you drew by fighting the
# mini-boss is the point (§1).
func _slot_tooltip(slot: Dictionary, s: int) -> String:
	var ty := String(slot["type"])
	if ty in ["miniboss", "boss"]:
		var what := "A mini-boss holds the middle of the zone." if ty == "miniboss" \
			else "The zone's boss. Nothing goes around it."
		var tail := "\n\nA bargain is offered before it." if ty == "miniboss" else ""
		return "%s\nYou will not know which until you meet it.%s" % [what, tail]
	var head := "Encounter %d of %d" % [s + 1, Run.SLOTS_PER_ZONE]
	var bargain := ""
	if ty == "elite":
		head += " — ELITE"
		bargain = "\n\nA bargain is offered before this fight."
	return "%s\n%s%s" % [head, _warband_tooltip(slot), bargain]


func _add_debug_outline(at: Vector2, size: Vector2) -> void:
	var frame := Panel.new()
	frame.position = at - Vector2(3, 3)
	frame.size = size + Vector2(6, 6)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.draw_center = false
	sb.set_border_width_all(2)
	sb.border_color = DEBUG_OUTLINE
	sb.set_corner_radius_all(4)
	frame.add_theme_stylebox_override("panel", sb)
	add_child(frame)


# The slot's own colour, pulled toward grey and dimmed: readable as "this is
# an elite", never readable as "this is an option".
func _debug_tint(c: Color) -> Color:
	var grey := (c.r + c.g + c.b) / 3.0
	return Color(lerpf(c.r, grey, 0.65) * 0.82, lerpf(c.g, grey, 0.65) * 0.82,
		lerpf(c.b, grey, 0.65) * 0.82)


# ---------- the hero cards (§2) ----------

const CARD_W := 296.0
const CARD_H := 226.0
const CARD_Y := 360.0


func _draw_hero_cards() -> void:
	for i in Run.party.size():
		_draw_hero_card(i, Vector2(14.0 + i * (CARD_W + 6.0), CARD_Y))


func _draw_hero_card(idx: int, at: Vector2) -> void:
	var member: Dictionary = Run.party[idx]
	var key := String(member["key"])
	var spec := String(member.get("spec", ""))
	var owed_runes := int(member.get("rune_picks_owed", 0))
	var owed_abs := int(member.get("bm_picks_owed", 0))
	var owed_ups := int(member.get("up_picks_owed", 0))
	var pts := int(member.get("talent_points", 0)) + int(member.get("talent_flex", 0))

	var panel := Panel.new()
	panel.position = at
	panel.size = Vector2(CARD_W, CARD_H)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.06, 0.05, 0.08, 0.92)
	sb.set_corner_radius_all(6)
	sb.set_border_width_all(2)
	# The border carries the loudest unspent thing, same precedence the old
	# Party badge used: rune purple > pick gold > talent gold > nothing.
	sb.border_color = Color(0.24, 0.22, 0.28)
	if owed_runes > 0:
		sb.border_color = Color(0.75, 0.45, 1.0)
	elif owed_abs > 0 or owed_ups > 0:
		sb.border_color = Color(0.95, 0.85, 0.4)
	elif pts > 0:
		sb.border_color = Color(0.85, 0.72, 0.35)
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)

	# The whole card is the button that opens the talent tree — laid under
	# the readouts so the rune slots and the badges can sit on top and take
	# their own clicks.
	var open := Button.new()
	open.position = at
	open.size = Vector2(CARD_W, CARD_H)
	open.flat = true
	open.tooltip_text = "Open %s's talents and full sheet." % (
		Classes.SPEC_INFO[spec]["name"] if spec != "" else key.capitalize())
	open.pressed.connect(Music.click)
	open.pressed.connect(_open_hero.bind(idx))
	add_child(open)

	var portrait := TextureRect.new()
	portrait.texture = Classes.class_icon(key, spec)
	portrait.position = at + Vector2(10, 10)
	portrait.custom_minimum_size = Vector2(56, 56)
	portrait.size = Vector2(56, 56)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not Classes.SPEC_PORTRAITS.has(spec):
		portrait.modulate = Classes.HERO_TINTS[idx % Classes.HERO_TINTS.size()]
	add_child(portrait)

	var name_lbl := Label.new()
	name_lbl.text = Classes.SPEC_INFO[spec]["name"] if spec != "" \
		else "%s — Unawakened" % key.capitalize()
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.86, 0.76))
	name_lbl.position = at + Vector2(74, 12)
	name_lbl.size = Vector2(CARD_W - 84, 20)
	name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(name_lbl)

	# HP bar with numbers, then the resource bar under it.
	var hp: int = int(member["hp"])
	var max_hp: int = maxi(int(member["max_hp"]), 1)
	_bar(at + Vector2(74, 36), CARD_W - 84, 16,
		float(hp) / float(max_hp),
		Color(0.75, 0.25, 0.28) if hp > 0 else Color(0.35, 0.2, 0.22),
		"%d / %d" % [hp, max_hp])
	var cfg := Classes.hero_config(key)
	var res_name := String(cfg.get("resource_name", "Mana"))
	if res_name == "Mana":
		_bar(at + Vector2(74, 56), CARD_W - 84, 12,
			float(member["mana"]) / float(maxi(int(member["max_mana"]), 1)),
			Color(0.3, 0.45, 0.85), "%s %d" % [res_name, int(member["mana"])])
	else:
		# Rage and its kin build in combat and carry nothing between fights;
		# an empty bar every time would be a lie about the resource.
		var res_lbl := Label.new()
		res_lbl.text = "%s — builds in combat" % res_name
		res_lbl.add_theme_font_size_override("font_size", 11)
		res_lbl.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
		res_lbl.position = at + Vector2(74, 56)
		res_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(res_lbl)

	# Three rune slots, filled or empty (§9 — flat 3 from run start). Each is
	# its own button: clicking one opens this hero's pouch.
	var runes: Array = member.get("runes", [])
	var worn: Array = runes.filter(func(r): return r.get("equipped", false))
	var slots_lbl := Label.new()
	slots_lbl.text = "RUNES"
	slots_lbl.add_theme_font_size_override("font_size", 11)
	slots_lbl.add_theme_color_override("font_color", Color(0.65, 0.6, 0.7))
	slots_lbl.position = at + Vector2(12, 78)
	slots_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(slots_lbl)
	for s in Run.rune_slots():
		var rune: Dictionary = worn[s] if s < worn.size() else {}
		var slot_btn := Button.new()
		slot_btn.position = at + Vector2(12 + s * 92, 96)
		slot_btn.custom_minimum_size = Vector2(86, 30)
		slot_btn.add_theme_font_size_override("font_size", 10)
		if rune.is_empty():
			slot_btn.text = "— empty —"
			slot_btn.tooltip_text = "An empty rune slot. Click to equip one\nfrom %s's pouch (%d carried)." % [
				key.capitalize(), runes.size()]
			slot_btn.add_theme_color_override("font_color", Color(0.45, 0.43, 0.48))
		else:
			slot_btn.text = String(rune["name"])
			slot_btn.tooltip_text = "%s\n%s\n\nClick to manage %s's runes." % [
				rune["name"], rune["desc"], key.capitalize()]
			slot_btn.add_theme_color_override("font_color",
				rune.get("rarity_color", Color(0.8, 0.8, 0.8)))
		slot_btn.pressed.connect(Music.click)
		slot_btn.pressed.connect(_open_rune_panel.bind(idx))
		add_child(slot_btn)

	# Batch AQ §5C: the ability-upgrade count, sitting alongside the rune slots
	# — runes already get exactly this treatment here and upgrades got nothing,
	# which is the asymmetry worth closing. A full run awards three to every
	# hero and before this they were discoverable only by hovering an ability
	# button mid-fight. IT DOES NOT TAKE A CLICK: it is a child of the card
	# button with MOUSE_FILTER_PASS, so it carries its own tooltip while the
	# press falls through to the card, which is already the button that opens
	# the tree.
	var ups: Array = member.get("upgrades", [])
	if not ups.is_empty():
		var up_lines := PackedStringArray()
		for up in ups:
			up_lines.append("%s — %s" % [String(up.get("ability", "")),
				Run.upgrade_name(String(up.get("id", "")))])
		var up_badge := Label.new()
		up_badge.text = "◆%d" % ups.size()
		up_badge.add_theme_font_size_override("font_size", 12)
		up_badge.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
		up_badge.tooltip_text = "Ability upgrades\n%s" % "\n".join(up_lines)
		up_badge.position = Vector2(CARD_W - 78, 76)
		up_badge.size = Vector2(66, 18)
		up_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		up_badge.mouse_filter = Control.MOUSE_FILTER_PASS
		open.add_child(up_badge)

	# The badges: unspent points and any owed pick, stated on the card rather
	# than behind a click.
	var badges := PackedStringArray()
	if pts > 0:
		badges.append("● %d point%s" % [pts, "" if pts == 1 else "s"])
	if owed_abs > 0:
		badges.append("◆ %d ability" % owed_abs)
	if owed_ups > 0:
		badges.append("◆ %d upgrade" % owed_ups)
	if owed_runes > 0:
		badges.append("◆ %d rune" % owed_runes)
	if not badges.is_empty():
		var badge := Label.new()
		badge.text = "  ".join(badges)
		badge.add_theme_font_size_override("font_size", 12)
		badge.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
		badge.position = at + Vector2(12, 134)
		badge.size = Vector2(CARD_W - 24, 16)
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(badge)

	# Owed picks resolve HERE, on the card, rather than on a screen the
	# player has to know to visit (§2 moved both flows onto the card).
	if owed_abs > 0:
		_draw_pick_row(idx, at + Vector2(12, 154), "NEW ABILITY",
			member.get("bm_candidates", []), Color(0.95, 0.85, 0.4))
	elif owed_ups > 0:
		_draw_upgrade_row(idx, at + Vector2(12, 154))
	elif owed_runes > 0:
		_draw_rune_pick_row(idx, at + Vector2(12, 154))
	else:
		var hint := Label.new()
		hint.text = "click the card for talents"
		hint.add_theme_font_size_override("font_size", 11)
		hint.add_theme_color_override("font_color", Color(0.5, 0.48, 0.52))
		hint.position = at + Vector2(12, 196)
		hint.size = Vector2(CARD_W - 24, 14)
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(hint)


func _bar(at: Vector2, w: float, h: float, frac: float, fill: Color,
		text: String) -> void:
	var back := ColorRect.new()
	back.position = at
	back.size = Vector2(w, h)
	back.color = Color(0.12, 0.11, 0.14)
	back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(back)
	var bar := ColorRect.new()
	bar.position = at
	bar.size = Vector2(w * clampf(frac, 0.0, 1.0), h)
	bar.color = fill
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bar)
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", int(h) - 4)
	lbl.add_theme_color_override("font_color", Color(0.95, 0.93, 0.9))
	lbl.add_theme_constant_override("outline_size", 3)
	lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	lbl.position = at
	lbl.size = Vector2(w, h)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(lbl)


# ---------- picks that resolve on the card ----------

func _draw_pick_row(idx: int, at: Vector2, heading: String, queue: Array,
		tint: Color) -> void:
	var head := Label.new()
	head.text = "%s — choose one" % heading
	head.add_theme_font_size_override("font_size", 11)
	head.add_theme_color_override("font_color", tint)
	head.position = at
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(head)
	if queue.is_empty():
		return
	var offer: Array = queue[0]
	var spec := String(Run.party[idx].get("spec", ""))
	for i in offer.size():
		var pool_name := String(offer[i])
		var ab: Ability = Classes.spec_pool_ability(spec, pool_name)
		var b := Button.new()
		b.text = pool_name
		b.position = at + Vector2(0, 18 + i * 18)
		b.custom_minimum_size = Vector2(CARD_W - 24, 17)
		b.add_theme_font_size_override("font_size", 11)
		if ab != null:
			b.tooltip_text = "%s\n\n%s" % [pool_name, ab.description]
		b.pressed.connect(Music.click)
		b.pressed.connect(_pick_ability.bind(idx, pool_name))
		add_child(b)


func _draw_upgrade_row(idx: int, at: Vector2) -> void:
	var member: Dictionary = Run.party[idx]
	var queue: Array = member.get("up_candidates", [])
	var head := Label.new()
	head.text = "ABILITY UPGRADE — choose one"
	head.add_theme_font_size_override("font_size", 11)
	head.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	head.position = at
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(head)
	if queue.is_empty():
		return
	var offer: Array = queue[0]
	for i in offer.size():
		var up: Dictionary = offer[i]
		var b := Button.new()
		b.text = "%s: %s" % [String(up["ability"]),
			Run.upgrade_name(String(up["id"]))]
		b.position = at + Vector2(0, 18 + i * 18)
		b.custom_minimum_size = Vector2(CARD_W - 24, 17)
		b.add_theme_font_size_override("font_size", 11)
		b.tooltip_text = "%s — %s\n%s" % [Run.upgrade_name(String(up["id"])),
			String(up["ability"]), Run.upgrade_desc(String(up["id"]))]
		b.pressed.connect(Music.click)
		b.pressed.connect(_pick_upgrade.bind(idx, i))
		add_child(b)


func _draw_rune_pick_row(idx: int, at: Vector2) -> void:
	var member: Dictionary = Run.party[idx]
	var queue: Array = member.get("rune_candidates", [])
	var head := Label.new()
	head.text = "RUNE — choose one"
	head.add_theme_font_size_override("font_size", 11)
	head.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	head.position = at
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(head)
	if queue.is_empty():
		return
	var triple: Array = queue[0]
	for i in triple.size():
		var rune: Dictionary = triple[i]
		var b := Button.new()
		b.text = String(rune["name"])
		b.position = at + Vector2(0, 18 + i * 18)
		b.custom_minimum_size = Vector2(CARD_W - 24, 17)
		b.add_theme_font_size_override("font_size", 11)
		b.add_theme_color_override("font_color",
			rune.get("rarity_color", Color(0.8, 0.8, 0.8)))
		b.tooltip_text = "%s  [%s]\n%s" % [rune["name"], rune["rarity"], rune["desc"]]
		b.pressed.connect(Music.click)
		b.pressed.connect(_pick_rune.bind(idx, i))
		add_child(b)


func _pick_ability(idx: int, pool_name: String) -> void:
	var member: Dictionary = Run.party[idx]
	if int(member.get("bm_picks_owed", 0)) < 1 \
			or pool_name in member.get("bm_abilities", []):
		return
	# Spend the triple this pick came from: the other two are gone, not
	# banked for the next award.
	var queue: Array = member.get("bm_candidates", [])
	if not queue.is_empty():
		queue.pop_front()
		member["bm_candidates"] = queue
	member["bm_abilities"] = member.get("bm_abilities", []) + [pool_name]
	member["bm_picks_owed"] = int(member.get("bm_picks_owed", 0)) - 1
	Run.save_run()
	_draw_screen()
	_toast("%s learns %s." % [String(member["key"]).capitalize(), pool_name])


func _pick_upgrade(idx: int, choice: int) -> void:
	var member: Dictionary = Run.party[idx]
	var queue: Array = member.get("up_candidates", [])
	if int(member.get("up_picks_owed", 0)) < 1 or queue.is_empty():
		return
	var offer: Array = queue.pop_front()
	member["up_candidates"] = queue
	var up: Dictionary = offer[clampi(choice, 0, offer.size() - 1)]
	member["upgrades"] = member.get("upgrades", []) + [up.duplicate()]
	member["up_picks_owed"] = int(member.get("up_picks_owed", 0)) - 1
	Run.save_run()
	_draw_screen()
	_toast("%s: %s is now %s." % [String(member["key"]).capitalize(),
		String(up["ability"]), Run.upgrade_name(String(up["id"]))])


func _pick_rune(idx: int, choice: int) -> void:
	var member: Dictionary = Run.party[idx]
	var queue: Array = member.get("rune_candidates", [])
	if int(member.get("rune_picks_owed", 0)) < 1 or queue.is_empty():
		return
	var triple: Array = queue.pop_front()
	member["rune_candidates"] = queue
	var rune: Dictionary = triple[clampi(choice, 0, triple.size() - 1)]
	# Auto-equip while a slot is free — the pick already happens here; save
	# the extra click.
	var worn := 0
	for r in member.get("runes", []):
		if r.get("equipped", false):
			worn += 1
	rune["equipped"] = worn < Run.rune_slots()
	member["runes"] = member.get("runes", []) + [rune]
	member["rune_picks_owed"] = int(member.get("rune_picks_owed", 0)) - 1
	Run.save_run()
	_draw_screen()


# ---------- the rune pouch overlay ----------

func _open_rune_panel(idx: int) -> void:
	if _rune_panel_for == idx:
		return
	_rune_panel_for = idx
	var member: Dictionary = Run.party[idx]
	var runes: Array = member.get("runes", [])
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 60
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.78)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(300, 120)
	panel.custom_minimum_size = Vector2(680, 480)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var equipped := runes.filter(func(r): return r.get("equipped", false)).size()
	var title := Label.new()
	title.text = "%s — RUNES (%d of %d slots filled)" % [
		String(member["key"]).capitalize(), equipped, Run.rune_slots()]
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	if runes.is_empty():
		var none := Label.new()
		none.text = "The pouch is empty. Runes come from the Peddler,\nfrom elites, and from the richer bargains."
		none.add_theme_font_size_override("font_size", 14)
		none.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
		none.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		box.add_child(none)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(650, 380)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 5)
	rows.custom_minimum_size = Vector2(630, 0)
	scroll.add_child(rows)
	for i in runes.size():
		var rune: Dictionary = runes[i]
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		rows.add_child(row)
		var is_on: bool = rune.get("equipped", false)
		var toggle := Button.new()
		toggle.text = "Unequip" if is_on else "Equip"
		toggle.custom_minimum_size = Vector2(84, 26)
		toggle.add_theme_font_size_override("font_size", 11)
		toggle.disabled = not is_on and equipped >= Run.rune_slots()
		toggle.pressed.connect(Music.click)
		toggle.pressed.connect(_toggle_rune.bind(idx, i, overlay))
		row.add_child(toggle)
		var lbl := Label.new()
		lbl.text = "%s%s — %s" % ["✦ " if is_on else "", rune["name"], rune["desc"]]
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Color(0.45, 0.9, 0.5) if is_on
			else rune.get("rarity_color", Color(0.8, 0.8, 0.8)))
		lbl.custom_minimum_size = Vector2(520, 20)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(lbl)

	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(200, 38)
	close.pressed.connect(Music.click)
	close.pressed.connect(func():
		_rune_panel_for = -1
		overlay.queue_free())
	box.add_child(close)


func _toggle_rune(idx: int, rune_idx: int, overlay: Control) -> void:
	var member: Dictionary = Run.party[idx]
	var runes: Array = member.get("runes", [])
	var rune: Dictionary = runes[rune_idx]
	if rune.get("equipped", false):
		rune["equipped"] = false
	else:
		var worn := 0
		for r in runes:
			if r.get("equipped", false):
				worn += 1
		if worn >= Run.rune_slots():
			return
		rune["equipped"] = true
	Run.save_run()
	overlay.queue_free()
	_rune_panel_for = -1
	_draw_screen()
	_open_rune_panel(idx)


# ---------- the footer: gold and the (now usable) potions ----------

func _draw_footer() -> void:
	var gold_lbl := Label.new()
	gold_lbl.text = "Gold: %d" % Run.gold
	gold_lbl.add_theme_font_size_override("font_size", 18)
	gold_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	gold_lbl.position = Vector2(20, 604)
	add_child(gold_lbl)

	# §6: potions are usable HERE, not only in battle. Each item is a button;
	# pressing it asks which hero, then applies the effect on the map.
	var hint := Label.new()
	hint.text = "Potions (usable here — max %d of each)" % Run.ITEM_CAP
	hint.add_theme_font_size_override("font_size", 11)
	hint.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
	hint.position = Vector2(180, 606)
	add_child(hint)
	for i in Run.ITEM_IDS.size():
		var id: String = Run.ITEM_IDS[i]
		var have := int(Run.items.get(id, 0))
		var btn := Button.new()
		btn.text = "%s  x%d" % [Run.ITEM_INFO[id][0].replace(" Potion", ""), have]
		btn.custom_minimum_size = Vector2(196, 34)
		btn.position = Vector2(180 + i * 202, 626)
		btn.add_theme_font_size_override("font_size", 12)
		btn.tooltip_text = _map_item_tooltip(id)
		btn.disabled = have < 1 or not _usable_on_map(id)
		if have >= Run.ITEM_CAP:
			btn.add_theme_color_override("font_color", Color(0.95, 0.75, 0.4))
		btn.pressed.connect(Music.click)
		btn.pressed.connect(_use_item.bind(id))
		add_child(btn)


# The Bomb is the one item with no meaning outside a fight — there is
# nothing on the map to throw it at. It stays in the pouch and says why,
# rather than being silently absent from a list of five.
func _usable_on_map(id: String) -> bool:
	return id != "bomb"


func _map_item_tooltip(id: String) -> String:
	var base: String = Run.ITEM_INFO[id][1]
	if not _usable_on_map(id):
		return "%s\n\nNothing here to throw it at — battle only." % base
	if int(Run.items.get(id, 0)) < 1:
		return "%s\n\nNone carried." % base
	if int(Run.items.get(id, 0)) >= Run.ITEM_CAP:
		return "%s\n\nCarrying the maximum (%d)." % [base, Run.ITEM_CAP]
	return "%s\n\nClick to use it now." % base


# Picking the target: revive offers the fallen, everything else the living.
func _use_item(id: String) -> void:
	if int(Run.items.get(id, 0)) < 1 or not _usable_on_map(id):
		return
	var wants_dead := id == "revive"
	var eligible: Array = []
	for i in Run.party.size():
		var alive := int(Run.party[i]["hp"]) > 0
		if alive != wants_dead:
			eligible.append(i)
	if id == "defense":
		# Party-wide and battle-scoped: there is no "3 turns" on the map, so
		# it is refused here rather than half-applied.
		_toast("The Defense Potion only means something in a fight.")
		return
	if eligible.is_empty():
		_toast("No one to use the %s on." % Run.ITEM_INFO[id][0])
		return
	_open_target_picker(id, eligible)


func _open_target_picker(id: String, eligible: Array) -> void:
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 70
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.75)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(440, 240)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	title.text = "Use the %s on…" % Run.ITEM_INFO[id][0]
	title.add_theme_font_size_override("font_size", 17)
	title.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	box.add_child(title)
	for i in eligible:
		var member: Dictionary = Run.party[int(i)]
		var spec := String(member.get("spec", ""))
		var b := Button.new()
		b.text = "%s — %d/%d HP" % [
			Classes.SPEC_INFO[spec]["name"] if spec != "" \
				else String(member["key"]).capitalize(),
			int(member["hp"]), int(member["max_hp"])]
		b.custom_minimum_size = Vector2(320, 34)
		b.pressed.connect(Music.click)
		b.pressed.connect(_apply_item.bind(id, int(i), overlay))
		box.add_child(b)
	var cancel := Button.new()
	cancel.text = "Cancel"
	cancel.custom_minimum_size = Vector2(320, 32)
	cancel.pressed.connect(overlay.queue_free)
	box.add_child(cancel)


# The map-side effects mirror the battle item table (Run.ITEM_INFO is the
# one place the numbers are written down, so these read the same 40 / 50%
# the fight does).
func _apply_item(id: String, idx: int, overlay: Control) -> void:
	overlay.queue_free()
	if int(Run.items.get(id, 0)) < 1:
		return
	var member: Dictionary = Run.party[idx]
	var line := ""
	match id:
		"health":
			var before := int(member["hp"])
			member["hp"] = mini(before + 40, int(member["max_hp"]))
			line = "%s recovers %d HP." % [String(member["key"]).capitalize(),
				int(member["hp"]) - before]
		"mana":
			if String(member["key"]) not in ["mage", "cleric", "hunter"]:
				_toast("%s has no Mana to restore." % String(member["key"]).capitalize())
				return
			var mana_was := int(member["mana"])
			member["mana"] = mini(mana_was + 40, int(member["max_mana"]))
			line = "%s recovers %d Mana." % [String(member["key"]).capitalize(),
				int(member["mana"]) - mana_was]
		"revive":
			member["hp"] = maxi(int(member["max_hp"]) / 2, 1)
			line = "%s is back on their feet." % String(member["key"]).capitalize()
		_:
			return
	Run.items[id] = int(Run.items.get(id, 0)) - 1
	Run.save_run()
	_draw_screen()
	_toast(line)


# ---------- travel ----------

func _open_hero(idx: int) -> void:
	# The hero sheet is the old Party screen with its LIST view deleted: it
	# opens straight onto one hero, because the map is the party list now.
	# Set the target BEFORE the scene change — change_scene_to_file is
	# deferred, but ordering a write after it is the kind of thing that works
	# until it does not.
	Run.hero_screen_idx = idx
	Run.save_run()
	get_tree().change_scene_to_file("res://scenes/party.tscn")


func _on_slot_pressed(s: int) -> void:
	# Nothing a harness drives may travel the board (Batch AC). RunSim walks
	# Run directly and never loads this scene.
	if Run.sim_run:
		return
	var slot: Dictionary = Run.map[s]
	Run.advance(s)
	var ty := String(slot["type"])
	var warband: Array = slot.get("enemies", [])
	if warband.is_empty():
		warband = Run.compose(ty, s + 1)
		slot["theme"] = Run.last_theme
	Run.encounter = {"type": ty, "enemies": warband,
		"theme": slot.get("theme", "Warband")}
	Run.save_run()
	# Batch AO §2: the offer is an EVENT, not a toll booth — fights and bosses
	# walk straight in, elites and mini-bosses are preceded by the bargain.
	if ty in ["elite", "miniboss"]:
		get_tree().change_scene_to_file("res://scenes/offer.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/battle.tscn")


var _burger_id_this_frame := -1
var _picker: Control = null


func _on_burger(id: int) -> void:
	# One press must never resolve twice: Godot may or may not deliver a
	# SUBMENU press to the parent popup as well, and both are connected here.
	if id == _burger_id_this_frame:
		return
	_burger_id_this_frame = id
	set_deferred("_burger_id_this_frame", -1)
	# THE honesty write site for the whole map DEBUG block (Batch AC). Every
	# debug id passes through this one dispatch, so a debug item added later
	# cannot forget to mark the run. It is also the second gate: firing an id
	# straight into this function has to fail the way the missing menu does.
	if id >= 10:
		if not Run.debug_enabled() or Run.sim_run:
			return
		Run.debug_used = true
	match id:
		0:
			Run.clear_save()
			Run.active = false
			get_tree().change_scene_to_file("res://scenes/draft.tscn")
		1:
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		2:
			Run.save_run()
			get_tree().quit()
		3:
			GlossaryPanel.open(self)
		10:
			Run.gold += 200
			_draw_screen()
		11:
			for member in Run.party:
				member["talent_points"] = member.get("talent_points", 0) + 200
			_draw_screen()
		12:
			Run.heal_party(1.0)
			Run.restore_mana(1.0)
			_draw_screen()
		13:
			# Land on the last pre-boss slot so the boss is the next pick.
			Run.advance(Run.BOSS_SLOT - 1)
			_draw_screen()
		14:
			Run.advance_zone()
			Run.save_run()
			_draw_screen()
		15:
			_debug_reroll_specs()
		16:
			Run.debug_grant_all = not Run.debug_grant_all
			_draw_screen()
			# Batch AU §5: it grants each hero their OWN spec's kit only —
			# the toast says so, or a tester waits for a sibling's ability
			# that is deliberately never coming.
			_toast("DEBUG: each hero's OWN spec abilities %s" % (
				"UNLOCKED for every battle" if Run.debug_grant_all else "gated again"))
		20:
			Run.debug_free_travel = not Run.debug_free_travel
			_draw_screen()
			_toast("DEBUG: free travel %s" % ("ON — every slot is clickable"
				if Run.debug_free_travel else "off"))
		21:
			_summon("shop")
		23:
			_open_event_picker()
		24:
			_summon("fight")
		25:
			_summon("elite")
		26:
			_summon("miniboss")
		_:
			if id >= PICKER_ID_BASE:
				var ids := _event_picker_ids()
				var pick := id - PICKER_ID_BASE
				if pick < ids.size():
					_summon_event(String(ids[pick]))


# Debug spec swap: refund spent points, clear specs, re-awaken. Nodes cost 1
# apiece. The spec-choice point comes back OFF, because re-awakening will
# pay it again — otherwise every swap mints one.
func _debug_reroll_specs() -> void:
	for member in Run.party:
		if String(member.get("spec", "")) == "":
			continue  # never awakened: nothing to refund, nothing paid
		var learned: Dictionary = member.get("talents", {})
		var tree: Array = member.get("tree", [])
		var normal := 0
		var flex := 0
		for talent_id in learned:
			if int(learned[talent_id]) < 1:
				continue
			var node := Talents.node_in_tree(tree, String(talent_id))
			var row := int(node.get("row", 1))
			# A row holding two picks bought the second out of the surplus;
			# the first (definition order) was the ordinary pick.
			var picks: Array = Talents.row_picks(tree, learned, row)
			if picks.size() > 1 and String(picks[0]) != String(talent_id):
				flex += 1
			else:
				normal += 1
		member["talent_points"] = maxi(
			member.get("talent_points", 0) + normal + flex - 1, 0)
		member["spec"] = ""
		member["talents"] = {}
		member["tree"] = []
	Run.specs_chosen = false
	Run.save_run()
	get_tree().change_scene_to_file("res://scenes/spec_choice.tscn")


# ---------- Batch AC: summoning a node in place ----------

# A summoned node is entered IN PLACE and runs for real: the party does not
# move, slot_idx is untouched and nothing is marked visited, so the board is
# exactly as it was when the tester comes back.
func _summon(node_type: String) -> void:
	var next := _begin_summon(node_type)
	if next != "":
		get_tree().change_scene_to_file(next)


# Arms the summoned node and returns the scene it needs, or "" when it
# resolved in place. Split from the scene change so a headless test can
# prove the arming inside a tree that has no current scene to swap.
func _begin_summon(node_type: String) -> String:
	Run.debug_summon = true
	if node_type == "shop":
		Run.save_run()
		return "res://scenes/shop.tscn"
	# The SAME call the map generator makes to roll a slot warband, at the
	# current slot by default — so a summoned fight is budgeted and scaled
	# exactly like the one the party is standing in front of, and there is
	# still exactly one warband generator in the project.
	Run.encounter = {"type": node_type, "enemies": Run.compose(node_type),
		"theme": Run.last_theme}
	return "res://scenes/battle.tscn"


# Alphabetical by title — the list will grow, and a designer looking for one
# event should not have to know its id first.
func _event_picker_ids() -> Array:
	var ids: Array = Events.ids().duplicate()
	ids.sort_custom(func(a, b): return String(Events.config(a).get("title", a)) \
		< String(Events.config(b).get("title", b)))
	return ids


func _open_event_picker() -> void:
	# One picker at a time: a second stacked on the first reads as a frozen
	# screen, and a tester would rightly report it as a bug.
	if _picker != null and is_instance_valid(_picker):
		return
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 95
	_picker = overlay
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.82)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(150, 40)
	panel.custom_minimum_size = Vector2(980, 640)
	overlay.add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "DEBUG — TEST AN EVENT"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", DEBUG_OUTLINE)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	var note := Label.new()
	note.text = ("Every event in the game. Requirement-failing events are "
		+ "selectable on purpose — testing the greyed-out branches is the point, "
		+ "and the event screen still runs its own guards.\nNothing here is "
		+ "recorded: the draw pool is not burned and the chronicle is not told.")
	note.add_theme_font_size_override("font_size", 13)
	note.add_theme_color_override("font_color", Color(0.78, 0.75, 0.68))
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(note)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(940, 500)
	vbox.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 4)
	list.custom_minimum_size = Vector2(920, 0)
	scroll.add_child(list)
	var ids := _event_picker_ids()
	for idx in ids.size():
		var eid: String = ids[idx]
		var cfg := Events.config(eid)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		list.add_child(row)
		var btn := Button.new()
		btn.text = String(cfg.get("title", eid))
		btn.custom_minimum_size = Vector2(320, 34)
		btn.tooltip_text = "id: %s" % eid
		btn.pressed.connect(Music.click)
		btn.pressed.connect(overlay.queue_free)
		btn.pressed.connect(_on_burger.bind(PICKER_ID_BASE + idx))
		row.add_child(btn)
		var id_label := Label.new()
		id_label.text = eid
		id_label.custom_minimum_size = Vector2(180, 0)
		id_label.add_theme_font_size_override("font_size", 12)
		id_label.add_theme_color_override("font_color", Color(0.6, 0.58, 0.55))
		id_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(id_label)
		# Pass/fail comes from the SAME check that filters the real draw, so
		# this column can never disagree with the game.
		var fail := Events.failed_reason(Run, cfg.get("requires", {}))
		var state := Label.new()
		state.text = "requirements met" if fail == "" else "FAILS: %s" % fail
		state.add_theme_font_size_override("font_size", 12)
		state.add_theme_color_override("font_color",
			Color(0.5, 0.8, 0.55) if fail == "" else Color(0.95, 0.6, 0.45))
		state.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		state.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		state.custom_minimum_size = Vector2(400, 0)
		row.add_child(state)

	var close := Button.new()
	close.text = "Cancel"
	close.custom_minimum_size = Vector2(200, 40)
	close.pressed.connect(Music.click)
	close.pressed.connect(overlay.queue_free)
	vbox.add_child(close)


# A summoned event runs through the normal event screen so its own guards
# behave exactly as they would in play. What it does NOT do is book
# anything: no Run.seen_events append and no Profile.note_event.
func _summon_event(id: String) -> void:
	Run.debug_summon = true
	Run.pending_event = id
	get_tree().change_scene_to_file("res://scenes/event.tscn")


# The hover card for a combat slot: theme, lineup, and the warband's damage
# type identity — how many units resist a type and how many are vulnerable
# ("Resists: Nature x3 / Soft to: Fire x2").
func _warband_tooltip(slot: Dictionary) -> String:
	var kinds: Array = slot.get("enemies", [])
	if kinds.is_empty():
		return "Scouts have not returned."
	var counts := {}
	for kind in kinds:
		counts[kind] = int(counts.get(kind, 0)) + 1
	var name_parts := PackedStringArray()
	for kind in counts:
		var label: String = Enemies.unit_name(kind)
		if counts[kind] > 1:
			label = "%dx %s" % [counts[kind], label]
		name_parts.append(label)
	# Units resisting / vulnerable per damage type, counted so one odd member
	# never masquerades as the whole band's identity. Token trims (the 5-15%
	# physical hides) stay off the card — only resists that change a fight
	# plan (25%+) count; every vulnerability counts.
	var resist_units := {}
	var vuln_units := {}
	for kind in kinds:
		var res: Dictionary = Enemies.resists_for(kind)
		for dtype in res:
			if float(res[dtype]) >= 0.2:
				resist_units[dtype] = int(resist_units.get(dtype, 0)) + 1
			elif float(res[dtype]) < 0.0:
				vuln_units[dtype] = int(vuln_units.get(dtype, 0)) + 1
	var text := "%s\n%s" % [String(slot.get("theme", "Warband")),
		", ".join(name_parts)]
	var hard := _type_counts_line(resist_units)
	if hard != "":
		text += "\nResists: %s" % hard
	var soft := _type_counts_line(vuln_units)
	if soft != "":
		text += "\nSoft to: %s" % soft
	return text


# "Nature x3, Shadow x2" — biggest cluster first, bare name for singles.
func _type_counts_line(units_by_type: Dictionary) -> String:
	var types: Array = units_by_type.keys()
	types.sort_custom(func(a, b): return units_by_type[a] > units_by_type[b])
	var parts := PackedStringArray()
	for dtype in types:
		var label: String = String(dtype).capitalize()
		if units_by_type[dtype] > 1:
			label += " x%d" % units_by_type[dtype]
		parts.append(label)
	return ", ".join(parts)


func _toast(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.6))
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	label.position = Vector2(0, 100)
	label.size = Vector2(1280, 26)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.z_index = 50
	add_child(label)
	var tween := create_tween()
	tween.tween_interval(1.4)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
