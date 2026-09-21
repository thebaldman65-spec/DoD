# CLASS SELECTION — BATCH GK: THE DRAFT OF THREE ENGINES.
#
# After the draft screen, before the first battle, each hero is DEALT THREE of
# his class's engine runes and TAKES ONE (the engine rune charter, `CLAUDE.md`).
# The deal is frozen on the member (`Run.deal_engines`), so redrawing this screen
# for the next hero does not re-deal the last. What is taken is his to keep, drop
# or swap from the map, and a second can join it from the ordinary rune pool.
#
# **THE SPEC THE TAKEN ENGINE CARRIED IS THE HERO'S LINEAGE** — the key the
# unmerged layers still read: his opening kit, his stat block and his boss pool.
# (His draft pool merged into the class's at GP, and his runes at HC §1.) A spine
# taken here leaves him none, and he opens with his class kit. `Run.awaken` is
# the one door; the sim uses it too.
#
# **BATCH GQ — EACH CARD SAYS ONLY WHAT DIFFERS.** A card is the rune's name, its
# engine rule, and — for a rune that carries a lineage — the abilities it opens
# with that the kit below does not show, by name. What is true of all three is
# drawn ONCE, below them: the class's basic attack and class kit, at the figures
# of a hero holding no engine. The spec's archetype line and blurb are gone from
# the card; `SPEC_INFO` keeps both fields, and the archetype still sets the
# lineage's Attack through its role.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")
# The card's text window, sized at GQ against every rune's text so that no card
# scrolls and the kit still fits under the cards on a 720px screen — `check_gq`
# re-measures both on every battery. A text that outgrows it scrolls in it; the
# text is never shrunk to fit.
const CARD_SCROLL_H := 280
const ROW_W := 1100


func _ready() -> void:
	# The awakening is still part of party setup — keep the menu track rolling.
	Music.play("menu")
	_draw_screen()


