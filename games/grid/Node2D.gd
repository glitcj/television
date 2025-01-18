extends Node2D


# Configs
var shape: int = 10
@onready var current_generation: Array = _initial_generation(shape)

# Cells
var cell_template = preload("res://games/grid/cell.tscn")
var cells_in_scene: Array[Node] = []

# Nodes
@onready var console: Label = get_node("../Label")
@onready var timer: Timer = get_node("../Timer")
@onready var camera: Camera2D = get_node("../Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	camera.make_current()


func _get_grid_as_string(g: Array):
	var s: String = ""
	for r in g:
		s = s + " ".join(r) + "\n"
	return s


func _initial_generation(shape: int) -> Array:
	var g: Array = []
	for i in range(shape):
		g.append([])
		for j in range(shape):
			g[-1].append(0)
			
	g[0][0] = 1
			
	return g


func _generate_new_generation(g: Array):
	var new_generation: Array = g
	for x in range(shape):
		for y in range(shape):
			if g[x][y]:
				var displace_x: int = 1 - ((randf() < 0.5) as int) * 2
				var displace_y: int = 1 - ((randf() < 0.5) as int) * 2
				
				if abs(displace_x) >= shape:
					displace_x = 0
					
				if abs(displace_y) >= shape:
					displace_y = 0
					
				displace_x = 0 if displace_x < 0 else displace_x
				displace_y = 0 if displace_y < 0 else displace_y
					
				new_generation[x+displace_x][y+displace_y] = randf() < 0.5 as int
				
				print("%s %s \n%s" % [x+displace_x, y+displace_y, _get_grid_as_string(new_generation)])
				
	return new_generation


func _update_cell_grid(g: Array):
	
	for i in cells_in_scene.size():
		var c: Node2D = cells_in_scene.pop_back()
		c.queue_free()
		

	for i in range(shape):
		for j in range(shape):
			if current_generation[i][j]:
				var c: Node2D = cell_template.instantiate()
				c.position = Vector2(i*4, j*4)
				cells_in_scene.append(c)
				add_child(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	console.text = "Console\n"
	if Input. is_key_pressed(KEY_LEFT):
		console.text += "%s\n\n%s\n\nTime: %s" % [_get_grid_as_string(current_generation), str(cells_in_scene), str(timer.time_left)]
	elif Input. is_action_just_pressed("ui_right"):
		current_generation = _generate_new_generation(current_generation)
		_update_cell_grid(current_generation)
	else:
		pass
	
	if Input. is_key_pressed(KEY_RIGHT):
		# Add child
		pass
		
