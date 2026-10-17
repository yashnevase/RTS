extends RefCounted

## Shared presentation tokens and Control factories. No game rules belong here.
const COLOR_BG := Color("#17211d")
const COLOR_PANEL := Color("#222f29")
const COLOR_PANEL_EDGE := Color("#46584b")
const COLOR_TEXT := Color("#f0ecdc")
const COLOR_MUTED := Color("#bbc5b5")
const COLOR_ACCENT := Color("#d3ae68")
const COLOR_ALERT := Color("#e2a073")
const COLOR_URGENT := Color("#e17b70")
const COLOR_GOOD := Color("#9bb98b")


static func panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL
	style.border_color = COLOR_PANEL_EDGE
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 11
	style.content_margin_bottom = 11
	return style


static func label(text_value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


static func button(text_value: String, prominent: bool) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(70, 34)
	button.add_theme_color_override("font_color", COLOR_BG if prominent else COLOR_TEXT)
	button.add_theme_color_override("font_hover_color", COLOR_BG if prominent else COLOR_TEXT)
	var normal := StyleBoxFlat.new()
	normal.bg_color = COLOR_ACCENT if prominent else Color("#35443b")
	normal.set_corner_radius_all(5)
	button.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#e0bf80") if prominent else Color("#45574b")
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	var disabled := normal.duplicate() as StyleBoxFlat
	disabled.bg_color = Color("#2a342f")
	button.add_theme_stylebox_override("disabled", disabled)
	button.add_theme_color_override("font_disabled_color", Color("#87948b"))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = COLOR_ACCENT
	focus.set_border_width_all(2)
	focus.set_corner_radius_all(5)
	button.add_theme_stylebox_override("focus", focus)
	return button
