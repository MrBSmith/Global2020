extends StateBase

# ---- INPUT ----

var offset_with_mouse := Vector2.ZERO

func update(_delta : float) -> String:
	owner.set_global_position(get_viewport().get_mouse_position() - offset_with_mouse)
	return ""


func enter_state():
	var mouse_pos = get_viewport().get_mouse_position()
	offset_with_mouse = mouse_pos - owner.get_global_position()


func exit_state():
	offset_with_mouse = Vector2.ZERO


func _input(_event):
	if states_node.get_state() == self:
		# If the card is grabbed and the clockwise button is pressed
		if Input.is_action_just_pressed("rotate_card_clock"):
			owner.set_rotation_degrees(owner.get_rotation_degrees() + 90)

		# If the tile is held and the anti clockwise button is pressed
		elif Input.is_action_just_pressed("rotate_card_anti_clock"):
			owner.set_rotation_degrees(owner.get_rotation_degrees() - 90)
