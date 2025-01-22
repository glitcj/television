extends Node2D
class_name MessageBox

# TODO: Replace .tscn with Portrait
signal all_messages_shown_signal
signal ready_to_allow_message_clear_signal

@onready var message_to_display := ""
@onready var message_displayed := ""
@onready var message = get_node("GFX/MessageNode/Message")
@onready var character_timer = get_node("CharacterTimer")

# TODO: Characters are drawn as a text object for each
# character, positions determines by message parameters
# and index of character.
class CharacterBlueprint:
	enum CharacterType {image, normal}
	var type = CharacterType.normal
	var colour = "white"
	var image_to_show = null
	var character_position: Vector2 = Vector2(0, 0)
	var text = ""
	var play_audio = true

# TODO: Change queue to message_queue
# Settables
var queue = []
var character_queue: Array = []
var characters_to_draw_queue: Array = []
var drawn_characters_queue: Array = []

var character_delta_x = Vector2(10, 0)
var character_delta_y = Vector2(0, 30)

# Add _ as a prefix to all non-settables
var allow_message_interruption := false
# var last_shown_message = null
var characters_shown_counter = 0
var character_pause_buffer = 5
var queue_was_filled = false
var is_interactive = true
var is_ready = false
var autoplay_ready_to_action = false

var borderless
var detached: bool = false
var autoplay: bool = false
var settings: MessageBoxSettings

# TODO: Add message box static vectors
static var top = Vector2(0, -150)

func initialise(position_, scale_, borderless_: bool = false, settings_: MessageBoxSettings = MessageBoxSettings.new()):
	if position_ != null:
		$GFX.position = position_
	if scale_ != null:
		$GFX.scale = scale_
	borderless = borderless_
	settings = settings_

func _ready():
	visible = false
	$CharacterTimer.start()
	is_ready = true
	show_next_message()

func _process(delta):
	_update()
	_process_inputs()


func _update():
	
	# SceneSettings override initialise settings
	if SceneSettings.message_box_is_visible:
		visible = not all_messages_shown()
	else:
		# TODO: Make sure this doesn't break anything else
		visible = false
	
	_process_autoplay_timer()

	$GFX/OuterBorders.visible = not borderless
	if all_messages_shown():
		all_messages_shown_signal.emit()
		queue_free()
		
	# Update displayed message
	if not current_message_is_fully_shown():
		# message.text = message_displayed
		pass
		
	#TODO: Add _emit_signals() to include long-signals
	if ready_to_allow_message_clear():
		ready_to_allow_message_clear_signal.emit()
		
func _process_inputs():
	if detached or not is_interactive:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		Queue.log("show_next_message()")
		show_next_message()

func _on_character_timer_timeout():
	_update_message_characters()

func _update_message_characters():
	message_displayed = message_to_display.substr(0, max(0, characters_shown_counter - character_pause_buffer))
	characters_shown_counter += 1
	if characters_to_draw_queue != []:
		_draw_next_character()
	
	# TODO: refactor
	if max(0, characters_shown_counter - character_pause_buffer) > 1 and characters_shown_counter < (message_to_display.length() + character_pause_buffer):
		if (characters_shown_counter - character_pause_buffer) % 3 == 0:
			$AudioStreamPlayer2D.play()

func show_next_message():
	if not allow_message_interruption and not ready_to_allow_message_clear():
		return
		
	_clean_up_drawn_characters()
	
	if messages_left_in_queue():
		message_to_display = queue.pop_front()
		characters_shown_counter = 0
		_parse_popped_message()
	else:
		print("No messages found in queue.")
		# TODO: Replace with typed null string value.
		message_to_display = ""
	
	# Reset character display counter
	characters_shown_counter = 0
	
	# Reset autoplay allowance
	autoplay_ready_to_action = false
	

func ready_to_allow_message_clear():
	return (characters_shown_counter > (message_to_display.length() + character_pause_buffer * 2)) or message_to_display == ""
	
func all_messages_shown():
	return queue_was_filled and queue.size() == 0 and message_to_display == ""

func messages_left_in_queue():
	return queue.size() > 0
	
func current_message_is_fully_shown():
	return message_displayed == message.text
	
func fill_queue(messages):
	queue.append_array(messages)
	queue_was_filled = true


