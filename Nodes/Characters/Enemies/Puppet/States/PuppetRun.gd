extends "res://Nodes/Characters/Enemies/States/Run.gd"


func _on_attack():
	state_machine.transition_to("AttackWindUp")
