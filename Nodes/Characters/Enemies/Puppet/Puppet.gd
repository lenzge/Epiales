extends Node2D

var focused_player : Player = null setget set_focused_player, get_focused_player
#var is_always_alarmed : bool


func _ready():
	_set_up()


func set_focused_player(value):
	focused_player = value


func get_focused_player() -> Player:
	return focused_player


func on_died():
	queue_free()


func _set_up():
	$StateMachine.propagate_call("set_controlled_character", [$PuppetCharacter])
	$StateMachine.propagate_call("set_ai_controller", [self])



