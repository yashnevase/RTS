extends SceneTree

const SIMULATION_SCRIPT := preload("res://src/campaign/m4_campaign_simulation.gd")
const SAVE_STORE_SCRIPT := preload("res://src/campaign/m4_campaign_save_store.gd")
const TEST_SAVE_PATH := "user://m4_test_saves/campaign.json"

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_starting_state_and_routes()
	_test_travel_advances_same_settlement_day()
	_test_contract_requires_market_presence_and_funds()
	_test_merchant_waits_for_public_escort_order()
	_test_escorted_delivery_transfers_goods_and_standing()
	_test_save_roundtrip_and_validation()
	_test_save_store_file_roundtrip_and_corruption()
	if failures.is_empty():
		print("M4 campaign checks passed (7 groups).")
		quit()
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _test_starting_state_and_routes() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_expect(sim.current_day() == 1, "Campaign should begin on day one")
	_expect(sim.current_day() == int(sim.settlement.state["day"]), "Campaign and settlement should begin on the same day")
	_expect(sim.player_location_id() == "keshavwadi", "The player's party should begin at Keshavwadi")
	_expect(sim.location_name("kaldar_pass") == "Kaldar Pass", "Named locations should be readable")
	_expect(not sim.request_travel("unknown"), "Unknown locations should be rejected")
	_expect(not sim.request_travel("keshavwadi"), "Travel to the current location should be rejected")
	_expect(sim.request_travel("nandipur"), "A connected market route should be accepted")
	_expect(not sim.request_travel("suryagarh"), "A second travel order should be rejected while travelling")


func _test_travel_advances_same_settlement_day() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	var grain_before := int(sim.settlement.state["inventory"]["grain"])
	_expect(sim.request_travel("nandipur"), "Party should be able to order travel to Nandipur")
	var first_report: Dictionary = sim.advance_day()
	_expect(sim.current_day() == 2 and int(sim.settlement.state["day"]) == 2, "Advancing campaign time should advance the shared settlement day")
	_expect(sim.player_location_id() == "kaldar_pass", "The first route day should reach Kaldar Pass")
	_expect(not str(first_report["party_movement"]).is_empty(), "Campaign report should explain party movement")
	_expect(int(sim.settlement.state["inventory"]["grain"]) != grain_before, "Settlement inventory should update while travelling")
	sim.advance_day()
	_expect(sim.current_day() == 3 and sim.player_location_id() == "nandipur", "The second route day should reach Nandipur Market")


func _test_contract_requires_market_presence_and_funds() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_expect(not sim.accept_escort_contract(), "Merchant contract should require a party at Nandipur")
	_travel_to_market(sim)
	sim.settlement.state["treasury"] = 0
	_expect(not sim.accept_escort_contract(), "Merchant contract should reject an unaffordable treasury")
	sim.settlement.state["treasury"] = 80
	var merchant_grain_before := int(sim.state["merchant"]["inventory_grain"])
	_expect(sim.accept_escort_contract(), "A party at the market with funds should reserve the grain contract")
	_expect(int(sim.state["merchant"]["inventory_grain"]) == merchant_grain_before - 12, "Contract should reserve a finite merchant grain stock")
	_expect(int(sim.settlement.state["treasury"]) == 56, "Contract price should leave the settlement treasury")
	_expect(sim.state["caravan"]["status"] == "awaiting_escort", "Reserved contract should wait for an escort order")


func _test_merchant_waits_for_public_escort_order() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_travel_to_market(sim)
	_expect(sim.accept_escort_contract(), "Contract setup should succeed at Nandipur")
	var report: Dictionary = sim.advance_day()
	_expect(sim.state["caravan"]["status"] == "awaiting_escort", "Merchant should not depart without a public escort order")
	_expect(str(report["merchant_decision"]).contains("no public escort order"), "Merchant decision should state the visible reason for waiting")
	_expect(str(sim.state["merchant"]["last_decision"]).contains("public Keshavwadi escort order"), "Merchant decision trace should be retained in state")


