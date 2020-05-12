extends KinematicBody2D
class_name Player

signal speed_changed

export var normal_speed : float = 60.0

var speed : float = normal_speed setget set_speed
export var friction : float = 0.8
export var acceleration : float = 0.8

onready var radius : float = $CollisionShape2D.get_shape().get_radius()

var velocity := Vector2.ZERO
var direction := Vector2.ZERO setget set_direction, get_direction

var grid_min_pos : Vector2
var grid_max_pos : Vector2

var is_moving : bool = false

func set_speed(value: float):
	speed = value
	
	if value > normal_speed:
		emit_signal("speed_changed", "Fast")
	elif value == normal_speed:
		emit_signal("speed_changed", "Medium")
	elif value < normal_speed:
		emit_signal("speed_changed", "Slow") 


func set_direction(value: Vector2):
	direction = value

func get_direction() -> Vector2:
	return direction


func _ready():
	set_physics_process(false)
	var screen_width : float = ProjectSettings.get("display/window/size/width")
	var screen_height : float =  ProjectSettings.get("display/window/size/height")
	
	self.position.x = screen_width / 2
	self.position.y = screen_height / 2
	
	var _err = connect("speed_changed", owner.get_node("Music"), "on_speed_changed")


func setup():
	set_physics_process(true)


# ----- TICK PROCESS -----

func _physics_process(_delta):
	move()


func move():
	# If there's input, accelerate to the input velocity
	if direction.length() > 0:
		is_moving = true
		velocity = velocity.linear_interpolate(direction, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		is_moving = false
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	# Move the physic body
	velocity = move_and_slide(velocity)
	global_position.x = clamp(global_position.x, grid_min_pos.x + radius, grid_max_pos.x - radius)
	global_position.y = clamp(global_position.y, grid_min_pos.y + radius, grid_max_pos.y - radius)

# ----- INPUT -----

func _input(_event):
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	
	dir = dir.normalized()
	direction = dir * speed

