@tool
extends "res://addons/popochiu/engine/interfaces/i_inventory.gd"

# classes ----
const PIISpaceNickel := preload("res://game/inventory_items/space_nickel/inventory_item_space_nickel.gd")
const PIIKeycard := preload("res://game/inventory_items/keycard/inventory_item_keycard.gd")
# ---- classes

# nodes ----
var SpaceNickel: PIISpaceNickel : get = get_SpaceNickel
var Keycard: PIIKeycard : get = get_Keycard
# ---- nodes

# functions ----
func get_SpaceNickel() -> PIISpaceNickel: return get_item_instance("SpaceNickel")
func get_Keycard() -> PIIKeycard: return get_item_instance("Keycard")
# ---- functions

