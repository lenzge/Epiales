class_name Player
extends KinematicBody2D

# Movement
enum MovementDir {LEFT, RIGHT}
enum PossibleInput {ATTACK_BASIC, BLOCK, JUMP}

const last_movement_buttons = []
const last_input = []

var velocity := Vector2(0,0)
var can_dash := true

export var speed = 300
export var attack_step_speed = 150
export var dash_speed = 700
export var max_attack_combo = 3
export var gravity = 3000
export var jump_impulse = 1000

export var windup_time : float = 0.1
export var block_time : float = 0.3
export var attack_time : float = 0.2
export var recovery_time : float = 0.2
export var dash_time : float = 0.3

export(Array, int) var attack_force = [200, 300, 400]
export(Array, int) var attack_knockback = [0.2, 0.2, 0.5]

onready var sprite : Sprite = $Sprite
onready var hitbox_attack : Area2D = $Attack
onready var hitbox : Area2D = $Hitbox


var direction : int = 1


func get_direction():
	return velocity.length()
	# Below returns zero even if player is moving but left and right are pressed.
	#return (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))


func pop_combat_queue():
	return last_input.pop_back()


func _process(delta):
	# Check if player can dash
	if is_on_floor():
		can_dash = true
	# todo: add other conditions (i.e. player hits dash resetter obj)
	
	# Queue Attack in Array
	if len(last_input) <= 4:
		if Input.is_action_just_pressed("attack"):
			if not last_input.empty() and last_input[0] == PossibleInput.BLOCK:
				last_input.clear()
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
		
	fall(delta)

func fall(delta):
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

## Moves the player at dash speed
##
## Call 'dash_move' in '_physics_process' while the player is dashing.
func dash_move(delta):
	_flip_sprite_in_movement_dir()
	
	if sprite.flip_h:
		velocity.x = -dash_speed
	else:
		velocity.x = dash_speed
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)



# Flip Sprite and Hitbox
func _flip_sprite_in_movement_dir() -> void:
	if not last_movement_buttons.empty():
		if last_movement_buttons[0] == MovementDir.LEFT:#velocity.x < 0:
			direction = -1
			sprite.flip_h = true
			hitbox_attack.position.x = -abs(hitbox_attack.position.x)
			hitbox_attack.direction = 0
		elif last_movement_buttons[0] == MovementDir.RIGHT:#velocity.x > 0:
			direction = 1
			sprite.flip_h = false
			hitbox_attack.position.x = abs(hitbox_attack.position.x)
			hitbox_attack.direction = 180

func knockback(delta, force, direction):
	velocity.x = force * direction
	fall(delta)

func _physics_process(delta):
	$Label.text = $StateMachine.state.name


func on_hit(emitter : DamageEmitter):
	var direction
	if emitter.is_directed:
		direction = emitter.direction
	else:
		direction = rad2deg((hitbox.global_position - emitter.global_position).angle_to(Vector2(1,0)))
	direction = int((direction + 90.0)) % 360
	if direction >= 0.0 && direction <= 180.0 || direction <= -180.0 && direction >= -360.0:
		direction = 1
	else:
		direction = -1
	if $StateMachine.state.name == "Block" and not direction == self.direction:
		emitter.block($"Hitbox")
		print("PLAYER: block")
	else:
		$StateMachine.transition_to("Stunned", {"force" :emitter.knockback_force, "time": emitter.knockback_time, "direction": direction})
		emitter.hit($"Hitbox")

