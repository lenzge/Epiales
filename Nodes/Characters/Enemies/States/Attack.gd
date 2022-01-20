extends CharacterState

# depending on last state (windup or chase) attack chain is possible

export(Array, String) var animations : Array
export var floor_detection_ray_path : NodePath
export var max_attack_combo : int = 1
export var move_accel : float = 0.0
export var attack_area_path : NodePath
export(int, "GRAVITY", "CONSTANT") var fall_mode : int = 1
export var constant_fall_speed : float = 0
export var should_reset_y_velocity : bool = false
export(Array, float) var attack_force = [100.0]
export(Array, int) var attack_damage = [20]

onready var attack_area : DamageEmitter = get_node(attack_area_path)
onready var _floor_detection_ray : RayCast2D = get_node(floor_detection_ray_path)

var _should_attack_again : bool
var _attack_count : int

func _ready():
	processing_mode = 1


func enter(_msg := {}):
	.enter(_msg)
	_floor_detection_ray.set_enabled(true)
	_should_attack_again = false
	_attack_count = _msg._attack_count if _msg.has("_attack_count") else 0
	character.attack_area.knockback_force = attack_force[_attack_count % attack_force.size()]
	character.attack_area.damage_amount = attack_damage[_attack_count % attack_force.size()]
	if should_reset_y_velocity:
		character.velocity.y = 0.0
	if fall_mode == 1:
		character.velocity.y = constant_fall_speed
	
	character.sound_machine.play_sound("Attack", false)


func physics_update(_delta):
	.physics_update(_delta)
	if fall_mode == 0:
		character.velocity.y += character.gravity * _delta
		character.apply_air_drag_on_y(_delta)
	else:
		character.apply_air_drag(_delta)
	character.velocity.x += move_accel * _delta * (1.0 if character.is_facing_right else -1.0)
	if !_floor_detection_ray.is_colliding():
		character.velocity.x = 0.0
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func start_animation():
	.start_animation()
	character.animation.play(animations[(_attack_count % animations.size())])


func exit():
	.exit()
	_floor_detection_ray.set_enabled(false)
	attack_area.set_deferred("monitorable", false) 


func _on_timeout():
	if _should_attack_again and _attack_count < max_attack_combo:
		state_machine.transition_to("AttackWindUp", {"_attack_count": _attack_count + 1})
	else:
		state_machine.transition_to("AttackRecovery")


func on_attack():
	_should_attack_again = true


func on_attack_has_been_blocked(receiver):
	if state_machine.state == self:
		state_machine.transition_to("Recoil")
