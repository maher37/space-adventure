@tool
extends RefCounted
# Second setup pass: positions, shapes, art and Dex's animations.
# Values are in game pixels on the 320x200 screen. The play area is y 0..150.

const ART := "res://game/art/"
const ROOM := "res://game/rooms/galley/room_galley.tscn"
const DEX := "res://game/characters/dex/character_dex.tscn"


static func rect_poly(w: float, h: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-w / 2, -h / 2), Vector2(w / 2, -h / 2), Vector2(w / 2, h / 2), Vector2(-w / 2, h / 2)
	])


static func run(plugin: EditorPlugin, wait: Callable) -> void:
	await _setup_dex()
	await _setup_items()
	await _setup_room(plugin, wait)


static func _setup_dex() -> void:
	var dex: Node2D = (load(DEX) as PackedScene).instantiate()
	var sprite: Sprite2D = dex.get_node("Sprite2D")
	sprite.texture = load(ART + "characters/dex/dex_sheet.png")
	sprite.hframes = 7
	sprite.vframes = 3
	sprite.centered = true
	sprite.offset = Vector2(0, -16)  # Feet sit on the character's position.
	dex.set("flips_when", 1)          # FlipsWhen.LOOKING_LEFT: reuse right-facing frames.
	dex.set("walk_speed", 60.0)
	dex.set("text_color", Color("ffd27a"))
	dex.set("dialog_pos", Vector2(0, -40))
	dex.set("description", "Dex")
	dex.set("interaction_polygon", PackedVector2Array([Vector2(-7, -32), Vector2(7, -32), Vector2(7, 0), Vector2(-7, 0)]))
	(dex.get_node("InteractionPolygon") as CollisionPolygon2D).polygon = dex.get("interaction_polygon")

	var player: AnimationPlayer = dex.get_node("AnimationPlayer")
	var lib := AnimationLibrary.new()
	var rows := {"r": 0, "d": 1, "u": 2}
	for dir: String in rows:
		var base: int = rows[dir] * 7
		lib.add_animation("idle_" + dir, _frames_anim([base], 1.0, true))
		lib.add_animation("walk_" + dir, _frames_anim([base + 1, base + 2, base + 3, base + 4], 0.14, true))
		lib.add_animation("talk_" + dir, _frames_anim([base + 5, base + 6], 0.15, true))
	if player.has_animation_library(""):
		player.remove_animation_library("")
	player.add_animation_library("", lib)
	_set_owner_recursive(dex, dex)
	_save(dex, DEX)


static func _frames_anim(frames: Array, step: float, loop: bool) -> Animation:
	var a := Animation.new()
	a.length = step * frames.size()
	a.loop_mode = Animation.LOOP_LINEAR if loop else Animation.LOOP_NONE
	var t := a.add_track(Animation.TYPE_VALUE)
	a.track_set_path(t, "Sprite2D:frame")
	a.value_track_set_update_mode(t, Animation.UPDATE_DISCRETE)
	for i in frames.size():
		a.track_insert_key(t, i * step, frames[i])
	return a


static func _setup_items() -> void:
	var items := {
		"space_nickel": ["Space nickel", "inventory/space_nickel.png"],
		"keycard": ["Keycard", "inventory/keycard.png"],
	}
	for id: String in items:
		var path := "res://game/inventory_items/%s/inventory_item_%s.tscn" % [id, id]
		var item: TextureRect = (load(path) as PackedScene).instantiate()
		item.texture = load(ART + items[id][1])
		item.set("description", items[id][0])
		_set_owner_recursive(item, item)
		_save(item, path)


