extends Area2D

var mouse_over : bool = false

func _ready():
	var _err
	_err = connect("mouse_entered", self, "on_mouse_entered")
	_err = connect("mouse_exited", self, "on_mouse_exited")


func _input(event):
	if event is InputEventMouseButton:
		if mouse_over and event.pressed:
			print("clicked")


func on_mouse_entered():
	mouse_over = true


func on_mouse_exited():
	mouse_over = false
