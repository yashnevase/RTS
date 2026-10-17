extends RefCounted

## Deterministic strategic-region rules for the M4 prototype.
## Place names, actors, quantities, and relationship effects are fictional
## placeholder tuning. The campaign owns one M3 settlement simulation instance.

const SETTLEMENT_SIMULATION_SCRIPT := preload("res://src/settlement/settlement_simulation.gd")

const SAVE_VERSION := 1
const KESHVWADI_ID := "keshavwadi"
const NANDIPUR_ID := "nandipur"
const KALDAR_PASS_ID := "kaldar_pass"
const SURYAGARH_ID := "suryagarh"
const LOCATION_ORDER := [KESHVWADI_ID, KALDAR_PASS_ID, NANDIPUR_ID, SURYAGARH_ID]
const LOCATION_DATA := {
	KESHVWADI_ID: {"name": "Keshavwadi", "kind": "Settlement", "description": "The player's fictional settlement and household stores."},
	KALDAR_PASS_ID: {"name": "Kaldar Pass", "kind": "Pass", "description": "A public route junction between the market and the settlement."},
	NANDIPUR_ID: {"name": "Nandipur Market", "kind": "Market", "description": "A fictional merchant hub where escorted contracts are arranged."},
	SURYAGARH_ID: {"name": "Suryagarh Fort", "kind": "Fort", "description": "The superior's nearby hill-fort seat."},
}
const CONNECTIONS := {
	KESHVWADI_ID: [KALDAR_PASS_ID],
	KALDAR_PASS_ID: [KESHVWADI_ID, NANDIPUR_ID, SURYAGARH_ID],
	NANDIPUR_ID: [KALDAR_PASS_ID],
	SURYAGARH_ID: [KALDAR_PASS_ID],
}
const CARAVAN_GRAIN := 12
const CARAVAN_PRICE := 24
const MAX_ACTIVITY_LOG := 18
const MAX_KNOWLEDGE_RECORDS := 8

var settlement: RefCounted
var state: Dictionary = {}
var last_error := ""


func _init() -> void:
	settlement = SETTLEMENT_SIMULATION_SCRIPT.new()


func reset() -> void:
	last_error = ""
	settlement.reset()
	state = {
		"day": int(settlement.state["day"]),
		"player_party": {
			"id": "party-rao-retinue",
			"name": "Rao's Retinue",
			"location_id": KESHVWADI_ID,
			"destination_id": "",
			"route": [],
		},
		"merchant": {
			"id": "merchant-leela",
			"name": "Leela of Nandipur",
			"location_id": NANDIPUR_ID,
			"capital": 140,
			"inventory_grain": 40,
			"knowledge": ["Public route: Kaldar Pass links Nandipur Market and Keshavwadi."],
			"last_decision": "No active contract.",
		},
		"caravan": {
			"id": "caravan-leela-grain",
			"name": "Leela's Grain Caravan",
			"status": "idle",
			"location_id": NANDIPUR_ID,
			"destination_id": "",
			"route": [],
			"cargo_grain": 0,
			"contract_price": 0,
			"escorted_days": 0,
			"last_decision_day": 0,
		},
		"superior": {
			"id": "governor-amara",
			"name": "Governor Amara",
			"location_id": SURYAGARH_ID,
			"standing": 40,
			"obligation": "Keep the Kaldar route open for the settlement and market.",
		},
		"activity_log": [],
	}
	_record("briefing", "Governor Amara expects the Kaldar route to remain usable. Leela trades from Nandipur Market.")


func current_day() -> int:
	return int(state.get("day", 1))


func location_name(location_id: String) -> String:
	var location: Dictionary = LOCATION_DATA.get(location_id, {})
	return str(location.get("name", location_id))


func player_location_id() -> String:
	return str((state.get("player_party", {}) as Dictionary).get("location_id", ""))


