@tool
extends "res://addons/popochiu/engine/interfaces/i_character.gd"

# classes ----
const PCDex := preload("res://game/characters/dex/character_dex.gd")
const PCSnackOTron := preload("res://game/characters/snack_o_tron/character_snack_o_tron.gd")
# ---- classes

# nodes ----
var Dex: PCDex : get = get_Dex
var SnackOTron: PCSnackOTron : get = get_SnackOTron
# ---- nodes

# functions ----
func get_Dex() -> PCDex: return get_runtime_character("Dex")
func get_SnackOTron() -> PCSnackOTron: return get_runtime_character("SnackOTron")
# ---- functions

