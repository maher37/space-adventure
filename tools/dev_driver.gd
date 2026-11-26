extends Node
# Dev-only test driver. Does nothing unless DEV_DRIVER is set, so it is safe to ship.
# DEV_DRIVER=shot      -> screenshot after 3s and quit
# DEV_DRIVER=<path.gd> -> run that script's run(driver) coroutine

var out_dir := "user://shots"


func _ready() -> void:
	var mode := OS.get_environment("DEV_DRIVER")
	if mode.is_empty():
		return
	out_dir = OS.get_environment("DEV_SHOT_DIR") if OS.has_environment("DEV_SHOT_DIR") else out_dir
	DirAccess.make_dir_recursive_absolute(out_dir)
	_go.call_deferred(mode)


func _go(mode: String) -> void:
	if mode == "shot":
		await wait(3.0)
		shot("first")
	else:
		var s: Object = load(mode).new()
		await s.run(self)
	get_tree().quit()


func wait(s: float) -> void:
	await get_tree().create_timer(s).timeout


func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(out_dir.path_join(name + ".png"))
	print("SHOT ", name)


# Clicks at a game-space position (320x200 coordinates). Events are sent in window coordinates,
# so the position is scaled the same way the game is stretched onto the window.
func click(pos: Vector2, button := MOUSE_BUTTON_LEFT) -> void:
	var window_pos: Vector2 = get_viewport().get_final_transform() * pos
	Input.warp_mouse(window_pos)
	var mm := InputEventMouseMotion.new()
	mm.position = window_pos
	mm.global_position = window_pos
	Input.parse_input_event(mm)
	await get_tree().process_frame
	await get_tree().process_frame
	for pressed in [true, false]:
		var e := InputEventMouseButton.new()
		e.button_index = button
		e.pressed = pressed
		e.position = window_pos
		e.global_position = window_pos
		Input.parse_input_event(e)
		await get_tree().process_frame
	await get_tree().process_frame
