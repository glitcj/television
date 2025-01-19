extends EventBase
class_name ClearQuizMonitorEvent

func initialise(se: String) -> ClearQuizMonitorEvent:
	return self

func run():
	if is_instance_valid(quiz_monitor):
		quiz_monitor.queue_free()
