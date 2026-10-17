extends Control

## Replaceable strategic presentation. Reads state; emits selection only.
signal location_selected(location_id: String)
const REGION := preload("res://src/world/region_definition.gd")
const UI := preload("res://src/ui/game_ui.gd")
var location_buttons: Dictionary = {}
var preview_route: Array = []
var party_location := "keshavwadi"
var caravan_location := "nandipur"
var caravan_visible := false
var marker := Vector2.ZERO
var initialized := false
var selected_id := "nandipur"


func _ready() -> void:
	custom_minimum_size = Vector2(600, 300)
	clip_contents = true
	for id in REGION.LOCATION_ORDER:
		var place: Dictionary = REGION.LOCATION_DATA[id]
		var button := UI.button(str(place["name"]), false)
		button.custom_minimum_size = Vector2(155, 38)
		button.tooltip_text = str(place["description"])
		button.pressed.connect(func() -> void: location_selected.emit(id))
		location_buttons[id] = button
		add_child(button)
	resized.connect(_layout_places)
	_layout_places()


func _layout_places() -> void:
	for id in location_buttons:
		var button: Button = location_buttons[id]
		button.position = point_for(id) + Vector2(-77, 25)
	queue_redraw()


func point_for(id: String) -> Vector2:
	return Vector2(REGION.LOCATION_DATA[id]["position"]) * size


func set_campaign_state(state: Dictionary) -> void:
	party_location = str(state["player_party"]["location_id"])
	caravan_location = str(state["caravan"]["location_id"])
	caravan_visible = state["caravan"]["status"] not in ["idle", "delivered"]
	if not initialized:
		marker = point_for(party_location)
		initialized = true
	queue_redraw()


func select_location(id: String, route: Array) -> void:
	selected_id = id
	preview_route = route
	for key in location_buttons:
		(location_buttons[key] as Button).modulate = Color("#f2d99e") if key == id else Color.WHITE
	queue_redraw()


func _process(delta: float) -> void:
	var target := point_for(party_location)
	if marker.distance_to(target) > 0.5:
		marker = marker.lerp(target, minf(1.0, delta * 9.0))
		queue_redraw()


func _draw() -> void:
	if size.x < 1:
		return
	draw_rect(Rect2(Vector2.ZERO, size), Color("#263b35"))
	# Authored terrain illustration: replaceable independently of route rules.
	for x in range(0, int(size.x), 40):
		draw_line(Vector2(x, 0), Vector2(x, size.y), Color(0.8, 0.85, 0.68, 0.025))
	for y in range(0, int(size.y), 40):
		draw_line(Vector2(0, y), Vector2(size.x, y), Color(0.8, 0.85, 0.68, 0.025))
	for row in range(3):
		for column in range(7):
			var hill := Vector2(0.30 + column * 0.055, 0.10 + row * 0.085) * size
			var ridge := PackedVector2Array([hill + Vector2(-20, 13), hill + Vector2(0, -13), hill + Vector2(23, 13)])
			draw_polyline(ridge, Color("#536558"), 2.0, true)
	for index in range(32):
		var tree := Vector2(0.09 + fmod(index * 0.071, 0.31), 0.18 + fmod(index * 0.109, 0.24)) * size
		draw_line(tree, tree + Vector2(0, 10), Color("#7e8970"), 1.0)
		draw_colored_polygon(PackedVector2Array([tree + Vector2(-5, 4), tree + Vector2(0, -7), tree + Vector2(5, 4)]), Color("#4a6650"))
	var river := PackedVector2Array()
	for step in range(51):
		var t := step / 50.0
		river.append(Vector2(t, 0.78 - t * 0.30 + sin(t * 10.0) * 0.065) * size)
	draw_polyline(river, Color("#1d2f32"), 19.0, true)
	draw_polyline(river, Color("#497a82"), 12.0, true)
	draw_polyline(river, Color("#719799"), 2.0, true)
	for from in REGION.CONNECTIONS:
		for to in REGION.CONNECTIONS[from]:
			if str(from) < str(to):
				draw_line(point_for(from), point_for(to), Color("#172722"), 7.0, true)
				draw_dashed_line(point_for(from), point_for(to), Color("#a49772"), 2.0, 8.0, true)
	var previous := point_for(party_location)
	for id in preview_route:
		draw_line(previous, point_for(id), Color("#e0bc71"), 3.0, true)
		previous = point_for(id)
	for id in REGION.LOCATION_ORDER:
		_draw_place(id)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(22, 31), "KALDAR MARCHES", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("#b6b99d"))
	draw_string(font, Vector2(size.x - 64, 35), "N", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("#c4bd9b"))
	draw_line(Vector2(size.x - 58, 46), Vector2(size.x - 58, 70), Color("#c4bd9b"), 2)
	draw_string(font, Vector2(22, size.y - 19), "Select a named location to inspect its route", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#a8b4a2"))
	var flag := marker + Vector2(-28, -6)
	draw_line(flag, flag + Vector2(0, -30), Color("#eed7a5"), 2)
	draw_colored_polygon(PackedVector2Array([flag + Vector2(0, -30), flag + Vector2(22, -23), flag + Vector2(0, -16)]), Color("#e9ba61"))
	if caravan_visible:
		var wagon := point_for(caravan_location) + Vector2(25, -8)
		draw_rect(Rect2(wagon, Vector2(19, 12)), Color("#99c5ad"))
		for offset in [3, 16]:
			draw_circle(wagon + Vector2(offset, 14), 3, Color("#182e26"))


func _draw_place(id: String) -> void:
	var point := point_for(id)
	var kind: String = REGION.LOCATION_DATA[id]["kind"]
	draw_circle(point, 23, Color("#203029"))
	draw_arc(point, 25, 0, TAU, 40, Color("#d9bb7e") if id == selected_id else Color("#687866"), 2, true)
	var ink := Color("#d8cbaa")
	if kind == "Fort":
		draw_rect(Rect2(point - Vector2(14, 7), Vector2(28, 20)), ink)
		for x in [-14, -3, 8]:
			draw_rect(Rect2(point + Vector2(x, -14), Vector2(6, 8)), ink)
		draw_rect(Rect2(point + Vector2(-4, 3), Vector2(8, 10)), Color("#203029"))
	elif kind == "Pass":
		draw_polyline(PackedVector2Array([point + Vector2(-16, 10), point + Vector2(-4, -12), point + Vector2(7, 10)]), ink, 2, true)
		draw_polyline(PackedVector2Array([point + Vector2(0, 10), point + Vector2(9, -7), point + Vector2(18, 10)]), ink, 2, true)
	else:
		draw_rect(Rect2(point + Vector2(-12, -2), Vector2(24, 15)), ink)
		draw_colored_polygon(PackedVector2Array([point + Vector2(-17, -2), point + Vector2(0, -15), point + Vector2(17, -2)]), Color("#b58e68"))
		draw_rect(Rect2(point + Vector2(-3, 5), Vector2(6, 8)), Color("#203029"))
