extends "res://Nodes/Characters/Enemies/States/AttackRecovery.gd"


func _ready():
	._ready()
	assert("is_focused" in character)

func start_animation():
	.start_animation()
	character.animation.play("Attack_Run_Recovery")

func _on_timeout():
	if character.is_focused:
		state_machine.transition_to("Run")
	if character.is_focused:
		state_machine.transition_to("FocusedRun")
