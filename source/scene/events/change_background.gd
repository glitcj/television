extends EventBase
class_name ChangeBackgroundEvent

var background: Background
var image_path

func initialise(image_path_: String) -> ChangeBackgroundEvent:
	image_path = image_path_
	return self

func run():
	if image_path == "":
		Queue.background.reset()
	else:
		Queue.background.change_background({"image": image_path})
	_clean_up()


func _event_type():
	return "ChangeBackgroundEvent"
