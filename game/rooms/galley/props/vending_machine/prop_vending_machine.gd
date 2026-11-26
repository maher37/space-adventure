@tool
extends PopochiuProp
# Verbs from the 9-verb panel call on_<verb>() below; anything without a handler falls back to
# the funny default lines in game/gui/gui_commands.gd.

func _on_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_item_used(item: PopochiuInventoryItem) -> void:
	await Globals.approach()
	if item != I.SpaceNickel:
		await C.SnackOTron.say("THAT IS NOT CURRENCY. THAT IS AN INSULT.")
		return
	if R.Galley.state.keycard_bought:
		await C.SnackOTron.say("SLOT B4 IS SOLD OUT. GOOD DAY.")
		return
	I.SpaceNickel.remove()
	await C.player.say("One space nickel. Slot B4, please.")
	await C.SnackOTron.say("B4. EXCELLENT CHOICE. THE ONLY CHOICE, REALLY.")
	await E.wait(0.4)
	await C.SnackOTron.say("*CLUNK*")
	R.Galley.state.keycard_bought = true
	I.Keycard.add()
	await C.player.say("Somebody's security keycard. Snacks have really changed.")


func on_look_at() -> void:
	await C.player.face_clicked()
	await C.player.say("The Snack-O-Tron 3000. It accepts space nickels only.")
	if not R.Galley.state.keycard_bought:
		await C.player.say("Slot B4 has... a security keycard in it? Between the jerky and the mystery cubes.")


func on_talk_to() -> void:
	await Globals.approach()
	D.VendingChat.start()


func on_push() -> void:
	await Globals.approach()
	await C.player.say("It weighs more than my salary. Which, admittedly, isn't hard.")


func on_pull() -> void:
	await on_push()


func on_open() -> void:
	await Globals.approach()
	await C.SnackOTron.say("HANDS OFF MY INNARDS.")


func on_use() -> void:
	await Globals.approach()
	await C.SnackOTron.say("INSERT ONE SPACE NICKEL. I DO NOT RUN ON HOPES.")
