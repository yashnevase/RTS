extends CanvasLayer

signal retreat_requested
signal restart_requested

const PLAYER_TEAM := 0
const CPU_TEAM := 1

var campaign_mode := false
var play_again: Button
var selection_label: Label
var status_label: Label
var counts_label: Label
var message_label: Label
var result_overlay: Panel
var result_title: Label
var result_detail: Label
var retreat_button: Button
var restart_button: Button


func _ready() -> void:
	_build_hud()


func set_message(message: String) -> void:
	if is_instance_valid(message_label):
		message_label.text = message


func update_battle(simulation: RefCounted, selected_unit_ids: Array[String]) -> void:
	if not is_instance_valid(status_label):
		return
	if campaign_mode:
		restart_button.text = "WITHDRAW ALL" if simulation.outcome == "ongoing" else "RETURN TO CAMPAIGN"
		play_again.text = "RETURN TO CAMPAIGN"
	counts_label.text = "YOUR FORCE  %d     •     OPPOSING FORCE  %d" % [simulation.unit_count(PLAYER_TEAM), simulation.unit_count(CPU_TEAM)]
	if simulation.outcome == "ongoing":
		status_label.text = "FIELD BATTLE  •  %02d:%02d" % [int(simulation.elapsed_seconds) / 60, int(simulation.elapsed_seconds) % 60]
		result_overlay.visible = false
	else:
		status_label.text = simulation.outcome.to_upper()
		_show_result(simulation.outcome, simulation.unit_count(PLAYER_TEAM, true))

	var total_health := 0.0
	var maximum_health := 0.0
	var roles: Array[String] = []
	var selected_count := 0
	for unit_id in selected_unit_ids:
		var unit: Dictionary = simulation.units.get(unit_id, {})
		if unit.is_empty() or float(unit["health"]) <= 0.0 or bool(unit["withdrawn"]):
			continue
		selected_count += 1
		total_health += float(unit["health"])
		maximum_health += float(unit["max_health"])
		var role: String = unit["role"]
		if role not in roles:
			roles.append(role)
	if roles.is_empty():
		selection_label.text = "Select one or more of your units"
	else:
		var unit_word := "unit" if selected_count == 1 else "units"
		selection_label.text = "%d %s\n%s\nCombined health  %d / %d" % [selected_count, unit_word, ", ".join(roles), int(total_health), int(maximum_health)]


