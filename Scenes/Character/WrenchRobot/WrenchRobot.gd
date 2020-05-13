extends Player

var angle : float = 0.0

func _physics_process(_delta):
	rotate_towards_direction()


func rotate_towards_direction():
	if velocity != Vector2.ZERO && direction != Vector2.ZERO:
		angle = direction.angle() + deg2rad(90)
	
	if pivot_node.get_rotation() != angle:
		angle = lerp(pivot_node.get_rotation(), angle, 0.8)
		pivot_node.set_rotation(angle)
