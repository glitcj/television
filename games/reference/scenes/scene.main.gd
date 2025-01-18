extends EventQueue

var load_sprited_scene = false
var enable_tv_loop = true
# TODO: Add animated curtain faders (in the near future pixelated faders)
# TODO: Add SEs of crowd and maybe comic [Done] 
# TODO: Add flags to create this VAIN with conditions [Done]
# TODO: Change to Portrait class
# TODO: Change extension to .sc

func initialise_global_queue():	
	if load_sprited_scene:
		pass
	else:
		fully_generated_standup()

# TODO: Add background looping audience ambience
func load_and_generate_assets():
	Queue.queue.append(Event.add_node().initialise("res://games/tv/loading/loading.tscn", [], "loading_screen"))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.make_portrait().initialise("loading", "res://games/tv/portraits/pallet.loading.tscn"))
	
	# TODO: Replace animation enums with strings
	Queue.queue.append(Event.play_portrait_animation().initialise("loading", "Default", false))
	Queue.queue.append(Event.fade_in().initialise(true))
	
	Queue.add(Event.message_box().initialise(["Event: Set message box position."]))
	Queue.queue.append(Event.settings().initialise({"message_box_position": [50,150]}))
	Queue.queue.append(Event.message_box().initialise(["Starting", "Right now"]))
	Queue.queue.append(Event.play_se().initialise("res://assets/se/laugh.wav"))
	

	Queue.add(Event.message_box().initialise(["Event: Label"]))
	Queue.queue.append(Event.label().initialise("LABEL_A"))
	Queue.add(Event.message_box().initialise(["Event: Add Portrait"]))
	Queue.queue.append(Event.make_portrait().initialise("presenter", "res://games/standup/assets/portraits/pallet.presenter.tscn"))
	Queue.add(Event.message_box().initialise(["Event: Wait"]))
	Queue.queue.append(Event.wait().initialise(1))
	
	Queue.add(Event.message_box().initialise(["Event: Play portrait animation (Sub)"]))
	Queue.queue.append(Event.play_portrait_animation().initialise("presenter", "Default", false, PortraitPallet.AnimationPlayerPointer.B))
	Queue.add(Event.message_box().initialise(["Event: Play portrait animation (Main)"]))
	Queue.queue.append(Event.play_portrait_animation().initialise("presenter", "SlideIn", true))
	Queue.queue.append(Event.play_portrait_animation().initialise("presenter", "Default", false))

	Queue.add(Event.message_box().initialise(["Event: Play SE"]))
	Queue.queue.append(Event.play_se().initialise("res://assets/se/laugh.wav"))
	Queue.queue.append(Event.play_portrait_animation().initialise("presenter", "SlideOut", true))
	
	if false:
		# Generate buffers
		Queue.add(Event.message_box().initialise(["Event: Generate Vain"]))
		Queue.queue.append(Event.generate_vain().initialise("'Do a stand up comedy about the game Dark Souls.'", "standup"))
		Queue.add(Event.message_box().initialise(["Event: Generate Image"]))
		Queue.queue.append(Event.generate_image().initialise("standup stage with a funny white host wearing sunglasses introducing the show", "presenter_background"))
		Queue.add(Event.message_box().initialise(["Event: Generate Image"]))
		Queue.queue.append(Event.generate_image().initialise("standup stage with george carlin in the middle roasting the video game Dark Souls", "comedian_background"))
	Queue.queue.append(Event.message_box().initialise(["Starting", "Right now"]))
	
	# Transition
	Queue.add(Event.message_box().initialise(["Event: Fade Out"]))
	Queue.queue.append(Event.fade_out().initialise(true))
	Queue.add(Event.message_box().initialise(["Event: Remove Portrait"]))
	Queue.queue.append(Event.remove_portrait().initialise("loading"))
	Queue.add(Event.message_box().initialise(["Event: Remove Node"]))
	Queue.queue.append(Event.remove_node().initialise("loading_screen"))
	
	
# TODO: Export queue definitions to Godot engine
# TODO: Add jump_to_label event to enable infinite tv loop 
func fully_generated_standup():
	Queue.queue.append(Event.label().initialise("Start Loading Scene"))
	load_and_generate_assets()

	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.change_background().initialise("res://assets/images/presenter_background.png"))
	Queue.queue.append(Event.fade_in().initialise(true))
	Queue.queue.append(Event.wait().initialise(1.5))
	
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.message_box().initialise(["Ladies and gentlemen.", "Welcome to the stand-up show !", "Let us welcome our stand up for today..", "Give it up for George Carlin !!!"]))
	
	# TODO: Enable portrait animation in a separate cpu thread
	Queue.queue.append(Event.wait().initialise(1.5))
	
	# Transition backgrounds
	Queue.queue.append(Event.fade_out().initialise(true))
	Queue.queue.append(Event.change_background().initialise("res://assets/images/comedian_background.png"))
	Queue.queue.append(Event.fade_in().initialise(true))
	
	# Play out comedy routine
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.play_event_queue().initialise("standup"))
	
	# End standup episode
	Queue.queue.append(Event.wait().initialise(1))
	Queue.queue.append(Event.fade_out().initialise(true))
	Queue.queue.append(Event.change_background().initialise("res://assets/images/Empty.png"))
	
	if enable_tv_loop:
		Queue.queue.append(Event.reset_variables().initialise())
		Queue.queue.append(Event.jump_to_label().initialise("Start Loading Scene"))
	else:
		Queue.queue.append(Event.quit_game().initialise())