static func _setup_room(plugin: EditorPlugin, wait: Callable) -> void:
	EditorInterface.open_scene_from_path(ROOM)
	await wait.call(2.0)
	var room: Node2D = EditorInterface.get_edited_scene_root()

	# An extra hotspot for the airlock door itself.
	if not room.has_node("Hotspots/AirlockDoor"):
		var hp := PopochiuHotspotFactory.PopochiuHotspotFactoryParam.new()
		hp.obj_name = "airlock_door"; hp.room = room; hp.is_interactive = true
		print("  hotspot airlock_door ", PopochiuHotspotFactory.new().create(hp))
		await wait.call(1.0)
		room = EditorInterface.get_edited_scene_root()

	# ---- Props -------------------------------------------------------------------------------
	var bg: Node2D = room.get_node("Props/Background")
	bg.position = Vector2(160, 100)
	bg.set("texture", load(ART + "rooms/galley/background.png"))
	bg.set("clickable", false)
	bg.set("baseline", -1000)
	bg.set("description", "")

	var vm: Node2D = room.get_node("Props/VendingMachine")
	vm.position = Vector2(113, 70)
	vm.set("texture", load(ART + "rooms/galley/vending_machine.png"))
	vm.set("interaction_polygon", rect_poly(34, 64))
	vm.set("baseline", 32)
	vm.set("walk_to_point", Vector2(4, 42))
	vm.set("look_at_point", Vector2(0, 0))
	vm.set("description", "Vending machine")

	var nickel: Node2D = room.get_node("Props/SpaceNickel")
	nickel.position = Vector2(196, 110)
	nickel.set("texture", load(ART + "rooms/galley/space_nickel.png"))
	nickel.set("interaction_polygon", rect_poly(12, 12))
	nickel.set("baseline", 0)
	nickel.set("walk_to_point", Vector2(-12, 2))
	nickel.set("description", "Space nickel")
	nickel.visible = false  # Appears once Dex searches the couch.

	# ---- Hotspots ----------------------------------------------------------------------------
	_hotspot(room, "BridgeDoor", Vector2(63, 62), rect_poly(66, 80), Vector2(0, 50), "Bridge door")
	_hotspot(room, "AirlockButton", Vector2(237, 66), rect_poly(28, 42), Vector2(0, 46), "Big red button")
	_hotspot(room, "AirlockDoor", Vector2(281, 60), rect_poly(62, 84), Vector2(-20, 52), "Airlock")
	_hotspot(room, "Couch", Vector2(175, 86), rect_poly(88, 32), Vector2(0, 26), "Couch")
	var circle := PackedVector2Array()
	for i in 12:
		circle.append(Vector2.from_angle(TAU * i / 12.0) * 26.0)
	_hotspot(room, "Window", Vector2(160, 40), circle, Vector2(0, 72), "Porthole")

	# ---- Walkable floor and start marker ------------------------------------------------------
	var floor: Node2D = room.get_node("WalkableAreas/Floor")
	floor.position = Vector2.ZERO
	var outline := PackedVector2Array([
		Vector2(6, 110), Vector2(314, 110), Vector2(318, 146), Vector2(2, 146)
	])
	var outlines: Array[PackedVector2Array] = [outline]
	floor.set("interaction_polygon", outlines)
	floor.set("interaction_polygon_position", Vector2.ZERO)
	var perimeter: NavigationRegion2D = floor.get_node("Perimeter")
	var nav := NavigationPolygon.new()
	nav.agent_radius = 0.0
	nav.add_outline(outline)
	perimeter.navigation_polygon = nav
	perimeter.position = Vector2.ZERO

	room.get_node("Markers/Start").position = Vector2(120, 128)

	EditorInterface.mark_scene_as_unsaved()
	EditorInterface.save_scene()
	await wait.call(2.0)


static func _hotspot(
	room: Node, node_name: String, pos: Vector2, poly: PackedVector2Array, walk_to: Vector2, text: String
) -> void:
	var h: Node2D = room.get_node("Hotspots/" + node_name)
	h.position = pos
	h.set("interaction_polygon", poly)
	h.set("walk_to_point", walk_to)
	h.set("description", text)


static func _set_owner_recursive(node: Node, owner: Node) -> void:
	for child in node.get_children():
		child.owner = owner
		_set_owner_recursive(child, owner)


static func _save(node: Node, path: String) -> void:
	var scene := PackedScene.new()
	scene.pack(node)
	scene.take_over_path(path)
	print("  saved ", path, " ", ResourceSaver.save(scene, path))
	node.free()
