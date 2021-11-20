class_name Puppet
extends KinematicBody2D


export var gravity = 100
export var direction = -1

# Different speed in different states
export var windup_speed = 40
export var walk_speed = 80
export var running_speed = 230
export var attack_speed = 300

export var windup_time = 0.3
export var attack_time = 0.3
export var recovery_time = 1.5

# Attack combo with different force
export(Array, int) var attack_force = [400, 500, 400]
export(Array, int) var attack_knockback = [0.4, 0.2, 0.4]
export var max_attack_combo = 2


onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var wall_detection_raycast : RayCast2D = $WallDetectionRaycast
onready var player_detection_area : Area2D = $PlayerDetectionArea
onready var attack_detection = $AttackDetection
onready var attack_area  = $AttackArea
onready var hitbox = $Hitbox
onready var attack_windup_detection = $AttackWindupDetection
onready var sprite : Sprite = $Sprite
onready var state_machine : StateMachine = $StateMachine

var velocity : Vector2

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
	
	if direction == 1:
		$"AttackArea".direction = 0
	else:
		$"AttackArea".direction = 180
	
	# Connect Player and signals
	chased_player = $"../Player"
	
# debugging action
func _physics_process(delta):
	$Label.text = state_machine.state.name

func find_player():
	if direction == 1 and chased_player.position.x < position.x or direction == -1 and chased_player.position.x > position.x:
		flip_direction()

func windup_move(delta):
	move(windup_speed)

func patrol(delta):
	move(walk_speed)
	
func chase(delta):
	if floor_detection_raycast.is_colliding() and is_on_floor():
		move(running_speed)
	
func fall():
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func move(speed):
	# Turn automatically on cliffs 
	# _is_on_wall() cant't be used because of weird interactions with the player. Other solution
	if wall_detection_raycast.is_colliding() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	velocity.x = speed * direction
	fall()
	
func move_backwards(delta):
	# Turn automatically on cliffs and walls
	if is_on_wall() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	velocity.x = walk_speed * -direction
	fall()
	
func attack_move(delta, attack_chain) -> void:
	if not attack_chain: 
		velocity.x = attack_speed * direction
	else:
		velocity.x = running_speed * direction
	fall()
		
func flip_direction():
	direction = direction * -1
	sprite.flip_h = not sprite.flip_h
	attack_area.position.x = attack_area.position.x * -1
	attack_detection.rotation_degrees = attack_detection.rotation_degrees * -1
	attack_windup_detection.rotation_degrees = attack_windup_detection.rotation_degrees * -1
	floor_detection_raycast.position.x = floor_detection_raycast.position.x * -1
	wall_detection_raycast.rotation_degrees = wall_detection_raycast.rotation_degrees * -1
	if attack_area.direction == 0:
		attack_area.direction = 180
	else:
		attack_area.direction = 0


func knockback(delta, force, direction):
	velocity.x = force * direction
	fall()


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
