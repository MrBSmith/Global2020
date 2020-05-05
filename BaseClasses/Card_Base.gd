extends Node2D
class_name Card

signal slot_freed

# ---- VARIABLES ----

onready var wall_node = preload("res://Scenes/Wall/Wall.tscn")
onready var door_node = preload("res://Scenes/Wall/Door.tscn")

# how many doors the card can have, between the range
export(int) var min_door : int = 2
export(int) var max_door : int = 2

# chances to get a color
# To prevent a color from being chosen, set the color value to 0
export(int) var blue : int = 0
export(int) var grey : int = 100
export(int) var red : int = 0

onready var color_chance : Dictionary = {
	"blue" : blue,
	"grey" : grey,
	"red" : red
}

var card_placed : bool = false
var tiles_array : Array = []

var tiles_touched : int = 0

var rng = RandomNumberGenerator.new()

var remaining_doors
var remaining_walls

# -- drag & drop & rotate variables --

var offset_with_mouse := Vector2.ZERO
var grab : bool = false

# ---- ONREADY ----

func _ready():
	# Get every tiles of the card
	for child in get_children():
		if child.is_class("Tile"):
			tiles_array.append(child)

	rng.randomize()
	var door_count = rng.randi_range(min_door, max_door)

	# Check how many sides the card has to know how many walls it has
	var side_count = count_sides()
	var wall_count = side_count - door_count

	remaining_doors = door_count
	remaining_walls = wall_count

	# Place walls and doors
	place_all_walls()
	var color_name = pick_color()
	change_tiles_color(color_name)


# ---- PROCESS ----

func _process(_delta):
	if grab:
		set_global_position(get_viewport().get_mouse_position() - offset_with_mouse)


# ---- INPUT ----

func _input(_event):
	if grab:
		# If the card is grabbed and the clockwise button is pressed
		if Input.is_action_just_pressed("rotate_card_clock"):
			set_rotation_degrees(get_rotation_degrees() + 90)

		# If the tile is held and the anti clockwise button is pressed
		elif Input.is_action_just_pressed("rotate_card_anti_clock"):
			set_rotation_degrees(get_rotation_degrees() - 90)


# -- spawn walls functions --

# Count how many sides the card has and return it
func count_sides() -> int:
	var counter : int = 0

	# For each nodes in the given node
	for tile in tiles_array:
		for child in get_children():
			# if the current node is a point
			if child is PointTop or child is PointSide:
				counter += 1

	return counter


# Generate a number depending of the remaining sides, return true if it'll be a door
func generate_door() -> bool:
	# Get a random number between the remaining sides
	rng.randomize()
	var rand_wall = rng.randi_range(1, remaining_walls)

	# if rand_wall is below the number of remaining doors, that means we still have doors to place
	if remaining_doors >= rand_wall:
		# a door has been placed, so remove it from the remaining_doors count
		remaining_doors -= 1
		return true
	# either there is not enough door to put one, or the random chose to put a wall in this position
	else:
		# remove a wall from the count
		remaining_walls -= 1
		return false


# Check if the node has childs, if it's a spawn point, place a wall
func place_all_walls():
	for tile in tiles_array:
		for current_node in tile.get_children():
			if current_node is Position2D:
				var side
				# if it's a door
				if generate_door():
					side = door_node.instance()
				else:
					side = wall_node.instance()
				
				# Makes it horizontal if the point is a top one
				if current_node is PointTop:
					side.set_rotation_degrees(90)
				
				# Add the door/wall to rh 
				side.set_position(current_node.get_position())
				tile.add_child(side)


# Pick a random color depending of the color chance values
func pick_color():

	var total_chance = 0

	for chance in color_chance.values():
		total_chance += chance

	rng.randomize()
	var color_pick = rng.randi_range(1, total_chance - 1)
	var previous_scores = 0
	for color_key in color_chance:
		if previous_scores < color_pick && color_pick <= color_chance.get(color_key) + previous_scores:
			return color_key # color found
		else:
			previous_scores += color_chance.get(color_key) # color not found


# Changes the tiles color to the one sent in parameters
func change_tiles_color(color_name : String):
	for tile in tiles_array:
		tile.set_color(tile.get(color_name))


# -- drag & drop & rotate functions --

# Triggered by (and connected from) a child tile
# Compute the offset between the mouse position and the position of the card to move the card accordingly
func on_tile_grabed():
	if !card_placed:
		var mouse_pos = get_viewport().get_mouse_position()
		offset_with_mouse = mouse_pos - get_global_position()
		grab = true


# Triggered by (and connected from) a child tile
# Reset the offset at zero, and snap the card to the nearest position
# If the position isn't empty, reset its position in the hand of the player
func on_tile_droped():
	if !card_placed:
		grab = false
		offset_with_mouse = Vector2.ZERO
		var nearst_void_tile = get_the_nearest_tile(tiles_array[0])
		global_position += get_translation(tiles_array[0], nearst_void_tile)
	
		if is_card_on_empty_place():
			card_placed = true
			for tile in tiles_array:
				tile.activate_walls()
				var void_underneath = get_the_nearest_tile(tile)
				void_underneath.queue_free()

		else:
			set_position(Vector2.ZERO)
			set_rotation_degrees(0)


# Check if there is a void tile under each tiles of the card
# Return true if its the case, false in any other case
func is_card_on_empty_place() -> bool:
	for tile in tiles_array:
		var areas_overlapping = tile.get_overlapping_areas()
		if len(areas_overlapping) == 0:
			return false
		if !is_there_node_of_class(areas_overlapping, "VoidTile"):
			return false

	return true


# Return true if at least one of the nodes of the array is of the given class
func is_there_node_of_class(array : Array, class_to_find : String) -> bool:
	for node in array:
		if node.is_class(class_to_find):
			return true
	return false


# Find the nearest void tile, and returns it
func get_the_nearest_tile(node : Node) -> VoidTile:
	var node_pos = node.get_global_position()
	var void_tiles_array = get_tree().get_nodes_in_group("VoidTiles")
	var smallest_distance = INF
	var nearest_tile : VoidTile = null
	
	for void_tile in void_tiles_array:
		var current_distance = node_pos.distance_to(void_tile.get_global_position())
		if current_distance < smallest_distance:
			smallest_distance = current_distance
			nearest_tile = void_tile
	
	return nearest_tile


# Return the translation between two nodes
func get_translation(node1 : Node, node2 : Node) -> Vector2:
	var direction_to : Vector2 = node1.global_position.direction_to(node2.get_global_position())
	var distance_to : float =  node1.global_position.distance_to(node2.get_global_position())
	return direction_to * distance_to


# -- Players detections methods --

# Triggered when a player entered a tile composing the card
func on_tile_body_entered(body: PhysicsBody2D):
	if body is Player && card_placed:
		tiles_touched += 1 


# Triggered when a player live a tile composing the card
func on_tile_body_exited(body: PhysicsBody2D):
	if body is Player && card_placed:
		tiles_touched -= 1
		if tiles_touched == 0:
			destroy()


# -- Card destruction --

# Replace every tile of the card by a void_tile in the grid,
# Emit a signal to the hand, to signify that a slot has been freed, and tell which one
# Then queue free the card
func destroy():
	if SCENES.scene_transitioning:
		return
	
	for tile in tiles_array:
		var tile_pos = tile.get_global_position()
		var grid_node = get_tree().get_current_scene().find_node("Grid")
		var void_tile = grid_node.void_tile_scene.instance()
		void_tile.set_global_position(tile_pos)
		grid_node.call_deferred("add_child", void_tile)
	
	emit_signal("slot_freed", get_parent())
	queue_free()
