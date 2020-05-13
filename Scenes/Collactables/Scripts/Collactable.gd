extends Area2D
class_name Collactable

export var color : String = ""

onready var shadow_node = $Shadow
onready var states_node = $States
onready var sprite_node = $Sprite

func _ready():
	states_node.setup()
	
	var _err = connect("body_entered", self, "on_body_entered") 


# Whenever the player apporches the collactable,
# if the player has no collactable, and the collactable is in idle state:
# The player grabs it
func on_body_entered(body : PhysicsBody2D):
	if body is Player && body.collactable_slot.get_child_count() == 0:
		if states_node.get_state_name() == "Idle":
			get_parent().call_deferred("remove_child", self)
			set_position(Vector2.ZERO)
			body.collactable_slot.call_deferred("add_child", self)
			states_node.set_state_by_name("Grabed")
