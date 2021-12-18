extends State

export (float, 0, 1) var move_speed : float

var controlled_character : Character

func physic_update(delta):
	var direction_x = 1 if controlled_character.is_facing_right else 1
	controlled_character.move(direction_x * move_speed)
