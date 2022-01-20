extends Transition

export var player_detection_area_path : NodePath

onready var player_detection_area : Area2D  = get_node(player_detection_area_path)

var _controlled_character : Character
var _ai_controller : Node2D
var _player : Player
var _level

func _ready():
	yield(owner, "ready")
	player_detection_area.connect("body_entered", self, "player_entered_detection_body")
	player_detection_area.connect("body_exited", self, "player_exited_detection_body")


func _check(delta):
	if _player != null:
		var space_state = _level.get_world_2d().direct_space_state
		var result = space_state.intersect_ray(_player.global_position, _controlled_character.global_position, [_controlled_character], 4)
		if result.empty():
			if _ai_controller.has_method("set_focused_player"):
				_ai_controller.set_focused_player(_player)
			_controlled_character.sound_machine.play_sound("Alert", false)
			return {"transition_to": transition_to,"parameters": parameters}
	return {}


func player_entered_detection_body(body):
	if body is Player:
		_player = body


func player_exited_detection_body(body):
	if body is Player:
		_player = null


func set_controlled_character(character):
	_controlled_character = character


func set_ai_controller(controller):
	_ai_controller = controller


func set_level_instance(level):
	_level = level
