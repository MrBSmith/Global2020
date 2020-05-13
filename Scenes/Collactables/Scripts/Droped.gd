extends StateBase

#### DROPED STATE ####

func enter_state():
	owner.set_position(Vector2.ZERO)
	
	var sprite_node = owner.sprite_node
	sprite_node.set_position(Vector2.ZERO)
	
	# Desactivate the outline
	sprite_node.set_material(null)
	
	# Reset the offset to zero
	sprite_node.set_offset(Vector2.ZERO)
	sprite_node.set_z_index(1)
