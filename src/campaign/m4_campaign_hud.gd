extends Control

signal travel_requested(destination_id: String)
signal recruit_requested
signal prepare_patrol_requested
signal encounter_requested
signal stop_requested
signal contract_requested
signal advance_requested
signal save_requested
signal load_requested

const MAP_SCRIPT := preload("res://src/campaign/m4_campaign_map.gd")
const REGION := preload("res://src/world/region_definition.gd")
const UI := preload("res://src/ui/game_ui.gd")

const COLOR_BG := Color("#17211d")
const COLOR_PANEL := Color("#222f29")
const COLOR_PANEL_EDGE := Color("#46584b")
const COLOR_TEXT := Color("#f0ecdc")
const COLOR_MUTED := Color("#bbc5b5")
const COLOR_ACCENT := Color("#d3ae68")
const COLOR_GOOD := Color("#9bb98b")
const COLOR_ALERT := Color("#e2a073")

var recruit_button: Button
var prepare_button: Button
var recovery_label: Label
var encounter_button: Button
var encounter_label: Label
var tabs: TabContainer
var map_board: Control
var day_label: Label
var party_label: Label
var destination_label: Label
var travel_button: Button
var stop_button: Button
var route_label: Label
var objective_label: Label
var resource_label: Label
var contract_reason: Label
var _simulation: RefCounted
var contract_button: Button
var advance_button: Button
var save_button: Button
var load_button: Button
var travel_target_id := "nandipur"
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
	_simulation = simulation
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
	encounter_label.text = simulation.encounter_block_reason()
	if encounter_label.text.is_empty():
		encounter_label.text = "Opposing patrol: 5 troops. Casualties and wounds persist. Campaign time pauses. Save before entering; saving resumes after battle."
	var roster_lines: PackedStringArray = []
	for soldier in campaign_state["encounter"]["roster"]:
		roster_lines.append("%s · %d health" % [soldier["role"], int(soldier["health"])])
	encounter_label.text += "\nRetinue: " + ("; ".join(roster_lines) if not roster_lines.is_empty() else "No surviving troops.")
	encounter_button.disabled = not simulation.encounter_block_reason().is_empty()
	recruit_button.text = "Hire replacement · %d coin + %d grain" % [simulation.ENCOUNTER.RECRUIT_COIN, simulation.ENCOUNTER.RECRUIT_GRAIN]
	recruit_button.disabled = not simulation.recruit_block_reason().is_empty()
	recruit_button.tooltip_text = simulation.recruit_block_reason()
	prepare_button.disabled = not simulation.prepare_patrol_block_reason().is_empty()
	prepare_button.tooltip_text = simulation.prepare_patrol_block_reason()
	var wounded: int = simulation.ENCOUNTER.wounded_count(campaign_state["encounter"])
	var missing: int = simulation.ENCOUNTER.missing_soldiers(campaign_state["encounter"]).size()
	recovery_label.text = "%d wounded · %d vacant places\nRest at home: +%d health per wounded troop/day, %d grain each after household food.\n%s" % [wounded, missing, simulation.ENCOUNTER.HEAL_PER_DAY, simulation.ENCOUNTER.HEAL_GRAIN, simulation.home_service_block_reason()]
	if not simulation.prepare_patrol_block_reason().is_empty():
		recovery_label.text += "\n" + simulation.prepare_patrol_block_reason()
	_refresh_route()
	objective_label.text = simulation.next_objective()
	resource_label.text = "Treasury %d coin  ·  Grain %d  ·  Free storage %d" % [int(simulation.settlement.state["treasury"]), int(simulation.settlement.state["inventory"]["grain"]), simulation.settlement.free_storage()]
	contract_reason.text = simulation.contract_block_reason()
	contract_button.disabled = not contract_reason.text.is_empty()
	contract_button.text = "Arrange %d grain · %d coin" % [simulation.CARAVAN_GRAIN, simulation.CARAVAN_PRICE]
	advance_button.text = "Advance to day %02d" % (simulation.current_day() + 1)
	briefing_label.text = str(superior["obligation"])
	caravan_label.text = _caravan_summary(simulation, caravan)
	lord_label.text = "Governor Amara  ·  standing %d / 100\n%s" % [int(superior["standing"]), str(superior["location_id"]).replace("_", " ").capitalize()]
	merchant_label.text = "%s  ·  %d coin  ·  %d grain" % [str(merchant["name"]), int(merchant["capital"]), int(merchant["inventory_grain"])]
	decision_label.text = str(merchant["last_decision"])
	_refresh_activity(campaign_state.get("activity_log", []))
	_refresh_settlement_tab(simulation)


