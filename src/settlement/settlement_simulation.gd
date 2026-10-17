extends RefCounted

## Deterministic settlement rules for the M3 prototype.
## Every quantity and formula here is prototype tuning, not a historical claim.

const SAVE_VERSION := 1
const GOODS := ["grain", "timber", "flour"]
const JOBS := ["farm", "woodcut", "mill"]
const JOB_LABELS := {
	"farm": "Farming",
	"woodcut": "Woodcutting",
	"mill": "Milling",
}
const BUY_PRICES := {"grain": 3, "timber": 4, "flour": 5}
const SELL_PRICES := {"grain": 2, "timber": 3, "flour": 4}
const MARKET_CAPACITY := 240
const MAX_ALERTS := 8

var state: Dictionary = {}
var last_error := ""


func reset() -> void:
	last_error = ""
	state = {
		"day": 1,
		"settlement_name": "Keshavwadi",
		"households": [
			{"id": "field", "name": "Field households", "households": 8, "population": 32},
			{"id": "woodland", "name": "Woodland households", "households": 5, "population": 20},
			{"id": "market", "name": "Market households", "households": 6, "population": 24},
		],
		"workers_available": 30,
		"assignments": {"farm": 8, "woodcut": 3, "mill": 2},
		"inventory": {"grain": 44, "timber": 18, "flour": 6},
		"warehouse_capacity": 140,
		"treasury": 90,
		"tax_level": 1,
		"upkeep_arrears": 0,
		"market_coin": 250,
		"market_inventory": {"grain": 48, "timber": 24, "flour": 16},
		"alerts": [],
		"last_report": {},
	}
	_add_alert(1, "Settlement ledger ready. Values are temporary prototype tuning.")


func household_count() -> int:
	var total := 0
	for group_value in state.get("households", []):
		var group: Dictionary = group_value
		total += int(group.get("households", 0))
	return total


func population_count() -> int:
	var total := 0
	for group_value in state.get("households", []):
		var group: Dictionary = group_value
		total += int(group.get("population", 0))
	return total


func assigned_workers() -> int:
	var total := 0
	for job in JOBS:
		total += int(state.get("assignments", {}).get(job, 0))
	return total


func unassigned_workers() -> int:
	return int(state.get("workers_available", 0)) - assigned_workers()


func storage_used() -> int:
	return _inventory_total(state.get("inventory", {}))


func free_storage() -> int:
	return int(state.get("warehouse_capacity", 0)) - storage_used()


func daily_tax_income() -> int:
	return int(floor(float(household_count() * int(state.get("tax_level", 0))) / 3.0))


func daily_upkeep() -> int:
	var active_activities := 0
	for job in JOBS:
		if int(state.get("assignments", {}).get(job, 0)) > 0:
			active_activities += 1
	return 4 + active_activities * 2


func set_job_workers(job: String, workers: int) -> bool:
	if job not in JOBS:
		return _reject("That production activity is not available.")
	if workers < 0:
		return _reject("Worker assignments cannot be negative.")
	var other_workers := assigned_workers() - int(state["assignments"][job])
	if other_workers + workers > int(state["workers_available"]):
		return _reject("Only %d unassigned workers are available." % unassigned_workers())
	state["assignments"][job] = workers
	last_error = ""
	return true


func set_tax_level(level: int) -> bool:
	if level < 0 or level > 2:
		return _reject("Tax setting must be None, Standard or High.")
	state["tax_level"] = level
	last_error = ""
	return true


