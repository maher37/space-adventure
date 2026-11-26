@tool
extends EditorPlugin
const GuiHelper = preload("res://addons/popochiu/editor/helpers/popochiu_gui_templates_helper.gd")
# One-time scaffolding: runs Popochiu's own factories so files match what its editor makes.

func _enter_tree() -> void:
	var step := OS.get_environment("BOOTSTRAP_STEP")
	if step == "1":
		_run.call_deferred()
	elif step == "2":
		_run2.call_deferred()
	elif step == "3":
		_run3.call_deferred()
	elif step == "4":
		_run4.call_deferred()


func _run4() -> void:
	await _wait(3.0)
	# Same as Popochiu's _create_input_actions(), which only runs when enabled from the editor UI.
	var actions := preload("res://addons/popochiu/engine/others/input_actions.gd")
	for d in actions.ACTIONS:
		var setting_name: String = "input/" + d.name
		if ProjectSettings.has_setting(setting_name):
			continue
		var event: InputEvent
		if d.has("button"):
			event = InputEventMouseButton.new()
			event.button_index = d.button
		elif d.has("key"):
			event = InputEventKey.new()
			event.keycode = d.key
		ProjectSettings.set_setting(setting_name, {
			deadzone = float(d.deadzone if d.has("deadzone") else 0.5), events = [event]
		})
	print("BOOT4: input ", ProjectSettings.save())
	get_tree().quit()


func _run3() -> void:
	await _wait(4.0)
	print("BOOT3: npc ", PopochiuCharacterFactory.new().create("SnackOTron", false))
	await _wait(1.0)
	var path := "res://game/characters/snack_o_tron/character_snack_o_tron.tscn"
	var npc: Node2D = (load(path) as PackedScene).instantiate()
	npc.set("description", "Snack-O-Tron 3000")
	npc.set("text_color", Color("7fe8ff"))
	npc.set("dialog_pos", Vector2(0, -8))
	npc.set("clickable", false)
	npc.set("obstacle", false)
	for c in npc.get_children():
		c.owner = npc
	var scene := PackedScene.new()
	scene.pack(npc)
	print("  saved ", ResourceSaver.save(scene, path))
	print("BOOT3: done")
	get_tree().quit()


func _run2() -> void:
	await _wait(4.0)
	print("BOOT2: start")
	await preload("step2.gd").run(self, _wait)
	print("BOOT2: done")
	get_tree().quit()


func _wait(s: float) -> void:
	var end := Time.get_ticks_msec() + int(s * 1000)
	while Time.get_ticks_msec() < end:
		await get_tree().process_frame


func _run() -> void:
	await _wait(4.0)
	print("BOOT: settings")
	ProjectSettings.set_setting(PopochiuResources.DISPLAY_WIDTH, 320)
	ProjectSettings.set_setting(PopochiuResources.DISPLAY_HEIGHT, 200)
	ProjectSettings.set_setting(PopochiuResources.TEST_WIDTH, 1280)
	ProjectSettings.set_setting(PopochiuResources.TEST_HEIGHT, 800)
	ProjectSettings.set_setting(PopochiuResources.STRETCH_MODE, "canvas_items")
	ProjectSettings.set_setting(PopochiuResources.STRETCH_ASPECT, "keep")
	PopochiuConfig.set_pixel_art_textures(true)
	ProjectSettings.save()

	print("BOOT: gui")
	await GuiHelper.copy_gui_template("9_verb", func(p, m): print("  gui ", p, " ", m), func(): print("  gui done"))

	print("BOOT: character")
	print("  ", PopochiuCharacterFactory.new().create("Dex", true))

	print("BOOT: room")
	var rf := PopochiuRoomFactory.new()
	print("  ", rf.create("Galley", true))
	await _wait(2.0)

	for item in ["SpaceNickel", "Keycard"]:
		print("BOOT: item ", item, " ", PopochiuInventoryItemFactory.new().create(item))
	print("BOOT: dialog ", PopochiuDialogFactory.new().create("VendingChat"))
	await _wait(1.0)

	var room_path := "res://game/rooms/galley/room_galley.tscn"
	EditorInterface.open_scene_from_path(room_path)
	await _wait(2.0)
	var room: PopochiuRoom = EditorInterface.get_edited_scene_root()
	print("BOOT: room open ", room)

	var bg := PopochiuPropFactory.PopochiuPropFactoryParam.new()
	bg.obj_name = "background"; bg.room = room; bg.is_interactive = false
	print("  prop bg ", PopochiuPropFactory.new().create(bg))
	await _wait(0.5)

	for p in ["vending_machine", "space_nickel"]:
		var pp := PopochiuPropFactory.PopochiuPropFactoryParam.new()
		pp.obj_name = p; pp.room = room; pp.is_interactive = true
		print("  prop ", p, " ", PopochiuPropFactory.new().create(pp))
		await _wait(0.5)

	for h in ["airlock_button", "bridge_door", "couch", "window"]:
		var hp := PopochiuHotspotFactory.PopochiuHotspotFactoryParam.new()
		hp.obj_name = h; hp.room = room; hp.is_interactive = true
		print("  hotspot ", h, " ", PopochiuHotspotFactory.new().create(hp))
		await _wait(0.5)

	var wp := PopochiuWalkableAreaFactory.PopochiuWalkableAreaFactoryParam.new()
	wp.obj_name = "floor"; wp.room = room
	print("  walkable ", PopochiuWalkableAreaFactory.new().create(wp))
	await _wait(0.5)

	var mp := PopochiuRoomObjFactory.PopochiuRoomObjFactoryParam.new()
	mp.obj_name = "start"; mp.room = room
	print("  marker ", PopochiuMarkerFactory.new().create(mp))
	await _wait(1.0)
	EditorInterface.save_scene()
	await _wait(2.0)
	print("BOOT: done")
	get_tree().quit()
