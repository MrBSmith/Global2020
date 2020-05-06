extends Node

class_name StateBase

onready var states_node = get_parent()

# Called every physics ticks by the StateMachine when the state is this one
func update(_delta) -> String:
	return ""

# Called whenever the new state is set to be this one
func enter_state():
	pass

# Called right before the state is changed to anoter one
func exit_state():
	pass
