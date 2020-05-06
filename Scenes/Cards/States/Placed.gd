extends StateBase

#### PLACED STATE ####

var player_touched : bool = false

func enter_state():
	for tile in owner.tiles_array:
		var _err = tile.connect("body_entered", self, "on_tile_body_entered")


func exit_state():
	for tile in owner.tiles_array:
		var _err = tile.disconnect("body_entered", self, "on_tile_body_entered")
	
	player_touched = false


func update(_delta) -> String:
	if player_touched && !is_player_inside_card():
		owner.call_deferred("destroy")
	return ""


func is_player_inside_card():
	for tile in owner.tiles_array:
		for body in tile.get_overlapping_bodies():
			if body is Player:
				return true
	return false


func on_tile_body_entered(body: PhysicsBody2D):
	if body is Player:
		player_touched = true
