class_name Player
extends KinematicBody2D

# Movement
enum MovementDir {LEFT, RIGHT}
enum PossibleInput {ATTACK_BASIC, ATTACK_AIR, BLOCK, JUMP}

# Wall hang/jump
enum Walls {NONE, LEFT, RIGHT}

# needed for running turn
var direction : int = 1
var prev_direction : int = 1

const last_movement_buttons = []
const last_input = []
var _use_joy_controller := false

var velocity := Vector2(0,0)
var can_dash := true
var can_reset_dash := true
var started_dash_in_air := false
var in_charged_attack := false
var attack_count := 1 # Needs to be 1 because increment happens after the attack
var attack_direction := 0 # Set to 1 or -1 when in attack, so the player can't turn
var in_air_attack

var can_hang_on_wall := true
var raycasts_enabled := false
var on_wall = Walls.NONE
var wall_jump_vector := Vector2(0, 0)

var add_jump_gravity_damper : bool = false

var dash_cooldown_timer

var transition_to_stunned : bool = false
var stunned_knockback_force : float = 0.0
var stunned_knockback_time : float = 0.0
var stunned_direction_x : float = 0.0

# The current "health"
var nightmare : float = 0
var enemies_in_range : int = 0

onready var sound_machine : SoundMachine = $SoundMachine
onready var camera = $Camera

export(int) var speed :int = 300
export(int) var attack_step_speed :int= 150
export(float) var air_attack_fall_speed :float = 0.1
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
export(float) var friction_leap_jump: float = 10

export(float) var dash_time : float = 0.2
export(float) var charged_dash_time : float = 0.7
export(float) var dash_cooldown_time : float = 1.0
export(float) var leap_jump_time : float = 0.8
export(float) var jump_gravity_damper : float = 0.75

export(float) var wall_jump_deceleration : float = 0.1
export(float) var wall_jump_time : float = 0.5
export(float, 0, 1) var wall_jump_additional_y : float = 0.5
export(bool) var dash_reset_after_wallhang : bool = true
export(Array, int) var attack_force = [20, 30, 40, 60] # attack chain + charged attack
export(int) var attack_force_up = 10
export(int) var attack_force_down = 10
export(int) var charged_dash_damage = 80
export(Array, int) var attack_knockback = [0.2, 0.2, 0.5, 0.3]

export(float) var max_nightmare : float = 60.0
export(float) var nightmare_on_hit_reduction : float = 10.0
export(float) var nightmare_enemy_surronding_increment : float = 0.1
export(float) var nightmare_spikes_increment : float = 10.0

onready var sprite : Sprite = $Sprite
onready var particles : Sprite = $ParticleSystem
onready var hitbox_down_attack : Area2D = $Attack_Down_Ground
onready var hitbox_up_attack : Area2D = $Attack_Up_Ground
onready var hitbox_up_attack_air : Area2D = $Attack_Up_Air
onready var hitbox_down_attack_air : Area2D = $Attack_Down_Air
onready var hitbox_attack : Area2D = $Attack
onready var hitbox : Area2D = $Hitbox
onready var hitbox_charged_dash: Area2D = $Charged_Dash
onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var charge_controller = $ChargeController


onready var ray_left : RayCast2D = $RayLeft
onready var ray_right : RayCast2D = $RayRight


# Needed for the wall hang
onready var player_size_x = collision_shape.shape.extents.x

# Enemy needs to know
onready var _position = collision_shape.position
	
signal blocked
signal charged_action
signal nightmare_changed

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
		if raycasts_enabled:
			enable_Raycasts(false)
		if started_dash_in_air:
			can_reset_dash = true
			started_dash_in_air = false
	else:
		if !raycasts_enabled:
			enable_Raycasts(true)
	if can_reset_dash and !started_dash_in_air:
		can_dash = true
		can_hang_on_wall = true
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
	
	if transition_to_stunned:
		transition_to_stunned = false
		$StateMachine.transition_to("Stunned", {"force" :stunned_knockback_force, "time": stunned_knockback_time, "direction": stunned_direction_x})
	
	# If enemies are nearby increase the nightmare
	if enemies_in_range > 0:
		increment_nightmare(nightmare_enemy_surronding_increment)
	

