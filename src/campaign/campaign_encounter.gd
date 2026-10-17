extends RefCounted

## Repeatable optional M5 patrol. Composition comes from the existing battle scenario.
## Rates and prices below are provisional prototype tuning.
const BATTLE := preload("res://src/battle/battle_simulation.gd")
const SEED := 173
const HEAL_PER_DAY := 20
const HEAL_GRAIN := 1
const RECRUIT_COIN := 12
const RECRUIT_GRAIN := 2

static func initial_state() -> Dictionary:
	var battle := BATTLE.new()
	battle.reset(SEED)
	return {"status": "available", "roster": roster_from(battle), "outcome": "", "losses": 0, "completed": 0}

static func roster_from(battle: RefCounted) -> Array:
	var roster: Array = []
	for id in battle.units:
		var unit: Dictionary = battle.units[id]
		if int(unit["team"]) == 0 and float(unit["health"]) > 0.0:
			roster.append({"id": str(id), "role": str(unit["role"]), "health": int(unit["health"])})
	return roster

static func create_battle(encounter: Dictionary) -> RefCounted:
	var battle := BATTLE.new()
	battle.reset(SEED)
	var survivors: Dictionary = {}
	for soldier in encounter["roster"]:
		survivors[soldier["id"]] = soldier
	for id in battle.units.keys():
		if int(battle.units[id]["team"]) != 0:
			continue
		if not survivors.has(id):
			battle.units.erase(id)
		else:
			battle.units[id]["health"] = float(survivors[id]["health"])
	return battle

static func validate(value: Variant) -> String:
	if typeof(value) != TYPE_DICTIONARY:
		return "Encounter data is missing."
	if value.get("status") not in ["available", "resolved"] or typeof(value.get("roster")) != TYPE_ARRAY:
		return "Encounter status or roster is invalid."
	var initial := initial_state()
	var known: Dictionary = {}
	for soldier in initial["roster"]:
		known[soldier["id"]] = soldier
	var seen: Dictionary = {}
	for soldier in value["roster"]:
		if typeof(soldier) != TYPE_DICTIONARY or typeof(soldier.get("id")) != TYPE_STRING:
			return "Invalid soldier record."
		var id: String = soldier["id"]
		if not known.has(id) or seen.has(id) or soldier.get("role") != known[id]["role"]:
			return "Unknown or duplicate soldier."
		var health: Variant = soldier.get("health")
		if typeof(health) not in [TYPE_INT, TYPE_FLOAT] or not is_finite(float(health)) or float(health) != floor(float(health)) or float(health) <= 0 or float(health) > float(known[id]["health"]):
			return "Invalid soldier health."
		seen[id] = true
	for key in ["losses", "completed"]:
		var number: Variant = value.get(key)
		if typeof(number) not in [TYPE_INT, TYPE_FLOAT] or not is_finite(float(number)) or float(number) < 0 or float(number) != floor(float(number)):
			return "Invalid encounter counter."
	if int(value["losses"]) > known.size():
		return "Invalid casualty count."
	if int(value["completed"]) == 0:
		if value["status"] != "available" or value.get("outcome") != "" or int(value["losses"]) != 0:
			return "Unfought encounter has a result."
	elif value.get("outcome") not in ["victory", "defeat", "draw"]:
		return "Invalid encounter outcome."
	if value["status"] == "available":
		if seen.size() != known.size():
			return "Prepare a complete retinue before another patrol."
		for soldier in value["roster"]:
			if float(soldier["health"]) != float(known[soldier["id"]]["health"]):
				return "Prepared retinue must be fully recovered."
	return ""


static func missing_soldiers(encounter: Dictionary) -> Array:
	var present: Dictionary = {}
	for soldier in encounter["roster"]:
		present[soldier["id"]] = true
	var missing: Array = []
	for soldier in initial_state()["roster"]:
		if not present.has(soldier["id"]):
			missing.append(soldier)
	return missing


static func wounded_count(encounter: Dictionary) -> int:
	var count := 0
	for soldier in encounter["roster"]:
		if int(soldier["health"]) < int(BATTLE.UNIT_ROLES[soldier["role"]]["max_health"]):
			count += 1
	return count
