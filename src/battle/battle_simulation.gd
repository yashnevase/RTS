extends RefCounted

## Small deterministic rules model for the M2 standalone battle.
## Values are prototype tuning, not final historical balance.

const FIXED_STEP := 0.1
const BATTLE_EDGE := 27.0
const CPU_DECISION_INTERVAL := 0.8

const PLAYER_TEAM := 0
const CPU_TEAM := 1

const UNIT_ROLES := {
	"Guard": {
		"max_health": 170.0,
		"damage": 14.0,
		"attack_range": 1.55,
		"attack_interval": 1.6,
		"move_speed": 3.7,
	},
	"Archer": {
		"max_health": 112.0,
		"damage": 10.0,
		"attack_range": 8.0,
		"attack_interval": 1.8,
		"move_speed": 3.2,
	},
	"Cavalry": {
		"max_health": 195.0,
		"damage": 19.0,
		"attack_range": 1.8,
		"attack_interval": 1.8,
		"move_speed": 5.7,
	},
}

var units: Dictionary = {}
var outcome := "ongoing"
var elapsed_seconds := 0.0
var battle_seed := 0
var last_error := ""
var _accumulator := 0.0
var _cpu_timer := 0.0
var _rng := RandomNumberGenerator.new()
var _combat_events: Array[Dictionary] = []
var _message_events: Array[String] = []


func reset(seed_value: int = 173) -> void:
	units.clear()
	outcome = "ongoing"
	elapsed_seconds = 0.0
	battle_seed = seed_value
	last_error = ""
	_accumulator = 0.0
	_cpu_timer = CPU_DECISION_INTERVAL
	_combat_events.clear()
	_message_events.clear()
	_rng.seed = seed_value
	_deploy_standard_armies()


func _deploy_standard_armies() -> void:
	var roster: Array[Dictionary] = [
		{"id": "player_guard_1", "team": PLAYER_TEAM, "role": "Guard", "position": Vector2(-13.5, -4.0)},
		{"id": "player_guard_2", "team": PLAYER_TEAM, "role": "Guard", "position": Vector2(-13.5, 0.0)},
		{"id": "player_archer_1", "team": PLAYER_TEAM, "role": "Archer", "position": Vector2(-17.0, -2.0)},
		{"id": "player_archer_2", "team": PLAYER_TEAM, "role": "Archer", "position": Vector2(-17.0, 3.0)},
		{"id": "player_cavalry_1", "team": PLAYER_TEAM, "role": "Cavalry", "position": Vector2(-12.0, 4.5)},
		{"id": "cpu_guard_1", "team": CPU_TEAM, "role": "Guard", "position": Vector2(13.5, -4.0)},
		{"id": "cpu_guard_2", "team": CPU_TEAM, "role": "Guard", "position": Vector2(13.5, 0.0)},
		{"id": "cpu_archer_1", "team": CPU_TEAM, "role": "Archer", "position": Vector2(17.0, -2.0)},
		{"id": "cpu_archer_2", "team": CPU_TEAM, "role": "Archer", "position": Vector2(17.0, 3.0)},
		{"id": "cpu_cavalry_1", "team": CPU_TEAM, "role": "Cavalry", "position": Vector2(12.0, 4.5)},
	]
	for unit_data in roster:
		var position: Vector2 = unit_data["position"]
		position.y += _rng.randf_range(-0.38, 0.38)
		unit_data["position"] = position
		_add_unit(unit_data)


func _add_unit(source: Dictionary) -> void:
	var role: String = source["role"]
	var role_data: Dictionary = UNIT_ROLES[role]
	var unit_id: String = source["id"]
	units[unit_id] = {
		"id": unit_id,
		"team": int(source["team"]),
		"role": role,
		"position": source["position"],
		"destination": source["position"],
		"health": float(role_data["max_health"]),
		"max_health": float(role_data["max_health"]),
		"order": "idle",
		"target_id": "",
		"attack_cooldown": 0.0,
		"withdrawn": false,
	}


func issue_move(unit_ids: Array[String], destination: Vector2) -> bool:
	if not _can_issue_orders():
		return false
	var eligible := _eligible_player_units(unit_ids)
	if eligible.is_empty():
		return _reject("Select an active friendly unit before issuing orders.")
	destination.x = clampf(destination.x, -BATTLE_EDGE + 1.0, BATTLE_EDGE - 1.0)
	destination.y = clampf(destination.y, -18.0, 18.0)
	var columns := ceili(sqrt(float(eligible.size())))
	var rows := ceili(float(eligible.size()) / float(columns))
	for index in range(eligible.size()):
		var unit: Dictionary = units[eligible[index]]
		var column := index % columns
		var row := int(index / columns)
		var spacing := Vector2((float(column) - float(columns - 1) * 0.5) * 1.7, (float(row) - float(rows - 1) * 0.5) * 1.7)
		unit["destination"] = destination + spacing
		unit["order"] = "move"
		unit["target_id"] = ""
		unit["withdrawn"] = false
	return true


