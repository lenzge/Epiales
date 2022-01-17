extends Transition

export var max_sight_range : float

var _level
var _controlled_character
var _ai_controller


func _check(delta):
	if _ai_controller.get_focused_player().global_position.distance_to(_controlled_character.global_position) < max_sight_range:
		var space_state = _level.get_world_2d().direct_space_state
		var result = space_state.intersect_ray(_controlled_character.global_position, _ai_controller.get_focused_player().global_position, [_controlled_character], 4)
		if result.empty():
			return {"transition_to": transition_to, "parameters": parameters}
	return {}


func set_controlled_character(character):
	_controlled_character = character


func set_ai_controller(controller):
	_ai_controller = controller


func set_level_instance(level):
	_level = level

