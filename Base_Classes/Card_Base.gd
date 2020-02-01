extends Node2D

# ---- VARIABLES ----

var rng = RandomNumberGenerator.new()

var wall_node_path = "res://Scenes/Wall/Wall.tscn"
var door_node_path = "res://Scenes/Wall/Door.tscn"

# how many doors the card can have, between the range 
export(int) var min_door : int = 2
export(int) var max_door : int = 2

# Number of sides the room has
var side_count
# the number of door the room will have
var door_count
# the number of walls the room will have
var wall_count


# ---- ONREADY ----

func _ready():
	rng.randomize()
	door_count = rng.randi_range(min_door, max_door)
	print("door_count : " + str(door_count))
	
	# Check how many sides the card has to know how many walls it has
	side_count = 0
	count_sides(get_node("."))
	wall_count = side_count - door_count
	print("side_count : " + str(side_count))
	print("wall_count : " + str(wall_count))
	
	# Place walls and doors
	place_all_walls(get_node("."))
	

# ---- FUNCTIONS ----

# function : count_sides
# parameters : (Node)
# returns : int
# description : count how many sides the card has

func count_sides(Node):
	# For each nodes in the given node
	for current_node in Node.get_children():
		# if the current children node, named N, has children nodes
		if current_node.get_child_count() > 0:
#			print("["+current_node.get_name()+"]")
			# calls back the function to get the children node of the current node
			count_sides(current_node)
		# The current node is the last children node
		else:
#			print("- "+current_node.get_name())
			
			# if the current node is a side
			if(current_node is PointTop || current_node is PointSide):
				side_count += 1


# function : place_all_walls
# parameters : (Node)
# returns : None
# description : Check if the node has childs, if it's a spawn point, place a wall

func place_all_walls(Node):
	
	var remaining_doors = door_count
	var remaining_walls = wall_count
	
	# For each nodes in the given node
	for current_node in Node.get_children():
		# if the current children node, named N, has children nodes
		if current_node.get_child_count() > 0:
#			print("["+current_node.get_name()+"]")
			# calls back the function to get the children node of the current node
			place_all_walls(current_node)
		# The current node is the last children node
		else:
#			print("- "+current_node.get_name())
			
			# Get a random number between the remaining sides
			rng.randomize()
			var rand_wall = rng.randi_range(1, remaining_walls)
			
			print("rand_wall : " + str(rand_wall))
			
			var is_door = false
			
			# if rand_wall is below the number of remaining doors, that means we still have doors to place
			if remaining_doors >= rand_wall:
				# it's a door, set the bool to true
				is_door = true
				# a door has been placed, so remove it from the remaining_doors count
				remaining_doors -= 1
			# either there is not enough door to put one, or the random chose to put a wall in this position
			else:
				# remove a wall from the count
				remaining_walls -= 1
			
			
			
			# if the current node is from PointTop class
			if current_node is PointTop:
				print("Top")
				
				# spawns a horizontal wall
				var side
				# if it's a door
				if is_door:
					side = load(door_node_path).instance()
				else:
					side = load(wall_node_path).instance()
					
				# makes it horizontal
				side.set_rotation_degrees(90)
				# add it to the scene
				current_node.add_child(side)
			
			# else, if the node is from PointSide class
			elif current_node is PointSide:
				print("side")
				
				# spawns a vertical wall
				var side
				# if it's a door
				if is_door:
					side = load(door_node_path).instance()
				else:
					side = load(wall_node_path).instance()
					
				# add it to the scene
				current_node.add_child(side)
