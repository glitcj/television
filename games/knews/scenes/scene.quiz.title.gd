extends EventQueue

# Common tags/names
# TODO: Replace Variables strings/keys with ints, pulled from the enum Scene.Tags
var DEBUG = true
enum Tags {TitleSelectable, TitlePortrait}

var TitleSelectableOptions = ["Start", "Continue"] 
var SelectablePosition = Constants.ScreenPositions.Bottom + Vector2(-40, 0)
var TitlePallet = "res://games/quiz/portraits/title/pallet.quiz.title.tscn"

# TODO: Add background looping audience ambience
func load_and_generate_assets():
	Queue.queue.append(Event.add_node().initialise("res://games/tv/loading/loading.tscn", [], "loading_screen"))
	
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.make_portrait().initialise("loading", "res://games/tv/portraits/pallet.loading.tscn"))
	
	# TODO: Replace animation enums with strings
	Queue.queue.append(Event.play_portrait_animation().initialise("loading", "Default", false))
	Queue.queue.append(Event.fade_in().initialise(true))
	
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,-150]}))
	Queue.queue.append(Event.message_box().initialise(["...Loading Vain..."], true))
	Queue.queue.append(Event.play_se().initialise("res://assets/se/laugh.wav"))

func process_title_selectable_index(index: int):
	var _messages = ["Selected %s" % TitleSelectableOptions[Variables.CommonVariables.LastSelectableIndex]]
	Queue.queue = [Event.message_box().initialise(_messages)] + Queue.queue
	Queue.queue = [Event.change_scene().initialise("res://games/quiz/scenes/scene.quiz.introduction.gd")] + Queue.queue

func add_title_portraits():
	Queue.queue.append(Event.make_portrait().initialise(Tags.TitlePortrait, TitlePallet))
	Queue.queue.append(Event.play_portrait_animation().initialise(Tags.TitlePortrait, "Enter", true))

func initialise_global_queue():
	Queue.queue.append(Event.fade_in().initialise())
	add_title_portraits()

	# TODO: Add parameter to link options with functions ? Or just add a function takes in selected index.
	Queue.queue.append(Event.add_node().initialise(Templates.Selectable, [TitleSelectableOptions, SelectablePosition], Tags.TitleSelectable, "option_selection_completed"))
	Queue.queue.append(Event.remove_node().initialise(Tags.TitleSelectable))
	Queue.queue.append(Event.fade_out().initialise())
	Queue.queue.append(Event.remove_portrait().initialise(Tags.TitlePortrait))
	
	
	# Queue.queue.append(Event.message_box().initialise(["Options selected.", "Starting Quiz"]))
	Queue.queue.append(Event.lambda().initialise(process_title_selectable_index, [Variables.CommonVariables.LastSelectableIndex]))

func _comments_and_todos():
	# Sprite Order: # Background # Contestants 10 # Panels 20 # Hud 100
	pass
