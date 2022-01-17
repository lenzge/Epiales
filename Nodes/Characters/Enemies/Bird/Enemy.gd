class_name Enemy
extends KinematicBody2D

export var gravity = 100
export var direction = -1
export var health_points = 1000

# Different speed in different states
export var windup_speed = 40
export var walk_speed = 80
export var running_speed = 230
export var attack_speed = 300
export var recovery_speed = 120

# Time the diffrent states are active
export var chase_windup_time = 0.5
export var windup_time = 0.3
export var attack_time = 0.3
export var freeze_time = 0.5
export var recovery_time = 1.5
# Time till enemy can attack again
export var attack_cooldown_time = 1.5
# Time till enemy can chase again
export var chase_cooldown_time = 5
# Time till enemy stops chasing
export var giveup_time = 3.0
# Time between no health and despawning
export var dying_time = 3.0

# Attack combo with different force
export(Array, int) var attack_force = [600, 400, 800]
export(Array, int) var attack_damage = [20]
export var max_attack_combo = 2

onready var state_machine : StateMachine = $StateMachine
onready var sprite : Sprite = $Sprite
onready var health_bar = $HealthBar
onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var floor_back_detection_raycast : RayCast2D = $FloorBackDetectionRaycast
onready var wall_detection_raycast : RayCast2D = $WallDetectionRaycast
onready var enemy_detection_raycast : RayCast2D = $EnemyDetectionRaycast

# Puppet doesn't follow player, if a wall is in between
onready var wall_between_raycast : RayCast2D = $WallBetweenRaycast
# Puppet starts to follow player, when player entered
onready var player_follow_area : Area2D = $PlayerFollowArea
# Puppet starts to chase player, when player entered
onready var player_detection_area : Area2D = $PlayerDetectionArea
# Enemy transition to windup, if player is detected
onready var attack_windup_detection : RayCast2D = $AttackWindupDetection
# Enemy transition to attack, if player is detected
onready var attack_detection : RayCast2D = $AttackDetection
# Area, where Enemy attack deals damage
onready var attack_area : Area2D = $AttackArea
# Whole body of the enemy deals damage (always)
onready var damage_box : Area2D = $DamageBox
# Area, where the enemy gets damage (body)
onready var hitbox : Area2D = $Hitbox

var attack_count : int
var velocity : Vector2
var chased_player : Player

var is_registered_by_player : bool = false
var deal_nightmare : bool = false

# Timer for overall cooldown
var is_attack_recovering : bool
var is_chase_recovering : bool
var is_flip_cooldown : bool
var attack_recover_timer
var chase_recover_timer
var flip_cooldown_timer

func _ready() -> void:
	# Set everything in the right direction
	if direction == 1:
		attack_area.direction = Vector2(1, 0)
	else:
		attack_area.direction = Vector2(-1, 0)
	_set_all_in_right_direction(direction)
	
	# Connect Signals
	hitbox.connect("on_hit_start", self, "on_hit")
	attack_area.connect("blocked", self, "on_blocked")
	owner.connect("player_spawned", self, "_on_player_spawned")
	health_bar.connect("zero_hp", self, "_on_zero_hp")
	
	_init_timer()
	health_bar.set_max_health(health_points)
	
# Debugging action
func _physics_process(delta):
	$Label.text = state_machine.state.name

func follow_player():
	if not is_moving_in_player_direction():
		flip_direction()

func is_moving_in_player_direction() -> bool:
	if direction == 1 and chased_player.position.x < position.x or direction == -1 and chased_player.position.x > position.x:
		return false
	else:
		return true

func is_player_on_other_plattform() -> bool:
	if chased_player.global_position.y + chased_player._position.y < global_position.y and chased_player.is_on_floor():
		return true
	else:
		return false

func fall():
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
	

# Different move methods are implemented in child classes
func windup_move(delta):
	pass
	
func patrol(delta):
	pass
	
func chase(delta):
	pass

func move(speed):
	pass
	
