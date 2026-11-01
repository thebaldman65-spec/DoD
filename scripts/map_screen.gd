# The run map (Batch BK): a GENERATED 3-ROW LATTICE of 16 slots for the
# current zone, rendered LEFT TO RIGHT — column 1 on the left edge, the boss
# on the right, with the drawn edges between them. Batch AN's fixed line is
# gone and so is AO's two-constant flip; the direction is still left to right,
# and it is now a property of the lattice loop rather than of a sign.
#
# WHAT THE SCREEN HAS TO SHOW, and every layout decision below follows from
# it: the WHOLE zone, before the first step. A route is only planned if it can
# be read, so the lattice scrolls horizontally inside a clipped viewport and
# nothing about a node is hidden — type, warband, and (the part that makes
# foreclosure legible at all) WHETHER IT IS STILL REACHABLE FROM WHERE THE
# PARTY STANDS. A node a step has closed off is drawn nearly out, which is the
# only way a player sees the cost of the step they just took.
#
# THIS SCREEN IS ALSO THE PARTY SCREEN. All four hero stat cards live here
# rather than behind a Party button — HP, resource, three rune slots, unspent
# points — and the potion inventory is INTERACTIVE. §5 moves the cards to the
# LEFT EDGE, stacked, so the whole right two thirds belongs to the map.
# Clicking a card opens that hero's sheet (talents, abilities, runes); clicking
# a rune slot opens the pouch; an owed pick opens its own overlay, because a
# compact card has no room for three choice buttons and an overlay is the
# pattern the pouch already set.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const NODE_LABELS := {
	"fight": "Fight", "elite": "ELITE", "boss": "BOSS", "miniboss": "MINI-BOSS",
	# BATCH GJ §4 — IT READ "WARDEN", the word the Withered Warden, the Warden
	# spec and the second difficulty rung also carry: four things, one word, and
	# the Warden the zone's readout names stands two columns along. MINI-BOSS is
	# the plain voice the END BOSS label below was confirmed in.
	"blacksmith": "Smith", "merchant": "Trade", "event": "???",
	# BATCH GI — PROPOSED, AND THE DESIGNER CONFIRMS IT: the name the glossary,
	# the framing card and the run summary already give this node.
	"endboss": "END BOSS",
}
const NODE_COLORS := {
	"fight": Color(0.75, 0.72, 0.65), "elite": Color(0.95, 0.55, 0.3),
	"boss": Color(0.9, 0.3, 0.35),
	# Between the elite's orange and the boss's red, because that is exactly
	# where the slot sits.
	"miniboss": Color(0.95, 0.42, 0.32),
	"blacksmith": Color(0.85, 0.68, 0.35),
	"merchant": Color(0.45, 0.82, 0.55),
	# §4: ONE icon and ONE colour for all three event kinds. A tradeoff, a
	# boon and a bane are indistinguishable on the board on purpose — a
	# visibly-bad node is a wall with extra steps, not a gamble.
	"event": Color(0.72, 0.55, 0.95),
	# BATCH GI — the zone boss's red, because it is a boss: the last one.
	"endboss": Color(0.9, 0.3, 0.35),
}

# The lattice geometry. Column c sits at LAT_X0 + c * LAT_X_STEP inside the
# scrolled content; row r at LAT_Y0 + r * LAT_Y_STEP. The content is wider
# than the viewport by design — see _draw_lattice.
const LAT_X0 := 44.0
const LAT_X_STEP := 78.0
const LAT_Y0 := 46.0
const LAT_Y_STEP := 128.0
const NODE_W := 68.0
const NODE_H := 30.0
# The viewport the lattice is clipped to: the right two thirds, above the
# potion footer.
const VIEW_X := 316.0
const VIEW_Y := 84.0
const VIEW_W := 956.0
const VIEW_H := 452.0
# BATCH CT §1: the pouch row, sized so SIX slots fit inside the 1280 viewport.
# VIEW_W is exactly the space from VIEW_X to the right edge, so the pitch is
# derived from it rather than guessed: 6 * 158 = 948, and the last button ends
# at VIEW_X + 4 + 5 * 158 + 150 = 1265. The old 190/182 pair fit five and ran
# the sixth 172px off-screen — see the note in the footer for the whole story.
const POUCH_PITCH := 158.0
const POUCH_BTN_W := 150.0

# How far the lattice is scrolled, kept across the redraws a pick or a potion
# triggers — a screen that jumped back to column 1 every time a point was
# spent would be unusable. NEGATIVE means "not placed yet": the first draw of
# a scene centres on the party's own column, and every redraw after it holds
# where the player left it.
var _map_scroll := -1.0
# Every lattice control, with the content x-range it occupies. `clip_contents`
# clips DRAWING and nothing else: a button scrolled out of the viewport is
# invisible but still takes clicks and still shows its tooltip, in a strip
# beside the hero cards where nothing appears to be. Input is clipped by hand
# in _clip_lattice_input, called on every scroll.
var _lattice_controls: Array = []

# Debug-only-reachable slots (Batch AC) wear this outline — a colour no
# slot type and no slot state uses.
const DEBUG_OUTLINE := Color(1.0, 0.35, 0.85)
# Burger ids: 0-3 are the real entries, 10-16 the pre-AC debug block,
# 20-26 the summon block, and 100+ one per event in the picker.
const PICKER_ID_BASE := 100

# Which hero's pouch is open on the rune overlay, or -1.
var _rune_panel_for := -1
# BATCH HK §2 — whether the bag's own panel is open, and which bag rune's Drop is
# armed there (by name, "" for none): a drop from the bag is for good, so it takes
# two presses, the shop's Sell shape.
var _bag_panel_open := false
var _bag_drop_armed := ""
# BATCH HR §1 — the hero's panel's Drop, armed by the rune's name, as the bag's is.
var _held_drop_armed := ""

# BATCH EG §2 — the same, for the loadout panel. Its own flag rather than a
# shared one: the two overlays are opened from two buttons on the same card and
# a shared guard would make one refuse to open because the other had been.
var _loadout_panel_for := -1


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	# Every summoned node that leaves the map comes back HERE, so this is
	# where the summon flag is put down.
	Run.debug_summon = false
	Music.play("map")
	_draw_screen()
	_announce_arrival()
	# BATCH IB §1 — A RETURN FROM THE HERO SHEET OR THE TALENTS IS NOT AN ARRIVAL
	# (`Run.map_reentry`), so what the party carried here is opened once, when it came.
	var arrived := not Run.map_reentry
	Run.map_reentry = false
	# The walk never opens under the framing card: it starts only when the card is not
	# up, and dismissing the card starts nothing. The two cannot meet in play — the card
	# shows only before the run's first step, and nothing is owed then — so a pick owed
	# under it (a fixture's) waits for the next arrival; a screen over an orientation
	# card is the failure this order is written to prevent.
	if not _maybe_show_framing() and arrived:
		_begin_arrival()


# ══ BATCH HR §2 — THE DROP'S TOAST NAMES THE HERO ════════════════════════════════
#
# **ONE CHOICE IS NEVER TWO THINGS WITH NO ANNOUNCEMENT (HO's rule), AND A DROP IS
# SAID ON THE MAP AGAINST THE HERO WHOSE IT IS**: the rune, the nameplate it went to
# — the name on the card whose marker just moved — and that it waits unworn. A
# crest rune is said against the bag, whose marker moved instead. `Run.last_drop`
# is the drop as `drop_after_fight` put it down; it is read once and cleared, so a
# redraw never says it twice. And what a load had to tell the player
# (`Run.load_notes`: a rune kept in the bag with no hero to hold it) is said here
# too, once.
func _announce_arrival() -> void:
	var lines := PackedStringArray()
	for note in Run.load_notes:
		lines.append(String(note))
	Run.load_notes = []
	var drop: Dictionary = Run.last_drop
	Run.last_drop = {}
	if not drop.is_empty():
		lines.append(drop_toast_text(drop))
	if not lines.is_empty():
		_toast("   ·   ".join(lines))


# The words, apart so a gate can ask them of a drop it did not have to fight for.
func drop_toast_text(drop: Dictionary) -> String:
	var rune: Dictionary = drop.get("rune", {})
	var nm := String(rune.get("name", ""))
	var where := String(drop.get("where", ""))
	var hi := int(drop.get("hero", -1))
	var who := ""
	if hi >= 0 and hi < Run.party.size():
		who = "the %s" % Run.nameplate(Run.party[hi])
	if Runes.is_party_rune(rune) or who == "":
		match where:
			"bag":
				return "%s drops for the crest — it waits in the bag." % nm
			"pending":
				return "%s drops for the crest — the bag is full: choose below." % nm
		return "%s drops — it waits in the bag." % nm
	if where == "pending":
		return "%s drops for %s — every place he holds is taken: choose below." % [nm, who]
	return "%s drops for %s — held, not worn: equip it from the card.%s" % [nm, who,
		pet_clause(Run.party[hi], rune)]


# ══ BATCH HZ §3 — THE SHARPSHOOTER'S TOAST NAMES THE PET (HW's ruling 2: name it) ═══
#
# A core rune taken after class selection waits unworn on the hero until it is slotted
# (HL §1: one pick is never two things). When it is one that DISMISSES THE PET and the
# hero still fields one, slotting it takes the pet's card out of the kit — so the toast
# that says the rune is waiting says that too. **Read off the data, never typed here**:
# which runes dismiss the pet (`Classes.dismisses_pet`) and the card the pet comes from
# (`Classes.PET_CARD`). Empty for every other rune, and for a hero already without one.
func pet_clause(member: Dictionary, rune: Dictionary) -> String:
	var eng := String(rune.get("engine", ""))
	if eng == "" or not Classes.dismisses_pet([eng]) \
			or Classes.dismisses_pet(Run.held_engines(member)) \
			or not Run.opening_kit_names(member).has(Classes.PET_CARD):
		return ""
	return " Slotted, it sends the companion away: %s leaves the kit." % Classes.PET_CARD


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
	body.text = ("A run is 49 encounters — three zones of sixteen, and then\nthe end boss. A zone is a\n" +
		"MAP, not a road: up to three ways forward, reading LEFT TO\n" +
		"RIGHT, converging on the MINI-BOSS in the middle and the BOSS at\n" +
		"the end. Scroll it and read the whole zone before you step.\n\n" +
		"Nothing is guaranteed on a route. Step down a row and the corridor\n" +
		"above you is closed for the next few columns — that IS the choice.\n\n" +
		"Every FIGHT drops a rune for one of the heroes. ELITES pay a draft\n" +
		"pick and a rune cache, and cost you health. The SMITH sells ability\n" +
		"upgrades for gold. TRADE is the Peddler. ??? is something standing\n" +
		"on the road, and you will not know what until you stand on it.\n\n" +
		"Before every elite, and every mini-boss but Ruin's, THREE BARGAINS:\n" +
		"a condition on the coming battle, and what clearing\n" +
		"it pays — one always the safer deal. Ruin's mini-boss fights unpaid.\n\n" +
		"Winning any fight heals every hero %d%%. There is no resting.\n" % int(round(Run.SLOT_HEAL_PCT * 100)) +
		"Death ends the run and takes everything, but every boss you fell\n" +
		"leaves a RELIC behind, unlocked forever, and every zone boss a\n" +
		"talent point for each class among the heroes, banked as it falls.")
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
	# BATCH IR — THE CARD IS PLACED BY ITS OWN HEIGHT, SO ITS BUTTON IS ON THE SCREEN. It stood at y=150
	# and measured 660 px tall, so "Take the road" — the one way past it — sat below the 720-px screen on a
	# first run. Centred on what it holds (GT §1: make room for the text first, shrink nothing).
	panel.position.y = maxf((720.0 - panel.get_combined_minimum_size().y) * 0.5, 0.0)
	return true


# Where a node sits INSIDE the scrolled content. The mini-boss and the boss
# hold one node each and are drawn on the middle row; a branching slot's node
# uses its stored `row`, so a pruned column keeps the gaps that make the
# lattice read as authored rather than as a grid.
func _node_pos(slot: int, node: Dictionary) -> Vector2:
	return Vector2(LAT_X0 + slot * LAT_X_STEP,
		LAT_Y0 + int(node.get("row", 1)) * LAT_Y_STEP)


func _draw_screen() -> void:
	# BATCH HR §2 — A TOAST OUTLIVES A REDRAW: the drop's toast is put up as the map
	# opens, and the chain that follows (the draft, the pouch's offer, a full
	# holding's panel) can redraw the board under it. It frees itself when it fades.
	for child in get_children():
		if child.has_meta("toast"):
			continue
		child.queue_free()
	_rune_panel_for = -1
	_loadout_panel_for = -1
	_bag_panel_open = false
	# The draft overlay is a child too, so a redraw takes it with it. The
	# STAGED CHOICES deliberately survive (`_draft_stage` is not cleared here):
	# nothing was committed, so reopening from the card's CHOOSE button puts
	# the player back where they were rather than making them start over.
	_draft_overlay = null
	_hero_draft_for = -1

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
	_draw_lattice()
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
	# BATCH GI — AND IT NAMES WHAT THE NEXT STEP FIGHTS. Past the final zone's
	# boss the next node is the end boss and the zone's boss is already down, so
	# "the Withered Warden waits" would name a corpse.
	var waits_kind: String = Run.END_BOSS_KIND if _next_is_end_boss() \
		else Run.boss_kind()
	var boss_name: String = Enemies.name_after_the(waits_kind)
	var subtitle := Label.new()
	var here := Run.slot_idx + 1
	if here < 1:
		subtitle.text = "Zone %d of %d — 16 encounters to the %s" % [
			Run.zone_idx + 1, Run.SLOT_COUNT, boss_name]
	else:
		subtitle.text = "Zone %d of %d — encounter %d of %d (%d of %d) — the %s waits" % [
			Run.zone_idx + 1, Run.SLOT_COUNT, here, Run.map.size(),
			Run.run_slot_number(), Run.total_slots(), boss_name]
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
		bpop.add_item("Talent Points to 60 (all)", 11)
		bpop.add_item("Full Heal Standing Heroes", 12)
		bpop.add_item("Jump to Boss Slot", 13)
		bpop.add_item("Advance to Next Zone", 14)
		bpop.add_item("Reroll Specs", 15)
		bpop.add_check_item("All Class Abilities Unlocked", 16)
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


# BATCH GI — whether the node the next step reaches is the end boss, read off
# the board rather than off the zone number: only the final board carries one,
# and only that board's boss leads to it.
func _next_is_end_boss() -> bool:
	var nxt: int = Run.slot_idx + 1
	return nxt >= 0 and nxt < Run.map.size() and not Run.map[nxt].is_empty() \
		and String(Run.map[nxt][0].get("type", "")) == "endboss"


# ---------- the lattice ----------

# The whole zone, drawn once, inside a clipped viewport that scrolls. Order
# matters: edges first so nodes sit on top of them, then the nodes, then the
# scrollbar outside the clip.
func _draw_lattice() -> void:
	_lattice_controls = []
	var view := Control.new()
	view.position = Vector2(VIEW_X, VIEW_Y)
	view.size = Vector2(VIEW_W, VIEW_H)
	# The one line that makes horizontal scrolling possible without the
	# lattice drawing over the hero cards.
	view.clip_contents = true
	view.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(view)
	var inner := Node2D.new()
	view.add_child(inner)

	# BATCH GI — THE LATTICE DRAWS THE BOARD IT IS HANDED, NOT A CONSTANT. Every
	# zone is `SLOTS_PER_ZONE` wide and the final one is one wider — the end boss
	# is appended after its boss (`Run._build_lattice`) — so the width, and both
	# loops below, read `Run.map.size()`. They read the constant from BK to GI,
	# and the seventeenth column was never drawn: the edge to the end boss was,
	# because the edge loop reads `map[s + 1]`, and the node itself was not.
	var content_w: float = LAT_X0 * 2.0 + (Run.map.size() - 1) * LAT_X_STEP \
		+ NODE_W
	var max_scroll: float = maxf(content_w - VIEW_W, 0.0)
	# Centre the party's own column on entry, then hold wherever the player
	# left it. A fresh zone opens at the left edge, which is where column 1 is.
	if _map_scroll < 0.0:
		_map_scroll = clampf(LAT_X0 + maxi(Run.slot_idx, 0) * LAT_X_STEP
			- VIEW_W * 0.5, 0.0, max_scroll)
	_map_scroll = clampf(_map_scroll, 0.0, max_scroll)
	inner.position = Vector2(-_map_scroll, 0.0)

	# WHAT IS STILL REACHABLE from where the party stands. Before the first
	# step every entry node is; after it, this is the set a step has left —
	# and everything outside it is what the step cost.
	var live := {}
	if Run.slot_idx < 0:
		for j in Run.map[0].size():
			live["0,%d" % j] = true
			_merge_reach(live, Run.reachable_from(0, j))
	else:
		live = Run.reachable_from(Run.slot_idx, Run.node_idx)
	var next_slot: int = Run.slot_idx + 1
	var free_travel: bool = Run.debug_enabled() and Run.debug_free_travel
	var reach: Array = Run.reachable()

	for s in Run.map.size():
		for j in Run.map[s].size():
			var node: Dictionary = Run.map[s][j]
			var from_pos := _node_pos(s, node) + Vector2(NODE_W * 0.5, NODE_H * 0.5)
			for t in node.get("next", []):
				var target: Dictionary = Run.map[s + 1][int(t)]
				var edge := Line2D.new()
				edge.add_point(from_pos)
				edge.add_point(_node_pos(s + 1, target)
					+ Vector2(NODE_W * 0.5, NODE_H * 0.5))
				var walked: bool = bool(node["visited"]) and bool(target["visited"])
				var open_edge: bool = live.has("%d,%d" % [s, j])
				edge.width = 4.0 if walked else 2.0
				if walked:
					edge.default_color = Color(0.85, 0.72, 0.35, 0.85)
				elif open_edge:
					edge.default_color = Color(0.42, 0.38, 0.5, 0.75)
				else:
					edge.default_color = Color(0.2, 0.19, 0.24, 0.5)
				inner.add_child(edge)

	for s in Run.map.size():
		for j in Run.map[s].size():
			_draw_node(inner, s, j, s == next_slot, reach, live, free_travel)

	if max_scroll > 0.0:
		var bar := HScrollBar.new()
		bar.position = Vector2(VIEW_X, VIEW_Y + VIEW_H + 2.0)
		bar.custom_minimum_size = Vector2(VIEW_W, 14)
		bar.size = Vector2(VIEW_W, 14)
		bar.min_value = 0.0
		bar.max_value = content_w
		bar.page = VIEW_W
		bar.value = _map_scroll
		bar.value_changed.connect(func(v: float):
			_map_scroll = v
			inner.position = Vector2(-v, 0.0)
			_clip_lattice_input())
		add_child(bar)
	_clip_lattice_input()

	if free_travel:
		var marker := Label.new()
		marker.text = "DEBUG: FREE TRAVEL"
		marker.add_theme_font_size_override("font_size", 13)
		marker.add_theme_color_override("font_color", DEBUG_OUTLINE)
		marker.add_theme_constant_override("outline_size", 3)
		marker.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		marker.position = Vector2(VIEW_X, 62)
		marker.z_index = 40
		add_child(marker)


func _merge_reach(into: Dictionary, from: Dictionary) -> void:
	for k in from:
		into[k] = true


# A control scrolled entirely out of the viewport stops taking input. Partly
# visible keeps it: the half a player can see is the half they can click, and
# refusing input to a node they can plainly see would be the worse bug.
func _clip_lattice_input() -> void:
	for entry in _lattice_controls:
		var ctrl: Control = entry["ctrl"]
		if not is_instance_valid(ctrl):
			continue
		var left: float = float(entry["x0"]) - _map_scroll
		var right: float = float(entry["x1"]) - _map_scroll
		ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE \
			if right <= 0.0 or left >= VIEW_W else Control.MOUSE_FILTER_STOP


# FOUR STATES, four clearly separate reads, and the fourth is the new one:
# cleared is history (dim green), a node the party may step onto is THE option
# (full colour, bigger), the road ahead recedes into the dark, and a node this
# route can no longer reach is nearly gone.
func _draw_node(inner: Node2D, s: int, j: int, is_next: bool, reach: Array,
		live: Dictionary, free_travel: bool) -> void:
	var node: Dictionary = Run.map[s][j]
	var ty := String(node["type"])
	var at := _node_pos(s, node)
	var open_now: bool = is_next and (reach.has(j) or free_travel)
	var debug_only: bool = free_travel and is_next and not reach.has(j)
	var reachable_still: bool = live.has("%d,%d" % [s, j])

	var btn := Button.new()
	btn.text = String(NODE_LABELS.get(ty, ty))
	var w: float = NODE_W + 8.0 if open_now else NODE_W
	btn.position = at - Vector2((w - NODE_W) * 0.5, 0.0)
	btn.custom_minimum_size = Vector2(w, NODE_H)
	btn.size = Vector2(w, NODE_H)
	btn.disabled = not open_now
	btn.add_theme_font_size_override("font_size", 13 if open_now else 11)
	if node["visited"]:
		btn.modulate = Color(0.48, 0.66, 0.48)
	elif debug_only:
		btn.modulate = _debug_tint(NODE_COLORS.get(ty, Color.WHITE))
	elif open_now:
		btn.modulate = NODE_COLORS.get(ty, Color.WHITE)
	elif reachable_still:
		btn.modulate = Color(0.52, 0.50, 0.58)
	else:
		btn.modulate = Color(0.26, 0.25, 0.30)
	btn.pressed.connect(Music.click)
	btn.pressed.connect(_on_node_pressed.bind(j))
	btn.tooltip_text = _node_tooltip(node, s, reachable_still)
	if debug_only:
		btn.tooltip_text = "[DEBUG] " + btn.tooltip_text
	inner.add_child(btn)
	_lattice_controls.append({"ctrl": btn, "x0": btn.position.x,
		"x1": btn.position.x + w})
	if debug_only:
		_add_debug_outline_at(inner, btn.position, Vector2(w, NODE_H))

	# The column number under each node: sixteen slots and three rows want a
	# ruler, and "which encounter is this" is the first thing a player asks.
	var num := Label.new()
	num.text = str(s + 1)
	num.add_theme_font_size_override("font_size", 10)
	num.add_theme_color_override("font_color",
		Color(0.7, 0.66, 0.6) if open_now else Color(0.42, 0.40, 0.47))
	num.position = at + Vector2(0, NODE_H + 2.0)
	num.size = Vector2(NODE_W, 12)
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	num.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner.add_child(num)


