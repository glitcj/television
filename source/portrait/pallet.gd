extends Node
class_name PortraitPallet

enum Emotion {Default, Happy, Sad}
enum Animations {Default, Happy, Sad, SlideIn, SlideOut, Enter, Exit}
enum AnimationPlayerPointer {A, B}

var available_animation_players

var default_face: String = "res://assets/images/default.png"
var faces: Dictionary

var default_sound: String = "res://assets/se/laugh.wav"
var sounds: Dictionary

var default_animation: String = "res://source/portrait/animation.template.tscn"

@onready var default_animation_player = get_node("AnimationPlayerA")
@onready var default_sprite = get_node("GFX/Sprite2D")

# TODO: Add pointers to Animations/Players
func _init():
	faces = {Emotion.Default: default_face, Emotion.Happy: default_face, Emotion.Sad: default_face}
	sounds = {Emotion.Default: default_sound, Emotion.Happy: default_sound, Emotion.Sad: default_sound}

func _ready():
	available_animation_players = {AnimationPlayerPointer.A: $AnimationPlayerA, AnimationPlayerPointer.B: $AnimationPlayerB}

# TODO: Add asserts to check AnimationPlayer has all needed animations
func _check_animations():
	assert(true)

# TODO: Deprecate
# TODO: Add export to make  this more mutable across games
static func enum_to_animation(animation_enum: int):
	var enum_to_animation_: Dictionary = {}
	enum_to_animation_[Animations.Default] = "Default"
	enum_to_animation_[Animations.Happy] = "Happy"
	enum_to_animation_[Animations.Sad] = "Sad"
	enum_to_animation_[Animations.SlideIn] = "SlideIn"
	enum_to_animation_[Animations.SlideOut] = "SlideOut"
	enum_to_animation_[Animations.Enter] = "Enter"
	enum_to_animation_[Animations.Exit] = "Exit"
	return enum_to_animation_[animation_enum]

# TODO: Implement keep_ratio option
func absolute_rescale(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var scale_x = float(desired_width) / $GFX/Sprite2D.texture.get_width()
	var scale_y = float(desired_height) / $GFX/Sprite2D.texture.get_height()
	if keep_ratio:
		pass
	
	# Absolute scale is applied to GFX, not Sprite2D to enable relative 
	# animation in the Godot editor.
	$GFX.scale = Vector2(scale_x, scale_y)
	
