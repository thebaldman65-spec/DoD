# BATCH HZ §1b — THE KIT PREVIEW: ONE HERO'S CARRIED CARDS AND RUNES, OVER THE SCREEN
# WHERE A BUY OR A DRAFT IS DECIDED.
#
# The playtest's most-named zone-one finding was that the player cannot see what a hero
# already carries while deciding what to draft or buy for him. **ONE COMPONENT, USED BY
# TWO SCREENS**: the map's draft (the party draft's columns and the pick overlay — every
# draft is a map overlay) opens it on the hero whose decision it is; the Peddler, whose
# purse is the party's, opens it on the first hero and walks all four. Both screens take
# their input as Buttons, so the same three buttons serve both.
#
# **THREE CONSTRAINTS, EACH THE BRIEF'S.**
# - **READ-ONLY.** It equips nothing, benches nothing and drops nothing: a preview that
#   can equip is the rune panel, and the rune panel is IA's.
# - **AN OVERLAY THAT DOES NOT LOSE THE UNDERLYING CHOICE.** It is added on top of the
#   screen and frees only itself, so a staged draft, an open pick and a half-made
#   purchase are exactly as they were when it closes. Its dim stops every click, so the
#   choice underneath cannot be pressed through it.
# - **IT DOES NOT INVENT IA's LAYOUT.** The cards read as the hero sheet reads them and
#   the runes in the sheet's own words — the state it shows (CREST, ENGINE, WORN, held,
#   sits out), the `(core)` suffix the rune data carries (HL §2) and HR's nameplate marker
#   (✦ N held, not worn). IA builds the three sections; this is not a first draft of them.
#
# It reads the doors the hero sheet and the battle spawn read — the opening kit off
# `Classes.opening_kit`, the seated cards off `Run.seated_ability_names`, what sits out
# off `Run.sitting_out_names` — so it cannot disagree with them about what the hero
# carries. **No `class_name`, and its callers `load()` it**: it names the `Run` autoload,
# which a `preload` would resolve before the autoload exists (CT's rule).
extends Control

signal closed

const NAME_FONT := preload("res://assets/fonts/PirataOne-Regular.ttf")

var hero_idx := 0
var walk := false
var _title: Label
var _body: VBoxContainer
var _prev: Button
var _next: Button


# Who to open on, and whether the preview walks the whole party (the Peddler's purse is
# the party's) or stays on the hero whose decision it is (a draft is one hero's).
func setup(idx: int, walk_all: bool) -> Control:
	hero_idx = idx
	walk = walk_all
	return self


func _ready() -> void:
	z_index = 90
	size = Vector2(1280, 720)
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.72)
	# STOP so no click leaks to the choice underneath while the preview is up.
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var frame := PanelContainer.new()
	frame.position = Vector2(240, 60)
	frame.custom_minimum_size = Vector2(800, 600)
	frame.size = Vector2(800, 600)
	# OPAQUE, so the choice underneath does not read through the preview.
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.08, 0.06, 0.10, 0.98)
	sb.border_color = Color(0.45, 0.40, 0.52)
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(6)
	sb.set_content_margin_all(12)
	frame.add_theme_stylebox_override("panel", sb)
	add_child(frame)
	var root_box := VBoxContainer.new()
	root_box.add_theme_constant_override("separation", 8)
	frame.add_child(root_box)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	root_box.add_child(top)
	_title = Label.new()
	_title.add_theme_font_override("font", NAME_FONT)
	_title.add_theme_font_size_override("font_size", 26)
	_title.add_theme_color_override("font_color", Color(0.95, 0.85, 0.4))
	_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(_title)
	if walk:
		_prev = Button.new()
		_prev.text = "◀ Previous"
		_prev.custom_minimum_size = Vector2(110, 34)
		_prev.pressed.connect(_step.bind(-1))
		top.add_child(_prev)
		_next = Button.new()
		_next.text = "Next ▶"
		_next.custom_minimum_size = Vector2(90, 34)
		_next.pressed.connect(_step.bind(1))
		top.add_child(_next)
	var close := Button.new()
	close.text = "✕  Close"
	close.custom_minimum_size = Vector2(110, 34)
	close.pressed.connect(close_preview)
	top.add_child(close)
	var note := Label.new()
	note.text = "What this hero carries now. Nothing here can be changed — kits are set on the map."
	note.add_theme_font_size_override("font_size", 12)
	note.add_theme_color_override("font_color", Color(0.6, 0.58, 0.55))
	root_box.add_child(note)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(784, 520)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root_box.add_child(scroll)
	_body = VBoxContainer.new()
	_body.add_theme_constant_override("separation", 4)
	_body.custom_minimum_size = Vector2(760, 0)
	scroll.add_child(_body)
	_fill()


