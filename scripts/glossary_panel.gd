# The glossary panel (Batch Z): one shared overlay, reachable from the
# map burger, the Party screen, and the battle burger. Pure Control UI —
# no awaits, no timers, nothing that could stall a battle's timeline; in
# battle the scene additionally gates its OWN _input while the panel is
# open so a stray click can't grade a skill check through the overlay.
class_name GlossaryPanel
extends Control

signal closed

var _tree: Tree
var _title: Label
var _body: RichTextLabel
var _items_by_id := {}


# Build and attach the panel to `parent`. The caller keeps the reference
# if it needs to know whether the panel is still up (battle input gate).
static func open(parent: Node) -> GlossaryPanel:
	var panel := GlossaryPanel.new()
	parent.add_child(panel)
	return panel


func _ready() -> void:
	z_index = 95
	var dim := ColorRect.new()
	dim.size = Vector2(1280, 720)
	dim.color = Color(0, 0, 0, 0.7)
	# STOP so hovers/clicks never leak to the screen underneath.
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var frame := PanelContainer.new()
	frame.position = Vector2(140, 50)
	frame.custom_minimum_size = Vector2(1000, 620)
	add_child(frame)
	var root_box := VBoxContainer.new()
	root_box.add_theme_constant_override("separation", 8)
	frame.add_child(root_box)

	var top := HBoxContainer.new()
	root_box.add_child(top)
	var heading := Label.new()
	heading.text = "GLOSSARY — how the systems work"
	heading.add_theme_font_size_override("font_size", 24)
	heading.add_theme_color_override("font_color", Color(0.85, 0.78, 0.62))
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(heading)
	var close := Button.new()
	close.text = "✕  Close"
	close.custom_minimum_size = Vector2(110, 36)
	close.pressed.connect(_close)
	top.add_child(close)

	var split := HBoxContainer.new()
	split.add_theme_constant_override("separation", 14)
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.add_child(split)

	_tree = Tree.new()
	_tree.hide_root = true
	_tree.custom_minimum_size = Vector2(300, 0)
	_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_tree.item_selected.connect(_on_term_selected)
	split.add_child(_tree)

	var right := VBoxContainer.new()
	right.add_theme_constant_override("separation", 6)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.add_child(right)
	_title = Label.new()
	_title.add_theme_font_size_override("font_size", 22)
	_title.add_theme_color_override("font_color", Color(0.9, 0.82, 0.6))
	right.add_child(_title)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(scroll)
	_body = RichTextLabel.new()
	_body.bbcode_enabled = true
	_body.fit_content = true
	_body.custom_minimum_size = Vector2(620, 0)
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_theme_font_size_override("normal_font_size", 15)
	_body.meta_clicked.connect(_on_link)
	scroll.add_child(_body)

	_fill_tree()


func _fill_tree() -> void:
	var root := _tree.create_item()
	var first: TreeItem = null
	for cat in Glossary.CATEGORIES:
		var terms := Glossary.in_category(String(cat[0]))
		if terms.is_empty():
			continue
		var header := _tree.create_item(root)
		header.set_text(0, String(cat[1]))
		header.set_selectable(0, false)
		header.set_custom_color(0, Color(0.85, 0.72, 0.4))
		for e in terms:
			var item := _tree.create_item(header)
			item.set_text(0, String(e["term"]))
			item.set_metadata(0, String(e["id"]))
			_items_by_id[String(e["id"])] = item
			if first == null:
				first = item
	if first != null:
		first.select(0)


func _on_term_selected() -> void:
	var item := _tree.get_selected()
	if item == null or item.get_metadata(0) == null:
		return
	_show_entry(String(item.get_metadata(0)))


func _show_entry(id: String) -> void:
	var e := Glossary.entry(id)
	if e.is_empty():
		return
	_title.text = String(e["term"])
	var text := "[i][color=#b8ae98]%s[/color][/i]\n\n%s" % [e["short"], e["long"]]
	var links := PackedStringArray()
	for other_id in e.get("see_also", []):
		var other := Glossary.entry(String(other_id))
		if not other.is_empty():
			links.append("[url=%s]%s[/url]" % [other_id, other["term"]])
	if not links.is_empty():
		text += "\n\n[color=#8f8878]See also:[/color]  " + "   ".join(links)
	_body.text = text


# See-also links jump the tree selection too, so the panel never loses
# its place.
func _on_link(meta: Variant) -> void:
	var id := String(meta)
	if _items_by_id.has(id):
		_items_by_id[id].select(0)
	_show_entry(id)


func _close() -> void:
	closed.emit()
	queue_free()
