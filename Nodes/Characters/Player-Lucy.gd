extends KinematicBody2D

enum {IDLE,RUN,JUMP} 

var velocity = Vector2(0,0)
var PLAYERSTATE = IDLE
export var speed = 300
export var gravity = 1000
export var jump = 500
onready var sprite = $Sprite

func _physics_process(delta):
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		PLAYERSTATE = RUN
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		PLAYERSTATE = RUN
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump
		
#Flip Sprite
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2.UP)
