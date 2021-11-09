class_name Puppet
extends KinematicBody2D


export var walk_speed = 50
export var running_speed = 100
export var attack_speed = 200
export var max_walk_angle = 0.7
export var gravity = 100
export var snap_to_ground_val = 20.0
export var direction = -1
export var attack_time = 0.3
export var recovery_time = 2
export var windup_time = 0.2
export(Array, int) var attack_force = [300, 300, 400]
export(Array, int) var attack_knockback = [0.4, 0.2, 0.4]
export var max_attack_combo = 2


onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var player_detection_area : Area2D = $PlayerDetectionArea
onready var attack_detection_area = $AttackDetectionArea/CollisionShape2D
onready var attack_area  = $AttackArea/CollisionShape2D
onready var attack_windup_detection_area = $AttackWindupDetectionArea/CollisionShape2D
onready var sprite : Sprite = $Sprite

signal hit_player(force, time, direction)

var velocity : Vector2
var chased_player : Player

func _ready() -> void:
	# Set everything in the right direction
	if direction == 1:
		sprite.flip_h = true
	attack_area.position.x = attack_area.position.x * direction
	attack_detection_area.position.x = attack_detection_area.position.x * direction
	attack_windup_detection_area.position.x = attack_windup_detection_area.position.x * direction
	pos_raycast()
	
	# Connect Player and signals
	chased_player = $"../../Player"
	self.connect("hit_player", chased_player, "on_hit")
	chased_player.connect("hit_enemy", self, "on_hit")
	
# debugging action
func _physics_process(delta):
	$Label.text = $StateMachine.state.name
	
func pos_raycast():
	floor_detection_raycast.position.x = $CollisionShape2D.shape.get_extents().x * direction

func patrol(delta):
	move(walk_speed)
	
func chase(delta):
	if direction == 1 and chased_player.position.x < position.x or direction == -1 and chased_player.position.x > position.x:
		flip_direction()
	move(running_speed)
	
func fall():
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func move(speed):
	# Turn automatically on cliffs and walls
	if is_on_wall() or not floor_detection_raycast.is_colliding() and is_on_floor():
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
	if not attack_chain: # If running
		velocity.x = attack_speed * direction
	else: # If not running: slow step foreward
		velocity.x = attack_speed * direction
	fall()
		
func flip_direction():
	direction = direction * -1
	sprite.flip_h = not sprite.flip_h
	pos_raycast()
	attack_area.position.x = attack_area.position.x * -1
	attack_detection_area.position.x = attack_detection_area.position.x * -1
	attack_windup_detection_area.position.x = attack_windup_detection_area.position.x * -1
	
func knockback(delta, force, direction):
	velocity.x = force * direction
	fall()

	
func on_hit(force, time, direction):
	$StateMachine.transition_to("Stunned", {"force" :force, "time": time, "direction": direction})
	
	
func on_attack_player(attack_count):
	emit_signal("hit_player",attack_force[attack_count], attack_knockback[attack_count], direction)
