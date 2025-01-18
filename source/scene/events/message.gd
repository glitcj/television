extends EventBase
class_name Message


var message_box: MessageBox
var message_box_settings: MessageBoxSettings
var message_box_template = preload("res://source/messages/message_box.tscn")
var messages: Array
var detached: bool

var messages_name: String

func initialise(messages_: Array, detached_: bool = false, messages_name_: String = "", message_box_settings_: MessageBoxSettings = MessageBoxSettings.new()) -> Message:
	messages = messages_
	detached = detached_
	messages_name = messages_name_
	message_box_settings = message_box_settings_
	return self

func run():
	message_box = message_box_template.instantiate()
	message_box.fill_queue(messages)

	# TODO: Add more settings
	# message_box.initialise(SceneSettings.message_box_position, null, false)
	# TODO: Move SceneSettings.message_box_position to MessageBoxSettings
	message_box.initialise(SceneSettings.message_box_position, null, false, message_box_settings)
	message_box.detached = detached
	
	if detached:
		assert(messages_name != "")
		Variables.messages[messages_name] = message_box
		get_parent().add_child(Variables.messages[messages_name])
		_clean_up()
	else:
		add_child(message_box)
		# Note: Delete message_box, but not the event node, in case JumpToLabel is called
		message_box.connect("all_messages_shown_signal", message_box.queue_free)
		# Clean up
		message_box.connect("all_messages_shown_signal", _clean_up)

func _event_type():
	return "MessageEvent"
