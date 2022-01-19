extends CharacterState

export(Array, String) var animations : Array
export var floor_detection_ray_path : NodePath
export var move_accel : float
export(int, "GRAVITY", "CONSTANT") var fall_mode : int = 1
export var constant_fall_speed : float = 0
export var should_reset_y_velocity : bool = false

onready var _floor_detection_ray : RayCast2D = get_node(floor_detection_ray_path)
var _attack_count : int

func _ready():
	processing_mode = 1


func enter(_msg := {}):
	.enter(_msg)
	_attack_count = _msg.attack_count if _msg.has("attack_count") else 0
	_floor_detection_ray.set_enabled(true)
	if should_reset_y_velocity:
		character.velocity.y = 0.0
	if fall_mode == 1:
		character.velocity.y = constant_fall_speed
	character.can_die = false


func physics_update(_delta):
	if fall_mode == 0:
		character.velocity.y += character.gravity * _delta
		character.apply_air_drag_on_x(_delta)
	else:
		character.apply_air_drag(_delta)
	character.velocity.x += move_accel * _delta * (1.0 if character.is_facing_right else -1.0)
	if !_floor_detection_ray.is_colliding():
		character.velocity.x = 0.0
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func start_animation():
	.start_animation()
	character.animation.play(animations[(_attack_count % animations.size())])


func _on_timeout():
	state_machine.transition_to("Run")


func exit():
	_floor_detection_ray.set_enabled(false)
	character.can_die = true
