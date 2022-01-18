extends Node2D

export var attack_interval_min : float
export var attack_interval_max : float

var focused_player : Player = null setget set_focused_player, get_focused_player
var can_attack : bool = true

var _rng : RandomNumberGenerator

func _ready():
	_rng = RandomNumberGenerator.new()
	_set_up()


func set_can_attack(value : bool):
	can_attack = value


func set_focused_player(value):
	focused_player = value


func get_focused_player() -> Player:
	return focused_player


func switched_state(state_name):
	if ["Attack",  "AttackRun"].has(state_name):
		can_attack = false
		_rng.randomize()
		$AttackTimer.start(_rng.randf_range(attack_interval_min, attack_interval_max))


func on_died():
	queue_free()


func _set_up():
	$StateMachine.propagate_call("set_controlled_character", [$PuppetCharacter])
	$StateMachine.propagate_call("set_ai_controller", [self])
