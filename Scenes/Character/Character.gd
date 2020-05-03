extends KinematicBody2D

const fast_speed = 60.0
const medium_speed = 36.0
const slow_speed = 22.0

export var speed : float = 10
export var friction : float = 0.08
export var acceleration : float = 0.08
export var gayness : int

var velocity := Vector2.ZERO
var direction := Vector2()

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float =  ProjectSettings.get("display/window/size/height")

func _ready():
	self.position.x = screen_width/2-4
	self.position.y = screen_height/2


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


# ----- INPUT -----

func _input(_event):
	direction = Vector2()
	if Input.is_action_pressed("fast_speed"):
		speed = fast_speed
	if Input.is_action_pressed("medium_speed"):
		speed = medium_speed
	if Input.is_action_pressed("slow_speed"):
		speed = slow_speed
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
			
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
			
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
			
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		
	direction = direction.normalized() * speed