func issue_attack(unit_ids: Array[String], target_id: String) -> bool:
	if not _can_issue_orders():
		return false
	var target: Dictionary = units.get(target_id, {})
	if target.is_empty() or _is_inactive(target) or int(target["team"]) == PLAYER_TEAM:
		return _reject("Choose a living enemy unit as the attack target.")
	var eligible := _eligible_player_units(unit_ids)
	if eligible.is_empty():
		return _reject("Select an active friendly unit before issuing orders.")
	for unit_id in eligible:
		var unit: Dictionary = units[unit_id]
		unit["order"] = "attack"
		unit["target_id"] = target_id
		unit["withdrawn"] = false
	return true


func issue_retreat(unit_ids: Array[String]) -> bool:
	if not _can_issue_orders():
		return false
	var eligible := _eligible_player_units(unit_ids)
	if eligible.is_empty():
		return _reject("Select an active friendly unit before retreating.")
	var count := eligible.size()
	for index in range(count):
		var unit: Dictionary = units[eligible[index]]
		var row_offset := (float(index) - float(count - 1) * 0.5) * 1.6
		unit["destination"] = Vector2(-BATTLE_EDGE + 0.2, clampf(row_offset, -18.0, 18.0))
		unit["order"] = "retreat"
		unit["target_id"] = ""
		unit["withdrawn"] = false
	return true


func advance(delta: float) -> void:
	if outcome != "ongoing" or delta <= 0.0:
		return
	_accumulator += delta
	while _accumulator >= FIXED_STEP and outcome == "ongoing":
		_accumulator -= FIXED_STEP
		_step(FIXED_STEP)
	if outcome != "ongoing":
		_accumulator = 0.0


func _step(delta: float) -> void:
	elapsed_seconds += delta
	_cpu_timer -= delta
	if _cpu_timer <= 0.0:
		_cpu_timer += CPU_DECISION_INTERVAL
		_cpu_choose_targets()
	var ids := units.keys()
	ids.sort()
	for unit_id_value in ids:
		var unit_id: String = unit_id_value
		var unit: Dictionary = units[unit_id]
		if _is_inactive(unit):
			continue
		if unit["order"] == "attack":
			_update_attack(unit, delta)
		elif unit["order"] == "move" or unit["order"] == "retreat":
			_update_movement(unit, delta)
	_resolve_outcome()


func _update_movement(unit: Dictionary, delta: float) -> void:
	var position: Vector2 = unit["position"]
	var destination: Vector2 = unit["destination"]
	var offset := destination - position
	var distance := offset.length()
	if distance <= 0.08:
		unit["position"] = destination
		if unit["order"] == "retreat":
			unit["withdrawn"] = true
			unit["order"] = "withdrawn"
			_message_events.append("%s withdrew from the field." % unit["role"])
		else:
			unit["order"] = "idle"
		return
	var role_data: Dictionary = UNIT_ROLES[unit["role"]]
	var speed := float(role_data["move_speed"])
	if unit["order"] == "retreat":
		speed *= 1.35
	unit["position"] = position + offset / distance * minf(speed * delta, distance)


func _update_attack(unit: Dictionary, delta: float) -> void:
	var target: Dictionary = units.get(str(unit["target_id"]), {})
	if target.is_empty() or _is_inactive(target) or int(target["team"]) == int(unit["team"]):
		unit["order"] = "idle"
		unit["target_id"] = ""
		return
	var role_data: Dictionary = UNIT_ROLES[unit["role"]]
	var attack_range := float(role_data["attack_range"])
	var position: Vector2 = unit["position"]
	var target_position: Vector2 = target["position"]
	var direction := position - target_position
	if direction.length_squared() < 0.001:
		direction = Vector2.LEFT if int(unit["team"]) == PLAYER_TEAM else Vector2.RIGHT
	var stand_off := maxf(0.72, attack_range * 0.76)
	var desired_position := target_position + direction.normalized() * stand_off
	var distance := position.distance_to(target_position)
	if distance > attack_range:
		var to_target := desired_position - position
		var travel_distance := minf(float(role_data["move_speed"]) * delta, to_target.length())
		if to_target.length_squared() > 0.001:
			unit["position"] = position + to_target.normalized() * travel_distance
		return
	unit["attack_cooldown"] = maxf(0.0, float(unit["attack_cooldown"]) - delta)
	if float(unit["attack_cooldown"]) > 0.0:
		return
	var amount := float(role_data["damage"])
	target["health"] = maxf(0.0, float(target["health"]) - amount)
	unit["attack_cooldown"] = float(role_data["attack_interval"])
	_combat_events.append({
		"attacker_id": unit["id"],
		"target_id": target["id"],
		"amount": amount,
		"ranged": unit["role"] == "Archer",
		"target_health": target["health"],
	})
	if float(target["health"]) <= 0.0:
		_message_events.append("%s was defeated." % target["role"])


