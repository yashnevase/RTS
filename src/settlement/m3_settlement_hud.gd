extends Control

signal labor_changed(job: String, workers: int)
signal tax_changed(level: int)
signal advance_requested
signal save_requested
signal load_requested
signal trade_requested(good: String, direction: String, quantity: int)

const SIMULATION_SCRIPT := preload("res://src/settlement/settlement_simulation.gd")
const GOODS := ["grain", "timber", "flour"]
const GOOD_LABELS := {"grain": "Grain", "timber": "Timber", "flour": "Flour"}
const JOBS := ["farm", "woodcut", "mill"]
const JOB_LABELS := {"farm": "Farming", "woodcut": "Woodcutting", "mill": "Milling"}

const COLOR_BG := Color("#17211d")
const COLOR_PANEL := Color("#222f29")
const COLOR_PANEL_EDGE := Color("#46584b")
const COLOR_TEXT := Color("#f0ecdc")
const COLOR_MUTED := Color("#bbc5b5")
const COLOR_ACCENT := Color("#d3ae68")
const COLOR_ALERT := Color("#e2a073")
const COLOR_URGENT := Color("#e17b70")
const COLOR_GOOD := Color("#9bb98b")

var settlement_name_label: Label
var day_label: Label
var population_label: Label
var treasury_label: Label
var market_coin_label: Label
var worker_total_label: Label
var tax_option: OptionButton
var tax_summary_label: Label
var warehouse_summary_label: Label
var goods_labels: Dictionary = {}
var market_stock_labels: Dictionary = {}
var worker_spins: Dictionary = {}
var trade_spins: Dictionary = {}
var report_label: Label
var alerts_list: VBoxContainer
var status_label: Label
var advance_button: Button
var save_button: Button
var load_button: Button
var buy_buttons: Dictionary = {}
var sell_buttons: Dictionary = {}


func _ready() -> void:
	_build_layout()
	set_status("Adjust labour, trade goods, then advance one day.")


func refresh(simulation: RefCounted) -> void:
	if settlement_name_label == null:
		return
	settlement_name_label.text = str(simulation.state["settlement_name"]).to_upper()
	day_label.text = "DAY %02d" % int(simulation.state["day"])
	population_label.text = "%d households  ·  %d people  ·  %d workers" % [simulation.household_count(), simulation.population_count(), int(simulation.state["workers_available"])]
	treasury_label.text = "%d  COIN" % int(simulation.state["treasury"])
	worker_total_label.text = "%d assigned  ·  %d unassigned" % [simulation.assigned_workers(), simulation.unassigned_workers()]
	for job in JOBS:
		worker_spins[job].max_value = int(simulation.state["workers_available"])
		worker_spins[job].set_value_no_signal(int(simulation.state["assignments"][job]))
	tax_option.select(int(simulation.state["tax_level"]))
	tax_summary_label.text = "Tax income %d / day  ·  Upkeep %d / day  ·  Arrears %d" % [simulation.daily_tax_income(), simulation.daily_upkeep(), int(simulation.state["upkeep_arrears"])]
	warehouse_summary_label.text = "%d / %d units stored" % [simulation.storage_used(), int(simulation.state["warehouse_capacity"])]
	for good in GOODS:
		var inventory: Dictionary = simulation.state["inventory"]
		var market_inventory: Dictionary = simulation.state["market_inventory"]
		goods_labels[good].text = "%s   %d" % [GOOD_LABELS[good], int(inventory[good])]
		market_stock_labels[good].text = "Market %d  ·  Buy %d  ·  Sell %d" % [int(market_inventory[good]), int(SIMULATION_SCRIPT.BUY_PRICES[good]), int(SIMULATION_SCRIPT.SELL_PRICES[good])]
		trade_spins[good].max_value = 20
		trade_spins[good].value = clampi(int(trade_spins[good].value), 1, 20)
	market_coin_label.text = "Merchant float is finite  ·  coin %d" % int(simulation.state["market_coin"])
	var report: Dictionary = simulation.state.get("last_report", {})
	if report.is_empty():
		report_label.text = "No day has been settled yet. Household grain need is %d per day." % int(ceil(float(simulation.population_count()) / 12.0))
	else:
		report_label.text = "DAY %02d SETTLEMENT\n+%d grain · +%d timber · +%d flour\nHouseholds used %d grain%s\nTax +%d coin · upkeep −%d coin · unpaid %d" % [int(report["day"]), int(report["grain_produced"]), int(report["timber_produced"]), int(report["flour_produced"]), int(report["grain_consumed"]), (" · shortage %d" % int(report["grain_shortage"]) if int(report["grain_shortage"]) > 0 else ""), int(report["tax_collected"]), int(report["upkeep_paid"]), int(report["upkeep_unpaid"])]
	_refresh_alerts(simulation.state.get("alerts", []))


