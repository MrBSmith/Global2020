extends TileBase

onready var scene_tile = preload("res://Scenes/Tiles/Void/Void.tscn")

var current_tile_void : Node
var grid_size : int

func on_ready():
	fill_with_void()

# Fill the map with void tiles
func fill_with_void():
	current_tile_void = scene_tile.instance()
	var void_sprite = current_tile_void.get_node("AnimatedSprite").get_sprite_frames().get_frame("default", 0)
	var void_sprite_size = void_sprite.get_size().x
	
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var nb_tiles_in_screen = screen_width / void_sprite_size
	var grid_x_pos = ((nb_tiles_in_screen - grid_size) / 2) * void_sprite_size
	
	current_tile_void.queue_free()
	
	for i in range(1, grid_size):
		for j in range(1, grid_size):
			current_tile_void = scene_tile.instance()
			var current_tile_pos = Vector2(grid_x_pos + (i * void_sprite_size), j * void_sprite_size - void_sprite_size / 2)
			current_tile_void.set_position(current_tile_pos)
			add_child(current_tile_void)