# What a node says on hover. Combat nodes reveal their warband and what it
# resists / crumples to — mini-bosses and the boss show their TYPE but not
# their identity, because learning which pair you drew by fighting the
# mini-boss is the point. The three EVENT kinds share one line: an event that
# announced itself as a bane would never be walked onto.
func _node_tooltip(node: Dictionary, s: int, reachable_still: bool) -> String:
	var ty := String(node["type"])
	var closed := "" if reachable_still or bool(node["visited"]) \
		else "\n\nNo longer reachable from where the heroes stand."
	if ty in ["miniboss", "boss"]:
		var what := "A mini-boss holds the middle of the zone." if ty == "miniboss" \
			else "The zone's boss. Nothing goes around it."
		# BATCH IR §1a — on a rung that arms a fixed modifier the mini-boss offers no bargain,
		# so the line says what the node does instead, asked through the one predicate.
		var tail := ""
		if ty == "miniboss":
			tail = "\n\nA bargain is offered before it." if Run.offers_bargain(ty) \
				else "\n\nIt fights under a modifier the road chooses, and no bargain is offered."
		# The zone's boss is fixed by the zone and the header already names it, so only
		# the mini-boss keeps its identity back.
		var know := "You will not know which until you meet it." if ty == "miniboss" \
			else "It is the %s." % Enemies.name_after_the(Run.boss_kind())
		return "%s\n%s%s" % [what, know, tail]
	# BATCH GI — PROPOSED, AND THE DESIGNER CONFIRMS IT. The zone boss's two
	# sentences, for the one boss that is always the same creature (its node is
	# never composed) and after which there is no road.
	if ty == "endboss":
		return "The END BOSS. Nothing goes around it.\nIt is always the %s, and the road ends here." \
			% Enemies.name_after_the(Run.END_BOSS_KIND)
	# BATCH GI — the zone's own length, as the header and the run summary print
	# it: sixteen, or seventeen on the final board.
	var head := "Encounter %d of %d" % [s + 1, Run.map.size()]
	match ty:
		"blacksmith":
			return ("%s — THE BLACKSMITH\nThree ability upgrades on the counter, " +
				"gold only.\nOne purchase and the visit is over. %d gold here.%s") % [
					head, Run.blacksmith_price(), closed]
		# BATCH FG §3 — IT READ "to each hero who has a free slot" AND THE SHOP
		# HAS NEVER ASKED. `shop_screen._roll_offers` walks EVERY party member
		# and calls `Run.rune_slots()` nowhere; `_buy_rune` does not either, so
		# a rune bought with three worn goes into the pouch unequipped. The cap
		# is enforced where a rune is WORN (this file's own toggle, and the
		# elite pick's auto-equip), and the sim's "13.6 refusals a run for no
		# free slot" is the BOT's buying policy rather than the shop's.
		# BATCH HK §3 — HE SELLS RUNES AND BUYS THEM BACK. HR §1 — a rune bought goes to
		# the hero it is for (a crest rune to the bag), and he buys back any rune
		# nobody wears.
		"merchant":
			return ("%s — THE PEDDLER\nPotions, and one rune offered to every hero. He buys\n" +
				"back a rune nobody wears for a third.%s") % [head, closed]
		"event":
			return ("%s — ???\nSomething stands on the road. It may want to trade, " +
				"it\nmay be a gift, and it may simply cost you.%s") % [head, closed]
	var bargain := ""
	if ty == "elite":
		head += " — ELITE"
		bargain = "\n\nA bargain is offered before this fight."
	# BATCH HK §1 — a normal fight won drops a rune, and the node says so. HR §1 —
	# for the hero whose class it is, or the bag for a crest rune.
	elif ty == "fight":
		bargain = "\n\nWin it and a rune drops for one of the heroes."
	return "%s\n%s%s%s" % [head, _warband_tooltip(node), bargain, closed]


func _add_debug_outline_at(parent: Node, at: Vector2, size: Vector2) -> void:
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
	parent.add_child(frame)


# The slot's own colour, pulled toward grey and dimmed: readable as "this is
# an elite", never readable as "this is an option".
func _debug_tint(c: Color) -> Color:
	var grey := (c.r + c.g + c.b) / 3.0
	return Color(lerpf(c.r, grey, 0.65) * 0.82, lerpf(c.g, grey, 0.65) * 0.82,
		lerpf(c.b, grey, 0.65) * 0.82)


# ---------- the hero cards ----------

# Batch BK §5: STACKED DOWN THE LEFT EDGE, not spread along the bottom. The
# card lost 74 pixels of height in the move and gave them to the map; what it
# gave up is the inline pick row, which is a screen now (the hero's own,
# `_open_hero_draft`, since ID §1 for every kind) — three choice buttons never fit
# a 152-tall card and a card that scrolled would be worse than a click.
const CARD_W := 300.0
const CARD_H := 152.0
const CARD_X := 8.0
const CARD_Y := 84.0
const CARD_STEP := 158.0
# BATCH HR §2 — the nameplate marker's width: "✦ 8" at font 13 with the button's
# own margins, between the name and the upgrades badge.
const NAMEPLATE_MARK_W := 44.0
# BATCH IH §6 — the card's lines, each as tall as the line its text needs (measured at IH, Open Sans
# SemiBold: font 14 → 20 px, font 11 → 16, font 8 → 12).
const CARD_NAME_H := 20.0
const CARD_HP_BAR_H := 16.0
const CARD_RES_BAR_H := 12.0
# The ✦ marker is a 26-px button at y 4 (font 13, its margins), so the bars start under its foot.
const CARD_HP_Y := 31.0
const CARD_RES_Y := 49.0
# BATCH ID §4 — THE KIT BUTTON's WIDTH, and its place: the card's bottom-right, on the CHOOSE
# row. It sat after the rune slots from EG, sized `CARD_W - 24 - 3 × 96` — below zero once the
# slots were three, so it took its text's width from x 304 and ran 36 px past the card's 300
# (FOUND AT IA). Measured at ID: *Kit 10/10*, the widest the ladder reaches, is 51 px at font 10
# with the button's margins, and the rune row leaves 8 — the three slots keep their 92 px (GX §2's
# marker needs them) — so it takes its own place, and CHOOSE and the core-rune line give it room.
const KIT_BTN_W := 56.0
# BATCH IH §2 — THE RUNES BUTTON's WIDTH, beside Kit on the same row: the room the core-rune line
# gave up. Measured at IH at font 10 with the button's margins: *Runes 6/6* is 56 px — KIT_BTN_W —
# and *○ Runes 6/6*, the face a core rune that sits out gives it, 65. It takes the wider, so the
# face can change and the button cannot move.
const RUNES_BTN_W := 65.0
# The gap between Runes and Kit: at 4 the two dark faces read as one box on the real screen (IH §2).
const ROW_BTN_GAP := 6.0


func _draw_hero_cards() -> void:
	for i in Run.party.size():
		_draw_hero_card(i, Vector2(CARD_X, CARD_Y + i * CARD_STEP))


func _draw_hero_card(idx: int, at: Vector2) -> void:
	# BATCH IH §6 — every control this card draws is tagged with its seat (`hero_card`), so a check can
	# hold the card's own parts to the rule that nothing on it is drawn over anything else on it.
	var first_child := get_child_count()
	_draw_hero_card_parts(idx, at)
	for k in range(first_child, get_child_count()):
		get_child(k).set_meta("hero_card", idx)


# BATCH IH §6 — NOTHING ON A CARD IS DRAWN OVER ANYTHING ELSE ON IT (the designer's rule). The portrait
# keeps its 44-px column (expand mode before size: it drew at its texture's own size, the Berserker's
# 64-px bust over his name and his Rage line); every label is parented before it is sized (sized first
# it takes the default font's 22-px line); a bar's value is drawn in a bar as tall as its line.
func _draw_hero_card_parts(idx: int, at: Vector2) -> void:
	var member: Dictionary = Run.party[idx]
	var key := String(member["key"])
	var spec := String(member.get("spec", ""))
	var owed_runes := int(member.get("rune_picks_owed", 0))
	var owed_abs := int(member.get("bm_picks_owed", 0))
	var owed_ups := int(member.get("up_picks_owed", 0))
	var owed_draft := int(member.get("draft_picks_owed", 0))  # BATCH BO §3

	var panel := Panel.new()
	panel.position = at
	panel.size = Vector2(CARD_W, CARD_H)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.06, 0.05, 0.08, 0.92)
	sb.set_corner_radius_all(6)
	sb.set_border_width_all(2)
	# The border carries the loudest unspent thing: rune purple > pick gold >
	# nothing. BATCH BM dropped the talent-gold rung — there is nothing to
	# spend in a run any more, so a card can no longer owe a talent pick.
	sb.border_color = Color(0.24, 0.22, 0.28)
	if owed_runes > 0:
		sb.border_color = Color(0.75, 0.45, 1.0)
	elif owed_abs > 0 or owed_ups > 0 or owed_draft > 0:
		sb.border_color = Color(0.95, 0.85, 0.4)
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
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.texture = Classes.class_icon(key, spec)
	portrait.position = at + Vector2(8, 8)
	portrait.custom_minimum_size = Vector2(44, 44)
	portrait.size = Vector2(44, 44)
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# BATCH II §0.3 — the shared crop, tinted by seat, for every lineage (the Berserker's bust is kept and drawn nowhere).
	portrait.modulate = Classes.HERO_TINTS[idx % Classes.HERO_TINTS.size()]
	add_child(portrait)

	var name_lbl := Label.new()
	name_lbl.text = Classes.SPEC_INFO[spec]["name"] if spec != "" \
		else (key.capitalize() if bool(member.get("awakened", false))
			else "%s — Unawakened" % key.capitalize())
	name_lbl.add_theme_font_size_override("font_size", 14)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.86, 0.76))
	name_lbl.clip_text = true
	name_lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(name_lbl)
	name_lbl.position = at + Vector2(58, 5)
	name_lbl.size = Vector2(CARD_W - 108, CARD_NAME_H)
	# ══ BATCH HR §2 — THE NAMEPLATE SAYS A RUNE IS WAITING (ruled) ═══════════════
	#
	# **THE COUNT OF RUNES THIS HERO HOLDS AND DOES NOT WEAR**, on his nameplate, so
	# a rune earned from a fight is visible on the map against the hero whose it is.
	# **It is read off his holding at every draw (`Run.held_count`), never set by an
	# event and never cleared by opening a menu**: it clears when nothing is waiting,
	# because a count that lies is worse than none. It is its own button, which opens
	# the panel where he equips them (`_open_rune_panel`); the card's press still
	# opens the sheet everywhere else. It sits between the name and the upgrades
	# badge, and the name gives up the room it takes only while it is shown.
	var waiting: int = Run.held_count(member)
	if waiting > 0:
		name_lbl.size = Vector2(CARD_W - 110 - NAMEPLATE_MARK_W, CARD_NAME_H)
		var mark := Button.new()
		mark.add_theme_font_size_override("font_size", 13)
		mark.text = "✦ %d" % waiting
		mark.flat = true
		mark.position = at + Vector2(CARD_W - 52 - NAMEPLATE_MARK_W, 4)
		mark.custom_minimum_size = Vector2(NAMEPLATE_MARK_W, 22)
		mark.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
		mark.tooltip_text = "%d rune%s held, not worn. Click to equip\n%s from the %s's rune panel." % [
			waiting, "" if waiting == 1 else "s", "it" if waiting == 1 else "them",
			Run.nameplate(member)]
		mark.set_meta("held_marker", waiting)
		mark.pressed.connect(Music.click)
		mark.pressed.connect(_open_rune_panel.bind(idx))
		add_child(mark)
	# BATCH IH §6 — A NAME LONGER THAN ITS BOX TAKES A SIZE DOWN (font 12, a 17-px line, inside the 20),
	# so it is read whole rather than cut: *Warrior — Unawakened* beside a ✦ marker is 160 px at 14.
	if name_lbl.get_theme_font("font").get_string_size(name_lbl.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x \
			> name_lbl.size.x:
		name_lbl.add_theme_font_size_override("font_size", 12)

	# HP bar with numbers, then the resource bar under it.
	var hp: int = int(member["hp"])
	var max_hp: int = maxi(int(member["max_hp"]), 1)
	_bar(at + Vector2(58, CARD_HP_Y), CARD_W - 66, CARD_HP_BAR_H,
		float(hp) / float(max_hp),
		Color(0.75, 0.25, 0.28) if hp > 0 else Color(0.35, 0.2, 0.22),
		"%d / %d" % [hp, max_hp], 11)
	var cfg := Classes.hero_config(key)
	var res_name := String(cfg.get("resource_name", "Mana"))
	if res_name == "Mana":
		_bar(at + Vector2(58, CARD_RES_Y), CARD_W - 66, CARD_RES_BAR_H,
			float(member["mana"]) / float(maxi(int(member["max_mana"]), 1)),
			Color(0.3, 0.45, 0.85), "%s %d" % [res_name, int(member["mana"])], 8)
	else:
		# Rage and its kin build in combat and carry nothing between fights;
		# an empty bar every time would be a lie about the resource.
		var res_lbl := Label.new()
		res_lbl.text = "%s — builds in combat" % res_name
		res_lbl.add_theme_font_size_override("font_size", 10)
		res_lbl.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
		res_lbl.position = at + Vector2(58, CARD_RES_Y - 1)
		res_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(res_lbl)

	# Three rune slots, filled or empty (flat 3 from run start). Each is its
	# own button: clicking one opens this hero's pouch.
	var runes: Array = member.get("runes", [])
	var worn: Array = runes.filter(func(r): return r.get("equipped", false))
	# BATCH GX — the same door the pouch and the sheet ask.
	var sitting_runes: Array = Run.sitting_out_rune_names(member)
	for sl in Run.rune_slots():
		var rune: Dictionary = worn[sl] if sl < worn.size() else {}
		var slot_btn := Button.new()
		slot_btn.position = at + Vector2(8 + sl * 96, 62)
		slot_btn.custom_minimum_size = Vector2(92, 26)
		slot_btn.add_theme_font_size_override("font_size", 10)
		if rune.is_empty():
			slot_btn.text = "— empty —"
			# BATCH HR §1 — an unworn rune is held on the hero again (HK put it in
			# the bag), so the count is his own ordinary runes he does not wear.
			var wearable_n := 0
			for rr in Run.rune_rows(member):
				if not bool(rr["worn"]):
					wearable_n += 1
			slot_btn.tooltip_text = "An empty rune slot. Click to equip one\nof the runes he holds (%d)." % wearable_n
			slot_btn.add_theme_color_override("font_color", Color(0.45, 0.43, 0.48))
		else:
			slot_btn.text = String(rune["name"])
			slot_btn.tooltip_text = "%s\n%s\n\nClick to manage %s's runes." % [
				rune["name"], Runes.shown_desc(rune), key.capitalize()]
			slot_btn.add_theme_color_override("font_color",
				Runes.RUNE_TINT)  # HE §4 — no scope band; one tint
			# BATCH GX — A FILLED SLOT THAT PAYS NOTHING SAYS SO ON THE MAP
			# ITSELF, which is the only surface the player reads without
			# opening anything. **THE MARKER IS IN THE
			# TEXT, NOT ONLY IN THE COLOUR** — a colour is not a tell, and this
			# button is where the eye lands before a fight. **IT IS A MARKER
			# RATHER THAN A WORD BECAUSE NO WORD FITS, MEASURED**: the widest
			# gated name is 74 px of the 92-px slot at font 10, which leaves
			# room for one glyph and for none of `(out)` 99, `— out` 105 or
			# `— sits out` 124. The 92 is a MINIMUM, so a longer face grows
			# the button, and the three slots are pitched 96 apart — an
			# overflowing one would lie over its neighbour rather than clip.
			# `check_gx` §2 re-measures all four forms and the drawn button.
			# **The sentence itself is the pouch's and the kit preview's own,
			# in the tooltip, which has the room.**
			if sitting_runes.has(String(rune["name"])):
				slot_btn.text = "○ %s" % String(rune["name"])
				slot_btn.tooltip_text = "%s\n\n%s\n\nClick to manage %s's runes." % [
					rune["name"],
					Run.rune_sits_out_note(String(rune.get("id", "")), Run.held_engines(member),
						Run.worn_rune_ids(member)),
					key.capitalize()]
				slot_btn.add_theme_color_override("font_color", Color(0.85, 0.7, 0.45))
		slot_btn.pressed.connect(Music.click)
		slot_btn.pressed.connect(_open_rune_panel.bind(idx))
		add_child(slot_btn)

	# BATCH EG §2 — THE SWAP NEEDS A PLACE TO HAPPEN, AND THIS IS IT.
	# It is on the MAP CARD and not on the party sheet for the reason the runes
	# are: one writer — a loadout with two writers is the same defect as a rune
	# with two. Since IH §3 the sheet shows neither the loadout nor the runes: the
	# panel this button opens shows and moves the cards, and the Runes button
	# beside it opens the panel that shows and moves the runes.
	#
	# It sits at the card's bottom-right, on the CHOOSE row (ID §4; it sat after the rune slots
	# until then and ran past the card). It reads the ladder rather than a number, so it cannot
	# drift from `ABILITY_SLOTS_BY_BOSS`.
	var has_kit := spec != "" or bool(member.get("awakened", false))
	# BATCH IH §2 — THE ROW HOLDS KIT AND RUNES AT ITS RIGHT, CHOOSE AT ITS LEFT; the core-rune line
	# that stood where CHOOSE does when nothing is owed is gone (the designer's).
	var row_w: float = CARD_W - 16 - ((KIT_BTN_W + ROW_BTN_GAP + RUNES_BTN_W + ROW_BTN_GAP) if has_kit else 0.0)
	if has_kit:
		var load_btn := Button.new()
		load_btn.position = at + Vector2(CARD_W - 8 - KIT_BTN_W, 114)
		load_btn.custom_minimum_size = Vector2(KIT_BTN_W, 30)
		load_btn.add_theme_font_size_override("font_size", 10)
		var held_n: int = Run.earned_ability_names(member).size()
		var bench_n: int = Run.benched_ability_names(member).size()
		load_btn.text = "Kit %d/%d" % [Run.ability_slots_used(member),
			Run.ability_slot_cap()]
		load_btn.tooltip_text = "%s carries %d of %d ability slots and holds %d earned card%s (%d benched).\nClick to swap them — benching costs nothing and a benched card is kept." % [
			key.capitalize(), Run.ability_slots_used(member), Run.ability_slot_cap(),
			held_n, "" if held_n == 1 else "s", bench_n]
		load_btn.add_theme_color_override("font_color",
			Color(0.95, 0.85, 0.4) if bench_n > 0 else Color(0.62, 0.6, 0.57))
		load_btn.pressed.connect(Music.click)
		load_btn.pressed.connect(_open_loadout_panel.bind(idx))
		add_child(load_btn)
		_runes_button(idx, member, at)

	# Batch AQ §5C: the ability-upgrade count, sitting alongside the rune slots
	# — runes already get exactly this treatment here and upgrades got nothing,
	# which is the asymmetry worth closing. A full run awards three to every
	# hero (and BK's blacksmith sells more) and before AQ they were discoverable
	# only by hovering an ability button mid-fight. IT DOES NOT TAKE A CLICK: it
	# is a child of the card button with MOUSE_FILTER_PASS, so it carries its
	# own tooltip while the press falls through to the card.
	var ups: Array = member.get("upgrades", [])
	if not ups.is_empty():
		var up_lines := PackedStringArray()
		for up in ups:
			up_lines.append("%s — %s" % [String(up.get("ability", "")),
				Run.upgrade_name(String(up.get("id", "")))])
		var up_badge := Label.new()
		# BATCH IC §3 — ◆ MEANS A DECISION WAITS (the designer's, at IC §0.4), so a HOLDING
		# takes another mark: ↑, which nothing else in the game draws. The word does not fit
		# here, measured: this corner is 40 px at font 12 and "3 upgrades" is 65 (`check_ic`
		# §3 re-measures it); the tooltip below names every one.
		up_badge.text = "↑%d" % ups.size()
		up_badge.add_theme_font_size_override("font_size", 12)
		up_badge.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
		up_badge.tooltip_text = "Ability upgrades\n%s" % "\n".join(up_lines)
		up_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		up_badge.mouse_filter = Control.MOUSE_FILTER_PASS
		open.add_child(up_badge)
		up_badge.position = Vector2(CARD_W - 48, 4)
		up_badge.size = Vector2(40, 18)

	# The badges: any owed pick, stated on the card rather than behind a
	# click. BATCH BM removed the unspent-points badge with the purse.
	var badges := PackedStringArray()
	if owed_abs > 0:
		badges.append("◆ %d ability" % owed_abs)
	if owed_draft > 0:
		badges.append("◆ %d draft" % owed_draft)
	if owed_ups > 0:
		badges.append("◆ %d upgrade" % owed_ups)
	if owed_runes > 0:
		badges.append("◆ %d rune" % owed_runes)
	if not badges.is_empty():
		var badge := Label.new()
		badge.text = "  ".join(badges)
		badge.add_theme_font_size_override("font_size", 12)
		badge.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(badge)
		badge.position = at + Vector2(8, 92)
		badge.size = Vector2(CARD_W - 16, 18)

	# An owed pick opens the hero's own screen (ID §1: every kind is a section of it). It
	# stays ON THE CARD in the sense that matters — the player never has to know which
	# screen to visit — but the three choices need room to say what they are.
	if owed_abs > 0 or owed_draft > 0 or owed_ups > 0 or owed_runes > 0:
		var pick_btn := Button.new()
		pick_btn.text = "CHOOSE — %s" % ("ability" if owed_abs > 0
			else ("draft" if owed_draft > 0
			else ("upgrade" if owed_ups > 0 else "rune")))
		pick_btn.position = at + Vector2(8, 114)
		pick_btn.custom_minimum_size = Vector2(row_w, 30)
		pick_btn.add_theme_font_size_override("font_size", 12)
		pick_btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
		pick_btn.pressed.connect(Music.click)
		pick_btn.pressed.connect(_open_hero_draft.bind(idx))
		add_child(pick_btn)
	# BATCH IH §2 — THE CORE-RUNE LINE STOOD HERE, NAMING HIS CORE RUNES AND POINTING AT THE SHEET,
	# AND IT IS GONE WHOLE, the list and the hint both (the designer's). His core runes are counted
	# on the Runes button beside Kit, and named on the panel it opens; a core rune that sits out
	# marks that button (HC §5's tell, which this line carried).


# ══ BATCH IH §2 — THE RUNES BUTTON, BESIDE KIT ═══════════════════════════════════════════════
#
# **`Runes n/6`, mirroring `Kit n/m`**: n the runes he wears — his slotted core runes and his worn
# ordinary ones — and 6 the two slot counts the panel heads (CORE and WORN). The panel tells the two
# apart; the button does not have to. It is the way into his rune panel that is always there; the
# ✦ marker on his nameplate stays the glance that says something waits, and each rune slot above
# still opens the same panel. **HC §5's tell rides it now**: a slotted core rune that sits out marks
# the face (○), turns it amber and puts the sentence on its hover — the map's one place a core rune
# that pays nothing is said without opening anything, which the core-rune line was until IH.
# `runes_button` meta: `check_gx` §3 reads every other `_open_rune_panel` button as a rune slot.
func _runes_button(idx: int, member: Dictionary, at: Vector2) -> Button:
	var worn: int = Run.engines_worn(member) + Run.runes_worn(member)
	var slots: int = Run.ENGINE_SLOTS + Run.rune_slots()
	var held: Array = Runes.held_engines(member)
	var sits: Array = Run.sitting_out_rune_names(member)
	var note := ""
	for er in member.get("engines", []):
		var erd: Dictionary = er
		if bool(erd.get("equipped", false)) and sits.has(String(erd.get("name", ""))):
			note = Run.rune_sits_out_note(String(erd.get("id", "")), held)
			break
	var b := Button.new()
	# THE FONT BEFORE ANY SIZE: a size set first is clamped to the face at the default font and kept
	# (IA's label trap, met here at IH and caught by `check_id` §4c — it ran 85 px, under Kit).
	b.add_theme_font_size_override("font_size", 10)
	b.text = ("○ " if note != "" else "") + "Runes %d/%d" % [worn, slots]
	b.position = at + Vector2(CARD_W - 8 - KIT_BTN_W - ROW_BTN_GAP - RUNES_BTN_W, 114)
	b.custom_minimum_size = Vector2(RUNES_BTN_W, 30)
	b.tooltip_text = "%s wears %d of %d core runes and %d of %d runes; %d held, not worn.\nClick to manage them." % [
		Run.nameplate(member), Run.engines_worn(member), Run.ENGINE_SLOTS, Run.runes_worn(member),
		Run.rune_slots(), Run.held_count(member)]
	b.add_theme_color_override("font_color", Color(0.62, 0.6, 0.57))
	if note != "":
		b.tooltip_text += "\n\n%s" % note
		b.add_theme_color_override("font_color", Color(0.85, 0.7, 0.45))
	b.set_meta("runes_button", idx)
	b.pressed.connect(Music.click)
	b.pressed.connect(_open_rune_panel.bind(idx))
	add_child(b)
	return b


func _bar(at: Vector2, w: float, h: float, frac: float, fill: Color,
		text: String, font_px: int) -> void:
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
	# BATCH IH §6 — THE VALUE's FONT IS NAMED BY THE CALLER, whose bar is as tall as its line (it was
	# `h - 4`: a font-11 line of 16 px in a 15-px bar), and the label is parented before it is sized.
	lbl.add_theme_font_size_override("font_size", font_px)
	lbl.add_theme_color_override("font_color", Color(0.95, 0.93, 0.9))
	lbl.add_theme_constant_override("outline_size", 3)
	lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(lbl)
	lbl.position = at
	lbl.size = Vector2(w, h)


# ---------- the owed-pick overlay: RETIRED AT BATCH ID §1 ----------
#
# **ONE SCREEN WHERE THERE WERE TWO (IC §0.1, the designer's).** From BK to IC the zone boss's
# ability and the mini-boss's upgrade opened on an overlay of their own here — choose one of
# three, *Not yet* — while the draft and the rune cache opened on the hero's own screen (IB §2).
# Two screens doing one job, chosen by which enemy fell, is the rot; **both picks are sections of
# the hero's screen now** (`_open_hero_draft`): the boss's ability an offer in ABILITIES beside
# the draft, the upgrade its own UPGRADES section. Its census was those two picks and nothing
# else (IC premise 4, re-read at ID before the deletion). What it used that stays: the bench step
# (`_open_drop_overlay`), its choice buttons (`_pick_button`) and the two commit doors
# (`_pick_ability`, `_pick_upgrade`), which the screen's one Confirm calls.

# One choice: its name on the button, its full text under it. **Since ID §1 the bench step is
# its one caller** — the pick overlay that drew the boss's and the upgrade's choices with it is
# retired.
#
# BATCH IB §6a — **THE GAME MARKS ITS CHOICE BUTTONS** (`choice`: the handler's name
# and its bound arguments). The press goes through a closure that frees the overlay,
# so the handler is not on the button's own connection and a walker cannot find it
# by binding; HZ's one new button on the old pick overlay stopped four roads that found
# choices by elimination. A walker asks for the buttons this meta marks, never for
# the ones whose words are not "Back".
func _pick_button(box: VBoxContainer, label: String, desc: String,
		tint: Color, action: Callable, overlay: Control) -> void:
	var b := Button.new()
	b.text = label
	b.set_meta("choice", [action.get_method(), action.get_bound_arguments()])
	b.custom_minimum_size = Vector2(600, 32)
	b.add_theme_font_size_override("font_size", 14)
	b.add_theme_color_override("font_color", tint)
	b.pressed.connect(Music.click)
	b.pressed.connect(func():
		overlay.queue_free()
		action.call())
	box.add_child(b)
	if desc == "":
		return
	var text := Label.new()
	text.text = desc
	text.add_theme_font_size_override("font_size", 12)
	text.add_theme_color_override("font_color", Color(0.68, 0.65, 0.62))
	text.custom_minimum_size = Vector2(600, 0)
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(text)


# THE BENCH STEP (Batch BO §2, renamed at EG §2). At the cap an offer becomes
# take-one-and-bench-one: the player picks the incoming ability and THEN names
# which one it replaces. Only EARNED abilities are listed — a protected one can
# never appear here, which is what makes the cap unable to break a passive.
#
# **BATCH EG §2 — IT LISTS THE LOADOUT, NOT THE POOL, AND THAT IS THE ONE LINE
# THE SPLIT MOVED HERE.** `earned_ability_names` is the POOL now and it holds
# benched cards, which are not carried and cannot be benched again — listing
# them would put a button on the screen that `unequip_earned_ability` correctly
# refuses and that therefore does nothing. `equipped_ability_names` is a subset
# of the pool by construction (both doors check it), so this is still "only
# earned abilities" and is now also "only ones he is actually carrying".
#
# BATCH BX §2 — ONE STEP, TWO CONSUMERS. `on_drop` is what the party-wide
# draft screen passes: that screen resolves as one confirmation, so it STAGES
# the replacement instead of committing it, and the difference between the two
# consumers is exactly one Callable rather than a second list of what may be
# benched.
#
# **BATCH ID §1 — ONE CONSUMER, THE HERO'S SCREEN, AND TWO OFFERS ON IT.** The boss pick that
# committed here retired with the pick overlay, so every bench STAGES (`on_drop`), and `kind`
# says whose bench it is — `"draft"` or `"ability"`, the boss's. **A card one offer benches is
# not offered to the other** (`exclude`): one Confirm commits both, and a card benched once
# cannot be benched again.
func _open_drop_overlay(idx: int, kind: String, incoming: String,
		on_drop := Callable(), exclude: Array = []) -> void:
	if not on_drop.is_valid():
		return
	var member: Dictionary = Run.party[idx]
	var droppable := Run.equipped_ability_names(member).filter(
		func(n): return not exclude.has(String(n)))
	if droppable.is_empty():
		# Nothing carried to bench and the kit still reads full — the protected
		# core alone cannot exceed the cap, so this is unreachable today. It
		# refuses rather than silently exceeding the cap.
		_toast("%s has nothing that can be benched." % String(member["key"]).capitalize())
		return
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	# ABOVE the party-wide draft screen (z 62), which is what it is opened over
	# when a column is at the cap. Below it the modal would render behind the
	# columns and still take clicks.
	overlay.z_index = 64
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.82)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(320, 180)
	panel.custom_minimum_size = Vector2(640, 300)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var title := Label.new()
	title.text = "%s replaces which ability?" % incoming
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.95, 0.6, 0.45))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var note := Label.new()
	note.text = "The kit is full at %d slots. Protected abilities cannot be benched,\nand a benched one is KEPT — swap it back from the hero card." % Run.ability_slot_cap()
	note.add_theme_font_size_override("font_size", 12)
	note.add_theme_color_override("font_color", Color(0.6, 0.58, 0.55))
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(note)

	var spec := String(member.get("spec", ""))
	for name in droppable:
		var ab: Ability = Classes.spec_pool_ability(spec, String(name))
		_pick_button(box, "Bench %s" % String(name),
			Classes.resolve_values(ab.description) if ab != null else "",
			Color(0.9, 0.7, 0.6), on_drop.bind(idx, String(name)), overlay)

	# Over the hero's screen, always (ID §1): Back returns to it, the card still staged.
	var back := Button.new()
	back.text = "Back"
	back.custom_minimum_size = Vector2(200, 30)
	back.pressed.connect(Music.click)
	back.pressed.connect(overlay.queue_free)
	box.add_child(back)


