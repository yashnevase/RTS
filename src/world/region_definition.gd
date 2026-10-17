extends RefCounted

## Authored scenario geography shared by simulation and presentation.
## Coordinates are map layout only; travel follows the route graph.

const KESHVWADI_ID := "keshavwadi"
const NANDIPUR_ID := "nandipur"
const KALDAR_PASS_ID := "kaldar_pass"
const SURYAGARH_ID := "suryagarh"
const LOCATION_ORDER := [KESHVWADI_ID, KALDAR_PASS_ID, NANDIPUR_ID, SURYAGARH_ID]
const LOCATION_DATA := {
	KESHVWADI_ID: {"position": Vector2(0.19, 0.66), "name": "Keshavwadi", "kind": "Settlement", "description": "The player's fictional settlement and household stores."},
	KALDAR_PASS_ID: {"position": Vector2(0.49, 0.44), "name": "Kaldar Pass", "kind": "Pass", "description": "A public route junction between the market and the settlement."},
	NANDIPUR_ID: {"position": Vector2(0.79, 0.27), "name": "Nandipur Market", "kind": "Market", "description": "A fictional merchant hub where escorted contracts are arranged."},
	SURYAGARH_ID: {"position": Vector2(0.72, 0.76), "name": "Suryagarh Fort", "kind": "Fort", "description": "The superior's nearby hill-fort seat."},
}
const CONNECTIONS := {
	KESHVWADI_ID: [KALDAR_PASS_ID],
	KALDAR_PASS_ID: [KESHVWADI_ID, NANDIPUR_ID, SURYAGARH_ID],
	NANDIPUR_ID: [KALDAR_PASS_ID],
	SURYAGARH_ID: [KALDAR_PASS_ID],
}

static func find_route(origin_id: String, destination_id: String) -> Array:
	if not CONNECTIONS.has(origin_id) or not CONNECTIONS.has(destination_id):
		return []
	var frontier: Array = [origin_id]
	var paths := {origin_id: []}
	while not frontier.is_empty():
		var current_id := str(frontier.pop_front())
		if current_id == destination_id:
			return paths[current_id]
		for neighbour_value in CONNECTIONS[current_id]:
			var neighbour_id := str(neighbour_value)
			if paths.has(neighbour_id):
				continue
			var next_path: Array = (paths[current_id] as Array).duplicate()
			next_path.append(neighbour_id)
			paths[neighbour_id] = next_path
			frontier.append(neighbour_id)
	return []


static func valid_path(origin: String, route: Array, destination: String) -> bool:
	var previous := origin
	for next in route:
		if typeof(next) != TYPE_STRING or not CONNECTIONS.get(previous, []).has(next):
			return false
		previous = next
	return route.is_empty() or previous == destination
