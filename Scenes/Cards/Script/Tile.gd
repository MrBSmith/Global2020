extends Area2D
class_name Tile
const CLASS : String = "Tile"

signal tile_grabed
signal tile_droped
signal player_exited

var parent

var grab : bool
var has_parent : bool
var overlap : bool
var outside : bool

const blue = Color(0, 0, 1, 0.2)
const red = Color(1, 0, 0, 0.2)
const grey = Color(1, 1, 1, 0.2)
const white = Color(1, 1, 1, 1)

var current_color : Color = white setget set_color

func is_class(value: String) -> bool:
	return value == CLASS

func get_class() -> String:
	return CLASS


func set_color(color: Color):
	current_color = color
	$TileColor.set_frame_color(color)

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
	
	var _err = connect("body_entered", self, "on_body_entered")
	_err = connect("body_exited", self, "on_body_exited")
	
	if owner != null:
		_err = connect("tile_grabed", owner, "on_tile_grabed")
		_err = connect("tile_droped", owner, "on_tile_droped")
		_err = connect("player_exited", owner, "on_tile_player_exited")


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


func _unhandled_input(_event : InputEvent):
	if overlap:
		# Drag
		if Input.is_action_just_pressed("grab"):
			grab = true
			emit_signal("tile_grabed")
			get_tree().set_input_as_handled()
		
		# Drop
		elif Input.is_action_just_released("grab"):
			grab = false
			emit_signal("tile_droped")
			# If the mouse is outside the sprite, set the overlap to false
			if outside:
				overlap = false



# Adapt the player speed to the color of the tile
func on_body_entered(body: PhysicsBody2D):
	if owner is Card && !owner.card_placed:
		return
	
	if !(owner is Card): # If the tile is a stadalone one
		if body is Player:
			body.set_speed(body.medium_speed)
	
	if body is Player: # If the tile is from a card
		if current_color == blue:
			body.set_speed(body.slow_speed)
		elif current_color == grey:
			body.set_speed(body.medium_speed)
		elif current_color == red:
			body.set_speed(body.fast_speed)


func on_body_exited(body: PhysicsBody2D):
	if body is Player:
		emit_signal("player_exited", self)


# Set every walls collsision to be active
func activate_walls():
	for child in get_children():
		if child.is_class("Wall"):
			child.get_node("CollisionShape2D").set_disabled(false)

