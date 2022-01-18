class_name Checkpoint
extends Area2D

signal _checkpoint_entered(spawnpoint, prio)

export var opt_spawn := NodePath()
export var prio : int = 0

var spawnpoint

func _ready():
	self.connect("body_entered", self , "_on_Self_area_entered")
	self.connect("_checkpoint_entered", owner, "_on_Checkpoint_checkpoint_entered")
	
	var opt_position = get_node(opt_spawn)
	if opt_position != null and opt_position is Position2D:
		spawnpoint = opt_position.position
	else:
		spawnpoint = self.position
	
func _on_Self_area_entered(entered_object):
	if entered_object.name == "Player": #better Check needed! check with "is Player"
		emit_signal("_checkpoint_entered",spawnpoint, prio)
