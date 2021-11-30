class_name Player
extends KinematicBody2D

# Movement
enum MovementDir {LEFT, RIGHT}
enum PossibleInput {ATTACK_BASIC, BLOCK, JUMP}

const last_movement_buttons = []
const last_input = []
var _use_joy_controller := false

var velocity := Vector2(0,0)
var can_dash := true

onready var collision_shape_original_height : float = $CollisionShape2D.shape.height
onready var collision_shape_original_pos_y : float = $CollisionShape2D.position.y

export(int) var speed :int = 300
export(int) var attack_step_speed :int= 150
export(Vector2) var dash_speed :Vector2 = Vector2(1000, 1000)
export(int) var gravity :int = 3000
export(int) var jump_impulse :int = 1000
export(int) var knock_back_impulse :int = 300
export(int) var max_attack_combo :int = 3

# Friction is weaker the smaller the value is
export(float, 0, 1, 0.001) var acceleration : float = 0.3
export(float) var friction_ground : float = 40
export(float) var friction_ground_on_crouch : float = 20
export(float) var friction_knockback : float = 20
export(float, 0, 1, 0.001) var acceleration_after_dash : float = 0.05

export(float) var windup_time : float = 0.2
export(float) var block_time : float = 0.2
export(float) var attack_time : float = 0.2
export(float) var recovery_time : float = 0.2
export(float) var dash_time : float = 0.2
export(float) var dash_recovery_time : float = 0.2

export(Array, int) var attack_force = [200, 300, 400]
export(Array, int) var attack_knockback = [0.2, 0.2, 0.5]

onready var sprite : Sprite = $Sprite
onready var hitbox_block : CollisionShape2D = $Block/HitboxBlock
onready var hitbox_down_attack : Area2D = $Attack_Down_Ground
onready var hitbox_up_attack : Area2D = $Attack_Up_Ground
onready var hitbox_attack : Area2D = $Attack
onready var hitbox : Area2D = $Hitbox


var direction : int = 1

func _input(event):
	if (event is InputEventKey or 
		event is InputEventMouse):
			_use_joy_controller = false
	
	elif (event is InputEventJoypadButton or
		event is InputEventJoypadMotion):
			_use_joy_controller = true


func get_direction():
	return velocity.length()


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
			_accelerate(-speed, acceleration)
		elif last_movement_buttons[0] == MovementDir.RIGHT:
			_accelerate(speed, acceleration)
	else:
		_slow_with_friction(friction_ground)
		
	_fall(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)


# Lets the player step forward.
# Call while attacking
func attack_move(delta) -> void:
	_flip_sprite_in_movement_dir()
	
	if not last_movement_buttons.empty(): # If running
		if last_movement_buttons[0] == MovementDir.LEFT:
			_accelerate(-speed, acceleration)
		elif last_movement_buttons[0] == MovementDir.RIGHT:
			_accelerate(speed, acceleration)
	else: # If not running: slow step foreward
		if sprite.flip_h == true:
			velocity.x = ((-attack_step_speed - velocity.x) * acceleration)
		else:
			velocity.x = ((attack_step_speed - velocity.x) * acceleration)
	
	# Depending on game design Apply gravity here !!! If no gravity make sure that player is actually on floor and not 0.000000000001 above it
	# --> leads to issues with canceling windup states because player is falling
	_fall(delta)
	
	velocity = move_and_slide(velocity,Vector2.UP)


## Deccelerates the player when in up or down Attack on ground or in crouch
## Call in _physics_process when player attacks up or down on ground
func attack_up_ground_move(delta) -> void:
	_flip_sprite_in_movement_dir()
	_slow_with_friction(friction_ground)
	_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


## Basically the same as "attack_up_ground_move()" but with another friction
func crouch_move(delta) -> void:
	_flip_sprite_in_movement_dir()
	_slow_with_friction(friction_ground_on_crouch)
	_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


