# The offer screen (Batch AN §3, re-gated in AO §2): before every ELITE and
# MINI-BOSS slot the player is shown three bargains and takes one. A bargain
# is one MODIFIER (a condition binding BOTH parties for that battle) plus one
# REWARD, both visible before choosing. Plain fights and bosses walk straight
# in — four bargains a zone is an event, ten was a toll booth.
#
# The reward scales with the modifier's SEVERITY automatically — severity is
# authored per modifier, flat, and deliberately ignores party composition. A
# modifier that happens to be cheap for your build is a good deal you earned
# by building that way.
#
# There is NO decline. Three options is the decision; a fourth "take none"
# would make the severity-1 floor pointless, since that floor exists exactly
# so a wounded party always has a survivable choice.
#
# WHY THE REWARD PAYS ON VICTORY, not on acceptance: the modifier is the
# price and the reward is what clearing the fight under it bought. It is
# also the only reading that works for the severity-4 "a merchant follows
# the fight" — a merchant cannot precede a fight it follows.
extends Node2D

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

# Severity wears a colour so the three cards sort themselves at a glance,
# before a word of the text is read.
const SEVERITY_COLORS := {
	1: Color(0.55, 0.85, 0.6),
	2: Color(0.85, 0.82, 0.45),
	3: Color(0.95, 0.6, 0.35),
	4: Color(0.95, 0.35, 0.4),
}

var offer: Array = []


func _ready() -> void:
	if not Run.active or Run.encounter.is_empty():
		get_tree().change_scene_to_file.call_deferred("res://scenes/map.tscn")
		return
	Music.play("map")
	offer = Run.roll_offer()
	_draw_screen()


func _draw_screen() -> void:
	for child in get_children():
		child.queue_free()

	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color(0.07, 0.05, 0.09)
	add_child(bg)

	var title := Label.new()
	title.text = "A BARGAIN ON THE ROAD"
	title.add_theme_font_override("font", NAME_FONT)
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	title.position = Vector2(0, 26)
	title.size = Vector2(1280, 50)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)

	# Three-way, because the mini-boss reached this screen in Batch AO. The
	# plain-fight line is kept as a defensive default: nothing routes here
	# from a fight today, and a screen that says nothing is worse than a
	# screen that says the ordinary thing.
	var enc_type := String(Run.encounter.get("type", "fight"))
	var opener := "A warband stands in the road."
	if enc_type == "elite":
		opener = "An ELITE warband stands in the road."
	elif enc_type == "miniboss":
		opener = "The WARDEN of this zone blocks the road."
	var sub := Label.new()
	sub.text = opener \
		+ "  Choose the terms you will fight on —\n" \
		+ "the condition binds BOTH sides, and the payment lands when they fall."
	sub.add_theme_font_size_override("font_size", 15)
	sub.add_theme_color_override("font_color", Color(0.72, 0.68, 0.6))
	sub.position = Vector2(0, 80)
	sub.size = Vector2(1280, 44)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)

	# What the party is walking into, so the choice is made against a known
	# warband rather than a guess — the same scouting the map dot offers.
	var scout := Label.new()
	scout.text = _warband_line()
	scout.add_theme_font_size_override("font_size", 14)
	scout.add_theme_color_override("font_color", Color(0.62, 0.6, 0.66))
	scout.position = Vector2(0, 130)
	scout.size = Vector2(1280, 22)
	scout.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(scout)

	for i in offer.size():
		_draw_option(i, Vector2(70.0 + i * 390.0, 180.0))

	# The party's state, right where the decision is made: choosing a
	# severity-4 bargain at 30% health is a real choice, and it should be an
	# informed one.
	var parts := PackedStringArray()
	for member in Run.party:
		var spec := String(member.get("spec", ""))
		parts.append("%s %d/%d" % [
			Classes.SPEC_INFO[spec]["name"] if spec != "" \
				else String(member["key"]).capitalize(),
			int(member["hp"]), int(member["max_hp"])])
	var status := Label.new()
	status.text = "   ·   ".join(parts)
	status.add_theme_font_size_override("font_size", 15)
	status.add_theme_color_override("font_color", Color(0.8, 0.76, 0.7))
	status.position = Vector2(0, 640)
	status.size = Vector2(1280, 22)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status)

	var gold_lbl := Label.new()
	gold_lbl.text = "Gold: %d" % Run.gold
	gold_lbl.add_theme_font_size_override("font_size", 15)
	gold_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	gold_lbl.position = Vector2(0, 668)
	gold_lbl.size = Vector2(1280, 20)
	gold_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(gold_lbl)


