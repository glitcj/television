extends Node2D

var selectable: Selectable = Selectable.new()
var selectable_position: Vector2 = Vector2(100, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_selectable()

func _add_selectable():
	selectable.initialise(["Start", "Continue"], selectable_position)
	add_child(selectable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
