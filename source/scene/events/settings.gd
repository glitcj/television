extends EventBase
class_name SettingsEvent

var settings_update: Dictionary

func initialise(settings_update_: Dictionary) -> SettingsEvent:
	settings_update = settings_update_
	return self


func _event_type():
	return "SettingsEvent"

func run():
	Queue.update_global_settings(settings_update)
	_clean_up()
