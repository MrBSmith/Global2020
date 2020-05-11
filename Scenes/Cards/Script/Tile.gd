extends Tile

class_name WalkableTile

# Why do we need overlap AND outside booleans:
# When the mouse enter the tile, the overlap will be set to true. When it exit it, it's set to false
# We need to make sure the boolean stays true if the the card is being dragged because the mouse moves faster than the tile
# But if the mouse exit the tile and drop the tile, the signal had already been sent with the grab to true, so the overlap bool won't be set to false
# So we need to check if the mouse is outside the tile so we can properly set the overlap variable to false
var grab : bool = false
var overlap : bool = false
var outside : bool = false

const blue = Color(0, 0, 1, 0.2)
const red = Color(1, 0, 0, 0.2)
const grey = Color(1, 1, 1, 0.2)
const white = Color(1, 1, 1, 1)

var current_color : Color = white setget set_color

func set_color(color: Color):
	current_color = color
	$TileColor.set_frame_color(color)

# ---- READY ----

signal tile_grabed
signal tile_droped

func _ready():
	choose_sprite()
	
	var _err = connect("body_entered", self, "on_body_entered")
	
	if owner != null:
		_err = connect("tile_grabed", owner, "on_tile_grabed")
		_err = connect("tile_droped", owner, "on_tile_droped")


# Chose one of the 3 tiles randomly
func choose_sprite():
	var sprites_array = $Sprites.get_children()
	var nb_sprites = len(sprites_array)
	var tile_rng : int = randi() % nb_sprites
	
	for sprite in sprites_array:
		if sprite.get_index() != tile_rng:
			sprite.queue_free()


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
	if !(owner is Card): # If the tile is a stadalone one
		if body is Player:
			body.set_speed(body.normal_speed)
		return
	
	if owner.get_state_name() != "Placed":
		return
	
	if body is Player: # If the tile is from a card
		if current_color == blue:
			body.set_speed(body.normal_speed / 2)
		elif current_color == grey:
			body.set_speed(body.normal_speed)
		elif current_color == red:
			body.set_speed(body.normal_speed * 2)


# Set every walls collsision to be active
func activate_walls():
	for child in get_children():
		if child.is_class("Wall"):
			child.get_node("CollisionShape2D").set_disabled(false)

