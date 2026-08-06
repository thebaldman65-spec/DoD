# Spire-style run map: pick a node on the next floor to travel there.
# Combat nodes jump straight into battle; rest/treasure resolve in place.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

const NODE_LABELS := {
	"fight": "Fight", "elite": "ELITE", "rest": "Rest",
	"treasure": "Loot", "boss": "BOSS", "shop": "Shop",
	"event": "???", "miniboss": "WARDEN",
}
const NODE_COLORS := {
	"fight": Color(0.75, 0.72, 0.65), "elite": Color(0.95, 0.55, 0.3),
	"rest": Color(0.5, 0.85, 0.55), "treasure": Color(0.95, 0.85, 0.4),
	"boss": Color(0.9, 0.3, 0.35), "shop": Color(0.5, 0.8, 0.95),
	"event": Color(0.78, 0.55, 0.95),
	# Between the elite's orange and the boss's red, because that is exactly
	# where the node sits.
	"miniboss": Color(0.95, 0.42, 0.32),
}

# Debug-only-reachable nodes (Batch AC) wear this outline — a colour no
# node type and no node state uses, so the fourth read is never mistaken
# for one of the three real ones.
const DEBUG_OUTLINE := Color(1.0, 0.35, 0.85)
# Burger ids: 0-3 are the real entries, 10-16 the pre-AC debug block,
# 20-26 the summon block, and 100+ one per event in the picker.
const PICKER_ID_BASE := 100


func _ready() -> void:
	if not Run.active:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu.tscn")
		return
	# Every summoned node that leaves the map (shop, event, fight, elite)
	# comes back HERE, so this is where the summon flag is put down. The
	# rest resolves in place and clears it itself.
	Run.debug_summon = false
	Music.play("map")
	_draw_screen()
	if not _maybe_show_framing():
		_maybe_nudge_runes()


# First-run orientation (Batch Z): a skippable framing card between the
# draft and the first map — what a run IS. Once ever (Profile flag, set on
# dismissal so quitting mid-card re-shows it). Sims never load this scene
# (RunSim walks Run directly), and the sim_run guard keeps it that way if
# one ever does.
func _maybe_show_framing() -> bool:
	if Run.floor_idx >= 0 or Run.sim_run or Profile.flag("run_framing_seen"):
		return false
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.72)
	dim.z_index = 90
	add_child(dim)
	var panel := PanelContainer.new()
	panel.position = Vector2(340, 200)
	panel.z_index = 91
	add_child(panel)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)
	var title := Label.new()
	title.text = "THE CLIMB"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	var body := Label.new()
	body.text = ("A run climbs this map one node at a time: 10 tiers, then the\n" +
		"zone boss at the top. Kill the boss and the party descends into the\n" +
		"next zone — three zones stand between you and the end of the run.\n\n" +
		"Halfway up, the whole tier is one MINI-BOSS — there is no way\n" +
		"around it. It and the zone boss each let every hero choose a NEW\n" +
		"ABILITY on the Party screen: two a zone, six across a run.\n\n" +
		"Death ends the run and takes everything with it — gold, talents,\n" +
		"runes. But every boss you fell leaves a RELIC behind, unlocked\n" +
		"forever and yours to carry into the next attempt.\n\n" +
		"Hover any node to scout it before you commit.")
	body.add_theme_font_size_override("font_size", 15)
	body.add_theme_color_override("font_color", Color(0.85, 0.82, 0.75))
	vbox.add_child(body)
	var btn := Button.new()
	btn.text = "Begin the climb"
	btn.custom_minimum_size = Vector2(220, 44)
	btn.pressed.connect(Music.click)
	btn.pressed.connect(func():
		Profile.set_flag("run_framing_seen")
		dim.queue_free()
		panel.queue_free()
		_maybe_nudge_runes())
	vbox.add_child(btn)
	return true


# Batch AE: the opening rune pick is dealt on the spec screen and waits on
# the Party screen, so the map is where a player first has the chance to
# walk past it. The pulsing Party badge is the persistent affordance; this
# is the push that makes the FIRST map unmissable. Per run, not once ever
# (the card above is a tutorial, this is live state), and it chains off the
# framing card's dismissal so the two never talk over each other.
func _maybe_nudge_runes() -> void:
	if Run.sim_run or Run.floor_idx >= 0 or Run.owed_rune_picks() < 1:
		return
	_toast("Each hero has a rune to choose — open the Party screen.")


