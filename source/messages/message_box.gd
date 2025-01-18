extends Node2D
class_name MessageBox

# TODO: Replace .tscn with Portrait
signal all_messages_shown_signal
signal ready_to_allow_message_clear_signal

@onready var message_to_display := ""
@onready var message_displayed := ""
@onready var message = get_node("GFX/MessageNode/Message")
@onready var character_timer = get_node("CharacterTimer")

# Settables
var queue = []

# Add _ as a prefix to all non-settables
var allow_message_interruption := false
var last_shown_message = null
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
		message.text = message_displayed
		
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
	
	# TODO: refactor
	if max(0, characters_shown_counter - character_pause_buffer) > 1 and characters_shown_counter < (message_to_display.length() + character_pause_buffer):
		if (characters_shown_counter - character_pause_buffer) % 3 == 0:
			$AudioStreamPlayer2D.play()

func show_next_message():
	if not allow_message_interruption and not ready_to_allow_message_clear():
		return
		
	if messages_left_in_queue():
		message_to_display = queue.pop_front()
		characters_shown_counter = 0
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
	
	
	# _clean_up()
