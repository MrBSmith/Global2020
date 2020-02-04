extends Area2D

var offset : Vector2
var grab : bool
var has_parent : bool
var overlap : bool

# ---- READY ----

func _ready():
	grab = false
	overlap = false
	has_parent = get_parent() is Card
	
# ---- INPUT ----

func _on_Tile_mouse_entered():
	print("overlap")
	overlap = true
	
func _on_Tile_mouse_exited():
	print("end overlap")
	if !grab:
		overlap = false


func _input(event):
	
	if overlap:
		if Input.is_action_just_pressed("grab"):
			if has_parent:
				offset = get_parent().get_global_position() - get_viewport().get_mouse_position()
			else:
				offset = get_global_position() - get_viewport().get_mouse_position()
			grab = true
		
		if Input.is_action_just_pressed("rotate_card_clock") && Input.is_action_pressed("grab"):
			if has_parent:
				get_parent().set_rotation_degrees(get_parent().get_rotation_degrees() + 90)
		
		if Input.is_action_just_pressed("rotate_card_anti_clock") && Input.is_action_pressed("grab"):
			if has_parent:
				get_parent().set_rotation_degrees(get_parent().get_rotation_degrees() - 90)
		
		if Input.is_action_just_released("grab"):
			grab = false
			overlap = false


# ---- FUNCTIONS ----


# function : deactivate_drag_collision
# parameters : None
# returns : None
# description : deactivate the collision used for the drag and drop

func deactivate_drag_collision():
	get_node("DragCollision").disabled = true
		

# ---- PROCESS ----

func _process(delta):
	if grab:
		if get_parent() is Card:
			get_parent().set_global_position(get_viewport().get_mouse_position() + offset)
		else:
			set_global_position(get_viewport().get_mouse_position() + offset)
