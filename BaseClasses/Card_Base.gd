extends Node2D
class_name Card

# ---- VARIABLES ----

var tiles

var rng = RandomNumberGenerator.new()

var wall_node_path = "res://Scenes/Wall/Wall.tscn"
var door_node_path = "res://Scenes/Wall/Door.tscn"

var wall_node
var door_node

# how many doors the card can have, between the range 
export(int) var min_door : int = 2
export(int) var max_door : int = 2

# chances to get a color
export(int) var blue : int = 0
export(int) var grey : int = 100
export(int) var red : int = 0

# Number of sides the room has
var side_count
# the number of door the room will have
var door_count
# the number of walls the room will have
var wall_count

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
	
	tiles = get_children()
	send_parent_reference()
	
	wall_node = load(wall_node_path)
	door_node = load(door_node_path)
	
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


# ---- INPUT ----

func _input(event):
	
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
	for child in tiles:
		if child is Area2D:
			child.init_parent(self)
			
func pick_color():
	var lowest = 0
	var highest = 0
	var rates = [blue, grey, red]
	
	for i in range (0,3):
		if highest < rates[i]:
			highest = rates[i]
		if lowest > rates[i]:
			lowest = rates[i]

	rng.randomize()
	var pick = rng.randi(0, highest - 1)
	
	for i in range (0,3):
		if 0 < pick < lowest:
			pass
		if lowest < pick < highest:
			pass


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


# -- drag & drop & rotate functions --

# function : tiles_hold_position
# parameters : (Vector2)
# returns : None
# description : Apply an offset to all the tiles so they keep their position when moving the base node

func tiles_hold_position(point):
	for tile in tiles:
		if tile is Area2D:
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
	get_node("Sprite").set_visible(true)
	grab = true


# function : drop
# parameters : None
# returns : None
# description : used to stop drop the card

func drop():
	grab = false
	offset = Vector2.ZERO
	get_node("Sprite").set_visible(false)

# ---- PROCESS ----

func _process(delta):
	if grab:
		set_global_position(get_viewport().get_mouse_position())
