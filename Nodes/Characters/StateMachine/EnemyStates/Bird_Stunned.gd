extends "res://Nodes/Characters/StateMachine/EnemyStates/Stunned.gd"


func _on_timeout():
	state_machine.transition_to("Repatrol")
