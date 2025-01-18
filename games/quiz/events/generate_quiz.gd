extends EventBase
class_name GenerateQuizEvent

func initialise(se: String) -> GenerateQuizEvent:
	return self

func run():
	print("Running Llama.c")
	generated_strings_buffer.append_array([Quiz.parsed_question_and_answers()])
	print(generated_strings_buffer)
