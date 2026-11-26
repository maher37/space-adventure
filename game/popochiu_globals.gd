extends Node
# Game-wide helpers. Available everywhere as `Globals`.

const DeathScreen := preload("res://game/death/death_screen.gd")

var deaths := 0


## Silly death. Shows the death screen, then puts the player back where they stood before the
## fatal action. Call it only BEFORE changing any game state in that action, so "Try again" is a
## clean rewind.
func die(title: String, joke: String, safe_position: Vector2) -> void:
	deaths += 1
	var screen := DeathScreen.new()
	screen.title = title
	screen.joke = joke
	screen.deaths = deaths
	G.hide_interface()
	G.block()
	get_tree().root.add_child(screen)
	await screen.try_again_pressed
	screen.queue_free()
	C.player.teleport_to_position(safe_position)
	C.player.modulate = Color.WHITE
	C.player.rotation = 0.0
	C.player.scale = Vector2.ONE
	C.player.show()
	C.player.face_right()
	G.unblock()
	G.show_interface()
	await C.player.say("Huh. What a weird daydream.")


## Walks the player to whatever was clicked and turns to face it.
func approach() -> void:
	await C.player.walk_to_clicked()
	await C.player.face_clicked()
