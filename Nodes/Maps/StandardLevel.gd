class_name Standard_Level
extends Node

export(NodePath) var player_spawn_path
var player_instance
var player_spawn : Vector2
var current_spawnpoint
var current_spawnpoint_prio = -1

func _ready():
	if not player_spawn:
		player_spawn = get_node(player_spawn_path).position
		current_spawnpoint = player_spawn


func set_player_spawn(_player_spawn : Vector2) -> void:
	player_spawn = _player_spawn


func get_player_spawn() -> Vector2:
	return player_spawn


func spawn_player(player) -> void:
	print(player_spawn)
	player.position = player_spawn
	var camera = Camera2D.new()
	camera.current = true			#placeholder, to be determined how to implement
	player.add_child(camera)
	player_instance = player
	add_child(player)

func _on_Checkoint_checkpoint_entered(new_spawnpoint: Vector2, prio: int) -> void:
	if new_spawnpoint.x > current_spawnpoint.x or prio > current_spawnpoint_prio:
		current_spawnpoint = new_spawnpoint
		current_spawnpoint_prio = prio

func _on_player_entered_deadzone():
	print("[DEBUG] @class",name ," current_spawnpoint: ",current_spawnpoint," of type Vector2: ",current_spawnpoint is Vector2)
	player_instance.position = current_spawnpoint