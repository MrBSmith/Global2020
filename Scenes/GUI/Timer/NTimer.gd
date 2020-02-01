extends Node2D

onready var scene_gameover = "res://Scenes/GUI/Menus/LoseMenu/GameOver.tscn"

onready var children_array = get_children()
onready var node_LabelTimer = get_node("LabelTimer")
onready var node_Timer = get_node("Timer")

func _physics_process(_delta):
	node_LabelTimer.text = node_Timer.time_left as String

func on_ready():
	for child in children_array:
		if(child.has_method("on_ready")):
			child.on_ready()
	node_Timer.start_timer()

func on_timer_started():
	print("Timer started!")

func on_timer_timeout():
	get_tree().change_scene(scene_gameover)
