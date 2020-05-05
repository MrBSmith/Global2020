extends KinematicBody2D
class_name Player

signal speed_changed

export var fast_speed : float = 120.0
export var medium_speed : float = 60.0
export var slow_speed : float = 30.0

var speed : float = medium_speed setget set_speed
export var friction : float = 0.08
export var acceleration : float = 0.08

onready var radius : float = $CollisionShape2D.get_shape().get_radius()

var velocity := Vector2.ZERO
var direction := Vector2()

var min_pos : Vector2
var max_pos : Vector2

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float =  ProjectSettings.get("display/window/size/height")


func set_speed(value: float):
	speed = value
	
	if value == fast_speed:
		emit_signal("speed_changed", "Fast")
	elif value == medium_speed:
		emit_signal("speed_changed", "Medium")
	elif value == slow_speed:
		emit_signal("speed_changed", "Slow") 


func _ready():
	set_physics_process(false)
	self.position.x = screen_width / 2
	self.position.y = screen_height / 2
	
	var _err = connect("speed_changed", owner.get_node("Music"), "on_speed_changed")

func on_ready():
	set_physics_process(true)


# ----- TICK PROCESS -----

func _physics_process(_delta):
	move()


func move():
	# If there's input, accelerate to the input velocity
	if direction.length() > 0:
		velocity = velocity.linear_interpolate(direction, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	# Move the physic body
	velocity = move_and_slide(velocity)
	global_position.x = clamp(global_position.x, min_pos.x + radius, max_pos.x - radius)
	global_position.y = clamp(global_position.y, min_pos.y + radius, max_pos.y - radius)

# ----- INPUT -----

func _input(_event):
	direction = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized() * speed

