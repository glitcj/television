extends EventBase
class_name ChangeSceneEvent

var scene_path: String
var reset_all_variables: bool

func initialise(scene_path_: String, reset_all_variables_: bool = true) -> ChangeSceneEvent:
	scene_path = scene_path_
	reset_all_variables = reset_all_variables_
	return self

func run():
	var script: Script = load(scene_path)
	var event_queue: EventQueue = script.new()
	if reset_all_variables:
		Variables.reset()
	event_queue.initialise_global_queue()
	_clean_up()

func _event_type():
	return "ChangeSceneEvent"
