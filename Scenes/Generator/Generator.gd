extends Area2D

func _ready():
	var screen_width : float = ProjectSettings.get("display/window/size/width")
	var screen_height : float =  ProjectSettings.get("display/window/size/height")
	
	global_position.x = screen_width / 2
	global_position.y = screen_height / 2
