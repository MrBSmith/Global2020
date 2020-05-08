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
	if player_touched && !owner.is_player_inside_card():
		owner.call_deferred("destroy")
	return ""


func on_tile_body_entered(body: PhysicsBody2D):
	if body is Player:
		player_touched = true