func trade(good: String, direction: String, quantity: int) -> bool:
	if good not in GOODS:
		return _reject("That good is not traded here.")
	if direction != "buy" and direction != "sell":
		return _reject("Choose buy or sell.")
	if quantity <= 0:
		return _reject("Trade quantity must be at least one.")
	var inventory: Dictionary = state["inventory"]
	var market_inventory: Dictionary = state["market_inventory"]
	var price := int(BUY_PRICES[good] if direction == "buy" else SELL_PRICES[good])
	var total_cost := price * quantity
	if direction == "buy":
		if int(market_inventory[good]) < quantity:
			return _reject("The market does not have %d %s." % [quantity, good])
		if free_storage() < quantity:
			return _reject("The storehouse has room for only %d more goods." % free_storage())
		if int(state["market_coin"]) < total_cost:
			return _reject("The market cannot pay for this purchase right now.")
		if int(state["treasury"]) < total_cost:
			return _reject("The settlement treasury needs %d more coin." % (total_cost - int(state["treasury"])))
		inventory[good] = int(inventory[good]) + quantity
		market_inventory[good] = int(market_inventory[good]) - quantity
		state["treasury"] = int(state["treasury"]) - total_cost
		state["market_coin"] = int(state["market_coin"]) + total_cost
	else:
		if int(inventory[good]) < quantity:
			return _reject("The storehouse has only %d %s." % [int(inventory[good]), good])
		if _inventory_total(market_inventory) + quantity > MARKET_CAPACITY:
			return _reject("The market stores are full.")
		if int(state["market_coin"]) < total_cost:
			return _reject("The market has only %d coin available." % int(state["market_coin"]))
		inventory[good] = int(inventory[good]) - quantity
		market_inventory[good] = int(market_inventory[good]) + quantity
		state["treasury"] = int(state["treasury"]) + total_cost
		state["market_coin"] = int(state["market_coin"]) - total_cost
	last_error = ""
	return true


func advance_day() -> Dictionary:
	last_error = ""
	var next_day := int(state["day"]) + 1
	state["day"] = next_day
	var report := {
		"day": next_day,
		"grain_produced": 0,
		"timber_produced": 0,
		"flour_produced": 0,
		"grain_used_by_mill": 0,
		"grain_consumed": 0,
		"grain_shortage": 0,
		"tax_collected": 0,
		"upkeep_due": daily_upkeep(),
		"upkeep_paid": 0,
		"upkeep_unpaid": 0,
	}
	var inventory: Dictionary = state["inventory"]
	var farm_output := _produce_into_store("grain", int(state["assignments"]["farm"]) * 2)
	report["grain_produced"] = farm_output
	var timber_output := _produce_into_store("timber", int(state["assignments"]["woodcut"]))
	report["timber_produced"] = timber_output
	if farm_output < int(state["assignments"]["farm"]) * 2 or timber_output < int(state["assignments"]["woodcut"]):
		_add_alert(2, "Storehouse capacity limited today's production.")
	var requested_flour := int(state["assignments"]["mill"])
	var grain_available_for_mill := int(floor(float(inventory["grain"]) / 2.0))
	var flour_output := mini(requested_flour, grain_available_for_mill)
	if flour_output > 0:
		inventory["grain"] = int(inventory["grain"]) - flour_output * 2
		inventory["flour"] = int(inventory["flour"]) + flour_output
		report["grain_used_by_mill"] = flour_output * 2
		report["flour_produced"] = flour_output
	if flour_output < requested_flour:
		_add_alert(2, "Millers paused: each flour needs two grain; %d worker(s) could not work." % (requested_flour - flour_output))
	var daily_food_need := int(ceil(float(population_count()) / 12.0))
	var grain_consumed := mini(int(inventory["grain"]), daily_food_need)
	inventory["grain"] = int(inventory["grain"]) - grain_consumed
	report["grain_consumed"] = grain_consumed
	report["grain_shortage"] = daily_food_need - grain_consumed
	if int(report["grain_shortage"]) > 0:
		_add_alert(3, "Food shortage: households need %d more grain today." % int(report["grain_shortage"]))
	var tax_collected := daily_tax_income()
	state["treasury"] = int(state["treasury"]) + tax_collected
	report["tax_collected"] = tax_collected
	var total_upkeep_due := int(state["upkeep_arrears"]) + int(report["upkeep_due"])
	var upkeep_paid := mini(int(state["treasury"]), total_upkeep_due)
	state["treasury"] = int(state["treasury"]) - upkeep_paid
	state["upkeep_arrears"] = total_upkeep_due - upkeep_paid
	report["upkeep_paid"] = upkeep_paid
	report["upkeep_unpaid"] = int(state["upkeep_arrears"])
	if int(state["upkeep_arrears"]) > 0:
		_add_alert(3, "Upkeep unpaid: %d coin remains due." % int(state["upkeep_arrears"]))
	state["last_report"] = report.duplicate(true)
	return report


