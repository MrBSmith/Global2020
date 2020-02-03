extends Area2D

var offset : Vector2
var grab : bool


# ---- READY ----

func _ready():
	grab = false
	

# ---- INPUT ----

func _input(event):
	if Input.is_action_just_pressed("grab"):
		if get_parent() is Card:
			offset = get_parent().get_global_position() - get_viewport().get_mouse_position()
		else:
			offset = get_global_position() - get_viewport().get_mouse_position()
		grab = true
	if Input.is_action_just_released("grab"):
		grab = false


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
	
