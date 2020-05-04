extends Control

func _ready():
	SCENES.scene_transitioning = false


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_R:
			SCENES.goto_to(SCENES.game)