func to_save_data() -> Dictionary:
	return {"schema_version": SAVE_VERSION, "state": state.duplicate(true)}


func load_save_data(save_data: Variant) -> bool:
	last_error = ""
	if typeof(save_data) != TYPE_DICTIONARY:
		return _reject("Save data must be a dictionary.")
	var root_data: Dictionary = save_data
	if int(root_data.get("schema_version", -1)) != SAVE_VERSION:
		return _reject("This save uses an unsupported version.")
	if typeof(root_data.get("state")) != TYPE_DICTIONARY:
		return _reject("Save data has no settlement state.")
	var candidate: Dictionary = _normalize_json_numbers(root_data["state"].duplicate(true))
	var validation_error := _validate_state(candidate)
	if not validation_error.is_empty():
		return _reject(validation_error)
	state = candidate
	return true


func _validate_state(candidate: Dictionary) -> String:
	for key in ["day", "settlement_name", "households", "workers_available", "assignments", "inventory", "warehouse_capacity", "treasury", "tax_level", "upkeep_arrears", "market_coin", "market_inventory", "alerts", "last_report"]:
		if not candidate.has(key):
			return "Save is missing '%s'." % key
	if not _is_positive_int(candidate["day"]):
		return "Save day must be a positive whole number."
	if typeof(candidate["settlement_name"]) != TYPE_STRING or str(candidate["settlement_name"]).is_empty():
		return "Settlement name is invalid."
	if typeof(candidate["households"]) != TYPE_ARRAY or candidate["households"].size() != 3:
		return "Save must contain all three household groups."
	var household_ids := ["field", "woodland", "market"]
	var total_workers := 0
	for index in range(candidate["households"].size()):
		var group: Variant = candidate["households"][index]
		if typeof(group) != TYPE_DICTIONARY:
			return "Household group data is invalid."
		if str(group.get("id", "")) != household_ids[index]:
			return "Household group identifiers do not match this save version."
		if typeof(group.get("name")) != TYPE_STRING or str(group["name"]).is_empty():
			return "Household group name is invalid."
		if not _is_positive_int(group.get("households")) or not _is_positive_int(group.get("population")):
			return "Households and population must be positive whole numbers."
	if not _is_nonnegative_int(candidate["workers_available"]):
		return "Available workers must be a nonnegative whole number."
	if typeof(candidate["assignments"]) != TYPE_DICTIONARY or candidate["assignments"].size() != JOBS.size():
		return "Labour assignments are invalid."
	for job in JOBS:
		if not _is_nonnegative_int(candidate["assignments"].get(job)):
			return "Worker assignment for %s is invalid." % JOB_LABELS[job]
		total_workers += int(candidate["assignments"][job])
	if total_workers > int(candidate["workers_available"]):
		return "Saved labour assignments exceed the available workforce."
	if not _validate_goods(candidate["inventory"]) or not _validate_goods(candidate["market_inventory"]):
		return "Saved goods inventory is invalid."
	if not _is_positive_int(candidate["warehouse_capacity"]):
		return "Storehouse capacity must be a positive whole number."
	if _inventory_total(candidate["inventory"]) > int(candidate["warehouse_capacity"]):
		return "Saved storehouse exceeds its capacity."
	if _inventory_total(candidate["market_inventory"]) > MARKET_CAPACITY:
		return "Saved market inventory exceeds its capacity."
	for key in ["treasury", "upkeep_arrears", "market_coin"]:
		if not _is_nonnegative_int(candidate[key]):
			return "Saved %s must be a nonnegative whole number." % key
	if not _is_nonnegative_int(candidate["tax_level"]) or int(candidate["tax_level"]) > 2:
		return "Saved tax setting is invalid."
	if typeof(candidate["alerts"]) != TYPE_ARRAY or candidate["alerts"].size() > MAX_ALERTS or typeof(candidate["last_report"]) != TYPE_DICTIONARY:
		return "Saved report data is invalid."
	for alert_value in candidate["alerts"]:
		if typeof(alert_value) != TYPE_DICTIONARY:
			return "Saved priority notice is invalid."
		var alert: Dictionary = alert_value
		if not _is_positive_int(alert.get("day")) or int(alert["day"]) > int(candidate["day"]):
			return "Saved notice day is invalid."
		if not _is_positive_int(alert.get("priority")) or int(alert["priority"]) > 3:
			return "Saved notice priority is invalid."
		if typeof(alert.get("message")) != TYPE_STRING:
			return "Saved notice text is invalid."
	if not candidate["last_report"].is_empty():
		var report: Dictionary = candidate["last_report"]
		for key in ["day", "grain_produced", "timber_produced", "flour_produced", "grain_used_by_mill", "grain_consumed", "grain_shortage", "tax_collected", "upkeep_due", "upkeep_paid", "upkeep_unpaid"]:
			if not _is_nonnegative_int(report.get(key)):
				return "Saved daily report is invalid."
		if int(report["day"]) != int(candidate["day"]):
			return "Saved daily report does not match the current day."
	return ""


