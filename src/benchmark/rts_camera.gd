extends Node3D

@export var pan_speed: float = 16.0
@export var rotate_speed: float = 1.2
@export var zoom_step: float = 2.2
@export var minimum_distance: float = 11.0
@export var maximum_distance: float = 34.0

var camera: Camera3D
var zoom_distance: float = 23.0
var middle_dragging := false
var last_mouse_position := Vector2.ZERO


func _ready() -> void:
	position = Vector3(0.0, 0.0, 0.0)
	rotation.y = deg_to_rad(-12.0)
	_apply_zoom()


func _process(delta: float) -> void:
	var movement := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		movement.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		movement.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		movement.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		movement.y += 1.0
	if movement.length_squared() > 0.0:
		var world_move := Vector3(movement.x, 0.0, movement.y).rotated(Vector3.UP, rotation.y)
		position += world_move.normalized() * pan_speed * delta * zoom_distance / 22.0
	if Input.is_key_pressed(KEY_Q):
		rotation.y += rotate_speed * delta
	if Input.is_key_pressed(KEY_E):
		rotation.y -= rotate_speed * delta
	position.x = clampf(position.x, -35.0, 35.0)
	position.z = clampf(position.z, -35.0, 35.0)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_distance = maxf(minimum_distance, zoom_distance - zoom_step)
			_apply_zoom()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_distance = minf(maximum_distance, zoom_distance + zoom_step)
			_apply_zoom()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_dragging = event.pressed
			last_mouse_position = event.position
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and middle_dragging:
		var delta_position: Vector2 = event.position - last_mouse_position
		last_mouse_position = event.position
		var drag_move := Vector3(-delta_position.x, 0.0, -delta_position.y).rotated(Vector3.UP, rotation.y)
		position += drag_move * (zoom_distance / 1700.0)
		position.x = clampf(position.x, -35.0, 35.0)
		position.z = clampf(position.z, -35.0, 35.0)
		get_viewport().set_input_as_handled()


func _apply_zoom() -> void:
	if camera == null:
		return
	camera.position = Vector3(0.0, zoom_distance * 0.50, zoom_distance * 0.86)
	camera.look_at(Vector3.ZERO, Vector3.UP)