func set_status(message: String, is_error: bool = false) -> void:
	if status_label != null:
		status_label.text = message
		status_label.add_theme_color_override("font_color", COLOR_URGENT if is_error else COLOR_MUTED)


func _build_layout() -> void:
	var background := ColorRect.new()
	background.color = COLOR_BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var margins := MarginContainer.new()
	margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margins.add_theme_constant_override("margin_" + side, 28)
	for side in ["top", "bottom"]:
		margins.add_theme_constant_override("margin_" + side, 22)
	add_child(margins)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 15)
	margins.add_child(page)
	_build_header(page)
	var body_scroll := ScrollContainer.new()
	body_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	page.add_child(body_scroll)
	var columns := HBoxContainer.new()
	columns.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 16)
	body_scroll.add_child(columns)
	var left_column := VBoxContainer.new()
	left_column.custom_minimum_size.x = 470.0
	left_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_column.add_theme_constant_override("separation", 12)
	columns.add_child(left_column)
	var right_column := VBoxContainer.new()
	right_column.custom_minimum_size.x = 550.0
	right_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_column.add_theme_constant_override("separation", 12)
	columns.add_child(right_column)
	_build_households(left_column)
	_build_production(left_column)
	_build_settlement_controls(left_column)
	_build_storehouse(right_column)
	_build_market(right_column)
	_build_updates(right_column)
	status_label = Label.new()
	status_label.custom_minimum_size.y = 23
	status_label.add_theme_font_size_override("font_size", 14)
	page.add_child(status_label)


func _build_header(parent: VBoxContainer) -> void:
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 20)
	parent.add_child(header)
	var identity := VBoxContainer.new()
	identity.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	identity.add_theme_constant_override("separation", 3)
	header.add_child(identity)
	settlement_name_label = Label.new()
	settlement_name_label.add_theme_font_size_override("font_size", 27)
	settlement_name_label.add_theme_color_override("font_color", COLOR_ACCENT)
	identity.add_child(settlement_name_label)
	var subtitle := Label.new()
	subtitle.text = "SETTLEMENT LEDGER  ·  PROTOTYPE ECONOMY"
	subtitle.add_theme_font_size_override("font_size", 12)
	subtitle.add_theme_color_override("font_color", COLOR_MUTED)
	identity.add_child(subtitle)
	population_label = Label.new()
	population_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	population_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	population_label.add_theme_font_size_override("font_size", 15)
	population_label.add_theme_color_override("font_color", COLOR_TEXT)
	header.add_child(population_label)
	var finance := VBoxContainer.new()
	finance.custom_minimum_size.x = 140
	finance.alignment = BoxContainer.ALIGNMENT_CENTER
	header.add_child(finance)
	day_label = Label.new()
	day_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	day_label.add_theme_font_size_override("font_size", 14)
	day_label.add_theme_color_override("font_color", COLOR_MUTED)
	finance.add_child(day_label)
	treasury_label = Label.new()
	treasury_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	treasury_label.add_theme_font_size_override("font_size", 21)
	treasury_label.add_theme_color_override("font_color", COLOR_ACCENT)
	finance.add_child(treasury_label)
	var rule := HSeparator.new()
	rule.add_theme_color_override("color", COLOR_PANEL_EDGE)
	parent.add_child(rule)


func _build_households(parent: VBoxContainer) -> void:
	var content := _make_section(parent, "HOUSEHOLDS & WORKFORCE")
	for group in [
		{"name": "Field households", "detail": "8 households  ·  32 people"},
		{"name": "Woodland households", "detail": "5 households  ·  20 people"},
		{"name": "Market households", "detail": "6 households  ·  24 people"},
	]:
		var row := HBoxContainer.new()
		content.add_child(row)
		var name_label := _label(str(group["name"]), 14, COLOR_TEXT)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(name_label)
		row.add_child(_label(str(group["detail"]), 13, COLOR_MUTED))
	worker_total_label = _label("", 13, COLOR_ACCENT)
	content.add_child(worker_total_label)


func _build_production(parent: VBoxContainer) -> void:
	var content := _make_section(parent, "PRODUCTION ASSIGNMENTS")
	var descriptions := {"farm": "2 grain per worker  ·  day", "woodcut": "1 timber per worker  ·  day", "mill": "2 grain → 1 flour  ·  worker-day"}
	for job in JOBS:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		content.add_child(row)
		var labels := VBoxContainer.new()
		labels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		labels.add_child(_label(JOB_LABELS[job], 15, COLOR_TEXT))
		labels.add_child(_label(descriptions[job], 12, COLOR_MUTED))
		row.add_child(labels)
		var spin := SpinBox.new()
		spin.min_value = 0
		spin.max_value = 30
		spin.step = 1
		spin.custom_minimum_size.x = 88
		spin.tooltip_text = "Workers assigned to %s" % JOB_LABELS[job]
		spin.value_changed.connect(func(value: float) -> void: labor_changed.emit(job, int(value)))
		row.add_child(spin)
		worker_spins[job] = spin


