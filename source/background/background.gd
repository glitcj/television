extends Node2D
class_name Background

signal background_updated_short

# TODO: Add assertions to all constructors
func initialise(parameters: Dictionary):
	update_texture_keyframe("RESET", parameters["image"], Queue.scene_size[0], Queue.scene_size[1])
	
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: Add VainParameters class
func change_background(parameters: Dictionary):
	var image_
		# portrait_pallet["default"] = portrait_sprite_image_
	if "image" in parameters.keys():
		if "res://" in parameters["image"]:
			image_ = parameters["image"]
			# portrait_pallet["default"] = parameters["pallet"]
		elif "gen://" in parameters["image"]:
			var query = parameters["image"].split("/")[-1]
			image_ = Generator.new().generate_image(query)
			
			print("33333", image_)
			print(5566666, query)
			
	
	
	update_texture_keyframe("RESET", image_, Queue.scene_size[0], Queue.scene_size[1])
	reset()

# TODO: replace width, height with vector2
func update_texture_keyframe(animation_name: String = "RESET", resource: String = "null", width := 400, height := 400):
	
	# All animations must be stopped before modification
	$AnimationPlayer.stop()
	
	# Assuming you have an AnimationPlayer node named "AnimationPlayer"
	var anim_player = $AnimationPlayer

	# The path to the Sprite node in the animation tracks
	var sprite_path = "BackgroundNode/Background"

	# var new_texture = load(resource)
	var new_texture: Texture2D = Common.import_image_during_runtime(resource)
	
	# Access the animation
	var animation = anim_player.get_animation(animation_name)

	# Assuming you know the time of the keyframe, for example at 1.0 seconds
	# var keyframe_time = 1.0
	var keyframe_time = 0

	var track_index
	track_index = animation.find_track("%s:texture" % sprite_path, Animation.TYPE_VALUE)
	if track_index != -1:
		# Update the keyframe with the new texture
		animation.track_set_key_value(track_index, keyframe_time, new_texture)

	track_index = animation.find_track("%s:scale" % sprite_path, Animation.TYPE_VALUE)
	if track_index != -1:
		# Update the keyframe with the new texture
		animation.track_set_key_value(track_index, keyframe_time, Common.absolute_resize_scale(new_texture, width, height))

func reset():
	$AnimationPlayer.play("RESET")
