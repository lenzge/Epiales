extends Node

onready var player_spawn = get_node("Spawns/PlayerSpawn")
onready var enemy_spawns = $Spawns.get_children()
var enemy_spawn_positions = []

func _ready():
	enemy_spawns.remove(0)
	for spawn in enemy_spawns:
		enemy_spawn_positions.append(spawn.position)
	
func get_player_spawn() -> Vector2:
	return player_spawn.position

func get_enemy_spawns():
	return enemy_spawn_positions

