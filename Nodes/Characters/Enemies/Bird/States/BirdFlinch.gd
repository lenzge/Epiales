extends "res://Nodes/Characters/Enemies/States/Flinch.gd"

func _on_timeout():
	state_machine.transition_to("Fly")
