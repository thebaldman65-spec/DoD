# CLASS SELECTION — BATCH GK: THE DRAFT OF THREE ENGINES.
#
# After the draft screen, before the first battle, each hero is DEALT THREE of
# his class's engine runes and TAKES ONE (the engine rune charter, `CLAUDE.md`).
# The deal is frozen on the member (`Run.deal_engines`), so redrawing this screen
# for the next hero does not re-deal the last. What is taken is his to keep, drop
# or swap from the map, and a second can join it from the ordinary rune pool.
#
# **THE SPEC THE TAKEN ENGINE CARRIED IS THE HERO'S LINEAGE** — the key the
# unmerged layers still read: his opening kit, his stat block, his draft and boss
# pools and his spec-scoped runes. A spine taken here leaves him none, and he
# opens with his class kit. `Run.awaken` is the one door; the sim uses it too.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")


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
	for i in dealt.size():
		var rune_id := String(dealt[i])
		var rcfg: Dictionary = Runes.config(rune_id)
		var pid := String(rcfg.get("engine", ""))
		var lineage := Classes.engine_spec(pid)
		var panel := PanelContainer.new()
		panel.position = Vector2(90 + i * 380, 140)
		panel.custom_minimum_size = Vector2(340, 420)
		add_child(panel)
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
		# Archetype: bold name only; the explanation lives in the tooltip. A spine
		# carries no spec and so no archetype: it names its class instead.
		var arch: String = String(Classes.SPEC_INFO[lineage].get("archetype", "")) \
			if lineage != "" else "%s engine" % key.capitalize()
		var arch_label := Label.new()
		arch_label.text = arch
		var bold := FontVariation.new()
		bold.base_font = ThemeDB.fallback_font
		bold.variation_embolden = 0.9
		arch_label.add_theme_font_override("font", bold)
		arch_label.add_theme_font_size_override("font_size", 16)
		arch_label.add_theme_color_override("font_color", Color(0.82, 0.75, 0.6))
		arch_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		arch_label.mouse_filter = Control.MOUSE_FILTER_STOP
		arch_label.tooltip_text = Classes.ARCHETYPE_DESC.get(arch, "")
		vbox.add_child(arch_label)
		# Long kits (Beastmaster!) scroll instead of pushing the button off
		# screen: the text lives in a fixed-height ScrollContainer.
		var scroll := ScrollContainer.new()
		scroll.custom_minimum_size = Vector2(316, 320)
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		vbox.add_child(scroll)
		var body := Label.new()
		var ability_lines := PackedStringArray()
		var atk := Classes.spec_attack(lineage) if lineage != "" \
			else int(Classes.hero_config(key)["attack"])
		# BATCH CL §1 — this screen has an Attack and no hero, so Attack tokens
		# resolve and health tokens correctly stand as bare percentages.
		var vctx := {"attack": atk}
		# THE KIT THIS RUNE OPENS WITH, off the one builder the battle reads: the
		# class kit, the lineage's abilities, and the engine's enablers.
		for ab in Classes.opening_kit(key, lineage, [pid]):
			var line: String = "• %s" % ab.display_name
			if ab.damage > 0:
				# Numbers from the lineage's base Attack (damage is % of Attack).
				var hit: float = ab.damage * 0.01 * atk
				line += " — %d–%d %s dmg (%d%% Atk)" % [int(hit * 0.9),
					int(round(hit * 1.1)), ab.dmg_type.capitalize(), ab.damage]
			ability_lines.append(line)
			ability_lines.append("   %s" % Classes.resolve_values(
				ab.description, vctx).replace("\n", " "))
		# BATCH CL §7 — `passive_desc` is flattened here, where it soft-wraps.
		var engine_text := Classes.resolve_values(Classes.engine_desc(pid),
			vctx).replace("\n", " ")
		var blurb := String(Classes.SPEC_INFO[lineage]["blurb"]) if lineage != "" else ""
		body.text = "%sEngine: %s\n\n%s" % ["%s\n\n" % blurb if blurb != "" else "",
			engine_text, "\n".join(ability_lines)]
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
