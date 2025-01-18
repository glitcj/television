extends EventBase
class_name JumpToLabelEvent

var label_name: String

func initialise(label_name_: String) -> JumpToLabelEvent:
	label_name = label_name_
	return self

func run() -> void:
	for i in range(Queue.processed_queue.size()):
		var event: EventBase = Queue.processed_queue[i]
		print("Checking event: %s" % event._event_type())
		if event is LabelEvent and event.label_name == label_name:
			print("Found QueueLabel: %s" % event.label_name)
			var events_since_label = Queue.processed_queue.slice(i, Queue.processed_queue.size())
			
			Queue.queue = events_since_label + Queue.queue
			Queue.processed_queue = Queue.processed_queue.slice(0, i) if i > 0 else []
			
			break  # ラベルが見つかったらループを抜けます
	_clean_up()

func _event_type():
	return "JumpToLabelEvent"