func _build_hud() -> void:
	var root := Control.new()
	root.name = "HUDRoot"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	var heading := _panel(root, "BattleTitle", Vector2(30.0, 24.0), Vector2(390.0, 78.0))
	_label(heading, "DECCAN LORDS", 22, Color(0.91, 0.77, 0.50), Vector2(18.0, 7.0), Vector2(350.0, 32.0))
	_label(heading, "KALDAR PASS  /  CAMPAIGN ENCOUNTER" if campaign_mode else "M2  /  FIELD BATTLE PROTOTYPE", 12, Color(0.79, 0.76, 0.69), Vector2(20.0, 43.0), Vector2(350.0, 22.0))

	status_label = _label(root, "FIELD BATTLE", 17, Color(0.94, 0.88, 0.74), Vector2(550.0, 24.0), Vector2(500.0, 42.0), HORIZONTAL_ALIGNMENT_CENTER)
	var force_panel := _panel(root, "ForceSummary", Vector2(600.0, 75.0), Vector2(400.0, 50.0))
	counts_label = _label(force_panel, "YOUR FORCE  5     •     OPPOSING FORCE  5", 14, Color(0.91, 0.87, 0.77), Vector2(12.0, 7.0), Vector2(376.0, 34.0), HORIZONTAL_ALIGNMENT_CENTER)

	var inspector := _panel(root, "SelectionPanel", Vector2(1228.0, 25.0), Vector2(340.0, 164.0))
	_label(inspector, "SELECTED FORCE", 12, Color(0.89, 0.73, 0.44), Vector2(16.0, 9.0), Vector2(300.0, 23.0))
	selection_label = _label(inspector, "Select your units", 14, Color(0.91, 0.87, 0.78), Vector2(16.0, 34.0), Vector2(308.0, 64.0))
	selection_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label = _label(inspector, "RMB ground = move  •  enemy = attack", 12, Color(0.70, 0.77, 0.68), Vector2(16.0, 108.0), Vector2(308.0, 28.0))

	var controls := _panel(root, "BattleControls", Vector2(0.0, 0.0), Vector2(1600.0, 78.0))
	controls.anchor_left = 0.0
	controls.anchor_right = 1.0
	controls.anchor_top = 1.0
	controls.anchor_bottom = 1.0
	controls.offset_left = 0.0
	controls.offset_right = 0.0
	controls.offset_top = -94.0
	controls.offset_bottom = -16.0
	_label(controls, "LEFT CLICK SELECT     SHIFT + CLICK ADD     RIGHT CLICK MOVE / ATTACK     R RETREAT     ESC CLEAR", 12, Color(0.91, 0.87, 0.77), Vector2(28.0, 23.0), Vector2(980.0, 30.0))
	retreat_button = _button(controls, "RETREAT SELECTED  [R]", Vector2(1080.0, 14.0), Vector2(220.0, 48.0))
	retreat_button.pressed.connect(func(): retreat_requested.emit())
	restart_button = _button(controls, "RESTART", Vector2(1320.0, 14.0), Vector2(220.0, 48.0))
	restart_button.pressed.connect(func(): restart_requested.emit())

	result_overlay = Panel.new()
	result_overlay.name = "BattleResultOverlay"
	result_overlay.position = Vector2(500.0, 306.0)
	result_overlay.size = Vector2(600.0, 284.0)
	_apply_panel_style(result_overlay)
	result_overlay.visible = false
	root.add_child(result_overlay)
	result_title = _label(result_overlay, "VICTORY", 30, Color(0.92, 0.77, 0.48), Vector2(32.0, 34.0), Vector2(536.0, 48.0), HORIZONTAL_ALIGNMENT_CENTER)
	result_detail = _label(result_overlay, "Your force holds the field.", 16, Color(0.90, 0.86, 0.77), Vector2(46.0, 96.0), Vector2(508.0, 48.0), HORIZONTAL_ALIGNMENT_CENTER)
	play_again = _button(result_overlay, "FIGHT AGAIN", Vector2(183.0, 174.0), Vector2(234.0, 54.0))
	play_again.pressed.connect(func(): restart_requested.emit())


func _show_result(outcome: String, survivors: int) -> void:
	if outcome == "victory":
		result_title.text = "VICTORY"
		result_detail.text = "Your force holds the field. Survivors: %d" % survivors
	elif outcome == "defeat":
		result_title.text = "DEFEAT"
		result_detail.text = "Your force has been lost or withdrawn."
	else:
		result_title.text = "DRAW"
		result_detail.text = "Both forces left the field at the same time."
	result_overlay.visible = true


func _panel(parent: Control, panel_name: String, at: Vector2, size: Vector2) -> Panel:
	var panel := Panel.new()
	panel.name = panel_name
	panel.position = at
	panel.size = size
	_apply_panel_style(panel)
	parent.add_child(panel)
	return panel


func _apply_panel_style(panel: Panel) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.075, 0.092, 0.083, 0.93)
	style.border_color = Color(0.56, 0.43, 0.23, 0.79)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	panel.add_theme_stylebox_override("panel", style)


func _label(parent: Control, value: String, size: int, color: Color, at: Vector2, rect: Vector2, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = rect
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label


func _button(parent: Control, caption: String, at: Vector2, rect: Vector2) -> Button:
	var button := Button.new()
	button.text = caption
	button.position = at
	button.size = rect
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 13)
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	parent.add_child(button)
	return button