# **BATCH ID §1 — THE ZONE BOSS'S ABILITY, COMMITTED BY THE HERO'S CONFIRM.** It took its
# pick and redrew the map from the pick overlay; the overlay is retired, so this is the door the
# screen's one Confirm calls for the boss's offer, beside `Run.take_draft_ability` for the draft.
# It returns "" when the card is taken, or why it was refused, as that door does. At the cap it
# benches the card the screen staged and refuses without one — it no longer opens the bench step
# itself, because the screen stages the bench before the Confirm can be pressed.
func _pick_ability(idx: int, pool_name: String, bench_name := "") -> String:
	var member: Dictionary = Run.party[idx]
	# BATCH FE §2 — RE-ASKED HERE TOO, AND THE OLD GUARD IS WHY.
	# This used to refuse `pool_name in member["bm_abilities"]` and return,
	# which popped nothing and decremented nothing — so a name the hero had
	# taken since the triple was rolled stayed on screen as a button that did
	# NOTHING when pressed (604 of them over 240 driven runs), and where the
	# boss pool was smaller than the number of deferred picks EVERY button was
	# dead and the pick could never be answered at all (the Inquisitor's pool
	# is two: 20 of 20 driven runs stranded the third pick for good).
	# `ability_choice` is idempotent — it writes its repair back — so calling it
	# here re-reads the array the buttons were built from rather than repairing
	# a second time, and a triple that repaired to NOTHING is refused here
	# rather than being taken.
	var live: Array = Run.ability_choice(member)
	if int(member.get("bm_picks_owed", 0)) < 1:
		return "no pick is owed"
	if live.is_empty() or not live.has(pool_name):
		return "that card is not in the offer"
	# BATCH BO §2: THE CAP BINDS THE BOSS PICK TOO. §3 leaves the boss OFFER
	# unchanged — same source, same timing, same SPEC_POOLS draw — but the
	# cap is a rule about a KIT, not about one pool, and a boss pick that could
	# walk past it would not be a cap at all (a Beastmaster's five spec-pool
	# entries alone reach eight).
	#
	# BATCH EG §2: the step it opens BENCHES rather than drops. The named
	# ability stays in the pool and is swappable back from the hero card, and
	# the no-return ledger is not written — `Run.unequip_earned_ability` is the
	# one door, and it refuses a protected name by the same absence
	# `drop_earned_ability` refused it by.
	#
	# BATCH ID §1 — the bench is named on the hero's screen before its Confirm, so at the cap
	# a take with none is refused here, in `take_draft_ability`'s words; below the cap a name
	# handed in is not benched — nothing needs the room.
	if Run.ability_slots_full(member):
		if bench_name == "":
			return "the kit is full — name an ability to bench"
		if not Run.unequip_earned_ability(member, bench_name):
			return "%s cannot be benched" % bench_name
	# Spend the triple this pick came from: the other two are gone, not
	# banked for the next award.
	var queue: Array = member.get("bm_candidates", [])
	if not queue.is_empty():
		queue.pop_front()
		member["bm_candidates"] = queue
	Run.hold_ability(member, pool_name, true)
	member["bm_picks_owed"] = int(member.get("bm_picks_owed", 0)) - 1
	return ""


# ---------- BATCH IB §2: EACH HERO DRAFTS ALONE, ON HIS OWN SCREEN ----------
#
# **ONE SCREEN A HERO, AND ON IT EVERY CHOICE OF ONE OF THREE HE IS OWED FROM A FIGHT:
# THE ABILITY THE DRAFT OFFERS AND THE RUNE THE CACHE HOLDS.** From BX to IA a draft
# was one party screen of four columns and a rune cache this file's pick overlay; the
# designer asked for each class to draft separately, runes and abilities together. The
# columns were already four picks — each hero his own offer, his own pool, his own
# no-return ledger, his own take at the confirm (`Run.take_draft_ability` per member) —
# so this is a LAYOUT and moves no reward: one hero's column on a screen of his own,
# beside his rune, and a Confirm a hero.
#
# **A SECTION WITH NOTHING OWED IS ABSENT, NOT EMPTY.** The elite pays a draft to every
# living hero and its cache to one of them, so one hero an elite carries both, and the
# others only the draft; a bargain's rune comes alone. **ONE CONFIRM COMMITS THE HERO'S
# WHOLE DECISION** — every section on the screen decided, as BX's screen waited on
# every column — and **LATER LEAVES BOTH OWED**, marked on his card.
#
# THE RULES ALL LIVE IN `run_state.gd` AND THIS SCREEN OWNS NONE OF THEM. The cap, the
# bench, the no-return ledger and the re-asked offers are `Run.take_draft_ability`,
# `Run.decline_draft`, `Run.draft_choice`, `Run.rune_choice` and `Run.hold_rune`,
# exactly as the screens before it used them — a second layout, never a second
# implementation.
#
# ══ BATCH ID §1 — AND EVERY PICK HE IS OWED IS A SECTION OF IT (IC §0.1 and ID §0.5, the
#    designer's) ════════════════════════════════════════════════════════════════════
#
# **THE ZONE BOSS'S ABILITY AND THE MINI-BOSS'S UPGRADE FOLDED IN, AND THE PICK OVERLAY
# RETIRED.** Four sections, each present only while its pick is owed, each answering the head
# of its own queue: **ABILITIES** — the draft's offer and the zone boss's, **two labelled offers
# in one section**, because a draft and a boss's card are one kind of decision (pick a card) and
# two sections would teach the player otherwise; **UPGRADES**, its own, because an upgrade
# changes a card he holds rather than adding one; **RUNES**, unchanged. One Confirm still
# commits the hero's whole decision.
#
# **ONE COLUMN AN OFFER, AND THE ABILITIES SECTION SPANS ITS OFFERS.** BX's column is the
# offer's renderer — the boss's cards draw through it exactly as the draft's do (tag line,
# description, computed block), the reason §0.5 gives for one section given for one renderer
# too — so the widest screen, a hero owed all four, is four columns, 1,220 px of 1,280, and
# each column's text scrolls in its own bounded scroller with Godot's bar, as BX's column always
# did (§1b measured three cards at 358–896 px against the 388-px viewport). **The Confirm and
# Later sit outside every scroller** (IB §2e; GT §1's rule).
#
# **ONE CONFIRM, TWO TAKES, ONE CAP.** The draft's card and the boss's can both be staged, so
# the cap is counted across them in the order the Confirm commits (`_bench_needed`): the draft
# first, then the boss's; and a card one offer benches is not offered to the other. **A section
# with nothing he can take now — a boss's offer every card of which waits on an engine — does
# not hold the Confirm**: it says why and stays owed, as the pick overlay's *Not yet* left it.

# BATCH HZ §1b — THE KIT PREVIEW (`scripts/kit_preview.gd`): read-only, over a draft, on the
# hero whose decision it is. Opened from the hero's draft screen, never by walking: the screen
# already knows its hero.
const KIT_PREVIEW := "res://scripts/kit_preview.gd"


# Added last and on top of whatever overlay is open; it frees only itself, so a staged
# draft is exactly as it was when the preview closes.
func _open_kit_preview(idx: int) -> Control:
	var kp: Control = load(KIT_PREVIEW).new()
	kp.setup(idx, false)
	add_child(kp)
	return kp


# The button the hero's screen carries, found by its meta.
func _kit_preview_button(idx: int, width: float) -> Button:
	var b := Button.new()
	b.text = "See the kit"
	b.custom_minimum_size = Vector2(width, 22)
	b.add_theme_font_size_override("font_size", 12)
	b.set_meta("kit_preview", idx)
	b.pressed.connect(Music.click)
	b.pressed.connect(_open_kit_preview.bind(idx))
	return b


const DRAFT_COL_W := 296.0
const DRAFT_COL_GAP := 12.0
const DRAFT_COL_Y := 92.0
# BATCH ID §1b — 548, where it was 540: the draft's offer with its bench step and Decline under
# the section's head and the slot ledger measures 544 tall (`check_id` §1b re-measures it), and a
# panel shorter than its content grows past what it declares. The Confirm is at y 652.
const DRAFT_COL_H := 548.0


# ══ BATCH IB §1 — WHAT A HERO CARRIES OUT OF A FIGHT OPENS ITSELF WHEN THE PARTY ARRIVES ══
#
# **THE DESIGNER'S WORDS: *any applicable draft screens should automatically appear
# after a battle or event ends and the player arrives at the node map.*** BX opened the
# draft so from the start; the zone boss's ability, the mini-boss's upgrade and the
# rune cache waited behind a card's CHOOSE button, which is what read as *difficult to
# determine*. **Every owed pick opens now, one after another, in the order it was earned**
# (`Run.pending_picks`), then the pouch's swap offers and the full holdings, as before.
#
# **THE THREE RULES THE FEATURE OBEYS, EACH A LINE BELOW:**
# - **AN UNMADE PICK, NEVER AN UNEQUIPPED HOLDING.** A rune held and not worn is a
#   standing choice, and HR's ✦ N says so at a glance; were it to open a screen, the
#   screen would open at every arrival for the rest of the run. `Run.pending_picks`
#   reads the four pick counters and nothing else.
# - **DISMISSING LOSES NOTHING, AND IT IS ONCE AN ARRIVAL.** Later leaves every pick on the
#   screen owed, marked on the card, answered from its CHOOSE; and nothing dismissed opens
#   again until the party arrives again — not when it comes back from the hero sheet
#   (`Run.map_reentry`), and not when another screen closes.
# - **IT NEVER COVERS A CHOICE ALREADY MADE.** It runs from `_ready`, after the map has
#   drawn and before any press can land, and every next step waits until no overlay is
#   open (`_modal_open`): a step onto a node changes the scene, and a scene that is gone
#   opens nothing.
var _arrival_queue: Array = []
var _arrival_live := false
# The overlays a step of the walk, or what it chains to, can put up; nothing opens over
# one. The framing card and the kit preview (90) and the debug pickers (95) count too.
const ARRIVAL_MODALS := [60, 62, 64, 70, 72, 74, 80, 90, 91, 95]


func _begin_arrival() -> void:
	if Run.sim_run:
		return
	_arrival_queue = Run.pending_picks()
	_arrival_live = true
	_arrival_next()


func _modal_open() -> bool:
	for c in get_children():
		if c is Control and not c.is_queued_for_deletion() \
				and ARRIVAL_MODALS.has((c as Control).z_index):
			return true
	return false


# The next pick still owed, on the one screen that answers every kind (ID §1: the boss's
# ability and the upgrade opened on the pick overlay until then); when none is left, the
# pouch's swap offers and the full holdings, as the screen has always chained them.
func _arrival_next() -> void:
	if not _arrival_live or _modal_open():
		return
	while not _arrival_queue.is_empty():
		var t: Dictionary = _arrival_queue.pop_front()
		var i := int(t["hero"])
		var kind := String(t["kind"])
		if i < 0 or i >= Run.party.size() or Run.pick_owed(Run.party[i], kind) <= 0:
			continue
		_open_hero_draft(i)
		return
	_arrival_live = false
	_check_item_offers()


# A screen closed without its picks answered: the rest of that hero's picks leave this
# arrival with it — every kind is on his one screen — so it does not come straight back.
func _arrival_dismissed(i: int) -> void:
	_arrival_queue = _arrival_queue.filter(func(t): return int(t["hero"]) != i)
	_arrival_next.call_deferred()


# ── THE HERO'S DRAFT SCREEN ──────────────────────────────────────────────────────
#
# What he has staged, by hero: `card`, `drop` and `declined` for the draft's offer in the
# ABILITIES section (BX's three), `bcard` and `bdrop` for the zone boss's offer beside it (ID
# §1: no decline — a zone-boss award always pays), `upgrade` for the UPGRADES section (the
# upgrade's id), `rune_set` and `rune` for the RUNES section (a rune's name, or "" to let an
# empty cache go). Nothing here has touched `Run` — `_confirm_hero_draft` is the only thing
# that does. A redraw keeps it; a close or a confirm clears his.
var _draft_stage: Dictionary = {}
var _draft_overlay: Control = null
var _hero_draft_for := -1


func _stage_of(idx: int) -> Dictionary:
	var st: Dictionary = _draft_stage.get(idx, {})
	for k in ["card", "drop", "rune", "bcard", "bdrop", "upgrade"]:
		if not st.has(k):
			st[k] = ""
	for k in ["declined", "rune_set", "bspent", "uspent"]:
		if not st.has(k):
			st[k] = false
	_draft_stage[idx] = st
	return st


# The DRAFT's offer is DECIDED when the player has either declined it or chosen a card AND,
# where the cap needs it, named what that card replaces. (BATCH EG §1: the cap is a ladder and
# this predicate never named the number — it asks the run; ID §1: `_bench_needed` asks it.)
func _draft_decided(idx: int) -> bool:
	var st := _stage_of(idx)
	if bool(st["declined"]):
		return true
	if String(st["card"]) == "":
		return false
	if _bench_needed(idx, "draft"):
		return String(st["drop"]) != ""
	return true


# The ZONE BOSS's offer is DECIDED when a card is chosen and, where the cap needs it, its
# bench named. It has no decline: a zone-boss award always pays (EA §1).
func _boss_decided(idx: int) -> bool:
	var st := _stage_of(idx)
	if bool(st["bspent"]):
		return true
	if String(st["bcard"]) == "":
		return false
	if _bench_needed(idx, "boss"):
		return String(st["bdrop"]) != ""
	return true


# The UPGRADES section is DECIDED when an upgrade is chosen; it has no decline (the pick overlay
# had none).
func _upgrade_decided(idx: int) -> bool:
	return String(_stage_of(idx)["upgrade"]) != "" or bool(_stage_of(idx)["uspent"])


# The RUNES section is DECIDED when a rune is chosen, or an empty cache is let go.
func _rune_decided(idx: int) -> bool:
	return bool(_stage_of(idx)["rune_set"])


# ══ BATCH ID §1 — ONE CONFIRM, TWO TAKES, ONE CAP ══════════════════════════════════════
#
# **Does the offer `which` ("draft" or "boss") need a bench named before the Confirm?** The two
# ability offers commit in the Confirm's order — the draft, then the boss's — so the free slots
# are counted the way the commits will spend them: the draft's card takes a free slot, and when
# none is free it benches one and the count does not move; the boss's card then finds what is
# left. A bench is asked of an offer only when its card has nowhere else to go, so a card staged
# with a slot free is never benched by accident.
func _bench_needed(idx: int, which: String) -> bool:
	var member: Dictionary = Run.party[idx]
	var st := _stage_of(idx)
	var free: int = Run.ability_slot_cap() - Run.ability_slots_used(member)
	var draft_takes: bool = Run.pick_owed(member, "draft") > 0 \
		and String(st["card"]) != "" and not bool(st["declined"])
	if which == "draft":
		return draft_takes and free <= 0
	if Run.pick_owed(member, "ability") <= 0 or String(st["bcard"]) == "":
		return false
	if draft_takes and free > 0:
		free -= 1
	return free <= 0


# The bench an offer will commit with: its staged one when the cap needs it, else none — a bench
# named for a card that no longer needs the room is not spent.
func _bench_for(idx: int, which: String) -> String:
	if not _bench_needed(idx, which):
		return ""
	return String(_stage_of(idx)["drop" if which == "draft" else "bdrop"])


# ══ BATCH IE §5 — A PICK THAT CANNOT BE ANSWERED AND CANNOT BECOME ANSWERABLE IS SPENT ══════════
#
# **◆ MAY NOT STAND ON A PICK THAT CANNOT BE ANSWERED AND CANNOT BECOME ANSWERABLE** (IE §0.3, the
# designer's). Measured at IE: an offer re-asked to nothing is written back empty, and every later
# re-ask returns the empty list unchanged — `Run.ability_choice` and `Run.upgrade_choice` top up only
# for a candidate they DROP — so neither the zone boss's nor the mini-boss's can refill, whatever
# the hero equips or drafts after. Such a pick is SPENT in FM §3's shape (*Let it go*), as the rune
# cache's is. **A boss's offer HELD BACK is not empty**: its cards are stored and an engine or the
# pet brings them back, so it stays owed and says so.
func _boss_spent(idx: int) -> bool:
	var member: Dictionary = Run.party[idx]
	return Run.pick_owed(member, "ability") > 0 and Run.ability_choice(member).is_empty() \
		and Run.ability_choice_withheld(member).is_empty()


func _upgrade_spent(idx: int) -> bool:
	var member: Dictionary = Run.party[idx]
	return Run.pick_owed(member, "upgrade") > 0 and Run.upgrade_choice(member).is_empty()


# The zone boss's pick, let go: it asks the same doors first (`_boss_spent`), so a spend can never
# eat a pick with a card left in it or one held back. Returns the toast's words.
const BOSS_SPENT_NOTE := "The zone boss's offer holds nothing this hero can take — every card it held is already this hero's, and none is left to draw.\nThe pick is spent rather than held: nothing can arrive to fill it."
const UPGRADE_SPENT_NOTE := "The mini-boss's offer holds nothing this hero can take — every upgrade it held is taken, and none left fits a card this hero holds.\nThe pick is spent rather than held: nothing can arrive to fill it."


func _spend_boss_pick(idx: int) -> String:
	if not _boss_spent(idx):
		return ""
	var member: Dictionary = Run.party[idx]
	var queue: Array = member.get("bm_candidates", [])
	if not queue.is_empty():
		queue.pop_front()
		member["bm_candidates"] = queue
	member["bm_picks_owed"] = int(member.get("bm_picks_owed", 0)) - 1
	return "%s: the zone boss had nothing left to offer. The pick is spent." % String(member["key"]).capitalize()


func _spend_upgrade_pick(idx: int) -> String:
	if not _upgrade_spent(idx):
		return ""
	var member: Dictionary = Run.party[idx]
	var queue: Array = member.get("up_candidates", [])
	if not queue.is_empty():
		queue.pop_front()
		member["up_candidates"] = queue
	member["up_picks_owed"] = int(member.get("up_picks_owed", 0)) - 1
	return "%s: the mini-boss had nothing left to offer. The pick is spent." % String(member["key"]).capitalize()


