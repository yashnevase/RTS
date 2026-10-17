extends Node3D

const SIMULATION_SCRIPT := preload("res://src/battle/battle_simulation.gd")
const UNIT_ACTOR_SCRIPT := preload("res://src/battle/battle_unit_actor.gd")
const HUD_SCRIPT := preload("res://src/battle/m2_battle_hud.gd")
const CAMERA_SCRIPT := preload("res://src/benchmark/rts_camera.gd")

const PLAYER_TEAM := 0
const CPU_TEAM := 1

var simulation: RefCounted
var unit_actors: Dictionary = {}
var selected_unit_ids: Array[String] = []
var camera_rig: Node3D
var battle_hud: CanvasLayer
var _seed := 173


func _ready() -> void:
	simulation = SIMULATION_SCRIPT.new()
	_build_world()
	_build_camera()
	_build_hud()
	_restart_battle(_seed)


func _process(delta: float) -> void:
	if simulation.outcome == "ongoing":
		simulation.advance(delta)
		_apply_combat_events()
		_apply_message_events()
	_sync_unit_actors()
	if is_instance_valid(battle_hud):
		battle_hud.update_battle(simulation, selected_unit_ids)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			_order_retreat()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE:
			_clear_selection()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed:
		if simulation.outcome != "ongoing":
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			_select_at(event.position, event.shift_pressed)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_order_at(event.position)
			get_viewport().set_input_as_handled()


func _build_world() -> void:
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.31, 0.42, 0.48)
	sky_material.sky_horizon_color = Color(0.73, 0.65, 0.50)
	sky_material.ground_bottom_color = Color(0.20, 0.19, 0.15)
	sky_material.ground_horizon_color = Color(0.48, 0.40, 0.29)
	var sky := Sky.new()
	sky.sky_material = sky_material
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	environment.ambient_light_sky_contribution = 0.42
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.tonemap_exposure = 0.88
	var world_environment := WorldEnvironment.new()
	world_environment.environment = environment
	add_child(world_environment)

	var sun := DirectionalLight3D.new()
	sun.name = "BattlefieldSun"
	sun.rotation_degrees = Vector3(-47.0, -28.0, -12.0)
	sun.light_color = Color(1.0, 0.85, 0.68)
	sun.light_energy = 1.1
	sun.shadow_enabled = true
	add_child(sun)

	var ground := MeshInstance3D.new()
	ground.name = "BattlefieldGround"
	var plane := PlaneMesh.new()
	plane.size = Vector2(64.0, 44.0)
	ground.mesh = plane
	ground.position.y = -0.025
	var ground_material := StandardMaterial3D.new()
	ground_material.albedo_color = Color(0.49, 0.40, 0.28)
	ground_material.roughness = 1.0
	ground_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	ground.material_override = ground_material
	add_child(ground)

	var ground_body := StaticBody3D.new()
	ground_body.name = "BattlefieldPickingSurface"
	ground_body.position.y = -0.25
	var floor_shape := CollisionShape3D.new()
	var floor_box := BoxShape3D.new()
	floor_box.size = Vector3(64.0, 0.5, 44.0)
	floor_shape.shape = floor_box
	ground_body.add_child(floor_shape)
	add_child(ground_body)

	_add_field_detail()


func _add_field_detail() -> void:
	var center_line_material := _material(Color(0.72, 0.57, 0.34), 0.95)
	_add_box("CenterMarker", Vector3(0.08, 0.018, 22.0), Vector3(0.0, 0.012, 0.0), center_line_material)
	var player_line_material := _material(Color(0.55, 0.22, 0.13), 0.78)
	var cpu_line_material := _material(Color(0.19, 0.34, 0.47), 0.78)
	_add_box("PlayerDeploymentLine", Vector3(0.12, 0.025, 18.0), Vector3(-25.7, 0.015, 0.0), player_line_material)
	_add_box("CpuDeploymentLine", Vector3(0.12, 0.025, 18.0), Vector3(25.7, 0.015, 0.0), cpu_line_material)
	_add_banner("PlayerFieldBanner", Vector3(-26.6, 0.0, -10.0), Color(0.67, 0.27, 0.16))
	_add_banner("CpuFieldBanner", Vector3(26.6, 0.0, -10.0), Color(0.24, 0.42, 0.56))


func _build_camera() -> void:
	camera_rig = Node3D.new()
	camera_rig.name = "BattleCameraRig"
	camera_rig.set_script(CAMERA_SCRIPT)
	camera_rig.pan_speed = 12.0
	camera_rig.minimum_distance = 21.0
	camera_rig.maximum_distance = 39.0
	camera_rig.zoom_distance = 31.0
	add_child(camera_rig)
	var camera := Camera3D.new()
	camera.name = "BattleCamera"
	camera.current = true
	camera.fov = 47.0
	camera_rig.add_child(camera)
	camera_rig.camera = camera
	camera_rig._apply_zoom()


func _build_hud() -> void:
	battle_hud = HUD_SCRIPT.new()
	battle_hud.name = "BattleHUD"
	battle_hud.retreat_requested.connect(_order_retreat)
	battle_hud.restart_requested.connect(_restart_battle.bind(_seed))
	add_child(battle_hud)


func _select_at(mouse_position: Vector2, additive: bool) -> void:
	var hit := _raycast_at(mouse_position)
	var collider: Object = hit.get("collider")
	if collider is Node and collider.is_in_group("selectable_unit"):
		var actor := collider.get_parent() as Node3D
		var unit_id := str(actor.get("unit_id"))
		if unit_id != "" and unit_id in simulation.units:
			var unit: Dictionary = simulation.units[unit_id]
			if int(unit["team"]) == PLAYER_TEAM and float(unit["health"]) > 0.0 and not bool(unit["withdrawn"]):
				if not additive:
					_clear_selection()
				if unit_id not in selected_unit_ids:
					selected_unit_ids.append(unit_id)
					selected_unit_ids.sort()
				return
	_clear_selection()


