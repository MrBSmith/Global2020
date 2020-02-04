extends Area2D
class_name Tile

var offset : Vector2
var grab : bool
var has_parent : bool
var overlap : bool
var temp_mouse_pos : Vector2
var outside : bool
var is_rotating : bool

# ---- READY ----

func _ready():
	grab = false
	overlap = false
	temp_mouse_pos = Vector2.ZERO
	outside = false
	is_rotating = false
	has_parent = get_parent() is Card
	
# ---- INPUT ----

func _on_Tile_mouse_entered():
	# The mouse is not outside the tile
	outside = false
	# The mouse is overlapping the tile
	overlap = true
	
func _on_Tile_mouse_exited():
	# The mouse is outside the tile
	outside = true
	# If the tile is not held, the overlap boolean can be set to false. 
	# To make sure the imput still works if you are holding a tile but the mouse goes outside the tile because of its speed
	if !grab:
		overlap = false


func _input(event):
	
	# Check if the mouse overlap the tile
	if overlap:
		# Drag
		if Input.is_action_just_pressed("grab"):
			if has_parent:
				temp_mouse_pos = get_viewport().get_mouse_position()
				offset = get_parent().get_global_position() - temp_mouse_pos
				tiles_hold_position(offset)
				get_parent().set_global_position(temp_mouse_pos)
				get_parent().get_node("Sprite").set_visible(true)
			else:
				offset = get_global_position() - get_viewport().get_mouse_position()
			grab = true
		
		# If the tile is held and the clockwise button is pressed
		if Input.is_action_just_pressed("rotate_card_clock") && Input.is_action_pressed("grab"):
			if has_parent:
				if !is_rotating:
					is_rotating = true
					get_parent().set_rotation_degrees(get_parent().get_rotation_degrees() + 90)
		
		# If the tile is held and the anti clockwise button is pressed
		if Input.is_action_just_pressed("rotate_card_anti_clock") && Input.is_action_pressed("grab"):
			if has_parent:
				if !is_rotating:
					is_rotating = true
					get_parent().set_rotation_degrees(get_parent().get_rotation_degrees() - 90)
		
		# To avoid wierd double input
		if Input.is_action_just_released("rotate_card_clock") || Input.is_action_just_released("rotate_card_anti_clock"):
			is_rotating = false
		
		# Drop
		if Input.is_action_just_released("grab"):
			grab = false
			offset = Vector2.ZERO
			# If the mouse is outside the sprite, set the overlap to false
			if outside:
				overlap = false
			get_parent().get_node("Sprite").set_visible(false)

# ---- FUNCTIONS ----

# function : tiles_hold_position
# parameters : (Vector2)
# returns : None
# description : Apply an offset to all the tiles so they keep their position when moving the base node

func tiles_hold_position(point):
	for tile in get_parent().get_children():
		if tile is Area2D:
			tile.set_global_position(tile.get_global_position() + point)


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
			get_parent().set_global_position(get_viewport().get_mouse_position())
		else:
			set_global_position(get_viewport().get_mouse_position())
