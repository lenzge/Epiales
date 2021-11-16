extends "res://Nodes/Characters/StateMachine/EnemyStates/Attack_Recovery.gd"


func physics_update(delta):
	enemy.move_backwards(delta)
