extends Area2D
class_name Tile

var parent

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
	has_parent = false
	overlap = false
	temp_mouse_pos = Vector2.ZERO
	outside = false
	is_rotating = false

	
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
				offset = parent.get_global_position() - temp_mouse_pos
				parent.tiles_hold_position(offset)
				parent.set_global_position(temp_mouse_pos)
				parent.get_node("Sprite").set_visible(true)
			else:
				offset = get_global_position() - get_viewport().get_mouse_position()
			grab = true
		
		# If the tile is held and the clockwise button is pressed
		elif Input.is_action_just_pressed("rotate_card_clock") && Input.is_action_pressed("grab"):
			if has_parent:
				if !is_rotating:
					is_rotating = true
					parent.set_rotation_degrees(parent.get_rotation_degrees() + 90)
		
		# If the tile is held and the anti clockwise button is pressed
		elif Input.is_action_just_pressed("rotate_card_anti_clock") && Input.is_action_pressed("grab"):
			if has_parent:
				if !is_rotating:
					is_rotating = true
					parent.set_rotation_degrees(parent.get_rotation_degrees() - 90)
		
		# To avoid wierd double input
		elif Input.is_action_just_released("rotate_card_clock") || Input.is_action_just_released("rotate_card_anti_clock"):
			is_rotating = false
		
		# Drop
		elif Input.is_action_just_released("grab"):
			grab = false
			offset = Vector2.ZERO
			# If the mouse is outside the sprite, set the overlap to false
			if outside:
				overlap = false
			if has_parent:
				parent.get_node("Sprite").set_visible(false)


# ---- FUNCTIONS ----

# function : set_parent
# parameters : node
# returns : None
# description : set the parent variable with the node in parameter

func init_parent(node):
	if node != null:	
		parent = node
		has_parent = true
	else:
		print("ERROR : parent node is null")
		has_parent = false

# ---- PROCESS ----

func _process(delta):
	if grab:
		if has_parent:
			if parent is Card:
				parent.set_global_position(get_viewport().get_mouse_position())
		else:
			set_global_position(get_viewport().get_mouse_position())
