extends EventBase
class_name LambdaEvent

var callable: Callable
var variables: Array

func initialise(callable_: Callable, variables_: Array) -> LambdaEvent:
	callable = callable_
	variables = variables_
	return self

func run():
	var unpacked_variables = []
	for v in variables:
		if v is Variables.Retriever:
			unpacked_variables.append(v.get_variable())
		else:
			unpacked_variables.append(v)
	callable.callv(unpacked_variables)
	_clean_up()

func _event_type():
	return "LambdaEvent"

func print_event():
	pass