func move_backwards(delta):
	pass
	
func attack_move(delta, attack_chain):
	pass
	
func knockback(delta, force, direction):
	pass
		
		
		
func flip_direction():
	if not is_flip_cooldown:
		set_flip_cooldown()
		direction = direction * -1
		sprite.flip_h = not sprite.flip_h
		_set_all_in_right_direction(-1)
		attack_area.direction = attack_area.direction * -1
	else:
		state_machine.transition_to("Freeze")


func on_hit(emitter : DamageEmitter):
	var direction_x
	if is_equal_approx(emitter.direction.x, 0.0):
		direction_x = (hitbox.global_position - emitter.global_position).x 
	else:
		direction_x = emitter.direction.x
	emitter.hit(hitbox)
	health_bar.get_damage(emitter.knockback_force)
	state_machine.transition_to("Stunned", {"force": emitter.knockback_force, "time": emitter.knockback_time, "direction": (-1.0 if direction_x < 0.0 else 1.0)})


func _on_zero_hp():
	state_machine.transition_to("Die")

func on_blocked(receiver):
	state_machine.transition_to("Attack_Recovery")
	

func _set_all_in_right_direction(direction):
	attack_area.position.x = attack_area.position.x * direction
	attack_detection.rotation_degrees = attack_detection.rotation_degrees * direction
	attack_windup_detection.rotation_degrees = attack_windup_detection.rotation_degrees * direction
	floor_detection_raycast.position.x = floor_detection_raycast.position.x * direction
	floor_back_detection_raycast.position.x = floor_back_detection_raycast.position.x * direction
	wall_detection_raycast.rotation_degrees = wall_detection_raycast.rotation_degrees * direction
	enemy_detection_raycast.rotation_degrees = enemy_detection_raycast.rotation_degrees * direction
	enemy_detection_raycast.position.x = enemy_detection_raycast.position.x * direction

# Timer
func _init_timer():
	chase_recover_timer = Timer.new()
	chase_recover_timer.set_autostart(false)
	chase_recover_timer.set_one_shot(true)
	chase_recover_timer.set_timer_process_mode(0)
	chase_recover_timer.connect("timeout", self, "_on_chase_recover_timeout")
	self.add_child(chase_recover_timer)
	attack_recover_timer = Timer.new()
	attack_recover_timer.set_autostart(false)
	attack_recover_timer.set_one_shot(true)
	attack_recover_timer.set_timer_process_mode(0)
	attack_recover_timer.connect("timeout", self, "_on_attack_recover_timeout")
	self.add_child(attack_recover_timer)
	flip_cooldown_timer = Timer.new()
	flip_cooldown_timer.set_autostart(false)
	flip_cooldown_timer.set_one_shot(true)
	flip_cooldown_timer.set_timer_process_mode(0)
	flip_cooldown_timer.connect("timeout", self, "_on_flip_cooldown_timeout")
	self.add_child(flip_cooldown_timer)

func _on_chase_recover_timeout():
	is_chase_recovering = false
	player_detection_area.get_child(0).disabled = false
	player_follow_area.get_child(0).disabled = false
	
func _on_attack_recover_timeout():
	is_attack_recovering = false
	
func _on_flip_cooldown_timeout():
	is_flip_cooldown = false
	
func set_attack_recover():
	is_attack_recovering = true
	attack_recover_timer.set_wait_time(attack_cooldown_time)
	attack_recover_timer.start()
	
func set_chase_recover():
	is_chase_recovering = true
	chase_recover_timer.set_wait_time(chase_cooldown_time)
	chase_recover_timer.start()
	player_detection_area.get_child(0).disabled = true
	player_follow_area.get_child(0).disabled = true
	
func set_flip_cooldown():
	is_flip_cooldown = true
	flip_cooldown_timer.set_wait_time(0.3)
	flip_cooldown_timer.start()

func _on_player_spawned():
	chased_player = owner.player_instance
	
func despawning():
	queue_free()
	
