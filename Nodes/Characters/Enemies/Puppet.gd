class_name Puppet
extends KinematicBody2D


export var walk_speed = 50
export var running_speed = 100
export var attack_speed = 200
export var max_walk_angle = 0.7
export var gravity = 100
export var snap_to_ground_val = 20.0
export var direction = 1
export var attack_time = 0.3


onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var player_detection_area : Area2D = $PlayerDetectionArea
onready var attack_detection_area = $AttackDetectionArea/CollisionShape2D
onready var attack_area  = $AttackArea/CollisionShape2D
onready var sprite : Sprite = $Sprite

signal hit(force, time, direction)

var velocity : Vector2
var chased_player : Player

func _ready() -> void:
	#attack_area.set_physics_process(false)
	if direction == 1:
		sprite.flip_h = true
	pos_raycast()
	chased_player = $"../../Player"
	if chased_player == null:
		print("no player found")
	self.connect("hit", chased_player, "on_hit")
	
func pos_raycast():
	floor_detection_raycast.position.x = $CollisionShape2D.shape.get_extents().x * direction

func patrol(delta):
	move(walk_speed)
	
func chase(delta):
	move(running_speed)

func move(speed):
	if is_on_wall() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	velocity.y += gravity
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)
	
func attack_move(delta, attack_chain) -> void:
	if not attack_chain: # If running
		velocity.x = attack_speed * direction
	else: # If not running: slow step foreward
		velocity.x = walk_speed * direction
	
	# Depending on game design Apply gravity here !!! If no gravity make sure that player is actually on floor and not 0.000000000001 above it
	# --> leads to issues with canceling windup states because player is falling
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity,Vector2.UP)
		
func flip_direction():
	direction = direction * -1
	sprite.flip_h = not sprite.flip_h
	pos_raycast()
	attack_area.position.x = attack_area.position.x * direction
	attack_detection_area.position.x = attack_detection_area.position.x * direction
	
func _physics_process(delta):
	$Label.text = $StateMachine.state.name


func _on_AttackArea_area_entered(area):
	pass # Replace with function body.


func _on_AttackArea_body_entered(body):
	var force = 300
	var time = 0.5
	emit_signal("hit", force, time, direction)
	
