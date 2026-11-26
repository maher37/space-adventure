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
	await C.player.say("A big red button. The sign says DON'T.")
	await C.player.say("Don't what, though? It's very vague.")


func on_push() -> void:
	var safe_spot := C.player.position
	await Globals.approach()
	await C.player.say("I'm sure it's fine.")
	G.block()
	await E.wait(0.4)
	# Wind rushes toward the airlock and takes Dex with it.
	await C.player.say("Hey, is it windy in h-")
	var tween := create_tween().set_parallel()
	tween.tween_property(C.player, "position", Vector2(290, 92), 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(C.player, "rotation", TAU * 2, 0.7)
	tween.tween_property(C.player, "scale", Vector2(0.2, 0.2), 0.7)
	await tween.finished
	C.player.hide()
	G.unblock()
	await Globals.die(
		"YOU HAVE BEEN EJECTED",
		"On the bright side, you are now the fastest crew member on the ship. Well, near the ship.",
		safe_spot
	)


func on_pick_up() -> void:
	await Globals.approach()
	await C.player.say("It's bolted to the wall. Like my career.")


func on_pull() -> void:
	await Globals.approach()
	await C.player.say("It's a push button. Pulling it would just be embarrassing for both of us.")


func on_talk_to() -> void:
	await C.player.face_clicked()
	await C.player.say("Hello, button.")
	await E.wait(0.8)
	await C.player.say("It's giving me the silent treatment.")
