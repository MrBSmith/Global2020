extends Node2D
class_name Card

# ---- VARIABLES ----

onready var hand_position = get_global_position()

var tiles_array : Array = []

var rng = RandomNumberGenerator.new()

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


var color_chance



# Number of sides the room has
var side_count := 0
# the number of door the room will have
var door_count := 0
# the number of walls the room will have
var wall_count := 0

var remaining_doors
var remaining_walls

# -- drag & drop & rotate variables --

var grab : bool
var offset : Vector2
var temp_mouse_pos : Vector2
var is_rotating : bool


# ---- ONREADY ----

func _ready():
	grab = false
	
	# Get every tiles of the card
	for child in get_children():
		if child.is_class("Tile"):
			tiles_array.append(child)
	
	send_parent_reference()
	
	rng.randomize()
	door_count = rng.randi_range(min_door, max_door)
	
	# Check how many sides the card has to know how many walls it has
	side_count = 0
	count_sides(get_node("."))
	wall_count = side_count - door_count
	
	remaining_doors = door_count
	remaining_walls = wall_count
	
	# Place walls and doors
	place_all_walls(get_node("."))
	
	color_chance = {
	"blue" : blue,
	"grey" : grey,
	"red" : red
	}
	change_color(pick_color())


# ---- PROCESS ----

func _process(_delta):
	if grab:
		set_global_position(get_viewport().get_mouse_position())


# ---- INPUT ----

func _input(_event):
	if grab:
		# If the card is grabbed and the clockwise button is pressed
		if Input.is_action_just_pressed("rotate_card_clock"):
			if !is_rotating:
				is_rotating = true
				set_rotation_degrees(get_rotation_degrees() + 90)
		
		# If the tile is held and the anti clockwise button is pressed
		elif Input.is_action_just_pressed("rotate_card_anti_clock"):
			if !is_rotating:
				is_rotating = true
				set_rotation_degrees(get_rotation_degrees() - 90)
		
		# To avoid wierd double input
		elif Input.is_action_just_released("rotate_card_clock") || Input.is_action_just_released("rotate_card_anti_clock"):
			is_rotating = false
	

# ---- FUNCTIONS ----

# function : send_parent_reference
# parameters : None
# returns : None
# description : send self reference to children

func send_parent_reference():
	for child in tiles_array:
		child.init_parent(self)


# -- spawn walls functions --

# function : count_sides
# parameters : (Node)
# returns : int
# description : count how many sides the card has

func count_sides(node):
	# For each nodes in the given node
	for current_node in node.get_children():
		# if the current children node has children
		if current_node.get_child_count() > 0:
			# calls back the function to get the children node of the current node
			count_sides(current_node)
		# The current node is the last child node
		else:
			
			# if the current node is a point
			if(current_node is PointTop || current_node is PointSide):
				side_count += 1

# funciton : generate_door
# parameters : None
# returns : bool
# description : generate a number depending of the remaining sides, return true if it'll be a door

func generate_door():
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


# function : place_all_walls
# parameters : (Node)
# returns : None
# description : Check if the node has childs, if it's a spawn point, place a wall

func place_all_walls(node):
	
	# For each nodes in the given node
	for current_node in node.get_children():
		# if the current children node has children
		if current_node.get_child_count() > 0:
			# calls back the function to get the children node of the current node
			place_all_walls(current_node)
			
		# The current node is the last child
		else:
			
			# if the current node is from PointTop class
			if current_node is PointTop:
				
				# spawns a horizontal wall
				var side
				# if it's a door
				if generate_door():
					side = door_node.instance()
				else:
					side = wall_node.instance()
					
				# makes it horizontal
				side.set_rotation_degrees(90)
				# add it to the scene
				current_node.add_child(side)
			
			# else, if the node is from PointSide class
			elif current_node is PointSide:
				
				# spawns a vertical wall
				var side
				# if it's a door
				if generate_door():
					side = door_node.instance()
				else:
					side = wall_node.instance()
					
				# add it to the scene
				current_node.add_child(side)


# function : pick_color
# parameters : (None)
# returns : String
# description: pick a random color depending of the color chance values

func pick_color():
	
	var total_chance = 0
	
	for chance in color_chance.values():
		total_chance += chance
	
	rng.randomize()
	var color_pick = rng.randi_range(1, total_chance)
	
	var previous_scores = 0
	
	for color_key in color_chance:
		
		if previous_scores < color_pick && color_pick < color_chance.get(color_key) + previous_scores:
			# color found
			return color_key
		else:
			# color not found
			previous_scores += color_chance.get(color_key)



# function : change_color
# parameters : (String)
# returns : None
# description : changes the tiles' color to the one sent in parameters

func change_color(color):
	var color_var = Color(0,0,0,0)

	if color == "blue":
		color_var = Color(0,0,1,0.2)
	elif color == "red":
		color_var = Color(1,0,0,0.2)
		
	for tile in tiles:
		if tile is Area2D:
			tile.get_node("TileColor").color = color_var

# -- drag & drop & rotate functions --

# function : tiles_hold_position
# parameters : (Vector2)
# returns : None
# description : Apply an offset to all the tiles so they keep their position when moving the base node

func tiles_hold_position(point):
	for tile in tiles_array:
		tile.set_global_position(tile.get_global_position() + point)


# function : drag
# parameters : None
# returns : None
# description : used to start to drag the card

func drag():
	temp_mouse_pos = get_viewport().get_mouse_position()
	offset = get_global_position() - temp_mouse_pos
	tiles_hold_position(offset)
	set_global_position(temp_mouse_pos)
	grab = true
	# get_node("Sprite").set_visible(true)

# function : drop
# parameters : None
# returns : None
# description : used to stop drop the card

func drop():
	grab = false
	offset = Vector2.ZERO
	global_position += get_the_nearest_tile_translation()
	
	if !is_card_on_empty_place():
		set_global_position(hand_position)
	
	# get_node("Sprite").set_visible(false)


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


# Find the nearest void tile, gets its translation with the card, and returns it 
func get_the_nearest_tile_translation() -> Vector2:
	var tile0_pos = tiles_array[0].get_global_position()
	var void_tiles_array = get_tree().get_nodes_in_group("VoidTiles")
	var smallest_distance = INF
	var direction_to := Vector2.ZERO
	
	for void_tile in void_tiles_array:
		var current_distance = tile0_pos.distance_to(void_tile.get_global_position())
		if current_distance < smallest_distance:
			smallest_distance = current_distance
			direction_to = tile0_pos.direction_to(void_tile.get_global_position())
	
	return direction_to * smallest_distance