# **WHAT HE CAN ANSWER NOW.** A section is ANSWERABLE when the Confirm could commit it today: the
# draft always (Decline is always a button), the runes always (an empty cache is let go), the
# boss's offer and the upgrade while their live list holds a choice — **and since IE §5 while it
# holds nothing at all, which is let go** (`_boss_spent`, `_upgrade_spent`). A boss's offer
# whose every card is HELD BACK for an engine or the pet says so on the screen and stays owed;
# it does not hold the Confirm.
func _answerable(idx: int) -> Array:
	var member: Dictionary = Run.party[idx]
	var out: Array = []
	if Run.pick_owed(member, "draft") > 0:
		out.append("draft")
	if Run.pick_owed(member, "ability") > 0 and (not Run.ability_choice(member).is_empty() \
			or _boss_spent(idx)):
		out.append("boss")
	if Run.pick_owed(member, "upgrade") > 0 and (not Run.upgrade_choice(member).is_empty() \
			or _upgrade_spent(idx)):
		out.append("upgrade")
	if Run.pick_owed(member, "rune") > 0:
		out.append("rune")
	return out


# The answerable sections not yet decided — the count the Confirm says.
func _undecided(idx: int) -> int:
	var n := 0
	for which in _answerable(idx):
		var done: bool = {"draft": _draft_decided(idx), "boss": _boss_decided(idx),
			"upgrade": _upgrade_decided(idx), "rune": _rune_decided(idx)}[which]
		if not done:
			n += 1
	return n


# Every section he can answer decided — what the Confirm waits on.
func _hero_draft_decided(idx: int) -> bool:
	return _undecided(idx) == 0


# ══ BATCH ID §2 — THE WORDS ══════════════════════════════════════════════════════════════
#
# **THE TITLE NAMES WHAT IS ON THE SCREEN AND NEVER MISNAMES IT** (IC §0.2, the designer's):
# *THE DRAFT* whenever the draft is on it, and otherwise the picks it holds by their own nouns:
# *THE ABILITY* for the zone boss's (IE §0.4; it read THE DRAFT until IE), *THE UPGRADE*, *THE
# CACHE*, joined — *THE ABILITY, THE UPGRADE AND THE CACHE*. The Confirm says the same noun, so it
# cannot misname it either.
#
# **BATCH IE §0.4 — THE ABILITY, THE FOURTH NOUN (the designer's).** A zone boss's ability alone read
# THE DRAFT, and the screen's own section calls that pick *from the zone boss*. A draft on the screen
# still takes THE DRAFT — the more specific door, and the two share ABILITIES; otherwise the title
# names the kinds on the screen, joined the way the owed line joins them (`_joined`): *the title
# names the kinds on the screen, joined; the owed line enumerates them precisely.*
func _screen_name(idx: int) -> String:
	var member: Dictionary = Run.party[idx]
	if Run.pick_owed(member, "draft") > 0:
		return "THE DRAFT"
	var kinds := PackedStringArray()
	if Run.pick_owed(member, "ability") > 0:
		kinds.append("THE ABILITY")
	if Run.pick_owed(member, "upgrade") > 0:
		kinds.append("THE UPGRADE")
	if Run.pick_owed(member, "rune") > 0:
		kinds.append("THE CACHE")
	if kinds.is_empty():
		return "THE CACHE"
	return _joined(kinds, "AND")


# ID's joiner, one place: *A*, *A and B*, *A, B and C* — the title and the owed line both ask it.
static func _joined(items: PackedStringArray, and_word: String) -> String:
	if items.size() <= 1:
		return "" if items.is_empty() else items[0]
	return "%s %s %s" % [", ".join(items.slice(0, items.size() - 1)), and_word, items[items.size() - 1]]


# **THE OWED LINE IS WHAT HE IS OWED, AS ONE SENTENCE, THEN ONE CONSTANT TAIL.** Each pick its
# noun — *a new ability* (two when the draft and the boss are both owed), *an ability upgrade*,
# *a rune from the cache* — joined as a sentence joins a list, never as a list: *Two new
# abilities, an ability upgrade and a rune from the cache. Decide, then confirm.*
const OWED_TAIL := "Decide, then confirm."


func _owed_line(idx: int) -> String:
	var member: Dictionary = Run.party[idx]
	var items := PackedStringArray()
	var abilities := int(Run.pick_owed(member, "draft") > 0) + int(Run.pick_owed(member, "ability") > 0)
	if abilities == 2:
		items.append("two new abilities")
	elif abilities == 1:
		items.append("a new ability")
	if Run.pick_owed(member, "upgrade") > 0:
		items.append("an ability upgrade")
	if Run.pick_owed(member, "rune") > 0:
		items.append("a rune from the cache")
	var said := _joined(items, "and")
	if said == "":
		return OWED_TAIL
	return "%s. %s" % [said[0].to_upper() + said.substr(1), OWED_TAIL]


# **THE COUNTER COUNTS TO FOUR, IN WORDS, WITH NO PARENTHESIS** (ID §0.5): one screen holds at
# most one choice of each of the four kinds, so four is its ceiling by construction.
const COUNT_WORDS := ["One", "Two", "Three", "Four"]


func _confirm_text(idx: int) -> String:
	if _answerable(idx).is_empty():
		return "Nothing to choose yet"
	var n := _undecided(idx)
	if n == 0:
		return "Confirm %s" % _screen_name(idx).to_lower()
	return "%s choice%s still to make" % [COUNT_WORDS[clampi(n, 1, 4) - 1], "" if n == 1 else "s"]


func _open_hero_draft(idx: int) -> void:
	if idx < 0 or idx >= Run.party.size():
		return
	var member: Dictionary = Run.party[idx]
	var has_draft := Run.pick_owed(member, "draft") > 0
	var has_boss := Run.pick_owed(member, "ability") > 0
	var has_up := Run.pick_owed(member, "upgrade") > 0
	var has_rune := Run.pick_owed(member, "rune") > 0
	if _draft_overlay != null and is_instance_valid(_draft_overlay):
		_draft_overlay.queue_free()
	_draft_overlay = null
	if not (has_draft or has_boss or has_up or has_rune):
		_hero_draft_for = -1
		return
	_hero_draft_for = idx
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 62
	overlay.set_meta("hero_draft", idx)
	add_child(overlay)
	_draft_overlay = overlay
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.86)
	overlay.add_child(dim)

	var title := Label.new()
	title.text = "%s — %s" % [_screen_name(idx), Run.nameplate(member)]
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	title.position = Vector2(0, 16)
	title.size = Vector2(1280, 44)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay.add_child(title)
	var sub := Label.new()
	sub.text = _owed_line(idx)
	sub.add_theme_font_size_override("font_size", 13)
	sub.add_theme_color_override("font_color", Color(0.62, 0.6, 0.56))
	sub.position = Vector2(0, 62)
	sub.size = Vector2(1280, 18)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay.add_child(sub)
	# BATCH HZ §1b — what he already carries, beside the choice that adds to it. **IT OPENS
	# ON HIM**: the screen is his, so the preview's walk across the four is never needed.
	var kit := _kit_preview_button(idx, 180)
	kit.position = Vector2(1080, 24)
	overlay.add_child(kit)

	# ONE COLUMN AN OFFER, LEFT TO RIGHT IN THE ORDER THE CONFIRM COMMITS THEM: the ABILITIES
	# section's offers (the draft's, then the zone boss's), UPGRADES, RUNES — centred as a row.
	var offers: Array = []
	if has_draft:
		offers.append("draft")
	if has_boss:
		offers.append("boss")
	var cols: int = offers.size() + int(has_up) + int(has_rune)
	var span: float = cols * DRAFT_COL_W + (cols - 1) * DRAFT_COL_GAP
	var x: float = (1280.0 - span) * 0.5
	if not offers.is_empty():
		_abilities_section(overlay, idx, Vector2(x, DRAFT_COL_Y), offers)
		x += offers.size() * (DRAFT_COL_W + DRAFT_COL_GAP)
	if has_up:
		_upgrade_section(overlay, idx, Vector2(x, DRAFT_COL_Y))
		x += DRAFT_COL_W + DRAFT_COL_GAP
	if has_rune:
		_draft_rune_section(overlay, idx, Vector2(x, DRAFT_COL_Y))

	var ready_to := _answerable(idx).size() > 0 and _undecided(idx) == 0
	var confirm := Button.new()
	confirm.text = _confirm_text(idx)
	confirm.position = Vector2(490, 652)
	confirm.custom_minimum_size = Vector2(300, 44)
	confirm.add_theme_font_size_override("font_size", 17)
	confirm.disabled = not ready_to
	if ready_to:
		confirm.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
	confirm.pressed.connect(Music.click)
	confirm.pressed.connect(_confirm_hero_draft)
	overlay.add_child(confirm)

	# NOTHING IS COMMITTED UNTIL CONFIRM, so leaving is safe and every pick stays owed —
	# the card's badge and its CHOOSE button reopen this screen.
	var later := Button.new()
	later.text = "Later"
	later.position = Vector2(1100, 652)
	later.custom_minimum_size = Vector2(140, 44)
	later.add_theme_font_size_override("font_size", 14)
	later.pressed.connect(Music.click)
	later.pressed.connect(_close_hero_draft)
	overlay.add_child(later)


# Where the offer `which` came from, in the words its section labels it with (ID §1): the zone
# boss's always the zone boss; a draft the elite's spoils or an event's verb, by the record
# `Run.award_draft_pick` keeps — and, where there is none (a pick from before ID), both doors.
func _offer_source(idx: int, which: String) -> String:
	if which == "boss":
		return "from the zone boss"
	var src := Run.pick_source(Run.party[idx], "draft")
	if src == "elite":
		return "from the elite"
	if src == "event":
		return "from an event"
	return "from an elite or an event"


# ══ THE ABILITIES SECTION — BX's column for each offer, one head over them all ═══════════════
#
# **ONE SECTION, ONE OR TWO OFFERS (ID §0.5).** The head and the slot ledger are the section's,
# because the cap is one cap whichever offer fills it; under them each offer is BX's column, its
# line saying where it came from, its cards, what it holds back and why, its bench step at the
# cap, and — the draft's alone — Decline. The panel spans the offers' columns at the screen's one
# pitch, so a hero owed both reads one section two columns wide.
func _abilities_section(overlay: Control, idx: int, at: Vector2, offers: Array) -> void:
	var member: Dictionary = Run.party[idx]
	var n := offers.size()
	var w: float = n * DRAFT_COL_W + (n - 1) * DRAFT_COL_GAP
	var panel := PanelContainer.new()
	panel.position = at
	panel.custom_minimum_size = Vector2(w, DRAFT_COL_H)
	panel.size = Vector2(w, DRAFT_COL_H)
	panel.set_meta("section", "abilities")
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)

	var head := Label.new()
	head.text = "ABILITIES"
	head.add_theme_font_override("font", NAME_FONT)
	head.add_theme_font_size_override("font_size", 22)
	head.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	head.custom_minimum_size = Vector2(w - 16, 26)
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(head)
	# The slot ledger, stated before the choice rather than discovered by it (BO §2's rule,
	# the section's now): one cap, whichever offer fills it, and what taking will cost.
	var used := Run.ability_slots_used(member)
	var free: int = Run.ability_slot_cap() - used
	var cost := ""
	if free <= 0:
		cost = "  —  taking one means benching one"
	elif n == 2 and free == 1:
		cost = "  —  taking both means benching one"
	var slots := Label.new()
	slots.text = "Ability slots %d of %d%s" % [used, Run.ability_slot_cap(), cost]
	slots.add_theme_font_size_override("font_size", 11)
	slots.add_theme_color_override("font_color",
		Color(0.95, 0.6, 0.45) if cost != "" else Color(0.6, 0.58, 0.55))
	slots.custom_minimum_size = Vector2(w - 16, 14)
	slots.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(slots)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", int(DRAFT_COL_GAP + 16))
	box.add_child(row)
	for which in offers:
		_ability_offer(row, idx, String(which))


# ONE OFFER OF THE ABILITIES SECTION — BX's column: the draft's (`which` "draft") or the zone
# boss's ("boss"), each through its own run door, each staged under its own keys.
func _ability_offer(row: HBoxContainer, idx: int, which: String) -> void:
	var member: Dictionary = Run.party[idx]
	var st := _stage_of(idx)
	var is_draft := which == "draft"
	var staged := String(st["card" if is_draft else "bcard"])
	var staged_drop := String(st["drop" if is_draft else "bdrop"])
	var declined := is_draft and bool(st["declined"])
	var needs_bench := staged != "" and not declined and _bench_needed(idx, which)
	# A card the OTHER offer has staged is drawn here but cannot be pressed: one Confirm takes
	# both, and a card is taken once.
	var other := ""
	if is_draft:
		other = String(st["bcard"]) if Run.pick_owed(member, "ability") > 0 else ""
	elif Run.pick_owed(member, "draft") > 0 and not bool(st["declined"]):
		other = String(st["card"])
	var other_from := _offer_source(idx, "boss" if is_draft else "draft")

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	col.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 0)
	col.set_meta("offer", which)
	row.add_child(col)
	var from := Label.new()
	from.text = _offer_source(idx, which)
	from.add_theme_font_size_override("font_size", 12)
	from.add_theme_color_override("font_color", Color(0.78, 0.7, 0.5))
	from.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 16)
	from.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(from)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 388)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)
	var cards := VBoxContainer.new()
	cards.add_theme_constant_override("separation", 2)
	cards.custom_minimum_size = Vector2(DRAFT_COL_W - 34, 0)
	scroll.add_child(cards)

	# The class resource `ab.cost` is charged in, for the block below. Read off
	# `hero_config` rather than carried on the member, which holds no resource
	# NAME (only `mana`/`max_mana` numbers) — the hero card above does the same.
	var res_name := String(Classes.hero_config(String(member["key"])).get(
		"resource_name", "Mana"))
	# **BATCH HE §3 — THROUGH `Run.draft_choice`, NOT OFF THE MEMBER.** The triple
	# was rolled at the elite and rides the save; the pouch can unslot an engine
	# before it is answered, and `take_draft_ability` re-asks the card gate at the
	# pick. A card it would refuse is NOT drawn as a button here — FE's 604 dead
	# buttons were a correct refusal that left the screen lying — and the column
	# says what it holds back and which rune brings it back, below the cards.
	#
	# **BATCH ID §1 — AND THE ZONE BOSS'S THROUGH `Run.ability_choice`** (FE §2's door, the pick
	# overlay's until ID), which re-asks what he owns and what the card gate withholds.
	var queue: Array = member.get("draft_candidates" if is_draft else "bm_candidates", [])
	var stored: Array = queue[0] if not queue.is_empty() else []
	var offer: Array = Run.draft_choice(member) if is_draft else Run.ability_choice(member)
	for card in offer:
		var card_name := String(card)
		_offer_card(cards, card_name, card_name == staged and not declined,
			(_stage_draft if is_draft else _stage_boss).bind(idx, card_name), res_name,
			"chosen %s" % other_from if card_name == other else "")

	# BATCH HE §3 — WHAT THE COLUMN HOLDS BACK, SAID RATHER THAN HIDDEN, in the
	# rune cache's and the zone boss's words: an engine to EQUIP, or the pet's
	# dismisser to UNEQUIP. Held, not spent: the pick stays owed, the card stays
	# stored, and `Later` leaves the screen so the pouch can put the engine back.
	# **DECLINING STILL REFUSES THE WHOLE STORED OFFER** — the held-back cards with
	# the rest, on the no-return rule — and the all-held line says so, because it
	# is the one moment a player might decline to clear a column he cannot answer.
	#
	# **BATCH ID §1 — THE ZONE BOSS'S IN THE PICK OVERLAY'S WORDS** (HE §3's split, moved here
	# with the offer): an engine to EQUIP, the pet's dismisser to UNEQUIP, each with its return
	# clause when nothing is left to take.
	var held_back: Array = Run.draft_choice_withheld(member) if is_draft \
		else Run.ability_choice_withheld(member)
	var slots_now: Array = Run.held_engines(member)
	var hb_owned: Array = held_back.filter(func(n):
		return is_draft and Run.owned_ability_names(member).has(String(n)))
	var hb_eng: Array = held_back.filter(func(n):
		var e := Classes.engine_read(String(n))
		return not hb_owned.has(n) and e != "" and not slots_now.has(e))
	var hb_pet: Array = held_back.filter(func(n):
		return not hb_owned.has(n) and not hb_eng.has(n))
	var hb_lines := PackedStringArray()
	if not hb_eng.is_empty():
		hb_lines.append("The offer holds %d more that wait%s on %s being equipped.%s" % [
			hb_eng.size(), "s" if hb_eng.size() == 1 else "",
			Runes.cards_wait_on(hb_eng),
			"\nEquip it and they return." if not is_draft and offer.is_empty() else ""])
	if not hb_pet.is_empty():
		hb_lines.append("The offer holds %d more that need%s a companion, which the %s dismisses.%s" % [
			hb_pet.size(), "s" if hb_pet.size() == 1 else "",
			Runes.dismisser_name(slots_now),
			"\nUnequip it and they return." if not is_draft and offer.is_empty() else ""])
	if not hb_owned.is_empty():
		hb_lines.append("The offer holds %d this hero already knows." % hb_owned.size())
	if is_draft and offer.is_empty() and not held_back.is_empty():
		hb_lines.append("Nothing in this offer can be taken now. Later keeps the pick owed; declining refuses the whole offer."
			if hb_owned.size() < held_back.size()
			else "Nothing in this offer is new to this hero. Declining clears the pick.")
	if not hb_lines.is_empty():
		var hb := Label.new()
		hb.text = "\n".join(hb_lines)
		hb.add_theme_font_size_override("font_size", 11)
		hb.add_theme_color_override("font_color", Color(0.72, 0.68, 0.62))
		hb.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		hb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cards.add_child(hb)

	# THE OFFER FILLS SHORT rather than padding with repeats (AP §3, unchanged),
	# and it SAYS SO — a silently short column reads as a bug, and with the
	# per-run ledger four columns can now go short at different rates.
	# **BATCH HE §3 — READ OFF THE STORED TRIPLE, NOT THE LIVE LIST**: a card held
	# back for an engine is not a pool that ran dry, and the line above names it.
	# **ID §1 — THE ZONE BOSS'S FILLS SHORT ONLY WHEN BOTH ITS TIERS ARE SPENT** (`ability_choice`
	# tops it up), so its line is drawn only when nothing at all is left to take or hold back.
	var boss_spent := not is_draft and _boss_spent(idx)
	if (is_draft and stored.size() < 3) or boss_spent:
		var short := Label.new()
		short.text = "Nothing further left to offer this run." if stored.is_empty() \
				or not is_draft else "The pool holds no more to offer this run."
		# BATCH IE §5 — AN EMPTY BOSS OFFER IS SPENT, in the cache's words (FM §3).
		if boss_spent:
			short.text = BOSS_SPENT_NOTE
		short.add_theme_font_size_override("font_size", 11)
		short.add_theme_color_override("font_color", Color(0.55, 0.53, 0.5))
		short.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		short.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cards.add_child(short)

	# At the cap a staged card is not yet a decision: the column stays undecided
	# until the replacement is named, and the button says which state it is in.
	# **ID §1 — "AT THE CAP" IS `_bench_needed`'s**, counted across both offers in the Confirm's
	# order, and the step lists no card the other offer benches.
	if needs_bench:
		var drop_btn := Button.new()
		drop_btn.text = "benches %s  (change)" % staged_drop if staged_drop != "" \
			else "Choose what %s replaces" % staged
		drop_btn.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
		drop_btn.add_theme_font_size_override("font_size", 12)
		drop_btn.add_theme_color_override("font_color",
			Color(0.85, 0.82, 0.75) if staged_drop != "" else Color(0.95, 0.6, 0.45))
		drop_btn.pressed.connect(Music.click)
		# THE CALLABLE IS PASSED BARE. `Callable.bind` appends its arguments
		# AFTER the call's, so `_stage_draft_drop.bind(idx).bind(name)` resolves
		# to `_stage_draft_drop(name, idx)` — the arguments REVERSED, which is a
		# type error at the moment a player clicks a drop and nowhere earlier.
		# `_open_drop_overlay` already holds `idx` and binds both in signature
		# order.
		var other_bench := _bench_for(idx, "boss" if is_draft else "draft")
		drop_btn.pressed.connect(_open_drop_overlay.bind(idx, "draft" if is_draft else "ability",
			staged, _stage_draft_drop if is_draft else _stage_boss_drop,
			[other_bench] if other_bench != "" else []))
		col.add_child(drop_btn)

	if boss_spent:
		var let_b := Button.new()
		let_b.text = ("▸ " if bool(st["bspent"]) else "") + "Let it go"
		let_b.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
		let_b.add_theme_font_size_override("font_size", 12)
		let_b.add_theme_color_override("font_color",
			Color(1.0, 0.9, 0.5) if bool(st["bspent"]) else Color(0.7, 0.68, 0.65))
		let_b.set_meta("let_go", "boss")
		let_b.pressed.connect(Music.click)
		let_b.pressed.connect(_stage_spend.bind(idx, "bspent"))
		col.add_child(let_b)

	if is_draft:
		# DECLINING IS ALWAYS ALLOWED, PER HERO, INDEPENDENTLY. One hero taking a
		# card does not commit the others, and a settled kit is a legitimate end
		# state — being forced to churn would make a good build worse as the run
		# goes on. It writes THAT hero's ledger and nobody else's.
		var pass_btn := Button.new()
		pass_btn.text = "▸ Declined" if declined else "Decline"
		pass_btn.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
		pass_btn.add_theme_font_size_override("font_size", 12)
		pass_btn.add_theme_color_override("font_color",
			Color(1.0, 0.9, 0.5) if declined else Color(0.7, 0.68, 0.65))
		pass_btn.pressed.connect(Music.click)
		pass_btn.pressed.connect(_stage_draft_decline.bind(idx))
		col.add_child(pass_btn)

	var decided := _draft_decided(idx) if is_draft else _boss_decided(idx)
	var state := Label.new()
	if declined:
		state.text = "keeps the kit as it is"
	elif boss_spent:
		state.text = "lets the pick go" if bool(st["bspent"]) else "— undecided —"
	elif not is_draft and offer.is_empty():
		state.text = "nothing to take now — the pick stays owed"
	elif staged == "":
		state.text = "— undecided —"
	elif needs_bench and staged_drop == "":
		state.text = "name what it replaces"
	elif needs_bench:
		state.text = "takes %s, benching %s" % [staged, staged_drop]
	else:
		state.text = "takes %s" % staged
	state.add_theme_font_size_override("font_size", 12)
	state.add_theme_color_override("font_color",
		Color(0.6, 0.85, 0.6) if decided else Color(0.55, 0.53, 0.5))
	state.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 16)
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(state)


