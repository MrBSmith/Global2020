extends Node2D

# ---- VARIABLES ----

var wall_node_path = "res://Scenes/Wall/Wall.tscn";
var door_node_path = "res://Scenes/Wall/Door.tscn";


# ---- ONREADY ----

func _ready():
	place_all_walls(get_node("."))

# ---- FUNCTIONS ----

# function : place_all_walls
# parameters : Node
# returns : None
# description : Check if the node has childs, if it's a spawn point, place a wall

func place_all_walls(Node):
	# For each nodes in the given node
	for N in Node.get_children():
		# if the current children node, named N, has children nodes
		if N.get_child_count() > 0:
			print("["+N.get_name()+"]");
			# calls back the function to get the children node of the current node
			place_all_walls(N);
		# The current node is the last children node
		else:
			print("- "+N.get_name())
			
			# if the current node is from PointTop class
			if N is PointTop:
				print("Top");
				# spawns a horizontal wall or door
				var wall = load(wall_node_path).instance();
				# makes it horizontal
				wall.set_rotation_degrees(90);
				# add it to the scene
				N.add_child(wall);
			
			# else, if the node is from PointSide class
			elif N is PointSide:
				print("side");
				# spawns a vertical wall or door
				var wall = load(wall_node_path).instance();
				# add it to the scene
				N.add_child(wall);
