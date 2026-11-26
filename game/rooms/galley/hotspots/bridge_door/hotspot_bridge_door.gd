@tool
extends PopochiuHotspot
# Verbs from the 9-verb panel call on_<verb>() below; anything without a handler falls back to
# the funny default lines in game/gui/gui_commands.gd.

func _on_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_item_used(item: PopochiuInventoryItem) -> void:
	await Globals.approach()
	if item != I.Keycard:
		await C.player.say("The card reader is not interested in that.")
		return
	await C.player.say("Swipe!")
	R.Galley.state.bridge_unlocked = true
	I.Keycard.remove()
	await C.player.say("It worked! I'm a genius. A genius with clearance.")
	await _go_through()


func on_look_at() -> void:
	await C.player.face_clicked()
	await C.player.say("The door to the bridge. Snack Restockers are not allowed on the bridge.")
	await C.player.say("Which is exactly why I want to go in.")


func on_open() -> void:
	await Globals.approach()
	if R.Galley.state.bridge_unlocked:
		await _go_through()
		return
	await C.player.say("Locked. The card reader blinks at me, smugly.")


func on_push() -> void:
	await on_open()


func _go_through() -> void:
	C.player.hide()
	await G.show_system_text("End of room one. The bridge is still being built. (Like most of my ambitions.)")
	C.player.show()
