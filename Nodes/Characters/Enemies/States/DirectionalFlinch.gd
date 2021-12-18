extends "res://Nodes/Characters/Enemies/States/Flinch.gd"

var direction : Vector2

func enter(_msg := {}):
	.enter(_msg)
	character.can_die = false
	character.velocity = Vector2.ZERO
	direction = _msg.direction


func update(delta):
	character.move_and_slide(character.flinch_intensity * direction)
