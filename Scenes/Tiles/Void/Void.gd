extends TileBase

onready var scene_tile = preload("res://Scenes/Tiles/Void/Void.tscn")

var current_tile_void : Node
var game_difficulty : int

func on_ready():
	tile_effect()
	print(game_difficulty)

func tile_effect():
	for i in range(1,game_difficulty):
		for j in range(1,game_difficulty):
			current_tile_void = scene_tile.instance()
			current_tile_void.set_position(Vector2(i*16-8,j*16-8))
			add_child(current_tile_void)