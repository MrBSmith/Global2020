extends Node2D

onready var tiles_node = get_node("Tiles")
onready var void_node = get_node("Tiles/Void")
onready var tile_node_array = tiles_node.get_children()

onready var music_node = get_node("Music")

#8: HARD / 7: MEDIUM / 6: EASY
#8: (7x7) / 7: (6x6) / 6: (5x5)
export var difficulty : int = 8

func _ready():
	# Notify the Void node of the size of the map, so it can generate the right number of void tiles
	void_node.game_difficulty = difficulty
	
	# Call the on_ready function of every tiles
	for child in tile_node_array:
		if(child.has_method("on_ready")):
			child.on_ready()
	
	music_node.play_music("Base")
	music_node.play_music("Normal")