# Normal movement on ground
# Player is not allowed to turn around while attack windup
func move(delta):
	_flip_sprite_in_movement_dir()
	
	# Actual movement with acceleration and friction
	if abs(velocity.x) <= speed and not last_movement_buttons.empty():
		if last_movement_buttons[0] == MovementDir.LEFT and not attack_direction == 1:
			_accelerate(-speed, acceleration)
		elif last_movement_buttons[0] == MovementDir.RIGHT and not attack_direction == -1:
			_accelerate(speed, acceleration)
	else:
		_slow_with_friction(friction_ground)
		
	_apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


# Movement while basic attacking on ground (step forward)
# Player is not allowed to turn around while attacking
func basic_attack_move(delta) -> void:
	_flip_sprite_in_movement_dir()
	
	# If running use normal speed
	if not last_movement_buttons.empty(): 
		if last_movement_buttons[0] == MovementDir.LEFT and not attack_direction == 1:
			_accelerate(-speed, acceleration)
		elif last_movement_buttons[0] == MovementDir.RIGHT and not attack_direction == -1:
			_accelerate(speed, acceleration)
	# If not running: slow step foreward
	else: 
		velocity.x += ((attack_step_speed*attack_direction - velocity.x) * acceleration)
	

	_apply_gravity(delta)
	velocity = move_and_slide(velocity,Vector2.UP)

# Decelerated movement when the player can't move actively, but physics should be applied
# Friction is set to ground_friction by default, in crouch state the second arg has to be set to true
func decelerate_move_ground(delta, crouch:bool = false):
	_flip_sprite_in_movement_dir()
	if not crouch:
		_slow_with_friction(friction_ground)
	else:
		_slow_with_friction(friction_ground_on_crouch)
	_apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	

# Decelerate the player when in any air attack to fall slower
func air_attack_move(delta):
	_flip_sprite_in_movement_dir()
	_slow_with_friction(friction_air)
	
	# When the player is in jump the gravity shall stay until the player falls
	# Then the gravity should be less
	if velocity.y < 0:
		velocity.y += gravity * delta
	else:
#		velocity.y += air_attack_fall_speed * delta * gravity
		velocity.y = 20
		
	velocity = move_and_slide(velocity, Vector2.UP)

# Applies falling physics in air while the player can't move actively 
func fall_straight(delta):
	_flip_sprite_in_movement_dir()
	_slow_with_friction(friction_air)
	_apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

## Called if jumping while dashing
## Only adds gravity to dash movement
func move_leap_jump(delta:float, dir:Vector2, friction:float):
	_apply_gravity(delta)
	dash_move(delta, dir, friction)


## Slows the player down slowly in any direction whithout gravity.
## Call after velocity is set manually.
## Call 'dash_move' in '_physics_process' while the player is dashing.
func dash_move(delta:float, dir:Vector2, friction:float):
	_flip_sprite_in_movement_dir() #change this in dash dir
	# slowly slowing down
	velocity -= dir.normalized() * friction
	# Check for wrap around effect 
	# (friction overpowers velocity --> change of velocity sign)
	if velocity.x * dir.x <= 0:
		velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector2.UP)


## Test if the player is on a wall
## Used for wall detection in wall hang and wall jump
func can_change_to_wallhang() -> bool:
	var ret_value = false
	on_wall = Walls.NONE
	
	# test if one of the rays collides with a wall (right-ray dominant)
	if raycasts_enabled:
		if ray_right.is_colliding():
			if is_tile_wall(ray_right, ray_right.get_collision_point()):
				ret_value = true
				on_wall = Walls.RIGHT

		elif ray_left.is_colliding():
			var collision_point = ray_left.get_collision_point()
			# set collision_point inside the tile
			collision_point.x -= 1
			if is_tile_wall(ray_left, collision_point):
				ret_value = true
				on_wall = Walls.LEFT
	
	return ret_value


## Test if a tile that collides with a raycast is a tile without one-way collision
## Used for the raycasts of the wall hang (in the method "can_change_to_wallhang()"
func is_tile_wall(ray: RayCast2D, collision_point: Vector2) -> bool:
	
	var collider = ray.get_collider()
	
	# get tile of tileset
	var tile_pos = collider.world_to_map(collider.to_local(collision_point))
	var tile_tex_coords = collider.get_cell_autotile_coord(tile_pos.x, tile_pos.y)
	var tile_id = (tile_tex_coords.y * 8) + tile_tex_coords.x
	
	# get tileset
	var tile_map_id = collider.get_cellv(tile_pos)
	
	# test if the tile has a one_way collision and return the negated value
	return !ray.get_collider().tile_set.tile_get_shape_one_way(ray.get_collider().get_cellv(tile_pos), tile_id) and tile_map_id != TileMap.INVALID_CELL


