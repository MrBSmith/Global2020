extends Area2D

class_name VoidTile
const CLASS : String = "VoidTile"

func is_class(value: String) -> bool:
	return value == CLASS

func get_class() -> String:
	return CLASS
