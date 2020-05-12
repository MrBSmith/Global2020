extends Node

class_name StatesMachine

# Define the list of possible states, and give the path to the corresponding node for each state
# The states are distinguished by the name of their corresponding node
# The default state is always the first in the tree

signal state_change

onready var states_map = get_children()

onready var current_state : StateBase
onready var previous_state : StateBase


func _ready():
	set_physics_process(false)

func setup():
	set_state(states_map[0])
	set_physics_process(true)


# Call for the current state process
func _physics_process(delta):
	var new_state_name : String = current_state.update(delta)
	if new_state_name != "":
		set_state_by_name(new_state_name)


# Set a new state
func set_state(new_state: StateBase):
	# Discard the method if the new_state is the current_state
	if new_state == current_state:
		return
	
	# Use the exit state function of the current state
	if current_state != null:
		current_state.exit_state()
	
	# Change the current state, and the previous state
	previous_state = current_state
	current_state = new_state
	
	# Use the enter_state function of the current state
	if new_state != null:
		current_state.enter_state()
	
	emit_signal("state_change")


# Set the state, based on the given state name
func set_state_by_name(new_state_name : String):
	var new_state = get_node_or_null(new_state_name)
	if new_state != null:
		set_state(new_state)


# Returns the String name of the current state
func get_state_name() -> String:
	return current_state.name

# Returns the current state
func get_state() -> StateBase:
	return current_state

