extends EventBase
class_name QuizMonitorMessageEvent

func initialise(se: String) -> QuizMonitorMessageEvent:
	return self

func run():
	if is_instance_valid(quiz_monitor):
		quiz_monitor.queue_free()
		
	quiz_monitor = monitor_template.instantiate()
	quiz_monitor.initialise(Vector2(0, -230), Vector2(0.9, 0.9), true)

	quiz_monitor.fill_queue([Variables.global[item["parameters"]]])
	add_child(quiz_monitor)
