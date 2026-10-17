extends RefCounted

## Compatibility adapter: existing callers and save paths stay valid.
const STORE := preload("res://src/persistence/json_save_store.gd")
const DEFAULT_PATH := "user://saves/m3_settlement.json"


static func save_simulation(simulation: RefCounted, path: String = DEFAULT_PATH) -> Dictionary:
	return STORE.save_simulation(simulation, path)


static func load_simulation(simulation: RefCounted, path: String = DEFAULT_PATH) -> Dictionary:
	return STORE.load_simulation(simulation, path)
