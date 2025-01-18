extends Node2D

# TODO: Sub-scenes should extend Scene ? (and run in a canvas ?)
signal scene_finished_short

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_finished_short.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# scene_finished_short.emit()
	pass
