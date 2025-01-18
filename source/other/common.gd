extends Node
class_name Common


enum type { GENERATE_TEXT, GENERATE_STORY }
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


static func change_background_():
	print("show_background")

# TODO: Separate background to a different class Background
# TODO: This function enables RUNTIME IMPORTING of images, simply using load(.) does not work sometimes.
# Function to create a sprite from an image path with position and scale
static func change_background(image_path: String, x: float = 0, y: float = 0, scale: float = 1) -> Sprite2D:
	# Create a new Sprite node
	var sprite = Sprite2D.new()

	# Load the image texture
	var texture = ImageTexture.new()
	var image = Image.new()
	if image.load(image_path) == OK:
		# texture.create_from_image(image)
		sprite.texture = texture
		texture.set_image(image)
		print("Successfuly loaded: %s" % image_path)
	else:
		print("Failed to load image: " + image_path)
		return null
		
	# Set the scale of the sprite
	sprite.scale = Vector2(scale, scale)
	
	sprite.visible = true

	# Return the sprite node
	return sprite



static func import_image_during_runtime(image_path)->Texture2D:
	# Create a new Sprite node
	var sprite = Sprite2D.new()

	# Load the image texture
	var texture = ImageTexture.new()
	var image = Image.new()
	if image.load(image_path) == OK:
		# texture.create_from_image(image)
		sprite.texture = texture
		texture.set_image(image)
		print("Successfuly loaded: %s" % image_path)
	else:
		print("Failed to load image: " + image_path)
		return null
		
	# Set the scale of the sprite
	# sprite.scale = Vector2(scale, scale)
	
	sprite.visible = true

	# Return the sprite node
	return sprite.texture



static func absolute_resize_scale(texture_: Texture2D, desired_width := 100, desired_height := 150) -> Vector2:
	# Calculate the scale factors
	var scale_x = float(desired_width) / texture_.get_width()
	var scale_y = float(desired_height) / texture_.get_height()
	
	return Vector2(scale_x, scale_y)


# この関数はサウンドを再生するためのAudioStreamPlayerノードを生成します
func play_se(parameters: Dictionary):
	# AudioStreamPlayerノードのインスタンスを作成
	var sound_player = AudioStreamPlayer.new()

	# 作成したノードをシーンに追加
	get_tree().add_child(sound_player)

	# サウンドファイルをロード
	var sound = load(parameters["se"])

	# サウンドをAudioStreamPlayerに設定
	sound_player.stream = sound

	# サウンドの再生
	sound_player.play()

	# サウンドの再生が終了したら、ノードを削除する
	sound_player.connect("finished", queue_free)
	# sound_player.connect("finished", sound_player, "queue_free")


func display_text(t: String):
	# AudioStreamPlayerノードのインスタンスを作成
	var label = Label.new()
	
	label.text = 0

	# 作成したノードをシーンに追加
	get_tree().add_child(label)
	label.font_size =  24
