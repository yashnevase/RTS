extends Node3D

const UNIT_SCRIPT := preload("res://src/benchmark/rts_unit.gd")
const CAMERA_SCRIPT := preload("res://src/benchmark/rts_camera.gd")

var selected_unit: Node3D
var camera_rig: Node3D
var hud_title: Label
var hud_detail: Label
var hud_order: Label
var move_marker: MeshInstance3D
var marker_tween: Tween

var mat_ground: ShaderMaterial
var mat_stone: StandardMaterial3D
var mat_plaster: StandardMaterial3D
var mat_wood: StandardMaterial3D
var mat_roof: StandardMaterial3D
var mat_olive: StandardMaterial3D
var mat_leaf_light: StandardMaterial3D
var mat_basalt: StandardMaterial3D
var mat_brass: StandardMaterial3D
var mat_player: StandardMaterial3D
var mat_scout: StandardMaterial3D
var mat_worker: StandardMaterial3D


func _ready() -> void:
	_create_materials()
	_create_atmosphere()
	_create_terrain()
	_create_landmarks()
	_create_village_house()
	_create_foliage()
	_create_units()
	_create_camera()
	_create_hud()
	_create_ambience()


func _create_ambience() -> void:
	var stream := load("res://assets/audio/plateau_evening_wind.wav") as AudioStreamWAV
	if stream == null:
		push_warning("M1 ambience file is missing; scene will run silently.")
		return
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = stream.data.size() / 2
	var player := AudioStreamPlayer.new()
	player.name = "PlateauWindAmbience"
	player.stream = stream
	player.volume_db = -24.0
	add_child(player)
	player.play()


func _create_materials() -> void:
	mat_ground = _terrain_material()
	mat_stone = _pbr_material(Color(0.54, 0.53, 0.47), 0.94)
	mat_stone.albedo_texture = load("res://assets/textures/polyhaven/stacked_stone_wall/stacked_stone_wall_diff_1k.jpg")
	mat_stone.normal_enabled = true
	mat_stone.normal_texture = load("res://assets/textures/polyhaven/stacked_stone_wall/stacked_stone_wall_nor_gl_1k.jpg")
	mat_stone.normal_scale = 0.55
	mat_stone.roughness_texture = load("res://assets/textures/polyhaven/stacked_stone_wall/stacked_stone_wall_rough_1k.jpg")
	mat_stone.uv1_scale = Vector3(3.0, 2.0, 1.0)
	mat_plaster = _pbr_material(Color(0.63, 0.56, 0.43), 0.92)
	mat_wood = _pbr_material(Color(0.25, 0.16, 0.10), 0.9)
	mat_roof = _pbr_material(Color(0.46, 0.27, 0.20), 0.9)
	mat_olive = _pbr_material(Color(0.25, 0.31, 0.18), 0.98)
	mat_leaf_light = _pbr_material(Color(0.40, 0.43, 0.23), 0.98)
	mat_basalt = _pbr_material(Color(0.25, 0.28, 0.25), 1.0)
	mat_brass = _pbr_material(Color(0.72, 0.48, 0.19), 0.68)
	mat_player = _pbr_material(Color(0.46, 0.20, 0.12), 0.82)
	mat_scout = _pbr_material(Color(0.23, 0.35, 0.30), 0.86)
	mat_worker = _pbr_material(Color(0.57, 0.39, 0.22), 0.9)


