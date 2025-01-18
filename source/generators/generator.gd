extends Node
class_name Generator

# var generated_image_buffer: Sprite2D
# var generated_events_buffer: Dictionary = {}
var WORDS_PER_LINE = 40

# TODO: When generating text, the generator should never use "", 
# the role will replace "" with 「」
func generate_text(parameters: Dictionary, queue_free_after_completion: bool = true) -> Array:
	assert("query" in parameters.keys())
	var os_output = []
	var generator_role = ""
	var role = "You are George Carlin doing a standup comedy routine. Whenever you say one sentence, separate it with a new line character. Whenever you write a period, that's the end of a sentence. You can't have multiple sentences in one line. Try to keep your sentences to less than 20 words in general. Never use double quotes, replace them single quotes if you need to. Attach ### at the end of each sentence. When you think there is a punch line and the crowd should laugh, make a new line with only the characters 'HHH' and add a new line character at the end."
	var query = parameters["query"]
	var arguments = ['run_openai.py', '--query', query, '--role', role]
	var exit_code = OS.execute("python3", arguments, os_output, true)
	
	var sentences := " ".join(os_output).replace('."', '"').split("###") as Array
	var foo = sentences.pop_back() # remove last empty string
	
	Queue.log("Generated Llama story:")
	Queue.log("\n".join(sentences))
	
	var processed_sentences = []
	for sentence in sentences:
		processed_sentences.append(prepare_senetence_for_message_box(sentence))
		
	if queue_free_after_completion:
		queue_free()
		
	return processed_sentences

func prepare_senetence_for_message_box(s: String):
	# Step 1: Remove initial space
	var trimmed_str = s.lstrip(" ")# .lstrip()
	
	# Step 2: Remove all '\n'
	trimmed_str = trimmed_str.replace("\n", "")
	# trimmed_str = trimmed_str + "."
	
	# Step 3: Add new line characters '\n' every 20 characters
	var result = ""
	var count = 0
	var word = ""
	var whole_sentence_counter = 0
	for i in trimmed_str:
		word += i
		count += 1
		whole_sentence_counter += 1
		
		# Check if we're at a space or the end of the string
		if i == " " or whole_sentence_counter == trimmed_str.length():
			if count >= WORDS_PER_LINE:
				result += "\n" + word
				count = word.length()
			else:
				# Otherwise, just add the word.
				result += word
			if count == trimmed_str.length():
				print(word)
			word = ""  # Reset word for the next iteration
	
	return result
	
	
	
# TODO: When generating text, the generator should never use "", 
# the role will replace "" with 「」
# TODO: Sometimes fails, improve logging by adding a generator stream
func generate_image(query="pixelated 8-bit George Carlin full front body head to legs.", image_name = null) -> String:
	var os_output = []
	
	var arguments = ['generate_image_openai.py', '--query', query]
	var exit_code = OS.execute("python3", arguments, os_output, false)
	
	var image_path = "res://assets/images/%s" % os_output[0]
	image_path = remove_non_printable_chars(image_path)
	
	if image_path.split(".")[-1] != "png":
		image_path = "res://assets/images/pallet.png"

	print("full image path: %s" % image_path)
	# var image_path = "res://assets/images/image_24e74ee1-86ed-49a8-88c4-8ce9338984be.png"
	# TODO: Add exit_code check
	# generated_image_buffer = Events.change_background(image_path, 0, 0, 0.15)

	# If an image name is passed, cache the image
	if image_name != null:
		arguments = ["./assets/images/%s" % image_path.split("/")[-1], "./assets/images/%s.png" % image_name]
		exit_code = OS.execute("cp", arguments, os_output, false)
	
	# This runs in a thread so should clean up after itself
	queue_free()
		
	# generated_image_path_buffer
	return image_path
	
func remove_non_printable_chars(original_string: String) -> String:
	var clean_string = ""
	for i in range(original_string.length()):
		var char = original_string[i]
		# Check if the character is printable
		if char in '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ !"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~':
			clean_string += char
	return clean_string


# TODO: Add scene command "generate_vain"
func generate_vain(parameters: Dictionary) -> Array:
	var generated_text = generate_text(parameters, false)
	var generated_events: Array = []
	var event_type: String = "message" # TODO: Add enums to set event types instead of String
	
	# TODO: Add class Event
	var event
	generated_events.append(Event.wait().initialise(1))
	for text in generated_text:
		# Message queues should be completely handled by message or Global queue, not here.
		# TODO: Modify/Refactor Scene to handle sequences of "message"
		var message_queue = []
		
		if "HHH" in text:
			event_type = "play_se"
		else:
			event_type = "message"
		
		if event_type == "message":
			generated_events.append(Event.message_box().initialise([text]))
			
		elif event_type == "play_se":
			var random_index = randi() % 2 + 1
			generated_events.append(Event.wait().initialise(0.1))
			generated_events.append(Event.play_se().initialise("res://assets/se/laugh_%d.wav" % random_index))
			generated_events.append(Event.wait().initialise(0.1))
	generated_events.append(Event.wait().initialise(1))
	
	for e in generated_events:
		e.is_generated = true
	
	# generated_events_buffer[parameters["name"]]  = generated_events
	Variables.global["buffered_event_queues"][parameters["name"]]  = generated_events
	
	# This runs in a thread so should clean up after itself
	queue_free()

	return generated_events

func _clean_up():
	queue_free()
