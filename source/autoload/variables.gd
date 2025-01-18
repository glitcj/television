extends Node
""" This class is used to pass values by **reference**. """

# TODO: Add distinction between local (Scene) variables and global (Cross-Scene) variables

# TODO: Replace with -> int signal ?
var last_selected_selectable_index

var global: Dictionary
var portraits: Dictionary # Dictionary[Any: Portrait]
var messages: Dictionary # Dictionary[Any: MessageBox]

# WIP
var scene_nodes: Dictionary

enum KEY {GENERATED_TEXT, GENERATED_VAIN, GENERATED_IMAGE}

# TODO: Add class Buffer or Index which holds things like buffered_event_queues or buffered_event_queues.
# TODO: Or just stay with global buffers in Variables.index
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_last_answer_selected_is_correct()
	
func _update_last_answer_selected_is_correct():
	global["last_answer_selected_is_correct"] = global["last_correct_answer_index"] == global["last_selected_selectable_index"] 

func reset():
	global["foo"] = ["Foo"]
	global["last_answer_selected_is_correct"] = false
	global["last_correct_answer_index"] = 0
	global["last_selected_selectable_index"] = 0
	global["buffered_event_queues"] = {}
	global["active_scenes"] = {}
	global[KEY.GENERATED_TEXT] = {}
	portraits = {}
	messages = {}

# TODO: Replace sets with deletes to make sure nodes are deleted 
# and memory is cleared.
func clear():
	global["foo"] = ["Foo"]
	global["last_answer_selected_is_correct"] = false
	global["last_correct_answer_index"] = 0
	global["last_selected_selectable_index"] = 0
	global["buffered_event_queues"] = {}
	global["active_scenes"] = {}
	global[KEY.GENERATED_TEXT] = {}
	portraits = {}
	messages = {}

class CommonVariables:
	# Static variables are MUTABLE and can be passed dynamically during RUNTIME
	static var LastSelectableIndex: int = 0

class Retriever:
	var variable_name: String
	
	func _init(variable_name_: String):
		self.variable_name = variable_name_
		
	func get_variable():
		return Variables.global[variable_name]


class ArrayRetriever extends Retriever:
	var index_name: String
	var array: Array
	
	func _init(array_: Array, index_name_: String):
		self.index_name = index_name_
		self.array = array_
		
	func get_variable():
		return array[Variables.global[index_name]]
