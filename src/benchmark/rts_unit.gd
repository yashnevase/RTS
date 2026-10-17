extends Node3D

var unit_name: String = "Guard"
var role_name: String = "Guard"
var move_speed: float = 3.8
var home_position := Vector3.ZERO
var outfit_material: Material
var destination := Vector3.ZERO
var is_moving := false
var is_selected := false
var walk_clock := 0.0
var arm_left: Node3D
var arm_right: Node3D
var leg_left: Node3D
var leg_right: Node3D
var selection_ring: MeshInstance3D
var outfit_trim: StandardMaterial3D


func _ready() -> void:
	add_to_group("rts_unit")
	destination = position
	_create_body()
	_create_pick_area()


func _process(delta: float) -> void:
	if is_moving:
		var offset := destination - position
		offset.y = 0.0
		var distance := offset.length()
		if distance < 0.16:
			position.x = destination.x
			position.z = destination.z
			is_moving = false
		else:
			var direction := offset / distance
			position += direction * minf(move_speed * delta, distance)
			rotation.y = atan2(direction.x, direction.z)
			walk_clock += delta * 10.0
			arm_left.rotation.x = sin(walk_clock) * 0.48
			arm_right.rotation.x = -sin(walk_clock) * 0.48
			leg_left.rotation.x = -sin(walk_clock) * 0.52
			leg_right.rotation.x = sin(walk_clock) * 0.52
			$Visual/Torso.position.y = 1.0 + absf(sin(walk_clock * 2.0)) * 0.035
	else:
		walk_clock = 0.0
		arm_left.rotation.x = move_toward(arm_left.rotation.x, 0.0, delta * 2.8)
		arm_right.rotation.x = move_toward(arm_right.rotation.x, 0.0, delta * 2.8)
		leg_left.rotation.x = move_toward(leg_left.rotation.x, 0.0, delta * 3.0)
		leg_right.rotation.x = move_toward(leg_right.rotation.x, 0.0, delta * 3.0)
		$Visual/Torso.position.y = move_toward($Visual/Torso.position.y, 1.0, delta * 0.12)
	if is_instance_valid(selection_ring):
		selection_ring.rotation.y += delta * 0.3


func set_destination(point: Vector3) -> void:
	destination = Vector3(point.x, position.y, point.z)
	var offset := destination - position
	offset.y = 0.0
	is_moving = offset.length() > 0.2


func set_selected(value: bool) -> void:
	is_selected = value
	if is_instance_valid(selection_ring):
		selection_ring.visible = value


func _create_body() -> void:
	var visual := Node3D.new()
	visual.name = "Visual"
	add_child(visual)
	var dark := _material(Color(0.20, 0.15, 0.12), 0.83)
	outfit_trim = _material(Color(0.73, 0.54, 0.29), 0.72)
	var skin := _material(Color(0.48, 0.31, 0.22), 0.78)
	if outfit_material == null:
		outfit_material = _material(Color(0.43, 0.25, 0.16), 0.85)

	var tunic := _cylinder("Torso", 0.34, 0.22, 0.76, Vector3(0.0, 1.0, 0.0), outfit_material)
	visual.add_child(tunic)
	var waist := _cylinder("WaistWrap", 0.34, 0.31, 0.17, Vector3(0.0, 0.70, 0.0), outfit_material)
	visual.add_child(waist)
	var chest_panel := _box("ChestTrim", Vector3(0.08, 0.52, 0.025), Vector3(0.0, 1.02, 0.226), outfit_trim)
	visual.add_child(chest_panel)
	var head := _sphere("Head", 0.18, 0.36, Vector3(0.0, 1.62, 0.0), skin)
	visual.add_child(head)
	var turban := _sphere("Turban", 0.265, 0.24, Vector3(0.0, 1.79, 0.0), _material(Color(0.70, 0.59, 0.42), 0.9))
	turban.scale = Vector3(1.0, 0.70, 0.92)
	visual.add_child(turban)
	var turban_band := _cylinder("TurbanBand", 0.225, 0.225, 0.055, Vector3(0.0, 1.76, 0.0), outfit_trim)
	visual.add_child(turban_band)

	arm_left = _limb_pivot("LeftArm", Vector3(-0.36, 1.25, 0.0), 0.085, 0.53, skin, visual)
	arm_right = _limb_pivot("RightArm", Vector3(0.36, 1.25, 0.0), 0.085, 0.53, skin, visual)
	leg_left = _limb_pivot("LeftLeg", Vector3(-0.14, 0.60, 0.0), 0.095, 0.58, dark, visual)
	leg_right = _limb_pivot("RightLeg", Vector3(0.14, 0.60, 0.0), 0.095, 0.58, dark, visual)

	var shield := _box("LeatherShield", Vector3(0.52, 0.65, 0.12), Vector3(-0.43, 1.1, 0.25), dark)
	shield.rotation.z = deg_to_rad(-12.0)
	visual.add_child(shield)
	var shield_boss := _sphere("ShieldBoss", 0.095, 0.19, Vector3(-0.43, 1.1, 0.32), outfit_trim)
	shield_boss.scale = Vector3(1.0, 0.48, 0.5)
	visual.add_child(shield_boss)
	var spear := _cylinder("SpearShaft", 0.045, 0.045, 1.85, Vector3(0.51, 1.11, 0.0), dark)
	spear.rotation.z = deg_to_rad(-5.0)
	visual.add_child(spear)
	var spear_head := _cylinder("SpearHead", 0.10, 0.0, 0.32, Vector3(0.59, 2.18, 0.0), outfit_trim)
	spear_head.rotation.z = deg_to_rad(-5.0)
	visual.add_child(spear_head)

	selection_ring = MeshInstance3D.new()
	selection_ring.name = "SelectionRing"
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 0.52
	ring_mesh.outer_radius = 0.59
	ring_mesh.rings = 32
	ring_mesh.ring_segments = 8
	selection_ring.mesh = ring_mesh
	var ring_material := _material(Color(0.87, 0.62, 0.24), 0.48)
	ring_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ring_material.emission_enabled = true
	ring_material.emission = Color(0.38, 0.19, 0.045)
	selection_ring.material_override = ring_material
	selection_ring.position = Vector3(0.0, 0.035, 0.0)
	selection_ring.visible = false
	add_child(selection_ring)

	var banner_mesh := _box("BannerMesh", Vector3(0.05, 0.22, 0.02), Vector3(0.0, 1.36, 0.24), outfit_trim)
	banner_mesh.rotation.z = deg_to_rad(-8.0)
	visual.add_child(banner_mesh)


func _create_pick_area() -> void:
	var area := Area3D.new()
	area.name = "SelectionHitArea"
	area.add_to_group("selectable_unit")
	area.collision_layer = 2
	area.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.48
	shape.height = 2.0
	collision.shape = shape
	collision.position.y = 1.0
	area.add_child(collision)
	add_child(area)


func _limb_pivot(node_name: String, at: Vector3, radius: float, length: float, material: Material, parent: Node3D) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = node_name
	pivot.position = at
	parent.add_child(pivot)
	var limb := _capsule("Limb", radius, length, Vector3(0.0, -length * 0.30, 0.0), material)
	pivot.add_child(limb)
	return pivot


func _box(node_name: String, size: Vector3, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
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
	mesh.radial_segments = 12
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


func _sphere(node_name: String, radius: float, height: float, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh.radial_segments = 12
	mesh.rings = 6
	instance.mesh = mesh
	instance.position = at
	instance.material_override = material
	return instance


func _material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	return material