# ONE CARD OF AN OFFER, drawn the one way a card is drawn on this screen (BX's column): its
# button, its tag line, its description and its computed block. `taken` names the other offer
# that has staged the same card, and the button then cannot be pressed.
func _offer_card(cards: VBoxContainer, card_name: String, chosen: bool, on_press: Callable,
		res_name: String, taken: String) -> void:
	var ab: Ability = Classes.pool_ability(card_name)
	var b := Button.new()
	b.text = ("▸ " if chosen else "") + card_name + ("  — %s" % taken if taken != "" else "")
	b.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 28)
	b.add_theme_font_size_override("font_size", 13)
	b.add_theme_color_override("font_color",
		Color(1.0, 0.9, 0.5) if chosen else Color(0.85, 0.82, 0.75))
	if chosen:
		b.modulate = Color(1.15, 1.1, 0.85)
	b.disabled = taken != ""
	b.pressed.connect(Music.click)
	b.pressed.connect(on_press)
	cards.add_child(b)
	# BATCH EK §3 — THE ARCHETYPE TAG, ON THE SCREEN WHERE THE DECISION
	# HAPPENS. One line, directly under the card's own button and ABOVE the
	# description, because a tag is what the card is FOR and the sentence is
	# what it does — the reader wants the direction before the detail.
	#
	# **IT IS ITS OWN LABEL RATHER THAN A PREFIX ON THE DESCRIPTION**, for
	# CK §1's reason one layer down: an authored sentence and a derived
	# vocabulary are different kinds of writing, and only one of them is
	# text the designer wrote. Its own tint keeps them apart at a glance.
	#
	# **`Classes.card_tag_line` IS THE ONE BUILDER** — the Kit panel, the
	# battle tooltip and the rune offer all render a different surface, and
	# when one of them takes tags on it must not draw them a second way.
	#
	# LAYOUT, MEASURED: one 11px line a card, three cards a column, so
	# **+42px against a 388px viewport** on a column CK already measured at
	# 557–671px. It is a `ScrollContainer` with autowrap on and nothing is
	# clipped; the cost is that the column runs a little further past one
	# viewport than it already did. **The font was NOT shrunk and the
	# computed block was NOT truncated** — see `docs/reports/EK.md` §3.
	var tag_line := Classes.card_tag_line(card_name)
	if tag_line != "":
		var tags_lbl := Label.new()
		tags_lbl.text = tag_line
		tags_lbl.add_theme_font_size_override("font_size", 11)
		tags_lbl.add_theme_color_override("font_color",
			Color(0.85, 0.72, 0.95) if chosen else Color(0.62, 0.55, 0.72))
		tags_lbl.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		tags_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cards.add_child(tags_lbl)
	if ab != null and ab.description != "":
		var text := Label.new()
		# BATCH CL §1 — NO CTX ON PURPOSE. The map screen has no live hero to
		# resolve against (the same reason `computed_block` prints a scaling
		# percentage here and a range on the Kit panel's hover), so every token falls
		# through to its bare percentage: no parenthetical, no placeholder,
		# no dash. Resolving is still CALLED, because an unresolved token
		# must never reach a label.
		text.text = Classes.resolve_values(ab.description)
		text.add_theme_font_size_override("font_size", 11)
		text.add_theme_color_override("font_color",
			Color(0.8, 0.76, 0.66) if chosen else Color(0.62, 0.6, 0.57))
		text.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cards.add_child(text)
	# BATCH CK §1 — THE COMPUTED BLOCK. Damage, Break damage, cost,
	# cooldown, initiative and PERFECT, under the description, on the one
	# screen whose whole purpose is comparing cards. It is a SECOND LABEL
	# rather than more text in the first, in a cooler tint, because the
	# authored sentence and the computed figures are different kinds of
	# writing and only one of them is a card the designer wrote.
	#
	# THIS SURFACE IS ARITHMETIC-ALLOWED AND THE BENCH STEP IS NOT. `_pick_button`
	# (the bench step's choices) renders `description` alone BY DESIGN, and since ID §1
	# it is the one surface left that does: the zone boss's offer, which the pick
	# overlay drew that way, is an offer of this section now and draws through this
	# builder — a draft's card and a boss's are one kind of thing (§0.5), so they read
	# one way. Do not "make them consistent" with the bench step.
	if ab != null:
		var block := Classes.computed_block(ab, 0, res_name)
		if block != "":
			var nums := Label.new()
			nums.text = block
			nums.add_theme_font_size_override("font_size", 11)
			nums.add_theme_color_override("font_color",
				Color(0.78, 0.78, 0.70) if chosen else Color(0.60, 0.62, 0.58))
			nums.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
			nums.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			cards.add_child(nums)


# ══ THE UPGRADES SECTION (ID §1a) ══════════════════════════════════════════════════════════
#
# **ITS OWN SECTION, BECAUSE AN UPGRADE CHANGES A CARD HE HOLDS RATHER THAN ADDING ONE**, and it
# shows the two things that decision needs: WHICH CARD (each choice is named *card: upgrade*, as
# the pick overlay named it) and WHAT IT DOES TO IT — the upgrade's own sentence, then the card's
# figures that move, old → new (`Run.upgrade_preview`). The mini-boss's offer, re-asked at the
# answer (`Run.upgrade_choice`, FE §2's door), staged by its id; no decline, as the overlay had
# none. An offer with nothing in it says so and stays owed.
func _upgrade_section(overlay: Control, idx: int, at: Vector2) -> void:
	var member: Dictionary = Run.party[idx]
	var staged := String(_stage_of(idx)["upgrade"])
	var panel := PanelContainer.new()
	panel.position = at
	panel.custom_minimum_size = Vector2(DRAFT_COL_W, DRAFT_COL_H)
	panel.size = Vector2(DRAFT_COL_W, DRAFT_COL_H)
	panel.set_meta("section", "upgrades")
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)
	var head := Label.new()
	head.text = "UPGRADES"
	head.add_theme_font_override("font", NAME_FONT)
	head.add_theme_font_size_override("font_size", 22)
	head.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
	head.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(head)
	var from := Label.new()
	from.text = "from the mini-boss"
	from.add_theme_font_size_override("font_size", 12)
	from.add_theme_color_override("font_color", Color(0.78, 0.7, 0.5))
	from.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 16)
	from.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(from)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 388)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 2)
	list.custom_minimum_size = Vector2(DRAFT_COL_W - 34, 0)
	scroll.add_child(list)

	var offer: Array = Run.upgrade_choice(member)
	for i in offer.size():
		var up: Dictionary = offer[i]
		var uid := String(up.get("id", ""))
		var chosen: bool = staged == uid
		var b := Button.new()
		b.text = ("▸ " if chosen else "") + "%s: %s" % [String(up.get("ability", "")),
			Run.upgrade_name(uid)]
		b.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 28)
		b.add_theme_font_size_override("font_size", 13)
		b.add_theme_color_override("font_color",
			Color(1.0, 0.9, 0.5) if chosen else Color(0.85, 0.82, 0.75))
		if chosen:
			b.modulate = Color(1.15, 1.1, 0.85)
		b.pressed.connect(Music.click)
		b.pressed.connect(_stage_upgrade.bind(idx, uid))
		list.add_child(b)
		var what := Label.new()
		what.text = Run.upgrade_desc(uid)
		what.add_theme_font_size_override("font_size", 11)
		what.add_theme_color_override("font_color",
			Color(0.8, 0.76, 0.66) if chosen else Color(0.62, 0.6, 0.57))
		what.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		what.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		list.add_child(what)
		var moves := Run.upgrade_preview(member, up)
		if moves != "":
			var nums := Label.new()
			nums.text = moves
			nums.add_theme_font_size_override("font_size", 11)
			nums.add_theme_color_override("font_color",
				Color(0.78, 0.78, 0.70) if chosen else Color(0.60, 0.62, 0.58))
			nums.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
			nums.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			list.add_child(nums)
	if offer.is_empty():
		var none := Label.new()
		# BATCH IE §5 — an empty upgrade offer cannot refill, so it is spent (FM §3's words).
		none.text = UPGRADE_SPENT_NOTE
		none.add_theme_font_size_override("font_size", 11)
		none.add_theme_color_override("font_color", Color(0.55, 0.53, 0.5))
		none.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		none.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		list.add_child(none)

	var picked: Dictionary = {}
	for up in offer:
		if String((up as Dictionary).get("id", "")) == staged:
			picked = up
	var u_spent := bool(_stage_of(idx)["uspent"])
	if offer.is_empty():
		var let_u := Button.new()
		let_u.text = ("▸ " if u_spent else "") + "Let it go"
		let_u.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
		let_u.add_theme_font_size_override("font_size", 12)
		let_u.add_theme_color_override("font_color",
			Color(1.0, 0.9, 0.5) if u_spent else Color(0.7, 0.68, 0.65))
		let_u.set_meta("let_go", "upgrade")
		let_u.pressed.connect(Music.click)
		let_u.pressed.connect(_stage_spend.bind(idx, "uspent"))
		box.add_child(let_u)
	var state := Label.new()
	if offer.is_empty():
		state.text = "lets the pick go" if u_spent else "— undecided —"
	elif picked.is_empty():
		state.text = "— undecided —"
	else:
		state.text = "takes %s: %s" % [String(picked.get("ability", "")), Run.upgrade_name(staged)]
	state.add_theme_font_size_override("font_size", 12)
	state.add_theme_color_override("font_color",
		Color(0.6, 0.85, 0.6) if not picked.is_empty() or u_spent else Color(0.55, 0.53, 0.5))
	state.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 16)
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(state)


# Clicking the staged card again UNSTAGES it, so a section can be taken back to
# undecided without declining — declining is a real decision with a real cost (the whole
# offer enters that hero's no-return ledger) and must never be the only way out of a
# misclick. Each stage writes its own section's keys and leaves the other's alone — and a card the
# OTHER ability offer has staged is not staged here (ID §1: its button is drawn and cannot be
# pressed; one Confirm takes a card once).
func _stage_draft(idx: int, card: String) -> void:
	var st := _stage_of(idx)
	if card != "" and card == String(st["bcard"]) and Run.pick_owed(Run.party[idx], "ability") > 0:
		return
	if String(st["card"]) == card and not bool(st["declined"]):
		st["card"] = ""
	else:
		st["card"] = card
	st["drop"] = ""
	st["declined"] = false
	_open_hero_draft(idx)


func _stage_draft_drop(idx: int, drop_name: String) -> void:
	_stage_of(idx)["drop"] = drop_name
	_open_hero_draft(idx)


func _stage_draft_decline(idx: int) -> void:
	var st := _stage_of(idx)
	st["declined"] = not bool(st["declined"])
	st["card"] = ""
	st["drop"] = ""
	_open_hero_draft(idx)


# BATCH ID §1 — the zone boss's offer, staged as the draft's is: the same press again unstages,
# a card the draft's offer has staged is not staged here, and choosing a card clears its bench.
func _stage_boss(idx: int, card: String) -> void:
	var st := _stage_of(idx)
	if card == String(st["card"]) and not bool(st["declined"]) \
			and Run.pick_owed(Run.party[idx], "draft") > 0:
		return
	st["bcard"] = "" if String(st["bcard"]) == card else card
	st["bdrop"] = ""
	_open_hero_draft(idx)


func _stage_boss_drop(idx: int, drop_name: String) -> void:
	_stage_of(idx)["bdrop"] = drop_name
	_open_hero_draft(idx)


# BATCH ID §1 — the mini-boss's upgrade, by its id; the same press again unstages it.
func _stage_upgrade(idx: int, uid: String) -> void:
	var st := _stage_of(idx)
	st["upgrade"] = "" if String(st["upgrade"]) == uid else uid
	_open_hero_draft(idx)


# BATCH IE §5 — an empty boss or upgrade offer let go (`key` "bspent" or "uspent"); the same
# press again unstages it.
func _stage_spend(idx: int, key: String) -> void:
	var st := _stage_of(idx)
	st[key] = not bool(st[key])
	_open_hero_draft(idx)


# A rune by its name, or "" to let an empty cache go; the same press again unstages it.
func _stage_draft_rune(idx: int, rune_name: String) -> void:
	var st := _stage_of(idx)
	if bool(st["rune_set"]) and String(st["rune"]) == rune_name:
		st["rune_set"] = false
		st["rune"] = ""
	else:
		st["rune_set"] = true
		st["rune"] = rune_name
	_open_hero_draft(idx)


# THE RUNES SECTION — the rune cache's offer, re-asked at the answer (`Run.rune_choice`,
# FD §1), and what it holds back for an engine or the pet said, in the overlay's words
# it had from GV and HC until IB moved it here.
func _draft_rune_section(overlay: Control, idx: int, at: Vector2) -> void:
	var member: Dictionary = Run.party[idx]
	var st := _stage_of(idx)
	var rune_set := bool(st["rune_set"])
	var staged := String(st["rune"])

	var panel := PanelContainer.new()
	panel.position = at
	panel.custom_minimum_size = Vector2(DRAFT_COL_W, DRAFT_COL_H)
	panel.size = Vector2(DRAFT_COL_W, DRAFT_COL_H)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)
	var head := Label.new()
	head.text = "RUNES"
	head.add_theme_font_override("font", NAME_FONT)
	head.add_theme_font_size_override("font_size", 22)
	head.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	head.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(head)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 388)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 2)
	list.custom_minimum_size = Vector2(DRAFT_COL_W - 34, 0)
	scroll.add_child(list)

	var triple: Array = Run.rune_choice(member)
	for i in triple.size():
		var rune: Dictionary = triple[i]
		var nm := String(rune["name"])
		var chosen: bool = rune_set and staged == nm
		# BATCH HE §4 — no scope band; HO §1 — a crest rune says whose it is.
		var label := nm
		if Runes.is_party_rune(rune):
			label = "%s  (for %s)" % [nm, Run.rune_for_label(rune)]
		var b := Button.new()
		b.text = ("▸ " if chosen else "") + label
		b.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 28)
		b.add_theme_font_size_override("font_size", 13)
		b.add_theme_color_override("font_color",
			Color(1.0, 0.9, 0.5) if chosen else Runes.RUNE_TINT)
		if chosen:
			b.modulate = Color(1.15, 1.1, 0.85)
		b.pressed.connect(Music.click)
		b.pressed.connect(_stage_draft_rune.bind(idx, nm))
		list.add_child(b)
		var text := Label.new()
		text.text = Runes.shown_desc(rune)
		text.add_theme_font_size_override("font_size", 11)
		text.add_theme_color_override("font_color",
			Color(0.8, 0.76, 0.66) if chosen else Color(0.62, 0.6, 0.57))
		text.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		list.add_child(text)

	# BATCH GV / HC §5 — WHAT THE CACHE HOLDS BACK, SAID RATHER THAN HIDDEN: a rune that
	# waits on an engine being equipped, or one that needs the companion the equipped
	# dismisser sends away. Held, not spent: equipping (or unequipping) brings it back.
	var withheld: Array = Run.rune_choice_withheld(member)
	var wh_held: Array = Run.held_engines(member)
	var wh_pet: Array = withheld.filter(func(c): return Runes.pet_holds_back(
		String((c as Dictionary).get("id", "")), wh_held))
	var wh_engine: Array = withheld.filter(func(c): return not Runes.pet_holds_back(
		String((c as Dictionary).get("id", "")), wh_held))
	var waits_on: String = Runes.waited_on(wh_engine.map(
		func(c): return String((c as Dictionary).get("id", ""))))
	var pet_line := "The cache holds %d more that need%s a companion, which the %s dismisses." % [
		wh_pet.size(), "s" if wh_pet.size() == 1 else "", Runes.dismisser_name(wh_held)]
	var notes := PackedStringArray()
	if not triple.is_empty():
		if not wh_engine.is_empty():
			notes.append("The cache holds %d more that wait%s on %s being equipped." % [
				wh_engine.size(), "s" if wh_engine.size() == 1 else "", waits_on])
		if not wh_pet.is_empty():
			notes.append(pet_line)
	elif not withheld.is_empty():
		# BATCH FM §3 / GV — A CACHE EMPTIED BY WHAT HE HAS EQUIPPED IS NOT "NOTHING CAN
		# ARRIVE": the pouch's own button fills it, so it is said, and letting it go spends it.
		if wh_engine.is_empty():
			notes.append("The cache holds nothing this hero can take while the %s is equipped, which dismisses the companion they need.\nUnequip it and the cache's runes return; letting the pick go spends it." % \
				Runes.dismisser_name(wh_held))
		else:
			notes.append("The cache holds nothing this hero can take while %s is not equipped.\nEquip it and the cache's runes return; letting the pick go spends it." % \
				waits_on)
			if not wh_pet.is_empty():
				notes.append(pet_line)
	else:
		# BATCH FM §3 — A TRIPLE THAT REPAIRED TO NOTHING: the pick is spent rather than
		# held, because nothing can arrive to fill it.
		notes.append("The cache holds nothing this hero can take — %s.\nThe pick is spent rather than held: nothing can arrive to fill it." % \
			Runes.empty_offer_reason(member, Run.party_rune_names()))
	if not notes.is_empty():
		var more := Label.new()
		more.text = "\n".join(notes)
		more.add_theme_font_size_override("font_size", 11)
		more.add_theme_color_override("font_color", Color(0.72, 0.68, 0.62))
		more.custom_minimum_size = Vector2(DRAFT_COL_W - 38, 0)
		more.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		list.add_child(more)
	if triple.is_empty():
		var let_go := Button.new()
		let_go.text = ("▸ " if rune_set else "") + "Let it go"
		let_go.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 26)
		let_go.add_theme_font_size_override("font_size", 12)
		let_go.add_theme_color_override("font_color",
			Color(1.0, 0.9, 0.5) if rune_set else Color(0.7, 0.68, 0.65))
		let_go.pressed.connect(Music.click)
		let_go.pressed.connect(_stage_draft_rune.bind(idx, ""))
		box.add_child(let_go)

	var state := Label.new()
	if not rune_set:
		state.text = "— undecided —"
	elif staged == "":
		state.text = "lets the cache go"
	else:
		state.text = "takes %s" % staged
	state.add_theme_font_size_override("font_size", 12)
	state.add_theme_color_override("font_color",
		Color(0.6, 0.85, 0.6) if rune_set else Color(0.55, 0.53, 0.5))
	state.custom_minimum_size = Vector2(DRAFT_COL_W - 16, 16)
	state.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(state)


# LATER: nothing is committed, every pick on the screen stays owed and marked on his card, and
# the arrival walk goes on without bringing this screen back on this arrival.
func _close_hero_draft() -> void:
	var idx := _hero_draft_for
	_shut_hero_draft()
	if idx >= 0:
		_arrival_dismissed(idx)


func _shut_hero_draft() -> void:
	if _draft_overlay != null and is_instance_valid(_draft_overlay):
		_draft_overlay.queue_free()
	_draft_overlay = null
	_draft_stage.erase(_hero_draft_for)
	_hero_draft_for = -1


# THE ONE COMMIT FOR HIS WHOLE DECISION. The ability resolves through the two doors BX's
# screen called — `Run.take_draft_ability` and `Run.decline_draft` — and the rune through
# the cache's own (`_take_rune_pick`, `_spend_rune_pick`), so the cap, the bench, the
# no-return ledger and every re-asked offer are the run's rules and not this screen's.
# It saves ONCE afterwards.
#
# **BATCH ID §1 — FOUR SECTIONS, COMMITTED IN THE ORDER THEY ARE DRAWN**: the draft, the zone
# boss's ability (`_pick_ability`), the upgrade (`_pick_upgrade`), the rune. Each bench is read
# BEFORE anything commits (`_bench_for`), because the draft's take moves the count the boss's
# reads; a section he cannot answer now is skipped and stays owed.
func _confirm_hero_draft() -> void:
	var idx := _hero_draft_for
	if idx < 0 or idx >= Run.party.size() or _answerable(idx).is_empty() \
			or not _hero_draft_decided(idx):
		return
	var member: Dictionary = Run.party[idx]
	var st := _stage_of(idx)
	var who := String(member["key"]).capitalize()
	var can: Array = _answerable(idx)
	var draft_bench := _bench_for(idx, "draft")
	var boss_bench := _bench_for(idx, "boss")
	var said := PackedStringArray()
	if can.has("draft"):
		if bool(st["declined"]):
			Run.decline_draft(member)
			said.append("%s keeps the kit as it is" % who)
		else:
			var card := String(st["card"])
			var refused := Run.take_draft_ability(member, card, draft_bench)
			said.append("%s: %s" % [who, refused] if refused != "" else "%s takes %s" % [who, card])
	if can.has("boss") and bool(st["bspent"]) and _boss_spent(idx):
		said.append(_spend_boss_pick(idx))
	elif can.has("boss"):
		var bcard := String(st["bcard"])
		var refused_b := _pick_ability(idx, bcard, boss_bench)
		if refused_b != "":
			said.append("%s: %s" % [who, refused_b])
		elif boss_bench != "":
			said.append("%s carries %s instead of %s" % [who, bcard, boss_bench])
		else:
			said.append("%s learns %s" % [who, bcard])
	if can.has("upgrade") and bool(st["uspent"]) and _upgrade_spent(idx):
		said.append(_spend_upgrade_pick(idx))
	elif can.has("upgrade"):
		var live: Array = Run.upgrade_choice(member)
		var at := -1
		for i in live.size():
			if String((live[i] as Dictionary).get("id", "")) == String(st["upgrade"]):
				at = i
		var up: Dictionary = live[at] if at >= 0 else {}
		var refused_u := _pick_upgrade(idx, at)
		said.append("%s: %s" % [who, refused_u] if refused_u != "" else "%s: %s is now %s" % [
			who, String(up.get("ability", "")), Run.upgrade_name(String(up.get("id", "")))])
	var landed := ""
	if can.has("rune"):
		var took: Dictionary = _spend_rune_pick(idx) if String(st["rune"]) == "" \
			else _take_rune_pick(idx, String(st["rune"]))
		landed = String(took.get("landed", ""))
		if String(took.get("text", "")) != "":
			said.append(String(took["text"]))
	_shut_hero_draft()
	Run.save_run()
	_draw_screen()
	if not said.is_empty():
		_toast(" · ".join(said))
	if landed == "pending":
		_check_rune_drops()
	_arrival_next.call_deferred()


# ══ BATCH FM §3 — SPENDING A PICK THAT HAS NOTHING TO SPEND ON ══════════════
#
# The counterpart to `_take_rune_pick`, and it asks the SAME door first for the same
# reason: `rune_choice` is what decides whether this triple has anything left, so a
# spend that did not ask it could eat a live pick. The screen draws the button that
# stages it only when the triple came back empty. Returns what the toast says.
func _spend_rune_pick(idx: int) -> Dictionary:
	var member: Dictionary = Run.party[idx]
	# BATCH IV §1a — the run's door (`Run.spend_rune_pick`), which the sim lets a cache go through too.
	if not Run.spend_rune_pick(member):
		return {}
	return {"landed": "spent", "text": "%s: the cache had nothing left to offer. The pick is spent." % \
		String(member["key"]).capitalize()}


# The rune cache's pick, answered: the rune by its name, out of the list the screen drew
# (`Run.rune_choice`, FD §1 — idempotent, so the door re-reads the same array rather than
# repairing a second time, and a triple that repaired to nothing is refused there).
# Returns where it landed and what the toast says.
#
# **BATCH IV §1a — THE ANSWER IS THE RUN's DOOR NOW (`Run.take_rune_pick`)**, so the sim answers a cache
# through the same lines a player's Confirm does; this function says what happened.
func _take_rune_pick(idx: int, rune_name: String) -> Dictionary:
	var member: Dictionary = Run.party[idx]
	# BATCH GV — THE LIST THE BUTTONS WERE BUILT FROM, NOT THE STORED TRIPLE: a candidate
	# reading an engine he has not equipped SITS OUT of what `rune_choice` returns and
	# stays stored.
	var took: Dictionary = Run.take_rune_pick(member, rune_name)
	if took.is_empty():
		return {}
	var rune: Dictionary = took["rune"]
	# Auto-equip while a slot is free — the pick already happens here; save the extra
	# click. **BATCH HK §2 — ASKED, AND `hold_rune` DECIDES BY KIND**: an ordinary rune
	# takes one of his three slots, a party rune the party slot, each only while one is
	# free; anything else is held unworn — on him (HR §1), or in the bag for a crest rune
	# — and a full holding queues it for the panel.
	#
	# **BATCH HL §1 — A CORE RUNE IS NOT ASKED FOR.** A slotted engine brings its enabler,
	# so asking here put a card in the kit beside the rune the player chose: one pick, two
	# things. It is held unworn, and its card joins the kit when he slots it on the hero's
	# panel — an act of his own, as HK made every other equip.
	var is_core := String(rune.get("engine", "")) != ""
	# BATCH GK — THE ONE DOOR (`Run.hold_rune`, asked inside `Run.take_rune_pick` since IV §1a).
	var landed := String(took["landed"])
	var text := ""
	if landed == "held" and is_core:
		# THE WORDS HL §1 PROPOSED, RULED AT HN §2 — and since HR §1 the rune waits on the
		# hero, not in the bag, so the place in them is his.
		text = "%s waits with the %s — slot it on the hero's rune panel to use it.%s" % [
			String(rune["name"]), Run.nameplate(member), pet_clause(member, rune)]
	elif landed == "held":
		text = "%s waits with the %s — every slot it fits is filled." % [
			String(rune["name"]), Run.nameplate(member)]
	elif landed == "bag":
		# HO §1's words for a crest rune with the crest filled.
		text = "%s goes into the bag — every slot it fits is filled." % String(rune["name"])
	elif landed == "worn" and Runes.is_party_rune(rune):
		# BATCH HO §1 — A PICK FROM ONE HERO'S CACHE THAT EVERY HERO NOW WEARS IS SAID.
		text = "%s fills the crest — every hero wears it." % String(rune["name"])
	return {"landed": landed, "text": text}