## Moves the player at dash speed
## Call 'dash_move' in '_physics_process' while the player is dashing.
func dash_move(delta : float, dir : Vector2, after_dash : bool):
	_flip_sprite_in_movement_dir()
	
	if after_dash:
		# Move normally only with less friction
		if not last_movement_buttons.empty():
			if last_movement_buttons[0] == MovementDir.LEFT:
				_accelerate(-speed, acceleration_after_dash)
			elif last_movement_buttons[0] == MovementDir.RIGHT:
				_accelerate(speed, acceleration_after_dash)
		else:
			_accelerate(0, acceleration_after_dash)
		
		_fall(delta)
	
	else:
		if _use_joy_controller:
			if dir.x == 0 and dir.y == 0:
				if sprite.flip_h:
					dir.x = -1
				else:
					dir.x = 1
			velocity += ((dash_speed * dir.normalized() - velocity) * acceleration)
		else:
			if sprite.flip_h:
				velocity.x += ((-dash_speed.x - velocity.x) * acceleration)
			else:
				velocity.x += ((dash_speed.x - velocity.x) * acceleration)
	#_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func move_knockback(delta):
	_slow_with_friction(friction_knockback)
	_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


# Flip Sprite and Hitbox
func _flip_sprite_in_movement_dir() -> void:
	#if not last_movement_buttons.empty():
		#if last_movement_buttons[0] == MovementDir.LEFT:#velocity.x < 0:
			#direction = -1
			#sprite.flip_h = true
			#hitbox_attack.position.x = -abs(hitbox_attack.position.x)
			#hitbox_attack.direction = 0
		#elif last_movement_buttons[0] == MovementDir.RIGHT:#velocity.x > 0:
			#direction = 1
			#sprite.flip_h = false
			#hitbox_attack.position.x = abs(hitbox_attack.position.x)
			#hitbox_attack.direction = 180
	if velocity.x < 0:
		direction = -1
		sprite.flip_h = true
		hitbox_attack.position.x = -abs(hitbox_attack.position.x)
		hitbox_up_attack.scale.x = -abs(scale.x)
		hitbox_down_attack.scale.x = -abs(scale.x)
	elif velocity.x > 0:
		direction = 1
		sprite.flip_h = false
		hitbox_attack.position.x = abs(hitbox_attack.position.x)
		hitbox_up_attack.scale.x = abs(scale.x)
		hitbox_down_attack.scale.x = abs(scale.x)


func set_knockback(force, direction):
	#if sprite.flip_h == true:
	velocity.x = force * direction
	#else:
		#velocity.x = -force


func knockback(delta, force, direction):
	velocity.x = force * direction
	_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


## Applies gravity to the player
func _fall(delta):
	velocity.y += gravity * delta


## Accelerates the player (like function 1/x)
func _accelerate(target_speed : float, _acceleration : float) -> void:
	# Limit velocity to target speed
	var limited_accel
	
	if _use_joy_controller:
		limited_accel = ((target_speed * ( Input.get_action_strength("move_left") + Input.get_action_strength("move_right") ) - velocity.x )* _acceleration)
	else:
		limited_accel = ((target_speed - velocity.x) * _acceleration)
	velocity.x += limited_accel


## Slows the player down with friction (linear lowdonw)
func _slow_with_friction(friction : float) -> void:
	if abs(velocity.x) - (friction + 1) <= friction:
		velocity.x = 0
	else:
		if velocity.x < 0:
			velocity.x += friction
		else:
			velocity.x -= friction


## Change the players collisionshape when in entering crouch
## Called on entering the crouch state
func _enter_crouch():
	# change the height of the player's collisionshape to half of it
	var collision_shape = $CollisionShape2D
	if collision_shape_original_height == collision_shape.shape.height:
		collision_shape.shape.height /= 2
		
		var collision_pos_y_change = collision_shape.shape.height / 2
		
		collision_shape.position.y += collision_pos_y_change
		$Hitbox/CollisionShape2D.position.y += collision_pos_y_change


## Reset the players collisionshape when exiting crouch
## Called whenever the player leaves the crouch states
func _exit_crouch():
	var collision_shape = $CollisionShape2D
	collision_shape.shape.height = collision_shape_original_height
	collision_shape.position.y = collision_shape_original_pos_y
	$Hitbox/CollisionShape2D.position.y = collision_shape_original_pos_y


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
		emitter.was_blocked($"Hitbox")
		print("PLAYER: block")
	else:
		$StateMachine.transition_to("Stunned", {"force" :emitter.knockback_force, "time": emitter.knockback_time, "direction": direction})
		emitter.hit($"Hitbox")