func _node_pos(f: int, i: int) -> Vector2:
	# 11 rows (10 tiers + boss) stacked from y=620 up to y=100.
	var row_size: int = Run.map[f].size()
	var x := 640.0 + (i - (row_size - 1) / 2.0) * 220.0
	var y := 620.0 - f * 52.0
	return Vector2(x, y)


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)
	# Zone art behind the map, dimmed so nodes stay readable.
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
	dim.color = Color(0.05, 0.04, 0.08, 0.55)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)

	var title := Label.new()
	title.text = Run.zone_name
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 44)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 14)
	title.size = Vector2(1280, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	# The ladder readout (Batch Y): a tester should never count rows to
	# know how far in they are — or what waits at the top.
	var boss_name: String = Enemies.unit_name(Run.boss_kind())
	var subtitle := Label.new()
	if Run.floor_idx < 0:
		subtitle.text = "10 tiers stand between you and the %s" % boss_name
	else:
		subtitle.text = "Tier %d of 10 — the %s waits" % [
			mini(Run.floor_idx + 1, 10), boss_name]
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.72, 0.64, 0.52))
	subtitle.position = Vector2(0, 62)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	var party_parts := PackedStringArray()
	for member in Run.party:
		var part := "%s %d/%d" % [member["key"].capitalize(), member["hp"], member["max_hp"]]
		if member["key"] != "warrior":
			part += " (%d MP)" % member["mana"]
		party_parts.append(part)
	var status := Label.new()
	status.text = "Gold: %d      %s" % [Run.gold, "   ".join(party_parts)]
	status.add_theme_font_size_override("font_size", 14)
	status.add_theme_color_override("font_color", Color(0.75, 0.72, 0.65))
	status.position = Vector2(0, 690)
	status.size = Vector2(1280, 20)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status)

	# Top tabs: Party (own screen) and Inventory (dropdown).
	var party_btn := Button.new()
	var unspent := 0
	for member in Run.party:
		unspent += member.get("talent_points", 0)
	# Batch AE: owed rune picks badge the same button unspent points do —
	# the existing affordance, not a new one. A start pick that sits
	# unnoticed on the Party screen would defeat the entire point of
	# choosing a FRONT-LOADED lever, so when runes are owed the badge takes
	# the rune purple (which outranks the talent gold) and the button
	# breathes until the picks are spent.
	var owed := Run.owed_rune_picks()
	# Batch AH: owed ABILITY picks badge the same button for the same reason
	# — two a zone is the batch's whole progression curve, and a pick left
	# unchosen is a hero fighting the next tier a third weaker than intended.
	var owed_abs := Run.owed_ability_picks()
	var badges := PackedStringArray()
	if unspent > 0:
		badges.append("%d pts!" % unspent)
	if owed_abs > 0:
		badges.append("%d abilities!" % owed_abs)
	if owed > 0:
		badges.append("%d runes!" % owed)
	party_btn.text = "Party" if badges.is_empty() \
		else "Party  (%s)" % " · ".join(badges)
	# Colour precedence: rune purple over ability gold over talent gold —
	# the same "loudest unspent thing wins" rule Batch AE set.
	if owed > 0:
		party_btn.modulate = Color(0.85, 0.6, 1.0)
	elif owed_abs > 0:
		party_btn.modulate = Color(0.95, 0.85, 0.4)
	elif unspent > 0:
		party_btn.modulate = Color(1.0, 0.9, 0.45)
	party_btn.custom_minimum_size = Vector2(150, 42)
	party_btn.position = Vector2(20, 16)
	party_btn.pressed.connect(Music.click)
	party_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/party.tscn"))
	add_child(party_btn)
	if owed > 0 or owed_abs > 0:
		# Bound to the button, so the redraw that clears the owed count
		# takes the pulse with it.
		var pulse := create_tween().bind_node(party_btn).set_loops()
		pulse.tween_property(party_btn, "modulate:a", 0.5, 0.55)
		pulse.tween_property(party_btn, "modulate:a", 1.0, 0.55)

	var burger := MenuButton.new()
	burger.text = "☰"
	burger.custom_minimum_size = Vector2(52, 42)
	burger.position = Vector2(180, 16)
	burger.flat = false
	var bpop := burger.get_popup()
	bpop.add_item("Restart Run", 0)
	bpop.add_item("Glossary", 3)
	bpop.add_item("Quit to Main Menu", 1)
	bpop.add_item("Quit to Desktop", 2)
	# Testing shortcuts (always on in dev builds).
	if Run.debug_enabled():
		bpop.add_separator("DEBUG")
		bpop.add_item("+200 Gold", 10)
		bpop.add_item("+200 Talent Points (all)", 11)
		bpop.add_item("Full Heal Party", 12)
		bpop.add_item("Jump to Boss Tier", 13)
		bpop.add_item("Advance to Next Zone", 14)
		bpop.add_item("Reroll Specs", 15)
		# Review aid: battles spawn with every talent/trophy ability
		# pre-granted while checked (session-scoped, never saved).
		bpop.add_check_item("All Spec Abilities Unlocked", 16)
		bpop.set_item_checked(bpop.get_item_index(16), Run.debug_grant_all)
		# Batch AC — new ids start at 20 so nothing collides with 10-16.
		# Free Travel opens the whole board; "Test a node" runs one in
		# place without moving the party at all.
		bpop.add_check_item("Free Travel", 20)
		bpop.set_item_checked(bpop.get_item_index(20), Run.debug_free_travel)
		var summon := PopupMenu.new()
		summon.name = "TestANode"
		summon.add_item("Shop", 21)
		summon.add_item("Rest", 22)
		summon.add_item("??? Event", 23)
		summon.add_item("Fight", 24)
		summon.add_item("Elite", 25)
		summon.add_item("Mini-boss", 26)
		# Boss deliberately absent: "Jump to Boss Tier" (13) already goes
		# there, and a second path to the same place is a second thing to
		# keep working.
		summon.id_pressed.connect(_on_burger)
		# The submenu PARENT needs an explicit id: left to auto-assign it
		# takes its item INDEX, which lands on 13 — "Jump to Boss Tier".
		# 9 is deliberately below the debug block, because opening a
		# submenu is not yet using a debug tool.
		bpop.add_submenu_node_item("Test a node", summon, 9)
	bpop.id_pressed.connect(_on_burger)
	add_child(burger)

	var inv := MenuButton.new()
	inv.text = "Inventory ▾"
	inv.custom_minimum_size = Vector2(140, 42)
	inv.position = Vector2(1120, 16)
	inv.flat = false
	var popup := inv.get_popup()
	for i in Run.ITEM_IDS.size():
		var id: String = Run.ITEM_IDS[i]
		popup.add_item("%s  x%d" % [Run.ITEM_INFO[id][0], Run.items.get(id, 0)], i)
		popup.set_item_tooltip(i, Run.ITEM_INFO[id][1])
		popup.set_item_disabled(i, true)  # display only; items are used in battle
	add_child(inv)

	# Path lines first so nodes draw over them. The roads out of the
	# party's current node glow — "these are my options" should be the
	# first read of the screen, not a deduction.
	for f in Run.FLOORS - 1:
		for i in Run.map[f].size():
			var from_here: bool = f == Run.floor_idx and i == Run.node_idx
			for j in Run.map[f][i]["links"]:
				var line := Line2D.new()
				line.add_point(_node_pos(f, i))
				line.add_point(_node_pos(f + 1, j))
				line.width = 5.0 if from_here else 3.0
				line.default_color = Color(0.85, 0.72, 0.35, 0.9) if from_here \
					else Color(0.32, 0.28, 0.38, 0.5)
				add_child(line)

	var next_floor := Run.floor_idx + 1
	var reachable := Run.reachable()
	var free_travel: bool = Run.debug_enabled() and Run.debug_free_travel
	for f in Run.FLOORS:
		for i in Run.map[f].size():
			var node: Dictionary = Run.map[f][i]
			var btn := Button.new()
			btn.text = NODE_LABELS[node["type"]]
			btn.custom_minimum_size = Vector2(92, 36)
			btn.position = _node_pos(f, i) - Vector2(46, 18)
			var is_reachable: bool = f == next_floor and reachable.has(i)
			# Batch AC: Free Travel makes every OTHER node clickable too.
			# A tester must never confuse a debug-reachable node with a
			# genuinely reachable one, or they will report their own toggle
			# as a bug — so this is a FOURTH read, not a third with an
			# ambiguity: the debug outline plus a desaturated fill.
			var debug_only: bool = free_travel and not is_reachable
			btn.disabled = not (is_reachable or debug_only)
			if debug_only:
				_add_debug_outline(btn.position)
			# Three states, three clearly separate reads (Batch Y): visited
			# is history (dim green), reachable is an option (full node
			# colour, bigger), everything else recedes into the dark.
			if node["visited"]:
				btn.modulate = Color(0.48, 0.66, 0.48)
			elif is_reachable:
				btn.modulate = NODE_COLORS[node["type"]]
				btn.add_theme_font_size_override("font_size", 17)
			elif debug_only:
				btn.modulate = _debug_tint(NODE_COLORS[node["type"]])
			else:
				btn.modulate = Color(0.42, 0.40, 0.47)
			btn.pressed.connect(Music.click)
			btn.pressed.connect(_on_node_pressed.bind(f, i))
			# Scouting hover: combat nodes reveal their warband and what it
			# resists / crumples to; non-combat nodes state what they do
			# (Batch Y) — the event alone stays a deliberate mystery, and
			# says so instead of saying nothing.
			if node.has("enemies"):
				btn.tooltip_text = _warband_tooltip(node)
			else:
				match String(node["type"]):
					"rest":
						btn.tooltip_text = ("Waystone: the party rests, " +
							"recovering %d%% HP and Mana.") % int(round(
							(0.3 + Run.relic_add("rest_heal_add")) * 100))
					"shop":
						btn.tooltip_text = ("The Peddler: consumables, and " +
							"a rune offer for each hero.")
					"event":
						btn.tooltip_text = ("No scout returns with the same " +
							"story. What waits here is unknown.")
			if debug_only:
				btn.tooltip_text = "[DEBUG] " + (btn.tooltip_text \
					if btn.tooltip_text != "" \
					else "Free Travel: no road leads here from the party.")
			add_child(btn)

	# The toggle can never be on unnoticed.
	if free_travel:
		var marker := Label.new()
		marker.text = "DEBUG: FREE TRAVEL"
		marker.add_theme_font_size_override("font_size", 13)
		marker.add_theme_color_override("font_color", DEBUG_OUTLINE)
		marker.add_theme_constant_override("outline_size", 3)
		marker.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		marker.position = Vector2(20, 656)
		marker.z_index = 40
		add_child(marker)


