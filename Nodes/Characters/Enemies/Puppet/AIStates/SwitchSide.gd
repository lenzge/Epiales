extends State

export var move_speed : float

var _controlled_character : Character
var _ai_controller
var _focused_player : Player
var _direction_x

func enter(_msg := {}):
	processing_mode
	_controlled_character.is_running = true
	_focused_player = _ai_controller.get_focused_player()
	_direction_x = 1.0 if _focused_player.global_position.x > _controlled_character.global_position.x else -1.0


func physics_update(delta):
	if _focused_player.global_position.x < _controlled_character.global_position.x == _controlled_character.is_facing_right:
		_controlled_character.flip()
	_controlled_character.move(Vector2(_direction_x  * move_speed, 0))


func check_transitions(delta):
	if _ai_controller.can_attack:
		state_machine.transition_to("StayAndLookAtPlayer")


func set_ai_controller(value):
	_ai_controller = value


func set_controlled_character(value : Character):
	_controlled_character = value
