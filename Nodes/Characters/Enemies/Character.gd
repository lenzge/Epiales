class_name Character
extends KinematicBody2D

#Character Physics
export var gravity : float = 100
export var air_drag : float = 0.5

export var health : float 
export var max_health : float

var state_machine
var hitbox : DamageReceiver
var animation : AnimationPlayer

var velocity : Vector2
var is_running : bool
var is_facing_right : bool = true setget set_is_facing_right
var can_die : bool = true

var _move_input : Vector2

func _ready():
	state_machine = $StateMachine
	hitbox = $HitBox
	animation = $AnimationPlayer


func _process(delta):
	if can_die && health <= 0.0:
			state_machine.transition_to("Die")


func move(value : Vector2):
	_move_input = value


func consume_move() -> Vector2:
	var val = _move_input
	_move_input = Vector2.ZERO
	return val


func set_invincable(invincable : bool):
	hitbox.set_disabled(!invincable)


func set_is_facing_right(value : bool):
	if value != is_facing_right:
		flip()


func flip():
	is_facing_right = !is_facing_right
	scale.x *= -1


func apply_air_drag(delta):
	velocity += velocity.normalized() * velocity.length_squared() * -air_drag * 0.01 * delta


func apply_air_drag_on_x(delta):
	velocity.x += velocity.x * velocity.x * -air_drag * 0.01 * delta


func apply_air_drag_on_y(delta):
	velocity.y += velocity.y * velocity.y * -air_drag * 0.01 * delta


func on_hit(emitter : DamageEmitter):
	var direction_x
	if is_equal_approx(emitter.direction.x, 0.0):
		direction_x = (hitbox.global_position - emitter.global_position).x 
	else:
		direction_x = emitter.direction.x
	state_machine.transition_to("Flinch", {"direction_x": -1.0 if direction_x < 0.0 else 1.0, "force": emitter.knockback_force})
