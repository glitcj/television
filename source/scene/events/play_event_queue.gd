extends EventBase
class_name PlayEventQueueEvent

var event_queue_name: String


# WIP: String typing removed
# func initialise(event_queue_name_: String) -> PlayEventQueueEvent:
func initialise(event_queue_name_) -> PlayEventQueueEvent:
	
	# TODO: Refactor type checks and remove global Variables
	if typeof(event_queue_name_) == typeof("String"):
		event_queue_name = event_queue_name_
	elif typeof(event_queue_name_) == typeof(0):
		event_queue_name = "event_queue_name_" + str(event_queue_name_)
		
	return self

func run():
	assert(event_queue_name in Variables.global["buffered_event_queues"].keys())
	Queue.queue = Variables.global["buffered_event_queues"][event_queue_name] + Queue.queue
	_clean_up()

func _event_type():
	return "PlayEventQueueEvent"
