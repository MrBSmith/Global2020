extends Node

onready var gameover = preload("res://Scenes/GUI/Menus/LoseMenu/GameOver.tscn")
onready var game = preload("res://Scenes/Game/Game.tscn")

var scene_transitioning : bool = false

func goto_to(scene : PackedScene):
	scene_transitioning = true
	var _err = get_tree().change_scene_to(scene)
