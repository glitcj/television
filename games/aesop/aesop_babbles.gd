extends Scene

func initialise_global_queue():
	Queue.queue.append({"type": "wait", "parameters": 1})
	Queue.queue.append({"type": "play_bust_animation", "parameters": "slide_in"})
	Queue.queue.append({"type": "wait", "parameters": 1.5})
	
	Queue.queue.append({"type": "message", "parameters": ["Hello guest.", "Welcome to the quiz show.", "Let us welcome our contestants.."]})
	Queue.queue.append({"type": "wait", "parameters": 1})
	
	# TODO: Play applause
	Queue.queue.append({"type": "change_emotion", "parameters": "happy"})
	Queue.queue.append({"type": "wait", "parameters": 1})
	Queue.queue.append({"type": "change_emotion", "parameters": "default"})
	Queue.queue.append({"type": "wait", "parameters": 1})
	Queue.queue.append({"type": "message", "parameters": ["Let's start with the first question", "Let me just remember how it goes again.."]})
	Queue.queue.append({"type": "wait", "parameters": 1})
	
	# TODO: Generate quiz with Llama
	# Queue.queue.append({"type": "run_llama", "parameters": ""})
	Queue.queue.append({"type": "generate_quiz", "parameters": ""})
	
	
	Queue.queue.append({"type": "message", "parameters": ["Aha. I remember now."]})
	Queue.queue.append({"type": "wait", "parameters": 1})
	
	# generated_strings_buffer is mutable and updated after being added to the queue
	# Queue.queue.append({"type": "message", "parameters": generated_strings_buffer})
	Queue.queue.append({"type": "quiz_monitor_message", "parameters": "quiz::generated_question"})
	
	Queue.queue.append({"type": "wait", "parameters": 2})
	Queue.queue.append({"type": "selectable_box", "parameters": {"message": "And your options are:", "options": "quiz::generated_answers"}})
	Queue.queue.append({"type": "wait", "parameters": 2})


	var events
	events = [{"type": "message", "parameters": ["You selected the correct answer !"]}]
	Queue.queue.append({"type": "conditional", "parameters": {"condition": "last_answer_selected_is_correct", "is": true, "events": events}})
	
	events = [{"type": "message", "parameters": ["You selected the wrong answer.."]}]
	Queue.queue.append({"type": "conditional", "parameters": {"condition": "last_answer_selected_is_correct", "is": false, "events": events}})
	
	Queue.queue.append({"type": "wait", "parameters": 1})
	Queue.queue.append({"type": "clear_quiz_monitor", "parameters": null})
	
	Queue.queue.append({"type": "wait", "parameters": 1})
	Queue.queue.append({"type": "message", "parameters": ["Please go to the next room.", "You will find Ditto there.", "He has a test for you."]})
	Queue.queue.append({"type": "wait", "parameters": 1})
	Queue.queue.append({"type": "play_bust_animation", "parameters": "slide_out"})
	Queue.queue.append({"type": "wait", "parameters": 1.5})
	Queue.queue.append({"type": "quit_game", "parameters": null})
	
	# for sentence in generated_strings_buffer:
	# 	Queue.queue.append({"type": "message", "parameters": [sentence]})
