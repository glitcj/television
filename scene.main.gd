extends Scene

# The option "Debug" redirects to CurrentlyDebugging
# var CurrentlyDebugging: String = "res://games/quiz/scenes/scene.quiz.title.gd"
var CurrentlyDebugging: String = "res://games/knews/scenes/scene.quiz.introduction.gd"

enum Tags {DebugGame, Knews, QuizShow, StandUp, Reference, MainSelectable}
var event_queue_names: Dictionary = {Tags.DebugGame: "Debug", Tags.Knews: "Knews.tv", Tags.QuizShow: "Quiz Show", Tags.StandUp: "StandUp", Tags.Reference: "Reference"}
var event_queue_options: Dictionary = {Tags.DebugGame: CurrentlyDebugging, Tags.QuizShow: "res://games/quiz/scenes/scene.quiz.title.gd", Tags.StandUp: "res://games/standup/scenes/scene.standup.gd", Tags.Reference: "res://games/reference/scenes/scene.main.gd"}
var scene_selectable_position = Constants.ScreenPositions.TopLeft

func initialise_global_queue():
	Queue.queue.append(Event.add_node().initialise(Templates.Selectable, [event_queue_names.values(), scene_selectable_position], Tags.MainSelectable, "option_selection_completed"))
	Queue.queue.append(Event.remove_node().initialise(Tags.MainSelectable))
	
	var message_per_option = []
	for m in event_queue_names.values():
		message_per_option.append(["Moving to:\n%s" % m])
	var packed_message = Variables.ArrayRetriever.new(message_per_option, "last_selected_selectable_index")
	Queue.queue.append(Event.unpack().initialise([packed_message], Event.message_box()))
	
	# TODO: Add class Variables.Pointer or Variables.Retriever as parent class to all retrievers
	var packed_event_queue: Variables.ArrayRetriever = Variables.ArrayRetriever.new(event_queue_options.values(), "last_selected_selectable_index")
	Queue.queue.append(Event.unpack().initialise([packed_event_queue], Event.change_scene()))
