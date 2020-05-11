extends Player

onready var wrenches_sprite_node = $WrenchesSprite
onready var eyes_sprite_node = $EyesSprite
var angle : float = 0.0

func _physics_process(_delta):
	rotate_towards_direction()


func rotate_towards_direction():
	if velocity != Vector2.ZERO && direction != Vector2.ZERO:
		angle = direction.angle() + deg2rad(90)
	
	if eyes_sprite_node.get_rotation() != angle:
		angle = lerp(eyes_sprite_node.get_rotation(), angle, 0.8)
		wrenches_sprite_node.set_rotation(angle)
		eyes_sprite_node.set_rotation(angle)
