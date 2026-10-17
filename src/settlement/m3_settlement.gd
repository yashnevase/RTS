extends Control

const SIMULATION_SCRIPT := preload("res://src/settlement/settlement_simulation.gd")
const HUD_SCRIPT := preload("res://src/settlement/m3_settlement_hud.gd")
const SAVE_STORE_SCRIPT := preload("res://src/settlement/settlement_save_store.gd")

var simulation: RefCounted
var hud: Control
var save_path := SAVE_STORE_SCRIPT.DEFAULT_PATH


func _ready() -> void:
	simulation = SIMULATION_SCRIPT.new()
	simulation.reset()
	hud = HUD_SCRIPT.new()
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(hud)
	hud.labor_changed.connect(_on_labor_changed)
	hud.tax_changed.connect(_on_tax_changed)
	hud.advance_requested.connect(_on_advance_requested)
	hud.save_requested.connect(_on_save_requested)
	hud.load_requested.connect(_on_load_requested)
	hud.trade_requested.connect(_on_trade_requested)
	hud.refresh(simulation)


func save_to(path: String = "") -> Dictionary:
	if path.is_empty():
		path = save_path
	return SAVE_STORE_SCRIPT.save_simulation(simulation, path)


func load_from(path: String = "") -> Dictionary:
	if path.is_empty():
		path = save_path
	return SAVE_STORE_SCRIPT.load_simulation(simulation, path)


func _on_labor_changed(job: String, workers: int) -> void:
	if not simulation.set_job_workers(job, workers):
		hud.set_status(simulation.last_error, true)
	else:
		hud.set_status("%s assigned to %s." % [workers, simulation.JOB_LABELS[job]])
	hud.refresh(simulation)


func _on_tax_changed(level: int) -> void:
	if not simulation.set_tax_level(level):
		hud.set_status(simulation.last_error, true)
	else:
		hud.set_status("Tax setting updated. Broader household effects are not part of this prototype.")
	hud.refresh(simulation)


func _on_advance_requested() -> void:
	var report: Dictionary = simulation.advance_day()
	hud.set_status("Day %d settled: %d grain, %d timber, %d flour produced." % [int(report["day"]), int(report["grain_produced"]), int(report["timber_produced"]), int(report["flour_produced"])])
	hud.refresh(simulation)


func _on_save_requested() -> void:
	var result: Dictionary = save_to()
	hud.set_status(str(result["message"]), not bool(result["ok"]))


func _on_load_requested() -> void:
	var result: Dictionary = load_from()
	hud.set_status(str(result["message"]), not bool(result["ok"]))
	hud.refresh(simulation)


func _on_trade_requested(good: String, direction: String, quantity: int) -> void:
	if not simulation.trade(good, direction, quantity):
		hud.set_status(simulation.last_error, true)
	else:
		hud.set_status("%s %d %s." % ["Bought" if direction == "buy" else "Sold", quantity, good])
	hud.refresh(simulation)