func _order_at(mouse_position: Vector2) -> void:
	if selected_unit_ids.is_empty():
		battle_hud.set_message("Select friendly units first")
		return
	var hit := _raycast_at(mouse_position)
	if hit.is_empty():
		return
	var collider: Object = hit.get("collider")
	if collider is Node and collider.is_in_group("selectable_unit"):
		var actor := collider.get_parent() as Node3D
		var target_id := str(actor.get("unit_id"))
		if simulation.issue_attack(selected_unit_ids, target_id):
			battle_hud.set_message("Attack order sent to %d unit(s)" % selected_unit_ids.size())
		else:
			battle_hud.set_message(simulation.last_error)
		return
	var world_point: Vector3 = hit.get("position", Vector3.ZERO)
	if simulation.issue_move(selected_unit_ids, Vector2(world_point.x, world_point.z)):
		battle_hud.set_message("Formation moving to the marked ground")
	else:
		battle_hud.set_message(simulation.last_error)


func _order_retreat() -> void:
	if selected_unit_ids.is_empty():
		battle_hud.set_message("Select friendly units to retreat")
		return
	if simulation.issue_retreat(selected_unit_ids):
		battle_hud.set_message("Retreat order sent — withdrawing units leave the battle")
	else:
		battle_hud.set_message(simulation.last_error)


func _raycast_at(mouse_position: Vector2) -> Dictionary:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return {}
	var ray_start := camera.project_ray_origin(mouse_position)
	var ray_end := ray_start + camera.project_ray_normal(mouse_position) * 120.0
	var query := PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	return get_world_3d().direct_space_state.intersect_ray(query)


func _restart_battle(seed_value: int = 173) -> void:
	_seed = seed_value
	if simulation == null:
		return
	for actor in unit_actors.values():
		if is_instance_valid(actor):
			actor.queue_free()
	unit_actors.clear()
	selected_unit_ids.clear()
	simulation.reset(seed_value)
	for unit_id in simulation.units:
		var actor: Node3D = UNIT_ACTOR_SCRIPT.new()
		actor.configure(simulation.units[unit_id])
		actor.name = str(unit_id)
		add_child(actor)
		unit_actors[unit_id] = actor
	if is_instance_valid(battle_hud):
		battle_hud.set_message("RMB ground = move  •  enemy = attack")
		battle_hud.update_battle(simulation, selected_unit_ids)


func _clear_selection() -> void:
	selected_unit_ids.clear()


func _sync_unit_actors() -> void:
	for unit_id in simulation.units:
		var unit: Dictionary = simulation.units[unit_id]
		var actor: Node3D = unit_actors.get(unit_id)
		if not is_instance_valid(actor):
			continue
		var target_id: String = str(unit["target_id"])
		var display_data: Dictionary = unit.duplicate()
		if str(unit["order"]) == "attack" and simulation.units.has(target_id):
			var target: Dictionary = simulation.units[target_id]
			var target_position: Vector2 = target["position"]
			display_data["destination"] = target_position
		actor.sync_state(display_data, unit_id in selected_unit_ids)
		var active := float(unit["health"]) > 0.0 and not bool(unit["withdrawn"])
		actor.visible = active
		var pick_area := actor.get_node_or_null("BattleUnitPickArea") as Area3D
		if pick_area != null:
			pick_area.collision_layer = 2 if active else 0


func _apply_combat_events() -> void:
	for event in simulation.take_combat_events():
		var target_id: String = event["target_id"]
		var target: Dictionary = simulation.units.get(target_id, {})
		var target_actor: Node3D = unit_actors.get(target_id)
		if not target.is_empty() and is_instance_valid(target_actor):
			var label := Label3D.new()
			label.text = "-%d" % int(event["amount"])
			label.font_size = 30
			label.pixel_size = 0.006
			label.outline_size = 4
			label.modulate = Color(1.0, 0.79, 0.48) if bool(event["ranged"]) else Color(0.95, 0.89, 0.77)
			label.position = target_actor.position + Vector3(0.0, 2.75, 0.0)
			label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
			add_child(label)
			var tween := create_tween()
			tween.tween_property(label, "position:y", label.position.y + 0.75, 0.6)
			tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6)
			tween.tween_callback(label.queue_free)


func _apply_message_events() -> void:
	var messages: Array[String] = simulation.take_message_events()
	if not messages.is_empty():
		battle_hud.set_message(messages[messages.size() - 1])


func _add_box(node_name: String, size: Vector3, at: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	add_child(mesh_instance)


func _add_banner(node_name: String, at: Vector3, color: Color) -> void:
	var root := Node3D.new()
	root.name = node_name
	root.position = at
	add_child(root)
	var pole := MeshInstance3D.new()
	var pole_mesh := CylinderMesh.new()
	pole_mesh.bottom_radius = 0.055
	pole_mesh.top_radius = 0.04
	pole_mesh.height = 3.5
	pole.mesh = pole_mesh
	pole.position.y = 1.75
	pole.material_override = _material(Color(0.20, 0.17, 0.13), 0.9)
	root.add_child(pole)
	var flag := MeshInstance3D.new()
	var flag_mesh := BoxMesh.new()
	flag_mesh.size = Vector3(0.10, 0.92, 0.72)
	flag.mesh = flag_mesh
	flag.position = Vector3(0.0, 2.77, 0.22)
	flag.material_override = _material(color, 0.88)
	root.add_child(flag)


func _material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material
