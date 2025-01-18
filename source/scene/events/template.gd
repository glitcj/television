extends EventBase
class_name EventTemplate

func initialise(se: String) -> EventTemplate:
	return self

func run():
	_clean_up()

func _event_type():
	return "EventTemplate"
