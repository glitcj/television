extends Node2D


# TODO: Add camera zoom in/out with up/down
# TODO: Add console as camera child

# Configs
var shape: int = 70
var cell_width: int = 8
var verbose: bool = false
var cell_count := 0

@onready var current_generation: Array = _initial_generation(shape)
@onready var generation_overlay: Array = _initial_generation(shape)


# Cells
var cell_template = preload("res://cell.tscn")
var cells_in_scene: Array[Node] = []

# Nodes
@onready var console: Label = get_node("./LabelNode2D/Label")
@onready var timer: Timer = get_node("./Timer")
@onready var camera: Camera2D = get_node("./LabelNode2D/Camera2D")
@onready var pointer: Node2D = get_node("./PointerNode2D/Pointer")

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.make_current()
	timer.start()


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
	
	return g

func _sum_array(A, B):
	var result = []
	for i in range(len(A)):
		var row = []
		for j in range(len(A[i])):
			row.append(A[i][j] + B[i][j])
		result.append(row)
	return result


func _generate_new_generation(g: Array):
	var new_generation: Array = g
	for x in range(shape):
		for y in range(shape):
			if g[x][y]:
				var displace_x: int = 1 - ((randf() < 0.5) as int) * 2
				var displace_y: int = 1 - ((randf() < 0.5) as int) * 2
				
				displace_x = 0 if x+displace_x >= shape else displace_x
				displace_y = 0 if y+displace_y >= shape else displace_y
					
					
				displace_x = 0 if displace_x < 0 else displace_x
				displace_y = 0 if displace_y < 0 else displace_y
				
				# TODO: This is overwriting previous writes ?
				new_generation[x+displace_x][y+displace_y] = randf() < 0.5 as int
				
				if verbose:
					print("%s %s \n%s" % [x+displace_x, y+displace_y, _get_grid_as_string(new_generation)])

	new_generation = _sum_array(new_generation, generation_overlay)
	return new_generation


func _update_cell_grid(g: Array):
	var c: Node2D
	for i in cells_in_scene.size():
		c = cells_in_scene.pop_back()
		c.queue_free()
	
	cell_count = 0
	for i in range(shape):
		for j in range(shape):
			if current_generation[i][j]:
				c = cell_template.instantiate()
				c.position = Vector2(i * cell_width, j * cell_width)
				cells_in_scene.append(c)
				add_child(c)
				
				cell_count = cell_count + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	console.text = "Console\n"
	console.text += "Timer: %.3f\nCount: %.0f" % [timer.time_left, cell_count]
		

func _on_timer_timeout():
	current_generation = _generate_new_generation(current_generation)
	_update_cell_grid(current_generation)


func _on_pointer_click():
	print("Clicked")
	generation_overlay[pointer.grid_position[0]][pointer.grid_position[1]] = 1


func _on_pointer_cancel():
	print("Cancelled")
	generation_overlay[pointer.grid_position[0]][pointer.grid_position[1]] = 0

