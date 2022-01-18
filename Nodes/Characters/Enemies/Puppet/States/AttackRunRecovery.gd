extends "res://Nodes/Characters/Enemies/States/AttackRecovery.gd"

func _ready():
	._ready()
	yield(owner, "ready")
	assert("is_focused" in character)


func _on_timeout():
	if character.is_focused:
		state_machine.transition_to("FocusedRun")
	else:
		state_machine.transition_to("Run")
