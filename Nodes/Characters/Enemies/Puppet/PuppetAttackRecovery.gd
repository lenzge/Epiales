extends "res://Nodes/Characters/Enemies/States/AttackRecovery.gd"

func _on_timeout():
	if character.is_focused:
		state_machine.transition_to("FocusedRun")
	else:
		state_machine.transition_to("Run")
