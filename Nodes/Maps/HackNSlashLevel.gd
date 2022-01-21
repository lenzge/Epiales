class_name HackNSlashLevel
extends BaseLevel

export(NodePath) var player_spawn_path
var player_instance
var player_spawn : Vector2
var current_spawnpoint
var current_spawnpoint_prio = -1

# Enemy can connect to spawned player
signal player_spawned
signal level_reset

func _ready():
	propagate_call("set_level_instance", [self])
	if not player_spawn:
		player_spawn = get_node(player_spawn_path).position
		current_spawnpoint = player_spawn
	propagate_call("set_level_instance", [self])


func set_player_spawn(_player_spawn : Vector2) -> void:
	player_spawn = _player_spawn


func get_player_spawn() -> Vector2:
	return player_spawn


func spawn_player(player) -> void:
	player.position = player_spawn
	var camera = Camera2D.new()
	camera.current = true			#placeholder, to be determined how to implement
	player.add_child(camera)
	player_instance = player
	add_child(player)
	emit_signal("player_spawned")
	

func _on_Checkpoint_checkpoint_entered(new_spawnpoint: Vector2, prio: int) -> void:
	if new_spawnpoint.x > current_spawnpoint.x or prio > current_spawnpoint_prio:
		current_spawnpoint = new_spawnpoint
		current_spawnpoint_prio = prio

func reset():
	player_instance.position = current_spawnpoint
	player_instance.get_node("SoundMachine").play_sound("respawn", false)
	emit_signal("level_reset")