func request_travel(destination_id: String) -> bool:
	last_error = ""
	if not LOCATION_DATA.has(destination_id):
		return _reject("Unknown destination.")
	var party: Dictionary = (state.get("player_party", {}) as Dictionary).duplicate(true)
	var active_route: Array = party.get("route", [])
	if not active_route.is_empty():
		return _reject("Rao's Retinue already has a travel order.")
	var origin_id := str(party.get("location_id", ""))
	if origin_id == destination_id:
		return _reject("Rao's Retinue is already at %s." % location_name(destination_id))
	var route := _find_route(origin_id, destination_id)
	if route.is_empty():
		return _reject("No public route connects %s to %s." % [location_name(origin_id), location_name(destination_id)])
	party["route"] = route
	party["destination_id"] = destination_id
	state["player_party"] = party
	_record("order", "Rao's Retinue will travel from %s to %s." % [location_name(origin_id), location_name(destination_id)])
	return true


func accept_escort_contract() -> bool:
	last_error = ""
	var party: Dictionary = state.get("player_party", {})
	var merchant: Dictionary = state.get("merchant", {})
	var caravan: Dictionary = state.get("caravan", {})
	if str(party.get("location_id", "")) != str(merchant.get("location_id", "")):
		return _reject("Travel to Nandipur Market to arrange Leela's contract.")
	if str(caravan.get("status", "")) != "idle":
		return _reject("Leela has no new grain caravan available.")
	if int(merchant.get("inventory_grain", 0)) < CARAVAN_GRAIN:
		return _reject("Leela does not have enough grain for this contract.")
	if int(settlement.state.get("treasury", 0)) < CARAVAN_PRICE:
		return _reject("Keshavwadi's treasury cannot pay the %d-coin contract." % CARAVAN_PRICE)
	merchant["inventory_grain"] = int(merchant["inventory_grain"]) - CARAVAN_GRAIN
	merchant["capital"] = int(merchant["capital"]) + CARAVAN_PRICE
	merchant["last_decision"] = "Contract accepted; waiting for a public escort order back to Keshavwadi."
	_append_merchant_knowledge(merchant, "Day %d: Rao's Retinue accepted an escorted Keshavwadi grain contract at Nandipur." % current_day())
	settlement.state["treasury"] = int(settlement.state["treasury"]) - CARAVAN_PRICE
	caravan["status"] = "awaiting_escort"
	caravan["location_id"] = NANDIPUR_ID
	caravan["destination_id"] = KESHVWADI_ID
	caravan["route"] = []
	caravan["cargo_grain"] = CARAVAN_GRAIN
	caravan["contract_price"] = CARAVAN_PRICE
	caravan["escorted_days"] = 0
	caravan["last_decision_day"] = 0
	state["merchant"] = merchant
	state["caravan"] = caravan
	_record("contract", "Paid %d coin to reserve %d grain from Leela. Set a return order to escort the caravan." % [CARAVAN_PRICE, CARAVAN_GRAIN])
	return true


func advance_day() -> Dictionary:
	last_error = ""
	var settlement_report: Dictionary = settlement.advance_day()
	state["day"] = int(settlement.state["day"])
	var report := {
		"day": current_day(),
		"settlement_report": settlement_report,
		"merchant_decision": "",
		"party_movement": "",
		"caravan_movement": "",
		"delivery_completed": false,
	}
	report["merchant_decision"] = _merchant_decide()
	report["party_movement"] = _advance_player_party()
	report["caravan_movement"] = _advance_caravan()
	report["delivery_completed"] = _resolve_delivery()
	return report


func to_save_data() -> Dictionary:
	return {
		"schema_version": SAVE_VERSION,
		"campaign_state": state.duplicate(true),
		"settlement": settlement.to_save_data(),
	}


func load_save_data(save_data: Variant) -> bool:
	last_error = ""
	if typeof(save_data) != TYPE_DICTIONARY:
		return _reject("Campaign save data must be a dictionary.")
	var root_data: Dictionary = save_data
	if int(root_data.get("schema_version", -1)) != SAVE_VERSION:
		return _reject("This campaign save uses an unsupported version.")
	if typeof(root_data.get("campaign_state")) != TYPE_DICTIONARY or typeof(root_data.get("settlement")) != TYPE_DICTIONARY:
		return _reject("Campaign save is missing campaign or settlement state.")
	var candidate_settlement: RefCounted = SETTLEMENT_SIMULATION_SCRIPT.new()
	if not candidate_settlement.load_save_data(root_data["settlement"]):
		return _reject("Settlement state is invalid: %s" % candidate_settlement.last_error)
	var candidate: Dictionary = _normalize_json_numbers((root_data["campaign_state"] as Dictionary).duplicate(true))
	var validation_error := _validate_campaign_state(candidate, candidate_settlement)
	if not validation_error.is_empty():
		return _reject(validation_error)
	settlement = candidate_settlement
	state = candidate
	return true


