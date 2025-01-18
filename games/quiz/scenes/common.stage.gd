extends GDScript


static func add_contestant(contestant_tag, contestant_node, contestant_position):
	Queue.queue.append(Event.make_portrait().initialise(contestant_tag, contestant_node, contestant_position))
	Queue.queue.append(Event.play_portrait_animation().initialise(contestant_tag, "Enter", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(contestant_tag, "Idle"))
	
