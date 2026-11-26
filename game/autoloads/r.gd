@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PRGalley := preload("res://game/rooms/galley/room_galley.gd")
# ---- classes

# nodes ----
var Galley: PRGalley : get = get_Galley
# ---- nodes

# functions ----
func get_Galley() -> PRGalley: return get_runtime_room("Galley")
# ---- functions

