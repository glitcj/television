extends Node2D


var grid_position := [0,0]
var cell_width: int = 8


signal pointer_click
signal pointer_cancel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_inputs()
	position = Vector2(grid_position[0] * Queue.cell_width, grid_position[1] * Queue.cell_width) 


func process_inputs():
	
	if Input.is_action_just_pressed("ui_down"):
		grid_position[1] += 1
	
	elif Input.is_action_just_pressed("ui_right"):
		grid_position[0] += 1
	
	elif Input.is_action_just_pressed("ui_left"):
		grid_position[0] -= 1
	
	elif Input.is_action_just_pressed("ui_up"):
		grid_position[1] -= 1

	elif Input.is_action_just_pressed("ui_accept"):
		pointer_click.emit()
		
	elif Input.is_action_just_pressed("ui_cancel"):
		pointer_cancel.emit()
