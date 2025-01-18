extends Node2D
class_name Portrait

var pallet_path: String = "res://source/portrait/pallet.template.tscn"
var pallet: PortraitPallet
var thread = Thread.new()

signal portrait_animation_finished

func initialise(pallet_path_: String):
	pallet_path = pallet_path_
	_update_pallet()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func _update_pallet():
	remove_child($Pallet)
	# TODO: This breaks animations, why ?
	# $Pallet.queue_free()
	pallet = load(pallet_path).instantiate()
	assert(pallet.name == "Pallet")
	add_child(pallet)
	

func play_portrait_animation(animation_name: String, animation_player_pointer: int = 0):
	Queue.log("Playing portrait animation: %s" % animation_name)
	var selected_animation_player: AnimationPlayer = pallet.available_animation_players[animation_player_pointer]
	assert(animation_name in selected_animation_player.get_animation_list())
	selected_animation_player.play(animation_name)
	
	await selected_animation_player.animation_finished
	portrait_animation_finished.emit()

func _on_animation_finished():
	portrait_animation_finished.emit()

# TODO: Add sliding animations with custom vertical positions
func reset():
	# TODO: Reset all available animation players
	pallet.default_animation_player.play("RESET")

func absolute_resize_scale(texture_: Texture2D, desired_width := 100, desired_height := 150) -> Vector2:
	# Calculate the scale factors
	var scale_x = float(desired_width) / texture_.get_width()
	var scale_y = float(desired_height) / texture_.get_height()
	
	return Vector2(scale_x, scale_y)


# TODO: Use this to load pallet animations pointed to by PortraitPallet
func _add_portrait_animation(source_scene_path: String, source_animation_name: String) -> void:
	remove_child($Pallet)
	var source_scene = load(source_scene_path).instantiate()
	add_child(source_scene)


# Note: This is used to assign Generator images to animations
# Example: change_texture_keyframe("RESET", pallet.faces[PortraitPallet.Emotion.Default])
func change_texture_keyframe(animation_name: String = "RESET", resource: String = "null"):
	# Assuming you have an AnimationPlayer node named "AnimationPlayer"
	var anim_player = $Pallet/AnimationPlayer

	# The path to the Sprite node in the animation tracks
	var sprite_path = "Pallet/GFX/Sprite2D"

	var new_texture: Texture2D = Common.import_image_during_runtime(resource)
	
	# Access the animation
	var animation = anim_player.get_animation(animation_name)

	# Assuming you know the time of the keyframe, for example at 1.0 seconds
	var keyframe_time = 0

	var track_index
	track_index = animation.find_track("%s:texture" % sprite_path, Animation.TYPE_VALUE)
	if track_index != -1:
		# Update the keyframe with the new texture
		animation.track_set_key_value(track_index, keyframe_time, new_texture)

	
	track_index = animation.find_track("%s:scale" % sprite_path, Animation.TYPE_VALUE)
	if track_index != -1:
		# Update the keyframe with the new texture
		animation.track_set_key_value(track_index, keyframe_time, absolute_resize_scale(new_texture, 300, 300))


func print_details():
	print("Z Index ", z_index)
	
