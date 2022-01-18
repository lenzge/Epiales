extends "res://Nodes/Characters/Enemies/States/Attack.gd"


func _on_timeout():
	if _should_attack_again and _attack_count < max_attack_combo:
		state_machine.transition_to("AttackRunWindUp", {"_attack_count": _attack_count + 1})
	else:
		state_machine.transition_to("AttackRunRecovery", {"_attack_count": _attack_count})
