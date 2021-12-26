extends CharacterState

# depending on last state (windup or chase) attack chain is possible

export var max_attack_combo : int = 1
export var move_accel : float = 0.0
export var attack_area_path : NodePath
export(int, "GRAVITY", "CONSTANT") var fall_mode : int = 1
export var constant_fall_speed : float = 0
export var should_reset_y_velocity : bool = false
export(Array, float) var attack_force = [100.0]
export(Array, float) var attack_damage = [20.0]

onready var attack_area : DamageEmitter = get_node(attack_area_path)

var should_attack_again : bool
var attack_count : int


func _ready():
	processing_mode = 1


func enter(_msg := {}):
	.enter(_msg)
	should_attack_again = false
	attack_count = _msg.attack_count if _msg.has("attack_count") else 0
	character.attack_area.knockback_force = attack_force[attack_count % attack_force.count()]
	character.attack_area.damage = attack_damage[attack_count % attack_force.count()]
	if should_reset_y_velocity:
		character.velocity.y = 0.0
	if fall_mode == 1:
		character.velocity.y = constant_fall_speed


func physics_update(delta):
	.physics_update(delta)
	character.velocity.x += move_accel * delta
	if fall_mode == 0:
		character.velocity.y += character.gravity * delta
		character.apply_air_drag(delta)
	else:
		character.apply_air_drag_x(delta)
	character.velocity = character.move_and_slide(character.velocity, Vector2.UP)


func start_animation():
	.start_animation()
	character.animation.play("Attack" + str(attack_count))


func exit():
	.exit()
	character.attack_area.set_disabled(true)


func _on_timeout():
	if should_attack_again && max_attack_combo < attack_count:
		state_machine.transition_to("AttackWindUp", {"attack_count": attack_count + 1})
	else:
		state_machine.transition_to("AttackRecovery")


func on_attack():
	should_attack_again = true


func on_attack_has_been_blocked(receiver):
	if state_machine.state == self:
		state_machine.transition_to("Stunned")
