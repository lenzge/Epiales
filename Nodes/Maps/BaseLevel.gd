class_name Level
extends Node

export(NodePath) var player_spawn_path
var player_spawn : Vector2
var current_spawnpoint_prio = -1

func _ready():
	if not player_spawn:
		player_spawn = get_node(player_spawn_path).position


func set_player_spawn(_player_spawn : Vector2) -> void:
	player_spawn = _player_spawn


func get_player_spawn() -> Vector2:
	return player_spawn


func spawn_player(player : Player) -> void:
	print(player_spawn)
	player.position = player_spawn
	var camera = Camera2D.new()
	camera.current = true			#placeholder, to be determined how to implement
	player.add_child(camera)
	add_child(player)

func _on_Checkoint_checkoint_entered(new_spawnpoint: Vector2, prio: int) -> void:
	print("[DEBUG] ~ ",self.name," player_spawn on enter:", player_spawn, "prio: ", prio)
	if new_spawnpoint.x > player_spawn.x or prio > current_spawnpoint_prio:
		player_spawn = new_spawnpoint
		current_spawnpoint_prio = prio
	print("[DEBUG] ~ ",self.name," player_spawn after:", player_spawn)
