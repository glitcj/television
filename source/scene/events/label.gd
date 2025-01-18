extends EventBase
class_name LabelEvent

var label_name

func initialise(label_name_: String) -> LabelEvent:
	label_name = label_name_
	return self

func run():
	_clean_up()

func _event_type():
	return "LabelEvent"
