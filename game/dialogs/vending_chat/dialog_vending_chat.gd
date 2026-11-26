@tool
extends PopochiuDialog
# Talking to the Snack-O-Tron 3000. Option ids match the .tres file next to this script.


func _on_start() -> void:
	await C.SnackOTron.say("GREETINGS, MEAT-BASED CUSTOMER.")


func _option_selected(opt: PopochiuDialogOption) -> void:
	await D.say_selected()
	match opt.id:
		"Who":
			await C.SnackOTron.say("I AM SNACK-O-TRON 3000. I DISPENSE JOY. FOR A FEE.")
		"Keycard":
			await C.SnackOTron.say("THE CAPTAIN TRADED IT TO ME FOR A CHEESE PUFF.")
			await C.SnackOTron.say("IT IS NOW MERCHANDISE. SLOT B4. ONE SPACE NICKEL.")
			await C.player.say("Where would I find a space nickel on this ship?")
			await C.SnackOTron.say("WHERE ALL LOST THINGS GO. THE COUCH.")
			turn_off_options(["Keycard"])
		"Free":
			await C.SnackOTron.say("LET ME CHECK.")
			await E.wait(1.0)
			await C.SnackOTron.say("NO.")
		"Bye":
			await C.SnackOTron.say("COME BACK WITH MONEY.")
			stop()
			return
	_show_options()


func _on_save() -> Dictionary:
	return {}


func _on_load(_data: Dictionary) -> void:
	pass
