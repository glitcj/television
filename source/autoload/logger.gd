extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func log(s: String, stream: String = "Global"):
	print("[%d][%s] %s" % [Engine.get_frames_drawn(), stream, s])
