extends EventBase
class_name FadeOutEvent

var wait: bool

func initialise(wait_: bool = true) -> FadeOutEvent:
	wait = wait_
	return self

func run():
	Queue.fader.fade_out()
	await Queue.fader.animation_player.animation_finished
	_clean_up()

func _event_type():
	return "FadeOutEvent"