func _terrain_material() -> ShaderMaterial:
	var shader := Shader.new()
	shader.code = """
shader_type spatial;
render_mode diffuse_burley;

uniform sampler2D dirt_texture : source_color, repeat_enable, filter_linear_mipmap_anisotropic;
uniform sampler2D dirt_normal : hint_normal, repeat_enable, filter_linear_mipmap_anisotropic;
uniform sampler2D dirt_roughness : repeat_enable, filter_linear_mipmap;
uniform sampler2D grass_texture : source_color, repeat_enable, filter_linear_mipmap_anisotropic;
uniform sampler2D grass_normal : hint_normal, repeat_enable, filter_linear_mipmap_anisotropic;
uniform sampler2D grass_roughness : repeat_enable, filter_linear_mipmap;
uniform vec3 dirt_tint = vec3(0.74, 0.70, 0.58);
uniform vec3 grass_tint = vec3(0.72, 0.76, 0.55);
uniform float texture_scale = 29.0;
uniform float patch_scale = 8.0;
uniform float vegetation_amount = 0.72;

float hash_value(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

float value_noise(vec2 p) {
	vec2 cell = floor(p);
	vec2 local = fract(p);
	local = local * local * (3.0 - 2.0 * local);
	float a = hash_value(cell);
	float b = hash_value(cell + vec2(1.0, 0.0));
	float c = hash_value(cell + vec2(0.0, 1.0));
	float d = hash_value(cell + vec2(1.0, 1.0));
	return mix(mix(a, b, local.x), mix(c, d, local.x), local.y);
}

float fbm(vec2 p) {
	float value = 0.0;
	float amplitude = 0.57;
	for (int octave = 0; octave < 4; octave++) {
		value += value_noise(p) * amplitude;
		p *= 2.03;
		amplitude *= 0.48;
	}
	return value;
}

void fragment() {
	vec2 tiled_uv = UV * texture_scale;
	vec3 dirt = texture(dirt_texture, tiled_uv).rgb * dirt_tint;
	vec3 grass = texture(grass_texture, tiled_uv * 0.78).rgb * grass_tint;
	float patch = fbm(UV * patch_scale + vec2(5.2, 1.7));
	float grass_blend = smoothstep(0.34, 0.63, patch) * vegetation_amount;
	ALBEDO = mix(dirt, grass, grass_blend);
	float dirt_rough = texture(dirt_roughness, tiled_uv).r;
	float grass_rough = texture(grass_roughness, tiled_uv * 0.78).r;
	ROUGHNESS = mix(dirt_rough, grass_rough, grass_blend);
	vec3 dirt_n = texture(dirt_normal, tiled_uv).rgb * 2.0 - 1.0;
	vec3 grass_n = texture(grass_normal, tiled_uv * 0.78).rgb * 2.0 - 1.0;
	NORMAL_MAP = normalize(mix(dirt_n, grass_n, grass_blend));
	NORMAL_MAP_DEPTH = 0.48;
}
"""
	var material := ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("dirt_texture", load("res://assets/textures/polyhaven/brown_mud_dry/brown_mud_dry_diff_1k.jpg"))
	material.set_shader_parameter("dirt_normal", load("res://assets/textures/polyhaven/brown_mud_dry/brown_mud_dry_nor_gl_1k.jpg"))
	material.set_shader_parameter("dirt_roughness", load("res://assets/textures/polyhaven/brown_mud_dry/brown_mud_dry_rough_1k.jpg"))
	material.set_shader_parameter("grass_texture", load("res://assets/textures/polyhaven/sparse_grass/sparse_grass_diff_1k.jpg"))
	material.set_shader_parameter("grass_normal", load("res://assets/textures/polyhaven/sparse_grass/sparse_grass_nor_gl_1k.jpg"))
	material.set_shader_parameter("grass_roughness", load("res://assets/textures/polyhaven/sparse_grass/sparse_grass_rough_1k.jpg"))
	return material


func _pbr_material(color: Color, roughness: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	return material


func _create_atmosphere() -> void:
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.29, 0.39, 0.47)
	sky_material.sky_horizon_color = Color(0.73, 0.68, 0.55)
	sky_material.ground_bottom_color = Color(0.19, 0.21, 0.17)
	sky_material.ground_horizon_color = Color(0.49, 0.43, 0.33)
	sky_material.sun_angle_max = 12.0
	var sky := Sky.new()
	sky.sky_material = sky_material
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	environment.ambient_light_sky_contribution = 0.45
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.tonemap_exposure = 0.82
	environment.sdfgi_enabled = false
	var world_environment := WorldEnvironment.new()
	world_environment.environment = environment
	add_child(world_environment)

	var sun := DirectionalLight3D.new()
	sun.name = "LateAfternoonSun"
	sun.rotation_degrees = Vector3(-43.0, -28.0, -12.0)
	sun.light_color = Color(1.0, 0.83, 0.64)
	sun.light_energy = 1.12
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 80.0
	add_child(sun)


func _create_terrain() -> void:
	var ground := MeshInstance3D.new()
	ground.name = "DryPlateauGround"
	var plane := PlaneMesh.new()
	plane.size = Vector2(100.0, 100.0)
	ground.mesh = plane
	ground.material_override = mat_ground
	ground.position.y = -0.035
	add_child(ground)

	var floor_body := StaticBody3D.new()
	floor_body.name = "GroundPickingSurface"
	floor_body.position.y = -0.22
	var collision := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = Vector3(100.0, 0.4, 100.0)
	collision.shape = floor_shape
	floor_body.add_child(collision)
	add_child(floor_body)

	_create_dirt_track()


