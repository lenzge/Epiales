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
var can_reset_dash := true
var started_dash_in_air := false

var can_hang_on_wall := true
var hang_on_wall_velocity_save := 0.0

var dash_cooldown_timer

export(int) var speed :int = 300
export(int) var attack_step_speed :int= 150
export(Vector2) var dash_speed :Vector2 = Vector2(1000, 1000)
export(int) var gravity :int = 3000
export(int) var wall_hang_gravity : int = 300
export(int) var wall_hang_max_gravity : int = 500
export(int) var wall_hang_min_entrance_y_velocity : int = -200
export(int) var jump_impulse :int = 1000
export(int) var wall_jump_speed :int = 1000
export(int) var knock_back_impulse :int = 300
export(int) var max_attack_combo :int = 3

# Friction is weaker the smaller the value is
export(float, 0, 1, 0.001) var acceleration : float = 0.3
export(float) var friction_ground : float = 40
export(float) var friction_knockback : float = 20
export(float, 0, 1, 0.001) var acceleration_after_dash : float = 0.05

export(float) var windup_time : float = 0.2
export(float) var charged_windup_time : float = 0.7
export(float) var block_time : float = 0.2
export(float) var attack_time : float = 0.2
export(float) var charged_attack_time : float = 0.4
export(float) var recovery_time : float = 0.2
export(float) var dash_time : float = 0.2
export(float) var dash_cooldown_time : float = 1.0

export(float) var wall_jump_deceleration : float = 0.1
export(float) var wall_jump_time : float = 0.5
export(Array, int) var attack_force = [200, 300, 400]
export(Array, int) var attack_knockback = [0.2, 0.2, 0.5]

onready var sprite : Sprite = $Sprite
onready var hitbox_attack : Area2D = $Attack
onready var hitbox : Area2D = $Hitbox
onready var charge_ontroller = $ChargeController

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
	if can_reset_dash:
		can_dash = true
		can_hang_on_wall = true
		hang_on_wall_velocity_save = 0.0
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
	if not Input.is_action_pressed("move_left"):
		last_movement_buttons.remove(last_movement_buttons.find(MovementDir.LEFT))
	if not Input.is_action_pressed("move_right"):
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
			velocity.x += ((-attack_step_speed - velocity.x) * acceleration)
		else:
			velocity.x += ((attack_step_speed - velocity.x) * acceleration)
	
	# Depending on game design Apply gravity here !!! If no gravity make sure that player is actually on floor and not 0.000000000001 above it
	# --> leads to issues with canceling windup states because player is falling
	_fall(delta)
	
	velocity = move_and_slide(velocity,Vector2.UP)


## Moves the player at dash speed
## Call 'dash_move' in '_physics_process' while the player is dashing.
func dash_move(delta : float, dir : Vector2, after_dash : bool):
	_flip_sprite_in_movement_dir()

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
	elif velocity.x > 0:
		direction = 1
		sprite.flip_h = false
		hitbox_attack.position.x = abs(hitbox_attack.position.x)


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
		emit_signal("blocked")
		emitter.was_blocked($"Hitbox")
	else:
		$StateMachine.transition_to("Stunned", {"force" :emitter.knockback_force, "time": emitter.knockback_time, "direction": direction})
		emitter.hit($"Hitbox")


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
