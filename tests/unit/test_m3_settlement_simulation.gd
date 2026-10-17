extends SceneTree

const SIMULATION_SCRIPT := preload("res://src/settlement/settlement_simulation.gd")
const SAVE_STORE_SCRIPT := preload("res://src/settlement/settlement_save_store.gd")
const TEST_SAVE_PATH := "user://m3_test_saves/settlement.json"

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_starting_state_and_labour_limits()
	_test_production_consumption_tax_and_upkeep()
	_test_input_shortage_and_alert_priority()
	_test_storehouse_capacity()
	_test_market_transfers_and_rejections()
	_test_tax_and_upkeep_arrears()
	_test_save_roundtrip_and_validation()
	_test_save_store_file_roundtrip_and_corruption()
	if failures.is_empty():
		print("M3 settlement checks passed (8 groups).")
		quit()
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _test_starting_state_and_labour_limits() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_expect(sim.household_count() == 19, "Settlement should contain three household groups")
	_expect(sim.population_count() == 76, "Household population should aggregate correctly")
	_expect(sim.assigned_workers() == 13 and sim.unassigned_workers() == 17, "Available labour should reconcile with assignments")
	_expect(sim.set_job_workers("farm", 15), "Valid labour reassignment should be accepted")
	_expect(not sim.set_job_workers("mill", -1), "Negative labour should be rejected")
	_expect(not sim.set_job_workers("woodcut", 16), "Assignments exceeding available workers should be rejected")
	_expect(sim.set_job_workers("woodcut", 13), "An assignment exactly at the workforce limit should be accepted")
	_expect(not sim.set_job_workers("unknown", 1), "Unknown production activity should be rejected")


func _test_production_consumption_tax_and_upkeep() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	var report: Dictionary = sim.advance_day()
	_expect(report["grain_produced"] == 16, "Farms should produce two grain per assigned worker")
	_expect(report["timber_produced"] == 3, "Woodcutters should produce one timber per assigned worker")
	_expect(report["grain_used_by_mill"] == 4 and report["flour_produced"] == 2, "Mill should convert two grain into one flour per worker")
	_expect(report["grain_consumed"] == 7 and report["grain_shortage"] == 0, "Household grain need should be supplied before reporting a shortage")
	_expect(sim.state["inventory"]["grain"] == 49, "Production and consumption should reconcile grain stock")
	_expect(sim.state["inventory"]["timber"] == 21 and sim.state["inventory"]["flour"] == 8, "Produced goods should enter the storehouse")
	_expect(report["tax_collected"] == 6 and report["upkeep_due"] == 10, "Prototype tax and upkeep should calculate as described")
	_expect(sim.state["treasury"] == 86 and sim.state["upkeep_arrears"] == 0, "Taxes and upkeep should reconcile the settlement treasury")


func _test_input_shortage_and_alert_priority() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	sim.state["assignments"] = {"farm": 0, "woodcut": 0, "mill": 5}
	sim.state["inventory"] = {"grain": 2, "timber": 0, "flour": 0}
	var report: Dictionary = sim.advance_day()
	_expect(report["flour_produced"] == 1 and report["grain_used_by_mill"] == 2, "Mill should use only the inputs actually available")
	_expect(report["grain_shortage"] == 7, "Households should report the unmet food amount")
	_expect(not sim.state["alerts"].is_empty() and int(sim.state["alerts"][0]["priority"]) == 3, "Food shortage should lead prioritized notices")
	_expect(sim.last_error.is_empty(), "Successful day settlement should clear command errors")


func _test_storehouse_capacity() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	sim.state["inventory"] = {"grain": 50, "timber": 50, "flour": 40}
	var report: Dictionary = sim.advance_day()
	_expect(report["grain_produced"] == 0 and report["timber_produced"] == 0, "Storehouse should block production when full")
	_expect(sim.storage_used() <= int(sim.state["warehouse_capacity"]), "Production must not exceed storehouse capacity")
	_expect(sim.state["alerts"].any(func(alert: Dictionary) -> bool: return str(alert["message"]).contains("capacity")), "Blocked production should be explained in notices")


func _test_market_transfers_and_rejections() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	var total_coin_before := int(sim.state["treasury"]) + int(sim.state["market_coin"])
	var total_grain_before := int(sim.state["inventory"]["grain"]) + int(sim.state["market_inventory"]["grain"])
	_expect(sim.trade("grain", "buy", 3), "Affordable market purchase should succeed")
	_expect(sim.state["treasury"] == 81 and sim.state["market_coin"] == 259, "Purchase should transfer coin between settlement and market")
	_expect(sim.state["inventory"]["grain"] == 47 and sim.state["market_inventory"]["grain"] == 45, "Purchase should transfer goods between stocks")
	_expect(sim.trade("grain", "sell", 2), "Sale of stored goods should succeed")
	_expect(sim.state["treasury"] == 85 and sim.state["market_coin"] == 255, "Sale proceeds should transfer from finite market funds")
	_expect(sim.state["inventory"]["grain"] + sim.state["market_inventory"]["grain"] == total_grain_before, "Trade must not create or destroy goods")
	_expect(sim.state["treasury"] + sim.state["market_coin"] == total_coin_before, "Trade must not create or destroy coin")
	_expect(not sim.trade("grain", "sell", 1000), "Sale above local inventory must be rejected")
	_expect(not sim.trade("grain", "buy", 49), "Purchase above market stock must be rejected")
	_expect(not sim.trade("unknown", "buy", 1), "Unknown good must be rejected")
	_expect(not sim.trade("flour", "buy", 0), "Zero quantity must be rejected")
	sim.state["warehouse_capacity"] = sim.storage_used()
	_expect(not sim.trade("grain", "buy", 1), "Purchase without storehouse capacity must be rejected")
	sim.state["warehouse_capacity"] = 140
	sim.state["market_inventory"] = {"grain": 200, "timber": 24, "flour": 16}
	_expect(not sim.trade("grain", "sell", 1), "Market storage capacity must limit further sales")
	sim.state["market_inventory"] = {"grain": 48, "timber": 24, "flour": 16}
	sim.state["treasury"] = 0
	_expect(not sim.trade("timber", "buy", 1), "Purchase without enough settlement funds must be rejected")
	sim.state["treasury"] = 90
	sim.state["market_coin"] = 0
	_expect(not sim.trade("grain", "sell", 1), "Sale without enough market funds must be rejected")


