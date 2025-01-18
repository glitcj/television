extends EventBase
class_name UnpackEvent

var event: EventBase
var packed_variables: Array

func initialise(packed_variables_: Array, event_: EventBase) -> UnpackEvent:
	packed_variables = packed_variables_
	event = event_
	return self

func run():
	var unpacked_variables = []
	for v in packed_variables:
		if v is Variables.Retriever:
			unpacked_variables.append(v.get_variable())
		else:
			unpacked_variables.append(v)
	
	# var initialiser: Callable = event.initialise
	# initialiser.callv(unpacked_variables)
	event.initialise.callv(unpacked_variables)
	Queue.queue = [event] + Queue.queue
	_clean_up()

func _event_type():
	return "EventTemplate"
