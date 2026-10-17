extends Node3D

const UNIT_RADIUS := 0.43

var unit_id := ""
var role_name := "Guard"
var team := 0
var is_selected := false
var health_ratio := 1.0
var health_fill: MeshInstance3D
var selection_ring: MeshInstance3D
var model_root: Node3D
var fill_material: StandardMaterial3D
var team_material: StandardMaterial3D
var trim_material: StandardMaterial3D


func configure(unit_data: Dictionary) -> void:
	unit_id = str(unit_data["id"])
	role_name = str(unit_data["role"])
	team = int(unit_data["team"])
	_create_actor()
	_sync_state(unit_data)


func sync_state(unit_data: Dictionary, selected: bool) -> void:
	_sync_state(unit_data)
	set_selected(selected)


func _sync_state(unit_data: Dictionary) -> void:
	var sim_position: Vector2 = unit_data["position"]
	position = Vector3(sim_position.x, 0.0, sim_position.y)
	var destination: Vector2 = unit_data["destination"]
	var facing := destination - sim_position
	if str(unit_data["order"]) == "attack":
		facing = destination - sim_position
	if facing.length_squared() > 0.015:
		rotation.y = atan2(facing.x, facing.y)
	health_ratio = clampf(float(unit_data["health"]) / maxf(float(unit_data["max_health"]), 1.0), 0.0, 1.0)
	if is_instance_valid(health_fill):
		health_fill.scale.x = maxf(0.01, health_ratio)
		health_fill.position.x = -0.36 * (1.0 - health_ratio)
		if health_ratio <= 0.28:
			fill_material.albedo_color = Color(0.72, 0.20, 0.13)
		else:
			fill_material.albedo_color = Color(0.37, 0.64, 0.34)


func set_selected(value: bool) -> void:
	is_selected = value
	if is_instance_valid(selection_ring):
		selection_ring.visible = value


func _create_actor() -> void:
	add_to_group("battle_unit")
	team_material = _make_material(Color(0.57, 0.23, 0.15) if team == 0 else Color(0.20, 0.36, 0.48), 0.84)
	trim_material = _make_material(Color(0.88, 0.67, 0.34) if team == 0 else Color(0.72, 0.78, 0.78), 0.72)
	var dark_material := _make_material(Color(0.18, 0.15, 0.12), 0.88)
	model_root = Node3D.new()
	model_root.name = "Model"
	add_child(model_root)
	if role_name == "Cavalry":
		_create_cavalry(dark_material)
	else:
		_create_foot_soldier(dark_material)
	_create_selection_ring()
	_create_health_bar()
	_create_pick_area()


func _create_foot_soldier(dark_material: Material) -> void:
	var torso := _capsule("Torso", 0.30, 1.15, Vector3(0.0, 0.91, 0.0), team_material)
	model_root.add_child(torso)
	var head := _sphere("Head", 0.18, Vector3(0.0, 1.70, 0.0), _make_material(Color(0.48, 0.33, 0.23), 0.9))
	model_root.add_child(head)
	var head_wrap := _sphere("HeadWrap", 0.23, Vector3(0.0, 1.83, 0.0), trim_material)
	head_wrap.scale = Vector3(1.0, 0.68, 0.92)
	model_root.add_child(head_wrap)
	var belt := _box("Belt", Vector3(0.48, 0.11, 0.39), Vector3(0.0, 0.60, 0.0), dark_material)
	model_root.add_child(belt)
	if role_name == "Guard":
		var shield := _box("Shield", Vector3(0.13, 0.60, 0.45), Vector3(-0.42, 1.03, 0.09), dark_material)
		model_root.add_child(shield)
		var spear := _cylinder("Spear", 0.035, 0.035, 1.38, Vector3(0.39, 1.18, 0.0), dark_material)
		spear.rotation.z = deg_to_rad(-5.0)
		model_root.add_child(spear)
		var spearhead := _cylinder("Spearhead", 0.08, 0.0, 0.24, Vector3(0.41, 1.98, 0.0), trim_material)
		spearhead.rotation.z = deg_to_rad(-5.0)
		model_root.add_child(spearhead)
	else:
		var bow := _cylinder("Bow", 0.04, 0.04, 0.94, Vector3(0.40, 1.12, 0.04), trim_material)
		bow.rotation.z = deg_to_rad(-4.0)
		model_root.add_child(bow)
		var quiver := _cylinder("Quiver", 0.10, 0.10, 0.53, Vector3(-0.27, 1.28, -0.14), dark_material)
		quiver.rotation.z = deg_to_rad(-12.0)
		model_root.add_child(quiver)


