extends SceneTree

func _initialize() -> void:
	call_deferred("_run_capture")


func _fail_and_quit(message: String, world: Node3D) -> void:
	push_error(message)
	if is_instance_valid(world):
		world.queue_free()
		await process_frame
	quit(1)


func _run_capture() -> void:
	var main_scene_path := str(ProjectSettings.get_setting("application/run/main_scene"))
	var main_scene := load(main_scene_path) as PackedScene
	if main_scene == null:
		push_error("M1 interaction capture could not load the configured main scene: %s" % main_scene_path)
		quit(1)
		return
	var world := main_scene.instantiate() as Node3D
	if world == null:
		push_error("The configured main scene root is not Node3D: %s" % main_scene_path)
		quit(1)
		return
	root.add_child(world)
	await process_frame
	await process_frame
	await process_frame
	var initial_frame := world.get_viewport().get_texture().get_image()
	if initial_frame.save_png("res://artifacts/m1/field_study_initial.png") != OK:
		await _fail_and_quit("M1 could not save the initial scene screenshot.", world)
		return

	var camera: Camera3D = world.get_viewport().get_camera_3d()
	var units: Array[Node] = world.get_tree().get_nodes_in_group("rts_unit")
	if camera == null or units.is_empty():
		await _fail_and_quit("M1 interaction capture could not find the camera or unit group.", world)
		return

	var unit: Node3D = units[0]
	var select_event := InputEventMouseButton.new()
	select_event.button_index = MOUSE_BUTTON_LEFT
	select_event.pressed = true
	select_event.position = camera.unproject_position(unit.global_position + Vector3(0.0, 1.0, 0.0))
	world._unhandled_input(select_event)
	await process_frame
	if world.selected_unit != unit or not unit.is_selected:
		await _fail_and_quit("M1 failed to select a unit through its scene input and ray-picking path.", world)
		return
	print("M1 interaction: selected %s" % unit.unit_name)

	var target := Vector3(9.0, 0.0, 8.0)
	var move_event := InputEventMouseButton.new()
	move_event.button_index = MOUSE_BUTTON_RIGHT
	move_event.pressed = true
	move_event.position = camera.unproject_position(target)
	world._unhandled_input(move_event)
	for frame in range(30):
		await process_frame
	if not unit.is_moving or world.hud_order.text != "MOVE ORDER SENT" or not world.move_marker.visible:
		await _fail_and_quit("M1 failed to issue a ground movement order through its scene input and ray-picking path.", world)
		return
	var movement_frame := world.get_viewport().get_texture().get_image()
	if movement_frame.save_png("res://artifacts/m1/unit_selection_move.png") != OK:
		await _fail_and_quit("M1 could not save the selection and movement screenshot.", world)
		return
	print("M1 interaction: ground order sent; unit is moving at %s" % unit.position)

	# Keep this interaction frame available for a movie capture before inspecting the house.
	for frame in range(14):
		await process_frame
	var house_event := InputEventMouseButton.new()
	house_event.button_index = MOUSE_BUTTON_LEFT
	house_event.pressed = true
	house_event.position = camera.unproject_position(Vector3(5.2, 1.8, -1.15))
	world._unhandled_input(house_event)
	await process_frame
	if world.hud_title.text != "VILLAGE MARKET HOUSE":
		await _fail_and_quit("M1 failed to inspect the market house through its scene input and ray-picking path.", world)
		return
	print("M1 interaction: market-house inspection opened")
	world.queue_free()
	for frame in range(3):
		await process_frame
	quit()