# The first hero who has not yet taken an engine. A spine leaves a hero with no
# spec, so `spec == ""` no longer means "not yet chosen"; `awakened` does.
func _next_unawakened() -> int:
	for i in Run.party.size():
		if not bool(Run.party[i].get("awakened", false)):
			return i
	return -1


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var idx := _next_unawakened()
	if idx == -1:
		_finish_and_fade()
		return

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.08, 0.06, 0.10)
	add_child(bg)

	var member: Dictionary = Run.party[idx]
	var key := String(member["key"])
	var title := Label.new()
	title.text = "The %s Awakens" % key.capitalize()
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 30)
	title.size = Vector2(1280, 52)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	# PROPOSED WORDS (GK). The old line promised the choice was "permanent for
	# the run", which the charter makes false: an engine can be dropped or swapped.
	var subtitle := Label.new()
	subtitle.text = "Take one of three engine runes — a second can join it later, and either can be dropped (hero %d of %d)" % [
		idx + 1, Run.party.size()]
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
	subtitle.position = Vector2(0, 86)
	subtitle.size = Vector2(1280, 20)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(subtitle)

	# The class passive rides along on every engine this class can take.
	var class_p: Dictionary = Classes.CLASS_PASSIVES[key]
	var passive_line := Label.new()
	passive_line.text = "Class Passive — %s: %s" % [class_p["name"],
		class_p["desc"].replace("\n", " ")]
	passive_line.add_theme_font_size_override("font_size", 14)
	passive_line.add_theme_color_override("font_color", Color(0.82, 0.74, 0.55))
	passive_line.position = Vector2(0, 110)
	passive_line.size = Vector2(1280, 20)
	passive_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(passive_line)

	var back := Button.new()
	back.text = "< Back to Draft"
	back.custom_minimum_size = Vector2(150, 42)
	back.position = Vector2(20, 16)
	back.pressed.connect(func():
		Run.active = false
		get_tree().change_scene_to_file("res://scenes/draft.tscn"))
	add_child(back)

	var dealt: Array = Run.deal_engines(member)
	# THE HERO BEFORE HE TAKES ANYTHING: his class basic and class kit, off the
	# one builder the battle reads, at the class's own Attack. It is what every
	# card would otherwise repeat, so it is drawn once, below the cards.
	var base_atk := int(Classes.hero_config(key)["attack"])
	var shared: Array = Classes.opening_kit(key, "", [])
	# The cards and the kit stack in one column, so the kit sits under the
	# cards however tall the card's name renders.
	var column := VBoxContainer.new()
	column.position = Vector2(90, 140)
	column.add_theme_constant_override("separation", 12)
	add_child(column)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 40)
	column.add_child(row)
	for i in dealt.size():
		var rune_id := String(dealt[i])
		var rcfg: Dictionary = Runes.config(rune_id)
		var pid := String(rcfg.get("engine", ""))
		var lineage := Classes.engine_spec(pid)
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(340, 0)
		row.add_child(panel)
		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 10)
		panel.add_child(vbox)
		var name_label := Label.new()
		name_label.text = Runes.display_name(rcfg)
		name_label.add_theme_font_override("font", NAME_FONT)
		name_label.add_theme_font_size_override("font_size", 28)
		name_label.add_theme_color_override("font_color", Color(0.9, 0.82, 0.6))
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(name_label)
		var scroll := ScrollContainer.new()
		scroll.custom_minimum_size = Vector2(316, CARD_SCROLL_H)
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		vbox.add_child(scroll)
		var body := Label.new()
		var atk := Classes.spec_attack(lineage) if lineage != "" else base_atk
		# BATCH CL §1 — this screen has an Attack and no hero, so Attack tokens
		# resolve and health tokens correctly stand as bare percentages. The
		# rule is the rune's hero's, so it resolves at his lineage's Attack.
		var vctx := {"attack": atk}
		# BATCH CL §7 — `passive_desc` is flattened here, where it soft-wraps.
		var engine_text := Classes.resolve_values(Classes.engine_desc(pid),
			vctx).replace("\n", " ")
		body.text = "Engine: %s" % engine_text
		var adds := _adds(key, lineage, pid, shared)
		if adds != "":
			# PROPOSED WORDS (GQ).
			body.text += "\n\nAlso opens with: %s" % adds
		# BATCH HB §4 — AND WHAT IT OPENS WITHOUT: the Sharpshooter dismisses the
		# pet, so his card leaves Summon Companion out of the kit drawn below it.
		# Derived off the same builder, so a rune that dismisses nothing says
		# nothing. PROPOSED WORDS (HB), on GQ's shape.
		var leaves := _leaves(key, lineage, pid, shared)
		if leaves != "":
			body.text += "\n\nOpens without: %s" % leaves
		body.add_theme_font_size_override("font_size", 12)
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.custom_minimum_size = Vector2(298, 0)
		body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll.add_child(body)
		var choose := Button.new()
		choose.text = "Walk this path"
		choose.custom_minimum_size = Vector2(200, 44)
		choose.pressed.connect(_choose.bind(idx, rune_id))
		vbox.add_child(choose)
	# (choose buttons play the click inside _choose)
	_draw_kit(column, key, shared, base_atk, dealt)


# What a rune opens with that the kit below does not, by name and in the order
# his bar holds them — since GS §1, the engine's enablers and nothing else.
# **GQ WROTE AN "in place of" CLAUSE HERE** for a lineage whose basic-attack
# override took slot 0 from the class basic; GS §1 ended every override, so every
# hero opens on the class basic the kit below shows and the clause had nothing
# left to say.
static func _adds(key: String, lineage: String, pid: String, shared: Array) -> String:
	var own: Array = Classes.opening_kit(key, lineage, [pid])
	var shared_names: Array = shared.map(func(a): return a.display_name)
	var parts := PackedStringArray()
	for ab in own:
		if not shared_names.has(ab.display_name):
			parts.append(ab.display_name)
	return ", ".join(parts)


# BATCH HB §4 — the other direction of `_adds`: what the kit below holds that
# this rune's hero does NOT open with. Since HB that is Summon Companion for the
# Sharpshooter's rune and nothing for any other.
static func _leaves(key: String, lineage: String, pid: String, shared: Array) -> String:
	var own_names: Array = Classes.opening_kit(key, lineage, [pid]).map(
		func(a): return a.display_name)
	var parts := PackedStringArray()
	for ab in shared:
		if not own_names.has(ab.display_name):
			parts.append(ab.display_name)
	return ", ".join(parts)


