extends Node

onready var streams_node_array = get_children()
onready var current_stream : Node = get_node("Normal")
onready var base_stream : Node = get_node("Base")
var previous_stream : Node = null


# Launch every streams, and mute every one exepts the base one and the current one
func launch_every_stream():
	for stream in streams_node_array:
		stream.play()
		if stream != current_stream && stream != base_stream:
			stream.mute()


# Play the specified stream
func set_current_stream(node):
	var new_stream : Node
	if node is String:
		 new_stream = get_node_or_null(node)
	else:
		new_stream = node
	
	if new_stream != null && new_stream != current_stream:
		previous_stream = current_stream
		current_stream = new_stream
		
		previous_stream.set_fade_out(true)
		current_stream.set_fade_in(true)
	else:
		print("Le stream spécifié n'existe pas.")


# DEBUG PURPOSE
#func _unhandled_input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_ENTER:
#			var rng = RandomNumberGenerator.new()
#			rng.randomize()
#			var index = rng.randi_range(1, 3)
#			print(index)
#			set_current_stream(streams_node_array[index])


# Returns the current stream
func get_current_stream() -> Node:
	return current_stream
