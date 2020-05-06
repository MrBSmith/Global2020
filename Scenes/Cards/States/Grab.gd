extends StateBase

#### GRABED STATE ####


func update(_delta : float) -> String:
	owner.set_global_position(get_viewport().get_mouse_position())
	return ""


func enter_state():
	var mouse_pos = get_viewport().get_mouse_position()
	var card_original_pos = owner.get_global_position()
	owner.set_global_position(mouse_pos)
	owner.pivot_node.set_global_position(card_original_pos)


func exit_state():
	owner.set_global_position(owner.pivot_node.get_global_position())


# Handle rotation
func _input(_event):
	if states_node.get_state() == self:
		if Input.is_action_just_pressed("rotate_card_clock") or Input.is_action_just_pressed("rotate_card_anti_clock"):
			var current_rot = owner.rotation_dest_deg
			# If the card is grabbed and the clockwise button is pressed
			if Input.is_action_just_pressed("rotate_card_clock"):
				current_rot += 90
	
			# If the card is grabbed and the cunter clockwise button is pressed
			elif Input.is_action_just_pressed("rotate_card_anti_clock"):
				current_rot -= 90
			
			owner.rotation_dest_deg = wrapf(current_rot, 0, 360)
