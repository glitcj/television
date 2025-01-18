extends EventBase
class_name PortraitAnimationEvent

var animation: String
var portrait_name
var wait_for_animation: bool
var animation_player_pointer # PortraitPallet.AnimationPlayerPointer

func initialise(portrait_name_, animation_: String, wait_for_animation_: bool = false, animation_player_pointer_: int = 0) -> PortraitAnimationEvent:
	animation = animation_
	portrait_name = portrait_name_
	wait_for_animation = wait_for_animation_
	animation_player_pointer = animation_player_pointer_
	return self

func run():
	assert(portrait_name != null)
	assert(Variables.portraits[portrait_name] != null)
	var selected_portrait: Portrait = Variables.portraits[portrait_name]
	selected_portrait.play_portrait_animation(animation, animation_player_pointer)
	if wait_for_animation:
		var selected_animation_player: AnimationPlayer = selected_portrait.pallet.available_animation_players[animation_player_pointer]
		await selected_portrait.portrait_animation_finished
	else:
		pass
		
	_clean_up()

func _event_type():
	return "PortraitAnimationEvent"
