extends Control

signal travel_requested(destination_id: String)
signal contract_requested
signal advance_requested
signal save_requested
signal load_requested

const MAP_SCRIPT := preload("res://src/campaign/m4_campaign_map.gd")
const LOCATION_ORDER := ["keshavwadi", "kaldar_pass", "nandipur", "suryagarh"]

const COLOR_BG := Color("#17211d")
const COLOR_PANEL := Color("#222f29")
const COLOR_PANEL_EDGE := Color("#46584b")
const COLOR_TEXT := Color("#f0ecdc")
const COLOR_MUTED := Color("#bbc5b5")
const COLOR_ACCENT := Color("#d3ae68")
const COLOR_GOOD := Color("#9bb98b")
const COLOR_ALERT := Color("#e2a073")

var tabs: TabContainer
var map_board: Control
var day_label: Label
var party_label: Label
var destination_label: Label
var destination_buttons: Dictionary = {}
var contract_button: Button
var advance_button: Button
var save_button: Button
var load_button: Button
var travel_target_id := ""
var destination_buttons_for_test: Dictionary = {}
var briefing_label: Label
var caravan_label: Label
var lord_label: Label
var merchant_label: Label
var decision_label: Label
var activity_list: VBoxContainer
var status_label: Label


func _ready() -> void:
	_build_layout()
	set_status("Choose a destination, then advance one day.")


func refresh(simulation: RefCounted) -> void:
	if day_label == null:
		return
	var campaign_state: Dictionary = simulation.state
	var party: Dictionary = campaign_state["player_party"]
	var caravan: Dictionary = campaign_state["caravan"]
	var merchant: Dictionary = campaign_state["merchant"]
	var superior: Dictionary = campaign_state["superior"]
	day_label.text = "DAY %02d" % simulation.current_day()
	party_label.text = "%s  ·  %s" % [str(party["name"]), simulation.location_name(str(party["location_id"]))]
	party_status_label.text = "%s\nCurrent location: %s" % [str(party["name"]), simulation.location_name(str(party["location_id"]))]
	var remaining_route: Array = party["route"]
	if remaining_route.is_empty():
		destination_label.text = "At %s" % simulation.location_name(str(party["location_id"]))
	else:
		destination_label.text = "Travelling to %s  ·  next %s" % [simulation.location_name(str(party["destination_id"])), simulation.location_name(str(remaining_route[0]))]
	map_board.set_campaign_state(campaign_state)
	for location_id in LOCATION_ORDER:
		var location: Dictionary = simulation.LOCATION_DATA[location_id]
		var button: Button = destination_buttons[location_id]
		button.text = "%s\n%s" % [str(location["name"]), str(location["kind"])]
		button.disabled = not remaining_route.is_empty() or str(party["location_id"]) == location_id
		button.button_pressed = travel_target_id == location_id and not remaining_route.is_empty()
	contract_button.disabled = str(party["location_id"]) != str(merchant["location_id"]) or str(caravan["status"]) != "idle" or int(simulation.settlement.state["treasury"]) < simulation.CARAVAN_PRICE or int(merchant["inventory_grain"]) < simulation.CARAVAN_GRAIN
	advance_button.text = "Advance to day %02d" % (simulation.current_day() + 1)
	briefing_label.text = str(superior["obligation"])
	caravan_label.text = _caravan_summary(simulation, caravan)
	lord_label.text = "Governor Amara  ·  standing %d / 100\n%s" % [int(superior["standing"]), str(superior["location_id"]).replace("_", " ").capitalize()]
	merchant_label.text = "%s  ·  %d coin  ·  %d grain" % [str(merchant["name"]), int(merchant["capital"]), int(merchant["inventory_grain"])]
	decision_label.text = str(merchant["last_decision"])
	_refresh_activity(campaign_state.get("activity_log", []))
	_refresh_settlement_tab(simulation)


func refresh_settlement(simulation: RefCounted) -> void:
	_refresh_settlement_tab(simulation)


func set_status(message: String, is_error: bool = false) -> void:
	if status_label != null:
		status_label.text = message
		status_label.add_theme_color_override("font_color", Color("#e17b70") if is_error else COLOR_MUTED)


func _build_layout() -> void:
	var background := ColorRect.new()
	background.color = COLOR_BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var margins := MarginContainer.new()
	margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margins.add_theme_constant_override("margin_" + side, 26)
	for side in ["top", "bottom"]:
		margins.add_theme_constant_override("margin_" + side, 18)
	add_child(margins)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 12)
	margins.add_child(page)
	_build_header(page)
	tabs = TabContainer.new()
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.add_theme_color_override("font_color", COLOR_TEXT)
	page.add_child(tabs)
	_build_campaign_tab()
	_build_settlement_tab()
	status_label = Label.new()
	status_label.custom_minimum_size.y = 22
	status_label.add_theme_font_size_override("font_size", 13)
	page.add_child(status_label)


