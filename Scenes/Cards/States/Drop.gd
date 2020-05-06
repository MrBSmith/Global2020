extends StateBase

#### DROP STATE ####

func enter_state():
	var first_tile = owner.tiles_array[0]
	
	var nearest_void_tile = get_the_nearest_tile(first_tile, "VoidTiles")
	owner.pivot_node.set_global_position(owner.get_global_position())
	owner.global_position += get_translation(first_tile, nearest_void_tile)
	
	if is_card_on_empty_place():
		for tile in owner.tiles_array:
			tile.activate_walls()
			var void_underneath = get_the_nearest_tile(tile, "VoidTiles")
			void_underneath.queue_free()
			states_node.set_state_by_name("Placed")
	else:
		owner.set_position(Vector2.ZERO)
		owner.set_rotation_degrees(0)
		states_node.set_state_by_name("Hand")


# Check if there is a void tile under each tiles of the card
# Return true if its the case, false in any other case
func is_card_on_empty_place() -> bool:
	for tile in owner.tiles_array:
		var nearest_tile = get_the_nearest_tile(tile)
		# If there is no void tile under the tile
		if is_tile_outside_grid(tile):
			return false
		# If the nearest tile is not a void tile
		if !(nearest_tile is VoidTile):
			return false
	return true


# Return true if the given tile is inside the boudries of the grid, false if not
func is_tile_outside_grid(tile : Tile) -> bool:
	var tile_pos = tile.get_global_position()
	var min_pos = owner.grid_min_pos
	var max_pos = owner.grid_max_pos
	var inside_x : bool = tile_pos.x < min_pos.x && tile_pos.x >= max_pos.x
	var inside_y : bool = tile_pos.y < min_pos.y && tile_pos.y >= max_pos.y
	return inside_x && inside_y



# Find the nearest void tile, and returns it
func get_the_nearest_tile(node : Node, group_name : String = "Tiles") -> Tile:
	var node_pos = node.get_global_position()
	var searched_tiles_array = get_tree().get_nodes_in_group(group_name)
	var smallest_distance = INF
	var nearest_tile : Tile = null
	
	for tile in searched_tiles_array:
		var current_distance = node_pos.distance_to(tile.get_global_position())
		if current_distance < smallest_distance && tile != node:
			smallest_distance = current_distance
			nearest_tile = tile
	
	return nearest_tile


# Return the translation between two nodes
func get_translation(node1 : Node, node2 : Node) -> Vector2:
	var direction_to : Vector2 = node1.global_position.direction_to(node2.get_global_position())
	var distance_to : float =  node1.global_position.distance_to(node2.get_global_position())
	return direction_to * distance_to
