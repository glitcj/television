extends GDScript

static func lambda_attach_monitor_to_animator():
	var monitor_animator: PortraitPallet = Variables.global["active_scenes"]["monitor_animator"]
	var monitor: MessageBox = Variables.messages["MONITOR"]
	
	monitor.get_parent().remove_child(monitor)
	monitor_animator.get_node("GFX/Sprite2D").add_child(monitor)
	
static func lambda_play_monitor_animation(animation_name: String = "Exclaim"):
	# TODO: Replace with signal sent to animator node
	Variables.global["active_scenes"]["monitor_animator"].get_node("AnimationPlayerA").play(animation_name)

	# TODO: This is probably not safe, double check threads/cycles
	Queue.insert(Event.wait().initialise(1))
	# Queue.queue = [Event.wait().initialise(1)] + Queue.queue
	# Queue.occupy_global_queue(Variables.global["active_scenes"]["monitor_animator"].get_node("AnimationPlayerA").animation_finished)
	
# TODO: Add background looping audience ambience
static func load_and_generate_assets(DEBUG, PRESENTER_INTRODUCTION):
	Queue.queue.append(Event.add_node().initialise("res://games/tv/loading/loading.tscn", [], "loading_screen"))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.make_portrait().initialise("loading", "res://games/tv/portraits/pallet.loading.tscn"))
	# TODO: Replace animation enums with strings
	Queue.queue.append(Event.play_portrait_animation().initialise("loading", "Default", false))
	Queue.queue.append(Event.fade_in().initialise(true))
	
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,-150]}))
	
	Queue.queue.append(Event.message_box().initialise(["...Loading Vain..."]))
	Queue.queue.append(Event.play_se().initialise("res://assets/se/laugh.wav"))
	
	# Generate buffers
	if not DEBUG:
		Queue.queue.append(Event.generate_vain().initialise("'Present a quiz game show with the contestants Abraham Linkin, Socrates, and Boris Johnson. Make it funny.'", PRESENTER_INTRODUCTION))
	Queue.queue.append(Event.wait().initialise(1))

	# Transition
	Queue.queue.append(Event.fade_out().initialise(true))
	Queue.queue.append(Event.remove_portrait().initialise("loading"))
	Queue.queue.append(Event.remove_node().initialise("loading_screen"))


static func lambda_update_monitor_messages(monitor_message: String):
	Variables.messages["MONITOR"].display_message_immediately(monitor_message)
	
static func setup_monitor():
	# WIP
	
	Queue.queue.append(Event.settings().initialise({"message_box_is_visible": false}))
	# Queue.queue.append(Event.settings().initialise({"message_box_is_autoplay": false}))
	
	var _O_O = MessageBoxSettings.new()
	_O_O.is_autoplay = false
	Queue.queue.append(Event.message_box().initialise(["   "], true, "MONITOR", _O_O))
	
	Queue.queue.append(Event.add_node().initialise("res://games/quiz/portraits/pallet.monitor.animator.tscn", [], "monitor_animator"))
	Queue.queue.append(Event.wait().initialise(1))
	if false:
		Queue.queue.append(Event.message_box().initialise(["Attaching Monitor"]))
	Queue.queue.append(Event.lambda().initialise(lambda_attach_monitor_to_animator, []))
	Queue.queue.append(Event.lambda().initialise(lambda_play_monitor_animation, ["RESET"]))
	
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.settings().initialise({"message_box_is_visible": true}))
	# Queue.queue.append(Event.settings().initialise({"message_box_is_autoplay": true}))
	
	
static func display_question_and_options(Presenter, question_: String, options_: Array):
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.selectable_box().initialise(question_, options_))
	
	var correct_answer_events = [
		Event.play_portrait_animation().initialise(Presenter, "Happy", true),
		Event.lambda().initialise(lambda_play_monitor_animation, ["Exclaim"]),
		Event.message_box().initialise(["That's correct !"]),
		Event.play_portrait_animation().initialise(Presenter, "ResetIdleFrame", false),
		# Event.play_portrait_animation().initialise(Presenter, "Idle", false)
		]
	var wrong_answer_events = [Event.message_box().initialise(["Aww that was a missed chance.", "Better luck next time."])]
	Queue.queue.append(Event.conditional().initialise([Variables.Retriever.new("last_selected_selectable_index"), 1], ConditionalEventQueue.Lambdas.equals, correct_answer_events))
	Queue.queue.append(Event.conditional().initialise([Variables.Retriever.new("last_selected_selectable_index"), 1], ConditionalEventQueue.Lambdas.not_equals, wrong_answer_events))

	var erase_monitor_message = func(a):
		Variables.messages["MONITOR"].queue_free()
		Variables.messages.erase("MONITOR")
	Queue.queue.append(Event.lambda().initialise(erase_monitor_message, []))
