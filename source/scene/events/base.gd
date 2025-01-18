extends Node2D
class_name EventBase

signal finished_running_event_short

var is_generated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Event is ready: %s" % _event_type())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: Freeing an event deletes all objects it creates, but not itself
func _event_free():
	pass

func _event_type() -> String:
	return "EventBase"

func run():
	pass

func run_and_emit_for_await():
	Queue.occupy_global_queue(finished_running_event_short)
	run()

# This should be called at some point in run()
# _clean_up() removes events from Scene and Queue, 
# but does not delete events. This is to enable event looping.
# Note: _clean_up() is overrided by JumpToLabel
func _clean_up():
	print("Cleaning up: %s" % _event_type())
	print("Event parent: ", get_parent())
	finished_running_event_short.emit()
	get_parent().remove_child(self)
