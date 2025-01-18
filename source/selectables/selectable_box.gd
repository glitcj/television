extends Node2D
class_name SelectableBox

signal option_selection_completed
signal selectable_is_ready

var message_box_template = preload("res://source/messages/message_box.tscn")
var message_box: MessageBox = message_box_template.instantiate()
var message_box_position: Vector2

# Life cycle: Base definitions > .initialise(.) > add_child() > "ready" signal > @onready > _ready()
var selectable: Selectable = Selectable.new()
var selectable_options: Array
var selectable_position: Vector2

# This should be called after instantiating/creating a node and before
# adding it to the scene. _ready() runs AFTER add_child(). This is called BEFORE add_child().
func initialise(message: String, options: Array) -> void:
	selectable_position = message_box_position + Vector2(-120, -10)
	_instantiate_message_box(message)
	selectable_options = options
	
func _instantiate_message_box(message: String):
	message_box.fill_queue([message])
	var _O_O: MessageBoxSettings = MessageBoxSettings.new()
	_O_O.is_autoplay = false
	message_box.initialise(message_box_position, null, false, _O_O)
	add_child(message_box)

# Called when the node enters the scene tree for the first time.
func _ready():
	await message_box.ready_to_allow_message_clear_signal
	_add_selectables()
	_update()

func _add_selectables():
	selectable.initialise(selectable_options, selectable_position)
	selectable.connect("ready", _on_selectable_is_ready)
	add_child(selectable)

func _on_selectable_is_ready():
	selectable_is_ready.emit()

func _update():
	pass # Handled by Selectable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
