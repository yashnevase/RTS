extends RefCounted

## Compatibility adapter: existing callers and save paths stay valid.
const STORE := preload("res://src/persistence/json_save_store.gd")
const DEFAULT_PATH := "user://saves/m4_campaign.json"


static func save_campaign(simulation: RefCounted, path: String = DEFAULT_PATH) -> Dictionary:
	if simulation.active_battle != null:
		return {"ok": false, "message": "Finish the battle before saving the campaign."}
	return STORE.save_simulation(simulation, path)


static func load_campaign(simulation: RefCounted, path: String = DEFAULT_PATH) -> Dictionary:
	return STORE.load_simulation(simulation, path)