func _cpu_choose_targets() -> void:
	var player_ids := _active_unit_ids(PLAYER_TEAM)
	if player_ids.is_empty():
		return
	var enemy_ids := _active_unit_ids(CPU_TEAM)
	var claimed_targets: Dictionary = {}
	for enemy_id in enemy_ids:
		var enemy: Dictionary = units[enemy_id]
		var current_target_id: String = str(enemy["target_id"])
		var current_target: Dictionary = units.get(current_target_id, {})
		if enemy["order"] == "attack" and not current_target.is_empty() and not _is_inactive(current_target) and not claimed_targets.has(current_target_id):
			claimed_targets[current_target_id] = true
			continue
		var best_id := ""
		var best_distance := INF
		for player_id in player_ids:
			if claimed_targets.has(player_id):
				continue
			var player: Dictionary = units[player_id]
			var player_position: Vector2 = player["position"]
			var enemy_position: Vector2 = enemy["position"]
			var distance: float = player_position.distance_squared_to(enemy_position)
			if distance < best_distance:
				best_distance = distance
				best_id = player_id
		if best_id == "":
			for player_id in player_ids:
				var player: Dictionary = units[player_id]
				var player_position: Vector2 = player["position"]
				var enemy_position: Vector2 = enemy["position"]
				var distance: float = player_position.distance_squared_to(enemy_position)
				if distance < best_distance:
					best_distance = distance
					best_id = player_id
		if best_id != "":
			enemy["order"] = "attack"
			enemy["target_id"] = best_id
			claimed_targets[best_id] = true


func _resolve_outcome() -> void:
	var player_count := _active_unit_ids(PLAYER_TEAM).size()
	var cpu_count := _active_unit_ids(CPU_TEAM).size()
	if player_count == 0 and cpu_count == 0:
		outcome = "draw"
	elif cpu_count == 0:
		outcome = "victory"
	elif player_count == 0:
		outcome = "defeat"


func _eligible_player_units(unit_ids: Array[String]) -> Array[String]:
	var eligible: Array[String] = []
	for unit_id in unit_ids:
		var unit: Dictionary = units.get(unit_id, {})
		if not unit.is_empty() and int(unit["team"]) == PLAYER_TEAM and not _is_inactive(unit):
			eligible.append(unit_id)
	eligible.sort()
	return eligible


func _active_unit_ids(team: int) -> Array[String]:
	var result_ids: Array[String] = []
	for unit_id_value in units.keys():
		var unit_id: String = unit_id_value
		var unit: Dictionary = units[unit_id]
		if int(unit["team"]) == team and not _is_inactive(unit):
			result_ids.append(unit_id)
	result_ids.sort()
	return result_ids


func _is_inactive(unit: Dictionary) -> bool:
	return float(unit["health"]) <= 0.0 or bool(unit["withdrawn"])


func _can_issue_orders() -> bool:
	if outcome != "ongoing":
		return _reject("This battle is over. Restart to play again.")
	last_error = ""
	return true


func _reject(message: String) -> bool:
	last_error = message
	return false


func take_combat_events() -> Array[Dictionary]:
	var events := _combat_events.duplicate(true)
	_combat_events.clear()
	return events


func take_message_events() -> Array[String]:
	var events := _message_events.duplicate()
	_message_events.clear()
	return events


func unit_count(team: int, include_withdrawn: bool = false) -> int:
	var count := 0
	for unit_id in units:
		var unit: Dictionary = units[unit_id]
		if int(unit["team"]) != team or float(unit["health"]) <= 0.0:
			continue
		if not include_withdrawn and bool(unit["withdrawn"]):
			continue
		count += 1
	return count
