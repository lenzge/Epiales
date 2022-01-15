extends State

export var floor_detection_ray_path : NodePath
export var wall_detection_ray_path : NodePath
export (float, 0, 1) var move_speed : float
export var min_distance : float
export var max_distance : float

onready var _floor_detection_ray : RayCast2D = get_node(floor_detection_ray_path)
onready var _wall_detection_ray : RayCast2D = get_node(wall_detection_ray_path)
var _controlled_character : Character
var _ai_controller
var _focused_player : Player
var _direction_x : float
var _distance : float
var _rng : RandomNumberGenerator

func _ready():
	._ready()
	_rng = RandomNumberGenerator.new()


func enter(_msg := {}):
	_controlled_character.is_running = true
	_rng.randomize()
	_distance = _rng.randf_range(min_distance, max_distance)
	_focused_player = _ai_controller.get_focused_player()
	_direction_x = -1.0 if _focused_player.global_position > _controlled_character.global_position else 1.0


func physics_update(delta):
	if _focused_player.global_position.x < _controlled_character.global_position.x == _controlled_character.is_facing_right:
		_controlled_character.flip()
		_direction_x = !_direction_x
	_controlled_character.move(Vector2(_direction_x  * move_speed, 0))


func check_transitions(delta):
	var ran_far_enough = (_focused_player.global_position - _controlled_character.global_position).length() > _distance
	if ran_far_enough or _ai_controller.can_attack:
		state_machine.transition_to("StayAndLookAtPlayer")
	elif !_floor_detection_ray.is_colliding() or _wall_detection_ray.is_colliding():
		state_machine.transition_to("SwitchSide")


func exit():
	_controlled_character.is_running = false


func set_controlled_character(value : Character):
	_controlled_character = value


func set_ai_controller(value):
	_ai_controller = value
