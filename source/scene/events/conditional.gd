extends EventBase
class_name ConditionalEventQueue

var condition: String # Condition tag in Variables
var equals # Value to match
var events: Array
var else_events: Array
var variables: Array
var lambda: Callable

func initialise(variables_: Array, lambda_: Callable, events_: Array, else_events_: Array = []) -> ConditionalEventQueue:
	variables = variables_
	lambda = lambda_
	events = events_
	else_events = else_events_
	return self

func run():
	print("Checking condition: %s" % condition)
	
	var unpacked_variables = []
	for v in variables:
		if v is Variables.Retriever:
			unpacked_variables.append(v.get_variable())
		else:
			unpacked_variables.append(v)

	if lambda.call(unpacked_variables):
		for event in events:
			event.is_generated = true
		Queue.queue = events + Queue.queue
	else:
		for event in else_events:
			event.is_generated = true
		Queue.queue = else_events + Queue.queue
		
	_clean_up()

class Lambdas:
	static func equals(variables_: Array):
		assert(len(variables_) == 2)
		return variables_[0] == variables_[1]

	static func not_equals(variables_: Array):
		assert(len(variables_) == 2)
		return variables_[0] != variables_[1]
