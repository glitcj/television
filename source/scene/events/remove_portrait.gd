extends EventBase
class_name RemovePortraitEvent

var portrait_name

func initialise(portrait_name_) -> RemovePortraitEvent:
	portrait_name = portrait_name_
	return self
	
func run():
	assert(portrait_name in Variables.portraits.keys())
	Variables.portraits[portrait_name].queue_free()
	Variables.portraits.erase(portrait_name)
	_clean_up()


func _event_type():
	return "RemovePortraitEvent"