func _build_header(parent: VBoxContainer) -> void:
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 18)
	parent.add_child(header)
	var identity := VBoxContainer.new()
	identity.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	identity.add_theme_constant_override("separation", 3)
	header.add_child(identity)
	var title := _label("THE KALDAR MARCHES", 26, COLOR_ACCENT)
	identity.add_child(title)
	var subtitle := _label("STRATEGIC CAMPAIGN  ·  M4 PROTOTYPE REGION", 12, COLOR_MUTED)
	identity.add_child(subtitle)
	day_label = _label("DAY 01", 17, COLOR_TEXT)
	day_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(day_label)
	var divider := HSeparator.new()
	divider.add_theme_color_override("color", COLOR_PANEL_EDGE)
	parent.add_child(divider)


func _build_campaign_tab() -> void:
	var campaign_page := HBoxContainer.new()
	campaign_page.name = "Campaign Map"
	campaign_page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	campaign_page.size_flags_vertical = Control.SIZE_EXPAND_FILL
	campaign_page.add_theme_constant_override("separation", 14)
	tabs.add_child(campaign_page)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", 9)
	campaign_page.add_child(left)
	party_label = _label("Rao's Retinue", 15, COLOR_TEXT)
	left.add_child(party_label)
	destination_label = _label("At Keshavwadi", 12, COLOR_MUTED)
	left.add_child(destination_label)
	var map_panel := PanelContainer.new()
	map_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_panel.add_theme_stylebox_override("panel", _panel_style())
	left.add_child(map_panel)
	map_board = MAP_SCRIPT.new()
	map_board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_panel.add_child(map_board)
	var map_footer := _label("GOLD: public route  ·  CIRCLE: your party  ·  GREEN MARKER: caravan", 11, COLOR_MUTED)
	left.add_child(map_footer)
	var location_row := HBoxContainer.new()
	location_row.add_theme_constant_override("separation", 6)
	left.add_child(location_row)
	for location_id in LOCATION_ORDER:
		var button := _button("", false)
		button.custom_minimum_size = Vector2(0, 54)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.toggle_mode = true
		button.pressed.connect(func() -> void:
			travel_target_id = location_id
			for other_id in destination_buttons:
				(destination_buttons[other_id] as Button).button_pressed = str(other_id) == location_id
			travel_requested.emit(location_id)
		)
		location_row.add_child(button)
		destination_buttons[location_id] = button
		destination_buttons_for_test[location_id] = button
	advance_button = _button("Advance one day", true)
	advance_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	advance_button.pressed.connect(func() -> void: advance_requested.emit())
	left.add_child(advance_button)
	var save_row := HBoxContainer.new()
	save_row.add_theme_constant_override("separation", 8)
	left.add_child(save_row)
	save_button = _button("Save campaign", false)
	save_button.pressed.connect(func() -> void: save_requested.emit())
	save_row.add_child(save_button)
	load_button = _button("Load campaign", false)
	load_button.pressed.connect(func() -> void: load_requested.emit())
	save_row.add_child(load_button)
	_build_right_panel(campaign_page)


func _build_right_panel(parent: HBoxContainer) -> void:
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 350
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style())
	parent.add_child(panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)
	var sections := VBoxContainer.new()
	sections.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sections.add_theme_constant_override("separation", 10)
	scroll.add_child(sections)
	_build_section(sections, "YOUR PARTY", func(content: VBoxContainer) -> void:
		var current_party_label := _label("", 13, COLOR_TEXT)
		current_party_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(current_party_label)
		party_status_label = current_party_label
	)
	_build_section(sections, "SUPERIOR'S OBLIGATION", func(content: VBoxContainer) -> void:
		briefing_label = _label("", 13, COLOR_TEXT)
		briefing_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(briefing_label)
		lord_label = _label("", 12, COLOR_ACCENT)
		lord_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(lord_label)
	)
	_build_section(sections, "MERCHANT & CARAVAN", func(content: VBoxContainer) -> void:
		merchant_label = _label("", 12, COLOR_MUTED)
		merchant_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(merchant_label)
		caravan_label = _label("", 13, COLOR_TEXT)
		caravan_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(caravan_label)
		contract_button = _button("Arrange 12 grain · 24 coin", true)
		contract_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		contract_button.pressed.connect(func() -> void: contract_requested.emit())
		content.add_child(contract_button)
	)
	_build_section(sections, "MERCHANT DECISION · WHY", func(content: VBoxContainer) -> void:
		decision_label = _label("", 12, COLOR_GOOD)
		decision_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(decision_label)
	)
	_build_section(sections, "CAMPAIGN CHRONICLE", func(content: VBoxContainer) -> void:
		activity_list = VBoxContainer.new()
		activity_list.add_theme_constant_override("separation", 5)
		content.add_child(activity_list)
	)


