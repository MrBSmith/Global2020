extends Node2D

onready var node_gameoverscene : Node

onready var children_array = get_children()
onready var node_LabelTimer = get_node("LabelTimer")
onready var node_Timer = get_node("Timer")

var is_on_gameover_screen : bool = false

func _physics_process(_delta):
	node_LabelTimer.text = node_Timer.time_left as String
	if(is_on_gameover_screen):
		if(Input.is_action_just_pressed("game_restart")):
			node_Timer.wait_time = 1
			node_Timer.start_timer()

func setup():
	for child in children_array:
		if child.has_method("setup"):
			child.setup()
	node_Timer.start_timer()


func on_timer_started():
	#print("Timer started!")
	pass


func on_timer_timeout():
	if !is_on_gameover_screen:
		SCENES.goto_to(SCENES.gameover)

