extends StateBase

#### HAND STATE ####

func enter_state():
	owner.set_global_position(owner.pivot_node.get_global_position())
