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
	await C.player.say("The break-room couch. It has absorbed eleven years of crumbs.")
	if not R.Galley.state.couch_searched:
		await C.player.say("Something shiny is wedged between the cushions.")


func on_pull() -> void:
	await _search()


func on_open() -> void:
	await _search()


func on_pick_up() -> void:
	await _search()


func on_use() -> void:
	await Globals.approach()
	await C.player.say("I'm on shift. Officially, I don't know how to sit.")


func on_push() -> void:
	await Globals.approach()
	await C.player.say("It's bolted down. Someone must have tried to steal it. Twice.")


func _search() -> void:
	await Globals.approach()
	if R.Galley.state.couch_searched:
		await C.player.say("Just crumbs left. Ancient, angry crumbs.")
		return
	await C.player.say("Let's see what the cushions are hiding...")
	await E.wait(0.5)
	await C.player.say("A fossilized fry. A sock. And...")
	R.Galley.state.couch_searched = true
	R.Galley.get_prop("SpaceNickel").show()
	await C.player.say("A space nickel! It bounced onto the floor.")
