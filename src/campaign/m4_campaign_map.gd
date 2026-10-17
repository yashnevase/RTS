extends Control

## Decorative, data-readout strategic board. Commands remain in the campaign HUD.

const POSITIONS := {
	"keshavwadi": Vector2(0.22, 0.67),
	"kaldar_pass": Vector2(0.50, 0.47),
	"nandipur": Vector2(0.77, 0.30),
	"suryagarh": Vector2(0.67, 0.76),
}
const CONNECTIONS := [
	["keshavwadi", "kaldar_pass"],
	["kaldar_pass", "nandipur"],
	["kaldar_pass", "suryagarh"],
]

var player_location_id := ""
var caravan_location_id := ""
var caravan_status := "idle"


func _ready() -> void:
	custom_minimum_size = Vector2(620, 385)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_campaign_state(campaign_state: Dictionary) -> void:
	var party: Dictionary = campaign_state.get("player_party", {})
	var caravan: Dictionary = campaign_state.get("caravan", {})
	player_location_id = str(party.get("location_id", ""))
	caravan_location_id = str(caravan.get("location_id", ""))
	caravan_status = str(caravan.get("status", "idle"))
	queue_redraw()


func _draw() -> void:
	var board := Rect2(Vector2.ZERO, size)
	if board.size.x < 100.0 or board.size.y < 100.0:
		return
	draw_rect(board, Color("#273b32"), true)
	draw_rect(board.grow(-9.0), Color("#31493b"), true)
	_draw_land_forms(board)
	for connection in CONNECTIONS:
		var from_point := _point_for(str(connection[0]), board)
		var to_point := _point_for(str(connection[1]), board)
		draw_line(from_point, to_point, Color("#c69f60"), 5.0, true)
		draw_line(from_point, to_point, Color("#744f31"), 1.0, true)
	for location_id in POSITIONS:
		_draw_location(str(location_id), _point_for(str(location_id), board))
	if not player_location_id.is_empty() and POSITIONS.has(player_location_id):
		var player_point := _point_for(player_location_id, board) + Vector2(-15.0, -19.0)
		draw_circle(player_point, 10.0, Color("#e3be70"))
		draw_arc(player_point, 13.0, 0.0, TAU, 20, Color("#fff1c4"), 2.0, true)
	if caravan_status != "idle" and caravan_status != "delivered" and POSITIONS.has(caravan_location_id):
		var caravan_point := _point_for(caravan_location_id, board) + Vector2(17.0, 14.0)
		draw_rect(Rect2(caravan_point - Vector2(8.0, 6.0), Vector2(16.0, 12.0)), Color("#98bd8c"), true)
		draw_rect(Rect2(caravan_point - Vector2(8.0, 6.0), Vector2(16.0, 12.0)), Color("#e9f0d6"), false, 1.0)


func _draw_land_forms(board: Rect2) -> void:
	var center := board.get_center()
	draw_circle(center + Vector2(-120.0, -35.0), minf(board.size.x, board.size.y) * 0.31, Color("#3e5742"))
	draw_circle(center + Vector2(155.0, 84.0), minf(board.size.x, board.size.y) * 0.25, Color("#466049"))
	draw_circle(center + Vector2(44.0, -124.0), minf(board.size.x, board.size.y) * 0.16, Color("#536b4f"))
	var river_start := Vector2(board.position.x + board.size.x * 0.08, board.position.y + board.size.y * 0.20)
	var river_end := Vector2(board.position.x + board.size.x * 0.90, board.position.y + board.size.y * 0.89)
	draw_line(river_start, river_end, Color("#5a91a0"), 10.0, true)
	draw_line(river_start, river_end, Color("#7fb5bd"), 2.0, true)


func _draw_location(location_id: String, point: Vector2) -> void:
	var color := Color("#d4a95f")
	if location_id == "keshavwadi":
		color = Color("#e3be70")
	elif location_id == "suryagarh":
		color = Color("#c48468")
	elif location_id == "nandipur":
		color = Color("#a8c48f")
	draw_circle(point, 13.0, Color("#1d2923"))
	draw_circle(point, 9.0, color)
	draw_arc(point, 15.0, 0.0, TAU, 18, Color("#e8dcc0"), 1.0, true)


func _point_for(location_id: String, board: Rect2) -> Vector2:
	var ratio: Vector2 = POSITIONS.get(location_id, Vector2(0.5, 0.5))
	return Vector2(board.position.x + board.size.x * ratio.x, board.position.y + board.size.y * ratio.y)
