extends CanvasLayer
# The death screen: Dex tumbles through space while a narrator mocks him.
# Built in code so restyling it later only means swapping art and the font.

signal try_again_pressed

const FONT := preload("res://game/gui/fonts/monkeyisland_1991.ttf")
const SPACE := preload("res://game/art/ui/death_space.png")
const DEX := preload("res://game/art/characters/dex/dex_sheet.png")

var title := ""
var joke := ""
var deaths := 0

var _dex: Sprite2D


func _ready() -> void:
	layer = 100
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)

	var bg := TextureRect.new()
	bg.texture = SPACE
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(bg)

	_dex = Sprite2D.new()
	_dex.texture = DEX
	_dex.hframes = 7
	_dex.vframes = 3
	_dex.frame = 7 + 5  # Front-facing, mouth open.
	_dex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_dex.position = Vector2(70, 60)
	root.add_child(_dex)

	var box := VBoxContainer.new()
	box.position = Vector2(20, 104)
	box.size = Vector2(280, 90)
	box.add_theme_constant_override("separation", 4)
	root.add_child(box)

	box.add_child(_label(title, 16, Color("ff5a5a")))
	box.add_child(_label(joke, 8, Color.WHITE))
	if deaths > 1:
		box.add_child(_label("Deaths this shift: %d" % deaths, 8, Color("ffd27a")))

	var button := Button.new()
	button.text = "  Try again  "
	button.add_theme_font_override("font", FONT)
	button.add_theme_font_size_override("font_size", 16)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.pressed.connect(func() -> void: try_again_pressed.emit())
	box.add_child(button)

	root.modulate = Color(1, 1, 1, 0)
	create_tween().tween_property(root, "modulate:a", 1.0, 0.6)


func _process(delta: float) -> void:
	_dex.rotation += delta * 2.0
	_dex.position += Vector2(14, -6) * delta


func _label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(280, 0)
	label.add_theme_font_override("font", FONT)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	return label