func _warband_line() -> String:
	var counts := {}
	for kind in Run.encounter.get("enemies", []):
		counts[kind] = int(counts.get(kind, 0)) + 1
	var parts := PackedStringArray()
	for kind in counts:
		var label: String = Enemies.unit_name(String(kind))
		if int(counts[kind]) > 1:
			label = "%dx %s" % [int(counts[kind]), label]
		parts.append(label)
	if parts.is_empty():
		return ""
	return "%s — %s" % [String(Run.encounter.get("theme", "Warband")),
		", ".join(parts)]


func _draw_option(idx: int, at: Vector2) -> void:
	var option: Dictionary = offer[idx]
	var mod_id := String(option["modifier"])
	var cfg: Dictionary = Run.MODIFIERS[mod_id]
	var sev := int(cfg["severity"])
	var tint: Color = SEVERITY_COLORS.get(sev, Color.WHITE)

	var panel := Panel.new()
	panel.position = at
	panel.size = Vector2(350, 420)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.05, 0.04, 0.07, 0.95)
	sb.border_color = tint
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)

	var sev_lbl := Label.new()
	sev_lbl.text = "SEVERITY %d" % sev
	sev_lbl.add_theme_font_size_override("font_size", 13)
	sev_lbl.add_theme_color_override("font_color", tint)
	sev_lbl.position = at + Vector2(0, 16)
	sev_lbl.size = Vector2(350, 18)
	sev_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sev_lbl)

	# The severity pips: four boxes, `sev` of them lit. A number is precise,
	# a bar is comparable, and the choice between three cards is a comparison.
	for p in 4:
		var pip := ColorRect.new()
		pip.position = at + Vector2(133.0 + p * 22.0, 38.0)
		pip.size = Vector2(16, 6)
		pip.color = tint if p < sev else Color(0.22, 0.21, 0.25)
		add_child(pip)

	var name_lbl := Label.new()
	name_lbl.text = String(cfg["name"]).to_upper()
	name_lbl.add_theme_font_override("font", NAME_FONT)
	name_lbl.add_theme_font_size_override("font_size", 32)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.86, 0.78))
	name_lbl.position = at + Vector2(0, 54)
	name_lbl.size = Vector2(350, 40)
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(name_lbl)

	var desc := Label.new()
	desc.text = String(cfg["desc"])
	desc.add_theme_font_size_override("font_size", 15)
	desc.add_theme_color_override("font_color", Color(0.84, 0.81, 0.75))
	desc.position = at + Vector2(20, 104)
	desc.size = Vector2(310, 90)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(desc)

	var rule := ColorRect.new()
	rule.position = at + Vector2(40, 210)
	rule.size = Vector2(270, 1)
	rule.color = Color(1, 1, 1, 0.12)
	add_child(rule)

	var pay_head := Label.new()
	pay_head.text = "PAYS"
	pay_head.add_theme_font_size_override("font_size", 12)
	pay_head.add_theme_color_override("font_color", Color(0.6, 0.57, 0.55))
	pay_head.position = at + Vector2(0, 224)
	pay_head.size = Vector2(350, 16)
	pay_head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(pay_head)

	var reward := Label.new()
	reward.text = Run.reward_text(option["reward"])
	reward.add_theme_font_size_override("font_size", 20)
	reward.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	reward.position = at + Vector2(20, 244)
	reward.size = Vector2(310, 60)
	reward.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reward.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(reward)

	var take := Button.new()
	take.text = "Take this bargain"
	take.custom_minimum_size = Vector2(270, 48)
	take.position = at + Vector2(40, 340)
	take.add_theme_font_size_override("font_size", 16)
	take.tooltip_text = "%s\n%s\n\nOn victory: %s" % [String(cfg["name"]),
		String(cfg["desc"]), Run.reward_text(option["reward"])]
	take.pressed.connect(Music.click)
	take.pressed.connect(_accept.bind(idx))
	add_child(take)


func _accept(idx: int) -> void:
	if idx < 0 or idx >= offer.size():
		return
	Run.accept_offer(offer[idx])
	get_tree().change_scene_to_file("res://scenes/battle.tscn")
