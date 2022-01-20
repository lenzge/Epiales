extends "res://Nodes/Characters/Enemies/States/AttackWindup.gd"

var _should_attack : bool

func _ready():
	processing_mode = 1
	yield(owner, "ready")
	assert("is_winding_up" in character)


func enter(_msg := {}):
	_should_attack = false


func on_attack():
	_should_attack = true


func _on_timeout():
	if _should_attack || !character.is_winding_up || _attack_count > 0:
		state_machine.transition_to("AttackRun")
	else:
		state_machine.transition_to("AttackRunRun")
