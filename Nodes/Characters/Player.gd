class_name Player
extends KinematicBody2D

# Movement
enum MovementDir {LEFT, RIGHT}
enum PossibleInput {ATTACK_BASIC, BLOCK, JUMP}

const last_movement_buttons = []
const last_input = []

var velocity := Vector2(0,0)

export var speed = 300
export var attack_step_speed = 150
export var gravity = 3000
export var jump_impulse = 1000

export var windup_time : float = 0.2
export var block_time : float = 0.33
export var attack_time : float = 0.2
export var recovery_time : float = 0.2


onready var sprite : Sprite = $Sprite
onready var hitbox_block : CollisionShape2D = $HitboxBlock
onready var hitbox_attack : CollisionShape2D = $HitboxAttack


func get_direction():
	return velocity.length()
	# Below returns zero even if player is moving but left and right are pressed.
	#return (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))


func pop_combat_queue():
	return last_input.pop_back()


func _process(delta):
	# Queue Attack in Array
	if len(last_input) <= 4:
		if Input.is_action_just_pressed("attack"):
			last_input.push_front(PossibleInput.ATTACK_BASIC)
		
	# Cancel attack, clear queue
	if Input.is_action_just_pressed("jump"):
		last_input.clear()
	elif Input.is_action_just_pressed("block"):
		last_input.clear()
		last_input.push_front(PossibleInput.BLOCK)
	elif Input.is_action_just_pressed("jump"):
		last_input.clear()
		last_input.push_front(PossibleInput.JUMP)
	
	# Fill movement Array
	if Input.is_action_just_pressed("move_left"):
		last_input.clear()
		last_movement_buttons.push_front(MovementDir.LEFT)
	if Input.is_action_just_pressed("move_right"):
		last_input.clear()
		last_movement_buttons.push_front(MovementDir.RIGHT)

	# Clear Movement Array
	if Input.is_action_just_released("move_left"):
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.LEFT))
	if Input.is_action_just_released("move_right"):
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.RIGHT))


func move(delta):
	_flip_sprite_in_movement_dir()
	
	# Actual movement
	if not last_movement_buttons.empty():
		if last_movement_buttons[0] == MovementDir.LEFT:
			velocity.x = -speed
		elif last_movement_buttons[0] == MovementDir.RIGHT:
			velocity.x = speed
	else:
		velocity.x = 0
		
	# Apply gravity
	velocity.y += gravity * delta
	
	# Move character
	velocity = move_and_slide(velocity,Vector2.UP)


# Lets the player step forward.
# Call while attacking
func attack_move(delta) -> void:
	_flip_sprite_in_movement_dir()
	
	if not last_movement_buttons.empty(): # If running
		if last_movement_buttons[0] == MovementDir.LEFT:
			velocity.x = -speed
		elif last_movement_buttons[0] == MovementDir.RIGHT:
			velocity.x = speed
	else: # If not running: slow step foreward
		if sprite.flip_h == true:
			velocity.x = -attack_step_speed
		else:
			velocity.x = attack_step_speed
	
	# Depending on game design Apply gravity here !!! If no gravity make sure that player is actually on floor and not 0.000000000001 above it
	# --> leads to issues with canceling windup states because player is falling
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity,Vector2.UP)


# Flip Sprite and Hitbox
func _flip_sprite_in_movement_dir() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
		hitbox_block.position.x = -abs(hitbox_block.position.x)
		hitbox_attack.position.x = -abs(hitbox_attack.position.x)
	elif velocity.x > 0:
		sprite.flip_h = false
		hitbox_block.position.x = abs(hitbox_block.position.x)
		hitbox_attack.position.x = abs(hitbox_attack.position.x)

func _physics_process(delta):
	$Label.text = $StateMachine.state.name
