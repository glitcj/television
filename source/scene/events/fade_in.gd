extends EventBase
class_name FadeInEvent
var wait

func initialise(wait_:bool = true) -> FadeInEvent:
	wait = wait_
	return self

func run():
	Queue.fader.fade_in()
	await Queue.fader.animation_player.animation_finished
	_clean_up()
	
func _event_type():
	return "FadeInEvent"