func close_preview() -> void:
	closed.emit()
	queue_free()


func _step(by: int) -> void:
	var n := Run.party.size()
	if n <= 0:
		return
	hero_idx = posmod(hero_idx + by, n)
	_fill()


func _line(text: String, size_px: int, color: Color, tip := "") -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size_px)
	l.add_theme_color_override("font_color", color)
	l.custom_minimum_size = Vector2(760, 0)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if tip != "":
		l.tooltip_text = tip
		l.mouse_filter = Control.MOUSE_FILTER_STOP
	_body.add_child(l)
	return l


func _fill() -> void:
	for child in _body.get_children():
		child.queue_free()
	if hero_idx < 0 or hero_idx >= Run.party.size():
		_title.text = "No hero"
		return
	var member: Dictionary = Run.party[hero_idx]
	var key := String(member.get("key", ""))
	var spec := String(member.get("spec", ""))
	var awake: bool = spec != "" or bool(member.get("awakened", false))
	_title.text = "%s %d — the kit" % [Run.nameplate(member), hero_idx + 1]
	var res_name := String(Classes.hero_config(key).get("resource_name", "Mana"))
	var engines: Array = Runes.held_engines(member)

	# THE CARDS — the opening kit, then every carried card the next fight seats, as the
	# hero sheet lists them, and what sits out below them with its reason.
	_line("CARDS", 15, Color(0.85, 0.82, 0.75))
	var shown: Array = []
	var cards: Array = Classes.opening_kit(key, spec, engines)
	if awake:
		for n in Run.seated_ability_names(member):
			var ab_n := Classes.spec_pool_ability(spec, String(n))
			if ab_n != null and not cards.any(func(a): return a.display_name == ab_n.display_name):
				cards.append(ab_n)
	for ab in cards:
		var a: Ability = ab
		shown.append(a.display_name)
		var cost := ""
		if a.cost > 0:
			cost = "  (%d %s)" % [a.cost, res_name]
		elif a.faith_cost > 0:
			cost = "  (%d Mercy)" % a.faith_cost
		var tip := Classes.resolve_values(a.description)
		var block := Classes.computed_block(a, 0, res_name)
		if block != "":
			tip += ("\n" if tip != "" else "") + block
		_line("   %s%s" % [a.display_name, cost], 13, Color(0.9, 0.86, 0.76), tip)
	for so in (Run.sitting_out_names(member) if awake else []):
		_line("   %s — sits out" % String(so), 13, Color(0.55, 0.53, 0.5),
			Run.sits_out_note(String(so), engines))
	var benched: Array = Run.benched_ability_names(member) if awake else []
	if not benched.is_empty():
		_line("   Benched: %s" % ", ".join(PackedStringArray(benched)), 12,
			Color(0.6, 0.58, 0.55))

	# THE RUNES — in the sheet's own reading: the crest's rune first, then the core runes
	# (their names carry `(core)`), then his own; each with the state the sheet shows, and
	# HR's marker for what he holds and does not wear.
	_line("", 6, Color(0, 0, 0))
	_line("RUNES", 15, Color(0.85, 0.82, 0.75))
	var all_runes: Array = Run.party_runes + member.get("engines", []) + member.get("runes", [])
	if all_runes.is_empty():
		_line("   None yet — a rune drops after every normal fight, and the Peddler sells them.", 12,
			Color(0.55, 0.52, 0.5))
	var sitting: Array = Run.sitting_out_rune_names(member) if awake else []
	for entry in all_runes:
		var rune: Dictionary = entry
		var on: bool = rune.get("equipped", false)
		var state := ("CREST" if Runes.is_party_rune(rune) else ("ENGINE" if rune.has("engine")
			else "WORN")) if on else "held"
		if on and sitting.has(String(rune.get("name", ""))):
			state = "sits out"
		_line("   %s %s — %s" % [state.rpad(8), String(rune.get("name", "")), Runes.shown_desc(rune)], 12,
			Color(0.45, 0.9, 0.5) if on and state != "sits out" else Color(0.62, 0.6, 0.66))
	var waiting: int = Run.held_count(member)
	if waiting > 0:
		_line("   ✦ %d held, not worn — equipped from the %s's rune panel on the map." % [
			waiting, Run.nameplate(member)], 12, Color(0.85, 0.6, 1.0))
