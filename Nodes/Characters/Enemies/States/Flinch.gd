extends CharacterState

export var flinch_intensity : float = 100
export (float, 0, 1) var air_factor : float = 0
export var can_flinch_over_edge : bool = false 
export var _floor_detection_raycast_path : NodePath

var _floor_detection_raycast : RayCast2D

var _direction_x : float

func _ready():
	processing_mode = 1
	yield(owner, "ready")
	_floor_detection_raycast = get_node(_floor_detection_raycast_path)


func enter(_msg := {}):
	.enter(_msg)
	character.velocity = Vector2.ZERO
	_direction_x = _msg.direction_x


func start_animation():
	.start_animation()
	character.animation.play("Flinch")
	if character.is_facing_right && _direction_x > 0.0 || !character.is_facing_right && _direction_x < 0.0:
		character.flip()


func physics_update(delta):
	.update(delta)
	if not character.is_on_floor():
		character.move_and_slide(Vector2(flinch_intensity * _direction_x, 0.0) * air_factor, Vector2.UP)
	else:
		if _floor_detection_raycast.is_colliding() or can_flinch_over_edge:
			character.move_and_slide(Vector2(flinch_intensity * _direction_x, 1.0), Vector2.UP)


func exit():
	.exit()


func _on_timeout():
	state_machine.transition_to("Run")
