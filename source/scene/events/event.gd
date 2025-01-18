extends Node
class_name Event

# TODO: Add wait_for_chached_signal from Variables, e.g., to wait for background threads

static func play_se() -> PlaySE:
	return PlaySE.new()
	
static func message_box() -> Message:
	return Message.new()

static func make_portrait() -> MakePortraitEvent:
	return MakePortraitEvent.new()
	
static func remove_portrait() -> RemovePortraitEvent:
	return RemovePortraitEvent.new()

# Asynchronous generators
static func generate_image() -> GenerateImage:
	return GenerateImage.new()

static func generate_vain() -> GenerateVain:
	return GenerateVain.new()

static func generate_text() -> GenerateText:
	return GenerateText.new()

static func wait() -> WaitEvent:
	return WaitEvent.new()

static func change_background() -> ChangeBackgroundEvent:
	return ChangeBackgroundEvent.new()

static func fade_in() -> FadeInEvent:
	return FadeInEvent.new()

static func fade_out() -> FadeOutEvent:
	return FadeOutEvent.new()

static func play_portrait_animation() -> PortraitAnimationEvent:
	return PortraitAnimationEvent.new()

static func conditional() -> ConditionalEventQueue:
	return ConditionalEventQueue.new()

static func selectable_box() -> SelectableBoxEvent:
	return SelectableBoxEvent.new()

static func play_event_queue() -> PlayEventQueueEvent:
	return PlayEventQueueEvent.new()

static func add_node() -> AddNodeEvent:
	return AddNodeEvent.new()

static func remove_node() -> RemoveNodeEvent:
	return RemoveNodeEvent.new()

static func quit_game() -> QuitGameEvent:
	return QuitGameEvent.new()

static func settings() -> SettingsEvent:
	return SettingsEvent.new()

static func label() -> LabelEvent:
	return LabelEvent.new()

static func jump_to_label() -> JumpToLabelEvent:
	return JumpToLabelEvent.new()

static func reset_variables() -> ResetVariablesEvent:
	return ResetVariablesEvent.new()

static func lambda() -> LambdaEvent:
	return LambdaEvent.new()

static func change_scene() -> ChangeSceneEvent:
	return ChangeSceneEvent.new()

static func unpack() -> UnpackEvent:
	return UnpackEvent.new()
