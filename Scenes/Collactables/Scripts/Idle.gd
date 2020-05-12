extends StateBase

onready var anim_player_node = $AnimationPlayer

#### IDLE STATE ####

func enter_state():
	anim_player_node.play("Float")

func exit_state():
	anim_player_node.stop()