# A hollow frame behind a node button, in a colour nothing else on the map
# uses (Batch AC).
func _add_debug_outline(at: Vector2) -> void:
	var frame := Panel.new()
	frame.position = at - Vector2(4, 4)
	frame.size = Vector2(100, 44)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.draw_center = false
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.border_width_top = 2
	sb.border_width_bottom = 2
	sb.border_color = DEBUG_OUTLINE
	sb.corner_radius_top_left = 4
	sb.corner_radius_top_right = 4
	sb.corner_radius_bottom_left = 4
	sb.corner_radius_bottom_right = 4
	frame.add_theme_stylebox_override("panel", sb)
	add_child(frame)


# The node's own colour, pulled toward grey and dimmed: readable as "this
# is a shop / a rest / an elite", never readable as "this is an option".
func _debug_tint(c: Color) -> Color:
	var grey := (c.r + c.g + c.b) / 3.0
	return Color(lerpf(c.r, grey, 0.65) * 0.82, lerpf(c.g, grey, 0.65) * 0.82,
		lerpf(c.b, grey, 0.65) * 0.82)


func _on_node_pressed(f: int, i: int) -> void:
	# Nothing a harness drives may travel the board (Batch AC). RunSim walks
	# Run directly and never loads this scene, so this is the belt to that
	# braces — free travel must not become a second way in.
	if Run.sim_run:
		return
	var node: Dictionary = Run.map[f][i]
	Run.advance(f, i)
	match node["type"]:
		"rest":
			# Cairnmoss Poultice and kin deepen the waystone's rest.
			var rest_pct := 0.3 + Run.relic_add("rest_heal_add")
			Run.heal_party(rest_pct)
			Run.restore_mana(rest_pct)
			Run.tally_add("rests")
			Run.save_run()
			_draw_screen()
			_toast("The party rests by the waystone (+%d%% HP & Mana)"
				% int(round(rest_pct * 100)))
		"treasure":
			var id := Run.random_loot()
			Run.items[id] = Run.items.get(id, 0) + 1
			Run.save_run()
			_draw_screen()
			_toast("Scavenged a %s!" % Run.ITEM_INFO[id][0])
		"shop":
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/shop.tscn")
		"event":
			# Events are drawn at the door, never pre-rolled — "???" nodes
			# stay a mystery on the map (unlike scoutable warbands).
			Run.pending_event = Events.pick(Run)
			if Run.pending_event == "":
				Run.save_run()
				_draw_screen()
				_toast("The road is quiet. Nothing happens.")
			else:
				Run.seen_events.append(Run.pending_event)
				Profile.note_event(Run.pending_event)
				Run.save_run()
				get_tree().change_scene_to_file("res://scenes/event.tscn")
		_:
			# Pre-rolled at map birth; saves from before that compose here.
			var warband: Array = node.get("enemies", [])
			if warband.is_empty():
				warband = Run.compose(node["type"])
				node["theme"] = Run.last_theme
			Run.encounter = {"type": node["type"], "enemies": warband,
				"theme": node.get("theme", "Warband")}
			get_tree().change_scene_to_file("res://scenes/battle.tscn")