func _test_tax_and_upkeep_arrears() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_expect(sim.set_tax_level(2), "High tax setting should be accepted")
	_expect(sim.daily_tax_income() == 12, "High tax income should follow the prototype formula")
	sim.state["treasury"] = 0
	var report: Dictionary = sim.advance_day()
	_expect(report["tax_collected"] == 12 and report["upkeep_paid"] == 10, "Tax should be collected before due upkeep")
	_expect(sim.state["treasury"] == 2 and sim.state["upkeep_arrears"] == 0, "Treasury should retain remaining coin after upkeep")
	sim.state["treasury"] = 0
	sim.state["tax_level"] = 0
	var second_report: Dictionary = sim.advance_day()
	_expect(second_report["upkeep_paid"] == 0 and sim.state["upkeep_arrears"] == 10, "Unpaid upkeep should be carried as arrears")
	var third_report: Dictionary = sim.advance_day()
	_expect(third_report["upkeep_unpaid"] == 20, "Unpaid upkeep should remain visible and accumulate across days")
	_expect(not sim.set_tax_level(3), "Unsupported tax level must be rejected")


func _test_save_roundtrip_and_validation() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	sim.trade("timber", "sell", 3)
	sim.advance_day()
	var expected: Dictionary = sim.to_save_data()
	var clone: RefCounted = SIMULATION_SCRIPT.new()
	clone.reset()
	_expect(clone.load_save_data(expected), "Valid versioned save data should load")
	_expect(clone.state == expected["state"], "Save/load should preserve all settlement state")
	var before_invalid_load: Dictionary = clone.state.duplicate(true)
	var invalid_data: Dictionary = expected.duplicate(true)
	invalid_data["state"]["assignments"]["mill"] = 100
	_expect(not clone.load_save_data(invalid_data), "Malformed labour data must be rejected")
	_expect(clone.state == before_invalid_load, "Failed load must leave the active settlement unchanged")
	var invalid_alerts: Dictionary = expected.duplicate(true)
	invalid_alerts["state"]["alerts"] = ["not an alert dictionary"]
	_expect(not clone.load_save_data(invalid_alerts), "Malformed notice data must be rejected safely")
	_expect(clone.state == before_invalid_load, "Malformed notice load must leave the active settlement unchanged")
	_expect(not clone.load_save_data({"schema_version": 999, "state": {}}), "Unknown save version must be rejected")
	_expect(not clone.load_save_data("bad save"), "Non-dictionary save data must be rejected")


func _test_save_store_file_roundtrip_and_corruption() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	sim.advance_day()
	var save_result: Dictionary = SAVE_STORE_SCRIPT.save_simulation(sim, TEST_SAVE_PATH)
	_expect(bool(save_result["ok"]), "Save adapter should write a JSON save to its requested path")
	sim.advance_day()
	var replacement_expected: Dictionary = sim.state.duplicate(true)
	var replacement_result: Dictionary = SAVE_STORE_SCRIPT.save_simulation(sim, TEST_SAVE_PATH)
	_expect(bool(replacement_result["ok"]), "Save adapter should safely replace an existing save")
	sim.advance_day()
	var load_result: Dictionary = SAVE_STORE_SCRIPT.load_simulation(sim, TEST_SAVE_PATH)
	_expect(bool(load_result["ok"]), "Save adapter should read a valid JSON save")
	_expect(sim.state == replacement_expected, "File save/load should restore the latest replaced save")
	var absolute_test_path := ProjectSettings.globalize_path(TEST_SAVE_PATH)
	var corrupt_file := FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	corrupt_file.store_string("not json")
	corrupt_file.close()
	var before_corrupt_load: Dictionary = sim.state.duplicate(true)
	var corrupt_result: Dictionary = SAVE_STORE_SCRIPT.load_simulation(sim, TEST_SAVE_PATH)
	_expect(not bool(corrupt_result["ok"]), "Corrupt JSON should be rejected")
	_expect(sim.state == before_corrupt_load, "Corrupt load must not damage current simulation state")
	DirAccess.remove_absolute(absolute_test_path)
	DirAccess.remove_absolute(absolute_test_path + ".tmp")
	DirAccess.remove_absolute(absolute_test_path + ".bak")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://m3_test_saves"))


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
