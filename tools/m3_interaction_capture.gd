extends SceneTree

const SCENE_PATH := "res://scenes/settlement/m3_settlement.tscn"
const CAPTURE_SAVE_PATH := "user://m3_interaction_capture.json"


func _initialize() -> void:
	call_deferred("_run_capture")


func _save_frame(world: Control, path: String) -> bool:
	var viewport_image := world.get_viewport().get_texture().get_image()
	return viewport_image.save_png(path) == OK


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
		push_error("M3 interaction capture could not load the settlement scene.")
		quit(1)
		return
	var world := packed_scene.instantiate() as Control
	if world == null:
		push_error("M3 scene root is not a Control.")
		quit(1)
		return
	root.add_child(world)
	for frame in range(6):
		await process_frame
	var viewport_size: Vector2i = DisplayServer.window_get_size()
	var suffix := "%dx%d" % [viewport_size.x, viewport_size.y]
	if int(world.simulation.state["day"]) != 1:
		await _fail("M3 settlement should start on day one.", world)
		return
	var initial_path := "res://artifacts/m3/settlement_initial_%s.png" % suffix
	if not _save_frame(world, initial_path):
		await _fail("Could not save M3 initial screen.", world)
		return
	var farm_spin: SpinBox = world.hud.worker_spins["farm"]
	farm_spin.value = 10
	if int(world.simulation.state["assignments"]["farm"]) != 10:
		await _fail("Worker spin box did not update the simulation assignment.", world)
		return
	var grain_amount: SpinBox = world.hud.trade_spins["grain"]
	grain_amount.value = 3
	world.hud.buy_buttons["grain"].pressed.emit()
	if int(world.simulation.state["inventory"]["grain"]) != 47 or int(world.simulation.state["treasury"]) != 81:
		await _fail("Market button did not transfer grain and coin through the settlement controller.", world)
		return
	world.hud.advance_button.pressed.emit()
	if int(world.simulation.state["day"]) != 2 or int(world.simulation.state["last_report"]["grain_produced"]) != 20:
		await _fail("Advance day button did not settle production and consumption.", world)
		return
	world.save_path = CAPTURE_SAVE_PATH
	world.hud.save_button.pressed.emit()
	if not FileAccess.file_exists(CAPTURE_SAVE_PATH):
		await _fail("Save button did not create a settlement save.", world)
		return
	world.hud.advance_button.pressed.emit()
	world.hud.load_button.pressed.emit()
	if int(world.simulation.state["day"]) != 2 or world.hud.day_label.text != "DAY 02":
		await _fail("Load button did not restore the saved state and refresh the HUD.", world)
		return
	for frame in range(4):
		await process_frame
	var interaction_path := "res://artifacts/m3/settlement_interaction_%s.png" % suffix
	if not _save_frame(world, interaction_path):
		await _fail("Could not save M3 interaction screen.", world)
		return
	print("M3 interaction: assigned labour, bought grain, settled a day, saved and loaded through the actual UI (%s)." % suffix)
	_remove_test_save()
	world.queue_free()
	for frame in range(3):
		await process_frame
	quit()
