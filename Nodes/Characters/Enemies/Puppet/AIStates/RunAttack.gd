extends State

export (float, 0, 1) var move_speed : float
export var attack_range : float
export var max_attack_combo : int
export var floor_detection_ray_path : NodePath
export var wall_detection_ray_path : NodePath

onready var _floor_detection_ray : RayCast2D = get_node(floor_detection_ray_path)
onready var _wall_detection_ray : RayCast2D = get_node(wall_detection_ray_path)
var _controlled_character
var _direction_x : float
var _focused_player : Player
var _attack_count : int
var _ai_controller

func _ready():
	._ready()


func enter(_msg :={}):
	.enter(_msg)
	_controlled_character.is_running = true
	_controlled_character.state_machine.connect("transitioned", self, "on_swichted_state")
	_controlled_character.attack_area.connect("hit", self, "on_hit")
	_focused_player = _ai_controller.get_focused_player()
	_direction_x = 1.0 if _focused_player.global_position.x > _controlled_character.global_position.x else -1.0
	_controlled_character.is_winding_up = true
	_attack_count = 1


func physics_update(_delta):
	var enemy_to_player = (_focused_player.global_position - _controlled_character.global_position)
	
	var is_player_in_back = enemy_to_player.x < 0.0 == _controlled_character.is_facing_right
	var is_player_in_attack_range = enemy_to_player.length() < attack_range
	
	if is_player_in_back or is_player_in_attack_range or !_floor_detection_ray.is_colliding() or _wall_detection_ray.is_colliding():
		_controlled_character.is_winding_up = false
	else:
		_controlled_character.move(Vector2(_direction_x * move_speed, 0))


func exit():
	.exit()
	_controlled_character.is_running = false
	_controlled_character.is_winding_up = false
	_controlled_character.attack_area.disconnect("hit", self, "on_hit")
	_controlled_character.state_machine.disconnect("transitioned", self, "on_swichted_state")


func on_swichted_state(state_name):
	if not ["AttackRunRun", "AttackFall", "AttackRunWindUp", "AttackRun", "AttackRunRecovery"].has(state_name):
		state_machine.transition_to("StayAndLookAtPlayer")


func on_hit(receiver : DamageReceiver):
	if _attack_count < max_attack_combo:
		_controlled_character.attack()
		_attack_count += 1


func set_ai_controller(value):
	_ai_controller = value


func set_controlled_character(value : Character):
	_controlled_character = value