# TODO: Add more message box functs and testers in the RunEverything game
func display_message_immediately(message_to_display: String):
	queue = [message_to_display]
	queue_was_filled = false
	show_next_message()



func _process_autoplay_timer():
	if settings.is_autoplay:
		autoplay_ready_to_action = true
		var wait_timer = get_tree().create_timer(settings.autoplay_wait_seconds)
		await wait_timer.timeout
		# wait_timer.queue_free()
		if autoplay_ready_to_action:
			show_next_message()

# Change this to uuided portrait, uuid is added to Variables	
# func _add_image_to_message_box(image_path_: String):
func _add_image_to_message_box(c: CharacterBlueprint):
	# Check if the image path is valid
	if ResourceLoader.exists(c.image_to_show):
		var sprite = Sprite2D.new()
		var texture = load(c.image_to_show)
		sprite.texture = texture
		add_child(sprite)
		sprite.position = Vector2(50, 50)
		
		sprite.position = $GFX.position + $GFX/MessageNode.position + c.character_position
		# sprite.position = sprite.position
		sprite.z_index = $GFX.z_index + 1
		
		return sprite
	else:
		print("Failed to find MessageBox image asset.")
		return Label.new()

func _parse_message_commands(): # message_: String):
	var processed_message = []
	for word in message_to_display.split(" "):
		if "#image" in word:
			var start_index = word.find("[")
			var end_index = word.find("]")
			if start_index != -1 and end_index != -1:
				var image_path = word.substr(start_index + 1, end_index - start_index - 1)
				_add_image_to_message_box(image_path)
		else:
			processed_message.append(word)
	message_to_display = " ".join(processed_message)

# TODO: Change the following to update character queue
func _parse_popped_message(): # message_: String):
	var processed_message = []
	var character_to_add: CharacterBlueprint
	var character_position = Vector2(0, 0)
	var line_counter = 0
	var i = 0
	var c = ""
	while true:
		if i >= len(message_to_display):
			break
			
		c = message_to_display[i]
		if c == "{":
			var start_index = i
			var end_index = message_to_display.substr(i).find("}")
			assert(start_index != -1 and end_index != -1)
			
			var embedded_command = message_to_display.substr(start_index + 1, end_index - 1)
			var embedded_command_parameters = embedded_command.split(",")

			if embedded_command_parameters[0] == "image":
				var image_path = embedded_command_parameters[1]
				character_to_add = CharacterBlueprint.new()
				character_to_add.image_to_show = image_path
				character_to_add.type = CharacterBlueprint.CharacterType.image
				character_to_add.character_position = character_position
				characters_to_draw_queue.append(character_to_add)

			elif embedded_command_parameters[0] == "newline":
				line_counter = line_counter + 1
				character_position = character_delta_y * line_counter
				
			i = i + end_index + 1
		else:
			character_to_add = CharacterBlueprint.new()
			character_to_add.type = CharacterBlueprint.CharacterType.normal
			character_to_add.character_position = character_position
			character_to_add.text = c
			characters_to_draw_queue.append(character_to_add)
			
			character_position = character_position + character_delta_x
			processed_message.append(c)
			i = i + 1

	message_to_display = "".join(processed_message)


func _draw_character(c: CharacterBlueprint):
	var character_position_correction = character_delta_x * 3 + Vector2(0, 5)
	var character_node
	
	if c.type == CharacterBlueprint.CharacterType.normal:
		character_node = Label.new()
		character_node.text = c.text
		character_node.position = $GFX.position + $GFX/MessageNode.position + c.character_position
		character_node.position = character_node.position + character_position_correction
		character_node.z_index = $GFX.z_index + 1
		if c.play_audio:
			$AudioStreamPlayer2D.play()
	elif c.type == CharacterBlueprint.CharacterType.image:
		character_node = _add_image_to_message_box(c)
	

	add_child(character_node)
	drawn_characters_queue.append(character_node)
	return character_node

func _draw_next_character():
	if characters_to_draw_queue != []:
		var character_blueprint = characters_to_draw_queue.pop_front()
		add_child(_draw_character(character_blueprint))
	
func _clean_up_drawn_characters():
	for c in drawn_characters_queue:
		remove_child(c)
		c.queue_free()
	for c in characters_to_draw_queue:
		remove_child(c)
		c.queue_free()
	drawn_characters_queue = []
	characters_to_draw_queue = []
	