func _create_dirt_track() -> void:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var steps := 48
	for index in range(steps):
		var x0 := -37.0 + 74.0 * float(index) / steps
		var x1 := -37.0 + 74.0 * float(index + 1) / steps
		var z0 := -12.0 + 0.20 * x0 + sin(x0 * 0.12) * 1.2
		var z1 := -12.0 + 0.20 * x1 + sin(x1 * 0.12) * 1.2
		var half_width := 1.12 + 0.12 * sin(x0 * 0.27)
		var a := Vector3(x0, -0.018, z0 - half_width)
		var b := Vector3(x0, -0.018, z0 + half_width)
		var c := Vector3(x1, -0.018, z1 + half_width)
		var d := Vector3(x1, -0.018, z1 - half_width)
		for point in [a, b, c, a, c, d]:
			surface.add_vertex(point)
	surface.generate_normals()
	var track := MeshInstance3D.new()
	track.name = "DustRoad"
	track.mesh = surface.commit()
	var road_material := _pbr_material(Color(0.60, 0.43, 0.28), 1.0)
	road_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	track.material_override = road_material
	add_child(track)


func _create_landmarks() -> void:
	# A basalt escarpment and wall give the test area a recognisable plateau skyline.
	_add_sphere("EscarpmentLower", Vector3(-15.5, 1.0, -19.5), Vector3(16.5, 2.1, 5.2), mat_basalt, 12, 5)
	_add_sphere("EscarpmentTop", Vector3(-16.0, 2.3, -20.1), Vector3(10.0, 1.35, 4.2), mat_stone, 11, 4)
	_add_sphere("EscarpmentCrown", Vector3(-16.5, 3.2, -20.0), Vector3(6.2, 0.72, 3.6), mat_basalt, 9, 4)

	var fort := Node3D.new()
	fort.name = "HillFortBoundary"
	fort.position = Vector3(-15.0, 0.0, -11.2)
	add_child(fort)
	_make_box(fort, "BasaltFortWall", Vector3(16.0, 2.3, 0.95), Vector3.ZERO, mat_stone)
	for index in range(10):
		var x := -7.35 + float(index) * 1.63
		_make_box(fort, "WallMerlon%02d" % index, Vector3(0.76, 0.48, 1.05), Vector3(x, 1.38, 0.0), mat_basalt)
	_make_box(fort, "GateLintel", Vector3(2.6, 0.55, 1.2), Vector3(0.0, 0.40, 0.0), mat_basalt)
	var tower := _make_box(fort, "GatehouseTower", Vector3(3.1, 4.7, 3.1), Vector3(8.8, 2.35, 0.0), mat_stone)
	for index in range(4):
		_make_box(fort, "TowerParapet%02d" % index, Vector3(0.55, 0.46, 0.6), Vector3(7.75 + float(index) * 0.7, 4.85, 0.0), mat_basalt)
	_make_box(fort, "TowerShadowSlit", Vector3(0.22, 0.9, 0.12), Vector3(8.8, 2.65, 1.58), mat_wood)
	_add_sphere("TowerCapStone", Vector3(8.8, 4.85, 0.0), Vector3(2.15, 0.28, 2.05), mat_basalt, 8, 3)
	tower.rotation.y = deg_to_rad(-1.5)

	# Scattered Deccan basalt blocks add scale and tie the plain to the escarpment.
	var rock_data := [
		[Vector3(-24.0, 0.45, 1.0), Vector3(2.8, 0.9, 1.8)],
		[Vector3(-21.7, 0.32, 3.1), Vector3(1.7, 0.64, 1.4)],
		[Vector3(23.0, 0.48, -15.0), Vector3(2.5, 0.95, 1.9)],
		[Vector3(20.2, 0.36, -13.4), Vector3(1.8, 0.72, 1.4)],
		[Vector3(24.6, 0.33, -12.6), Vector3(1.6, 0.62, 1.5)],
		[Vector3(-2.0, 0.31, -22.0), Vector3(2.3, 0.62, 1.7)],
	]
	for index in range(rock_data.size()):
		var entry: Array = rock_data[index]
		_add_sphere("BasaltBoulder%02d" % index, entry[0], entry[1], mat_basalt, 8, 4)


func _create_village_house() -> void:
	var house := Node3D.new()
	house.name = "VillageMarketHouse"
	house.position = Vector3(5.2, 0.0, -1.8)
	add_child(house)
	var house_scene := load("res://assets/models/village_market_house.glb") as PackedScene
	var original_model := house_scene.instantiate()
	original_model.name = "OriginalBlenderMarketHouse"
	house.add_child(original_model)
	_create_well(house)
	_add_interaction_area(house)


