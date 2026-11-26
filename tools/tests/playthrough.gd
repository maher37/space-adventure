extends RefCounted
# Full playthrough of room one, using real mouse clicks on the 9-verb panel.
# Run: DEV_DRIVER=res://tools/tests/playthrough.gd xvfb-run godot --path .
# Prints PASS/FAIL lines and saves screenshots to DEV_SHOT_DIR.

# Verb buttons, in game pixels (320x200 screen).
const VERB := {
	"open": Vector2(20, 158), "pick_up": Vector2(63, 158), "push": Vector2(106, 158),
	"close": Vector2(20, 174), "look_at": Vector2(63, 174), "pull": Vector2(106, 174),
	"give": Vector2(20, 190), "talk_to": Vector2(63, 190), "use": Vector2(106, 190),
}
const INV_SLOT_1 := Vector2(175, 162)
const SPOT := {
	"couch": Vector2(175, 88), "nickel": Vector2(196, 110), "vending": Vector2(113, 70),
	"button": Vector2(237, 58), "door": Vector2(63, 70), "floor": Vector2(150, 130),
}

var d: Node
var failures := 0


func run(driver: Node) -> void:
	d = driver
	await d.wait(1.0)
	await advance()  # Intro lines.
	await d.shot("01_start")

	await act("look_at", SPOT.couch)
	check("couch not searched yet", not R.Galley.state.couch_searched)

	await act("pull", SPOT.couch, "02_search_couch")
	check("couch searched", R.Galley.state.couch_searched)
	check("nickel visible", R.Galley.get_prop("SpaceNickel").visible)

	await act("pick_up", SPOT.nickel)
	check("nickel in inventory", I.SpaceNickel.in_inventory)
	await d.shot("03_have_nickel")

	# The silly death, then the rewind.
	await d.click(VERB.push)
	await d.click(SPOT.button)
	await advance(8.0, true)
	await d.wait(1.2)
	await d.shot("04_death")
	var try_again := _find_button("Try again")
	check("death screen shown", try_again != null)
	if try_again:
		try_again.pressed.emit()
	await advance()
	check("player back after rewind", C.player.visible and C.player.position.x < 240)
	check("nickel kept after rewind", I.SpaceNickel.in_inventory)
	await d.shot("05_after_rewind")

	# Talk to the vending machine and pick the keycard question.
	await act("talk_to", SPOT.vending)
	await d.wait(0.5)
	await d.shot("06_dialog_options")
	await _choose_dialog_option("Why is there a keycard")
	await advance()
	await _choose_dialog_option("Bye")
	await advance()

	# Use nickel on the machine.
	await d.click(VERB.use)
	await d.click(INV_SLOT_1)
	await d.click(SPOT.vending)
	await advance(15.0)
	check("keycard bought", R.Galley.state.keycard_bought and I.Keycard.in_inventory)
	check("nickel spent", not I.SpaceNickel.in_inventory)
	await d.shot("07_have_keycard")

	# Use keycard on the bridge door.
	await d.click(VERB.use)
	await d.click(INV_SLOT_1)
	await d.click(SPOT.door)
	await advance(15.0)
	check("bridge unlocked", R.Galley.state.bridge_unlocked)
	await d.shot("08_end")

	print("RESULT ", "PASS" if failures == 0 else "FAIL (%d)" % failures, " deaths=", Globals.deaths)


func act(verb: String, target: Vector2, shot_name := "") -> void:
	await d.click(VERB[verb])
	await d.click(target)
	if shot_name:
		await d.wait(1.5)
		await d.shot(shot_name)
	await advance()


# Clicks through speech until nothing is talking and the game is idle.
func advance(timeout := 12.0, stop_on_death := false) -> void:
	var end := Time.get_ticks_msec() + int(timeout * 1000)
	var idle_since := -1
	var last_pos := C.player.position
	while Time.get_ticks_msec() < end:
		if stop_on_death and _find_button("Try again"):
			return
		if _text_showing():
			idle_since = -1
			await d.wait(0.35)
			await d.click(Vector2(160, 10))
			continue
		if C.player.position != last_pos or C.player._is_talking:
			last_pos = C.player.position
			idle_since = -1
		elif idle_since < 0:
			idle_since = Time.get_ticks_msec()
		elif Time.get_ticks_msec() - idle_since > 900:
			return
		await d.wait(0.1)


func _text_showing() -> bool:
	for n in d.get_tree().root.find_children("*", "RichTextLabel", true, false):
		var p: Node = n.get_parent()
		if not (p.name.begins_with("Dialog") or p.name == "SystemText"):
			continue  # Skip hover labels; only speech and system messages wait for a click.
		if n.is_visible_in_tree() and p is Control and p.modulate.a > 0.0 and n.get_parsed_text().strip_edges() != "":
			return true
	return false


func _find_button(text: String) -> Button:
	for b in d.get_tree().root.find_children("*", "Button", true, false):
		if b.is_visible_in_tree() and text in b.text:
			return b
	return null


func _choose_dialog_option(prefix: String) -> void:
	await d.wait(0.6)
	# Click the option the way a player would: find its on-screen line in the dialog menu.
	for n in d.get_tree().root.find_children("*", "", true, false):
		if not (n is Control and n.is_visible_in_tree() and "DialogMenu" in str(n.get_path())):
			continue
		var t: String = n.get_parsed_text() if n is RichTextLabel else str(n.get("text"))
		if t.begins_with(prefix):
			var r: Rect2 = n.get_global_rect()
			await d.click(r.position + Vector2(min(r.size.x, 40) / 2.0, r.size.y / 2.0))
			return
	check("dialog option '%s' found" % prefix, false)


func check(label: String, ok: bool) -> void:
	print("PASS " if ok else "FAIL ", label)
	if not ok:
		failures += 1
