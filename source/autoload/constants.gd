extends Node


enum ScreenPosition {Middle, TopLeft, TopRight, BottomLeft, BottomRight, Top, Bottom, Left, Right}

var message_box_position = Vector2(0,0)
var scene_size = Vector2(288 * 2, 256 * 2)
var enable_message_box_character_se = false

# Z Index Reference
var z_index_hud = 100
var z_index_layer_1 = 10
var z_index_layer_2 = 20
var z_index_layer_3 = 30


class ScreenPositions:
	static var Middle = Vector2(0, 0)
	static var Left = Vector2(-192, 0)
	static var Right = Vector2(192, 0)
	static var Top = Vector2(0, -128)
	static var Bottom = Vector2(0, 128)
	static var TopLeft = Vector2(-192, -128)
	static var TopRight = Vector2(192, -128)
	static var BottomLeft = Vector2(-192, 128)
	static var BottomRight = Vector2(192, 128)

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_screen_positions()

func _set_screen_positions():
	"""
	ScreenPositions[ScreenPosition.Middle] = Vector2(0, 0)
	ScreenPositions[ScreenPosition.Left] = Vector2(-192, 0)
	ScreenPositions[ScreenPosition.Right] = Vector2(192, 0)
	ScreenPositions[ScreenPosition.Top] = Vector2(0, 128)
	ScreenPositions[ScreenPosition.Bottom] = Vector2(0, -128)
	ScreenPositions[ScreenPosition.TopLeft] = Vector2(-192, -128)
	ScreenPositions[ScreenPosition.TopRight] = Vector2(192, -128)
	ScreenPositions[ScreenPosition.BottomLeft] = Vector2(-192, 128)
	ScreenPositions[ScreenPosition.BottomRight] = Vector2(192, 128)
	"""
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func screen_position():
	return {ScreenPosition.Middle: Vector2(0, 0)}
