extends SceneTree

const SIM := preload("res://src/campaign/m4_campaign_simulation.gd")
const STORE := preload("res://src/campaign/m4_campaign_save_store.gd")
const PATH := "user://m5_loop_test.json"
var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _new() -> RefCounted:
	var sim := SIM.new()
	sim.reset()
	return sim

func _at_pass(sim: RefCounted) -> void:
	_expect(sim.request_travel("kaldar_pass"), "Travel to pass")
	sim.advance_day()
	_expect(sim.begin_encounter(), "Begin encounter")

func _withdraw(sim: RefCounted) -> void:
	var ids: Array[String] = []
	for id in sim.active_battle.units:
		if int(sim.active_battle.units[id]["team"]) == 0:
			ids.append(id)
	_expect(sim.active_battle.issue_retreat(ids), "Withdraw living troops")
	for step in range(1000):
		if sim.active_battle.outcome != "ongoing":
			break
		sim.active_battle.advance(0.1)
	_expect(sim.finish_encounter(), "Return from resolved battle")

func _run() -> void:
	_test_repeat_and_pause()
	_test_recovery_and_costs()
	_test_no_food_no_healing()
	_test_complete_defeat()
	_test_migrations_and_invalid_data()
	_test_combat_resolution()
	_test_escort_stop_resume()
	for suffix in ["", ".tmp", ".bak"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH + suffix))
	if failures.is_empty():
		print("M5 campaign loop checks passed (7 groups).")
		quit()
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _test_repeat_and_pause() -> void:
	var sim := _new()
	_expect(not sim.begin_encounter(), "Encounter unavailable at home")
	_at_pass(sim)
	var before: Dictionary = sim.to_save_data()
	_expect(not sim.finish_encounter(), "Cannot finish ongoing battle")
	_expect(not sim.begin_encounter(), "Cannot enter twice")
	_expect(not sim.request_travel("nandipur"), "No travel during battle")
	_expect(not sim.recruit_replacement(), "No recruiting in battle")
	_expect(not STORE.save_campaign(sim, PATH)["ok"], "No mid-battle file save")
	_expect(not sim.load_save_data(before), "No mid-battle load")
	sim.advance_day()
	_expect(sim.to_save_data() == before, "Battle pauses all campaign day state")
	_withdraw(sim)
	_expect(sim.state["encounter"]["roster"].size() == 5, "Withdrawn troops survive")
	var resolved: Dictionary = sim.to_save_data()
	_expect(not sim.finish_encounter(), "Result cannot apply twice")
	_expect(sim.to_save_data() == resolved, "Repeated resolution has no effects")
	_expect(not sim.prepare_patrol(), "Cannot prepare outside home")
	_expect(sim.request_travel("keshavwadi"), "Return home")
	sim.advance_day()
	_expect(sim.prepare_patrol(), "Prepare recovered retinue at home")
	_expect(not sim.prepare_patrol(), "Cannot prepare twice")
	_expect(STORE.save_campaign(sim, PATH)["ok"], "Save prepared patrol")
	var clone := _new()
	_expect(STORE.load_campaign(clone, PATH)["ok"], "Reload prepared patrol")
	_expect(clone.to_save_data() == sim.to_save_data(), "Exact prepared state roundtrip")
	_at_pass(clone)
	_withdraw(clone)
	_expect(clone.state["encounter"]["completed"] == 2, "Second patrol resolves once")

func _test_recovery_and_costs() -> void:
	var sim := _new()
	_at_pass(sim)
	# Boundary fixture: one casualty and one wound; remaining combat resolves normally.
	sim.active_battle.units["player_guard_1"]["health"] = 0.0
	sim.active_battle.units["player_guard_2"]["health"] = 141.0
	_withdraw(sim)
	_expect(sim.state["encounter"]["losses"] == 1, "One casualty retained")
	_expect(not sim.recruit_replacement(), "No field recruitment")
	var wounded: int = sim.state["encounter"]["roster"][0]["health"]
	sim.advance_day()
	_expect(sim.state["encounter"]["roster"][0]["health"] == wounded, "No healing away from home")
	sim.request_travel("keshavwadi")
	sim.advance_day()
	_expect(sim.state["encounter"]["roster"][0]["health"] == wounded, "Arrival day is not a full rest day")
	var grain_before: int = sim.settlement.state["inventory"]["grain"]
	var report: Dictionary = sim.advance_day()
	var economy: Dictionary = report["settlement_report"]
	var expected := grain_before + int(economy["grain_produced"]) - int(economy["grain_used_by_mill"]) - int(economy["grain_consumed"]) - 1
	_expect(sim.settlement.state["inventory"]["grain"] == expected, "Healing consumes grain after household food")
	_expect(sim.state["encounter"]["roster"][0]["health"] == 161, "Rest restores 20 health")
	_expect(not sim.prepare_patrol(), "Cannot prepare wounded/incomplete force")
	var coin: int = sim.settlement.state["treasury"]
	var grain: int = sim.settlement.state["inventory"]["grain"]
	_expect(sim.recruit_replacement(), "Hire one replacement")
	_expect(sim.settlement.state["treasury"] == coin - 12 and sim.settlement.state["inventory"]["grain"] == grain - 2, "Recruit cost debited once")
	_expect(not sim.recruit_replacement(), "No recruiting beyond cap")
	_expect(sim.state["encounter"]["losses"] == 1, "Recruitment preserves previous battle losses")
	sim.advance_day()
	_expect(sim.state["encounter"]["roster"][0]["health"] == 170, "Healing caps at maximum")
	_expect(sim.prepare_patrol(), "Recovered and replenished force can prepare")

