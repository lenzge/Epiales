class_name CoralSailor
extends KinematicBody2D

enum AIState {
	PATROL,
	CHASE
}

enum State {
	AIR,
	WALKING
}

export var walk_speed = 20.0
export var running_speed = 30.0
export var max_walk_angle = 0.7
export var gravity = 98.0
export var snap_to_ground_val = 20.0

onready var current_ai_state = AIState.PATROL 
onready var current_state = State.AIR 
onready var floor_detection_raycast : RayCast2D = $FloorDetectionRaycast
onready var player_detection_area : Area2D = get_parent()

var is_running : bool
var move_y = 1.0

var velocity : Vector2

var chased_player : Node2D

func _ready():
	player_detection_area.connect("body_entered", self, "_on_player_detected")
	player_detection_area.connect("body_exited ", self, "_on_player_lost")


func _physics_process(delta) -> void:
	update_ai()
	
	match current_state:
		State.AIR:
			velocity.y += delta * gravity
			move_and_slide(Vector2(walk_speed, 0.0) * move_y + velocity, Vector2.UP, true, 4, max_walk_angle)
			if is_on_floor():
				velocity.y = 0;
				current_state = State.WALKING
		State.WALKING:
			move_and_slide_with_snap(Vector2(running_speed if is_running else walk_speed, 0.0) * move_y, Vector2(0.0, snap_to_ground_val), Vector2.UP, true, 4, max_walk_angle)
			if !is_on_floor():
				current_state = State.AIR


func update_ai() -> void:
	match current_ai_state:
		AIState.PATROL:
			var floor_angle = abs(floor_detection_raycast.get_collision_normal().angle_to(Vector2(1,0)) - PI / 2)
			if current_state == State.WALKING && (!floor_detection_raycast.is_colliding() || floor_angle > max_walk_angle || is_on_wall()):
				move_y *= -1.0
				floor_detection_raycast.transform.origin.x *= -1.0
		AIState.CHASE:
			var floor_angle = floor_detection_raycast.get_collision_normal().angle_to(Vector2(0,1))
			if !floor_detection_raycast.is_colliding() || floor_angle > max_walk_angle:
				move_y = 1.0 if chased_player.transform.origin.x - transform.origin.y < 0.0 else -1.0
			else: 
				move_y = 0


func _on_player_detected(body : Node):
	current_ai_state = AIState.CHASE
	chased_player = body
	is_running = true


func _on_player_lost(body : Node):
	current_ai_state = AIState.PATROL
	chased_player = null
	is_running = false
	move_y = 1.0 if move_y == 0.0 else move_y