func _build_settlement_controls(parent: VBoxContainer) -> void:
	var content := _make_section(parent, "GOVERNANCE & DAY END")
	var policy_row := HBoxContainer.new()
	content.add_child(policy_row)
	var policy_label := _label("Tax level", 14, COLOR_TEXT)
	policy_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	policy_row.add_child(policy_label)
	tax_option = OptionButton.new()
	tax_option.add_item("None")
	tax_option.add_item("Standard")
	tax_option.add_item("High")
	tax_option.item_selected.connect(func(index: int) -> void: tax_changed.emit(index))
	policy_row.add_child(tax_option)
	tax_summary_label = _label("", 13, COLOR_MUTED)
	content.add_child(tax_summary_label)
	var help := _label("Prototype only: taxes affect coin; household response is not simulated yet.", 12, COLOR_MUTED)
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(help)
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	content.add_child(buttons)
	advance_button = _button("Advance day", true)
	advance_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	advance_button.pressed.connect(func() -> void: advance_requested.emit())
	buttons.add_child(advance_button)
	save_button = _button("Save", false)
	save_button.pressed.connect(func() -> void: save_requested.emit())
	buttons.add_child(save_button)
	load_button = _button("Load", false)
	load_button.pressed.connect(func() -> void: load_requested.emit())
	buttons.add_child(load_button)


func _build_storehouse(parent: VBoxContainer) -> void:
	var content := _make_section(parent, "STOREHOUSE")
	warehouse_summary_label = _label("", 13, COLOR_MUTED)
	content.add_child(warehouse_summary_label)
	for good in GOODS:
		var row := HBoxContainer.new()
		content.add_child(row)
		var label := _label("", 15, COLOR_TEXT)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)
		goods_labels[good] = label


func _build_market(parent: VBoxContainer) -> void:
	var content := _make_section(parent, "MARKET EXCHANGE")
	market_coin_label = _label("", 13, COLOR_MUTED)
	content.add_child(market_coin_label)
	for good in GOODS:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 7)
		content.add_child(row)
		var labels := VBoxContainer.new()
		labels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(labels)
		labels.add_child(_label(GOOD_LABELS[good], 14, COLOR_TEXT))
		var stock_label := _label("", 11, COLOR_MUTED)
		labels.add_child(stock_label)
		market_stock_labels[good] = stock_label
		var amount_spin := SpinBox.new()
		amount_spin.min_value = 1
		amount_spin.max_value = 20
		amount_spin.step = 1
		amount_spin.value = 5
		amount_spin.custom_minimum_size.x = 79
		amount_spin.tooltip_text = "Trade quantity"
		row.add_child(amount_spin)
		var buy_button := _button("Buy", false)
		buy_button.pressed.connect(func() -> void: trade_requested.emit(good, "buy", int(amount_spin.value)))
		row.add_child(buy_button)
		buy_buttons[good] = buy_button
		var sell_button := _button("Sell", false)
		sell_button.pressed.connect(func() -> void: trade_requested.emit(good, "sell", int(amount_spin.value)))
		row.add_child(sell_button)
		sell_buttons[good] = sell_button
		trade_spins[good] = amount_spin


func _build_updates(parent: VBoxContainer) -> void:
	var report_content := _make_section(parent, "LATEST SETTLEMENT")
	report_label = _label("", 13, COLOR_TEXT)
	report_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_content.add_child(report_label)
	var alerts_content := _make_section(parent, "PRIORITY NOTICES")
	alerts_list = VBoxContainer.new()
	alerts_list.add_theme_constant_override("separation", 5)
	alerts_content.add_child(alerts_list)


func _refresh_alerts(alerts: Array) -> void:
	for child in alerts_list.get_children():
		child.queue_free()
	if alerts.is_empty():
		alerts_list.add_child(_label("No active notices.", 13, COLOR_MUTED))
		return
	for alert_value in alerts:
		var alert: Dictionary = alert_value
		var priority := int(alert.get("priority", 1))
		var prefix := "URGENT" if priority >= 3 else ("WATCH" if priority == 2 else "INFO")
		var color := COLOR_URGENT if priority >= 3 else (COLOR_ALERT if priority == 2 else COLOR_MUTED)
		var notice := _label("%s  ·  D%d  ·  %s" % [prefix, int(alert.get("day", 1)), str(alert.get("message", ""))], 12, color)
		notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		alerts_list.add_child(notice)


func _make_section(parent: VBoxContainer, title: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style())
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 7)
	panel.add_child(content)
	var heading := _label(title, 13, COLOR_ACCENT)
	heading.add_theme_font_size_override("font_size", 14)
	content.add_child(heading)
	var divider := HSeparator.new()
	divider.add_theme_color_override("color", COLOR_PANEL_EDGE)
	content.add_child(divider)
	return content


func _panel_style() -> StyleBoxFlat:
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


func _label(text_value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


func _button(text_value: String, prominent: bool) -> Button:
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
	return button