func _merchant_decide() -> String:
	var caravan: Dictionary = (state.get("caravan", {}) as Dictionary).duplicate(true)
	if str(caravan.get("status", "")) != "awaiting_escort":
		return ""
	if int(caravan.get("last_decision_day", 0)) == current_day():
		return ""
	var party: Dictionary = state.get("player_party", {})
	var merchant: Dictionary = (state.get("merchant", {}) as Dictionary).duplicate(true)
	var party_is_ready := str(party.get("location_id", "")) == NANDIPUR_ID and str(party.get("destination_id", "")) == KESHVWADI_ID and not (party.get("route", []) as Array).is_empty()
	caravan["last_decision_day"] = current_day()
	if party_is_ready:
		caravan["status"] = "travelling"
		caravan["route"] = _find_route(NANDIPUR_ID, KESHVWADI_ID)
		merchant["last_decision"] = "Depart: the party publicly announced the Keshavwadi return route and is present at Nandipur."
		_append_merchant_knowledge(merchant, "Day %d: public escort order confirms Rao's Retinue is departing toward Keshavwadi." % current_day())
		state["merchant"] = merchant
		state["caravan"] = caravan
		var depart_reason := "Leela sends the caravan because the party is present and publicly ordered home along the Kaldar route."
		_record("merchant decision", depart_reason)
		return depart_reason
	merchant["last_decision"] = "Wait: no public Keshavwadi escort order is present at Nandipur."
	state["merchant"] = merchant
	state["caravan"] = caravan
	var wait_reason := "Leela holds the caravan because no public escort order toward Keshavwadi is present at Nandipur."
	_record("merchant decision", wait_reason)
	return wait_reason


func _advance_player_party() -> String:
	var party: Dictionary = (state.get("player_party", {}) as Dictionary).duplicate(true)
	var route: Array = party.get("route", [])
	if route.is_empty():
		return ""
	var previous_id := str(party["location_id"])
	var next_id := str(route.pop_front())
	party["location_id"] = next_id
	party["route"] = route
	if route.is_empty():
		party["destination_id"] = ""
	state["player_party"] = party
	var message := "Rao's Retinue travelled from %s to %s." % [location_name(previous_id), location_name(next_id)]
	_record("movement", message)
	return message


func _advance_caravan() -> String:
	var caravan: Dictionary = (state.get("caravan", {}) as Dictionary).duplicate(true)
	if str(caravan.get("status", "")) != "travelling":
		return ""
	var route: Array = caravan.get("route", [])
	if route.is_empty():
		return ""
	var previous_id := str(caravan["location_id"])
	var next_id := str(route.pop_front())
	caravan["location_id"] = next_id
	caravan["route"] = route
	if str((state.get("player_party", {}) as Dictionary).get("location_id", "")) == next_id:
		caravan["escorted_days"] = int(caravan["escorted_days"]) + 1
	state["caravan"] = caravan
	var message := "Leela's caravan travelled from %s to %s." % [location_name(previous_id), location_name(next_id)]
	_record("caravan", message)
	return message


func _resolve_delivery() -> bool:
	var caravan: Dictionary = (state.get("caravan", {}) as Dictionary).duplicate(true)
	var caravan_status := str(caravan.get("status", ""))
	if caravan_status != "travelling" and caravan_status != "awaiting_unload":
		return false
	if str(caravan.get("location_id", "")) != KESHVWADI_ID:
		return false
	var party: Dictionary = state.get("player_party", {})
	if str(party.get("location_id", "")) != KESHVWADI_ID:
		caravan["status"] = "awaiting_escort"
		state["caravan"] = caravan
		_record("caravan", "Leela's caravan is waiting at Keshavwadi until the contracted escort arrives.")
		return false
	var cargo := int(caravan.get("cargo_grain", 0))
	if settlement.free_storage() < cargo:
		caravan["status"] = "awaiting_unload"
		state["caravan"] = caravan
		_record("delivery", "The caravan reached Keshavwadi, but the storehouse has no room for its grain.")
		return false
	settlement.state["inventory"]["grain"] = int(settlement.state["inventory"]["grain"]) + cargo
	caravan["status"] = "delivered"
	caravan["route"] = []
	caravan["cargo_grain"] = 0
	state["caravan"] = caravan
	var superior: Dictionary = (state.get("superior", {}) as Dictionary).duplicate(true)
	superior["standing"] = mini(100, int(superior["standing"]) + 2)
	state["superior"] = superior
	_record("delivery", "Escorted %d grain into Keshavwadi. Governor Amara's standing rose by 2 for protecting the public route." % cargo)
	return true


