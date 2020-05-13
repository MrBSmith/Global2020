extends StateBase

#### GRABED STATE ####

func enter_state():
	owner.shadow_node.set_visible(false)
	owner.set_position(Vector2.ZERO)
