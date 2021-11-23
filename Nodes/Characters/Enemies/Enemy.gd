class_name Enemy
extends KinematicBody2D

export var gravity = 100
export var direction = -1

# Different speed in different states
export var windup_speed = 40
export var walk_speed = 80
export var running_speed = 230
export var attack_speed = 300
export var recovery_speed = 120

export var chase_windup_time = 0.5
export var windup_time = 0.3
export var attack_time = 0.3
export var recovery_time = 1.5
export var attack_recovery_time = 1.5
export var chase_recovery_time = 5
export var freeze_time = 0.5
export var giveup_time = 3.0

# Attack combo with different force
export(Array, int) var attack_force = [600, 400, 800]
var attack_count : int
export var max_attack_combo = 2

onready var player_detection_area : Area2D = $PlayerDetectionArea
onready var player_follow_area : Area2D = $PlayerFollowArea
onready var attack_detection = $AttackDetection
onready var attack_area = $AttackArea
onready var damage_box = $DamageBox
onready var hitbox = $Hitbox
onready var attack_windup_detection = $AttackWindupDetection
onready var sprite : Sprite = $Sprite
onready var state_machine : StateMachine = $StateMachine
onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var wall_detection_raycast : RayCast2D = $WallDetectionRaycast
onready var enemy_detection : RayCast2D = $EnemyDetection

var velocity : Vector2
var is_attack_recovering : bool
var is_chase_recovering : bool
var attack_recover_timer
var chase_recover_timer

# Enemy has to know the player to interact with
var chased_player : Player

func _ready() -> void:
	# Set everything in the right direction
	if direction == 1:
		sprite.flip_h = true
	attack_area.position.x = attack_area.position.x * direction
	attack_detection.rotation_degrees = attack_detection.rotation_degrees * direction
	attack_windup_detection.rotation_degrees = attack_windup_detection.rotation_degrees * direction
	floor_detection_raycast.position.x = floor_detection_raycast.position.x * direction
	wall_detection_raycast.rotation_degrees = wall_detection_raycast.rotation_degrees * direction
	enemy_detection.rotation_degrees = enemy_detection.rotation_degrees * direction
	enemy_detection.position.x = enemy_detection.position.x * direction
	
	hitbox.connect("on_hit_start", self, "on_hit")
	attack_area.connect("blocked", self, "on_blocked")
	
	if direction == 1:
		$"AttackArea".direction = 0
	else:
		$"AttackArea".direction = 180
	
	# Connect Player and signals
	chased_player = $"../Player"

	_init_timer()
	

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

	
	
func _on_chase_recover_timeout():
	is_chase_recovering = false
	player_detection_area.get_child(0).disabled = false
	player_follow_area.get_child(0).disabled = false
	
func _on_attack_recover_timeout():
	is_attack_recovering = false
	
func set_attack_recover():
	is_attack_recovering = true
	attack_recover_timer.set_wait_time(attack_recovery_time)
	attack_recover_timer.start()
	
func set_chase_recover():
	is_chase_recovering = true
	chase_recover_timer.set_wait_time(chase_recovery_time)
	chase_recover_timer.start()
	player_detection_area.get_child(0).disabled = true
	player_follow_area.get_child(0).disabled = true
	
# debugging action
func _physics_process(delta):
	$Label.text = state_machine.state.name

func follow_player():
	if not moving_in_player_direction():
		flip_direction()

func moving_in_player_direction():
	if direction == 1 and chased_player.position.x < position.x or direction == -1 and chased_player.position.x > position.x:
		return false
	else:
		return true

func is_player_on_other_plattform():
	if chased_player.global_position.y < global_position.y and chased_player.is_on_floor():
		return true
	else:
		return false

func windup_move(delta):
	pass
	
func patrol(delta):
	pass
	
func chase(delta):
	pass
	
func fall():
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func move(speed):
	pass
	
func move_backwards(delta):
	pass
	
func attack_move(delta, attack_chain) -> void:
	pass
	
func knockback(delta, force, direction):
	pass
		
func flip_direction():
	direction = direction * -1
	sprite.flip_h = not sprite.flip_h
	attack_area.position.x = attack_area.position.x * -1
	attack_detection.rotation_degrees = attack_detection.rotation_degrees * -1
	attack_windup_detection.rotation_degrees = attack_windup_detection.rotation_degrees * -1
	floor_detection_raycast.position.x = floor_detection_raycast.position.x * -1
	wall_detection_raycast.rotation_degrees = wall_detection_raycast.rotation_degrees * -1
	enemy_detection.rotation_degrees = enemy_detection.rotation_degrees * -1
	enemy_detection.position.x = enemy_detection.position.x * -1
	if attack_area.direction == 180.0:
		attack_area.direction = 0.0
	else:
		attack_area.direction = 180.0



func on_hit(emitter : DamageEmitter):
	var direction
	if emitter.is_directed:
		direction = emitter.direction
	else:
		direction = rad2deg((hitbox.global_position - emitter.global_position).angle_to(Vector2(1,0)))
	direction = int((direction + 90.0)) % 360
	if direction >= 0.0 && direction <= 180.0 || direction <= -180.0 && direction >= -360.0:
		direction = -1
	else:
		direction = 1
	emitter.hit($"Hitbox")
	state_machine.transition_to("Stunned", {"force": emitter.knockback_force, "time": emitter.knockback_time, "direction": direction})


func on_blocked(receiver):
	state_machine.transition_to("Attack_Recovery")
