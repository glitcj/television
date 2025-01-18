extends EventBase
class_name QuitGameEvent

func initialise() -> QuitGameEvent:
	return self

func run():
	get_tree().quit()
	_clean_up()

func _event_type():
	return "QuitGameEvent"
