@tool
extends "res://addons/popochiu/engine/interfaces/i_dialog.gd"

# classes ----
const PDVendingChat := preload("res://game/dialogs/vending_chat/dialog_vending_chat.gd")
# ---- classes

# nodes ----
var VendingChat: PDVendingChat : get = get_VendingChat
# ---- nodes

# functions ----
func get_VendingChat() -> PDVendingChat: return get_instance("VendingChat")
# ---- functions

