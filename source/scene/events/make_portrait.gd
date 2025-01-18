extends EventBase
class_name MakePortraitEvent

var portrait_name
var portrait_pallet
var portrait_position

func initialise(portrait_name_, portrait_pallet_: String, portrait_position_: Vector2 = Vector2(0,0)) -> MakePortraitEvent:
	assert(typeof(portrait_name_) in [TYPE_NIL, TYPE_INT, TYPE_STRING])
	portrait_name = portrait_name_
	portrait_pallet = portrait_pallet_
	portrait_position = portrait_position_
	return self
	
func run():
	assert(portrait_name not in Variables.portraits.keys())
	var portrait: Portrait = Queue.portrait_template.instantiate()
	portrait.initialise(portrait_pallet)
	portrait.position = portrait.position + portrait_position
	
	Variables.portraits[portrait_name] = portrait
	get_parent().add_child(Variables.portraits[portrait_name])
	_clean_up()


func _event_type():
	return "MakePortraitEvent"
