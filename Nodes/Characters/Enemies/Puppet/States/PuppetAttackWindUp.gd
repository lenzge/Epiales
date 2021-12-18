extends "res://Nodes/Characters/Enemies/States/AttackWindup.gd"

var should_attack : bool

func _ready():
	yield(owner, "ready")
	assert("is_winding_up" in character)

func enter(_msg := {}):
	should_attack = false

func _on_attack():
	should_attack = true

func _on_timeout():
	if should_attack || !character.is_winding_up:
		state_machine.transition_to("Attack")
	else:
		state_machine.transition_to("AttackRun")
