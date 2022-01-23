extends Area2D

func _on_EndField_body_entered(body):
	if body is Player:
		body.get_node("StateMachine").transition_to("Die")