# **BATCH ID §1 — THE MINI-BOSS'S UPGRADE, COMMITTED BY THE HERO'S CONFIRM**: the door the
# screen's UPGRADES section is answered through, as `_pick_ability` is the boss's; "" when it is
# taken, or why it was refused.
func _pick_upgrade(idx: int, choice: int) -> String:
	var member: Dictionary = Run.party[idx]
	# BATCH FE §2 — THE SAME DOOR THE OVERLAY DREW FROM, CALLED AGAIN.
	# This path had NO guard of any kind: it indexed the stored offer and
	# appended it, so a hero could take one upgrade twice — AP's once-per-run
	# rule is enforced only by the ROLL's `has_upgrade` filter, and six of the
	# eight upgrades stamp a field that is not idempotent (Honed 25 -> 38 ->
	# 57, Weighted's pressure x2 -> x4, Quickened -2 -> -4 turns). Two queued
	# triples shared an id in 376 of 400 trials and the same (ability, id) pair
	# in 247 of 400.
	var live: Array = Run.upgrade_choice(member)
	var queue: Array = member.get("up_candidates", [])
	if int(member.get("up_picks_owed", 0)) < 1 or queue.is_empty():
		return "no pick is owed"
	if live.is_empty() or choice < 0 or choice >= live.size():
		return "that upgrade is not in the offer"
	queue.pop_front()
	var offer: Array = live
	member["up_candidates"] = queue
	var up: Dictionary = offer[choice]
	member["upgrades"] = member.get("upgrades", []) + [up.duplicate()]
	member["up_picks_owed"] = int(member.get("up_picks_owed", 0)) - 1
	return ""


# ---------- the rune pouch overlay ----------

# ══ BATCH GT §1 — THE POUCH'S CLOSE BUTTON NEVER MOVES ══════════════════════
#
# **IT COULD TRAP THE PLAYER, AND PAIRS WERE THE WORST OF IT.** The panel was a
# fixed stack from y 120 — title, the engine rows, a 380-pixel rune scroller —
# with Close at its foot, the ONLY way out, and an engine row is as tall as its
# rule. Measured on HEAD's layout with the pouch empty: Close was wholly below
# the 720-pixel screen for four engines held alone, for all sixty pairs of one
# class's engines, and for all four classes holding their six (y 1142 at worst).
# **A hero can HOLD up to all six of his class's engine runes** — three slotted
# since IA §2 (two until then), the rest kept — and this panel lists every one
# with its rule.
#
# **THE FIX IS THE LAYOUT, AND NOTHING WAS SHRUNK OR CUT.** The panel is a fixed
# rect inside the screen; everything whose height depends on text — the engine
# rows, the notes, the rune rows — lives in ONE scroller that takes the room
# between the title and Close; Close sits below the scroller, so no text can
# push it. The panel is wider than it was, which is what let the longest
# combination of GT's day, a class's six rules, fit with nothing scrolling (GQ's
# rule for the class-selection cards: make room for the longest text rather than
# cutting it). **Since IA §3 an empty core slot is a row**, so a class's six with
# a slot empty can run past the room the screen allows — the panel already spans
# it — and scrolls there, Close pinned, as a long pouch of ordinary runes always
# did; with every slot filled it still fits (`check_gt` §1 walks every slot count).
const POUCH_RECT := Rect2(140, 24, 1000, 672)
const POUCH_TEXT_W := 860
# BATCH HR §1 — the Drop on a held row, whose width the row's label gives up.
const HELD_DROP_W := 64


func _open_rune_panel(idx: int) -> void:
	if _rune_panel_for == idx:
		return
	_rune_panel_for = idx
	var member: Dictionary = Run.party[idx]
	# BATCH HK §2 — THE ROWS ARE `Run`'s: what he wears and, since HR §1, what he
	# holds unworn (the bag's rows until then), for his ordinary slots and his engine
	# slots. The index a button carries is the row's, and the door it presses
	# (`Run.toggle_rune`, `Run.toggle_engine`) reads the same rows, so the two cannot
	# disagree.
	var rows: Array = Run.rune_rows(member)
	var erows: Array = Run.engine_rows(member)
	# BATCH GX — read ONCE, off the same door the sheet and the slot buttons
	# ask, so no surface can disagree with another about which rune is sitting
	# out. It is re-read on every open, and the engine toggle below re-opens
	# the panel, so unequipping an engine repaints its runes immediately.
	var sitting_runes: Array = Run.sitting_out_rune_names(member)
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 60
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.78)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = POUCH_RECT.position
	panel.custom_minimum_size = POUCH_RECT.size
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var equipped: int = Run.runes_worn(member)
	var worn_engines: int = Run.engines_worn(member)
	# ══ BATCH IA §3 — THE HERO'S RUNES IN THREE SECTIONS, THE DESIGNER'S ORDER ══════
	#
	# *All the runes from each class in one bag for that class. At the top, the core
	# runes in their own section. Under that, the normal runes. Below that, all the
	# held runes that are not equipped. Each section separated.* So: **CORE** — his
	# core slots, every one drawn, an empty one too — **WORN** — his ordinary slots'
	# runes — **HELD, NOT WORN** — every rune he holds and does not wear, core runes
	# first. **THE SECTIONS ARE THE STATE**: a row carries no ✦ for worn and no
	# *(held)* for held any more, because a list sectioned by state that also prints
	# the state on every row says one thing twice; and the panel counts what he holds
	# once, in that section's head (HR's line above the list said it until IA). The
	# crest's bag is not here: a class's runes live on his panel and the bag holds
	# the crest's (HR §1, not re-merged). The kit preview stays one flat list with its
	# state column (HZ §1b): a read-only list is a different surface.
	var title := Label.new()
	title.text = "%s — RUNES" % String(member["key"]).capitalize()
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	# GT §1 — THE ONE SCROLLER. It fills whatever the title and Close leave, so
	# its height is the panel's and never the text's; the three sections live in it.
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 8)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)

	# ── CORE — every core slot drawn, filled or empty (GK's slots, three since IA §2) ──
	#
	# **THE CHARTER'S DROP AND SWAP HAPPEN HERE** (GK): a slotted core rune is
	# unequipped into his holding, and unequipping every one is allowed — a hero with
	# no core rune is a legal state. Its enabler leaves the next fight with it; the rune
	# is kept, held on him unworn (HR §1). `Run.toggle_engine` owns the rule; this
	# panel only draws it. **A core rune applies at the SPAWN, never here**: the battle
	# reads the slotted set once, as a fight opens, and nothing in it writes a slot.
	_pouch_head(list, "CORE — %d of %d slots" % [worn_engines, Run.ENGINE_SLOTS],
		Color(0.95, 0.75, 0.45))
	for ei in erows.size():
		if bool(erows[ei]["worn"]):
			_pouch_engine_row(list, idx, member, erows, ei, worn_engines, sitting_runes, overlay)
	for _empty in maxi(Run.ENGINE_SLOTS - worn_engines, 0):
		# AN EMPTY SLOT IS DRAWN AND SAYS SO IN THE MAP CARD'S OWN WORD for one — the
		# slot is the thing shown; HN §2.6's line below says where a core rune comes from.
		# **IB §0.3 (ruled): *— empty —*, not *— empty core slot —* — A ROW DOES NOT
		# REPEAT ITS SECTION'S HEAD**, which already says CORE and counts the slots.
		_pouch_note(list, "— empty —", Color(0.5, 0.48, 0.52), true)
	if erows.is_empty():
		# BATCH HN §2 — RULED BY THE DESIGNER: HL's line read as though a core rune
		# arrives ATTACHED TO another rune — the confusion HL §1a closed — so the
		# line says where one is found, and nothing about arriving with anything.
		_pouch_note(list, "No core rune held. Core runes are found in play, alongside the others.",
			Color(0.6, 0.57, 0.55), false)
	list.add_child(HSeparator.new())

	# ── WORN — his ordinary slots' runes ──
	_pouch_head(list, "WORN — %d of %d slots" % [equipped, Run.rune_slots()],
		Color(0.45, 0.9, 0.5))
	if equipped == 0:
		_pouch_note(list, "No rune worn.", Color(0.6, 0.57, 0.55), false)
	for i in rows.size():
		if bool(rows[i]["worn"]):
			_pouch_rune_row(list, idx, member, rows, i, equipped, sitting_runes, overlay)
	list.add_child(HSeparator.new())

	# ── HELD, NOT WORN — every rune he holds and does not wear, core runes first ──
	#
	# BATCH HR §1 — WHAT HE HOLDS, AND HOW FULL IT IS: a rune he unequips stays with
	# him, unworn, and a full holding is why an Unequip is refused. The count is this
	# section's own, and the line under it says what the section is.
	_pouch_head(list, "HELD, NOT WORN — %d of %d" % [Run.held_count(member), Run.HERO_HOLD_CAP],
		Color(0.85, 0.6, 1.0))
	_pouch_note(list, "A rune taken off stays with him; Drop lets one go for good.",
		Color(0.72, 0.66, 0.8), false)
	var any_held := false
	for ei in erows.size():
		if not bool(erows[ei]["worn"]):
			any_held = true
			_pouch_engine_row(list, idx, member, erows, ei, worn_engines, sitting_runes, overlay)
	for i in rows.size():
		if not bool(rows[i]["worn"]):
			any_held = true
			_pouch_rune_row(list, idx, member, rows, i, equipped, sitting_runes, overlay)
	if not any_held:
		_pouch_note(list, "Nothing held. A rune drops after every normal fight, and the Peddler sells them.",
			Color(0.6, 0.57, 0.55), false)

	# BELOW THE SCROLLER, NEVER INSIDE IT: the one control the player needs to
	# leave is the one thing on this panel that no text can move.
	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(200, 38)
	close.pressed.connect(Music.click)
	close.pressed.connect(func():
		_rune_panel_for = -1
		overlay.queue_free())
	box.add_child(close)


# BATCH IA §3 — a section's head: one line, centred, in the section's colour.
func _pouch_head(list: VBoxContainer, text: String, color: Color) -> void:
	var head := Label.new()
	head.text = text
	head.add_theme_font_size_override("font_size", 15)
	head.add_theme_color_override("font_color", color)
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	list.add_child(head)


# BATCH IA §3 — a line inside a section that is not a rune: an empty core slot, an
# empty section, what a section is. An empty slot stands where a row would, so it
# takes a row's height (`slot_row`); a line that speaks for the section does not.
func _pouch_note(list: VBoxContainer, text: String, color: Color, slot_row: bool) -> void:
	var note := Label.new()
	note.text = text
	note.add_theme_font_size_override("font_size", 12)
	note.add_theme_color_override("font_color", color)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if slot_row:
		note.custom_minimum_size = Vector2(0, 26)
		note.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	list.add_child(note)


# BATCH IA §3 — ONE CORE RUNE'S ROW, in CORE when it is slotted and in HELD, NOT WORN
# when it is not. `ei` indexes `Run.engine_rows`, which the door it presses reads too.
func _pouch_engine_row(list: VBoxContainer, idx: int, member: Dictionary, erows: Array,
		ei: int, worn_engines: int, sitting_runes: Array, overlay: Control) -> void:
	var erow_d: Dictionary = erows[ei]
	var er: Dictionary = erow_d["rune"]
	var erow := HBoxContainer.new()
	erow.add_theme_constant_override("separation", 10)
	list.add_child(erow)
	var e_on: bool = bool(erow_d["worn"])
	var e_bag: bool = not e_on  # HR §1 — held unworn on him (HK: in the bag)
	var etoggle := Button.new()
	etoggle.custom_minimum_size = Vector2(84, 26)
	etoggle.add_theme_font_size_override("font_size", 11)
	etoggle.pressed.connect(Music.click)
	if e_bag and worn_engines >= Run.ENGINE_SLOTS:
		# BATCH HK §2 — EVERY CORE SLOT FULL: a held core rune goes on in place of one.
		etoggle.text = "Swap"
		etoggle.tooltip_text = "Every core slot is filled. Swap this\ncore rune for one he has slotted."
		etoggle.pressed.connect(_open_swap_chooser.bind(idx, "engines", ei, overlay))
	else:
		etoggle.text = "Unequip" if e_on else "Equip"
		# BATCH HB §4 — THE REFUSAL IS `Run.engine_toggle_refusal`'s, and it has
		# three causes: every core slot full (GK), unequipping the rune that
		# dismisses the pet into a kit with no slot free to take it back, and
		# (HK) unequipping into a full holding. The button is disabled on any and
		# says which, so the refusal is never a silent no-op.
		var e_why: String = Run.engine_toggle_refusal(member, ei)
		etoggle.disabled = e_why != ""
		if e_why != "":
			etoggle.tooltip_text = e_why
		etoggle.pressed.connect(_toggle_engine.bind(idx, ei, overlay))
	erow.add_child(etoggle)
	if e_bag:
		erow.add_child(_held_drop_button(idx, "engines", int(erow_d["at"]), er, overlay))
	var elbl := Label.new()
	elbl.text = "%s — %s" % [er["name"], Runes.shown_desc(er)]
	elbl.add_theme_font_size_override("font_size", 12)
	elbl.add_theme_color_override("font_color", Color(0.95, 0.75, 0.45) if e_on
		else Color(0.62, 0.6, 0.57))
	# BATCH HC §5 — A SLOTTED CORE RUNE THAT SITS OUT SAYS SO HERE, IN THE ORDINARY
	# ROWS' OWN SHAPE (GX's tell, ruled): the sentence in place of the rule and
	# the same amber, off the same door. It is the Rune of the Beastmaster beside
	# the Rune of the Sharpshooter, and this panel is where either is unslotted.
	if e_on and sitting_runes.has(String(er["name"])):
		elbl.text = "%s — %s" % [er["name"],
			Run.rune_sits_out_note(String(er.get("id", "")),
				Run.held_engines(member)).replace("\n", " ")]
		elbl.add_theme_color_override("font_color", Color(0.85, 0.7, 0.45))
	# HR §1 — a held row's Drop takes its width out of the label, so the row stays
	# inside the panel.
	elbl.custom_minimum_size = Vector2(POUCH_TEXT_W - (HELD_DROP_W + 10 if e_bag else 0), 20)
	elbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	erow.add_child(elbl)


# BATCH IA §3 — ONE ORDINARY RUNE'S ROW, in WORN or in HELD, NOT WORN. `i` indexes
# `Run.rune_rows`, which the door it presses reads too.
func _pouch_rune_row(list: VBoxContainer, idx: int, member: Dictionary, rows: Array,
		i: int, equipped: int, sitting_runes: Array, overlay: Control) -> void:
	var row_d: Dictionary = rows[i]
	var rune: Dictionary = row_d["rune"]
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	list.add_child(row)
	var is_on: bool = bool(row_d["worn"])
	var in_bag: bool = not is_on  # HR §1 — held unworn on him (HK: in the bag)
	var toggle := Button.new()
	toggle.custom_minimum_size = Vector2(84, 26)
	toggle.add_theme_font_size_override("font_size", 11)
	toggle.pressed.connect(Music.click)
	if in_bag and equipped >= Run.rune_slots():
		# BATCH HK §2 — EVERY SLOT FULL: a held rune goes on in place of one,
		# which works on a full holding too, because one rune moves each way.
		toggle.text = "Swap"
		toggle.tooltip_text = "Every rune slot is filled. Swap this rune\nfor one he wears."
		toggle.pressed.connect(_open_swap_chooser.bind(idx, "runes", i, overlay))
	else:
		toggle.text = "Unequip" if is_on else "Equip"
		var why: String = Run.rune_toggle_refusal(member, i)
		toggle.disabled = why != ""
		if why != "":
			toggle.tooltip_text = why
		toggle.pressed.connect(_toggle_rune.bind(idx, i, overlay))
	row.add_child(toggle)
	if in_bag:
		row.add_child(_held_drop_button(idx, "runes", int(row_d["at"]), rune, overlay))
	var lbl := Label.new()
	lbl.text = "%s — %s" % [rune["name"], Runes.shown_desc(rune)]
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.add_theme_color_override("font_color", Color(0.45, 0.9, 0.5) if is_on
		else Runes.RUNE_TINT)  # HE §4 — no scope band; one tint
	# BATCH GX — WORN, AND SITTING OUT. The row says so in place of the
	# rune's own text, because this is the panel where the engine it waits
	# on is re-slotted and where the slot it holds can be freed; the
	# sentence is the hero sheet's, one door. **GT §3's Kit panel, one
	# layer up** — same placement, same amber, same flattening, because a
	# second shape for the same idea is a second thing to keep in step.
	if is_on and sitting_runes.has(String(rune["name"])):
		lbl.text = "%s — %s" % [rune["name"],
			Run.rune_sits_out_note(String(rune.get("id", "")),
				Run.held_engines(member), Run.worn_rune_ids(member)).replace("\n", " ")]
		lbl.add_theme_color_override("font_color", Color(0.85, 0.7, 0.45))
	lbl.custom_minimum_size = Vector2(POUCH_TEXT_W - (HELD_DROP_W + 10 if in_bag else 0), 20)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	row.add_child(lbl)


# BATCH GK — drop or swap one engine rune. The rule is `Run.toggle_engine`'s; a
# refusal (every core slot full, or — since HB — the pet with no slot to come back
# to, or — since HK — a full holding to unequip into) is the disabled button, never a
# silent no-op here.
func _toggle_engine(idx: int, engine_idx: int, overlay: Control) -> void:
	if not Run.toggle_engine(Run.party[idx], engine_idx):
		return
	Run.save_run()
	overlay.queue_free()
	_rune_panel_for = -1
	_draw_screen()
	_open_rune_panel(idx)


# BATCH HK §2 — equip from the bag, and unequip back into it, through `Run`'s one
# door; a refusal is the disabled button above.
func _toggle_rune(idx: int, rune_idx: int, overlay: Control) -> void:
	if not Run.toggle_rune(Run.party[idx], rune_idx):
		return
	Run.save_run()
	overlay.queue_free()
	_rune_panel_for = -1
	_draw_screen()
	_open_rune_panel(idx)


# ══ BATCH HR §1 — A RUNE HE HOLDS CAN BE LET GO FROM HIS OWN PANEL ═══════════════
#
# **THE BAG'S DROP, MOVED TO WHERE THE RUNE IS NOW**: two presses, keyed by the
# rune's name, and the rune is gone for good. Without it a full holding could only
# be emptied at the Peddler. `key`/`at` name the rune on his list; `Run`'s door
# takes the index of `held_rows`, which is the same rune.
func _held_drop_button(idx: int, key: String, at: int, rune: Dictionary,
		overlay: Control) -> Button:
	var nm := String(rune.get("name", ""))
	var armed: bool = _held_drop_armed == nm
	var db := Button.new()
	db.text = "Sure?" if armed else "Drop"
	db.custom_minimum_size = Vector2(HELD_DROP_W, 26)
	db.add_theme_font_size_override("font_size", 11)
	db.add_theme_color_override("font_color", Color(0.95, 0.75, 0.4) if armed
		else Color(0.78, 0.55, 0.5))
	db.tooltip_text = "Drop %s for good.\n%s" % [nm,
		"Press again to confirm." if armed else "Press twice to drop it."]
	db.pressed.connect(Music.click)
	db.pressed.connect(_drop_held.bind(idx, key, at, overlay))
	return db


func _drop_held(idx: int, key: String, at: int, overlay: Control) -> void:
	var member: Dictionary = Run.party[idx]
	var hi := -1
	var rows: Array = Run.held_rows(member)
	for i in rows.size():
		if String(rows[i]["key"]) == key and int(rows[i]["at"]) == at:
			hi = i
	if hi < 0:
		_held_drop_armed = ""
		return
	var nm := String((rows[hi]["rune"] as Dictionary).get("name", ""))
	overlay.queue_free()
	_rune_panel_for = -1
	if _held_drop_armed != nm:
		_held_drop_armed = nm
		_open_rune_panel(idx)
		return
	_held_drop_armed = ""
	Run.drop_held_rune(member, hi)
	# A rune waiting on his full holding may fit now.
	Run.settle_pending_drops()
	Run.save_run()
	_draw_screen()
	_toast("%s is dropped. The %s holds %d unworn." % [nm, Run.nameplate(member),
		Run.held_count(member)])
	_open_rune_panel(idx)


# ══ BATCH HK §2 — THE SWAP CHOOSER ═══════════════════════════════════════════
#
# **WITH EVERY SLOT FULL, A BAG RUNE GOES ON IN PLACE OF A WORN ONE**, and this is
# where the player says which. It is also the only way to change what a hero wears
# while the bag is full: a swap moves one rune each way, so the bag's count does
# not move. `kind` is "runes", "engines" or "party"; `bag_row` indexes the rows the
# panel drew. An engine swap asks `Run.swap_engine_refusal` per choice — taking the
# pet's dismisser out owes the pet a slot (HB §4) — and a refused choice is a
# disabled button with the sentence on it. Cancel sits below the list.
func _open_swap_chooser(idx: int, kind: String, bag_row: int, parent: Control) -> void:
	var member: Dictionary = Run.party[idx] if idx >= 0 else {}
	var rows: Array = Run.party_rune_rows() if kind == "party" \
		else (Run.engine_rows(member) if kind == "engines" else Run.rune_rows(member))
	if bag_row < 0 or bag_row >= rows.size():
		return
	var incoming: Dictionary = rows[bag_row]["rune"]
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 80
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.6)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(340, 200)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)
	var head := Label.new()
	head.text = "Wear %s in place of:" % String(incoming.get("name", ""))
	head.add_theme_font_size_override("font_size", 17)
	head.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	box.add_child(head)
	for wi in rows.size():
		if not bool(rows[wi]["worn"]):
			continue
		var out_rune: Dictionary = rows[wi]["rune"]
		var b := Button.new()
		# HR §1 — a hero's swapped-out rune stays with him, unworn; the crest's goes
		# back into the bag.
		b.text = "%s  — %s" % [String(out_rune.get("name", "")),
			"back into the bag" if kind == "party" else "kept, unworn"]
		b.custom_minimum_size = Vector2(600, 30)
		b.add_theme_font_size_override("font_size", 12)
		var why := Run.swap_engine_refusal(member, bag_row, wi) if kind == "engines" else ""
		b.disabled = why != ""
		b.tooltip_text = why if why != "" else Runes.shown_desc(out_rune)
		b.pressed.connect(Music.click)
		b.pressed.connect(_do_swap.bind(idx, kind, bag_row, wi, overlay, parent))
		box.add_child(b)
	var cancel := Button.new()
	cancel.text = "Cancel"
	cancel.custom_minimum_size = Vector2(600, 30)
	cancel.pressed.connect(Music.click)
	cancel.pressed.connect(overlay.queue_free)
	box.add_child(cancel)


func _do_swap(idx: int, kind: String, bag_row: int, worn_row: int, overlay: Control,
		parent: Control) -> void:
	var done := false
	match kind:
		"engines":
			done = Run.swap_engine(Run.party[idx], bag_row, worn_row)
		"party":
			done = Run.swap_party_rune(bag_row, worn_row)
		_:
			done = Run.swap_rune(Run.party[idx], bag_row, worn_row)
	overlay.queue_free()
	if not done:
		return
	Run.save_run()
	if is_instance_valid(parent):
		parent.queue_free()
	_rune_panel_for = -1
	_bag_panel_open = false
	_draw_screen()
	if kind == "party":
		_open_bag_panel()
	else:
		_open_rune_panel(idx)


