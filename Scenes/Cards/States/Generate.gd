extends StateBase

#### GENERATE STATE ####

onready var wall_node = preload("res://Scenes/Wall/Wall.tscn")

var rng = RandomNumberGenerator.new()

var tiles_touched : int = 0

var remaining_doors
var remaining_walls


# Place the walls and door randomly, 
# Also choose a color randomly, based on the weight of each color set in the card node
func enter_state():
	rng.randomize()
	var door_count = rng.randi_range(owner.min_door, owner.max_door)

	# Check how many sides the card has to know how many walls it has
	var side_count = count_sides()
	var wall_count = side_count - door_count

	remaining_doors = door_count
	remaining_walls = wall_count

	# Place walls and doors
	place_all_walls()
	var color_name = pick_color()
	change_tiles_color(color_name)
	
	states_node.set_state_by_name("Hand")
	
	
	owner.set_scale(Vector2(0.5, 0.5))
	owner.scale_dest = Vector2(0.5, 0.5)


# -- spawn walls functions --

# Count how many sides the card has and return it
func count_sides() -> int:
	var counter : int = 0

	# For each nodes in the given node
	for tile in owner.tiles_array:
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
	for tile in owner.tiles_array:
		for current_node in tile.get_children():
			if current_node is Position2D:
				if !generate_door(): # if it's a wall
					var side = wall_node.instance()
					
					# Makes it horizontal if the point is a top one
					if current_node is PointTop:
						side.set_rotation_degrees(90)
					
					# Add the door/wall to rh 
					side.set_position(current_node.get_position())
					tile.add_child(side)


# Pick a random color depending of the color chance values
func pick_color():
	var total_chance = 0
	var color_chance : Dictionary = owner.color_chance

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
	for tile in owner.tiles_array:
		tile.set_color(tile.get(color_name))
