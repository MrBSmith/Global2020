extends Control

onready var children_array = get_children()
onready var node_Timer = get_node("Timer")

func _physics_process(_delta):
	pass

func on_ready():
	for child in children_array:
		if(child.has_method("on_ready")):
			child.on_ready()

func on_timer_started():
	print("Timer started!")

func on_timer_timeout():
	print("Timer timeout")
