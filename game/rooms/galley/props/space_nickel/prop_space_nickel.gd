@tool
extends PopochiuProp
# Verbs from the 9-verb panel call on_<verb>() below; anything without a handler falls back to
# the funny default lines in game/gui/gui_commands.gd.

func _on_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func on_look_at() -> void:
	await C.player.face_clicked()
	await C.player.say("A space nickel. Worth five space cents, or one bad snack.")


func on_pick_up() -> void:
	await Globals.approach()
	R.Galley.state.nickel_taken = true
	hide()
	I.SpaceNickel.add()
	await C.player.say("Finders keepers. That's in the crew handbook. Probably.")