var _burger_id_this_frame := -1
var _picker: Control = null


func _on_burger(id: int) -> void:
	# One press must never resolve twice. Godot may or may not deliver a
	# SUBMENU press to the parent popup as well (both are connected here,
	# and PopupMenu.activate_item cannot be driven headlessly to find out),
	# and a doubled "Test a node ▸ Rest" would heal the party twice. A
	# repeat of the same id inside one frame is dropped; a human cannot
	# click twice in a frame, so nothing real is lost.
	if id == _burger_id_this_frame:
		return
	_burger_id_this_frame = id
	set_deferred("_burger_id_this_frame", -1)
	# THE honesty write site for the whole map DEBUG block (Batch AC).
	# Every debug id passes through this one dispatch — the pre-AC items at
	# 10-16, this batch's at 20-25, and every event in the picker at 100+ —
	# so a debug item added later cannot forget to mark the run, and the
	# check items trip the flag when toggled on (unchecking never clears
	# it: a run that was debug-touched stays debug-touched).
	# It is also the second gate. The DEBUG section is not BUILT unless
	# debug_enabled(), but firing an id straight into this function has to
	# fail the same way the missing menu does.
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
		10:  # DEBUG entries below
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
			# Land on the last pre-boss tier so the boss is the next pick.
			Run.advance(Run.FLOORS - 2, 0)
			_draw_screen()
		14:
			Run.advance_zone()
			Run.save_run()
			_draw_screen()
		16:
			Run.debug_grant_all = not Run.debug_grant_all
			_draw_screen()
			_toast("DEBUG: all spec abilities %s" % (
				"UNLOCKED for every battle" if Run.debug_grant_all else "gated again"))
		15:
			# Debug spec swap: refund spent points, clear specs, re-awaken.
			for member in Run.party:
				var learned: Dictionary = member.get("talents", {})
				var spent := 0
				for talent_id in learned:
					spent += int(learned[talent_id])
				member["talent_points"] = member.get("talent_points", 0) + spent
				member["spec"] = ""
				member["talents"] = {}
				member["tree"] = []
			Run.specs_chosen = false
			Run.save_run()
			get_tree().change_scene_to_file("res://scenes/spec_choice.tscn")
		20:
			Run.debug_free_travel = not Run.debug_free_travel
			_draw_screen()
			_toast("DEBUG: free travel %s" % ("ON — every node is clickable"
				if Run.debug_free_travel else "off"))
		21:
			_summon("shop")
		22:
			_summon("rest")
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


