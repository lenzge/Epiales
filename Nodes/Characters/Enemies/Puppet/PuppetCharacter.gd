class_name PuppetCharacter
extends Character

#Attack State
export var attack_area_path : NodePath
onready var attack_area : DamageEmitter = get_node(attack_area_path)


var is_winding_up : bool

func _ready():
	._ready()


func flip():
	.flip()
	attack_area.direction = Vector2(1, 0) if is_facing_right else Vector2(-1, 0)
	$HealthBar.rect_scale.x *= -1


func attack():
	if state_machine.state.has_method("on_attack"):
		state_machine.state.call("on_attack")


func _set_up():
	._set_up()
	for child in $StateMachine.get_children():
		if "character" in child:
			child.character = self
	$HealthBar.set_max_health(max_health)


func on_hit(emitter : DamageEmitter):
	.on_hit(emitter)
	$HealthBar.get_damage(emitter.damage_amount)
