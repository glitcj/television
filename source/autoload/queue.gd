extends Node

signal queue_is_available_again_short

# TODO: Add events to update global settings. 
# var message_box_position = Vector2(0,0)
# var message_box_is_visible = true
var scene_size = Vector2(288 * 2, 256 * 2)
var enable_message_box_character_se = false
# var current_active_scene

# TODO: Move the following to queue.gd
var cell_width := 8

# グローバルイベントを含める配列
var queue: Array = []

# 処理してしまったイベントはこの配列に移動される
var processed_queue: Array = []

var global_queue_is_busy: bool = false
var verbose := true
# var queue_is_waiting: bool = false

# Global scene components
var portraits: Dictionary = {}
var background: Background
var fader: Fader

# Templates
var message_box_template = preload("res://source/messages/message_box.tscn")
var monitor_template = preload("res://games/quiz/nodes/monitor.tscn")
var console_template = preload("res://source/console/console.tscn")
var portrait_template = preload("res://source/portrait/portrait.tscn")
var fader_template = preload("res://source/fader/fader.tscn") # Used to fade-in/fade-out/splash 
var background_template = preload("res://source/background/background.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	_initialise_global_nodes()
	# background = background_template.instantiate()

func _initialise_global_nodes():
	background = background_template.instantiate()
	fader = fader_template.instantiate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func occupy_global_queue(signal_to_wait_for: Signal):
	global_queue_is_busy = true
	await signal_to_wait_for
	global_queue_is_busy = false
	queue_is_available_again_short.emit()

func log(l: String):
	if verbose:
		print(l)
		
func update_global_settings(settings: Dictionary):
	for key in settings.keys():
		if key == "message_box_position":
			SceneSettings.message_box_position = Vector2(settings[key][0], settings[key][1])
		if key == "message_box_is_visible":
			SceneSettings.message_box_is_visible = settings[key]
		elif key == "message_box_character_se":
			enable_message_box_character_se = settings[key]

func print_queue():
	print("Event Queue:")
	var to_print = []
	for q in queue:
		to_print.append(q._event_type())
	print(" ".join(to_print))
	print("")
	
func print_processed_queue():
	print("Event Processed Queue:")
	var to_print = []
	for q in processed_queue:
		to_print.append(q._event_type())
	print(" ".join(to_print))
	print("")

func add(event: EventBase):
	queue.append(event)
	
func insert(event: EventBase, index: int = 0):
	# queue = [event] + queue
	queue.insert(index, event)
