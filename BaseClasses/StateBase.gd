extends Node

class_name StateBase

onready var states_node = get_parent()

func update(_delta) -> String:
	return ""

func enter_state():
	pass

func exit_state():
	pass