# One ability as this screen has always printed it: the name, its damage range
# at `atk` with the scaling, and the description on the line under it.
static func _ability_text(ab: Ability, atk: int) -> String:
	var line: String = "• %s" % ab.display_name
	if ab.damage > 0:
		# Numbers from the given Attack (damage is % of Attack).
		var hit: float = ab.damage * 0.01 * atk
		line += " — %d–%d %s dmg (%d%% Atk)" % [int(hit * 0.9),
			int(round(hit * 1.1)), ab.dmg_type.capitalize(), ab.damage]
	return "%s\n   %s" % [line, Classes.resolve_values(ab.description,
		{"attack": atk}).replace("\n", " ")]


# THE KIT, ONCE, BELOW THE CARDS — true of all three, so drawn where it is true.
# Its figures are a hero's with NO engine (the brief's basis). A dealt rune whose
# lineage sets another Attack moves them, and then the screen says so: the note
# is DERIVED by printing every kit card that rune's hero still holds at both
# Attacks, so a rune that moves nothing shown is never named.
func _draw_kit(column: VBoxContainer, key: String, shared: Array, base_atk: int,
		dealt: Array) -> void:
	var head := Label.new()
	# PROPOSED WORDS (GQ); "or leaves out" is HB's, for the Sharpshooter's rune,
	# which opens without the pet.
	head.text = "With no engine, the %s opens every fight with these. A rune adds, or leaves out, what its card names." % key.capitalize()
	head.add_theme_font_size_override("font_size", 14)
	head.add_theme_color_override("font_color", Color(0.82, 0.74, 0.55))
	head.custom_minimum_size = Vector2(ROW_W, 0)
	head.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(head)
	var movers := PackedStringArray()
	for rid in dealt:
		var pid := String(Runes.config(String(rid)).get("engine", ""))
		var lineage := Classes.engine_spec(pid)
		if lineage == "" or Classes.spec_attack(lineage) == base_atk:
			continue
		var atk := Classes.spec_attack(lineage)
		var held: Array = Classes.opening_kit(key, lineage, [pid]).map(
			func(a): return a.display_name)
		for ab in shared:
			if held.has(ab.display_name) and _ability_text(ab, atk) != _ability_text(ab, base_atk):
				movers.append("the %s sets Attack to %d" % [
					Runes.display_name(Runes.config(String(rid))), atk])
				break
	if not movers.is_empty():
		var note := Label.new()
		# PROPOSED WORDS (GQ).
		note.text = "Figures are for the %s with no engine: %s, and they move with it." % [
			key.capitalize(), " and ".join(movers)]
		note.add_theme_font_size_override("font_size", 12)
		note.add_theme_color_override("font_color", Color(0.6, 0.55, 0.5))
		note.custom_minimum_size = Vector2(ROW_W, 0)
		note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		column.add_child(note)
	var kit_row := HBoxContainer.new()
	kit_row.add_theme_constant_override("separation", 20)
	column.add_child(kit_row)
	var col_w := int((ROW_W - 20.0 * (shared.size() - 1)) / shared.size())
	for ab in shared:
		var lbl := Label.new()
		lbl.text = _ability_text(ab, base_atk)
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl.custom_minimum_size = Vector2(col_w, 0)
		# Top-aligned: the row is as tall as its longest column, and a short
		# card centred in it reads as a different row.
		lbl.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		kit_row.add_child(lbl)


func _choose(idx: int, rune_id: String) -> void:
	Music.click()
	Run.awaken(idx, rune_id)
	_draw_screen()


# All heroes awakened: the boss-entry tune plays over a fade to black, then the
# node map appears (map music waits for the tune to finish).
func _finish_and_fade() -> void:
	# Batch AN deleted Batch AF/AE's opening rune pick-of-3 that used to be
	# dealt here. Heroes begin with NO ordinary runes and three empty slots —
	# and, since GK, the one engine rune each took on this screen.
	Run.specs_chosen = true
	# Persist immediately: without this, quitting before the next node made
	# Continue resurrect the old specs and talent trees.
	Run.save_run()
	# The persistent profile counts the run from the moment the heroes awaken.
	Profile.note_run_started(Run.chronicle_keys())
	Music.play_intro_then("boss_intro", "map")
	var fade := ColorRect.new()
	fade.size = Vector2(1280, 720)
	fade.color = Color(0, 0, 0, 0.0)
	add_child(fade)
	var tween := create_tween()
	tween.tween_property(fade, "color:a", 1.0, 1.3)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/map.tscn")