## Moves the player with a special gravitational force for the wall_hang
## Call when player is in wall hang
func move_wall_hang(delta):
	_flip_sprite_in_movement_dir()
	velocity.y += wall_hang_gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


## Moves the player with a deceleration instead of an acceleration
## Call when in a wall jump
func move_wall_jump(delta):
	_flip_sprite_in_movement_dir()
	_accelerate(0, wall_jump_deceleration)
	_apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func move_knockback(delta):
	_slow_with_friction(friction_knockback)
	_apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


# Flip Sprite and Hitbox
func _flip_sprite_in_movement_dir() -> void:
	prev_direction = direction
	if velocity.x < 0:
		direction = -1
		sprite.flip_h = true
		particles.flip_h = true
	elif velocity.x > 0:
		direction = 1
		sprite.flip_h = false
		particles.flip_h = false
	
	hitbox_attack.direction = Vector2(direction, 0)
	hitbox_attack.scale.x = abs(hitbox_attack.scale.x) * direction
	hitbox_up_attack.scale.x = abs(scale.x) * direction
	hitbox_down_attack.scale.x = abs(scale.x) * direction
	hitbox_up_attack_air.scale.x = abs(hitbox_up_attack_air.scale.x) * direction
	hitbox_down_attack_air.scale.x = abs(hitbox_down_attack_air.scale.x) * direction
	hitbox_charged_dash.scale.x = abs(hitbox_charged_dash.scale.x) * direction

	
func set_knockback(force, direction):
	velocity.x = force * direction


func knockback(delta, force, direction):
	velocity.x = force * direction
	_apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)


## Applies gravity to the player
func _apply_gravity(delta):
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

# Is called when the player makes a charged attack
func charge():
	in_charged_attack = true
	#attack_count = 4 # deleted this to use this method for charged dash
	emit_signal("charged_action")


func _physics_process(delta):
	$Label.text = $StateMachine.state.name
	# hitbox equals collisionshape
	hitbox.get_child(0).scale = collision_shape.scale
	hitbox.get_child(0).position = collision_shape.position


func on_hit(emitter : DamageEmitter):
	if in_charged_attack:
		# only damage
		increment_nightmare(emitter.damage_amount)
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
			transition_to_stunned = true
			stunned_knockback_force = emitter.knockback_force
			stunned_knockback_time = emitter.knockback_time
			stunned_direction_x = direction_x
			emitter.hit($"Hitbox")
			sound_machine.play_sound("Hit", false)
			
			increment_nightmare(emitter.damage_amount)


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


func enable_Raycasts(value : bool):
	ray_left.enabled = value
	ray_right.enabled = value
	raycasts_enabled = value


func reduce_nightmare(reduction: float) -> void:
	if nightmare > (0 + reduction):
		nightmare -= reduction
	else:
		nightmare = 0
	emit_signal("nightmare_changed")


func increment_nightmare(increment: float) -> void:
	if (nightmare + increment) < max_nightmare:
		nightmare += increment
	else:
		nightmare = max_nightmare
	emit_signal("nightmare_changed")
	
	if nightmare >= max_nightmare:
		$StateMachine.transition_to("Die")


func add_enemy_in_range():
	enemies_in_range += 1


func remove_enemy_in_range():
	if enemies_in_range > 0:
		enemies_in_range -= 1


func _on_Attack_Down_Air_hit(receiver):
	if receiver.receiver.state_machine.state.name != "Die":
		velocity.y = -attack_air_down_knockback_impulse
		reduce_nightmare(nightmare_on_hit_reduction)


func _on_Attack_Up_Air_hit(receiver):
	if receiver.receiver.state_machine.state.name != "Die":
		reduce_nightmare(nightmare_on_hit_reduction)


func _on_Attack_Down_Ground_hit(receiver):
	if receiver.receiver.state_machine.state.name != "Die":
		reduce_nightmare(nightmare_on_hit_reduction)


func _on_Attack_Up_Ground_hit(receiver):
	if receiver.receiver.state_machine.state.name != "Die":
		reduce_nightmare(nightmare_on_hit_reduction)


func _on_Attack_hit(receiver):
	if receiver.receiver.state_machine.state.name != "Die":
		reduce_nightmare(nightmare_on_hit_reduction)


func _on_Charged_Dash_hit(receiver):
	if receiver.receiver.state_machine.state.name != "Die":
		reduce_nightmare(nightmare_on_hit_reduction)


func _on_AnimationPlayer_animation_finished(param):
	pass