# ---------- BATCH EG §2: THE LOADOUT PANEL ----------
#
# THE RUNE POUCH'S SHAPE, DELIBERATELY. Same overlay, same row layout, same
# toggle-and-redraw. What differs is what the cap counts (`ability_slots_used`
# reads the PROTECTED CORE as well as the loadout, so the number on the title
# is not the row count) and that the protected core is LISTED AND CANNOT BE
# TOGGLED — a hero who could not see his own core would read the panel as
# "three of ten used" with nothing to account for the missing seven.
#
# IT WRITES THROUGH `Run.equip_earned_ability` / `Run.unequip_earned_ability`
# AND OWNS NEITHER RULE. The cap, the refusal of a protected name and the fact
# that neither door touches the no-return ledger are all `run_state.gd`'s, on
# the draft screen's own precedent.
func _open_loadout_panel(idx: int) -> void:
	if _loadout_panel_for == idx:
		return
	_loadout_panel_for = idx
	var member: Dictionary = Run.party[idx]
	var spec := String(member.get("spec", ""))
	var earned: Array = Run.earned_ability_names(member)
	var carried: Array = Run.equipped_ability_names(member)
	var sitting: Array = Run.sitting_out_names(member)
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 60
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.78)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(300, 110)
	panel.custom_minimum_size = Vector2(680, 500)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var title := Label.new()
	title.text = "%s — ABILITY SLOTS (%d of %d carried)" % [
		String(member["key"]).capitalize(), Run.ability_slots_used(member),
		Run.ability_slot_cap()]
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)

	var note := Label.new()
	note.text = "Benching costs nothing and a benched card is KEPT for the rest of the run.\nThe starting kit can never be benched. Slots grow on every zone boss."
	note.add_theme_font_size_override("font_size", 12)
	note.add_theme_color_override("font_color", Color(0.6, 0.58, 0.55))
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(note)

	# ── BATCH ES §4 — THE TAG CENSUS, ON THE SCREEN WHERE THE SWAP HAPPENS ──
	#
	# **A SILENT THRESHOLD IS A STAT NOBODY KNOWS THEY HAVE.** A rune reading
	# "hold 2+ of a tag" is only a decision if the player can see the count, see
	# it move, and see which card moved it — so the census sits on THIS panel (and
	# since IH §3 only here: the sheet shows what the hero is), because this is the
	# one screen where the number is under the player's hand. `_toggle_loadout` re-opens the panel after every
	# bench and carry, so the line is redrawn from the live loadout each time and
	# cannot go stale: there is no cached count here to invalidate.
	#
	# It reads `Run.loadout_ability_names` through `Classes.tag_census` — the
	# same door a rune asks through (`Runes.loadout_tag_census`) — so the number
	# on the screen and the number a clause reads can never be two numbers.
	# **THE CORE IS IN IT**, because the core is carried; that is why the row
	# already reads non-zero before anything is drafted, and it is the baseline
	# a threshold has to be authored against.
	var census: Dictionary = Classes.tag_census(Run.loadout_ability_names(member))
	var held: Array = []
	for tag in Classes.TAG_ORDER:
		held.append("%s %d" % [String(tag), int(census[String(tag)])])
	var tag_line := Label.new()
	tag_line.text = "CARRIED BY TAG   %s        breadth %d of %d" % [
		"   ".join(held), Classes.tag_breadth(Run.loadout_ability_names(member)),
		Classes.TAG_ORDER.size()]
	tag_line.add_theme_font_size_override("font_size", 12)
	tag_line.add_theme_color_override("font_color", Color(0.72, 0.68, 0.85))
	tag_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(tag_line)

	# ── BATCH FN — THE `RUNE CONDITIONS` LINE STOOD HERE AND IT IS GONE ──────
	#
	# **EZ §0 drew a second line under the census, because this is the screen
	# where the bench lever is under the player's hand**: the census counts the
	# whole bar and both tags, while the two rune conditions counted the DRAFTED
	# half and the PRIMARY tag only. **FN retired both conditions**, so the line
	# now answers a question no rune asks.
	#
	# **THE BENCH LEVER ITSELF IS UNTOUCHED** — `_toggle_loadout` still re-opens
	# this panel after every bench and every carry, and the census above is
	# still rebuilt from the live member on each swap. What went is the second
	# line, not the immediacy. `check_fn` §3 asserts the pair on this panel.

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(650, 380)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 5)
	rows.custom_minimum_size = Vector2(630, 0)
	scroll.add_child(rows)

	# ══ BATCH IF §3 — THE KIT IN FOUR SECTIONS, IA §3's SHAPE (IE's ruling 4, the designer's) ══
	#
	# **THE SECTIONS ARE THE STATE**, as on the rune panel: STARTING KIT (CORE until IG §3) — the
	# protected kit, never benched — ENABLERS — what his core runes bring, outside the slot count — CARRIED and
	# BENCHED, each with the head saying what every row under it is. So a carried card's row
	# no longer leads with ✦ (✦ names a rune, never a card), and a kit row no longer carries
	# CORE or ENABLER in a column of its own: a list sectioned by state that also prints the
	# state on every row says one thing twice. Every section is drawn, an empty one with the
	# line that says so (IA's emptiest state). The protected core is read off
	# `Run.opening_kit_names` — names, not `core_slots`, which counts slots — and an enabler
	# travels with its engine (GK).
	# BATCH IH §5 — THE HOVER THE HERO SHEET's CHIPS CARRIED, MOVED HERE: every ability row reads
	# `Run.ability_hover` off one live config built once for the panel (the sheet's own prologue,
	# moved to `Run.hero_live_config`), and wears ↑ when an upgrade landed on it (ID's glyph, which
	# the sheet's chip wore). A section's head or note is not an ability and carries no hover.
	var live: Dictionary = Run.hero_live_config(member)
	var enabler_names: Array = []
	for pid in Runes.held_engines(member):
		enabler_names.append_array(Classes.engine_enablers(String(pid)))
	var kit_core: Array = []
	var kit_enablers: Array = []
	for pname in Run.opening_kit_names(member):
		if enabler_names.has(String(pname)):
			kit_enablers.append(String(pname))
		else:
			kit_core.append(String(pname))
	var on_names: Array = earned.filter(func(n): return carried.has(n))
	var off_names: Array = earned.filter(func(n): return not carried.has(n))
	# BATCH IG §3 — STARTING KIT, NEVER CORE (IF's ruling 4, the designer's): CORE names a core rune on the
	# rune panel and the kit preview, and one word may not name two kinds of thing on two
	# panels. Not the bare KIT: the map card's own button counts this panel's starting cards AND its carried
	# ones as the kit (`Kit n/m`), so KIT here would name the whole and one part of it.
	_pouch_head(rows, "STARTING KIT — never benched", Color(0.55, 0.62, 0.85))
	for pname in kit_core:
		_loadout_kit_row(rows, member, String(pname), live)
	if kit_core.is_empty():
		_pouch_note(rows, "No card in the starting kit.", Color(0.6, 0.57, 0.55), false)
	rows.add_child(HSeparator.new())
	_pouch_head(rows, "ENABLERS — brought by a core rune", Color(0.55, 0.62, 0.85))
	for pname in kit_enablers:
		_loadout_kit_row(rows, member, String(pname), live)
	if kit_enablers.is_empty():
		_pouch_note(rows, "None: no slotted core rune brings a card.", Color(0.6, 0.57, 0.55), false)
	rows.add_child(HSeparator.new())
	_pouch_head(rows, "CARRIED — %d" % on_names.size(), Color(0.45, 0.9, 0.5))
	for aname in on_names:
		_loadout_earned_row(rows, idx, member, String(aname), true, sitting, overlay, live)
	if on_names.is_empty():
		_pouch_note(rows, "Nothing earned yet. A card is drafted after an elite or at an event,\nand a zone boss pays a pick of up to three."
			if earned.is_empty() else "Nothing carried. A benched card is carried again from below.",
			Color(0.6, 0.57, 0.55), false)
	rows.add_child(HSeparator.new())
	_pouch_head(rows, "BENCHED — %d, kept for the run" % off_names.size(), Color(0.62, 0.6, 0.57))
	for aname in off_names:
		_loadout_earned_row(rows, idx, member, String(aname), false, sitting, overlay, live)
	if off_names.is_empty():
		_pouch_note(rows, "Nothing benched.", Color(0.6, 0.57, 0.55), false)

	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(200, 38)
	close.pressed.connect(Music.click)
	close.pressed.connect(func():
		_loadout_panel_for = -1
		overlay.queue_free())
	box.add_child(close)


# BATCH IF §3 — a kit card's row in CORE or ENABLERS: its name, behind a blank where an
# earned row's button stands, so every name in the panel starts in one column.
func _loadout_kit_row(rows: VBoxContainer, member: Dictionary, pname: String,
		live: Dictionary) -> void:
	var prow := HBoxContainer.new()
	prow.add_theme_constant_override("separation", 10)
	rows.add_child(prow)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(84, 26)
	prow.add_child(gap)
	var plbl := Label.new()
	plbl.text = _upgraded_mark(member, pname, live) + pname
	_hover(plbl, Run.ability_hover(member, pname, live))
	plbl.add_theme_font_size_override("font_size", 12)
	plbl.add_theme_color_override("font_color", Color(0.72, 0.78, 0.9))
	plbl.custom_minimum_size = Vector2(520, 20)
	prow.add_child(plbl)


# BATCH IF §3 — an earned card's row in CARRIED or BENCHED: Bench or Carry, then its name
# and its text. The section says which; the row does not say it again.
func _loadout_earned_row(rows: VBoxContainer, idx: int, member: Dictionary, aname: String,
		is_on: bool, sitting: Array, overlay: Control, live: Dictionary = {}) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	rows.add_child(row)
	var toggle := Button.new()
	toggle.text = "Bench" if is_on else "Carry"
	toggle.custom_minimum_size = Vector2(84, 26)
	toggle.add_theme_font_size_override("font_size", 11)
	# A benched card cannot be carried while the slots are full. The
	# refusal is the DISABLED button plus its reason, never a silent no-op.
	toggle.disabled = not is_on and Run.ability_slots_full(member)
	if toggle.disabled:
		toggle.tooltip_text = "Every slot is carried. Bench one first."
	toggle.pressed.connect(Music.click)
	toggle.pressed.connect(_toggle_loadout.bind(idx, aname, overlay))
	row.add_child(toggle)
	var lbl := Label.new()
	var ab: Ability = Classes.pool_ability(aname)
	lbl.text = "%s%s%s" % [_upgraded_mark(member, aname, live), aname,
		"" if ab == null or ab.description == "" else " — %s" % Classes.resolve_values(ab.description)]
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.add_theme_color_override("font_color",
		Color(0.45, 0.9, 0.5) if is_on else Color(0.62, 0.6, 0.57))
	# BATCH GT §3 — CARRIED, AND SITTING OUT. The row says so in place of
	# the card's own text, because this is the panel where the slot it
	# still holds can be freed; the sentence is `Run.sits_out_note`'s, one door.
	if is_on and sitting.has(aname):
		lbl.text = "%s — %s" % [aname, Run.sits_out_note(aname,
			Run.held_engines(member)).replace("\n", " ")]
		lbl.add_theme_color_override("font_color", Color(0.85, 0.7, 0.45))
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl.custom_minimum_size = Vector2(520, 20)
	_hover(lbl, Run.ability_hover(member, aname, live))
	row.add_child(lbl)


# BATCH IH §5 — a row's hover, on the Label that names the card: a Label ignores the mouse by
# default and a tooltip on one that ignores it is never shown; it PASSES rather than stops, so
# the wheel still reaches the panel's scroller over a row.
func _hover(lbl: Label, tip: String) -> void:
	if tip == "":
		return
	lbl.tooltip_text = tip
	lbl.mouse_filter = Control.MOUSE_FILTER_PASS


# BATCH IH §5 — ↑ when an upgrade LANDED on the card (`Run.ability_landed`), as the sheet's chip
# wore it until IH §3 and the battle's button wears it (ID §3: ↑ names an upgrade wherever one appears).
func _upgraded_mark(member: Dictionary, card_name: String, live: Dictionary) -> String:
	return "↑ " if not Run.ability_landed(member, card_name, live).is_empty() else ""


# The overlay defaults to null so the panel can be driven without one —
# `check_map_screen` toggles both directions to prove the Callable binds, and a
# hard `overlay.queue_free()` would make that a crash rather than a check. The
# real caller always passes the live overlay.
func _toggle_loadout(idx: int, name: String, overlay: Control = null) -> void:
	var member: Dictionary = Run.party[idx]
	if Run.equipped_ability_names(member).has(name):
		Run.unequip_earned_ability(member, name)
	elif not Run.equip_earned_ability(member, name):
		return
	Run.save_run()
	if overlay != null and is_instance_valid(overlay):
		overlay.queue_free()
	_loadout_panel_for = -1
	_draw_screen()
	_open_loadout_panel(idx)


# ---------- the footer: gold and the (now usable) potions ----------

func _draw_footer() -> void:
	var gold_lbl := Label.new()
	gold_lbl.text = "Gold: %d" % Run.gold
	gold_lbl.add_theme_font_size_override("font_size", 18)
	gold_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	gold_lbl.position = Vector2(VIEW_X + 4, 556)
	add_child(gold_lbl)

	# §6: potions are usable HERE, not only in battle. Each item is a button;
	# pressing it asks which hero, then applies the effect on the map.
	#
	# BATCH CT §1 — THE ROW IS THE SLOT LIST. It draws the types the party
	# HOLDS (up to `Run.item_slots()`), not every id that exists, and an empty
	# held slot is drawn greyed rather than vanishing — a slot is only freed by
	# a discard or a sale.
	#
	# **THE BRIEF'S LAYOUT CLAIM IS WRONG AND THIS IS THE FIX IT SAID WAS NOT
	# NEEDED.** §1: "Six buttons fit the existing row... The slot cap removes the
	# layout problem rather than requiring a fix for it." At the old pitch they
	# do not. `VIEW_X + 4 + i * 190` puts button 6 (i = 5) at x = 1270 with a
	# width of 182, so it spans 1270..1452 on a viewport that is 1280 wide — 172
	# pixels of it off the screen, and the whole of its label. FIVE fit at that
	# pitch and no more. The pitch and width below are sized from the space that
	# actually exists: VIEW_X + 4 to the right edge is 956px, so six buttons at a
	# 158 pitch and 150 wide end at 1265, inside the edge with room to spare.
	var slot_cap := Run.item_slots()
	var hint := Label.new()
	hint.text = "Pouch  %d/%d slots (a slot holds one kind — discard to free it)" % [
		Run.slots_used(), slot_cap]
	hint.add_theme_font_size_override("font_size", 11)
	hint.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
	hint.position = Vector2(VIEW_X + 120, 560)
	add_child(hint)
	# ITEM_IDS order, so the row does not reshuffle as the pouch changes shape.
	var held: Array = Run.ITEM_IDS.filter(func(i): return Run.items.has(i))
	for i in held.size():
		var id: String = held[i]
		var have := int(Run.items.get(id, 0))
		var btn := Button.new()
		btn.text = "%s  x%d" % [Run.ITEM_INFO[id][0].replace(" Potion", ""), have]
		btn.custom_minimum_size = Vector2(POUCH_BTN_W, 32)
		btn.position = Vector2(VIEW_X + 4 + i * POUCH_PITCH, 584)
		btn.add_theme_font_size_override("font_size", 12)
		btn.tooltip_text = _map_item_tooltip(id)
		btn.disabled = have < 1 or not _usable_on_map(id)
		if have >= Run.item_stack_cap(id):
			btn.add_theme_color_override("font_color", Color(0.95, 0.75, 0.4))
		btn.pressed.connect(Music.click)
		btn.pressed.connect(_use_item.bind(id))
		add_child(btn)
		# §2 — DISCARD, FROM THE POUCH, ANY TIME. A wasted purchase has to be
		# recoverable or one mistake at the shop follows the player for the whole
		# run. It is its own small button rather than a gesture on the one above,
		# because the button above is DISABLED for every battle-only item and for
		# every empty stack — which is exactly when a player most wants the slot
		# back.
		var drop := Button.new()
		drop.text = "Discard"
		drop.custom_minimum_size = Vector2(POUCH_BTN_W, 20)
		drop.position = Vector2(VIEW_X + 4 + i * POUCH_PITCH, 618)
		drop.add_theme_font_size_override("font_size", 10)
		drop.add_theme_color_override("font_color", Color(0.78, 0.55, 0.5))
		drop.tooltip_text = "Give up the slot and everything in it (%d %s).\nThe stack is lost." % [
			have, Run.ITEM_INFO[id][0]]
		drop.pressed.connect(Music.click)
		drop.pressed.connect(_confirm_discard.bind(id))
		add_child(drop)
	# The free slots, drawn as empty frames so the cap is visible BEFORE the
	# player is standing in a shop wondering why a button is greyed.
	for i in range(held.size(), slot_cap):
		var empty := Label.new()
		empty.text = "— empty slot —"
		empty.custom_minimum_size = Vector2(POUCH_BTN_W, 32)
		empty.position = Vector2(VIEW_X + 4 + i * POUCH_PITCH, 590)
		empty.add_theme_font_size_override("font_size", 11)
		empty.add_theme_color_override("font_color", Color(0.42, 0.40, 0.38))
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty.size = Vector2(POUCH_BTN_W, 32)
		add_child(empty)
	_draw_bag_row()


# ══ BATCH HK §2/§4 — THE BAG AND THE PARTY SLOT, ON THE MAP ═══════════════════
#
# **ONE ROW UNDER THE POUCH**, in the strip from y 644 to the screen's foot that
# nothing on this screen used. Two buttons, both opening the bag's panel: the bag's
# count (and a drop waiting on it), and the party slot — what it holds, or that it
# is empty. **Since HR §1 the bag is the crest's**, and **HR §2 puts the crest's own
# marker on it**: the count of crest runes waiting in the bag, read off the bag at
# every draw, as a hero's is read off his holding.
const BAG_ROW_Y := 648.0


func _draw_bag_row() -> void:
	var bag_btn := Button.new()
	var waiting: int = 0
	for pr in Run.pending_rune_drops:
		if Run.pending_holder(pr) < 0:
			waiting += 1
	var crest_waiting: int = 0
	for br in Run.rune_bag:
		if Runes.is_party_rune(br):
			crest_waiting += 1
	bag_btn.text = "Rune bag  %d/%d%s%s" % [Run.rune_bag.size(), Run.BAG_CAP,
		"  ✦ %d" % crest_waiting if crest_waiting > 0 else "",
		"  (+%d waiting)" % waiting if waiting > 0 else ""]
	bag_btn.set_meta("crest_marker", crest_waiting)
	bag_btn.custom_minimum_size = Vector2(230, 30)
	bag_btn.position = Vector2(VIEW_X + 4, BAG_ROW_Y)
	bag_btn.add_theme_font_size_override("font_size", 12)
	bag_btn.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	bag_btn.tooltip_text = "The crest's runes that nobody wears (%d here).\nIt holds %d. Click to see it, drop a rune,\nor fill the crest." % [crest_waiting, Run.BAG_CAP]
	bag_btn.pressed.connect(Music.click)
	bag_btn.pressed.connect(_open_bag_panel)
	add_child(bag_btn)
	var party_btn := Button.new()
	var worn_party: Array = Run.party_runes
	party_btn.text = "Crest: %s" % (String((worn_party[0] as Dictionary).get("name", ""))
		if not worn_party.is_empty() else "— empty —")
	party_btn.custom_minimum_size = Vector2(300, 30)
	party_btn.position = Vector2(VIEW_X + 244, BAG_ROW_Y)
	party_btn.add_theme_font_size_override("font_size", 12)
	party_btn.tooltip_text = ("%s\n%s" % [String((worn_party[0] as Dictionary).get("name", "")),
		Runes.shown_desc(worn_party[0])]) if not worn_party.is_empty() \
		else "The crest: one rune worn by every hero\nat once. It is empty."
	party_btn.pressed.connect(Music.click)
	party_btn.pressed.connect(_open_bag_panel)
	add_child(party_btn)


# THE BAG'S PANEL: the party slot, and every rune in the bag with the hero it is
# for and a Drop. The pouch panel's shape — a fixed rect, ONE scroller for every
# row whose height is its text, Close below it where no text can move it (GT §1).
func _open_bag_panel() -> void:
	if _bag_panel_open:
		return
	_bag_panel_open = true
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 60
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.78)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = POUCH_RECT.position
	panel.custom_minimum_size = POUCH_RECT.size
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	title.text = "THE RUNE BAG — %d of %d, the crest's" % [Run.rune_bag.size(), Run.BAG_CAP]
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var sub := Label.new()
	sub.text = "A crest rune is worn in the crest, by every hero at once. A rune dropped from here is gone for good."
	sub.add_theme_font_size_override("font_size", 12)
	sub.add_theme_color_override("font_color", Color(0.72, 0.66, 0.8))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(sub)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 6)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)

	# ══ BATCH IF §3 — THE CREST SPLITS, THE RUNE PANEL's CORE / WORN / HELD LOGIC (IE's ruling 4) ══
	#
	# THE CREST holds the one worn crest rune — its slot drawn when empty, as a core slot
	# is (IA) — and IN THE BAG holds every rune the bag holds, a crest rune with Equip (or
	# Swap, the crest filled) beside its Drop. Until IF a bagged crest rune was listed
	# twice, under THE CREST marked *(in the bag)* and again under IN THE BAG, and the worn
	# one carried ✦ as the only mark of *worn*: the sections are the state now, and a row
	# says it once. Each Equip still presses `_toggle_party_rune` by its index in
	# `Run.party_rune_rows()`, the one list the door reads.
	var prows: Array = Run.party_rune_rows()
	var p_head := Label.new()
	p_head.text = "THE CREST — %d of %d filled" % [Run.party_runes.size(), Run.PARTY_RUNE_SLOTS]
	p_head.add_theme_font_size_override("font_size", 15)
	p_head.add_theme_color_override("font_color", Color(0.95, 0.75, 0.45))
	p_head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	list.add_child(p_head)
	var bag_at := {}
	for pi in prows.size():
		var pr_d: Dictionary = prows[pi]
		if not bool(pr_d["worn"]):
			bag_at[int(pr_d["at"])] = pi
			continue
		var pr: Dictionary = pr_d["rune"]
		var prow := HBoxContainer.new()
		prow.add_theme_constant_override("separation", 10)
		list.add_child(prow)
		prow.add_child(_crest_toggle(pi, true, overlay))
		var plbl := Label.new()
		plbl.text = "%s — %s" % [String(pr.get("name", "")), Runes.shown_desc(pr)]
		plbl.add_theme_font_size_override("font_size", 12)
		plbl.add_theme_color_override("font_color", Color(0.45, 0.9, 0.5))
		plbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		plbl.custom_minimum_size = Vector2(POUCH_TEXT_W, 20)
		prow.add_child(plbl)
	for _empty in maxi(Run.PARTY_RUNE_SLOTS - Run.party_runes.size(), 0):
		_pouch_note(list, "— empty —", Color(0.5, 0.48, 0.52), true)
	if prows.is_empty():
		_pouch_note(list, "No crest rune held. A rune in the crest is worn by every hero at once.",
			Color(0.6, 0.57, 0.55), false)
	list.add_child(HSeparator.new())

	# ── THE BAG ─────────────────────────────────────────────────────────────
	var b_head := Label.new()
	b_head.text = "IN THE BAG"
	b_head.add_theme_font_size_override("font_size", 15)
	b_head.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	b_head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	list.add_child(b_head)
	if Run.rune_bag.is_empty():
		var none := Label.new()
		none.text = "The bag is empty. A crest rune that drops or is bought waits here; every other rune goes to its hero."
		none.add_theme_font_size_override("font_size", 12)
		none.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
		none.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		list.add_child(none)
	for bi in Run.rune_bag.size():
		var r: Dictionary = Run.rune_bag[bi]
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		list.add_child(row)
		var crest_row: bool = bag_at.has(bi)
		if crest_row:
			row.add_child(_crest_toggle(int(bag_at[bi]), false, overlay))
		var nm := String(r.get("name", ""))
		var armed: bool = _bag_drop_armed == nm
		var db := Button.new()
		db.text = "Sure?" if armed else "Drop"
		db.custom_minimum_size = Vector2(84, 26)
		db.add_theme_font_size_override("font_size", 11)
		db.add_theme_color_override("font_color", Color(0.95, 0.75, 0.4) if armed
			else Color(0.78, 0.55, 0.5))
		db.tooltip_text = "Drop %s for good.\n%s" % [nm,
			"Press again to confirm." if armed else "Press twice to drop it."]
		db.pressed.connect(Music.click)
		db.pressed.connect(_drop_from_bag.bind(bi, overlay))
		row.add_child(db)
		var lbl := Label.new()
		lbl.text = "%s  (for %s%s) — %s" % [nm, Run.rune_for_label(r).trim_prefix("the "),
			_stray_note(r), Runes.shown_desc(r)]
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Runes.RUNE_TINT)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl.custom_minimum_size = Vector2(POUCH_TEXT_W - (94 if crest_row else 0), 20)
		row.add_child(lbl)

	var close := Button.new()
	close.text = "Close"
	close.custom_minimum_size = Vector2(200, 38)
	close.pressed.connect(Music.click)
	close.pressed.connect(func():
		_bag_panel_open = false
		_bag_drop_armed = ""
		overlay.queue_free())
	box.add_child(close)


