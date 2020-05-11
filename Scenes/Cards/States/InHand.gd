extends StateBase

#### HAND STATE ####

func enter_state():
	owner.set_global_position(owner.pivot_node.get_global_position())
	owner.scale_dest = Vector2(0.5, 0.5)


func exit_state():
	owner.scale_dest = Vector2.ONE
