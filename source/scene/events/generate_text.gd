extends EventBase
class_name GenerateText

var query
var text_name
var run_in_background
var thread = Thread.new()

func initialise(query_: String, text_name_: String, run_in_background_: bool = false) -> GenerateText:
	text_name = text_name_
	query = query_
	run_in_background = run_in_background_
	return self

func run():
	thread.start(_background_generate_text)
	if run_in_background:
		return
	Queue.occupy_global_queue(finished_running_event_short)

func _background_generate_text():
	_generate_text()
	call_deferred("_print_generated_text")
	
func _generate_text() -> void:
	Variables.global[text_name] = Generator.new().generate_text({"name": text_name, "query": query})

func _print_generated_text():
	print("Generated Text:")
	print(Variables.global[text_name])
	finished_running_event_short.emit()

func _event_type():
	return "GenerateText"
