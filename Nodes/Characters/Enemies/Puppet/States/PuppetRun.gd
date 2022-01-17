extends "res://Nodes/Characters/Enemies/States/Run.gd"

func _ready():
	yield(owner, "ready")
	assert("is_winding_up" in character)


func check_transitions(_delta):
	.check_transitions(_delta)
	if character.is_winding_up:
		state_machine.transition_to("AttackWindUp")


func on_attack():
	state_machine.transition_to("AttackWindUp")