func _create_well(parent: Node3D) -> void:
	var well := Node3D.new()
	well.name = "CourtyardWell"
	well.position = Vector3(-3.7, 0.0, 1.2)
	parent.add_child(well)
	var rim := _make_cylinder(well, "StoneRim", 0.88, 0.70, 0.44, Vector3(0.0, 0.22, 0.0), mat_stone, 12)
	var opening := _make_cylinder(well, "DarkWellWater", 0.62, 0.62, 0.04, Vector3(0.0, 0.45, 0.0), _pbr_material(Color(0.12, 0.17, 0.15), 0.35), 12)
	for side in [-1.0, 1.0]:
		_make_box(well, "WellUpright", Vector3(0.12, 1.4, 0.12), Vector3(side * 0.7, 0.86, 0.0), mat_wood)
	_make_box(well, "WellLintel", Vector3(1.6, 0.12, 0.12), Vector3(0.0, 1.53, 0.0), mat_wood)


func _create_foliage() -> void:
	var tree_positions := [
		Vector3(-28.0, 0.0, -8.0), Vector3(-26.0, 0.0, -14.5), Vector3(-7.0, 0.0, -25.0),
		Vector3(3.0, 0.0, -26.0), Vector3(20.0, 0.0, -22.0), Vector3(28.0, 0.0, -5.0),
		Vector3(26.5, 0.0, 8.0), Vector3(-28.0, 0.0, 14.0), Vector3(17.0, 0.0, 18.0),
		Vector3(-19.0, 0.0, 22.0), Vector3(0.0, 0.0, 27.0), Vector3(29.0, 0.0, 23.0),
	]
	for index in range(tree_positions.size()):
		_create_tree("NeemTree%02d" % index, tree_positions[index], 0.8 + float(index % 4) * 0.12)
	for index in range(18):
		var x := -25.0 + float((index * 17) % 49)
		var z := -4.0 + float((index * 13) % 23)
		if absf(x - 5.2) < 8.0 and absf(z + 1.8) < 7.0:
			continue
		_create_scrub(Vector3(x, 0.0, z), 0.55 + float(index % 3) * 0.12)


func _create_tree(tree_name: String, at: Vector3, scale: float) -> void:
	var tree := Node3D.new()
	tree.name = tree_name
	tree.position = at
	tree.scale = Vector3.ONE * scale
	add_child(tree)
	_make_cylinder(tree, "Trunk", 0.24, 0.16, 2.8, Vector3(0.0, 1.4, 0.0), mat_wood, 8)
	_add_sphere_to(tree, "CrownCenter", Vector3(0.0, 3.05, 0.0), Vector3(1.25, 1.05, 1.05), mat_olive, 8, 4)
	_add_sphere_to(tree, "CrownLeft", Vector3(-0.62, 2.83, 0.12), Vector3(0.82, 0.72, 0.78), mat_leaf_light, 7, 4)
	_add_sphere_to(tree, "CrownRight", Vector3(0.66, 2.9, -0.1), Vector3(0.83, 0.76, 0.78), mat_olive, 7, 4)
	_add_sphere_to(tree, "CrownTop", Vector3(0.0, 3.6, -0.05), Vector3(0.78, 0.72, 0.74), mat_leaf_light, 7, 4)


func _create_scrub(at: Vector3, scale: float) -> void:
	var shrub := Node3D.new()
	shrub.position = at
	shrub.scale = Vector3.ONE * scale
	add_child(shrub)
	_add_sphere_to(shrub, "ScrubA", Vector3(-0.25, 0.32, 0.0), Vector3(0.52, 0.38, 0.50), mat_olive, 6, 3)
	_add_sphere_to(shrub, "ScrubB", Vector3(0.22, 0.3, -0.08), Vector3(0.48, 0.34, 0.44), mat_leaf_light, 6, 3)
	_make_box(shrub, "DryGrass", Vector3(0.04, 0.48, 0.05), Vector3(0.0, 0.25, 0.0), mat_roof)


func _create_units() -> void:
	var squad := [
		["Pahalwan", Vector3(-1.25, 0.0, 5.7), mat_player, "Guard"],
		["Nadiya", Vector3(0.35, 0.0, 6.5), mat_scout, "Scout"],
		["Mali", Vector3(2.2, 0.0, 5.2), mat_worker, "Villager"],
	]
	for entry in squad:
		var unit = UNIT_SCRIPT.new()
		unit.unit_name = entry[0]
		unit.role_name = entry[3]
		unit.outfit_material = entry[2]
		unit.position = entry[1]
		unit.home_position = entry[1]
		add_child(unit)


