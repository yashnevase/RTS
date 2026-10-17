extends SceneTree

const SCENE_PATH := "res://scenes/campaign/m4_strategic_campaign.tscn"
const CAPTURE_SAVE_PATH := "user://m4_interaction_capture.json"


func _initialize() -> void:
	call_deferred("_run_capture")


func _save_frame(world: Control, path: String) -> bool:
	var image := world.get_viewport().get_texture().get_image()
	return image.save_png(path) == OK


func _remove_test_save() -> void:
	var global_path := ProjectSettings.globalize_path(CAPTURE_SAVE_PATH)
	DirAccess.remove_absolute(global_path)
	DirAccess.remove_absolute(global_path + ".tmp")
	DirAccess.remove_absolute(global_path + ".bak")


func _fail(message: String, world: Node) -> void:
	push_error(message)
	_remove_test_save()
	if is_instance_valid(world):
		world.queue_free()
		await process_frame
	quit(1)


func _run_capture() -> void:
	var packed_scene := load(SCENE_PATH) as PackedScene
	if packed_scene == null:
		push_error("M4 interaction capture could not load the campaign scene.")
		quit(1)
		return
	var world := packed_scene.instantiate() as Control
	if world == null:
		push_error("M4 scene root is not a Control.")
		quit(1)
		return
	root.add_child(world)
	for frame in range(8):
		await process_frame
	var suffix := "%dx%d" % [DisplayServer.window_get_size().x, DisplayServer.window_get_size().y]
	if world.simulation.current_day() != 1:
		await _fail("M4 campaign should start on day one.", world)
		return
	if not _save_frame(world, "res://artifacts/m4/campaign_initial_%s.png" % suffix):
		await _fail("Could not save M4 initial campaign screen.", world)
		return
	for day in range(2):
		world.hud.destination_buttons_for_test["nandipur"].pressed.emit()
		world.hud.advance_button.pressed.emit()
	if world.simulation.player_location_id() != "nandipur":
		await _fail("Campaign map travel control did not move the party to Nandipur.", world)
		return
	world.hud.contract_button.pressed.emit()
	world.hud.destination_buttons_for_test["keshavwadi"].pressed.emit()
	for day in range(2):
		world.hud.advance_button.pressed.emit()
	if not world.simulation.state["caravan"]["status"] == "delivered":
		await _fail("Campaign controls did not complete the escorted grain delivery.", world)
		return
	world.save_path = CAPTURE_SAVE_PATH
	world.hud.save_button.pressed.emit()
	if not FileAccess.file_exists(CAPTURE_SAVE_PATH):
		await _fail("Campaign save control did not write campaign state.", world)
		return
	world.hud.advance_button.pressed.emit()
	world.hud.load_button.pressed.emit()
	if world.simulation.current_day() != 5 or world.simulation.state["caravan"]["status"] != "delivered":
		await _fail("Campaign load control did not restore the campaign and settlement state.", world)
		return
	for frame in range(4):
		await process_frame
	if not _save_frame(world, "res://artifacts/m4/campaign_interaction_%s.png" % suffix):
		await _fail("Could not save M4 campaign interaction screen.", world)
		return
	world.hud.tabs.current_tab = 1
	for frame in range(4):
		await process_frame
	if int(world.hud.settlement_hud.day_label.text.trim_prefix("DAY ")) != 5:
		await _fail("Settlement view did not show the campaign's shared day.", world)
		return
	if not _save_frame(world, "res://artifacts/m4/settlement_shared_%s.png" % suffix):
		await _fail("Could not save M4 shared settlement view.", world)
		return
	print("M4 interaction: travelled, accepted and escorted a caravan, saved and loaded the campaign, then inspected the same settlement state (%s)." % suffix)
	_remove_test_save()
	world.queue_free()
	for frame in range(3):
		await process_frame
	quit()