# ---------- Batch AC: summoning a node in place ----------

# Free travel only reaches what the deal put on the board. This reaches
# what it did not: a node type entered IN PLACE. The party does not move,
# floor_idx/node_idx are untouched and nothing is marked visited, so the
# board is exactly as it was when the tester comes back. Everything else
# runs for real — a summoned shop has real offers and spends real gold, a
# summoned rest heals for real, a summoned fight is a real battle at the
# tier the party is actually standing on.
func _summon(node_type: String) -> void:
	var next := _begin_summon(node_type)
	if next != "":
		get_tree().change_scene_to_file(next)


# Arms the summoned node and returns the scene it needs, or "" when it
# resolved in place. Split from the scene change so a headless test can
# prove the arming — the warband rolled, the board untouched — inside a
# tree that has no current scene to swap.
func _begin_summon(node_type: String) -> String:
	Run.debug_summon = true
	match node_type:
		"rest":
			var rest_pct := 0.3 + Run.relic_add("rest_heal_add")
			Run.heal_party(rest_pct)
			Run.restore_mana(rest_pct)
			Run.save_run()
			# Resolves without leaving the map, so it puts the flag down
			# itself — every other summon clears it in _ready on return.
			Run.debug_summon = false
			_draw_screen()
			_toast("[DEBUG] Summoned rest: +%d%% HP & Mana (not counted in the run)"
				% int(round(rest_pct * 100)))
			return ""
		"shop":
			Run.save_run()
			return "res://scenes/shop.tscn"
	# The SAME call the map generator makes to roll a node warband
	# (run_state._generate_map), at the current tier by default — so a
	# summoned fight is budgeted and scaled exactly like the one sitting on
	# the board next to the party, and there is still exactly one warband
	# generator in the project.
	Run.encounter = {"type": node_type, "enemies": Run.compose(node_type),
		"theme": Run.last_theme}
	return "res://scenes/battle.tscn"


