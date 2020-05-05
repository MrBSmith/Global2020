extends Node2D
 
onready var node_GUI = get_node("GUI")
onready var grid_gen_node = get_node("Grid")
onready var node_GUI_array = node_GUI.get_children()
onready var music_node = get_node("Music")

export var grid_size : int = 8

func _ready():
	SCENES.scene_transitioning = false
	
	# Notify the Void node of the size of the map, so it can generate the right number of void tiles
	grid_gen_node.nb_tiles = grid_size
	grid_gen_node.on_ready()
	
	for child in node_GUI_array:
		if child.has_method("on_ready"):
			child.on_ready()

	music_node.launch_every_stream()
