extends KinematicBody2D

enum {IDLE,RUN,JUMP} 
enum MovementDir {NONE, LEFT, RIGHT}

var velocity = Vector2(0,0)
var PLAYERSTATE = IDLE
export var speed = 300
export var gravity = 3000
export var jump = 1000
onready var sprite = $Sprite
var last_movement_buttons = []

func _physics_process(delta):
	velocity.x = 0

	# Fill movement Array
	if Input.is_action_just_pressed("move_left"):
		last_movement_buttons.push_front(MovementDir.LEFT)
	if Input.is_action_just_pressed("move_right"):
		last_movement_buttons.push_front(MovementDir.RIGHT)

	# Clear Movement Array
	if Input.is_action_just_released("move_left"):
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.LEFT))
	if Input.is_action_just_released("move_right"):
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.RIGHT))
	
	# Actual movement
	if not last_movement_buttons.empty():
		if last_movement_buttons[0] == MovementDir.LEFT:
			velocity.x = -speed
	#		PLAYERSTATE = RUN
		if last_movement_buttons[0] == MovementDir.RIGHT:
			velocity.x = speed
	#		PLAYERSTATE = RUN
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump
		
#Flip Sprite
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2.UP)
