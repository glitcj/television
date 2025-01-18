extends Node2D
class_name Selectable

signal option_selection_completed

var absolute_index: int = 0
var currently_hovering: int = 0
var selected_option := 0
var ready_to_select: bool = false
var size_of_selectables = 11
var selectable_position =  Vector2(0, 0)
var attached: bool = true

# TODO: Use Containers + Layouts to place selectable portraits
# TODO: Add absolute scaling
var pallet_selectable_template = "res://source/selectables/portrait.selectable.template.tscn"

# TODO: Replace "selectable.gd" with normal portraits
@onready var portraits: Array = []
@onready var selectable_options: Array


# This should be called after instantiating/creating a node and before
# adding it to the scene. _ready() runs AFTER add_child(). This is called BEFORE add_child().
func initialise(options_: Array, position_: Vector2 = Vector2(0, 0)) -> void:
	selectable_options = options_
	position = position_
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_add_selectable_portraits()
	_update()


func _add_portrait():
	var portrait: Portrait = Queue.portrait_template.instantiate()
	portrait.initialise(pallet_selectable_template)
	portraits.append(portrait)
	return portrait
	

func _add_selectable_portraits():
	var i = 0
	for option in selectable_options:
		var portrait: Portrait = _add_portrait()
		portrait.position = selectable_position + Vector2(0, size_of_selectables*i*1.8)
		portrait.pallet.absolute_rescale(size_of_selectables, size_of_selectables)
		assert(portrait.pallet.has_method("set_description"))
		portrait.pallet.set_description(option)
		add_child(portrait)
		i += 1
	portraits[currently_hovering].play_portrait_animation("hovering")
	
	
func _update_inputs():
	var absolute_index_updated: bool = false
	if Input.is_action_just_pressed("ui_up"):
		absolute_index -= 1
		absolute_index_updated = true
	
	if Input.is_action_just_pressed("ui_down"):
		absolute_index += 1
		absolute_index_updated = true
		
	if Input.is_action_just_pressed("ui_accept"):
		_process_selection()
		
	if absolute_index_updated:
		_update()
	
func _update():
	portraits[currently_hovering].play_portrait_animation("hovering")
	portraits[currently_hovering].play_portrait_animation("default")
	currently_hovering = absolute_index % selectable_options.size()
	portraits[currently_hovering].play_portrait_animation("hovering")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attached:
		_update_inputs()

func _process_selection():
	selected_option = currently_hovering
	Variables.global["last_selected_selectable_index"] = selected_option
	Variables.CommonVariables.LastSelectableIndex = selected_option
	print("Selected option: ", selected_option)
	option_selection_completed.emit()