func _build_settlement_tab() -> void:
	var settlement_page := HBoxContainer.new()
	settlement_page.name = "Keshavwadi Settlement"
	settlement_page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	settlement_page.size_flags_vertical = Control.SIZE_EXPAND_FILL
	settlement_page.add_theme_constant_override("separation", 12)
	tabs.add_child(settlement_page)
	var nav := VBoxContainer.new()
	nav.custom_minimum_size.x = 220
	nav.add_theme_constant_override("separation", 8)
	settlement_page.add_child(nav)
	var nav_title := _label("SETTLEMENT VIEW", 15, COLOR_ACCENT)
	nav.add_child(nav_title)
	var explanation := _label("This view reads the same Keshavwadi simulation. Campaign time continues to settle its economy.", 12, COLOR_MUTED)
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nav.add_child(explanation)
	var location_title := _label("SETTLEMENT", 12, COLOR_TEXT)
	nav.add_child(location_title)
	_settlement_status_label = _label("Keshavwadi ledger · day 01", 12, COLOR_GOOD)
	_settlement_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nav.add_child(_settlement_status_label)
	var ledger_host := VBoxContainer.new()
	ledger_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ledger_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	settlement_page.add_child(ledger_host)
	var heading := _label("KESHAVWADI  ·  SHARED CAMPAIGN STATE", 14, COLOR_ACCENT)
	ledger_host.add_child(heading)
	var ledger_scroll := ScrollContainer.new()
	ledger_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ledger_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ledger_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	ledger_host.add_child(ledger_scroll)
	settlement_hud = Control.new()
	settlement_hud.set_script(load("res://src/settlement/m3_settlement_hud.gd"))
	settlement_hud.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	settlement_hud.size_flags_vertical = Control.SIZE_EXPAND_FILL
	settlement_hud.custom_minimum_size = Vector2(980, 720)
	ledger_scroll.add_child(settlement_hud)


func _refresh_settlement_tab(simulation: RefCounted) -> void:
	if settlement_hud != null:
		settlement_hud.refresh(simulation.settlement)
		_settlement_status_label.text = "Keshavwadi ledger · campaign day %02d" % simulation.current_day()


func _refresh_activity(entries: Array) -> void:
	for child in activity_list.get_children():
		activity_list.remove_child(child)
		child.queue_free()
	for index in range(maxi(0, entries.size() - 5), entries.size()):
		var entry: Dictionary = entries[index]
		var label := _label("D%02d · %s" % [int(entry["day"]), str(entry["message"])], 11, COLOR_MUTED)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		activity_list.add_child(label)


func _caravan_summary(simulation: RefCounted, caravan: Dictionary) -> String:
	var status := str(caravan["status"])
	if status == "idle":
		return "No active contract. Arrange an escorted 12-grain delivery at Nandipur."
	if status == "awaiting_escort":
		return "12 grain reserved at Nandipur · waiting for your return escort order."
	if status == "travelling":
		return "12 grain caravan · at %s · escorted days %d" % [simulation.location_name(str(caravan["location_id"])), int(caravan["escorted_days"])]
	if status == "awaiting_unload":
		return "At Keshavwadi · clear storehouse space to unload 12 grain."
	return "Delivered to Keshavwadi · 12 grain transferred and route obligation fulfilled."


func _build_section(parent: VBoxContainer, title: String, populate: Callable) -> void:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style())
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 7)
	panel.add_child(content)
	var heading := _label(title, 13, COLOR_ACCENT)
	content.add_child(heading)
	var divider := HSeparator.new()
	divider.add_theme_color_override("color", COLOR_PANEL_EDGE)
	content.add_child(divider)
	populate.call(content)


func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL
	style.border_color = COLOR_PANEL_EDGE
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style


func _label(text_value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


func _button(text_value: String, prominent: bool) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(70, 36)
	button.add_theme_color_override("font_color", COLOR_BG if prominent else COLOR_TEXT)
	button.add_theme_color_override("font_hover_color", COLOR_BG if prominent else COLOR_TEXT)
	button.add_theme_color_override("font_disabled_color", Color("#778179"))
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
	return button


var party_status_label: Label
var settlement_hud: Control
var _settlement_status_label: Label