func _create_camera() -> void:
	camera_rig = Node3D.new()
	camera_rig.name = "StrategyCameraRig"
	camera_rig.set_script(CAMERA_SCRIPT)
	add_child(camera_rig)
	var camera := Camera3D.new()
	camera.name = "StrategyCamera"
	camera.current = true
	camera.fov = 47.0
	camera.position = Vector3(0.0, 11.5, 19.8)
	camera_rig.add_child(camera)
	camera_rig.camera = camera
	camera_rig._apply_zoom()


func _create_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "M1BenchmarkHUD"
	add_child(layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(root)

	var header := _panel(root, "ProjectHeader", Vector2(34, 28), Vector2(424, 105))
	var title := _label(header, "DECCAN LORDS", 25, Color(0.91, 0.77, 0.50), Vector2(20, 10), Vector2(380, 36))
	title.add_theme_font_size_override("font_size", 25)
	_label(header, "FIELD STUDY  /  M1 VISUAL BENCHMARK", 12, Color(0.78, 0.75, 0.67), Vector2(22, 55), Vector2(380, 24))
	_label(root, "WESTERN DECCAN  •  PLATEAU SETTLEMENT STUDY", 13, Color(0.91, 0.86, 0.74), Vector2(0, 31), Vector2(1600, 24), HORIZONTAL_ALIGNMENT_CENTER)

	var inspector := _panel(root, "SelectionInspector", Vector2(1228, 31), Vector2(338, 142))
	hud_title = _label(inspector, "INSPECT", 14, Color(0.91, 0.77, 0.50), Vector2(18, 13), Vector2(294, 22))
	hud_detail = _label(inspector, "Click a guard, villager or house", 15, Color(0.91, 0.87, 0.77), Vector2(18, 43), Vector2(294, 54))
	hud_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hud_order = _label(inspector, "", 12, Color(0.71, 0.76, 0.65), Vector2(18, 103), Vector2(294, 25))

	var controls := _panel(root, "ControlLegend", Vector2(0, 807), Vector2(1600, 65))
	controls.anchor_left = 0.0
	controls.anchor_right = 1.0
	controls.anchor_top = 1.0
	controls.anchor_bottom = 1.0
	controls.offset_left = 0
	controls.offset_right = 0
	controls.offset_top = -93
	controls.offset_bottom = -28
	_label(controls, "LEFT CLICK  SELECT / INSPECT     •     RIGHT CLICK  MOVE SELECTED UNIT", 14, Color(0.91, 0.87, 0.77), Vector2(36, 16), Vector2(950, 30))
	_label(controls, "WASD PAN     Q / E ROTATE     SCROLL ZOOM", 13, Color(0.78, 0.75, 0.67), Vector2(1010, 16), Vector2(554, 30), HORIZONTAL_ALIGNMENT_RIGHT)


func _panel(parent: Control, panel_name: String, at: Vector2, size: Vector2) -> Panel:
	var panel := Panel.new()
	panel.name = panel_name
	panel.position = at
	panel.size = size
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.085, 0.105, 0.092, 0.91)
	style.border_color = Color(0.56, 0.43, 0.23, 0.75)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)
	return panel