func _find_route(origin_id: String, destination_id: String) -> Array:
	if not CONNECTIONS.has(origin_id) or not CONNECTIONS.has(destination_id):
		return []
	var frontier: Array = [origin_id]
	var paths := {origin_id: []}
	while not frontier.is_empty():
		var current_id := str(frontier.pop_front())
		if current_id == destination_id:
			return paths[current_id]
		for neighbour_value in CONNECTIONS[current_id]:
			var neighbour_id := str(neighbour_value)
			if paths.has(neighbour_id):
				continue
			var next_path: Array = (paths[current_id] as Array).duplicate()
			next_path.append(neighbour_id)
			paths[neighbour_id] = next_path
			frontier.append(neighbour_id)
	return []


func _append_merchant_knowledge(merchant: Dictionary, record: String) -> void:
	var knowledge: Array = merchant.get("knowledge", [])
	knowledge.append(record)
	if knowledge.size() > MAX_KNOWLEDGE_RECORDS:
		knowledge.pop_front()
	merchant["knowledge"] = knowledge


func _record(category: String, message: String) -> void:
	var entries: Array = state.get("activity_log", [])
	entries.append({"day": current_day(), "category": category, "message": message})
	if entries.size() > MAX_ACTIVITY_LOG:
		entries.pop_front()
	state["activity_log"] = entries


func _validate_campaign_state(candidate: Dictionary, candidate_settlement: RefCounted) -> String:
	for key in ["day", "player_party", "merchant", "caravan", "superior", "activity_log"]:
		if not candidate.has(key):
			return "Campaign save is missing '%s'." % key
	if not _is_positive_int(candidate["day"]):
		return "Campaign day must be a positive whole number."
	if int(candidate["day"]) != int(candidate_settlement.state.get("day", -1)):
		return "Campaign and settlement days do not match."
	var party_error := _validate_party(candidate["player_party"])
	if not party_error.is_empty():
		return party_error
	var merchant_error := _validate_merchant(candidate["merchant"])
	if not merchant_error.is_empty():
		return merchant_error
	var caravan_error := _validate_caravan(candidate["caravan"], int(candidate["day"]))
	if not caravan_error.is_empty():
		return caravan_error
	var superior_error := _validate_superior(candidate["superior"])
	if not superior_error.is_empty():
		return superior_error
	if typeof(candidate["activity_log"]) != TYPE_ARRAY or (candidate["activity_log"] as Array).size() > MAX_ACTIVITY_LOG:
		return "Campaign activity log is invalid."
	for entry_value in candidate["activity_log"]:
		if typeof(entry_value) != TYPE_DICTIONARY:
			return "Campaign activity entry is invalid."
		var entry: Dictionary = entry_value
		if not _is_positive_int(entry.get("day")) or int(entry["day"]) > int(candidate["day"]):
			return "Campaign activity day is invalid."
		if typeof(entry.get("category")) != TYPE_STRING or typeof(entry.get("message")) != TYPE_STRING:
			return "Campaign activity text is invalid."
	return ""


func _validate_party(value: Variant) -> String:
	if typeof(value) != TYPE_DICTIONARY:
		return "Player party data is invalid."
	var party: Dictionary = value
	if not _valid_entity_text(party, ["id", "name"]) or not _valid_location_id(str(party.get("location_id", ""))):
		return "Player party identity or location is invalid."
	if not _valid_optional_location_id(party.get("destination_id", "")) or not _valid_route(party.get("route", [])):
		return "Player party route is invalid."
	return ""


