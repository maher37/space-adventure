@tool
extends PopochiuHotspot
# Verbs from the 9-verb panel call on_<verb>() below; anything without a handler falls back to
# the funny default lines in game/gui/gui_commands.gd.

func _on_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func on_look_at() -> void:
	await C.player.face_clicked()
	await C.player.say("Space. Lots of it.")
	await C.player.say("Still no snack stands out there. Somebody should get on that.")


func on_open() -> void:
	await Globals.approach()
	await C.player.say("Opening a window on a spaceship is how you become a former employee.")