# Alphabetical by title — the list will grow, and a designer looking for
# one event should not have to know its id first.
func _event_picker_ids() -> Array:
	var ids: Array = Events.ids().duplicate()
	ids.sort_custom(func(a, b): return String(Events.config(a).get("title", a)) \
		< String(Events.config(b).get("title", b)))
	return ids


# The single highest-value item in the batch: today a SPECIFIC event
# cannot be tested at all. Events.pick draws at the door, filters by
# requirement and never repeats within a run, so three visits exhaust a
# zone and the designer never chooses what they see. This lists every
# event in data/events.json and addresses it by id.
func _open_event_picker() -> void:
	# One picker at a time: a second one stacked on the first reads as a
	# frozen screen, and a tester would rightly report it as a bug.
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
		# Pass/fail comes from the SAME check that filters the real draw
		# (Events.failed_reason — requires_met is that function read as a
		# boolean), so this column can never disagree with the game.
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
# anything: no Run.seen_events append (testing must not burn the pool a
# real run draws from) and no Profile.note_event.
func _summon_event(id: String) -> void:
	Run.debug_summon = true
	Run.pending_event = id
	get_tree().change_scene_to_file("res://scenes/event.tscn")


# The hover card for a combat node: theme, lineup, and the warband's
# damage-type identity — how many units resist a type and how many are
# vulnerable to it ("Resists: Nature x3 / Soft to: Fire x2").
func _warband_tooltip(node: Dictionary) -> String:
	var kinds: Array = node["enemies"]
	var counts := {}
	for kind in kinds:
		counts[kind] = int(counts.get(kind, 0)) + 1
	var name_parts := PackedStringArray()
	for kind in counts:
		var label: String = Enemies.unit_name(kind)
		if counts[kind] > 1:
			label = "%dx %s" % [counts[kind], label]
		name_parts.append(label)
	# Units resisting / vulnerable per damage type, counted so one odd
	# member never masquerades as the whole band's identity. Token trims
	# (the 5-15% physical hides) stay off the card — only resists that
	# change a fight plan (25%+) count; every vulnerability counts.
	var resist_units := {}
	var vuln_units := {}
	for kind in kinds:
		var res: Dictionary = Enemies.resists_for(kind)
		for dtype in res:
			if float(res[dtype]) >= 0.2:
				resist_units[dtype] = int(resist_units.get(dtype, 0)) + 1
			elif float(res[dtype]) < 0.0:
				vuln_units[dtype] = int(vuln_units.get(dtype, 0)) + 1
	var text := "%s\n%s" % [String(node.get("theme", "Warband")),
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
