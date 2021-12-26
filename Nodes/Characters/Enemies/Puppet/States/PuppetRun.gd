extends "res://Nodes/Characters/Enemies/States/Run.gd"


func on_attack():
	state_machine.transition_to("AttackWindUp")
