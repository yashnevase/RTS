extends Control

const SIMULATION_SCRIPT := preload("res://src/campaign/m4_campaign_simulation.gd")
const HUD_SCRIPT := preload("res://src/campaign/m4_campaign_hud.gd")
const SAVE_STORE_SCRIPT := preload("res://src/campaign/m4_campaign_save_store.gd")

var simulation: RefCounted
var hud: Control
var save_path := SAVE_STORE_SCRIPT.DEFAULT_PATH


func _ready() -> void:
	simulation = SIMULATION_SCRIPT.new()
	simulation.reset()
	hud = HUD_SCRIPT.new()
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(hud)
	hud.travel_requested.connect(_on_travel_requested)
	hud.contract_requested.connect(_on_contract_requested)
	hud.advance_requested.connect(_on_advance_requested)
	hud.save_requested.connect(_on_save_requested)
	hud.load_requested.connect(_on_load_requested)
	_connect_settlement_hud()
	hud.refresh(simulation)


func save_to(path: String = "") -> Dictionary:
	if path.is_empty():
		path = save_path
	return SAVE_STORE_SCRIPT.save_campaign(simulation, path)


func load_from(path: String = "") -> Dictionary:
	if path.is_empty():
		path = save_path
	return SAVE_STORE_SCRIPT.load_campaign(simulation, path)


func _connect_settlement_hud() -> void:
	var settlement_hud: Control = hud.settlement_hud
	settlement_hud.labor_changed.connect(_on_labor_changed)
	settlement_hud.tax_changed.connect(_on_tax_changed)
	settlement_hud.advance_requested.connect(_on_advance_requested)
	settlement_hud.save_requested.connect(_on_save_requested)
	settlement_hud.load_requested.connect(_on_load_requested)
	settlement_hud.trade_requested.connect(_on_trade_requested)


func _refresh() -> void:
	hud.refresh(simulation)
	if hud.settlement_hud != null:
		hud.settlement_hud.refresh(simulation.settlement)


func _on_travel_requested(destination_id: String) -> void:
	if not simulation.request_travel(destination_id):
		hud.set_status(simulation.last_error, true)
	else:
		hud.set_status("Travel order set for %s." % simulation.location_name(destination_id))
	_refresh()


func _on_contract_requested() -> void:
	if not simulation.accept_escort_contract():
		hud.set_status(simulation.last_error, true)
	else:
		hud.set_status("Contract reserved. Issue a Keshavwadi travel order to announce the escort.")
	_refresh()


func _on_advance_requested() -> void:
	var report: Dictionary = simulation.advance_day()
	var summary := "Day %02d settled." % int(report["day"])
	if not str(report["merchant_decision"]).is_empty():
		summary += " " + str(report["merchant_decision"])
	elif not str(report["party_movement"]).is_empty():
		summary += " " + str(report["party_movement"])
	if bool(report["delivery_completed"]):
		summary = "Convoy delivered: 12 grain reached Keshavwadi; Governor Amara's standing improved."
	hud.set_status(summary)
	_refresh()


func _on_save_requested() -> void:
	var result: Dictionary = save_to()
	hud.set_status(str(result["message"]), not bool(result["ok"]))


func _on_load_requested() -> void:
	var result: Dictionary = load_from()
	hud.set_status(str(result["message"]), not bool(result["ok"]))
	_refresh()


func _on_labor_changed(job: String, workers: int) -> void:
	if not simulation.settlement.set_job_workers(job, workers):
		hud.set_status(simulation.settlement.last_error, true)
	else:
		hud.set_status("%d workers assigned to %s." % [workers, simulation.settlement.JOB_LABELS[job]])
	_refresh()


func _on_tax_changed(level: int) -> void:
	if not simulation.settlement.set_tax_level(level):
		hud.set_status(simulation.settlement.last_error, true)
	else:
		hud.set_status("Settlement tax setting updated.")
	_refresh()


func _on_trade_requested(good: String, direction: String, quantity: int) -> void:
	if not simulation.settlement.trade(good, direction, quantity):
		hud.set_status(simulation.settlement.last_error, true)
	else:
		hud.set_status("%s %d %s." % ["Bought" if direction == "buy" else "Sold", quantity, good])
	_refresh()
