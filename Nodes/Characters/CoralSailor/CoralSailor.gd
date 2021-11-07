class_name CoralSailor
extends KinematicBody2D

enum AIState {
	PATROL,
	CHASE
}

enum State {
	AIR,
	WALKING
	ATTACK
}

export var walk_speed = 20.0
export var running_speed = 30.0
export var max_walk_angle = 0.7
export var gravity = 98.0
export var snap_to_ground_val = 20.0

onready var current_ai_state = AIState.PATROL 
onready var current_state = State.AIR 
onready var floor_detection_raycast : RayCast2D = $Node2D/FloorDetectionRaycast
onready var player_detection_area : Area2D = get_parent()
onready var attack_detection_area : Area2D = $Node2D/AttackDetectionArea
onready var attack_area : Area2D = $Node2D/AttackArea
onready var attack_animation : AnimationPlayer = $Node2D/AttackArea/AttackAnimation

var is_running : bool
var is_attacking : bool
var move_y = 1.0

var velocity : Vector2

var chased_player : Node2D

func _ready() -> void:
	attack_area.set_physics_process(false)

func _physics_process(delta) -> void:
	update_ai()
	
	match current_state:
		State.AIR:
			velocity.y += delta * gravity
			move_and_slide(Vector2(walk_speed, 0.0) * move_y + velocity, Vector2.UP, true, 4, max_walk_angle)
			
			#test for transition
			if is_on_floor():
				velocity.y = 0;
				current_state = State.WALKING
		State.WALKING:
			move_and_slide_with_snap(Vector2(running_speed if is_running else walk_speed, 0.0) * move_y, Vector2(0.0, snap_to_ground_val), Vector2.UP, true, 4, max_walk_angle)
			
			#test for transition
			if !is_on_floor():
				current_state = State.AIR
			if is_attacking:
				current_state = State.ATTACK
		State.ATTACK:
			if !attack_animation.is_playing():
				if is_attacking:
					attack_animation.play("Attack", -1, 1.0, true)
					attack_animation.is_playing()
				else:
					current_state = State.WALKING


func update_ai() -> void:
	match current_ai_state:
		AIState.PATROL:
			var floor_angle = abs(floor_detection_raycast.get_collision_normal().angle_to(Vector2(1,0)) - PI / 2)
			
			if current_state == State.WALKING && (!floor_detection_raycast.is_colliding() || floor_angle > max_walk_angle || is_on_wall()):
				move_y *= -1.0
				floor_detection_raycast.transform.origin.x *= -1.0
			
			#test for transition
			attack_detection_area
			var detected_bodies = player_detection_area.get_overlapping_bodies()
			if detected_bodies.size():
				transition_ai_state_to(AIState.CHASE)
				chased_player = detected_bodies.front()
		AIState.CHASE:
			var floor_angle = floor_detection_raycast.get_collision_normal().angle_to(Vector2(0,1))
			if !floor_detection_raycast.is_colliding() || floor_angle > max_walk_angle:
				move_y = 1.0 if chased_player.transform.origin.x - transform.origin.y < 0.0 else -1.0
			else: 
				move_y = 0
			is_attacking = player_detection_area.get_overlapping_bodies().size() > 0
			
			#test for transition
			var detected_bodies = player_detection_area.get_overlapping_bodies()
			if !detected_bodies.size():
				transition_ai_state_to(AIState.PATROL)
				chased_player = null


func transition_ai_state_to(new_state) -> void:
	#exit previous ai state
	match current_ai_state:
		AIState.PATROL:
			pass
		AIState.Chase:
			is_attacking = false
			
	#enter new ai state
	match new_state:
		AIState.PATROL:
			is_running = false
			move_y = 1.0 if move_y == 0.0 else move_y
		AIState.Chase:
			is_running = true
	
	current_ai_state = new_state