func _validate_goods(value: Variant) -> bool:
	if typeof(value) != TYPE_DICTIONARY or value.size() != GOODS.size():
		return false
	for good in GOODS:
		if not _is_nonnegative_int(value.get(good)):
			return false
	return true


func _is_nonnegative_int(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return int(value) >= 0
	if typeof(value) == TYPE_FLOAT:
		return float(value) >= 0.0 and is_equal_approx(float(value), floor(float(value)))
	return false


func _is_positive_int(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return int(value) > 0
	if typeof(value) == TYPE_FLOAT:
		return float(value) > 0.0 and is_equal_approx(float(value), floor(float(value)))
	return false


func _normalize_json_numbers(value: Variant) -> Variant:
	if typeof(value) == TYPE_FLOAT and is_equal_approx(float(value), floor(float(value))):
		return int(value)
	if typeof(value) == TYPE_DICTIONARY:
		var normalized := {}
		for key in value:
			normalized[key] = _normalize_json_numbers(value[key])
		return normalized
	if typeof(value) == TYPE_ARRAY:
		var normalized: Array = []
		for item in value:
			normalized.append(_normalize_json_numbers(item))
		return normalized
	return value


func _produce_into_store(good: String, requested: int) -> int:
	var produced := mini(requested, free_storage())
	state["inventory"][good] = int(state["inventory"][good]) + produced
	return produced


func _inventory_total(inventory: Dictionary) -> int:
	var total := 0
	for good in GOODS:
		total += int(inventory.get(good, 0))
	return total


func _add_alert(priority: int, message: String) -> void:
	var alerts: Array = state.get("alerts", [])
	alerts.append({"day": int(state.get("day", 1)), "priority": priority, "message": message})
	alerts.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if int(a["priority"]) == int(b["priority"]):
			return int(a["day"]) > int(b["day"])
		return int(a["priority"]) > int(b["priority"])
	)
	if alerts.size() > MAX_ALERTS:
		alerts.resize(MAX_ALERTS)
	state["alerts"] = alerts


func _reject(message: String) -> bool:
	last_error = message
	return false
