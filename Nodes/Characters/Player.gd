class_name Player
extends KinematicBody2D

# Movement
enum MovementDir {LEFT, RIGHT}
enum PossibleInput {ATTACK_BASIC, ATTACK_AIR, BLOCK, JUMP}

const last_movement_buttons = []
const last_input = []
var _use_joy_controller := false

var velocity := Vector2(0,0)
var can_dash := true
var can_reset_dash := true
var started_dash_in_air := false
var in_charged_attack := false

var can_hang_on_wall := true
var hang_on_wall_velocity_save := 0.0

var add_jump_gravity_damper : bool = false

var dash_cooldown_timer

onready var sound_machine : SoundMachine = $SoundMachine

export(int) var speed :int = 300
export(int) var attack_step_speed :int= 150
export(float) var air_attack_fall_speed :float = 0.2
export(float) var dash_speed :float = 1000
export(int) var gravity :int = 3000
export(int) var wall_hang_gravity : int = 300
export(int) var wall_hang_max_gravity : int = 500
export(int) var wall_hang_min_entrance_y_velocity : int = -200
export(int) var jump_impulse :int = 1000
export(int) var wall_jump_speed :int = 1000
export(int) var knock_back_impulse :int = 300
export(int) var max_attack_combo :int = 3
export(int) var attack_air_down_knockback_impulse :int = 700
export(int) var air_attack_velocity :int = 1000

# Friction is weaker the smaller the value is
export(float, 0, 1, 0.001) var acceleration : float = 0.3
export(float) var friction_ground : float = 40
export(float) var friction_ground_on_crouch : float = 20
export(float) var friction_knockback : float = 30
export(float) var friction_air : float = 20
export(float) var friction_dash: float = 5

export(float) var windup_time : float = 0.2
export(float) var charged_windup_time : float = 0.7
export(float) var block_time : float = 0.2
export(float) var attack_time : float = 0.2
export(float) var charged_attack_time : float = 0.4
export(float) var recovery_time : float = 0.2
export(float) var dash_time : float = 0.2
export(float) var dash_cooldown_time : float = 1.0
export(float) var jump_gravity_damper : float = 0.75

export(float) var wall_jump_deceleration : float = 0.1
export(float) var wall_jump_time : float = 0.5
export(Array, int) var attack_force = [200, 300, 400, 600]
export(Array, int) var attack_knockback = [0.2, 0.2, 0.5, 0.3]

onready var sprite : Sprite = $Sprite
onready var hitbox_down_attack : Area2D = $Attack_Down_Ground
onready var hitbox_up_attack : Area2D = $Attack_Up_Ground
onready var hitbox_up_attack_air : Area2D = $Attack_Up_Air
onready var hitbox_down_attack_air : Area2D = $Attack_Down_Air
onready var hitbox_attack : Area2D = $Attack
onready var hitbox : Area2D = $Hitbox
onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var charge_controller = $ChargeController

# For changing hitbox while crouching
onready var original_height_hitbox = collision_shape.shape.height
	
var direction : int = 1

signal blocked


func _ready():
	_init_timer()
	


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
	# Check if player can dash and hang on wall
	if is_on_floor():
		if started_dash_in_air:
			can_reset_dash = true
			started_dash_in_air = false
	if can_reset_dash and !started_dash_in_air:
		can_dash = true
		can_hang_on_wall = true
		hang_on_wall_velocity_save = 0.0
	# todo: add other conditions (i.e. player hits dash resetter obj)
	
	# Queue Attack in Array
	if len(last_input) <= 4:
		if Input.is_action_just_pressed("attack"):
			if not last_input.empty() and last_input[0] == PossibleInput.BLOCK:
				last_input.clear()
			if is_on_floor():
				last_input.push_front(PossibleInput.ATTACK_BASIC)
			else:
				last_input.push_front(PossibleInput.ATTACK_AIR)
		
	# Cancel attack, clear queue
	if Input.is_action_just_pressed("block"):
		last_input.clear()
		last_input.push_front(PossibleInput.BLOCK)
	elif Input.is_action_just_pressed("jump"):
		last_input.clear()
	
	# Fill movement Array
	if Input.is_action_just_pressed("move_left"):
		last_input.clear()
		last_movement_buttons.push_front(MovementDir.LEFT)
	if Input.is_action_just_pressed("move_right"):
		last_input.clear()
		last_movement_buttons.push_front(MovementDir.RIGHT)

	# Clear Movement Array
	if not Input.is_action_pressed("move_left") and last_movement_buttons.find(MovementDir.LEFT) != -1:
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.LEFT))
	if not Input.is_action_pressed("move_right") and last_movement_buttons.find(MovementDir.RIGHT) != -1:
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.RIGHT))


func move(delta):
	_flip_sprite_in_movement_dir()
	
	# Actual movement
	if abs(velocity.x) <= speed and not last_movement_buttons.empty():
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
			velocity.x += ((-attack_step_speed - velocity.x) * acceleration)
		else:
			velocity.x += ((attack_step_speed - velocity.x) * acceleration)

	if velocity.y < 0:
		velocity.y = 0;
#	velocity.y += gravity * delta * air_attack_fall_speed
	velocity.y = 20
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


