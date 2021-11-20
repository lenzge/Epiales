extends "res://Nodes/Characters/EnemyStates/Attack_Windup.gd"

func _on_timeout():
	state_machine.transition_to("Drop_Attack")

