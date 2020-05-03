extends Area2D
class_name Tile
const CLASS : String = "Tile"

var parent

var grab : bool
var has_parent : bool
var overlap : bool
var outside : bool

func is_class(value: String) -> bool:
	return value == CLASS

func get_class() -> String:
	return CLASS

# ---- READY ----

func _ready():
	has_parent = false
	
	grab = false
	
	# why do we need overlap AND outside booleans:
	# when the mouse enter the tile, the overlap will be set to true. When it exit it, it's set to false
	# we need to make sure the boolean stays true if the the card is being dragged because the mouse moves faster than the tile
	# but if the mouse exit the tile and drop the tile, the signal had already been sent with the grab to true, so the overlap bool won't be set to false
	# So we need to check if the mouse is outside the tile so we can properly set the overlap variable to false
	overlap = false
	outside = false

	
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


func _input(_event):
	
	# Check if the mouse overlap the tile
	if overlap:
		# Drag
		if Input.is_action_just_pressed("grab"):
			if has_parent:
				grab = true
				parent.drag()
		
		# Drop
		elif Input.is_action_just_released("grab"):
			if has_parent:
				grab = false
				parent.drop()
				# If the mouse is outside the sprite, set the overlap to false
				if outside:
					overlap = false


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
