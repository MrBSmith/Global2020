extends Node

onready var void_tile_scene = preload("res://Scenes/Tiles/VoidTile/Void.tscn")
onready var tile_scene = preload("res://Scenes/Tiles/NormalTile/Tile.tscn")

var nb_tiles : int
var void_sprite_size : float
var grid_position := Vector2.ZERO

func setup():
	create_grid()
	
	var min_pos = Vector2(grid_position.x + void_sprite_size / 2, 0)
	var max_pos = Vector2.ZERO
	max_pos.x = grid_position.x + (nb_tiles * void_sprite_size) - void_sprite_size / 2
	max_pos.y = grid_position.y + (nb_tiles * void_sprite_size) - void_sprite_size
	
	for child in get_children():
		if "grid_min_pos" in child && "grid_max_pos" in child:
			child.grid_min_pos = min_pos
			child.grid_max_pos = max_pos
		
		if child.has_method("setup"):
			child.setup()
	
	place_fog(min_pos, max_pos - min_pos)


# Place the fog behind the grid, and scale it accordingly
func place_fog(pos: Vector2, size: Vector2):
	var fog = $Fog
	fog.set_global_position(pos)
	fog.set_region(true)
	fog.set_region_rect(Rect2(0, 0, size.x, size.y))


# Fill the map with void tile, except the 4 corners and the center with normal tiles
func create_grid():
	var current_tile = void_tile_scene.instance()
	var void_sprite = current_tile.get_node("Sprite").get_texture()
	void_sprite_size = void_sprite.get_size().x
	
	var screen_width = ProjectSettings.get_setting("display/window/size/width")
	var nb_tiles_in_screen = screen_width / void_sprite_size
	grid_position.x = ((nb_tiles_in_screen - nb_tiles) / 2) * void_sprite_size
	
	current_tile.queue_free()
	
	# Create every tiles in the grid
	for i in range(1, nb_tiles):
		for j in range(1, nb_tiles):
			# Determine if the node should be a normal tile or a void tile
			if is_tile_the_center(i, j) || is_tile_a_corner(i, j):
				current_tile = tile_scene.instance()
			else:
				current_tile = void_tile_scene.instance()
			
			# Create the tile, and set its position
			var current_tile_pos = Vector2(grid_position.x + (i * void_sprite_size), j * void_sprite_size - void_sprite_size / 2)
			current_tile.set_position(current_tile_pos)
			add_child(current_tile)


# Return true if the given tile coordinates corresponds to the center of the grid
func is_tile_the_center(i: int, j: int) -> bool:
	return (i == int(float(nb_tiles) / 2) && j == int(float(nb_tiles) /2)) 


# Return true if the given tile coordinates corresponds to a corner of the grid
func is_tile_a_corner(i: int, j: int) -> bool:
	return (i == 1 || i == nb_tiles - 1) && (j == 1 || j == nb_tiles - 1)
