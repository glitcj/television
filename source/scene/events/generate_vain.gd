extends EventBase
class_name GenerateVain

var event_queue_name
var query
var run_in_background

# Use threads for heavy processes to avoid interrupting the main thread which handles animations etc.
var thread: Thread
var generator: Generator

signal finished_generating

# TODO: Generator is just another node attached to the main scene tree, not autoloaded.
func initialise(query_: String, event_queue_name_: String, run_in_background_: bool = false) -> GenerateVain:
	event_queue_name = event_queue_name_
	query = query_
	run_in_background = run_in_background_
	return self

func run():
	thread = Thread.new()
	generator = Generator.new()
	get_parent().add_child(generator)
	thread.start(_background_generate_vain)
	if not run_in_background:
		await finished_generating
	_clean_up()
	
func _background_generate_vain():
	print("Generating Vain: ", query)
	generator.generate_vain({"name": event_queue_name, "query": query})
	# Note: The signal finished_generating is emitted by this EventBase, and not Generator, because signals are not thread safe.
	call_deferred("_emit_finished_generating_signal")
		

func _emit_finished_generating_signal():
	# Note: Signals are NOT thread-safe, because Godot assumes
	# they are delivered in the main thread lifecycle.
	# Using call_deferred to deliver signals is a safer option.
	# This is because call_deferred defers signals to the main thread, and main lifecycle.
	# Thread processes should clean up automatically to avoid signal chaos.
	finished_generating.emit()


func _event_type():
	return "GenerateVain"
