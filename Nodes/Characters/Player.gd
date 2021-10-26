class_name Player
extends KinematicBody2D

# Movement
enum MovementDir {LEFT, RIGHT}

var last_movement_buttons = []
var velocity = Vector2(0,0)

export var speed = 300
export var gravity = 3000
export var jump_impulse = 1000

export var windup_time = 0.7
export var block_time = 0.3
export var hp = 300

# Sprite
onready var sprite = $Sprite


func get_direction():
	return (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	
func move(delta):
	# Fill movement Array
	if Input.is_action_pressed("move_left") and last_movement_buttons.find(MovementDir.LEFT)==-1:
		last_movement_buttons.push_front(MovementDir.LEFT)
	if Input.is_action_pressed("move_right") and last_movement_buttons.find(MovementDir.RIGHT)==-1:
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
		if last_movement_buttons[0] == MovementDir.RIGHT:
			velocity.x = speed
		
	#Flip Sprite
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2.UP)
	

func _physics_process(delta):
	$Label.text = $StateMachine.state.name
	

func get_damage(damage : int):
	if $StateMachine.state == "Block":
		return
	else:
		 hp = hp - damage