func _label(parent: Control, text_value: String, font_size: int, color: Color, at: Vector2, size: Vector2, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = at
	label.size = size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_select_or_inspect_at(event.position)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_order_selected_unit_at(event.position)
			get_viewport().set_input_as_handled()


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


func _select_or_inspect_at(mouse_position: Vector2) -> void:
	var hit := _raycast_at(mouse_position)
	if hit.is_empty():
		_select_unit(null)
		_set_inspector("FIELD STUDY", "Select one of the three characters to give it a movement order.", "")
		return
	var collider: Object = hit.get("collider")
	if collider is Node and collider.is_in_group("selectable_unit"):
		var unit: Node3D = collider.get_parent()
		_select_unit(unit)
		_set_inspector(unit.unit_name.to_upper(), "%s  •  %d m/s\nReady for a movement order." % [unit.role_name, int(round(unit.move_speed))], "UNIT SELECTED")
	elif collider is Node and collider.is_in_group("interactable_building"):
		_select_unit(null)
		_set_inspector("VILLAGE MARKET HOUSE", "Stone footing, shaded veranda and a small village stall.\nPrototype architecture study — not period-locked.", "CLICKED TO INSPECT")
	else:
		_select_unit(null)
		_set_inspector("OPEN GROUND", "Right-click to move the currently selected unit.", "")


func _select_unit(unit: Node3D) -> void:
	if is_instance_valid(selected_unit):
		selected_unit.set_selected(false)
	selected_unit = unit
	if is_instance_valid(selected_unit):
		selected_unit.set_selected(true)


func _order_selected_unit_at(mouse_position: Vector2) -> void:
	if not is_instance_valid(selected_unit):
		_set_inspector("NO UNIT SELECTED", "Left-click a character first, then right-click the ground to move.", "ORDER NOT SENT")
		return
	var hit := _raycast_at(mouse_position)
	if hit.is_empty():
		return
	var collider: Object = hit.get("collider")
	if collider is Node and collider.is_in_group("interactable_building"):
		_set_inspector("MARKET HOUSE", "This study has no simulated economy yet. Click the ground to move your selected unit.", "INSPECTION ONLY")
		return
	var target: Vector3 = hit.get("position", Vector3.ZERO)
	target.x = clampf(target.x, -43.0, 43.0)
	target.z = clampf(target.z, -43.0, 43.0)
	selected_unit.set_destination(target)
	_show_move_marker(target)
	_set_inspector(selected_unit.unit_name.to_upper(), "%s moving to the marked position." % selected_unit.role_name, "MOVE ORDER SENT")


func _show_move_marker(at: Vector3) -> void:
	if move_marker == null:
		move_marker = MeshInstance3D.new()
		var ring := TorusMesh.new()
		ring.inner_radius = 0.53
		ring.outer_radius = 0.62
		ring.rings = 28
		ring.ring_segments = 8
		move_marker.mesh = ring
		var marker_material := _pbr_material(Color(0.94, 0.66, 0.26, 0.94), 0.45)
		marker_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		marker_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		marker_material.emission_enabled = true
		marker_material.emission = Color(0.61, 0.29, 0.06)
		move_marker.material_override = marker_material
		add_child(move_marker)
	if marker_tween and marker_tween.is_running():
		marker_tween.kill()
	move_marker.visible = true
	move_marker.position = Vector3(at.x, 0.045, at.z)
	move_marker.scale = Vector3(1.7, 1.0, 1.7)
	var marker_material := move_marker.material_override as StandardMaterial3D
	marker_material.albedo_color.a = 0.94
	marker_tween = create_tween()
	marker_tween.tween_property(move_marker, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	marker_tween.parallel().tween_property(marker_material, "albedo_color:a", 0.0, 1.5).set_delay(0.45)
	marker_tween.tween_callback(func(): move_marker.visible = false)


func _set_inspector(title: String, detail: String, order: String) -> void:
	if hud_title == null:
		return
	hud_title.text = title
	hud_detail.text = detail
	hud_order.text = order


func _add_interaction_area(parent: Node3D) -> void:
	var area := Area3D.new()
	area.name = "InspectionArea"
	area.add_to_group("interactable_building")
	area.collision_layer = 4
	area.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(6.7, 4.7, 6.3)
	collision.shape = shape
	collision.position = Vector3(0.0, 1.8, 0.65)
	area.add_child(collision)
	parent.add_child(area)


func _make_box(parent: Node3D, node_name: String, size: Vector3, at: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	instance.mesh = mesh
	instance.material_override = material
	instance.position = at
	parent.add_child(instance)
	return instance


func _make_cylinder(parent: Node3D, node_name: String, bottom_radius: float, top_radius: float, height: float, at: Vector3, material: Material, segments: int = 12) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = bottom_radius
	mesh.top_radius = top_radius
	mesh.height = height
	mesh.radial_segments = segments
	instance.mesh = mesh
	instance.material_override = material
	instance.position = at
	parent.add_child(instance)
	return instance


func _add_sphere(node_name: String, at: Vector3, scale: Vector3, material: Material, radial: int, rings: int) -> void:
	_add_sphere_to(self, node_name, at, scale, material, radial, rings)


func _add_sphere_to(parent: Node3D, node_name: String, at: Vector3, scale: Vector3, material: Material, radial: int, rings: int) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 2.0
	mesh.radial_segments = radial
	mesh.rings = rings
	instance.mesh = mesh
	instance.scale = scale
	instance.material_override = material
	instance.position = at
	parent.add_child(instance)
	return instance
