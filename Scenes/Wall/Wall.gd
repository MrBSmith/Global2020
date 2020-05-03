extends StaticBody2D

class_name Wall
const CLASS : String = "Wall"

func is_class(value: String) -> bool:
	return value == CLASS

func get_class() -> String:
	return CLASS