func set_status(message: String, is_error: bool = false) -> void:
	if settlement_hud != null:
		settlement_hud.set_status(message, is_error)
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
	var subtitle := _label("DECCAN LORDS  ·  CAMPAIGN", 12, COLOR_MUTED)
	identity.add_child(subtitle)
	day_label = _label("DAY 01", 17, COLOR_TEXT)
	day_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(day_label)
	var divider := HSeparator.new()
	divider.add_theme_color_override("color", COLOR_PANEL_EDGE)
	parent.add_child(divider)
	resource_label = _label("", 14, COLOR_TEXT)
	parent.add_child(resource_label)


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
	objective_label = _label("", 15, COLOR_ACCENT)
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	left.add_child(objective_label)
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
	map_board.location_selected.connect(func(id: String) -> void:
		travel_target_id = id
		_refresh_route()
	)
	var map_footer := _label("GOLD FLAG: retinue  ·  GREEN WAGON: caravan  ·  GOLD ROAD: selected route", 11, COLOR_MUTED)
	left.add_child(map_footer)
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
	_build_section(sections, "LOCATION & ORDERS", func(content: VBoxContainer) -> void:
		party_status_label = _label("", 13, COLOR_TEXT)
		party_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(party_status_label)
		route_label = _label("", 13, COLOR_MUTED)
		route_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(route_label)
		travel_button = _button("Travel", true)
		travel_button.pressed.connect(func() -> void: travel_requested.emit(travel_target_id))
		content.add_child(travel_button)
		stop_button = _button("Halt at current location", false)
		stop_button.pressed.connect(func() -> void: stop_requested.emit())
		content.add_child(stop_button)
	)
	_build_section(sections, "KALDAR PASS · OPTIONAL SKIRMISH", func(content: VBoxContainer) -> void:
		encounter_label = _label("", 12, COLOR_MUTED)
		encounter_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(encounter_label)
		encounter_button = _button("Confront patrol", false)
		encounter_button.pressed.connect(func() -> void: encounter_requested.emit())
		content.add_child(encounter_button)
	)
	_build_section(sections, "RETINUE · HOME SERVICES", func(content: VBoxContainer) -> void:
		recovery_label = _label("", 12, COLOR_MUTED)
		recovery_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(recovery_label)
		recruit_button = _button("Hire replacement · 12 coin + 2 grain", false)
		recruit_button.pressed.connect(func() -> void: recruit_requested.emit())
		content.add_child(recruit_button)
		prepare_button = _button("Prepare next patrol", false)
		prepare_button.pressed.connect(func() -> void: prepare_patrol_requested.emit())
		content.add_child(prepare_button)
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
		contract_reason = _label("", 12, COLOR_MUTED)
		contract_reason.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content.add_child(contract_reason)
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
	settlement_hud = preload("res://src/settlement/m3_settlement_hud.gd").new()
	settlement_hud.name = "Keshavwadi Settlement"
	tabs.add_child(settlement_hud)


func _refresh_settlement_tab(simulation: RefCounted) -> void:
	settlement_hud.refresh(simulation.settlement)


func _refresh_route() -> void:
	if _simulation == null:
		return
	var origin: String = _simulation.player_location_id()
	var route: Array = REGION.find_route(origin, travel_target_id)
	var names: PackedStringArray = []
	for id in route:
		names.append(_simulation.location_name(id))
	var busy: bool = not _simulation.state["player_party"]["route"].is_empty()
	route_label.text = "%s\n%s\n%s" % [_simulation.location_name(travel_target_id), REGION.LOCATION_DATA[travel_target_id]["description"], "Already here." if route.is_empty() else " → ".join(names) + " · %d days" % route.size()]
	travel_button.text = "Halt before changing route" if busy else "Issue travel order"
	travel_button.disabled = busy or route.is_empty()
	stop_button.disabled = not busy
	map_board.select_location(travel_target_id, route)


func _refresh_activity(entries: Array) -> void:
	for child in activity_list.get_children():
		activity_list.remove_child(child)
		child.queue_free()
	for index in range(entries.size() - 1, maxi(-1, entries.size() - 6), -1):
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
		return "%d grain · at %s · escorted days %d\nMoves only while your retinue accompanies it toward Keshavwadi." % [int(caravan["cargo_grain"]), simulation.location_name(str(caravan["location_id"])), int(caravan["escorted_days"])]
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
	return UI.panel_style()


func _label(text_value: String, size: int, color: Color) -> Label:
	return UI.label(text_value, size, color)


func _button(text_value: String, prominent: bool) -> Button:
	return UI.button(text_value, prominent)


var party_status_label: Label
var settlement_hud: Control
