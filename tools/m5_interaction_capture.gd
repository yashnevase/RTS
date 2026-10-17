extends SceneTree

var world: Control
var suffix: String
const SAVE := "user://m5_interaction_capture.json"

func _initialize() -> void:
	call_deferred("_run")

func _frames(count: int = 3) -> void:
	for frame in range(count):
		await process_frame

func _click(button: Control) -> void:
	var parent := button.get_parent()
	while parent != null:
		if parent is ScrollContainer:
			parent.ensure_control_visible(button)
		parent = parent.get_parent()
	await _frames()
	var point := button.get_global_rect().get_center()
	for pressed in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.position = point
		root.push_input(event, true)
		await process_frame
	await _frames()

func _check(ok: bool, message: String) -> bool:
	if not ok:
		push_error(message)
		quit(1)
	return ok

func _capture(name: String) -> void:
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png("res://artifacts/m5/%s_%s.png" % [name, suffix])
	_check(error == OK, "Capture failed: " + name)

func _run() -> void:
	world = load("res://scenes/campaign/m4_strategic_campaign.tscn").instantiate()
	root.add_child(world)
	world.save_path = SAVE
	await _frames(8)
	suffix = "%dx%d" % [DisplayServer.window_get_size().x, DisplayServer.window_get_size().y]
	await _click(world.hud.map_board.location_buttons["kaldar_pass"])
	await _click(world.hud.travel_button)
	await _click(world.hud.advance_button)
	if not _check(world.simulation.player_location_id() == "kaldar_pass", "Mouse input must travel to pass"):
		return
	await _click(world.hud.save_button)
	await _click(world.hud.encounter_button)
	if not _check(world.battle_view != null, "Mouse input must enter battle"):
		return
	await _frames(8)
	var battle: Node3D = world.battle_view
	var camera := root.get_camera_3d()
	var actor: Node3D = battle.unit_actors["player_guard_1"]
	var point := camera.unproject_position(actor.global_position + Vector3(0, 1, 0))
	for pressed in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.position = point
		event.pressed = pressed
		root.push_input(event, true)
		await process_frame
	if not _check(battle.selected_unit_ids.has("player_guard_1"), "Battle mouse selection must pass through campaign root"):
		return
	await _capture("battle_selected")
	await _click(battle.battle_hud.restart_button)
	var deadline := Time.get_ticks_msec() + 15000
	while battle.simulation.outcome == "ongoing" and Time.get_ticks_msec() < deadline:
		await process_frame
	if not _check(battle.simulation.outcome != "ongoing", "Withdrawal must resolve"):
		return
	await _capture("battle_result")
	await _click(battle.battle_hud.play_again)
	if not _check(world.battle_view == null and world.simulation.state["encounter"]["completed"] == 1, "Return must record result once"):
		return
	await _click(world.hud.map_board.location_buttons["keshavwadi"])
	await _click(world.hud.travel_button)
	await _click(world.hud.advance_button)
	await _click(world.hud.prepare_button)
	if not _check(world.simulation.state["encounter"]["status"] == "available", "Home preparation must permit another patrol"):
		return
	print("M5 capture: home prepared")
	await _capture("home_prepared")
	await _click(world.hud.save_button)
	var expected: Dictionary = world.simulation.to_save_data()
	await _click(world.hud.advance_button)
	print("M5 capture: loading saved campaign")
	await _click(world.hud.load_button)
	if not _check(world.simulation.to_save_data() == expected, "UI save/load must restore full campaign"):
		return
	print("M5 capture: first save/load complete")
	# A second encounter proves that a real defeat can be replenished through UI.
	await _click(world.hud.map_board.location_buttons["kaldar_pass"])
	await _click(world.hud.travel_button)
	await _click(world.hud.advance_button)
	await _click(world.hud.encounter_button)
	print("M5 capture: second battle entered")
	battle = world.battle_view
	deadline = Time.get_ticks_msec() + 45000
	while battle.simulation.outcome == "ongoing" and Time.get_ticks_msec() < deadline:
		await process_frame
	if not _check(battle.simulation.outcome == "defeat", "Unattended second patrol must resolve"):
		return
	print("M5 capture: second battle resolved")
	await _capture("battle_casualties")
	await _click(battle.battle_hud.play_again)
	await _click(world.hud.map_board.location_buttons["keshavwadi"])
	await _click(world.hud.travel_button)
	await _click(world.hud.advance_button)
	var coin_before: int = world.simulation.settlement.state["treasury"]
	for index in range(5):
		await _click(world.hud.recruit_button)
	if not _check(world.simulation.settlement.state["treasury"] == coin_before - 60, "Five UI recruits must debit 60 coin"):
		return
	await _click(world.hud.prepare_button)
	if not _check(world.simulation.state["encounter"]["completed"] == 2 and world.simulation.state["encounter"]["status"] == "available", "Defeat and paid replenishment must permit another patrol"):
		return
	await _capture("replenished")
	world.hud.tabs.current_tab = 1
	await _frames()
	await _capture("settlement")
	for ending in ["", ".tmp", ".bak"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE + ending))
	world.queue_free()
	await _frames()
	print("M5 mouse interaction passed: travel, enter, select, withdraw, return, prepare, save/load, real defeat and paid replacements (%s)." % suffix)
	quit()
