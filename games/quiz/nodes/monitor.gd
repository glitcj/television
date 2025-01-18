extends Node2D
class_name Monitor

var position_
var scale_
var borderless

func initialise(position_, scale_, borderless_):
	$MessageBox.initialise(position_, scale_, borderless_)

# Called when the node enters the scene tree for the first time.
func _ready():
	$MessageBox.is_interactive = false

func _process(delta):
	pass

func show_next_message():
	$MessageBox.show_next_message()

func fill_queue(m: Array):
	$MessageBox.fill_queue(m)
