class_name StayAndLookAtPlayer
extends State

#Export
export var flip_delay : float
export var attack_range_close : float
export var max_y_difference : float
export var initial_delay : float
export var floor_detection_ray_path : NodePath
export var wall_detection_ray_path : NodePath

onready var _floor_detection_ray : RayCast2D = get_node(floor_detection_ray_path)
onready var _wall_detection_ray : RayCast2D = get_node(wall_detection_ray_path)
var _controlled_character : Character
var _ai_controller

var _focused_player : Player
var _flip_delay_timer : Timer
var _initial_delay_timer : Timer
var _is_initial_delay_over : bool
var _is_player_in_attack_range : bool
var _is_player_on_same_height : bool

func _ready():
	._ready()
	processing_mode = 1
	_initial_delay_timer = Timer.new()
	_initial_delay_timer.process_mode = 0
	_initial_delay_timer.one_shot = true
	_initial_delay_timer.connect("timeout", self, "set_initial_delay_over", [true])
	add_child(_initial_delay_timer)
	_flip_delay_timer = Timer.new()
	_flip_delay_timer.process_mode = 0
	_flip_delay_timer.one_shot = true
	add_child(_flip_delay_timer)
	yield(owner, "ready")
	_flip_delay_timer.connect("timeout", _controlled_character, "flip")


func enter(_msg := {}):
	_initial_delay_timer.start(initial_delay)
	_focused_player = _ai_controller.get_focused_player()


func physics_update(delta):
	var enemy_to_player = (_focused_player.global_position - _controlled_character.global_position)
	
	#Conditions
	var is_player_in_back = enemy_to_player.x < 0.0 == _controlled_character.is_facing_right
	_is_player_on_same_height = abs(enemy_to_player.y) < max_y_difference
	_is_player_in_attack_range = enemy_to_player.length() < attack_range_close
	
	#Check for attack
	if _is_player_in_attack_range and _is_player_on_same_height and not is_player_in_back and _ai_controller.can_attack and _controlled_character.state_machine.is_in_state(["Run","FocusedRun"]):
		_controlled_character.attack()
	
	#Flip when player in back
	if _controlled_character.state_machine.is_in_state(["Run","FocusedRun","Fall"]) and is_player_in_back:
		if _flip_delay_timer.is_stopped():
			_flip_delay_timer.start(flip_delay)
	else:
		_flip_delay_timer.stop()


func check_transitions(delta):
	if _is_initial_delay_over and _ai_controller.can_attack and !_is_player_in_attack_range and _controlled_character.state_machine.is_in_state(["Run","FocusedRun", "Fall"]) and _is_player_on_same_height and !_wall_detection_ray.is_colliding() and _floor_detection_ray.is_colliding():
		state_machine.transition_to("RunAttack")
	elif not _ai_controller.can_attack and _is_player_in_attack_range and _controlled_character.state_machine.is_in_state(["Run","FocusedRun", "Fall"]):
		state_machine.transition_to("RunAway")


func exit():
	_flip_delay_timer.stop()
	_initial_delay_timer.stop()


func set_initial_delay_over(value : bool):
	_is_initial_delay_over = value


func set_controlled_character(value : Character):
	_controlled_character = value


func set_ai_controller(value : Node):
	_ai_controller = value
