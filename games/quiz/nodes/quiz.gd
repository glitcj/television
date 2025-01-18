extends Node


class QuizGenerator:
	var generated_question
	var generated_answers
	var correct_answer_index

	# TODO: Refactor to skip Variables
	# Called when the node enters the scene tree for the first time.
	func _ready():
		pass # Replace with function body.

	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(delta):
		pass


	func parsed_question_and_answers():
		Variables.global["last_correct_answer_index"] = generate_question_and_answers()["correct_answer"]	
		var question_answers_message = generate_question_and_answers()["question"]

		return question_answers_message

	func generate_question_and_answers():
		Variables.global["quiz::generated_question"] = "Which animal is known for laughing \nlike a human when tickled?"
		Variables.global["quiz::generated_answers"] = ["Horse", "Kookaburra", "Rat", "Dolphin"]
		correct_answer_index = 2
		return {
		  "question": "Which animal is known for laughing like a human \nwhen tickled?",
		  "answers": ["Horse", "Kookaburra", "Rat", "Dolphin"],
		  "correct_answer": 2
		}
