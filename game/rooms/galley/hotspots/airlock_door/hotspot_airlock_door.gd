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
	await C.player.say("The airlock. It leads to the great outdoors.")
	await C.player.say("Very great. Very outdoors. Zero oxygen.")


func on_open() -> void:
	await Globals.approach()
	await C.player.say("There's no handle. Just that suspicious red button.")


func on_push() -> void:
	await Globals.approach()
	await C.player.say("Nope. Sturdy. Good. Let's keep it that way.")
