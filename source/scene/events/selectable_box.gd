extends EventBase
class_name SelectableBoxEvent


# .new() makes object instances of .gd, class, or class_name
# .instantiate() makes object instances of .tscn ( or nodes ? )
var message: String
var selectable_box = SelectableBox.new()
var options: Array

func initialise(message_: String, options_: Array) -> SelectableBoxEvent:
	message = message_
	options = options_
	return self

func run():
	selectable_box.position = SceneSettings.message_box_position
	selectable_box.initialise(message, options)
	selectable_box.selectable.connect("option_selection_completed", selectable_box.queue_free)
	selectable_box.selectable.connect("option_selection_completed", _clean_up)
	get_parent().add_child(selectable_box)

func _event_type():
	return "SelectableBoxEvent"
