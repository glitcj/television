extends EventBase
class_name GenerateImage

var query
var image_name
var run_in_background

# Use threads for heavy processes to avoid interrupting the main thread which handles animations etc.
var thread: Thread
var generator: Generator

signal finished_generating

func initialise(query_: String, image_name_: String, run_in_background_: bool = false) -> GenerateImage:
	query = query_
	image_name = image_name_
	run_in_background = run_in_background_
	return self

func run():
	thread = Thread.new()
	generator = Generator.new()
	get_parent().add_child(generator)
	# Use threads for heavy processes to avoid interrupting the main thread which handles animations etc.
	thread.start(_background_generate_image)
	if not run_in_background:
		await finished_generating
	_clean_up()




func _background_generate_image():
	print("Generating Image: ", query)
	generator.generate_image(query, image_name)
	# Note: The signal finished_generating is emitted by this Event, and not Generators, because signals are not thread safe.
	call_deferred("_emit_finished_generating_signal")
		

func _emit_finished_generating_signal():
	# Note: Signals are NOT thread-safe, because Godot assumes
	# they are delivered in the main thread lifecycle.
	# Using call_deferred to deliver signals is a safer option.
	# This is because call_deferred defers signals to the main thread, and main lifecycle.
	# Thread processes should clean up automatically to avoid signal chaos.
	finished_generating.emit()


func _event_type():
	return "GenerateImage"
