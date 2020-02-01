extends Node2D

onready var node_tiles = get_node("Tiles")
onready var tiles_children = node_tiles.get_children()

#8: HARD / 7: MEDIUM / 6: EASY
#8: (7x7) / 7: (6x6) / 6: (5x5)
export var difficulty : int = 8

func _ready():
	for child in tiles_children:
		if(child.get("game_difficulty") != null):
			child.game_difficulty = difficulty
		if(child.has_method("on_ready")):
			child.on_ready()

