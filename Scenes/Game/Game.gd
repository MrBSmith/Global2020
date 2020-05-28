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
	grid_gen_node.setup()
	
	for child in node_GUI_array:
		if child.has_method("setup"):
			child.setup()

	music_node.launch_every_stream()

# The game is won
func _on_Generator_repaired():
	music_node.stop_every_stream()
	
	node_GUI.get_node("NTimer/Timer").set_paused(true)
	
	if grid_gen_node.has_node("Fog"):
		grid_gen_node.get_node("Fog").set_visible(false)
	
	grid_gen_node.get_node("Hand").disable()
	
	
	
	
	pass # Replace with function body.