## Deccelerate the player when inup or down attack in air and fall slower
## Call in _physics_process when player attacks up or down in air
func attack_updown_air_move(delta):
	_flip_sprite_in_movement_dir()
	_slow_with_friction(friction_air)
	
	# When the player is in jump the gravity shall stay until the player falls
	# Then the gravity should be less
	if velocity.y < 0:
		velocity.y += gravity * delta
	else:
		velocity.y += air_attack_fall_speed * delta * gravity
		
	velocity = move_and_slide(velocity, Vector2.UP)


## Slows the player down slowly in any direction whithout gravity.
## Call after velocity is set manually.
## Call 'dash_move' in '_physics_process' while the player is dashing.
func dash_move(delta:float, dir:Vector2, friction:float):
	_flip_sprite_in_movement_dir() #change this in dash dir
	
	# slowly slowing down
	if velocity.length() + 1 < friction:
		velocity.x = 0
	else:
		velocity -= dir.normalized() * friction
	
	velocity = move_and_slide(velocity, Vector2.UP)


## Moves the player with a special gravitational force for the wall_hang
## Call when player is in wall hang
func move_wall_hang(delta):
	_flip_sprite_in_movement_dir()
	
	if not last_movement_buttons.empty():
		if last_movement_buttons[0] == MovementDir.LEFT:
			_accelerate(-speed, acceleration)
		elif last_movement_buttons[0] == MovementDir.RIGHT:
			_accelerate(speed, acceleration)
	
	velocity.y += wall_hang_gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


## Moves the player with a deceleration instead of an acceleration
## Call when in a wall jump
func move_wall_jump(delta):
	_flip_sprite_in_movement_dir()
	_accelerate(0, wall_jump_deceleration)
	_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func move_knockback(delta):
	_slow_with_friction(friction_knockback)
	_fall(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


# Flip Sprite and Hitbox
func _flip_sprite_in_movement_dir() -> void:
	if velocity.x < 0:
		direction = -1
		sprite.flip_h = true
		hitbox_attack.scale.x = -abs(hitbox_attack.scale.x)
		hitbox_up_attack.scale.x = -abs(scale.x)
		hitbox_down_attack.scale.x = -abs(scale.x)
		hitbox_up_attack_air.scale.x = -abs(hitbox_up_attack_air.scale.x)
		hitbox_down_attack_air.scale.x = -abs(hitbox_down_attack_air.scale.x)
		hitbox_attack.direction = Vector2(-1, 0)
	elif velocity.x > 0:
		hitbox_attack.direction = Vector2(1, 0)
		direction = 1
		sprite.flip_h = false
		hitbox_attack.scale.x = abs(hitbox_attack.scale.x)
		hitbox_up_attack.scale.x = abs(scale.x)
		hitbox_down_attack.scale.x = abs(scale.x)
		hitbox_up_attack_air.scale.x = abs(hitbox_up_attack_air.scale.x)
		hitbox_down_attack_air.scale.x = abs(hitbox_down_attack_air.scale.x)


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
	if add_jump_gravity_damper:
		velocity.y += gravity * delta * jump_gravity_damper
	else:
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


## Slows the player down with friction (linear slowdown)
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
	if collision_shape.shape.height == original_height_hitbox:
		hitbox.get_child(0).shape.height = original_height_hitbox/2
		hitbox.get_child(0).position.y = hitbox.get_child(0).position.y + collision_shape.shape.height/4
		collision_shape.shape.height = original_height_hitbox/2
		collision_shape.position.y = collision_shape.position.y + collision_shape.shape.height/2


## Reset the players collisionshape when exiting crouch
## Called whenever the player leaves the crouch states
func _exit_crouch():
	collision_shape.position.y = collision_shape.position.y - collision_shape.shape.height/2
	collision_shape.shape.height = collision_shape.shape.height * 2
	hitbox.get_child(0).shape.height = collision_shape.shape.height
	hitbox.get_child(0).position.y = hitbox.get_child(0).position.y - collision_shape.shape.height/4
	


func _physics_process(delta):
	$Label.text = $StateMachine.state.name


func on_hit(emitter : DamageEmitter):
	if in_charged_attack:
		# only damage
		pass
	else:
		var direction_x
		if is_equal_approx(emitter.direction.x, 0.0):
			direction_x = (hitbox.global_position  - emitter.global_position).x 
		else:
			direction_x = emitter.direction.x
		direction_x = -1.0 if emitter.direction.x < 0.0 else 1.0
		if $StateMachine.state.name == "Block" and not direction_x == self.direction:
			emit_signal("blocked")
			emitter.was_blocked($"Hitbox")
			sound_machine.play_sound("Blocking", false)
		else:
			$StateMachine.transition_to("Stunned", {"force" :emitter.knockback_force, "time": emitter.knockback_time, "direction": direction_x})
			emitter.hit($"Hitbox")
			sound_machine.play_sound("Hit", false)


# Timer
func _init_timer():
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.set_autostart(false)
	dash_cooldown_timer.set_one_shot(true)
	dash_cooldown_timer.set_timer_process_mode(0)
	dash_cooldown_timer.connect("timeout", self, "_on_dash_cooldown_timeout")
	self.add_child(dash_cooldown_timer)


func _on_dash_cooldown_timeout():
	dash_cooldown_timer.stop()
	can_reset_dash = true


func start_dash_cooldown():
	dash_cooldown_timer.set_wait_time(dash_cooldown_time)
	dash_cooldown_timer.start()


func _on_Attack_Down_Air_hit(receiver):
	velocity.y = -attack_air_down_knockback_impulse
