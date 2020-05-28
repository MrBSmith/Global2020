extends Node

onready var gameover = preload("res://Scenes/GUI/Menus/LoseMenu/GameOver.tscn")
onready var screen_title = preload("res://Scenes/GUI/Menus/ScreenTitle/ScreenTitle.tscn")
onready var sound_menu = preload("res://Scenes/GUI/Menus/SoundMenu/SoundMenu.tscn")
onready var game = preload("res://Scenes/Game/Game.tscn")
onready var you_won = preload("res://Scenes/GUI/Menus/WinMenu/YouWon.tscn")

var scene_transitioning : bool = false

func goto_to(scene : PackedScene):
	scene_transitioning = true
	var _err = get_tree().change_scene_to(scene)
