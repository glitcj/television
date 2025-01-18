extends Node2D
class_name Scene
# "Scene" is not defined as a an autoload script.

signal scene_completed_short

static var current_scene: String
static var last_scene: String

var message_box: MessageBox
var console: Console

# Concurrent nodes
var portraits: Dictionary # Array[Portrait]
var fader: Fader
var background: Background

# TODO: Move generated_strings_buffer to Llama global script
@onready var generated_strings_buffer: Array

# Load templates
var message_box_template = preload("res://source/messages/message_box.tscn")
var monitor_template = preload("res://games/quiz/nodes/monitor.tscn")
var console_template = preload("res://source/console/console.tscn")
var portrait_template = preload("res://source/portrait/portrait.tscn")

var thread: Thread = Thread.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	initialise_console()
	_load_global_nodes() # load global nodes
	initialise_global_queue()
	

func _load_global_nodes():
	# All VARIABLES here must be MUTABLE
	fader = Queue.fader # fader_template.instantiate()
	add_child(fader)
	
	background = Queue.background # background_template.instantiate()
	add_child(background)
	
	# TODO: Should the global nodes be stored in Queue ?
	add_child(console)
	
	portraits = Variables.portraits

# TODO: Move console text to Global ?
func _process(delta):
	_update_console()
	_process_inputs()
	_pop_global_queue()

func _process_inputs():
	pass

func _pop_global_queue():
	if Queue.global_queue_is_busy:
		return

	var global_queue_has_items = Queue.queue.size() > 0
	if global_queue_has_items:
		Queue.print_queue()
		Queue.print_processed_queue()
		
		var item: EventBase = Queue.queue.pop_front()
		
		if not item.is_generated:
			Queue.processed_queue.append(item)
		
		print("Popped event: %s" % item._event_type())
		if item is EventBase:
			add_child(item)
			item.run_and_emit_for_await()

func _update_console():
	console.text = "Console:\n"
	var m = message_box # get_node("MessageBox")
	if false and is_instance_valid(m) and m.is_inside_tree() && m.is_ready:
		console.text += "CharacterTimer: %.3f\n" % m.character_timer.time_left
		console.text += "all_messages_shown(): %s\n" % str(m.all_messages_shown())
		console.text += "messages_left_in_queue(): %s\n" % str(m.messages_left_in_queue())
		console.text += "current_message_is_fully_shown(): %s\n" % str(m.current_message_is_fully_shown())
		console.text += "Queue.global_queue_is_busy: %s\n" % str(Queue.global_queue_is_busy)
	else:
		console.text += "last_answer_selected_is_correct: %s\n" % Variables.global["last_answer_selected_is_correct"] as String
		console.text += "last_selected_selectable_index: %s\n" % Variables.global["last_selected_selectable_index"] as String
		console.text += "last_correct_answer_index: %s\n" % Variables.global["last_correct_answer_index"] as String

func initialise_console():
	console = console_template.instantiate()

func initialise_global_queue():
	# Scene queues are defined here.
	pass

# -------- DEBUGGER TO BE ADDED -------
## TODO: Add event to do this at runtime
# Function to repeat a string 'count' times
func repeat_string(str: String, count: int) -> String:
	var result = ""
	for i in range(count):
		result += str
	return result

# Function to print the scene tree with indentation
func print_scene_tree(node: Node, indent: int = 0):
	# Print the current node's name with indentation
	var indent_str = repeat_string("\t", indent)
	print(indent_str + node.name)

	# Recursively call this function for all children of the current node
	for child in node.get_children():
		print_scene_tree(child, indent + 1)  # Increase indentation for child nodes

# Example usage: call this function with the root of the scene tree
# print_scene_tree(get_tree().get_root())

# Call this function with the root of the scene tree
# print_scene_tree(get_tree().get_root())


# この関数はサウンドを再生するためのAudioStreamPlayerノードを生成します
func play_se(parameters: Dictionary):
	# AudioStreamPlayerノードのインスタンスを作成
	var sound_player = AudioStreamPlayer.new()

	# 作成したノードをシーンに追加
	add_child(sound_player)
	# get_tree().add_child(sound_player)

	# サウンドファイルをロード
	var sound = load(parameters["se"])

	# サウンドをAudioStreamPlayerに設定
	sound_player.stream = sound

	# サウンドの再生
	sound_player.play()

	# サウンドの再生が終了したら、ノードを削除する
	sound_player.connect("finished", sound_player.queue_free)
