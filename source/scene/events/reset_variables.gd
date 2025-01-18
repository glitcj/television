extends EventBase
class_name ResetVariablesEvent

func initialise() -> ResetVariablesEvent:
	return self

func run():
	Variables.clear()
	_clean_up()
	
func _event_type():
	return "ResetVariablesEvent"
