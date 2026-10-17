extends SceneTree

const SIMULATION_SCRIPT := preload("res://src/battle/battle_simulation.gd")

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_seed_reproducibility()
	_test_move_spacing_and_validation()
	_test_attack_damage_and_victory()
	_test_cpu_decision()
	_test_natural_match_end()
	_test_retreat_and_defeat()
	_test_restart_recovery()
	if failures.is_empty():
		print("M2 simulation checks passed (7 groups).")
		quit()
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _test_seed_reproducibility() -> void:
	var first: RefCounted = SIMULATION_SCRIPT.new()
	var repeat: RefCounted = SIMULATION_SCRIPT.new()
	var varied: RefCounted = SIMULATION_SCRIPT.new()
	first.reset(17)
	repeat.reset(17)
	varied.reset(91)
	_expect(first.units["player_guard_1"]["position"] == repeat.units["player_guard_1"]["position"], "Same seed should reproduce the deployment")
	_expect(first.units["player_guard_1"]["position"] != varied.units["player_guard_1"]["position"], "A different seed should vary deployment")


func _test_move_spacing_and_validation() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset(17)
	var enemy_ids: Array[String] = ["cpu_guard_1"]
	_expect(not sim.issue_move(enemy_ids, Vector2.ZERO), "CPU units must reject player movement orders")
	var selected: Array[String] = ["player_guard_1", "player_guard_2"]
	_expect(sim.issue_move(selected, Vector2(-8.0, 1.0)), "Valid player movement order should be accepted")
	_expect(sim.units["player_guard_1"]["order"] == "move", "Move order should be stored in simulation state")
	_expect(sim.units["player_guard_1"]["destination"] != sim.units["player_guard_2"]["destination"], "Group order should preserve formation spacing")
	var old_position: Vector2 = sim.units["player_guard_1"]["position"]
	sim.advance(1.0)
	_expect(sim.units["player_guard_1"]["position"] != old_position, "Unit should advance toward the commanded position")


func _test_attack_damage_and_victory() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset(17)
	for unit_id in ["cpu_guard_2", "cpu_archer_1", "cpu_archer_2", "cpu_cavalry_1"]:
		sim.units[unit_id]["health"] = 0.0
	sim.units["player_guard_1"]["position"] = Vector2(-1.0, 0.0)
	sim.units["player_guard_1"]["destination"] = Vector2(-1.0, 0.0)
	sim.units["cpu_guard_1"]["position"] = Vector2(0.0, 0.0)
	sim.units["cpu_guard_1"]["destination"] = Vector2(0.0, 0.0)
	sim.units["cpu_guard_1"]["health"] = 18.0
	var stale_target_ids: Array[String] = ["player_guard_1"]
	_expect(not sim.issue_attack(stale_target_ids, "cpu_guard_2"), "Attack order should reject a defeated target")
	var attacker_ids: Array[String] = ["player_guard_1"]
	_expect(sim.issue_attack(attacker_ids, "cpu_guard_1"), "Valid enemy target should accept an attack order")
	sim.advance(0.2)
	_expect(sim.units["cpu_guard_1"]["health"] < 18.0, "Attack order should apply role damage")
	sim.advance(1.8)
	_expect(sim.units["cpu_guard_1"]["health"] <= 0.0, "Repeated attacks should defeat a low-health unit")
	_expect(sim.outcome == "victory", "Removing the final enemy should end the battle in victory")
	_expect(not sim.issue_move(attacker_ids, Vector2.ZERO), "Completed battle should reject new orders")
	var completion_time: float = float(sim.elapsed_seconds)
	sim.advance(10.0)
	_expect(sim.elapsed_seconds == completion_time, "Completed battle should remain frozen")


func _test_cpu_decision() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset(41)
	sim.advance(0.9)
	var cpu_guard: Dictionary = sim.units["cpu_guard_1"]
	_expect(cpu_guard["order"] == "attack", "CPU should select and pursue a living player target")
	_expect(str(cpu_guard["target_id"]).begins_with("player_"), "CPU target should be a player unit")
	var assigned_targets: Dictionary = {}
	for unit_id in ["cpu_guard_1", "cpu_guard_2", "cpu_archer_1", "cpu_archer_2", "cpu_cavalry_1"]:
		assigned_targets[sim.units[unit_id]["target_id"]] = true
	_expect(assigned_targets.size() == 5, "CPU should distribute targets while living player units are available")


func _test_natural_match_end() -> void:
	for seed_value in [83, 197, 401]:
		var sim: RefCounted = SIMULATION_SCRIPT.new()
		sim.reset(seed_value)
		sim.advance(120.0)
		print("M2 unattended CPU battle seed %d: %s at %.1fs (player %d, CPU %d)." % [seed_value, sim.outcome, sim.elapsed_seconds, sim.unit_count(sim.PLAYER_TEAM), sim.unit_count(sim.CPU_TEAM)])
		_expect(sim.outcome != "ongoing", "Autonomous CPU battle should eventually end for seed %d" % seed_value)


func _test_retreat_and_defeat() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset(23)
	for unit_id in ["player_guard_2", "player_archer_1", "player_archer_2", "player_cavalry_1"]:
		sim.units[unit_id]["health"] = 0.0
	sim.units["player_guard_1"]["position"] = Vector2(-26.6, 0.0)
	sim.units["player_guard_1"]["destination"] = Vector2(-26.6, 0.0)
	var withdrawing_ids: Array[String] = ["player_guard_1"]
	_expect(sim.issue_retreat(withdrawing_ids), "Active friendly unit should accept retreat order")
	sim.advance(0.2)
	_expect(sim.units["player_guard_1"]["withdrawn"], "Retreat should remove unit from the field")
	_expect(sim.outcome == "defeat", "Withdrawing the final player unit should produce defeat")
	_expect(sim.unit_count(sim.PLAYER_TEAM, true) == 1, "Withdrawn survivor should remain distinguishable from casualties")


func _test_restart_recovery() -> void:
	var sim: RefCounted = SIMULATION_SCRIPT.new()
	sim.reset(17)
	sim.units["player_guard_1"]["health"] = 0.0
	sim.outcome = "defeat"
	sim.reset(17)
	_expect(sim.outcome == "ongoing", "Reset should restore the battle state")
	_expect(sim.units.size() == 10, "Reset should restore both complete forces")
	_expect(sim.units["player_guard_1"]["health"] == sim.units["player_guard_1"]["max_health"], "Reset should restore unit health")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
