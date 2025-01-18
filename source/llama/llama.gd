extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_story() -> Array:
	var os_output = []
	var exit_code = OS.execute("bash", ["get_story.sh"], os_output)
	var sentences := " ".join(os_output).replace('."', '"').split(".") as Array
	var foo = sentences.pop_back() # remove last empty string
	
	Queue.log("Generated Llama story:")
	Queue.log("\n".join(sentences))
	
	var processed_sentences = []
	for sentence in sentences:
		processed_sentences.append(prepare_senetence_for_message_box(sentence))
		
	return processed_sentences

func prepare_senetence_for_message_box(s: String):
	# Step 1: Remove initial space
	var trimmed_str = s.lstrip(" ")# .lstrip()
	
	# Step 2: Remove all '\n'
	trimmed_str = trimmed_str.replace("\n", "")
	trimmed_str = trimmed_str + "."
	
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
			if count >= 40:
				result += "\n" + word
				count = word.length()
			else:
				# Otherwise, just add the word.
				result += word
			if count == trimmed_str.length():
				print(word)
			word = ""  # Reset word for the next iteration
	
	return result
