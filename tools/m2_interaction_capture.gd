extends SceneTree


func _initialize() -> void:
	call_deferred("_run_capture")


func _fail(message: String, world: Node3D) -> void:
	push_error(message)
	if is_instance_valid(world):
		world.queue_free()
		await process_frame
	quit(1)


func _save_frame(world: Node3D, path: String) -> bool:
	var viewport_image := world.get_viewport().get_texture().get_image()
	return viewport_image.save_png(path) == OK


func _run_capture() -> void:
	var main_scene_path := str(ProjectSettings.get_setting("application/run/main_scene"))
	var packed_scene := load(main_scene_path) as PackedScene
	if packed_scene == null:
		push_error("M2 interaction capture could not load the configured main scene: %s" % main_scene_path)
		quit(1)
		return
	var world := packed_scene.instantiate() as Node3D
	if world == null:
		push_error("M2 configured scene root is not Node3D.")
		quit(1)
		return
	root.add_child(world)
	for frame in range(5):
		await process_frame
	if world.simulation.units.size() != 10:
		await _fail("M2 battle did not deploy two complete forces.", world)
		return
	if not _save_frame(world, "res://artifacts/m2/battle_initial.png"):
		await _fail("M2 could not save the initial battle screenshot.", world)
		return

	var camera: Camera3D = world.get_viewport().get_camera_3d()
	var friendly: Node3D = world.unit_actors["player_guard_1"]
	var select_event := InputEventMouseButton.new()
	select_event.button_index = MOUSE_BUTTON_LEFT
	select_event.pressed = true
	select_event.position = camera.unproject_position(friendly.global_position + Vector3(0.0, 1.0, 0.0))
	world._unhandled_input(select_event)
	await process_frame
	if "player_guard_1" not in world.selected_unit_ids:
		await _fail("Actual scene input could not select a friendly unit.", world)
		return

	var move_target := Vector3(-8.0, 0.0, 8.0)
	var move_event := InputEventMouseButton.new()
	move_event.button_index = MOUSE_BUTTON_RIGHT
	move_event.pressed = true
	move_event.position = camera.unproject_position(move_target)
	world._unhandled_input(move_event)
	for frame in range(30):
		await process_frame
	if world.simulation.units["player_guard_1"]["order"] != "move":
		await _fail("Actual scene input did not create a movement order.", world)
		return

	for unit_id in ["player_guard_2", "player_cavalry_1"]:
		var additional_unit: Node3D = world.unit_actors[unit_id]
		var add_select_event := InputEventMouseButton.new()
		add_select_event.button_index = MOUSE_BUTTON_LEFT
		add_select_event.pressed = true
		add_select_event.shift_pressed = true
		add_select_event.position = camera.unproject_position(additional_unit.global_position + Vector3(0.0, 1.0, 0.0))
		world._unhandled_input(add_select_event)
		await process_frame
	if world.selected_unit_ids.size() != 3:
		await _fail("Shift-click did not add units to the selected group.", world)
		return

	var enemy: Node3D = world.unit_actors["cpu_guard_1"]
	var attack_event := InputEventMouseButton.new()
	attack_event.button_index = MOUSE_BUTTON_RIGHT
	attack_event.pressed = true
	attack_event.position = camera.unproject_position(enemy.global_position + Vector3(0.0, 1.0, 0.0))
	world._unhandled_input(attack_event)
	if world.simulation.units["player_guard_1"]["order"] != "attack":
		await _fail("Actual scene input did not create a contextual attack order.", world)
		return
	var enemy_health_before := float(world.simulation.units["cpu_guard_1"]["health"])
	for frame in range(420):
		await process_frame
	var battle_health_changed := false
	for unit in world.simulation.units.values():
		if float(unit["health"]) < float(unit["max_health"]):
			battle_health_changed = true
			break
	if not battle_health_changed and float(world.simulation.units["cpu_guard_1"]["health"]) >= enemy_health_before:
		await _fail("The CPU and player orders did not produce any combat damage.", world)
		return
	if not _save_frame(world, "res://artifacts/m2/battle_commands.png"):
		await _fail("M2 could not save the interaction screenshot.", world)
		return

	for unit_id in ["cpu_guard_1", "cpu_guard_2", "cpu_archer_1", "cpu_archer_2", "cpu_cavalry_1"]:
		world.simulation.units[unit_id]["health"] = 0.0
	world.simulation.advance(0.1)
	world._sync_unit_actors()
	world.battle_hud.update_battle(world.simulation, world.selected_unit_ids)
	if world.simulation.outcome != "victory" or not world.battle_hud.result_overlay.visible:
		await _fail("Defeating the CPU did not show the battle result overlay.", world)
		return
	await process_frame
	await process_frame
	if not _save_frame(world, "res://artifacts/m2/battle_victory.png"):
		await _fail("M2 could not save the victory screen.", world)
		return
	world.battle_hud.restart_button.pressed.emit()
	if world.simulation.outcome != "ongoing" or world.simulation.units.size() != 10 or world.battle_hud.result_overlay.visible:
		await _fail("Restart button did not reset the battle and close the result overlay.", world)
		return
	await process_frame
	var retreat_unit: Node3D = world.unit_actors["player_guard_1"]
	var retreat_select := InputEventMouseButton.new()
	retreat_select.button_index = MOUSE_BUTTON_LEFT
	retreat_select.pressed = true
	retreat_select.position = camera.unproject_position(retreat_unit.global_position + Vector3(0.0, 1.0, 0.0))
	world._unhandled_input(retreat_select)
	world.battle_hud.retreat_button.pressed.emit()
	if world.simulation.units["player_guard_1"]["order"] != "retreat":
		await _fail("Retreat button did not send a retreat order to the selected unit.", world)
		return
	print("M2 interaction: selected and grouped units, moved, attacked, saw victory, restarted and retreated.")
	world.queue_free()
	for frame in range(3):
		await process_frame
	quit()
