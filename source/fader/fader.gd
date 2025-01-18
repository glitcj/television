extends Node2D
class_name Fader

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Default fader is faded out.
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fade_in():
	$AnimationPlayer.play("fade_in_1_sec")

func fade_out():
	$AnimationPlayer.play("fade_out_1_sec")

func reset():
	$AnimationPlayer.play("RESET")

