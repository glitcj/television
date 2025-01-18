extends EventBase
class_name WaitEvent

var time

func initialise(time_: float) -> WaitEvent:
	time = time_
	return self

func run():
	print("Waiting for %.3f seconds." % time)
	if false:
		Queue.occupy_global_queue(get_tree().create_timer(time).timeout)
	else:
		var wait_timer = get_tree().create_timer(time)
		# Queue.occupy_global_queue()
		# wait_timer.connect("timeout", _clean_up())
		await wait_timer.timeout
		_clean_up()
		

func _event_type():
	return "WaitEvent"