func _create_cavalry(dark_material: Material) -> void:
	var horse_material := _make_material(Color(0.36, 0.25, 0.17), 0.94)
	var horse_body := _capsule("HorseBody", 0.40, 1.55, Vector3(0.0, 0.77, 0.0), horse_material)
	horse_body.rotation.x = PI * 0.5
	model_root.add_child(horse_body)
	var horse_head := _sphere("HorseHead", 0.27, Vector3(0.0, 1.13, 0.70), horse_material)
	horse_head.scale = Vector3(0.78, 1.22, 0.84)
	model_root.add_child(horse_head)
	var rider := _capsule("Rider", 0.24, 1.0, Vector3(0.0, 1.63, -0.04), team_material)
	model_root.add_child(rider)
	var rider_head := _sphere("RiderHead", 0.15, Vector3(0.0, 2.28, -0.04), trim_material)
	model_root.add_child(rider_head)
	var pennant := _box("Pennant", Vector3(0.05, 0.55, 0.30), Vector3(0.27, 2.01, -0.24), trim_material)
	model_root.add_child(pennant)
	var bridle := _cylinder("Bridle", 0.025, 0.025, 0.47, Vector3(0.0, 0.96, 0.81), dark_material)
	bridle.rotation.x = deg_to_rad(90.0)
	model_root.add_child(bridle)


func _create_selection_ring() -> void:
	selection_ring = MeshInstance3D.new()
	selection_ring.name = "SelectionRing"
	var ring := TorusMesh.new()
	ring.inner_radius = 0.54 if role_name != "Cavalry" else 0.78
	ring.outer_radius = 0.61 if role_name != "Cavalry" else 0.86
	ring.rings = 28
	ring.ring_segments = 8
	selection_ring.mesh = ring
	var material := _make_material(Color(0.97, 0.73, 0.26), 0.45)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.emission_enabled = true
	material.emission = Color(0.34, 0.18, 0.035)
	selection_ring.material_override = material
	selection_ring.position.y = 0.055
	selection_ring.visible = false
	add_child(selection_ring)


func _create_health_bar() -> void:
	var bar_root := Node3D.new()
	bar_root.name = "HealthBar"
	bar_root.position.y = 2.43 if role_name != "Cavalry" else 2.93
	add_child(bar_root)
	var background := _box("HealthBarBackground", Vector3(0.78, 0.11, 0.07), Vector3.ZERO, _make_material(Color(0.10, 0.10, 0.09), 0.95))
	bar_root.add_child(background)
	fill_material = _make_material(Color(0.37, 0.64, 0.34), 0.8)
	health_fill = _box("HealthBarFill", Vector3(0.72, 0.065, 0.04), Vector3.ZERO, fill_material)
	health_fill.position.z = 0.045
	bar_root.add_child(health_fill)


func _create_pick_area() -> void:
	var area := Area3D.new()
	area.name = "BattleUnitPickArea"
	area.add_to_group("selectable_unit")
	area.collision_layer = 2
	area.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.74 if role_name == "Cavalry" else UNIT_RADIUS
	shape.height = 2.1 if role_name != "Cavalry" else 2.8
	collision.shape = shape
	collision.position.y = 1.05 if role_name != "Cavalry" else 1.4
	area.add_child(collision)
	add_child(area)


func _make_material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	return material


func _box(node_name: String, size: Vector3, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	return instance


func _capsule(node_name: String, radius: float, height: float, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh.radial_segments = 8
	mesh.rings = 4
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	return instance


func _sphere(node_name: String, radius: float, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 10
	mesh.rings = 5
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	return instance


func _cylinder(node_name: String, bottom_radius: float, top_radius: float, height: float, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = bottom_radius
	mesh.top_radius = top_radius
	mesh.height = height
	mesh.radial_segments = 8
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	return instance
