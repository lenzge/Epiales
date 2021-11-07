class_name Puppet
extends KinematicBody2D


export var walk_speed = 50
export var running_speed = 100
export var max_walk_angle = 0.7
export var gravity = 100
export var snap_to_ground_val = 20.0
export var direction = 1


onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var player_detection_area : Area2D = $PlayerDetectionArea
onready var attack_detection_area : Area2D = $AttackDetectionArea
onready var attack_area : Area2D = $AttackArea
onready var sprite : Sprite = $Sprite


var velocity : Vector2
var chased_player : Player

func _ready() -> void:
	#attack_area.set_physics_process(false)
	if direction == 1:
		sprite.flip_h = true
	pos_raycast()
	
	
func pos_raycast():
	floor_detection_raycast.position.x = $CollisionShape2D.shape.get_extents().x * direction

func move(delta):
	print("move")
	if is_on_wall() or not floor_detection_raycast.is_colliding() and is_on_floor():
		flip_direction()
	
	velocity.y += gravity
	velocity.x = walk_speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)
		
func flip_direction():
	direction = direction * -1
	sprite.flip_h = not sprite.flip_h
	pos_raycast()