# BATCH IF §3 — a crest rune's toggle, worn or in the bag: Unequip, Equip, or Swap when
# the crest is filled. `pi` indexes `Run.party_rune_rows()`, which the door reads.
func _crest_toggle(pi: int, p_on: bool, overlay: Control) -> Button:
	var pb := Button.new()
	pb.custom_minimum_size = Vector2(84, 26)
	pb.add_theme_font_size_override("font_size", 11)
	pb.pressed.connect(Music.click)
	if not p_on and Run.party_runes.size() >= Run.PARTY_RUNE_SLOTS:
		pb.text = "Swap"
		pb.tooltip_text = "The crest is filled. Swap this rune\nfor the one it holds."
		pb.pressed.connect(_open_swap_chooser.bind(-1, "party", pi, overlay))
	else:
		pb.text = "Unequip" if p_on else "Equip"
		var p_why: String = Run.party_toggle_refusal(pi)
		pb.disabled = p_why != ""
		if p_why != "":
			pb.tooltip_text = p_why
		pb.pressed.connect(_toggle_party_rune.bind(pi, overlay))
	return pb


# BATCH HR §1 — a rune in the bag that is not a crest rune is a save's whose class
# no hero in this party is (`Run.bag_strays`): kept, and said so beside its name.
func _stray_note(r: Dictionary) -> String:
	if Runes.is_party_rune(r) or Run.holder_index(r) >= 0:
		return ""
	var ck := Runes.rune_class(r)
	return " — no hero here is a %s" % ck.capitalize() if ck != "" else " — no hero here can wear it"


func _reopen_bag_panel(overlay: Control) -> void:
	Run.save_run()
	overlay.queue_free()
	_bag_panel_open = false
	_draw_screen()
	_open_bag_panel()


func _toggle_party_rune(i: int, overlay: Control) -> void:
	if not Run.toggle_party_rune(i):
		return
	_reopen_bag_panel(overlay)


# First press arms, second drops — keyed by the rune's name, the Sell rows' shape.
func _drop_from_bag(bag_idx: int, overlay: Control) -> void:
	if bag_idx < 0 or bag_idx >= Run.rune_bag.size():
		_bag_drop_armed = ""
		return
	var nm := String((Run.rune_bag[bag_idx] as Dictionary).get("name", ""))
	if _bag_drop_armed != nm:
		_bag_drop_armed = nm
		overlay.queue_free()
		_bag_panel_open = false
		_open_bag_panel()
		return
	_bag_drop_armed = ""
	Run.drop_bag_rune(bag_idx)
	_toast("%s is dropped from the bag." % nm)
	# A rune waiting on the full-bag panel may fit now.
	Run.settle_pending_drops()
	_reopen_bag_panel(overlay)


# ══ BATCH HK §2 — A DROP THAT LANDS ON A FULL BAG, SHOWN BESIDE THE TWENTY ═════
#
# **THE PLAYER IS SHOWN IT AND MUST DROP SOMETHING TO TAKE IT** (ruled): the drop
# at the top with its rule, the holding below it each with a button that drops that
# one and takes the new one in its place, and — outside the scroller, where no text
# can move it — **"Leave it behind", which declines the drop itself** (ruled:
# allowed). Resolved one at a time and re-opened for the next, the pouch's swap
# offer's shape (`_check_item_offers`, CT §3), which runs first and chains here.
# A rune its holding has room for by the time this opens — a sale or a drop on the
# way — goes straight in, because a question with one answer is not asked.
#
# **BATCH HR §1 — THE PANEL IS THE HOLDING'S THE RUNE IS BOUND FOR** (`Run.pending_
# holder`): a crest rune is shown beside the bag, as HK built it; a class or core
# rune beside the runes its hero holds unworn, his `HERO_HOLD_CAP` of them — HK's
# panel made per hero, because a full holding is one hero's and the choice is his.
const FULL_BAG_RECT := Rect2(190, 30, 900, 660)


func _check_rune_drops() -> void:
	if Run.pending_rune_drops.is_empty():
		return
	if Run.settle_pending_drops() > 0:
		Run.save_run()
		_draw_screen()
		_toast("There is room now: the waiting rune goes in.")
		if Run.pending_rune_drops.is_empty():
			return
	var incoming: Dictionary = Run.pending_rune_drops[0]
	var in_name := String(incoming.get("name", ""))
	var hi: int = Run.pending_holder(incoming)
	var holder: Dictionary = Run.party[hi] if hi >= 0 else {}
	var held: Array = Run.held_rows(holder) if hi >= 0 else []
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 74
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.82)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = FULL_BAG_RECT.position
	panel.custom_minimum_size = FULL_BAG_RECT.size
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	if hi >= 0:
		title.text = "THE %s HOLDS ALL HE CAN — %d of %d" % [
			Run.nameplate(holder).to_upper(), Run.held_count(holder), Run.HERO_HOLD_CAP]
	else:
		title.text = "THE BAG IS FULL — %d of %d" % [Run.rune_bag.size(), Run.BAG_CAP]
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(title)
	var drop_lbl := Label.new()
	drop_lbl.text = "A rune has dropped: %s, for %s.\n%s" % [in_name,
		("the %s" % Run.nameplate(holder)) if hi >= 0 else Run.rune_for_label(incoming),
		Runes.shown_desc(incoming)]
	drop_lbl.add_theme_font_size_override("font_size", 14)
	drop_lbl.add_theme_color_override("font_color", Color(0.45, 0.9, 0.5))
	drop_lbl.custom_minimum_size = Vector2(FULL_BAG_RECT.size.x - 40, 0)
	drop_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(drop_lbl)
	var ask := Label.new()
	ask.text = ("To take it, drop one of the %d runes he holds unworn. Or leave it behind." % held.size()) \
		if hi >= 0 else ("To take it, drop one of the %d in the bag. Or leave it behind." % Run.rune_bag.size())
	ask.add_theme_font_size_override("font_size", 13)
	ask.add_theme_color_override("font_color", Color(0.75, 0.72, 0.68))
	ask.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(ask)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 4)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	var choices: Array = []
	if hi >= 0:
		for hr in held:
			choices.append(hr["rune"])
	else:
		choices = Run.rune_bag.duplicate()
	for bi in choices.size():
		var r: Dictionary = choices[bi]
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		list.add_child(row)
		var b := Button.new()
		b.text = "Drop this"
		b.custom_minimum_size = Vector2(96, 26)
		b.add_theme_font_size_override("font_size", 11)
		b.add_theme_color_override("font_color", Color(0.78, 0.55, 0.5))
		b.tooltip_text = "Drop %s for good,\nand take %s in its place." % [String(r.get("name", "")), in_name]
		b.pressed.connect(Music.click)
		b.pressed.connect(_take_pending_drop.bind(bi, overlay))
		row.add_child(b)
		var lbl := Label.new()
		lbl.text = "%s  (for %s%s) — %s" % [String(r.get("name", "")),
			Run.rune_for_label(r).trim_prefix("the "), _stray_note(r), Runes.shown_desc(r)]
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.add_theme_color_override("font_color", Runes.RUNE_TINT)
		lbl.custom_minimum_size = Vector2(FULL_BAG_RECT.size.x - 150, 0)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(lbl)
	var decline := Button.new()
	decline.text = "Leave %s behind" % in_name
	decline.custom_minimum_size = Vector2(400, 36)
	decline.pressed.connect(Music.click)
	decline.pressed.connect(_decline_pending_drop.bind(overlay))
	box.add_child(decline)


func _take_pending_drop(drop_idx: int, overlay: Control) -> void:
	if Run.pending_rune_drops.is_empty():
		return
	var head: Dictionary = Run.pending_rune_drops[0]
	var hi: int = Run.pending_holder(head)
	var gone := ""
	if hi >= 0:
		var held: Array = Run.held_rows(Run.party[hi])
		if drop_idx >= 0 and drop_idx < held.size():
			gone = String((held[drop_idx]["rune"] as Dictionary).get("name", ""))
	elif drop_idx >= 0 and drop_idx < Run.rune_bag.size():
		gone = String((Run.rune_bag[drop_idx] as Dictionary).get("name", ""))
	var incoming := String(head.get("name", ""))
	if not Run.take_pending_drop(drop_idx):
		return
	overlay.queue_free()
	Run.save_run()
	_draw_screen()
	if hi >= 0:
		_toast("%s is dropped. The %s holds %s now." % [gone, Run.nameplate(Run.party[hi]), incoming])
	else:
		_toast("%s is dropped. %s goes into the bag." % [gone, incoming])
	_check_rune_drops()
	_arrival_next.call_deferred()   # BATCH IB §1 — a panel the walk waited on has closed


func _decline_pending_drop(overlay: Control) -> void:
	var let_go: Dictionary = Run.decline_pending_drop()
	overlay.queue_free()
	Run.save_run()
	_draw_screen()
	if not let_go.is_empty():
		_toast("%s is left on the road." % String(let_go.get("name", "")))
	_check_rune_drops()
	_arrival_next.call_deferred()   # BATCH IB §1 — a panel the walk waited on has closed


# BATCH CT §4: four items now have no meaning outside a fight. Each stays in
# the pouch with a DISABLED button and a tooltip saying why, rather than being
# silently absent from the row — which is the BOMB's idiom.
#
# §4 said to do this "exactly as the Bomb and Defense Potion already do", and
# those are two different mechanisms, not one. The Bomb is refused HERE, by
# `_usable_on_map`, so its button never lights up. The Defense Potion's button
# is ENABLED and refuses inside `_use_item` with a toast AFTER the press. The
# Bomb's is the one that actually reads — a button you cannot press, that says
# why on hover, beats a button that looks live and then declines — so the
# three new ones follow it. The Defense Potion is left exactly as it was:
# changing it is not in this batch.
const MAP_REFUSAL := {
	"bomb": "Nothing here to throw it at — battle only.",
	"cleanse": "Nothing to cleanse between fights — battle only.",
	"visage": "There is no one here to curse — battle only.",
	"hourglass": "Nothing is waiting on a turn out here — battle only.",
}


func _usable_on_map(id: String) -> bool:
	return not MAP_REFUSAL.has(id)


func _map_item_tooltip(id: String) -> String:
	var base: String = Run.ITEM_INFO[id][1]
	if not _usable_on_map(id):
		return "%s\n\n%s" % [base, MAP_REFUSAL.get(id, "Battle only.")]
	if int(Run.items.get(id, 0)) < 1:
		return "%s\n\nNone carried — the slot is still held.\nDiscard it to free the slot." % base
	if int(Run.items.get(id, 0)) >= Run.item_stack_cap(id):
		return "%s\n\nCarrying the maximum (%d)." % [base, Run.item_stack_cap(id)]
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
		_toast("The %s only means something in a fight." % Run.ITEM_INFO["defense"][0])
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


# ---------- BATCH CT §2: discarding a slot ----------
#
# CONFIRMED, NOT INSTANT. The stack is lost and the button sits directly under
# a button the player presses to DRINK a potion, so a misclick here would cost
# a whole stack for a one-pixel error. Every other irreversible thing on this
# screen asks first.
func _confirm_discard(id: String) -> void:
	var have := int(Run.items.get(id, 0))
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 70
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.75)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(440, 264)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	var title := Label.new()
	title.text = "Discard the %s?" % Run.ITEM_INFO[id][0]
	title.add_theme_font_size_override("font_size", 17)
	title.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	box.add_child(title)
	var body := Label.new()
	body.text = "The slot comes free. %s is lost." % (
		"All %d of them" % have if have > 1 else
		("The one you carry" if have == 1 else "Nothing"))
	body.add_theme_font_size_override("font_size", 13)
	body.add_theme_color_override("font_color", Color(0.75, 0.72, 0.68))
	box.add_child(body)
	var yes := Button.new()
	yes.text = "Discard it"
	yes.custom_minimum_size = Vector2(320, 34)
	yes.pressed.connect(Music.click)
	yes.pressed.connect(func():
		overlay.queue_free()
		if Run.discard_item(id):
			Run.save_run()
			_draw_screen()
			_toast("The %s is gone. A slot comes free." % Run.ITEM_INFO[id][0]))
	box.add_child(yes)
	var no := Button.new()
	no.text = "Keep it"
	no.custom_minimum_size = Vector2(320, 32)
	no.pressed.connect(overlay.queue_free)
	box.add_child(no)


# ---------- BATCH CT §3: a drop with no room is a SWAP OFFER ----------
#
# Queued by whatever granted it (elite spoils, an event, the bargain) and
# resolved HERE, because the map is where owed picks are resolved — the same
# door `rune_picks_owed` and the draft picks come through, which this file's
# own header calls "an owed pick opens its own overlay".
#
# DECLINING IS ALWAYS A BUTTON, per the standing rule that governs events.
# Offers are resolved ONE AT A TIME and the overlay re-opens for the next, so
# a Gravelight Lantern elite handing over two unheld types asks twice rather
# than making one compound decision out of two.
func _check_item_offers() -> void:
	if Run.pending_item_offers.is_empty():
		# BATCH HK §2 — the pouch's owed choice first, then the bag's: CHAINED, on
		# the precedent the draft and this overlay already follow, so two overlays
		# never open over each other.
		_check_rune_drops()
		return
	var id := String(Run.pending_item_offers[0])
	# The pouch may have changed since the offer was queued — a discard on the
	# way here can have made the room. Take it silently in that case: an offer
	# to give something up when nothing has to be given up is a question with
	# one answer.
	if not Run.needs_slot(id):
		Run.pending_item_offers.pop_front()
		if Run.add_item(id) > 0:
			_toast("+1 %s" % Run.ITEM_INFO[id][0])
		Run.save_run()
		_draw_screen()
		# BATCH IC §3 — AND THE TAIL GOES ON: the next offer, or the full holdings after the
		# last. Returning here ended the arrival, so both waited for the next one.
		_check_item_offers()
		return
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 72
	add_child(overlay)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.8)
	overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(408, 176)
	overlay.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)
	var title := Label.new()
	title.text = "The pouch is full — %s" % Run.ITEM_INFO[id][0]
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	box.add_child(title)
	var body := Label.new()
	body.text = "%s\n\nTake it in place of which stack?" % Run.ITEM_INFO[id][1]
	body.add_theme_font_size_override("font_size", 13)
	body.add_theme_color_override("font_color", Color(0.75, 0.72, 0.68))
	body.custom_minimum_size = Vector2(400, 0)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(body)
	for held_id in Run.ITEM_IDS.filter(func(i): return Run.items.has(i)):
		var b := Button.new()
		b.text = "Give up %s  (x%d)" % [Run.ITEM_INFO[held_id][0],
			int(Run.items.get(held_id, 0))]
		b.custom_minimum_size = Vector2(400, 32)
		b.add_theme_font_size_override("font_size", 13)
		b.tooltip_text = Run.ITEM_INFO[held_id][1]
		b.pressed.connect(Music.click)
		b.pressed.connect(func():
			overlay.queue_free()
			Run.pending_item_offers.pop_front()
			if Run.swap_item(held_id, id):
				_toast("The %s goes. +1 %s." % [Run.ITEM_INFO[held_id][0],
					Run.ITEM_INFO[id][0]])
			Run.save_run()
			_draw_screen()
			# The next offer, if the same victory queued more than one.
			_check_item_offers())
		box.add_child(b)
	var decline := Button.new()
	decline.text = "Leave it behind"
	decline.custom_minimum_size = Vector2(400, 34)
	decline.pressed.connect(Music.click)
	decline.pressed.connect(func():
		overlay.queue_free()
		Run.pending_item_offers.pop_front()
		Run.save_run()
		_toast("The %s is left on the road." % Run.ITEM_INFO[id][0])
		_check_item_offers())
	box.add_child(decline)


# The map-side effects mirror the battle item table. BATCH CT §6 made the
# numbers percentages, and both sides now call the SAME `Run` helpers rather
# than each repeating a literal — which is what "Run.ITEM_INFO stays the
# single place these numbers are written" has to mean in practice, because
# the old comment claimed the two read the same 40 while each spelled it out
# separately and nothing stopped them drifting.
func _apply_item(id: String, idx: int, overlay: Control) -> void:
	overlay.queue_free()
	if int(Run.items.get(id, 0)) < 1:
		return
	var member: Dictionary = Run.party[idx]
	var line := ""
	match id:
		"health":
			var before := int(member["hp"])
			member["hp"] = mini(before + Run.health_potion_heal(int(member["max_hp"])),
				int(member["max_hp"]))
			line = "%s recovers %d HP." % [String(member["key"]).capitalize(),
				int(member["hp"]) - before]
		"mana":
			if String(member["key"]) not in ["mage", "cleric", "hunter"]:
				_toast("%s has no Mana to restore." % String(member["key"]).capitalize())
				return
			var mana_was := int(member["mana"])
			member["mana"] = mini(
				mana_was + Run.mana_potion_restore(int(member["max_mana"])),
				int(member["max_mana"]))
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


# Stepping onto a node. `j` indexes the NEXT slot's node array — the slot is
# never a choice, only which of its nodes.
func _on_node_pressed(j: int) -> void:
	# Nothing a harness drives may travel the board (Batch AC). RunSim walks
	# Run directly and never loads this scene.
	if Run.sim_run:
		return
	Run.advance(j)
	var node: Dictionary = Run.current_node()
	var ty := String(node["type"])
	# Batch BK §3/§4: three node types resolve WITHOUT a battle. They still
	# take the step — the node is spent, and the party has walked past whatever
	# stood in the columns it can no longer reach.
	match ty:
		"blacksmith":
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/blacksmith.tscn")
			return
		"merchant":
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/shop.tscn")
			return
		"event":
			if not Run.begin_event_node():
				# The pool is spent AND every survivor is gated out. Walking on
				# beats an empty screen; the node stays marked visited.
				Run.save_run()
				_draw_screen()
				_toast("The road is quiet here.")
				return
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/event.tscn")
			return
	var warband: Array = node.get("enemies", [])
	if warband.is_empty():
		warband = Run.compose(ty, Run.slot_idx + 1)
		node["theme"] = Run.last_theme
	Run.encounter = {"type": ty, "enemies": warband,
		"theme": node.get("theme", "Warband")}
	Run.arm_fixed_modifier(ty)  # BATCH BM §5: rung 3's second twist
	Run.save_run()
	# Batch AO §2: the offer is an EVENT, not a toll booth — fights and bosses
	# walk straight in, elites and mini-bosses are preceded by the bargain.
	# BATCH GF: the list is `Run.BARGAIN_NODES`, which `Run.resume_scene` reads too.
	# BATCH IR §1a — asked through `Run.offers_bargain`: a node that armed its fixed modifier
	# above (Ruin's mini-boss) offers no bargain, and walks straight in.
	if Run.offers_bargain(ty):
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
		# BATCH IH §0.2 — the readout is told, naming the action, before it runs.
		Run.note_debug(_debug_action_name(id), "on the map")
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
			# BATCH BM: there is no in-run purse to fill. The tester's
			# equivalent is a META grant — 60 points to every class (FX: the
			# purse keys to the class), past the 54 the whole tree costs —
			# plus every tier's end-boss gate open (the spend gate still applies).
			Profile.debug_grant_meta()
			_draw_screen()
			_toast("DEBUG: 60 talent points to every class, every tier's end-boss gate open")
		12:
			Run.heal_party(1.0)
			Run.restore_mana(1.0)
			_draw_screen()
		13:
			# Walk the board forward, taking the first reachable node each
			# column, until the boss is the next pick. On a lattice there is no
			# "set slot_idx" — advance() is the only mover, and a debug entry
			# that bypassed it would place the party on a node nothing links to.
			while Run.slot_idx < Run.BOSS_SLOT - 1:
				var step: Array = Run.reachable()
				if step.is_empty():
					break
				Run.advance(int(step[0]))
			_map_scroll = -1.0
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
			# BATCH HJ §3: it grants each hero his CLASS's one draft pool and
			# his lineage's boss pool (it was his lineage's alone from AU §5) —
			# the toast says so, or a tester waits for a sibling's boss card
			# that is deliberately never coming.
			_toast("DEBUG: each hero's class pool and boss cards %s" % (
				"UNLOCKED for every battle" if Run.debug_grant_all else "gated again"))
		20:
			Run.debug_free_travel = not Run.debug_free_travel
			_draw_screen()
			_toast("DEBUG: free travel %s" % ("ON — every node in the next column is clickable"
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


# BATCH IH §0.2 — THE MAP's DEBUG ITEMS BY WHAT EACH DOES, for the readout — the talent grant by
# its toast's words, a check item by the state it moves to (read before the dispatch flips it).
func _debug_action_name(id: int) -> String:
	match id:
		10:
			return "+200 Gold"
		11:
			return "60 talent points to every class, every tier's end-boss gate open"
		12:
			return "Full Heal Heroes"
		13:
			return "Jump to Boss Slot"
		14:
			return "Advance to Next Zone"
		15:
			return "Reroll Specs"
		16:
			return "All Class Abilities Unlocked: %s" % ("off" if Run.debug_grant_all else "on")
		20:
			return "Free Travel: %s" % ("off" if Run.debug_free_travel else "on")
		21:
			return "Test a node: Shop"
		23:
			return "Test a node: ??? Event (the picker)"
		24:
			return "Test a node: Fight"
		25:
			return "Test a node: Elite"
		26:
			return "Test a node: Mini-boss"
	if id >= PICKER_ID_BASE:
		var ids := _event_picker_ids()
		var pick := id - PICKER_ID_BASE
		if pick < ids.size():
			return "Test a node: event %s" % String(Events.config(ids[pick]).get("title", ids[pick]))
	return "debug item %d" % id


# Debug spec swap: clear the specs and re-awaken. BATCH BM removed the refund
# arithmetic with the purse it refunded into — a spec's talents are its META
# loadout now, so re-awakening simply re-equips whatever the profile holds.
func _debug_reroll_specs() -> void:
	for member in Run.party:
		member["spec"] = ""
		member["talents"] = {}
		member["tree"] = []
		# BATCH GK — the engines were the choice, so they are what a reroll undoes.
		member["engines"] = []
		member["awakened"] = false
		member.erase("engine_offer")
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


# BATCH IS §2a — A TOAST WRAPS. It was one line, 1,280 px wide with no wrap, so a sentence past the screen's width
# was cut at both ends — and the arrival toast joins every note a load had to say (`_announce_arrival`), which is
# where a card the game no longer has is said. A short toast reads as it always did; a long one takes a second
# line instead of losing its ends (GT §1: make room, shrink nothing). IH §0's order: parent it, size it, then words.
func _toast(text: String) -> void:
	var label := Label.new()
	label.set_meta("toast", true)
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.6))
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.z_index = 50
	add_child(label)
	label.position = Vector2(40, 100)
	label.size = Vector2(1200, 26)
	label.text = text
	var tween := create_tween()
	tween.tween_interval(1.4)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
