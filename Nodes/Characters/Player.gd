class_name Player
extends KinematicBody2D


var velocity = Vector2(0,0)
export var speed = 300
export var gravity = 3000
export var jump_impulse = 1000
onready var sprite = $Sprite

enum MovementDir {LEFT, RIGHT}
var last_movement_buttons = []

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


# Better (?) than several Attack functions: One animation Player with several atk animations
# --> pass attack func animation name
func attack_basic_1():
	if sprite.flip_h:
		$Attack_Basic_Left/Anim_Attack_Basic_1.play("Placeholder_Attack")
	else:
		$Attack_Basic_Right/Anim_Attack_Basic_1.play("Placeholder_Attack")


func attack_basic_2():
	if sprite.flip_h:
		$Attack_Basic_Left/Anim_Attack_Basic_2.play("Placeholder_Attack")
	else:
		$Attack_Basic_Right/Anim_Attack_Basic_2.play("Placeholder_Attack")


func attack_basic_3():
	if sprite.flip_h:
		$Attack_Basic_Left/Anim_Attack_Basic_3.play("Placeholder_Attack")
	else:
		$Attack_Basic_Right/Anim_Attack_Basic_3.play("Placeholder_Attack")