func _test_complete_defeat() -> void:
	var sim := _new()
	_at_pass(sim)
	for step in range(1000):
		if sim.active_battle.outcome != "ongoing":
			break
		sim.active_battle.advance(0.1)
	_expect(sim.finish_encounter(), "CPU can defeat unattended force")
	_expect(sim.state["encounter"]["roster"].is_empty(), "Defeated troops are removed")
	sim.request_travel("keshavwadi")
	sim.advance_day()
	sim.settlement.state["treasury"] = 0
	var before: Dictionary = sim.to_save_data()
	_expect(not sim.recruit_replacement(), "No free recruitment")
	_expect(sim.to_save_data() == before, "Failed recruit leaves accounts untouched")
	sim.settlement.state["treasury"] = 60
	sim.settlement.state["inventory"]["grain"] = 10
	for index in range(5):
		_expect(sim.recruit_replacement(), "Replace full lost force")
	_expect(sim.settlement.state["treasury"] == 0 and sim.settlement.state["inventory"]["grain"] == 0, "Full replacement costs exact resources")
	_expect(sim.prepare_patrol(), "Full defeat can recover into a new patrol")

func _test_migrations_and_invalid_data() -> void:
	var sim := _new()
	var legacy: Dictionary = sim.to_save_data()
	legacy["schema_version"] = 1
	legacy["campaign_state"].erase("encounter")
	_expect(sim.load_save_data(legacy), "Schema 1 migrates")
	var old: Dictionary = sim.to_save_data()
	old["schema_version"] = 2
	old["campaign_state"]["encounter"].erase("completed")
	_expect(sim.load_save_data(old), "Schema 2 migrates")
	var pristine: Dictionary = sim.to_save_data()
	for invalid_health in [-1, 171, 1.5, "bad", INF]:
		var bad: Dictionary = pristine.duplicate(true)
		bad["campaign_state"]["encounter"]["roster"][0]["health"] = invalid_health
		_expect(not sim.load_save_data(bad), "Reject malformed soldier health")
		_expect(sim.to_save_data() == pristine, "Invalid load is atomic")
	var duplicate: Dictionary = pristine.duplicate(true)
	duplicate["campaign_state"]["encounter"]["roster"].append(duplicate["campaign_state"]["encounter"]["roster"][0].duplicate())
	_expect(not sim.load_save_data(duplicate), "Reject duplicate soldier")

func _test_combat_resolution() -> void:
	var sim := _new()
	_at_pass(sim)
	for step in range(1200):
		var battle: RefCounted = sim.active_battle
		if battle.outcome != "ongoing":
			break
		var players: Array[String] = []
		var target := ""
		for id in battle.units:
			if float(battle.units[id]["health"]) <= 0:
				continue
			if int(battle.units[id]["team"]) == 0:
				players.append(id)
			elif target.is_empty():
				target = id
		if not target.is_empty() and not players.is_empty():
			battle.issue_attack(players, target)
		battle.advance(0.1)
	_expect(sim.active_battle.outcome != "ongoing", "Commanded combat reaches an outcome")
	var survivors: Array = sim.ENCOUNTER.roster_from(sim.active_battle)
	_expect(sim.finish_encounter(), "Apply actual combat result")
	_expect(sim.state["encounter"]["roster"] == survivors, "Battle health and survivor identities preserved")
	_expect(STORE.save_campaign(sim, PATH)["ok"], "Save combat result")
	var clone := _new()
	_expect(STORE.load_campaign(clone, PATH)["ok"], "Reload combat result")
	_expect(clone.to_save_data() == sim.to_save_data(), "Actual combat result roundtrip")

func _test_escort_stop_resume() -> void:
	var sim := _new()
	sim.request_travel("nandipur")
	sim.advance_day()
	sim.advance_day()
	sim.accept_escort_contract()
	sim.request_travel("keshavwadi")
	sim.advance_day()
	sim.stop_travel()
	sim.advance_day()
	_expect(sim.state["caravan"]["location_id"] == "kaldar_pass", "Caravan waits after halt")
	sim.request_travel("keshavwadi")
	sim.advance_day()
	_expect(sim.state["caravan"]["status"] == "delivered", "Caravan resumes and delivers")

func _test_no_food_no_healing() -> void:
	var sim := _new()
	_at_pass(sim)
	sim.active_battle.units["player_guard_1"]["health"] = 100.0
	_withdraw(sim)
	sim.request_travel("keshavwadi")
	sim.advance_day()
	_expect(sim.settlement.set_job_workers("farm", 0), "Disable farm production for food boundary")
	sim.settlement.state["inventory"]["grain"] = 0
	var report: Dictionary = sim.advance_day()
	_expect(report["recovery"] == 0, "No grain means no healing")
	_expect(sim.state["encounter"]["roster"][0]["health"] == 100, "Wounds persist without food")
	var old: Dictionary = sim.to_save_data()
	old["schema_version"] = 2
	old["campaign_state"]["encounter"].erase("completed")
	var clone := _new()
	_expect(clone.load_save_data(old), "Resolved schema 2 migrates")
	_expect(clone.state["encounter"]["completed"] == 1 and clone.state["encounter"]["roster"][0]["health"] == 100, "Migration retains wounds and result")
