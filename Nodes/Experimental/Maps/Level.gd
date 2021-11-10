class_name Level
extends Node

export(NodePath) var player_spawn_path
var player_spawn : Position2D

func _ready():
	if not player_spawn:
		player_spawn = get_node(player_spawn_path)


func set_player_spawn(_player_spawn : Position2D) -> void:
	player_spawn = _player_spawn


func get_player_spawn() -> Position2D:
	return player_spawn


func spawn_player(player : Player) -> void:
	print(player_spawn)
	player.position = player_spawn.position
	var camera = Camera2D.new()
	camera.current = true			#placeholder, to be determined how to implement
	player.add_child(camera)
	add_child(player)
