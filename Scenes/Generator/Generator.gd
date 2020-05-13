extends Area2D

func _ready():
	var screen_width : float = ProjectSettings.get("display/window/size/width")
	var screen_height : float =  ProjectSettings.get("display/window/size/height")
	
	global_position.x = screen_width / 2
	global_position.y = screen_height / 2
	
	var _err = connect("body_entered", self, "on_body_entered")


func on_body_entered(body : PhysicsBody2D):
	if body is Player && body.collactable_slot.get_child_count() != 0:
		var collactable = body.collactable_slot.get_child(0)
		collactable.get_parent().call_deferred("remove_child", collactable)
		
		var collactable_color : String = collactable.color
		var slot_node = $Slots.get_node_or_null(collactable_color)
		if slot_node != null:
			slot_node.call_deferred("add_child", collactable)
			collactable.states_node.set_state_by_name("Droped")