func _validate_merchant(value: Variant) -> String:
	if typeof(value) != TYPE_DICTIONARY:
		return "Merchant data is invalid."
	var merchant: Dictionary = value
	if not _valid_entity_text(merchant, ["id", "name"]) or not _valid_location_id(str(merchant.get("location_id", ""))):
		return "Merchant identity or location is invalid."
	if not _is_nonnegative_int(merchant.get("capital")) or not _is_nonnegative_int(merchant.get("inventory_grain")):
		return "Merchant accounts are invalid."
	if typeof(merchant.get("knowledge")) != TYPE_ARRAY or (merchant["knowledge"] as Array).size() > MAX_KNOWLEDGE_RECORDS:
		return "Merchant knowledge is invalid."
	for record in merchant["knowledge"]:
		if typeof(record) != TYPE_STRING:
			return "Merchant knowledge record is invalid."
	if typeof(merchant.get("last_decision")) != TYPE_STRING:
		return "Merchant decision record is invalid."
	return ""


func _validate_caravan(value: Variant, candidate_day: int) -> String:
	if typeof(value) != TYPE_DICTIONARY:
		return "Caravan data is invalid."
	var caravan: Dictionary = value
	if not _valid_entity_text(caravan, ["id", "name"]) or not _valid_location_id(str(caravan.get("location_id", ""))):
		return "Caravan identity or location is invalid."
	if not ["idle", "awaiting_escort", "travelling", "awaiting_unload", "delivered"].has(str(caravan.get("status", ""))):
		return "Caravan status is invalid."
	if not _valid_optional_location_id(caravan.get("destination_id", "")) or not _valid_route(caravan.get("route", [])):
		return "Caravan route is invalid."
	for key in ["cargo_grain", "contract_price", "escorted_days", "last_decision_day"]:
		if not _is_nonnegative_int(caravan.get(key)):
			return "Caravan '%s' is invalid." % key
	if int(caravan["last_decision_day"]) > candidate_day:
		return "Caravan decision day is invalid."
	return ""


func _validate_superior(value: Variant) -> String:
	if typeof(value) != TYPE_DICTIONARY:
		return "Superior data is invalid."
	var superior: Dictionary = value
	if not _valid_entity_text(superior, ["id", "name", "obligation"]) or not _valid_location_id(str(superior.get("location_id", ""))):
		return "Superior identity or location is invalid."
	if not _is_nonnegative_int(superior.get("standing")) or int(superior["standing"]) > 100:
		return "Superior standing is invalid."
	return ""


func _valid_entity_text(entity: Dictionary, keys: Array) -> bool:
	for key_value in keys:
		var key := str(key_value)
		if typeof(entity.get(key)) != TYPE_STRING or str(entity[key]).is_empty():
			return false
	return true


func _valid_location_id(location_id: String) -> bool:
	return LOCATION_DATA.has(location_id)


func _valid_optional_location_id(value: Variant) -> bool:
	return typeof(value) == TYPE_STRING and (str(value).is_empty() or _valid_location_id(str(value)))


func _valid_route(value: Variant) -> bool:
	if typeof(value) != TYPE_ARRAY or (value as Array).size() > LOCATION_ORDER.size():
		return false
	for location_value in value:
		if not _valid_location_id(str(location_value)):
			return false
	return true


func _is_nonnegative_int(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return int(value) >= 0
	if typeof(value) == TYPE_FLOAT:
		return float(value) >= 0.0 and is_equal_approx(float(value), floor(float(value)))
	return false


func _is_positive_int(value: Variant) -> bool:
	return _is_nonnegative_int(value) and int(value) > 0


func _normalize_json_numbers(value: Variant) -> Variant:
	if typeof(value) == TYPE_FLOAT and is_equal_approx(float(value), floor(float(value))):
		return int(value)
	if typeof(value) == TYPE_DICTIONARY:
		var normalized := {}
		for key in value:
			normalized[key] = _normalize_json_numbers(value[key])
		return normalized
	if typeof(value) == TYPE_ARRAY:
		var normalized_array: Array = []
		for item in value:
			normalized_array.append(_normalize_json_numbers(item))
		return normalized_array
	return value


func _reject(message: String) -> bool:
	last_error = message
	return false