func _test_escorted_delivery_transfers_goods_and_standing() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_travel_to_market(sim)
	_expect(sim.accept_escort_contract(), "Escorted contract should be accepted")
	var standing_before := int(sim.state["superior"]["standing"])
	_expect(sim.request_travel("keshavwadi"), "Party should be able to publicly announce the home escort route")
	var first_return: Dictionary = sim.advance_day()
	_expect(str(first_return["merchant_decision"]).contains("publicly ordered home"), "Merchant should depart only from the public escort order")
	_expect(sim.player_location_id() == "kaldar_pass" and sim.state["caravan"]["location_id"] == "kaldar_pass", "Party and caravan should travel together through Kaldar Pass")
	var grain_before_delivery := int(sim.settlement.state["inventory"]["grain"])
	var final_return: Dictionary = sim.advance_day()
	_expect(bool(final_return["delivery_completed"]), "Caravan should complete delivery when the escort arrives at Keshavwadi")
	_expect(sim.state["caravan"]["status"] == "delivered", "Completed caravan should have a delivered state")
	var settlement_report: Dictionary = final_return["settlement_report"]
	var expected_grain := grain_before_delivery + int(settlement_report["grain_produced"]) - int(settlement_report["grain_used_by_mill"]) - int(settlement_report["grain_consumed"]) + 12
	_expect(int(sim.settlement.state["inventory"]["grain"]) == expected_grain, "Delivery should add the reserved grain once after household consumption")
	_expect(int(sim.state["superior"]["standing"]) == standing_before + 2, "Protected public route should improve the superior relationship")
	_expect(int(sim.state["caravan"]["escorted_days"]) == 2, "Caravan should record two visible escorted route days")


func _test_save_roundtrip_and_validation() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	_travel_to_market(sim)
	sim.accept_escort_contract()
	sim.request_travel("keshavwadi")
	sim.advance_day()
	var expected: Dictionary = sim.to_save_data()
	var clone: RefCounted = SIMULATION_SCRIPT.new()
	clone.reset()
	_expect(clone.load_save_data(expected), "Valid campaign and nested settlement data should load")
	_expect(clone.to_save_data() == expected, "Campaign save/load should preserve all campaign and settlement state")
	var before_invalid_load: Dictionary = clone.to_save_data()
	var invalid_data: Dictionary = expected.duplicate(true)
	invalid_data["campaign_state"]["player_party"]["location_id"] = "unknown"
	_expect(not clone.load_save_data(invalid_data), "Unknown saved party locations should be rejected")
	_expect(clone.to_save_data() == before_invalid_load, "Invalid campaign load must leave active state unchanged")
	var mismatched_day: Dictionary = expected.duplicate(true)
	mismatched_day["campaign_state"]["day"] = 99
	_expect(not clone.load_save_data(mismatched_day), "Campaign and settlement day mismatch should be rejected")
	_expect(clone.to_save_data() == before_invalid_load, "Mismatched save must leave active state unchanged")
	_expect(not clone.load_save_data({"schema_version": 99}), "Unknown save version should be rejected")


func _test_save_store_file_roundtrip_and_corruption() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset()
	sim.request_travel("nandipur")
	sim.advance_day()
	var save_result: Dictionary = SAVE_STORE_SCRIPT.save_campaign(sim, TEST_SAVE_PATH)
	_expect(bool(save_result["ok"]), "Campaign save adapter should write JSON at its requested path")
	var expected: Dictionary = sim.to_save_data()
	sim.advance_day()
	var load_result: Dictionary = SAVE_STORE_SCRIPT.load_campaign(sim, TEST_SAVE_PATH)
	_expect(bool(load_result["ok"]), "Campaign save adapter should read a valid JSON save")
	_expect(sim.to_save_data() == expected, "Campaign file save/load should restore nested state")
	var corrupt_file := FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	corrupt_file.store_string("not json")
	corrupt_file.close()
	var before_corrupt_load: Dictionary = sim.to_save_data()
	var corrupt_result: Dictionary = SAVE_STORE_SCRIPT.load_campaign(sim, TEST_SAVE_PATH)
	_expect(not bool(corrupt_result["ok"]), "Corrupt campaign JSON should be rejected")
	_expect(sim.to_save_data() == before_corrupt_load, "Corrupt campaign load must not damage active state")
	var absolute_test_path := ProjectSettings.globalize_path(TEST_SAVE_PATH)
	DirAccess.remove_absolute(absolute_test_path)
	DirAccess.remove_absolute(absolute_test_path + ".tmp")
	DirAccess.remove_absolute(absolute_test_path + ".bak")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://m4_test_saves"))


func _travel_to_market(sim: RefCounted) -> void:
	_expect(sim.request_travel("nandipur"), "Test route to Nandipur should be accepted")
	sim.advance_day()
	sim.advance_day()
	_expect(sim.player_location_id() == "nandipur", "Test route should arrive at Nandipur")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
